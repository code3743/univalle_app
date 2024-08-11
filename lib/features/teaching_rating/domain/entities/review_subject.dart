import 'package:univalle_app/features/teaching_rating/domain/entities/questions_subject.dart';

class ReviewSubject {
  final List<QuestionsSubject> questions;
  final String teacherName;
  final String subjectName;
  final Map<String, String> bodyData;
  String? feedback;

  ReviewSubject({
    required this.bodyData,
    required this.questions,
    required this.teacherName,
    required this.subjectName,
    this.feedback,
  });

  /*
  eva_apd_sed_codigo: 06
una_codigo: 750
eva_apd_pea_codigo: 202402041
eva_apd_doc_codigo: 16647935
eva_apd_doc_per_codigo: 2000001404
eva_apd_asi_codigo: 750016C
eva_apd_agp_grupo: 51
eva_enc_codigo: 21
eva_tie_codigo: 0
eva_fecha_evaluacion: 2024-08-09
eva_num_estudiantes_asignatura: 46
eva_num_estudiantes_evaluados: 45
ase_maa_est_codigo: 202259332
ase_maa_per_codigo: 2000201890
etiqueta_observacion: (no se pudo decodificar el valor)
mensaje_estudiantes: (no se pudo decodificar el valor)
num_respuesta: 24
  
   */
}
