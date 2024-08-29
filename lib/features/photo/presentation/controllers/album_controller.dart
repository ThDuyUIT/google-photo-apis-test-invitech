import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/photoslibrary/v1.dart';
import 'package:test_invitech/features/photo/data/album_repository.dart';
import 'package:test_invitech/features/photo/domain/album_model.dart';
import 'package:test_invitech/features/photo/presentation/controllers/album_states.dart';
import 'package:test_invitech/untils/delay.dart';

class AlbumController extends StateNotifier<AlbumState> {
  final AlbumRepository albumRepositoryProvider;

  AlbumController({required this.albumRepositoryProvider}) : super(AlbumState());

  Future<void> createAlbum(String title) async {
    state = state.copyWith(value: const AsyncValue.loading());
    DateTime now = DateTime.now();
    final id = now.millisecondsSinceEpoch.toString();
    final albumData = Album(id: id, title: title);
    try {
      await albumRepositoryProvider.createAlbum(albumData);
      await delay(true);
      state = state.copyWith(value: const AsyncValue.data(null));
    } catch (e, stack) {
      state = state.copyWith(value: AsyncValue.error(e, stack));
    }
  }

  Future<void> renameAlbum(String albumID, String name) async {
    state = state.copyWith(value: const AsyncValue.loading());
    try {
      await albumRepositoryProvider.patchTitle(albumID, name);
      await delay(true);
      state = state.copyWith(value: const AsyncValue.data(null));
    } catch (e, stack) {
      state = state.copyWith(value: AsyncValue.error(e, stack));
    }
  }
}

final AlbumControllerProvider =
    StateNotifierProvider<AlbumController, AlbumState>((ref) {
  final albumRepository = ref.watch(albumRepositoryProvider);
  return AlbumController(albumRepositoryProvider: albumRepository);
});
