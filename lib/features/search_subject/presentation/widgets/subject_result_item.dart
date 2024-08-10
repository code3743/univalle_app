import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/features/search_subject/domain/entities/subject_result.dart';

class SubjectResultItem extends StatelessWidget {
  const SubjectResultItem({
    super.key,
    required this.subjectResult,
  });

  final SubjectResult subjectResult;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        widthFactor: .9,
        child: Container(
          height: 150,
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  subjectResult.isGeneric
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('Genérico',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.white,
                                  fontSize: 12),
                              textScaler: TextScaler.noScaling),
                        )
                      : const SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryBlue,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0)),
                        ),
                        child: Text('Gr. ${subjectResult.group}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                                fontSize: 14),
                            textScaler: TextScaler.noScaling),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryRed,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10.0),
                              topRight: Radius.circular(10.0)),
                        ),
                        child: Text(subjectResult.program,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                                fontSize: 14),
                            textScaler: TextScaler.noScaling),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.person_rounded),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Text(subjectResult.teacher,
                          style: const TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textScaler: TextScaler.noScaling)),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.email_rounded),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(subjectResult.teacherEmail,
                        style: const TextStyle(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textScaler: TextScaler.noScaling),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.schedule_rounded),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(subjectResult.schedule,
                        style: const TextStyle(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textScaler: TextScaler.noScaling),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.people_rounded),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('${subjectResult.capacity} Cupos',
                        style: const TextStyle(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textScaler: TextScaler.noScaling),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
