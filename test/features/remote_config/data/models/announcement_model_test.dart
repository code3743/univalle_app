import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/remote_config/data/models/announcement_model.dart';

void main() {
  test('fromJson parses a nullable imageUrl', () {
    final model = AnnouncementModel.fromJson({
      'id': 1,
      'title': 'Título',
      'description': 'Descripción',
      'imageUrl': null,
    });

    expect(model.id, 1);
    expect(model.imageUrl, isNull);
    expect(model.toEntity().title, 'Título');
  });

  test('AnnouncementsPageModel.fromJson parses the paginated envelope', () {
    final json = jsonDecode(
      File('test/fixtures/remote_config/announcements_page.json')
          .readAsStringSync(),
    ) as Map<String, dynamic>;

    final page = AnnouncementsPageModel.fromJson(json);

    expect(page.items, hasLength(2));
    expect(page.page, 1);
    expect(page.limit, 20);
    expect(page.total, 2);
    expect(page.toEntity().hasMore, isFalse);
  });
}
