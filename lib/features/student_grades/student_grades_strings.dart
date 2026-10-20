abstract final class StudentGradesStrings {
  static const gradesUnavailable = 'No se pudieron obtener las calificaciones.';

  static const title = 'Calificaciones';
  static const empty = 'Aún no hay calificaciones registradas.';
  static const subjectsSectionLabel = 'Materias';
  static const periodsCountLabel = 'Periodos cursados';
  static const bestPeriodLabel = 'Mejor semestre';
  static const averageLabel = 'Promedio';
  static const creditsLabel = 'Créditos';
  static const approvedLabel = 'Aprob.';
  static const academicMeritTooltip = 'Estímulo académico';
  static const groupLabel = 'Grupo';
  static const creditsUnit = 'créditos';
  static const canceledLabel = 'Cancelada';

  static const equivalencesTitle = 'Equivalencias';
  static const equivalencesEmpty = 'No tienes equivalencias registradas.';
  static const equivalencesSubjectsLabel = 'Materias';
  static const equivalencesCreditsLabel = 'Créditos';

  static String equivalencesShortcutLabel(int subjects, int credits) =>
      '$equivalencesTitle · ${subjects == 1 ? '1 materia' : '$subjects materias'} · '
      '$credits $creditsUnit';
}
