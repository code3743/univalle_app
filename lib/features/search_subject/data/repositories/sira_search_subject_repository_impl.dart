import 'package:univalle_app/features/search_subject/domain/datasources/search_subject_datasource.dart';
import 'package:univalle_app/features/search_subject/domain/entities/subject_result.dart';
import 'package:univalle_app/features/search_subject/domain/entities/subject_suggestion.dart';
import 'package:univalle_app/features/search_subject/domain/repositories/search_subject_repository.dart';

class SiraSearchSubjectRepositoryImpl implements SearchSubjectRepository {
  final SearchSubjectDataSource dataSource;
  SiraSearchSubjectRepositoryImpl(this.dataSource);
  @override
  Future<List<SubjectSuggestion>> getSuggestions(
      String query, int page, String campus) {
    return dataSource.getSuggestions(query, page, campus);
  }

  @override
  Future<List<SubjectResult>> searchSubjects(
      SubjectSuggestion suggestion, String campus) {
    return dataSource.searchSubjects(suggestion, campus);
  }
}
