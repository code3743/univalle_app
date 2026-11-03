import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

final _importPattern = RegExp(
  r'''^import\s+['"]([^'"]+)['"]''',
  multiLine: true,
);

class _Import {
  _Import(this.file, this.raw, this.resolved);

  final String file;
  final String raw;
  final String resolved;
}

List<File> _dartFiles(String dir) =>
    Directory(dir)
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart') && !f.path.endsWith('.g.dart'))
        .toList();

List<_Import> _importsOf(File file) {
  final source = file.readAsStringSync();
  return _importPattern.allMatches(source).map((m) {
    final raw = m.group(1)!;
    final resolved = raw.startsWith('package:univalle_app/')
        ? p.join('lib', raw.substring('package:univalle_app/'.length))
        : raw.startsWith('package:') || raw.startsWith('dart:')
        ? raw
        : p.normalize(p.join(p.dirname(file.path), raw));
    return _Import(file.path, raw, resolved);
  }).toList();
}

String? _featureOf(String path) {
  final parts = p.split(path);
  final i = parts.indexOf('features');
  return i >= 0 && i + 1 < parts.length ? parts[i + 1] : null;
}

String? _layerOf(String path) {
  final parts = p.split(path);
  final i = parts.indexOf('features');
  return i >= 0 && i + 2 < parts.length ? parts[i + 2] : null;
}

void _expectNoViolations(List<String> violations) {
  expect(violations, isEmpty, reason: violations.join('\n'));
}

void main() {
  final libFiles = _dartFiles('lib');
  final featureFiles = libFiles
      .where((f) => p.split(f.path).contains('features'))
      .toList();

  test('domain layer is pure Dart and never imports data or di', () {
    final violations = <String>[];
    final domainFiles = libFiles.where((f) {
      final path = f.path;
      return _layerOf(path) == 'domain' ||
          path.startsWith(p.join('lib', 'core', 'domain'));
    });
    for (final file in domainFiles) {
      for (final i in _importsOf(file)) {
        final bad =
            i.resolved.startsWith('package:flutter/') ||
            i.resolved.startsWith('package:dio/') ||
            i.resolved.startsWith('package:html/') ||
            i.resolved.startsWith('package:flutter_riverpod/') ||
            p.split(i.resolved).contains('data') ||
            p.split(i.resolved).contains('di') ||
            p.split(i.resolved).contains('presentation');
        if (bad) violations.add('${i.file} imports ${i.raw}');
      }
    }
    _expectNoViolations(violations);
  });

  test('presentation never imports data or http/html packages', () {
    final violations = <String>[];
    for (final file in featureFiles.where(
      (f) => _layerOf(f.path) == 'presentation',
    )) {
      for (final i in _importsOf(file)) {
        final parts = p.split(i.resolved);
        final bad =
            parts.contains('data') ||
            i.resolved.startsWith('package:dio/') ||
            i.resolved.startsWith('package:html/');
        if (bad) violations.add('${i.file} imports ${i.raw}');
      }
    }
    _expectNoViolations(violations);
  });

  test('features never import another feature data or domain', () {
    final violations = <String>[];
    for (final file in featureFiles) {
      final own = _featureOf(file.path);
      for (final i in _importsOf(file)) {
        final other = _featureOf(i.resolved);
        if (other == null || other == own) continue;
        final layer = _layerOf(i.resolved);
        if (layer == 'data' || layer == 'domain') {
          violations.add('${i.file} imports ${i.raw}');
        }
      }
    }
    _expectNoViolations(violations);
  });

  test('di layer is only imported from its own feature presentation', () {
    final violations = <String>[];
    for (final file in featureFiles) {
      final own = _featureOf(file.path);
      for (final i in _importsOf(file)) {
        if (_layerOf(i.resolved) != 'di') continue;
        final other = _featureOf(i.resolved);
        if (other != own && _layerOf(file.path) != 'di') {
          violations.add('${i.file} imports ${i.raw}');
        }
      }
    }
    _expectNoViolations(violations);
  });

  test('core never imports features (except the router)', () {
    final violations = <String>[];
    final allowed = p.join('lib', 'core', 'router', 'app_router.dart');
    final coreFiles = libFiles.where(
      (f) => f.path.startsWith(p.join('lib', 'core')) && f.path != allowed,
    );
    for (final file in coreFiles) {
      for (final i in _importsOf(file)) {
        if (p.split(i.resolved).contains('features')) {
          violations.add('${i.file} imports ${i.raw}');
        }
      }
    }
    _expectNoViolations(violations);
  });

  test('view models never depend on Flutter UI or navigation', () {
    final violations = <String>[];
    for (final file in libFiles.where(
      (f) => p.basename(p.dirname(f.path)) == 'viewmodels',
    )) {
      for (final i in _importsOf(file)) {
        if (i.resolved.startsWith('package:flutter/') ||
            i.resolved.startsWith('package:go_router/')) {
          violations.add('${i.file} imports ${i.raw}');
        }
      }
    }
    _expectNoViolations(violations);
  });

  test('color literals only live in app_colors.dart', () {
    final violations = <String>[];
    final allowed = p.join('lib', 'core', 'theme', 'app_colors.dart');
    for (final file in libFiles.where((f) => f.path != allowed)) {
      if (RegExp(r'\bColor\(0x').hasMatch(file.readAsStringSync())) {
        violations.add(file.path);
      }
    }
    _expectNoViolations(violations);
  });

  test('views do not hardcode user-facing copy', () {
    final violations = <String>[];
    final literalText = RegExp(r'''Text\(\s*(?:const\s+)?['"]([^'"]*)['"]''');
    final interpolation = RegExp(r'\$\{[^}]*\}|\$\w+');
    final words = RegExp(r'[A-Za-zÁ-ú]{3}');
    for (final file in featureFiles.where(
      (f) =>
          p.split(f.path).contains('views') ||
          p.split(f.path).contains('widgets'),
    )) {
      final source = file.readAsStringSync();
      for (final m in literalText.allMatches(source)) {
        final literal = m.group(1)!.replaceAll(interpolation, '');
        if (words.hasMatch(literal)) violations.add(file.path);
      }
    }
    _expectNoViolations(violations);
  });
}
