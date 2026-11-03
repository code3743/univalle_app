import 'dart:convert';

import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/review_question.dart';
import '../../teaching_rating_strings.dart';
import '../models/review_question_model.dart';
import '../models/teacher_review_model.dart';
import '../models/teacher_to_rate_model.dart';

const _qualifiedNoveltyTitle = 'El Docente ya ha sido evaluado';

/// Parses the HTML pages served by evaluacioncursos.univalle.edu.co.
class CourseEvaluationParser {
  const CourseEvaluationParser._();

  static Document document(List<int> bytes) => parse(latin1.decode(bytes));

  static String? loginErrorMessage(Document document) {
    final message = document
        .querySelector('script')
        ?.text
        .replaceFirst("alert ('", '')
        .replaceFirst("');", '')
        .trim();
    return (message != null && message.isNotEmpty) ? message : null;
  }

  static List<TeacherToRateModel> teachersToRate(Document document) {
    final teachers = <TeacherToRateModel>[];
    for (final form in document.querySelectorAll('form')) {
      final inputs = <String, String>{};
      for (final input in form.querySelectorAll('input')) {
        final name = input.attributes['name'];
        if (name == null || name.isEmpty) continue;
        inputs[name] = input.attributes['value'] ?? '';
      }
      final id = inputs['ase_maa_pea_codigo'];
      if (id == null || id.isEmpty) continue;

      final noveltyTitle = form
          .querySelector('span')
          ?.attributes['title']
          ?.trim();
      final isQualified = noveltyTitle == _qualifiedNoveltyTitle;

      teachers.add(
        TeacherToRateModel(
          id: id,
          teacherName:
              form.querySelector('span')?.text ??
              form.querySelector('label')?.text ??
              '',
          subjectName: inputs['apd_asi_nombre'] ?? '',
          subjectCode: inputs['ase_apd_asi_codigo'] ?? '',
          group: inputs['ase_apd_agp_grupo'] ?? '',
          campusId: inputs['ase_apd_sed_codigo'] ?? '',
          teacherId: inputs['ase_apd_doc_per_codigo'] ?? '',
          teacherDocument: inputs['ase_apd_doc_codigo'] ?? '',
          programId: inputs['ase_maa_per_codigo'] ?? '',
          programName: inputs['ase_pra_nombre'] ?? '',
          programCode: inputs['ase_maa_pra_codigo'] ?? '',
          isQualified: isQualified,
          novelty: (!isQualified && noveltyTitle != null) ? noveltyTitle : null,
        ),
      );
    }
    return teachers;
  }

  static TeacherReviewModel review(
    Document document, {
    required String teacherName,
    required String subjectName,
  }) {
    // When SIRA has no real questionnaire configured for this assignment,
    // it returns a summary row ("Tipo encuesta: NO DEFINIDO (99)") instead
    // of the question form; `cantidadPreguntas21` is only present in the
    // real form, so its absence is the reliable signal to tell them apart.
    if (document.querySelector('input#cantidadPreguntas21') == null) {
      throw BusinessException(
        message:
            _surveyTypeMessage(document) ??
            TeachingRatingStrings.surveyNotConfigured,
        retryable: false,
      );
    }

    final form = document.querySelector('td[width="100%"]>form');
    if (form == null) {
      throw const ServerException(
        message: TeachingRatingStrings.reviewUnavailable,
      );
    }

    final formFields = <String, String>{};
    // SIRA embeds exactly 21 hidden inputs identifying this evaluation
    // (period, student, subject, teacher codes...) that must be replayed
    // verbatim on submit; anything past that is unrelated page markup.
    final hiddenInputs = form.querySelectorAll('input[type="HIDDEN"]').take(21);
    for (final input in hiddenInputs) {
      final name = input.attributes['name'];
      if (name == null || name.isEmpty) continue;
      formFields[name] = input.attributes['value'] ?? '';
    }

    final questions = [
      ..._questionsIn(
        document,
        cssClass: 'asignatura',
        category: QuestionCategory.subject,
      ),
      ..._questionsIn(
        document,
        cssClass: 'profesor',
        category: QuestionCategory.teacher,
      ),
      ..._questionsIn(
        document,
        cssClass: 'estudiante',
        category: QuestionCategory.student,
      ),
    ];

    return TeacherReviewModel(
      formFields: formFields,
      questions: questions,
      teacherName: teacherName,
      subjectName: subjectName,
    );
  }

  static String? _surveyTypeMessage(Document document) {
    for (final label in document.querySelectorAll('td.normalNegroB > label')) {
      final labelText = label.text.trim();
      if (!labelText.toLowerCase().startsWith('tipo encuesta')) continue;
      final valueText = label.parent?.nextElementSibling?.text.trim();
      if (valueText == null || valueText.isEmpty) continue;
      return '$labelText $valueText';
    }
    return null;
  }

  static List<ReviewQuestionModel> _questionsIn(
    Document document, {
    required String cssClass,
    required QuestionCategory category,
  }) {
    final texts = document.querySelectorAll('.$cssClass > td[size]');
    final ids = document.querySelectorAll('.$cssClass > td[size] > input');
    return [
      for (var i = 0; i < texts.length; i++)
        ReviewQuestionModel(
          id: i < ids.length ? (ids[i].attributes['value'] ?? '') : '',
          category: category,
          question: texts[i].text.trim(),
        ),
    ];
  }
}
