import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/core/common/handlers/handlers.dart';
import 'package:univalle_app/features/search_subject/data/datasources/sira_search_subject_datasource.dart';
import 'package:univalle_app/features/search_subject/data/repositories/sira_search_subject_repository_impl.dart';
import 'package:univalle_app/features/search_subject/domain/entities/subject_result.dart';
import 'package:univalle_app/features/search_subject/domain/entities/subject_suggestion.dart';
import 'package:univalle_app/features/search_subject/domain/repositories/search_subject_repository.dart';

final subjectSearchProvider =
    StateNotifierProvider<SubjectSearchNotifier, SubjectSearchStatus>((ref) {
  final searchSubjectRepository =
      SiraSearchSubjectRepositoryImpl(SiraSearchSubjectDatasource());
  return SubjectSearchNotifier(ref, searchSubjectRepository);
});

class SubjectSearchNotifier extends StateNotifier<SubjectSearchStatus> {
  final Ref _ref;
  final SearchSubjectRepository _searchSubjectRepository;
  late SearchResult _result;

  SubjectSearchNotifier(this._ref, this._searchSubjectRepository)
      : super(SubjectSearchStatus.initial);

  Future<void> searchSubjects(
      SubjectSuggestion? suggestion, String campus) async {
    try {
      if (suggestion == null) {
        return;
      }
      state = SubjectSearchStatus.loading;
      _result =
          await _searchSubjectRepository.searchSubjects(suggestion, campus);
      state = SubjectSearchStatus.loaded;
    } catch (e) {
      _ref.read(snackBarHandlerProvider).showSnackBarError(e.toString());
      state = SubjectSearchStatus.error;
    }
  }

  SearchResult get result => _result;
}

enum SubjectSearchStatus { initial, loading, loaded, error }
