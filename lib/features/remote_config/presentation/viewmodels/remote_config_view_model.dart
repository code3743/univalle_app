import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/device/app_platform_provider.dart';
import '../../../../core/device/app_version_provider.dart';
import '../../domain/entities/app_config.dart';
import '../providers/remote_config_providers.dart';

part 'remote_config_view_model.g.dart';

@Riverpod(keepAlive: true)
class RemoteConfigViewModel extends _$RemoteConfigViewModel {
  @override
  Future<AppConfig?> build() async {
    final platform = ref.watch(appPlatformProvider);
    final version = await ref.watch(appVersionProvider.future);
    final result = await ref
        .read(getAppConfigUseCaseProvider)
        .call(platform: platform, version: version);

    // Fail-open, unlike every other viewmodel in this app: the backend must
    // never be able to lock people out, so a Failure resolves to `null`
    // ("no server config, fall back to local defaults") instead of being
    // rethrown for AsyncValueWidget/AppErrorView to render.
    return result.fold(onError: (_) => null, onSuccess: (config) => config);
  }
}
