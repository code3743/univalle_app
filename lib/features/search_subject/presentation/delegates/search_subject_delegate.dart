import 'dart:async';
import 'package:flutter/material.dart';
import 'package:univalle_app/features/search_subject/data/datasources/sira_search_subject_datasource.dart';
import 'package:univalle_app/features/search_subject/data/repositories/sira_search_subject_repository_impl.dart';
import 'package:univalle_app/features/search_subject/domain/entities/subject_suggestion.dart';

class SearchSubjectDelegate extends SearchDelegate<SubjectSuggestion?> {
  final String _campus;
  Timer? _debounce;
  final _getSuggestionsStream =
      StreamController<List<SubjectSuggestion>>.broadcast();
  final searchRepository =
      SiraSearchSubjectRepositoryImpl(SiraSearchSubjectDatasource());

  SearchSubjectDelegate(this._campus)
      : super(searchFieldLabel: 'Buscar Asignatura');

  @override
  void dispose() {
    _debounce?.cancel();
    _getSuggestionsStream.close();
    super.dispose();
  }

  @override
  void close(BuildContext context, SubjectSuggestion? result) {
    _getSuggestionsStream.close();
    _debounce?.cancel();
    super.close(context, result);
  }

  _fecthSuggestions(String query) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () async {
      if (query.isEmpty) {
        _getSuggestionsStream.add([]);
        return;
      }
      final result = await searchRepository.getSuggestions(query, 0, _campus);
      _getSuggestionsStream.add(result);
    });
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
      IconButton(
          onPressed: () => showResults(context), icon: const Icon(Icons.search))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) {
    _fecthSuggestions(query);
    return StreamBuilder(
        stream: _getSuggestionsStream.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SubjectSuggestionsList(
                suggestions: snapshot.data!,
                loadMoreSuggestions: (page) async {
                  return await searchRepository.getSuggestions(
                      query, page, _campus);
                },
                close: close);
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _fecthSuggestions(query);
    return StreamBuilder(
        stream: _getSuggestionsStream.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SubjectSuggestionsList(
                suggestions: snapshot.data!,
                loadMoreSuggestions: (page) async {
                  return await searchRepository.getSuggestions(
                      query, page, _campus);
                },
                close: close);
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}

class SubjectSuggestionsList extends StatefulWidget {
  const SubjectSuggestionsList(
      {super.key,
      required this.suggestions,
      required this.loadMoreSuggestions,
      required this.close});
  final List<SubjectSuggestion> suggestions;
  final Future<List<SubjectSuggestion>> Function(int) loadMoreSuggestions;
  final void Function(BuildContext, SubjectSuggestion?) close;

  @override
  State<SubjectSuggestionsList> createState() => _SubjectSuggestionsListState();
}

class _SubjectSuggestionsListState extends State<SubjectSuggestionsList> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(
      () {
        if (_controller.position.maxScrollExtent <=
                _controller.position.pixels + 600 &&
            !_isLoading) {
          _loadMoreSuggestions();
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  int _page = 1;
  void _loadMoreSuggestions() async {
    try {
      if (_isLoading) return;
      _isLoading = true;
      _page++;
      final result = await widget.loadMoreSuggestions(_page);
      setState(() {
        widget.suggestions.addAll(result);
      });
    } catch (e) {
      _page--;
    } finally {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemCount: widget.suggestions.length,
        controller: _controller,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.suggestions[index].name),
            subtitle: Text(widget.suggestions[index].code),
            onTap: () => widget.close(context, widget.suggestions[index]),
          );
        });
  }
}
