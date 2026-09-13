abstract final class TeachingRatingStrings {
  static const title = 'Calificación Docente';
  static const banner =
      'Evaluar a los docentes nos ayuda a mejorar la calidad educativa.';
  static const empty = 'No tienes docentes pendientes por calificar.';
  static const unavailable = 'No pudimos obtener los docentes por calificar.';
  static const reviewUnavailable = 'No se pudo iniciar la evaluación.';
  static const surveyNotConfigured =
      'No hay una encuesta configurada para esta materia.';

  static const alreadyQualified = 'El docente ya ha sido calificado.';
  static const previousLabel = 'Anterior';
  static const submitLabel = 'Enviar';

  static const feedbackTitle = '¡Gracias por completar el cuestionario!';
  static const feedbackSubtitle =
      'Antes de enviarlo, nos gustaría conocer tu opinión. Tu '
      'retroalimentación sobre la materia es muy importante para nosotros.';
  static const feedbackHint =
      '¿Qué tan satisfecho estás con la materia que estás evaluando?';

  static const submitSuccess = 'Calificación enviada correctamente.';

  static String questionCounter(int current, int total) =>
      'Pregunta $current de $total';
}
