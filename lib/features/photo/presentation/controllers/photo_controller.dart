import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_invitech/features/photo/application/photo_services.dart';
import 'package:test_invitech/features/photo/data/photo_repository.dart';
import 'package:test_invitech/features/photo/presentation/controllers/album_states.dart';
import 'package:test_invitech/features/photo/presentation/controllers/photo_states.dart';
import 'package:test_invitech/untils/delay.dart';

class PhotoController extends StateNotifier<PhotoState> {
  final PhotoService photoServiceProvider;

  PhotoController({required this.photoServiceProvider}) : super(PhotoState());

  Future<void> onUpload(List<XFile> images, String albumID) async {
    state = state.copyWith(value: const AsyncValue.loading());
    try {
      await photoServiceProvider.pickUploadAndBatchCreateImages(images, albumID);
      await delay(true);
      state = state.copyWith(value: const AsyncValue.data(null));
    } catch (e, stack) {
      state = state.copyWith(value: AsyncValue.error(e, stack));
    }
  }
}

final photoControllerProvider = StateNotifierProvider<PhotoController, PhotoState>((ref) {
  final photoRepository = ref.watch(photoServiceProvider);
  return PhotoController(photoServiceProvider: photoRepository);
});
