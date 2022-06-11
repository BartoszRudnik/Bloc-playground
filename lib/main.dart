import 'package:flutter/material.dart';
import 'dart:math' as math;

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
      home: const MyHomePage(),
    );
  }
}

const names = [
  "Foo",
  "Bar",
  "Baz",
];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(
        math.Random().nextInt(
          length,
        ),
      );
}

class NamesCubit extends Cubit<String?> {
  NamesCubit() : super(null);

  void pickRandomName() => emit(
        names.getRandomElement(),
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
  late final NamesCubit namesCubit;

  @override
  void initState() {
    super.initState();

    namesCubit = NamesCubit();
  }

  @override
  void dispose() {
    namesCubit.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<String?>(
        stream: namesCubit.stream,
        builder: (ctx, snapshot) {
          final button = TextButton(
            onPressed: () {
              namesCubit.pickRandomName();
            },
            child: const Text("Pick Random Name"),
          );

          switch (snapshot.connectionState) {
            case ConnectionState.active:
              return Column(
                children: [
                  Text(snapshot.data!),
                  button,
                ],
              );
            case ConnectionState.done:
              return const SizedBox();
            case ConnectionState.waiting:
              return button;
            case ConnectionState.none:
              return button;
          }
        },
      ),
    );
  }
}
