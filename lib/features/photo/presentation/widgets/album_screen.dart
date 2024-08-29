import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_invitech/common_widgets/app_bar/my_app_bar_widget.dart';
import 'package:test_invitech/constants/app_colors.dart';
import 'package:test_invitech/features/photo/data/album_repository.dart';
import 'package:test_invitech/features/photo/presentation/widgets/form_add_album.dart';
import 'package:test_invitech/features/photo/presentation/widgets/list_albums_widget.dart';
import 'package:test_invitech/untils/delay.dart';

class AlbumScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return AlbumScreenState();
  }
}

class AlbumScreenState extends ConsumerState<ConsumerStatefulWidget> {
  Future<void> onCreateAlbum() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Create new an album',
              style: TextStyle(
                  color: ColorApp.primary, fontWeight: FontWeight.bold),
            ),
            content: FormAddAlbum(
                onSubmitSuccess: () =>
                    ref.invalidate(albumsStreamDataProvider)),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: MyAppBar(),
      body: RefreshIndicator(
          onRefresh: () async {
            await delay(true);
            ref.invalidate(albumsStreamDataProvider);
          },
          child: ListAlbumWidget()),
      floatingActionButton: FloatingActionButton(
        onPressed: onCreateAlbum,
        backgroundColor: ColorApp.primary,
        foregroundColor: ColorApp.white,
        child: const Icon(Icons.add),
      ),
    ));
  }
}
