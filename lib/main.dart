import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_bloc/bloc/app_bloc.dart';
import 'package:learning_bloc/bloc/app_event.dart';
import 'package:learning_bloc/bloc/app_state.dart';
import 'package:learning_bloc/dialog/show_auth_error.dart';
import 'package:learning_bloc/loading/loading_screen.dart';
import 'package:learning_bloc/view/login_view.dart';
import 'package:learning_bloc/view/photo_gallery_view.dart';
import 'package:learning_bloc/view/register_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (_) => AppBloc()
        ..add(
          const AppEventInitialize(),
        ),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocConsumer<AppBloc, AppState>(
          listener: (context, state) {
            if (state.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: 'Loading...',
              );
            } else {
              LoadingScreen.instance().hide();
            }

            final authError = state.authError;

            if (authError != null) {
              showAuthError(
                context,
                authError,
              );
            }
          },
          builder: (context, state) {
            if (state is AppStateLogedOut) {
              return const LoginView();
            } else if (state is AppStateLoggedIn) {
              return const PhotoGalleryView();
            } else if (state is AppStateIsInRegistrationView) {
              return const RegisterView();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
