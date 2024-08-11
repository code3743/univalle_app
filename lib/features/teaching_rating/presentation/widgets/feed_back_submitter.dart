import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';

class FeedbackSubmitter extends StatelessWidget {
  const FeedbackSubmitter({
    super.key,
    required this.onFeedback,
  });

  final ValueChanged<String> onFeedback;

  @override
  Widget build(BuildContext context) {
    final feedbackTextController = TextEditingController();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(height: 25),
        const Text('¡Gracias por completar el cuestionario!',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue),
            textScaler: TextScaler.noScaling),
        const Text(
            'Antes de enviarlo, nos gustaría conocer tu opinión. Tu retroalimentación sobre la materia es muy importante para nosotros.',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryBlue),
            textAlign: TextAlign.center,
            textScaler: TextScaler.noScaling),
        const SizedBox(height: 10),
        TextField(
            maxLines: 10,
            controller: feedbackTextController,
            decoration: InputDecoration(
              hintText:
                  '¿Qué tan satisfecho estás con la materia que estás evaluando?',
              fillColor: AppColors.lightGrey.withOpacity(.2),
              filled: true,
              focusColor: AppColors.primaryBlue,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      color: AppColors.primaryBlue, width: 1.5)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      color: AppColors.primaryBlue, width: 1.5)),
            )),
        const SizedBox(height: 10),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            onPressed: () {
              onFeedback(feedbackTextController.text);
            },
            child: const Text('Enviar',
                textScaler: TextScaler.noScaling,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white))),
      ],
    );
  }
}
