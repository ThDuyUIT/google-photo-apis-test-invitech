import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_invitech/common_widgets/async_value_widget.dart';
import 'package:test_invitech/constants/app_colors.dart';
import 'package:test_invitech/constants/app_sizes.dart';
import 'package:test_invitech/features/photo/data/album_repository.dart';
import 'package:test_invitech/features/photo/domain/album_model.dart'
    as myAlbum;
import 'package:test_invitech/features/photo/presentation/widgets/album_item_widget.dart';

class ListAlbumWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return ListAlbumWidgetState();
  }
}

class ListAlbumWidgetState extends ConsumerState<ListAlbumWidget> {
  @override
  Widget build(BuildContext context) {
    final albums = ref.watch(albumsStreamDataProvider);
    return AsyncValueWidget(
        value: albums,
        data: (data) {
          return data.isEmpty
              ? const Center(
                  child: Text('Empty Collections!'),
                )
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return AlbumItemWidget(albumID: data[index].id!);
                  });
        });
  }
}
