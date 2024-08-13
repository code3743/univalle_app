import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/questions_subject.dart';
import 'package:univalle_app/features/teaching_rating/presentation/widgets/feed_back_submitter.dart';
import 'package:univalle_app/features/teaching_rating/presentation/widgets/teaching_rating_options.dart';

class TeachingQuestions extends StatefulWidget {
  const TeachingQuestions(
      {super.key,
      required this.questions,
      required this.onPageChanged,
      required this.onFeedback});
  final List<QuestionsSubject> questions;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<String> onFeedback;
  @override
  State<TeachingQuestions> createState() => _TeachingQuestionsState();
}

class _TeachingQuestionsState extends State<TeachingQuestions> {
  final controller = PageController(initialPage: 0);
  final feedbackTextController = TextEditingController();

  @override
  void initState() {
    controller.addListener(() {
      final page = controller.page!.round() + 1;
      if (page > widget.questions.length) return;
      widget.onPageChanged(page);
    });
    super.initState();
  }

  @override
  void dispose() {
    feedbackTextController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (index == widget.questions.length) {
          return FeedbackSubmitter(
            feedbackTextController: feedbackTextController,
            onFeedback: (feedback) {
              widget.onFeedback(feedback);
            },
          );
        }
        return Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.questions[index].question.trim(),
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue),
                textScaler: TextScaler.noScaling),
          ),
          const Spacer(),
          TeachingRatingOptions(
              rating: widget.questions[index].rating,
              onChanged: (rating) {
                widget.questions[index].rating = rating;
              },
              onRating: () {
                Future.delayed(const Duration(milliseconds: 300), () {
                  controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                });
              }),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              onPressed: index == 0
                  ? null
                  : () {
                      controller.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    },
              child: const Text('Anterior',
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white))),
        ]);
      },
      itemCount: widget.questions.length + 1,
    );
  }
}
