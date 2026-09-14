/// The public class-schedule lookup lives on its own host
/// (sira1.univalle.edu.co) rather than the main sira.univalle.edu.co one
/// used by [SiraConstants] — it's a separate, unauthenticated endpoint, so
/// it gets its own base URL instead of reusing [siraDioProvider].
abstract final class ScheduleConstants {
  static const String baseUrl = 'https://sira1.univalle.edu.co/sra/';
  static const String path = 'paquetes/programacionacademica/index_publico.php';
}
