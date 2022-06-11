import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => PersonsBloc(),
        child: const MyHomePage(),
      ),
    );
  }
}

enum PersonUrl {
  persons1,
  persons2,
}

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index
      ? elementAt(
          index,
        )
      : null;
}

extension UrlString on PersonUrl {
  String get urlString {
    switch (this) {
      case PersonUrl.persons1:
        return "http://127.0.0.1:5500/api/person1.json";
      case PersonUrl.persons2:
        return "http://127.0.0.1:5500/api/person2.json";
    }
  }
}

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonAction implements LoadAction {
  final PersonUrl personUrl;

  const LoadPersonAction({
    required this.personUrl,
  }) : super();
}

@immutable
class Person {
  final String name;
  final int age;

  const Person({
    required this.name,
    required this.age,
  });

  Person.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        age = json['age'] as int;
}

@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isRetrievedFromCache;

  const FetchResult({
    required this.persons,
    required this.isRetrievedFromCache,
  });
}

class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<PersonUrl, Iterable<Person>> _cache = {};
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
        final persons = await getPersons(url.urlString);
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

Future<Iterable<Person>> getPersons(String url) {
  return HttpClient()
      .getUrl(
        Uri.parse(
          url,
        ),
      )
      .then((
        req,
      ) =>
          req.close())
      .then((
        resp,
      ) =>
          resp
              .transform(
                utf8.decoder,
              )
              .join())
      .then(
        (str) => json.decode(
          str,
        ) as List<dynamic>,
      )
      .then(
        (list) => list.map(
          (e) => Person.fromJson(e),
        ),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  context.read<PersonsBloc>().add(
                        const LoadPersonAction(
                          personUrl: PersonUrl.persons1,
                        ),
                      );
                },
                child: const Text(
                  "Load json 1",
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<PersonsBloc>().add(
                        const LoadPersonAction(
                          personUrl: PersonUrl.persons2,
                        ),
                      );
                },
                child: const Text(
                  "Load json 2",
                ),
              ),
            ],
          ),
          BlocBuilder<PersonsBloc, FetchResult?>(
            buildWhen: (previous, current) {
              return previous?.persons != current?.persons;
            },
            builder: (context, fetchResult) {
              final persons = fetchResult?.persons;

              if (persons == null) {
                return const SizedBox();
              } else {
                return ListView.builder(
                  itemCount: persons.length,
                  itemBuilder: (context, index) => Text(
                    "${persons[index]!.name} ${persons[index]!.age}",
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
