import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_bloc/apis/login_api.dart';
import 'package:learning_bloc/apis/notes_api.dart';
import 'package:learning_bloc/bloc/actions.dart';
import 'package:learning_bloc/bloc/app_state.dart';
import 'package:learning_bloc/models.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApiProtocol;
  final NotesApiProtocol notesApiProtocol;
  final LoginHandle acceptableLoginHandle;

  AppBloc({
    required this.loginApiProtocol,
    required this.notesApiProtocol,
    required this.acceptableLoginHandle,
  }) : super(
          const AppState.empty(),
        ) {
    on<LoginAction>(
      (event, emit) async {
        emit(
          const AppState(
            isLoading: true,
            fetchedNotes: null,
            loginError: null,
            loginHandle: null,
          ),
        );

        final loginHandle = await loginApiProtocol.login(
          email: event.email,
          password: event.password,
        );

        emit(
          AppState(
            isLoading: false,
            fetchedNotes: null,
            loginError: loginHandle == null ? LoginErrors.invalidHandle : null,
            loginHandle: loginHandle,
          ),
        );
      },
    );

    on<LoadNotesAction>(
      (event, emit) async {
        emit(
          AppState(
            isLoading: true,
            fetchedNotes: null,
            loginError: null,
            loginHandle: state.loginHandle,
          ),
        );

        final loginHandle = state.loginHandle;

        if (loginHandle != acceptableLoginHandle) {
          emit(
            AppState(
              isLoading: false,
              fetchedNotes: null,
              loginError: LoginErrors.invalidHandle,
              loginHandle: loginHandle,
            ),
          );

          return;
        }

        final notes = await notesApiProtocol.getNotes(loginHandle: loginHandle!);

        emit(
          AppState(
            isLoading: false,
            fetchedNotes: notes,
            loginError: null,
            loginHandle: loginHandle,
          ),
        );
      },
    );
  }
}
