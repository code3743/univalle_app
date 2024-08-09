class SiraConstants {
  static const String baseUrl = 'https://sira.univalle.edu.co/sra/';
  static const String logoutPath = '/paquetes/autenticacion/salir.php';
  static const String homePath =
      '/paquetes/inicioestudiante/index.php?accion=Inicio';
  static const String studentPath = '/paquetes/tablaMaestro/persona/index.php';
  static const String rantingPath = '/paquetes/academica/index.php';
  static const String finesPath =
      '/paquetes/tablaMaestro/deuda/index_publico.php?accion=desplegarFormaConsultaPublica';
  static const String tabulatedPath = '/paquetes/matricula/index_publico.php';
  static const String resolutionPath =
      '/paquetes/resolucionporprograma/index.php';

  static const String resetPasswordPath =
      'https://swebse58.univalle.edu.co/sac/sac.php/solicitarClave';

  static const String searchSubjectPath =
      'paquetes/programacionacademica/index_publico.php';
  static const String searchSuggestionsPath =
      'paquetes/herramientas/wincombo.php?&ID=ID&db_conexion=&patron=QUERY&patron2=CAMPUS&patron3=&patron4=&patron5=&patron6=&patron7=&patron8=&patron9=&min=PAGE&opcion=asignaturaProgramadaActualmente&variableCalculada=1&numeroRegistros=';
  static const String bodySearchSubject =
      'sed_codigo=CAMPUS&agp_asi_codigo=CODE&wincomboagp_asi_codigo=&accion=Consultar+Programaci%F3n+Acad%E9mica&fac_codigo=1&una_codigo=102&tipo_consulta=desplegarFormularioConsultarProgramacion&fac_codigo=1&pra_codigo=&tipo_consulta=desplegarFormularioConsultarProgramacion';
}
