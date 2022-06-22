import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learning_bloc/bloc/app_bloc.dart';
import 'package:learning_bloc/bloc/app_event.dart';
import 'package:learning_bloc/bloc/app_state.dart';
import 'package:learning_bloc/view/main_popup_menu_button.dart';
import 'package:learning_bloc/view/storage_image_view.dart';

class PhotoGalleryView extends HookWidget {
  const PhotoGalleryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imagePicker = useMemoized(
      () => ImagePicker(),
      [key],
    );
    final images = context.watch<AppBloc>().state.images ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery,'),
        actions: [
          IconButton(
            onPressed: () async {
              final appBloc = context.read<AppBloc>();

              final image = await imagePicker.pickImage(
                source: ImageSource.gallery,
              );

              if (image != null) {
                appBloc.add(
                  AppEventUploadImage(
                    filePathToUpload: image.path,
                  ),
                );
              }
            },
            icon: const Icon(
              Icons.upload,
            ),
          ),
          const MainPopupMenuButton(),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(8),
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: images
            .map(
              (image) => StorageImageView(
                image: image,
              ),
            )
            .toList(),
      ),
    );
  }
}
