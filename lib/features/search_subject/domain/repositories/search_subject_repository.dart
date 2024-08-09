import 'package:univalle_app/features/search_subject/domain/entities/subject_result.dart';
import 'package:univalle_app/features/search_subject/domain/entities/subject_suggestion.dart';

abstract class SearchSubjectRepository {
  Future<SearchResult> searchSubjects(
      SubjectSuggestion suggestion, String campus);
  Future<List<SubjectSuggestion>> getSuggestions(
      String query, int page, String campus);
}
