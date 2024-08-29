import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_invitech/common_widgets/async_value_widget.dart';
import 'package:test_invitech/constants/app_colors.dart';
import 'package:test_invitech/constants/app_sizes.dart';
import 'package:test_invitech/features/photo/data/album_repository.dart';
import 'package:test_invitech/features/photo/data/photo_repository.dart';
import 'package:test_invitech/features/photo/presentation/controllers/photo_controller.dart';
import 'package:test_invitech/routing/app_router.dart';

class GridPhotosWidget extends ConsumerStatefulWidget {
  final String albumID;

  const GridPhotosWidget({super.key, required this.albumID});

  @override
  ConsumerState<GridPhotosWidget> createState() => _GridPhotosWidgetState();
}

class _GridPhotosWidgetState extends ConsumerState<GridPhotosWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  Future<List<XFile>> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    return images;
  }

  @override
  Widget build(BuildContext context) {
    final photos = ref.watch(photosStreamProvider(widget.albumID));
    final album = ref.watch(albumFutureProvider(widget.albumID));
    final state = ref.watch(photoControllerProvider);
    return SafeArea(
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final pickedImages = await pickImages();
              if (pickedImages.isNotEmpty) {
                await ref
                    .watch(photoControllerProvider.notifier)
                    .onUpload(pickedImages, widget.albumID);
                if (state.value.hasValue) {
                  ref.invalidate(albumFutureProvider(widget.albumID));
                  ref.invalidate(photosStreamProvider(widget.albumID));
                }
              }
            },
            backgroundColor: ColorApp.primary,
            foregroundColor: ColorApp.white,
            child: const Icon(Icons.add),
          ),
          appBar: AppBar(
            backgroundColor: ColorApp.primary,
            foregroundColor: ColorApp.white,
            centerTitle: true,
            title: Text(
              album.value!.title!,
              style: const TextStyle(
                  fontSize: Sizes.p20, fontWeight: FontWeight.bold),
            ),
          ),
          body: AsyncValueWidget(
              value: photos,
              data: (data) {
                return GridView.builder(
                  padding: const EdgeInsets.all(Sizes.p8),
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: Sizes.p12,
                    mainAxisSpacing: Sizes.p12,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        context.goNamed(AppRoute.photo.name, pathParameters: {
                          'photoID': data[index].id!,
                          'albumID': widget.albumID
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                        child: Image(image: NetworkImage(data[index].baseUrl!)),
                      ),
                    );
                  },
                );
              })),
    );
  }
}
