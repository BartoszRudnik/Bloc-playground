import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:learning_bloc/auth/auth_error.dart';

@immutable
abstract class AppState {
  final bool isLoading;
  final AuthError? authError;

  const AppState({
    required this.isLoading,
    required this.authError,
  });
}

@immutable
class AppStateLoggedIn extends AppState {
  final User user;
  final Iterable<Reference> images;

  const AppStateLoggedIn({
    required this.user,
    required this.images,
    required super.isLoading,
    required super.authError,
  });

  @override
  bool operator ==(other) {
    final otherClass = other;

    if (otherClass is AppStateLoggedIn) {
      return isLoading == otherClass.isLoading && user.uid == otherClass.user.uid && images.length == otherClass.images.length;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(
        user.uid,
        images,
      );
}

@immutable
class AppStateLogedOut extends AppState {
  const AppStateLogedOut({
    required super.isLoading,
    required super.authError,
  });
}

@immutable
class AppStateIsInRegistrationView extends AppState {
  const AppStateIsInRegistrationView({
    required super.isLoading,
    required super.authError,
  });
}

extension GetUserId on AppState {
  User? get user {
    final cls = this;

    if (cls is AppStateLoggedIn) {
      return cls.user;
    } else {
      return null;
    }
  }
}

extension GetUserImages on AppState {
  Iterable<Reference>? get user {
    final cls = this;

    if (cls is AppStateLoggedIn) {
      return cls.images;
    } else {
      return null;
    }
  }
}
