import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/routers/app_router.dart';
import 'package:univalle_app/features/search_subject/domain/entities/subject_suggestion.dart';

final searchDelegateProvider = FutureProvider<SubjectSuggestion?>((ref) async {
  return await showSearch<SubjectSuggestion?>(
      context: ref
          .read(appRouterProvider)
          .configuration
          .navigatorKey
          .currentContext!,
      delegate: SearchSubjectDelegate());
});

class SearchSubjectDelegate extends SearchDelegate<SubjectSuggestion?> {
  Timer? _debounce;
  final List<SubjectSuggestion> suggestions = [];
  final ScrollController _scrollController = ScrollController();
  SearchSubjectDelegate() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent <=
          _scrollController.position.pixels - 500) {
        // _loadMore();
      }
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
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {});

    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {});

    return ListView.builder(
        controller: _scrollController,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(suggestions[index].name),
            subtitle: Text(suggestions[index].code),
            onTap: () => close(context, suggestions[index]),
          );
        },
        itemCount: suggestions.length);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }
}
