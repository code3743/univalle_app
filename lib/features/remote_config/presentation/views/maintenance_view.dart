import 'package:flutter/material.dart';

import '../../domain/entities/app_config.dart';
import '../../remote_config_strings.dart';
import '../widgets/blocking_message_view.dart';

class MaintenanceView extends StatelessWidget {
  const MaintenanceView({super.key, required this.maintenance});

  final MaintenanceStatus maintenance;

  @override
  Widget build(BuildContext context) {
    return BlockingMessageView(
      icon: Icons.build_circle_outlined,
      title: maintenance.title.isNotEmpty
          ? maintenance.title
          : RemoteConfigStrings.maintenanceTitleFallback,
      message: maintenance.message.isNotEmpty
          ? maintenance.message
          : RemoteConfigStrings.maintenanceMessageFallback,
    );
  }
}
