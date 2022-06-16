import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning_bloc/bloc/app_bloc.dart';
import 'package:learning_bloc/bloc/app_state.dart';
import 'package:learning_bloc/bloc/bloc_events.dart';

extension ToList on String {
  Uint8List toUint8List() => Uint8List.fromList(
        codeUnits,
      );
}

final text1 = 'foo'.toUint8List();
final text2 = 'bar'.toUint8List();

enum Errors {
  dummy,
}

void main() {
  blocTest<AppBloc, AppState>(
    'initial state of bloc should be empty',
    build: () => AppBloc(
      urls: [],
      waitBeforeLoading: null,
      urlPicker: null,
      urlLoader: null,
    ),
    verify: (appBloc) => expect(
      appBloc.state,
      const AppState.empty(),
    ),
  );

  blocTest<AppBloc, AppState>(
    'load valid data and compare state',
    build: () => AppBloc(
      urls: [],
      waitBeforeLoading: null,
      urlPicker: (_) => '',
      urlLoader: (_) => Future.value(text1),
    ),
    verify: (appBloc) => expect(
      appBloc.state,
      const AppState.empty(),
    ),
    act: (appBloc) => appBloc.add(
      const LoadNextUrlEvent(),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        data: text1,
        error: null,
      ),
    ],
  );

  blocTest<AppBloc, AppState>(
    'throwing a error from urlLoader',
    build: () => AppBloc(
      urls: [],
      waitBeforeLoading: null,
      urlPicker: (_) => '',
      urlLoader: (_) => Future.error(Errors.dummy),
    ),
    verify: (appBloc) => expect(
      appBloc.state,
      const AppState.empty(),
    ),
    act: (appBloc) => appBloc.add(
      const LoadNextUrlEvent(),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      const AppState(
        isLoading: false,
        data: null,
        error: Errors.dummy,
      ),
    ],
  );

  blocTest<AppBloc, AppState>(
    'load more than one url',
    build: () => AppBloc(
      urls: [],
      waitBeforeLoading: null,
      urlPicker: (_) => '',
      urlLoader: (_) => Future.value(text2),
    ),
    verify: (appBloc) => expect(
      appBloc.state,
      const AppState.empty(),
    ),
    act: (appBloc) {
      appBloc.add(
        const LoadNextUrlEvent(),
      );
      appBloc.add(
        const LoadNextUrlEvent(),
      );
    },
    expect: () => [
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        data: text2,
        error: null,
      ),
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        data: text2,
        error: null,
      ),
    ],
  );
}
