import 'package:flutter/foundation.dart' show immutable;
import 'package:learning_bloc/models.dart';
import 'package:collection/collection.dart';

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

  @override
  bool operator ==(covariant AppState other) {
    final isTrue = isLoading == other.isLoading && loginError == other.loginError && loginHandle == other.loginHandle;

    if (fetchedNotes == null && other.fetchedNotes == null) {
      return isTrue;
    } else {
      return isTrue && (fetchedNotes?.isEqualTo(other.fetchedNotes) ?? false);
    }
  }

  @override
  int get hashCode => Object.hash(
        isLoading,
        loginError,
        loginHandle,
        fetchedNotes,
      );
}

extension UnorderedEquality on Object {
  bool isEqualTo(other) => const DeepCollectionEquality.unordered().equals(
        this,
        other,
      );
}
