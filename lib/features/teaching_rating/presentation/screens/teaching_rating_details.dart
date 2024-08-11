import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/core/utils/capitalize.dart';
import 'package:univalle_app/features/teaching_rating/presentation/providers/teaching_rating_provider.dart';
import 'package:univalle_app/features/teaching_rating/presentation/widgets/question_counter.dart';
import 'package:univalle_app/features/teaching_rating/presentation/widgets/teaching_questions.dart';

class TeachingRatingDetails extends StatelessWidget {
  const TeachingRatingDetails({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    final sendingFeedback = ValueNotifier(false);
    return Scaffold(
      backgroundColor: AppColors.primaryRed,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: FractionallySizedBox(
            widthFactor: .9,
            child: Consumer(builder: (context, ref, _) {
              final teachingProvider =
                  ref.read(teachingRatingProvider.notifier);

              return FutureBuilder(
                  future: teachingProvider.getReviewSubject(index),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.hasError) {
                      //TODO: loading
                      return const Center(child: CircularProgressIndicator());
                    }

                    final review = snapshot.data!;
                    final questions = review.questions;
                    final currentQuestion = ValueNotifier(1);

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          review.teacherName.capitalize(),
                          style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 20,
                              height: 1.1,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          review.subjectName.capitalize(),
                          style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 20),
                        QuestionCounter(
                            currentQuestion: currentQuestion,
                            questions: questions),
                        const SizedBox(height: 20),
                        ValueListenableBuilder(
                            valueListenable: sendingFeedback,
                            builder: (context, value, _) {
                              return Container(
                                  height: 500,
                                  padding: const EdgeInsets.all(10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: value
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : TeachingQuestions(
                                          questions: questions,
                                          onFeedback: (feedback) async {
                                            sendingFeedback.value = true;
                                            review.feedback = feedback;
                                            await teachingProvider
                                                .setRating(review);
                                            sendingFeedback.value = false;
                                          },
                                          onPageChanged: (page) {
                                            currentQuestion.value = page;
                                          }));
                            }),
                      ],
                    );
                  });
            }),
          ),
        ),
      ),
    );
  }
}
