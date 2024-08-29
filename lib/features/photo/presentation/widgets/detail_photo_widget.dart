import 'dart:async';

import 'package:fl_downloader/fl_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_invitech/common_widgets/async_value_widget.dart';
import 'package:test_invitech/constants/app_colors.dart';
import 'package:test_invitech/features/photo/data/photo_repository.dart';

class DetailPhotoWidget extends ConsumerStatefulWidget {
  String photoID;
  DetailPhotoWidget({super.key, required this.photoID});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return DetailPhotoWidgetState();
  }
}

class DetailPhotoWidgetState extends ConsumerState<DetailPhotoWidget> {
  int progress = 0;
  late StreamSubscription progressStream;
  @override
  void initState() {
    FlDownloader.initialize();
    progressStream = FlDownloader.progressStream.listen((event) {
      if (event.status == DownloadStatus.successful) {
        debugPrint('event.progress: ${event.progress}');
        setState(() {
          progress = event.progress;
        });
        // This is a way of auto-opening downloaded file right after a download is completed
        FlDownloader.openFile(filePath: event.filePath);
      } else if (event.status == DownloadStatus.running) {
        debugPrint('event.progress: ${event.progress}');
        setState(() {
          progress = event.progress;
        });
      } else if (event.status == DownloadStatus.failed) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: ColorApp.error,
            content: Text(
              'Download fail!',
              style: TextStyle(color: ColorApp.white),
            )));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    progressStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final photo = ref.watch(photoFutureProvider(widget.photoID));
    return SafeArea(
      child: AsyncValueWidget(
          value: photo,
          data: (data) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: ColorApp.primary,
                foregroundColor: ColorApp.white,
                title: Text(data!.filename!),
                actions: [
                  IconButton(
                      onPressed: () async {
                        final permission =
                            await FlDownloader.requestPermission();
                        if (permission == StoragePermissionStatus.granted) {
                          await FlDownloader.download(
                            data.baseUrl!,
                            fileName: data.filename,
                          );
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  backgroundColor: ColorApp.error,
                                  content: Text(
                                    'Permission denied =(',
                                    style: TextStyle(color: ColorApp.white),
                                  )));
                        }
                      },
                      icon: const Icon(Icons.download_rounded))
                ],
              ),
              body: Container(
                color: ColorApp.basic,
                width: double.infinity,
                //height: double.infinity,
                child: Center(
                  child: Image(image: NetworkImage(data.baseUrl!)),
                ),
              ),
            );
          }),
    );
  }
}
