import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_bloc/bloc/app_bloc.dart';
import 'package:learning_bloc/bloc/app_event.dart';
import 'package:learning_bloc/dialog/delete_account_dialog.dart';
import 'package:learning_bloc/dialog/logout_dialog.dart';

enum MenuAction {
  logout,
  deleteAccount,
}

class MainPopupMenuButton extends StatelessWidget {
  const MainPopupMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (menuAction) async {
        final appBloc = context.read<AppBloc>();

        if (menuAction == MenuAction.logout) {
          final shouldLogout = await showLogoutDialog(context);

          if (shouldLogout) {
            appBloc.add(
              AppEventLogout(),
            );
          }
        } else if (menuAction == MenuAction.deleteAccount) {
          final shouldDeleteAccount = await showDeleteAccountDialog(context);

          if (shouldDeleteAccount) {
            appBloc.add(
              const AppEventDeleteAccount(),
            );
          }
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem<MenuAction>(
            value: MenuAction.logout,
            child: Text('Logout'),
          ),
          const PopupMenuItem<MenuAction>(
            value: MenuAction.deleteAccount,
            child: Text('Delete Account'),
          )
        ];
      },
    );
  }
}
