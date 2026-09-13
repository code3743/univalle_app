import 'domain/entities/weekday.dart';

abstract final class ScheduleStrings {
  static const title = 'Horario de clases';
  static const empty =
      'No se encontró un horario para tus materias matriculadas.';
  static const noClassesThisDay = 'No tienes clases este día.';
  static const scheduleUnavailable = 'No se pudo obtener el horario de clases.';

  static String weekdayLabel(Weekday day) => switch (day) {
    Weekday.monday => 'Lunes',
    Weekday.tuesday => 'Martes',
    Weekday.wednesday => 'Miércoles',
    Weekday.thursday => 'Jueves',
    Weekday.friday => 'Viernes',
    Weekday.saturday => 'Sábado',
    Weekday.sunday => 'Domingo',
  };

  static String weekdayShortLabel(Weekday day) => switch (day) {
    Weekday.monday => 'Lun',
    Weekday.tuesday => 'Mar',
    Weekday.wednesday => 'Mié',
    Weekday.thursday => 'Jue',
    Weekday.friday => 'Vie',
    Weekday.saturday => 'Sáb',
    Weekday.sunday => 'Dom',
  };
}
