import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:test_invitech/common_widgets/async_value_widget.dart';
import 'package:test_invitech/constants/app_colors.dart';
import 'package:test_invitech/constants/app_sizes.dart';
import 'package:test_invitech/features/photo/data/album_repository.dart';
import 'package:test_invitech/features/photo/presentation/controllers/album_controller.dart';
import 'package:test_invitech/features/photo/presentation/controllers/album_states.dart';
import 'package:test_invitech/routing/app_router.dart';

class AlbumItemWidget extends ConsumerStatefulWidget {
  String albumID;
  AlbumItemWidget({super.key, required this.albumID});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return AlbumItemWidgetState();
  }
}

class AlbumItemWidgetState extends ConsumerState<AlbumItemWidget> {
  bool stateEditTitle = false;
  TextEditingController controller = TextEditingController();
  final _renameformKey = GlobalKey<FormState>();

  Future<void> onRename(AlbumState state) async {
    if (_renameformKey.currentState!.validate()) {
      await ref
          .read(AlbumControllerProvider.notifier)
          .renameAlbum(widget.albumID, controller.text);
      if (state.value.hasValue) {
        ref.invalidate(albumFutureProvider(widget.albumID));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final album = ref.watch(albumFutureProvider(widget.albumID));
    final state = ref.watch(AlbumControllerProvider);
    return AsyncValueWidget(
        value: album,
        data: (data) {
          return data == null
              ? const SizedBox()
              : GestureDetector(
                  onTap: () {
                    context.goNamed(AppRoute.photos.name, pathParameters: {'albumID': data.id!});
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(
                        Sizes.p8, Sizes.p12, Sizes.p8, 0),
                    height: 250,
                    child: Card(
                      elevation: 10,
                      shadowColor: ColorApp.grey,
                      child: Stack(
                        children: [
                          Image(image: NetworkImage(data.coverPhotoBaseUrl!)),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: ColorApp.black.withOpacity(0.5)),
                              child: Padding(
                                padding: const EdgeInsets.all(Sizes.p16),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: PopupMenuButton(
                                        color: ColorApp.white,
                                        itemBuilder: (BuildContext context) {
                                          return [
                                            PopupMenuItem(
                                              child: const Padding(
                                                padding:
                                                    EdgeInsets.all(Sizes.p8),
                                                child: Text('Rename'),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  stateEditTitle = true;
                                                });
                                              },
                                            )
                                          ];
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          stateEditTitle
                                              ? Form(
                                                  key: _renameformKey,
                                                  child: TextFormField(
                                                    validator: (value) =>
                                                        state.titleValidator(
                                                            value ?? ''),
                                                    cursorColor: ColorApp.white,
                                                    controller: controller,
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        suffixIcon:
                                                            state.value
                                                                    .isLoading
                                                                ? const Center(
                                                                    child:
                                                                        CircularProgressIndicator(),
                                                                  )
                                                                : Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          onRename(
                                                                              state);
                                                                        },
                                                                        icon:
                                                                            const Icon(
                                                                          Icons
                                                                              .check_circle,
                                                                          color:
                                                                              ColorApp.primary,
                                                                        ),
                                                                      ),
                                                                      IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            stateEditTitle =
                                                                                false;
                                                                          });
                                                                        },
                                                                        icon:
                                                                            const Icon(
                                                                          Icons
                                                                              .cancel,
                                                                          color:
                                                                              ColorApp.error,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )),
                                                    style: const TextStyle(
                                                        fontSize: Sizes.p32,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: ColorApp.white),
                                                  ),
                                                )
                                              : Text(
                                                  'Title: ${data.title}',
                                                  style: const TextStyle(
                                                      fontSize: Sizes.p32,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: ColorApp.white),
                                                ),
                                          const Divider(
                                            color: ColorApp.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        });
  }
}
