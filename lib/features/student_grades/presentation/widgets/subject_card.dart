import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/features/student_grades/domain/entities/subject.dart';

class SubjectCard extends StatelessWidget {
  const SubjectCard({
    super.key,
    required this.subject,
  });
  final Subject subject;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(subject.credits.toString(),
          style: const TextStyle(
              color: AppColors.primaryBlue,
              fontSize: 20,
              fontWeight: FontWeight.w500)),
      trailing: subject.isCanceled
          ? const Icon(Icons.cancel, color: Colors.red)
          : Text(subject.grade.toString(),
              style: TextStyle(
                  color: subject.isEnabled
                      ? AppColors.blue
                      : subject.grade < 3
                          ? AppColors.orange
                          : AppColors.green,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
      textColor: AppColors.grey,
      title: Text(subject.name,
          style: const TextStyle(
            height: 1,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          )),
      subtitle: Text('${subject.code} -${subject.group}',
          style: const TextStyle(
            height: 1,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          )),
    );
  }
}
