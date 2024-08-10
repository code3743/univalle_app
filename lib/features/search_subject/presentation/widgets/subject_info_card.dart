import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';

class SubjectInfoCard extends StatelessWidget {
  const SubjectInfoCard({
    super.key,
    required this.subjectName,
    required this.subjectCode,
    required this.subjectCredits,
  });

  final String subjectName;
  final String subjectCode;
  final int subjectCredits;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: FractionallySizedBox(
        widthFactor: .85,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              width: double.infinity,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 50),
                  Expanded(
                    child: ListTile(
                      textColor: AppColors.white,
                      title: Text(
                        subjectName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '$subjectCode - Créditos: $subjectCredits',
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: SizedBox(
                height: 100,
                width: 60,
                child: Image.asset(
                  'assets/img/uv_ardilla.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
