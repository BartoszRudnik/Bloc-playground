import 'package:flutter/material.dart' show BuildContext;
import 'package:learning_bloc/dialog/generic_dialog.dart';

Future<bool> showDeleteAccountDialog(
  BuildContext context,
) {
  return showGenericDialog(
    context: context,
    title: 'Delete account',
    content: 'Are you sure you want to delete your account?',
    optionBuilder: () => {
      'Cancel': false,
      'Delete Account': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
