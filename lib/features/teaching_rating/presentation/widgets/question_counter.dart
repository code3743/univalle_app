import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/questions_subject.dart';

class QuestionCounter extends StatelessWidget {
  const QuestionCounter({
    super.key,
    required this.currentQuestion,
    required this.questions,
  });

  final ValueNotifier<int> currentQuestion;
  final List<QuestionsSubject> questions;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: currentQuestion,
        builder: (_, value, __) {
          return Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Text('Pregunta $value de ${questions.length}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white),
                    textAlign: TextAlign.left,
                    textScaler: TextScaler.noScaling),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: value / questions.length,
                backgroundColor: AppColors.white.withOpacity(.2),
                borderRadius: BorderRadius.circular(20),
                minHeight: 10,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: Text('Categoria: ${questions[value - 1].category}',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white),
                    textAlign: TextAlign.left,
                    textScaler: TextScaler.noScaling),
              ),
            ],
          );
        });
  }
}
