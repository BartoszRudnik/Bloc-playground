import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_bloc/bloc/bloc_actions.dart';
import 'package:learning_bloc/bloc/persons_block.dart';
import 'package:learning_bloc/model/fetch_result.dart';
import 'package:learning_bloc/model/person.dart';

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

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index
      ? elementAt(
          index,
        )
      : null;
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
                          personUrl: person1Url,
                          loader: getPersons,
                        ),
                      );
                },
                child: const Text(
                  'Load json 1',
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<PersonsBloc>().add(
                        const LoadPersonAction(
                          personUrl: person2Url,
                          loader: getPersons,
                        ),
                      );
                },
                child: const Text(
                  'Load json 2',
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
                    '${persons[index]!.name} ${persons[index]!.age}',
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
