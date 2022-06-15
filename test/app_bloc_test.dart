import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning_bloc/apis/login_api.dart';
import 'package:learning_bloc/apis/notes_api.dart';
import 'package:learning_bloc/bloc/actions.dart';
import 'package:learning_bloc/bloc/app_bloc.dart';
import 'package:learning_bloc/bloc/app_state.dart';
import 'package:learning_bloc/models.dart';

const Iterable<Note> mockNotes = [
  Note(
    title: 'note 1',
  ),
  Note(
    title: 'note 2',
  ),
  Note(
    title: 'note 3',
  ),
];

@immutable
class DummyNotesApi implements NotesApiProtocol {
  final LoginHandle acceptedLoginHandle;
  final Iterable<Note>? notesToReturnToAcceptedLoginHandle;

  const DummyNotesApi({
    required this.acceptedLoginHandle,
    required this.notesToReturnToAcceptedLoginHandle,
  });

  const DummyNotesApi.empty()
      : acceptedLoginHandle = const LoginHandle.fooBar(),
        notesToReturnToAcceptedLoginHandle = null;

  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle}) async {
    if (loginHandle == acceptedLoginHandle) {
      return notesToReturnToAcceptedLoginHandle;
    } else {
      return null;
    }
  }
}

@immutable
class DummyLoginApi implements LoginApiProtocol {
  final String acceptedEmail;
  final String acceptedPassword;
  final LoginHandle handleToReturn;

  const DummyLoginApi.empty()
      : acceptedEmail = '',
        acceptedPassword = '',
        handleToReturn = const LoginHandle.fooBar();

  const DummyLoginApi({
    required this.acceptedEmail,
    required this.acceptedPassword,
    required this.handleToReturn,
  });

  @override
  Future<LoginHandle?> login({required String email, required String password}) async {
    if (email == acceptedEmail && password == acceptedPassword) {
      return handleToReturn;
    }

    return null;
  }
}

void main() {
  blocTest<AppBloc, AppState>(
    'Initial state should be AppState.empty()',
    build: () => AppBloc(
      acceptableLoginHandle: const LoginHandle(
        token: 'ABC',
      ),
      loginApiProtocol: const DummyLoginApi.empty(),
      notesApiProtocol: const DummyNotesApi.empty(),
    ),
    verify: (appState) => expect(
      appState.state,
      const AppState.empty(),
    ),
  );

  blocTest<AppBloc, AppState>(
    'Log in with correct credentials',
    build: () => AppBloc(
      acceptableLoginHandle: const LoginHandle(
        token: 'ABC',
      ),
      loginApiProtocol: const DummyLoginApi(
        acceptedEmail: 'bar@baz.com',
        acceptedPassword: 'foo',
        handleToReturn: LoginHandle(
          token: 'ABC',
        ),
      ),
      notesApiProtocol: const DummyNotesApi.empty(),
    ),
    act: (appBloc) => appBloc.add(
      const LoginAction(
        email: 'bar@baz.com',
        password: 'foo',
      ),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        fetchedNotes: null,
        loginError: null,
        loginHandle: null,
      ),
      const AppState(
        isLoading: false,
        fetchedNotes: null,
        loginError: null,
        loginHandle: LoginHandle(
          token: 'ABC',
        ),
      ),
    ],
  );

  blocTest<AppBloc, AppState>(
    'Log in with invalid credentials',
    build: () => AppBloc(
      acceptableLoginHandle: const LoginHandle(
        token: 'ABC',
      ),
      loginApiProtocol: const DummyLoginApi(
        acceptedEmail: 'bar@baz.com',
        acceptedPassword: 'baz',
        handleToReturn: LoginHandle(
          token: 'ABC',
        ),
      ),
      notesApiProtocol: const DummyNotesApi.empty(),
    ),
    act: (appBloc) => appBloc.add(
      const LoginAction(
        email: 'bar@baz.com',
        password: 'foo',
      ),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        fetchedNotes: null,
        loginError: null,
        loginHandle: null,
      ),
      const AppState(
        isLoading: false,
        fetchedNotes: null,
        loginError: LoginErrors.invalidHandle,
        loginHandle: null,
      ),
    ],
  );

  blocTest<AppBloc, AppState>(
    'Fetch notes after log in',
    build: () => AppBloc(
      acceptableLoginHandle: const LoginHandle(
        token: 'ABC',
      ),
      loginApiProtocol: const DummyLoginApi(
        acceptedEmail: 'bar@baz.com',
        acceptedPassword: 'baz',
        handleToReturn: LoginHandle(
          token: 'ABC',
        ),
      ),
      notesApiProtocol: const DummyNotesApi(
        acceptedLoginHandle: LoginHandle(
          token: 'ABC',
        ),
        notesToReturnToAcceptedLoginHandle: mockNotes,
      ),
    ),
    act: (appBloc) {
      appBloc.add(
        const LoginAction(
          email: 'bar@baz.com',
          password: 'baz',
        ),
      );
      appBloc.add(
        const LoadNotesAction(),
      );
    },
    expect: () => [
      const AppState(
        isLoading: true,
        fetchedNotes: null,
        loginError: null,
        loginHandle: null,
      ),
      const AppState(
        isLoading: false,
        fetchedNotes: null,
        loginError: null,
        loginHandle: LoginHandle(
          token: 'ABC',
        ),
      ),
      const AppState(
        isLoading: true,
        fetchedNotes: null,
        loginError: null,
        loginHandle: LoginHandle(
          token: 'ABC',
        ),
      ),
      const AppState(
        isLoading: false,
        fetchedNotes: mockNotes,
        loginError: null,
        loginHandle: LoginHandle(
          token: 'ABC',
        ),
      ),
    ],
  );
}
