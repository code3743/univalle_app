/// Ordered Monday-first so its declaration order doubles as sort order.
enum Weekday {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  /// Parses SIRA's three-letter Spanish day codes (LUN, MAR, MIE/MIÉ, JUE,
  /// VIE, SAB, DOM). Returns null for anything else instead of throwing,
  /// since callers use it to filter out lines that don't match.
  static Weekday? fromSiraCode(String code) {
    switch (code.trim().toUpperCase()) {
      case 'LUN':
        return Weekday.monday;
      case 'MAR':
        return Weekday.tuesday;
      case 'MIE':
      case 'MIÉ':
        return Weekday.wednesday;
      case 'JUE':
        return Weekday.thursday;
      case 'VIE':
        return Weekday.friday;
      case 'SAB':
        return Weekday.saturday;
      case 'DOM':
        return Weekday.sunday;
      default:
        return null;
    }
  }
}
