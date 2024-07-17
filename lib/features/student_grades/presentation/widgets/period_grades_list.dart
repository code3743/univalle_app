import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';

class PeriodGradesList extends StatelessWidget {
  const PeriodGradesList({
    super.key,
    required this.periods,
  });
  final List<String> periods;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> selectedPeriod = ValueNotifier<int>(0);
    return SizedBox(
      width: double.infinity,
      height: 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text('Periodos',
                style: TextStyle(
                    fontSize: 20,
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w500)),
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: periods.length,
              itemBuilder: (context, index) {
                return ValueListenableBuilder(
                    valueListenable: selectedPeriod,
                    builder: (_, value, __) {
                      return PeriodItem(
                        title: periods[index],
                        onTap: () {
                          selectedPeriod.value = index;
                        },
                        selected: value == index,
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PeriodItem extends StatelessWidget {
  const PeriodItem({
    super.key,
    required this.title,
    required this.selected,
    this.onTap,
  });
  final bool selected;
  final String title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Chip(
          label: Text(title),
          backgroundColor: selected ? AppColors.primaryBlue : AppColors.white,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          labelStyle: selected
              ? const TextStyle(color: Colors.white)
              : const TextStyle(color: AppColors.primaryBlue),
          shadowColor: AppColors.grey,
          elevation: 1,
        ),
      ),
    );
  }
}