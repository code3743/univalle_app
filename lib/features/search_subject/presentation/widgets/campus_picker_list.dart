import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/providers/selected_campus_provider.dart';
import 'package:univalle_app/config/themes/app_colors.dart';

class CampusPickerList extends StatelessWidget {
  const CampusPickerList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Consumer(builder: (context, ref, _) {
        final selectedNotifier = ref.read(selectedCampusProvider.notifier);
        return ListView.builder(
            itemCount: selectedNotifier.campusName.length,
            itemBuilder: (context, index) {
              return ListTile(
                textColor: AppColors.grey,
                selectedColor: AppColors.primaryBlue,
                leading: selectedNotifier.isCampusSelected(index)
                    ? const Icon(Icons.location_on)
                    : const Icon(Icons.location_on_outlined),
                title: Text(
                  selectedNotifier.campusName[index],
                ),
                selected: selectedNotifier.isCampusSelected(index),
                onTap: () {
                  selectedNotifier.changeCampus(index);
                  Navigator.of(context).pop();
                },
              );
            });
      }),
    );
  }
}
