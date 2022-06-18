import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/foundation.dart' show immutable;

const Map<String, AuthError> authErrorMapping = {
  'no-current-user': AuthErrorNoCurrentUser(),
  'requires-recent-login': AuthErrorRequiresRecentLogin(),
  'operation-not-allowed': AuthErrorOperationNotAllowed(),
  'user-not-found': AuthErrorUserNotFound(),
  'weak-password': AuthErrorWeakPassword(),
  'invalid-email': AuthErrorInvalidEmail(),
  'email-already-in-use': AuthErrorEmailAlreadyInUse(),
};

@immutable
abstract class AuthError {
  final String dialogTitle;
  final String dialogContent;

  const AuthError({
    required this.dialogContent,
    required this.dialogTitle,
  });

  factory AuthError.from(FirebaseAuthException exception) => authErrorMapping[exception.code.toLowerCase().trim()] ?? const AuthErrorUnknown();
}

@immutable
class AuthErrorUnknown extends AuthError {
  const AuthErrorUnknown()
      : super(
          dialogTitle: 'Authentication Error',
          dialogContent: 'Unknown authentication error',
        );
}

@immutable
class AuthErrorNoCurrentUser extends AuthError {
  const AuthErrorNoCurrentUser()
      : super(
          dialogTitle: 'No current user',
          dialogContent: 'Current user not found',
        );
}

@immutable
class AuthErrorRequiresRecentLogin extends AuthError {
  const AuthErrorRequiresRecentLogin()
      : super(
          dialogTitle: 'Requires recent login',
          dialogContent: 'You need to log out and log back in again in order to perform this operation',
        );
}

@immutable
class AuthErrorOperationNotAllowed extends AuthError {
  const AuthErrorOperationNotAllowed()
      : super(
          dialogTitle: 'Operation not allowed',
          dialogContent: 'You cannot register with this metod at this moment!',
        );
}

@immutable
class AuthErrorUserNotFound extends AuthError {
  const AuthErrorUserNotFound()
      : super(
          dialogTitle: 'User not found',
          dialogContent: 'The given user was not found',
        );
}

@immutable
class AuthErrorWeakPassword extends AuthError {
  const AuthErrorWeakPassword()
      : super(
          dialogTitle: 'Weak password',
          dialogContent: 'Please choose a stronger password consisting of more characters',
        );
}

@immutable
class AuthErrorInvalidEmail extends AuthError {
  const AuthErrorInvalidEmail()
      : super(
          dialogTitle: 'Invalid email',
          dialogContent: 'Please double check your email and try again',
        );
}

@immutable
class AuthErrorEmailAlreadyInUse extends AuthError {
  const AuthErrorEmailAlreadyInUse()
      : super(
          dialogTitle: 'Email already in use',
          dialogContent: 'Please double check your email and try again',
        );
}
