import 'package:flutter/foundation.dart' show immutable;
import 'package:learning_bloc/model/person.dart';

const person1Url = 'http://127.0.0.1:5500/api/person1.json';
const person2Url = 'http://127.0.0.1:5500/api/person2.json';

typedef PersonsLoader = Future<Iterable<Person>> Function(String url);

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonAction implements LoadAction {
  final String personUrl;
  final PersonsLoader loader;

  const LoadPersonAction({
    required this.personUrl,
    required this.loader,
  }) : super();
}
