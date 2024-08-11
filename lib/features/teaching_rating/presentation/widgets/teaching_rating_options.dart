import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/questions_subject.dart';

class TeachingRatingOptions extends StatelessWidget {
  const TeachingRatingOptions({
    super.key,
    required this.rating,
    required this.onRating,
    required this.onChanged,
  });

  final Rating? rating;
  final void Function() onRating;
  final ValueChanged<Rating?> onChanged;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<Rating?> selectedRating = ValueNotifier(rating);
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: Rating.values.length,
      itemBuilder: (context, i) {
        final rating = Rating.values[i];
        return ValueListenableBuilder(
            valueListenable: selectedRating,
            builder: (_, value, __) {
              return RadioListTile<Rating>(
                value: rating,
                activeColor: AppColors.primaryBlue,
                groupValue: value,
                onChanged: (value) {
                  selectedRating.value = value;
                  onChanged(value);
                  onRating();
                },
                contentPadding: const EdgeInsets.all(0),
                title: Text('$rating',
                    textScaler: TextScaler.noScaling,
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w500)),
              );
            });
      },
    );
  }
}
