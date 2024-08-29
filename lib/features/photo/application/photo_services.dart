import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/photoslibrary/v1.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_invitech/features/photo/data/photo_repository.dart';

class PhotoService {
  Ref ref;
  PhotoService(this.ref);

  Future<void> pickUploadAndBatchCreateImages(List<XFile> images, String albumID) async {
    final photoRepository = ref.watch(photoRepositoryProvider);
    List<String> uploadTokens = [];
    for (final image in images) {
      final token = await photoRepository.uploadImageFile(image);
      if (token != null) {
        uploadTokens.add(token);
      }
    }

    if (uploadTokens.isNotEmpty) {
      await photoRepository.batchCreateImages(uploadTokens, albumID);
    } else {
      print('No images were uploaded.');
    }
    //print('Authentication failed.');
  }
}

final photoServiceProvider = Provider((ref) => PhotoService(ref));
