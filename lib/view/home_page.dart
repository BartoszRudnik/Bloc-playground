import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_bloc/bloc/bottom_bloc.dart';
import 'package:learning_bloc/bloc/top_bloc.dart';
import 'package:learning_bloc/models/constants.dart';
import 'package:learning_bloc/view/app_bloc_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<TopBloc>(
              create: (context) => TopBloc(
                urls: images,
                waitBeforeLoading: const Duration(
                  seconds: 3,
                ),
                urlPicker: null,
                urlLoader: null,
              ),
            ),
            BlocProvider<BottomBloc>(
              create: (context) => BottomBloc(
                urls: images,
                waitBeforeLoading: const Duration(
                  seconds: 3,
                ),
                urlPicker: null,
                urlLoader: null,
              ),
            ),
          ],
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              AppBlocView(),
              AppBlocView(),
            ],
          ),
        ),
      ),
    );
  }
}
