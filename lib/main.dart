import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_bloc/apis/login_api.dart';
import 'package:learning_bloc/apis/notes_api.dart';
import 'package:learning_bloc/bloc/actions.dart';
import 'package:learning_bloc/bloc/app_bloc.dart';
import 'package:learning_bloc/bloc/app_state.dart';
import 'package:learning_bloc/dialogs/generic_dialog.dart';
import 'package:learning_bloc/dialogs/loading_screen.dart';
import 'package:learning_bloc/models.dart';
import 'package:learning_bloc/strings.dart';
import 'package:learning_bloc/views/iterable_list_view.dart';
import 'package:learning_bloc/views/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApiProtocol: LoginApi.instance(),
        notesApiProtocol: NotesApi(),
        acceptableLoginHandle: const LoginHandle.fooBar(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            homePage,
          ),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          builder: (context, appState) {
            final notes = appState.fetchedNotes;

            if (notes == null) {
              return LoginView(
                onLoginTapped: (email, password) {
                  context.read<AppBloc>().add(
                        LoginAction(
                          email: email,
                          password: password,
                        ),
                      );
                },
              );
            } else {
              return notes.toListView();
            }
          },
          listener: (context, appState) {
            if (appState.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: pleaseWait,
              );
            } else {
              LoadingScreen.instance().hide();
            }

            final loginError = appState.loginError;

            if (loginError != null) {
              showGenericDialog(
                context: context,
                title: loginErrorDialogTitle,
                content: loginErrorDialogContent,
                optionBuilder: () => {
                  ok: true,
                },
              );
            }

            if (appState.isLoading == false &&
                appState.loginError == null &&
                appState.loginHandle == const LoginHandle.fooBar() &&
                appState.fetchedNotes == null) {
              context.read<AppBloc>().add(
                    const LoadNotesAction(),
                  );
            }
          },
        ),
      ),
    );
  }
}
