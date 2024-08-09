import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/core/common/handlers/handlers.dart';
import 'package:univalle_app/features/search_subject/data/datasources/sira_search_subject_datasource.dart';
import 'package:univalle_app/features/search_subject/data/repositories/sira_search_subject_repository_impl.dart';
import 'package:univalle_app/features/search_subject/domain/entities/subject_result.dart';
import 'package:univalle_app/features/search_subject/domain/entities/subject_suggestion.dart';
import 'package:univalle_app/features/search_subject/domain/repositories/search_subject_repository.dart';

final subjectSearchProvider =
    StateNotifierProvider<SubjectSearchNotifier, List<SubjectResult>?>((ref) {
  final searchSubjectRepository =
      SiraSearchSubjectRepositoryImpl(SiraSearchSubjectDatasource());
  return SubjectSearchNotifier(ref, searchSubjectRepository);
});

class SubjectSearchNotifier extends StateNotifier<List<SubjectResult>?> {
  final Ref _ref;
  final SearchSubjectRepository _searchSubjectRepository;

  SubjectSearchNotifier(this._ref, this._searchSubjectRepository) : super(null);

  Future<void> searchSubjects(
      SubjectSuggestion? suggestion, String campus) async {
    try {
      if (suggestion == null) {
        return;
      }
      state = await _searchSubjectRepository.searchSubjects(suggestion, campus);
    } catch (e) {
      _ref.read(snackBarHandlerProvider).showSnackBArError(e.toString());
    }
  }
}
