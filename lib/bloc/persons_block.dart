import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_bloc/bloc/bloc_actions.dart';
import 'package:learning_bloc/model/fetch_result.dart';
import 'package:learning_bloc/model/person.dart';

class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<String, Iterable<Person>> _cache = {};
  PersonsBloc() : super(null) {
    on<LoadPersonAction>(event, emit) async {
      final url = event.url;

      if (_cache.containsKey(url)) {
        final cachedPersons = _cache[url];

        final result = FetchResult(
          persons: cachedPersons!,
          isRetrievedFromCache: true,
        );

        emit(result);
      } else {
        final loader = event.loader;
        final persons = await loader(url);
        final result = FetchResult(
          persons: persons,
          isRetrievedFromCache: false,
        );

        _cache[url] = persons;

        emit(result);
      }
    }
  }
}
