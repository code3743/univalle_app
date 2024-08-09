import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/features/search_subject/presentation/widgets/campus_picker.dart';
import 'package:univalle_app/features/search_subject/presentation/widgets/search_bar_widget.dart';

class SubjectSearchBar extends StatelessWidget {
  const SubjectSearchBar({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(35),
              bottomRight: Radius.circular(35),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withOpacity(.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const CampusPicker(),
        ),
        Container(
          height: 80,
          width: double.infinity,
          margin: EdgeInsets.zero,
          decoration: const BoxDecoration(
            color: AppColors.primaryRed,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(35),
              bottomRight: Radius.circular(35),
            ),
          ),
          child: const SearchBarWidget(),
        ),
      ],
    );
  }
}
