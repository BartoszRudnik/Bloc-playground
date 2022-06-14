import 'package:flutter/foundation.dart' show immutable;
import 'package:learning_bloc/models.dart';

@immutable
class AppState {
  final bool isLoading;
  final Iterable<Note>? fetchedNotes;
  final LoginErrors? loginError;
  final LoginHandle? loginHandle;

  const AppState({
    required this.isLoading,
    required this.fetchedNotes,
    required this.loginError,
    required this.loginHandle,
  });

  const AppState.empty()
      : isLoading = false,
        loginError = null,
        loginHandle = null,
        fetchedNotes = null;

  @override
  String toString() => {
        'isLoading': isLoading,
        'fetchedNotes': fetchedNotes,
        'loginError': loginError,
        'loginHandle': loginHandle,
      }.toString();
}
