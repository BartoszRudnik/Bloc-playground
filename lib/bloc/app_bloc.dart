import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_bloc/auth/auth_error.dart';
import 'package:learning_bloc/bloc/app_event.dart';
import 'package:learning_bloc/bloc/app_state.dart';
import 'package:learning_bloc/utils/upload_image.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc()
      : super(
          const AppStateLogedOut(
            isLoading: false,
          ),
        ) {
    on<AppEventGoToRegistration>(
      (event, emit) {
        emit(
          const AppStateIsInRegistrationView(
            isLoading: false,
          ),
        );
      },
    );
    on<AppEventLogin>(
      (event, emit) async {
        emit(
          const AppStateLogedOut(
            isLoading: true,
          ),
        );

        final email = event.email;
        final password = event.password;

        try {
          final userCredentials = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          final user = userCredentials.user!;
          final images = await _getImages(user.uid);

          emit(
            AppStateLoggedIn(
              user: user,
              images: images,
              isLoading: false,
            ),
          );
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateLogedOut(
              isLoading: false,
              authError: AuthError.from(e),
            ),
          );
        }
      },
    );
    on<AppEventGoToLogin>(
      (event, emit) {
        emit(
          const AppStateLogedOut(
            isLoading: false,
          ),
        );
      },
    );
    on<AppEventRegister>(
      (event, emit) async {
        emit(
          const AppStateIsInRegistrationView(
            isLoading: true,
          ),
        );

        final email = event.email;
        final password = event.password;

        try {
          final credentials = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          final user = credentials.user!;

          emit(
            AppStateLoggedIn(
              user: user,
              images: const [],
              isLoading: false,
            ),
          );
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateIsInRegistrationView(
              isLoading: false,
              authError: AuthError.from(e),
            ),
          );
        }
      },
    );
    on<AppEventInitialize>(
      (event, emit) async {
        emit(
          const AppStateLogedOut(
            isLoading: true,
          ),
        );

        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          emit(
            const AppStateLogedOut(
              isLoading: false,
            ),
          );

          return;
        }

        final images = await _getImages(
          user.uid,
        );

        emit(
          AppStateLoggedIn(
            user: user,
            images: images,
            isLoading: false,
          ),
        );
      },
    );
    on<AppEventLogout>(
      (event, emit) async {
        emit(
          const AppStateLogedOut(
            isLoading: true,
          ),
        );

        await FirebaseAuth.instance.signOut();

        emit(
          const AppStateLogedOut(
            isLoading: false,
          ),
        );
      },
    );
    on<AppEventDeleteAccount>(
      (event, emit) async {
        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          emit(
            const AppStateLogedOut(
              isLoading: false,
            ),
          );

          return;
        }

        emit(
          AppStateLoggedIn(
            user: user,
            images: state.images ?? [],
            isLoading: true,
          ),
        );

        try {
          final folderContents = await FirebaseStorage.instance.ref(user.uid).listAll();

          for (final item in folderContents.items) {
            await item.delete().catchError(
                  (_) {},
                );
          }

          await FirebaseStorage.instance.ref(user.uid).delete().catchError((_) {});

          await user.delete();
          await FirebaseAuth.instance.signOut();

          emit(
            const AppStateLogedOut(
              isLoading: false,
            ),
          );
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateLoggedIn(
              user: user,
              images: state.images ?? [],
              isLoading: false,
              authError: AuthError.from(e),
            ),
          );
        } on FirebaseException {
          emit(
            AppStateLoggedIn(
              user: user,
              images: state.images ?? [],
              isLoading: false,
            ),
          );
        }
      },
    );
    on<AppEventUploadImage>(
      (event, emit) async {
        final user = state.user;

        if (user == null) {
          emit(
            const AppStateLogedOut(
              isLoading: false,
            ),
          );

          return;
        }

        emit(
          AppStateLoggedIn(
            user: user,
            images: state.images ?? [],
            isLoading: true,
          ),
        );

        final file = File(event.filePathToUpload);

        await uploadImage(
          file: file,
          userId: user.uid,
        );

        final images = await _getImages(
          user.uid,
        );

        emit(
          AppStateLoggedIn(
            user: user,
            images: images,
            isLoading: false,
          ),
        );
      },
    );
  }

  Future<Iterable<Reference>> _getImages(String userId) async {
    return FirebaseStorage.instance
        .ref(
          userId,
        )
        .list()
        .then((listResult) => listResult.items);
  }
}
