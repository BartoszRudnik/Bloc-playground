import 'package:flutter/material.dart' show BuildContext;
import 'package:learning_bloc/dialog/generic_dialog.dart';

Future<bool> showLogoutDialog(
  BuildContext context,
) {
  return showGenericDialog(
    context: context,
    title: 'Logout',
    content: 'Are you sure you want to logout?',
    optionBuilder: () => {
      'Logout': true,
      'Cancel': false,
    },
  ).then(
    (value) => value ?? false,
  );
}
