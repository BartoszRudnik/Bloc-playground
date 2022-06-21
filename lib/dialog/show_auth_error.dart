import 'package:flutter/material.dart' show BuildContext;
import 'package:learning_bloc/auth/auth_error.dart';
import 'package:learning_bloc/dialog/generic_dialog.dart';

Future<void> showAuthError(
  BuildContext context,
  AuthError authError,
) {
  return showGenericDialog(
    context: context,
    title: authError.dialogTitle,
    content: authError.dialogContent,
    optionBuilder: () => {
      'Ok': true,
    },
  );
}
