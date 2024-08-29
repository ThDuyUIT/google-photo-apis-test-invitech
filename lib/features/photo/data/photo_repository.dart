import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/photoslibrary/v1.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;
import 'package:image_picker/image_picker.dart';
import 'package:test_invitech/features/auth/data/auth_repository.dart';

abstract class IPhotoRepository {
  Stream<List<MediaItem>> listMediaItems(String albumID);
  Future<MediaItem?> getPhoto(String photoID);
  Future<String?> uploadImageFile(XFile? pickedFile);
  Future<void> batchCreateImages(List<String> uploadTokens,  String albumID);
}

class PhotoRepository implements IPhotoRepository {
  Ref ref;
  PhotoRepository(this.ref);
  // String pageToken = '';

  @override
  Stream<List<MediaItem>> listMediaItems(String albumID) async* {
    auth.AuthClient? client =
        await ref.watch(authRepositoryProvider).fetchAuthClient();

    if (client == null) {
      print('authClient is null');
      yield [];
    }
    try {
      final response = await client!.post(
          Uri.parse(
              'https://photoslibrary.googleapis.com/v1/mediaItems:search'),
          headers: {
            'Authorization': 'Bearer ${client.credentials.accessToken.data}',
          },
          body: jsonEncode({
            'albumId': albumID,
            'pageSize': 100
            //'pageToken': pageToken
          }));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> mediaItemsJson = jsonResponse['mediaItems'] ?? [];

        final mediaItemsData =
            mediaItemsJson.map((e) => MediaItem.fromJson(e)).toList();
        final photosModelData = mediaItemsData
            .where((element) => element.mimeType!.contains('image'));

        yield photosModelData.toList();
      } else {
        yield [];
      }
    } catch (e) {
      print(e);
      yield [];
    }
  }

  @override
  Future<MediaItem?> getPhoto(String photoID) async {
    auth.AuthClient? client =
        await ref.watch(authRepositoryProvider).fetchAuthClient();

    if (client == null) {
      print('authClient is null');
      return null;
    }
    try {
      final response = await client.get(
        Uri.parse(
            'https://photoslibrary.googleapis.com/v1/mediaItems/$photoID'),
        headers: {
          'Authorization': 'Bearer ${client.credentials.accessToken.data}',
        },
      );
      if (response.statusCode == 200) {
        print(response.body);
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final photoJson = jsonResponse;
        final photoModelData = MediaItem.fromJson(photoJson);
        return photoModelData;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<String?> uploadImageFile(XFile? pickedFile) async {
    auth.AuthClient? client =
        await ref.watch(authRepositoryProvider).fetchAuthClient();

    if (client == null) {
      print('authClient is null');
      return null;
    }
    final file = File(pickedFile!.path);
    final uploadEndpoint =
        Uri.parse('https://photoslibrary.googleapis.com/v1/uploads');

    final headers = {
      'Authorization': 'Bearer ${client.credentials.accessToken.data}',
      'Content-Type': 'application/octet-stream',
      'X-Goog-Upload-Content-Type': 'image/jpeg',
      'X-Goog-Upload-Protocol': 'raw',
    };

    final response = await client.post(uploadEndpoint,
        headers: headers, body: file.readAsBytesSync());

    if (response.statusCode == 200) {

      return response.body;
    } else {
      print('Upload failed with status: ${response.statusCode}');
      return null;
    }
  }
  
  @override
  Future<void> batchCreateImages(List<String> uploadTokens, String albumID) async {
    auth.AuthClient? client =
        await ref.watch(authRepositoryProvider).fetchAuthClient();

    if (client == null) {
      print('authClient is null');
      return;
    }
    final PhotosLibraryApi photosApi = PhotosLibraryApi(client);
  final BatchCreateMediaItemsRequest request = BatchCreateMediaItemsRequest(
    newMediaItems: uploadTokens.map((token) {
      return NewMediaItem(
        simpleMediaItem: SimpleMediaItem(uploadToken: token),
      );
    }).toList(), albumId: albumID
  );

  final response = await photosApi.mediaItems.batchCreate(request);

  if (response.newMediaItemResults != null) {
    for (final result in response.newMediaItemResults!) {
      if (result.status?.code == 0) {
        print('Image created: ${result.mediaItem?.id}');
      } else {
        print('Failed to create image: ${result.status?.message}');
      }
    }
  } else {
    print('Batch create failed.');
  }
  }



}


final photoRepositoryProvider = Provider((ref) => PhotoRepository(ref));

final photosStreamProvider =
    StreamProvider.family<List<MediaItem>, String>((ref, albumID) {
  return ref.watch(photoRepositoryProvider).listMediaItems(albumID);
});

final photoFutureProvider = FutureProvider.family<MediaItem?, String>(
  (ref, photoID) => ref.watch(photoRepositoryProvider).getPhoto(photoID),
);
