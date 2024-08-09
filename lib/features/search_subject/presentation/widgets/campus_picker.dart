import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/providers/selected_campus_provider.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/features/search_subject/presentation/widgets/campus_picker_list.dart';

class CampusPicker extends StatelessWidget {
  const CampusPicker({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: .85,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          SizedBox(
            height: 60,
            child: Center(
              child: Consumer(builder: (context, ref, _) {
                return ListTile(
                  iconColor: AppColors.primaryBlue,
                  textColor: AppColors.primaryBlue,
                  leading: const Icon(
                    Icons.location_on,
                  ),
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          return const CampusPickerList();
                        });
                  },
                  trailing: const Icon(
                    Icons.arrow_drop_down,
                  ),
                  title: Text(
                    ref.watch(selectedCampusProvider),
                    style: const TextStyle(fontSize: 16, height: 1.1),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textScaler: TextScaler.noScaling,
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
