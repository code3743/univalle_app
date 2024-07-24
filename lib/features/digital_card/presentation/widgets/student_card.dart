import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/core/common/widgets/profile_picture.dart';
import 'package:univalle_app/core/constants/campus_id.dart';
import 'package:univalle_app/core/domain/entities/student.dart';
import 'package:univalle_app/core/utils/capitalize.dart';
import 'package:univalle_app/features/digital_card/presentation/widgets/item_card.dart';

class StudentCard extends StatelessWidget {
  const StudentCard({
    super.key,
    required this.width,
    required this.student,
  });

  final double width;
  final Student student;

  String _generateQrData() {
    return '${student.studentId} ${student.fristName.capitalize()} ${student.lastName} ${student.documentId}';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 565,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 65,
            child: Container(
              width: width,
              height: 500,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(.1),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 70,
                  ),
                  Text(student.fristName.capitalize(),
                      style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1)),
                  Text(student.lastName.capitalize(),
                      style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Divider(
                      color: AppColors.primaryRed,
                      thickness: 4,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 120,
                        width: width * .45,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ItemCard(title: 'Código', value: student.studentId),
                            ItemCard(
                                title: 'Documento', value: student.documentId),
                            ItemCard(
                                title: 'Sede',
                                value: CampusId.getCampus(student.campus)),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width * .4,
                        height: 110,
                        child: BarcodeWidget(
                            data: _generateQrData(), barcode: Barcode.qrCode()),
                      )
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Divider(
                      color: AppColors.primaryRed,
                      thickness: 4,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      student.programName.capitalize(),
                      style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'El presente carné es personal e intransferible. Se exigirá en todas las oportunidades y servicios en que se deba acreditar la condición de estudiante.',
                      style: TextStyle(
                          color: AppColors.black, fontSize: 12, height: 1),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    child: BarcodeWidget(
                      barcode: Barcode.code128(escapes: true),
                      data: student.studentId,
                      width: width * .8,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
          const Positioned(
            top: 0,
            child: ProfilePicture(
              isEditable: false,
            ),
          )
        ],
      ),
    );
  }
}
