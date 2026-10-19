import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

/// Records launched URLs instead of opening them. Call [install] once per
/// test; the real platform is restored automatically afterwards.
class FakeUrlLauncher extends UrlLauncherPlatform {
  FakeUrlLauncher({this.canOpen = true});

  final bool canOpen;
  final launched = <String>[];

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> canLaunch(String url) async => canOpen;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launched.add(url);
    return canOpen;
  }

  static FakeUrlLauncher install({bool canOpen = true}) {
    final original = UrlLauncherPlatform.instance;
    final fake = FakeUrlLauncher(canOpen: canOpen);
    UrlLauncherPlatform.instance = fake;
    addTearDown(() => UrlLauncherPlatform.instance = original);
    return fake;
  }
}
