import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/cloudsearch/v1.dart';
import 'package:test_invitech/common_widgets/text_form_field_app.dart';
import 'package:test_invitech/constants/app_colors.dart';
import 'package:test_invitech/constants/app_sizes.dart';
import 'package:test_invitech/features/photo/data/album_repository.dart';
import 'package:test_invitech/features/photo/presentation/controllers/album_controller.dart';

class FormAddAlbum extends ConsumerWidget {
  final _albumformKey = GlobalKey<FormState>();
  final VoidCallback onSubmitSuccess;
  final _titleController = TextEditingController();
  final _node = FocusScopeNode();

  FormAddAlbum({super.key, required this.onSubmitSuccess});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(AlbumControllerProvider);
    return FocusScope(
        node: _node,
        child: Form(
            key: _albumformKey,
            child: SizedBox(
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormFieldApp(
                      validator: (value) => state.titleValidator(value ?? ''),
                      controller: _titleController,
                      hintText: 'Enter title: ',
                      labelText: 'Title',
                      icon: Icons.photo_album_outlined),
                  state.value.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            if (_albumformKey.currentState!.validate()) {
                              await ref
                                  .read(AlbumControllerProvider.notifier)
                                  .createAlbum(_titleController.text);
                              if (state.value.hasValue) {
                                onSubmitSuccess();
                                Navigator.of(context).pop();
                              }
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(ColorApp.primary),
                              foregroundColor:
                                  MaterialStateProperty.all(ColorApp.white)),
                          child: const Text('Create',
                              style: TextStyle(
                                  fontSize: Sizes.p16,
                                  fontWeight: FontWeight.bold)))
                ],
              ),
            )));
  }
}
