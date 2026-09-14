abstract final class ResolutionStrings {
  static const curriculumUnavailable =
      'No pudimos obtener la resolución de tu programa.';

  static const title = 'Resolución';
  static const empty = 'Aún no hay información de la resolución disponible.';
  static const subjectsCountLabel = 'Asignaturas';
  static const totalCreditsLabel = 'Créd. Totales';
  static const creditsUnit = 'créditos';
  static const prerequisitesSectionTitle = 'PRERREQUISITOS';
  static const unlocksSectionTitle = 'DESBLOQUEA';
  static const noPrerequisites =
      'Sin prerrequisitos: puedes cursarla en su semestre sin depender de otra.';
  static const noUnlocks = 'Ninguna asignatura depende de esta.';

  static const subjectAreaElective = 'Electiva';
  static const subjectAreaProfessional = 'Formación profesional';
  static const subjectAreaBasic = 'Formación básica';
  static const subjectAreaOther = 'Otra';

  static String semesterTitle(int semester) =>
      'Semestre ${semester.toString().padLeft(2, '0')}';

  static String creditsValue(int credits) =>
      credits == 1 ? '1 crédito' : '$credits créditos';

  static String prerequisitesChip(int count) =>
      count == 1 ? '1 prerrequisito' : '$count prerrequisitos';
}
