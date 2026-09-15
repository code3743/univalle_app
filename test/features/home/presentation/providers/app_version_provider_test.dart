import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:univalle_app/features/home/presentation/providers/app_version_provider.dart';

import '../../../../helpers/container.dart';

void main() {
  setUp(() {
    PackageInfo.setMockInitialValues(
      appName: 'Univalle App',
      packageName: 'co.edu.univalle.univalle_app',
      version: '1.2.3',
      buildNumber: '7',
      buildSignature: '',
    );
  });

  test('reads the version reported by the platform', () async {
    final container = createContainer();

    final version = await container.read(appVersionProvider.future);

    expect(version, '1.2.3');
  });
}
