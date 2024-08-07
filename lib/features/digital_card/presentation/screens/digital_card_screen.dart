import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/config/providers/student_use_cases_provider.dart';
import 'package:univalle_app/features/digital_card/presentation/widgets/student_card.dart';

class DigitalCardScreen extends StatelessWidget {
  const DigitalCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      color: AppColors.primaryRed,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      color: AppColors.white,
                    ),
                  )
                ],
              ),
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(height: size.height * .5 - 60 - (565 * .5)),
                  ),
                  Consumer(builder: (_, ref, __) {
                    return SliverToBoxAdapter(
                      child: StudentCard(
                        student: ref.read(studentUseCasesProvider).getStudent(),
                        width: size.width * .9,
                      ),
                    );
                  })
                ],
              )
            ],
          ),
        ));
  }
}
