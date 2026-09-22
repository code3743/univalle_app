import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/constants/asset_paths.dart';
import 'package:univalle_app/core/theme/app_colors.dart';
import 'package:univalle_app/features/remote_config/presentation/utils/module_style.dart';

void main() {
  group('moduleIconAsset', () {
    test('resolves a known backend icon name to its local asset', () {
      expect(moduleIconAsset('notebook-text'), AssetPaths.iconNotebook);
    });

    test('falls back to a generic asset for an unknown name', () {
      expect(moduleIconAsset('some-future-icon'), AssetPaths.iconLink);
    });
  });

  group('moduleColor', () {
    test('parses a valid #RRGGBB hex string', () {
      expect(moduleColor('#2563EB'), const Color(0xFF2563EB));
    });

    test('falls back to univalleRed for a malformed value', () {
      expect(moduleColor('not-a-color'), AppColors.univalleRed);
    });

    test('falls back to univalleRed for an empty string', () {
      expect(moduleColor(''), AppColors.univalleRed);
    });
  });
}
