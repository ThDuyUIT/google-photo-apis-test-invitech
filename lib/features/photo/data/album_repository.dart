import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/photoslibrary/v1.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;
import 'package:test_invitech/features/auth/data/auth_repository.dart';

abstract class IAlbumRepository {
  Stream<List<Album>> listAlbum();
  Future<Album?> getAlbum(String albumID);
  Future<void> createAlbum(Album album);
  Future<void> deleteAlbum(String albumID);
  Future<void> patchTitle(String albumID, String newTitle);
}

class AlbumRepository implements IAlbumRepository {
  Ref ref;
  AlbumRepository(this.ref);

  @override
  Stream<List<Album>> listAlbum() async* {
    auth.AuthClient? client =
        await ref.watch(authRepositoryProvider).fetchAuthClient();

    if (client == null) {
      print('authClient is null');
      yield [];
    }

    try {
      final response = await client!.get(
          Uri.parse('https://photoslibrary.googleapis.com/v1/albums'),
          headers: {
            'Authorization': 'Bearer ${client.credentials.accessToken.data}',
          });

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> albumsJson = jsonResponse['albums'] ?? [];
        final albumsModelData =
            albumsJson.map((e) => Album.fromJson(e)).toList();
        yield albumsModelData;
      } else {
        yield [];
      }
    } on Exception catch (e) {
      print(e);
      yield [];
    }
  }

  @override
  Future<Album?> getAlbum(String albumID) async {
    auth.AuthClient? client =
        await ref.watch(authRepositoryProvider).fetchAuthClient();

    if (client == null) {
      print('authClient is null');
      return null;
    }

    try {
      final response = await client.get(
          Uri.parse('https://photoslibrary.googleapis.com/v1/albums/$albumID'),
          headers: {
            'Authorization': 'Bearer ${client.credentials.accessToken.data}',
          });
      if (response.statusCode == 200) {
        // print(response.body);
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final albumsJson = jsonResponse;
        final albumsModelData = Album.fromJson(albumsJson);
        return albumsModelData;
      } else {
        return null;
      }
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<void> deleteAlbum(String albumID) {
    // TODO: implement deleteAlbum
    throw UnimplementedError();
  }

  @override
  Future<void> patchTitle(String albumID, String newTitle) async {
    print(albumID);
    auth.AuthClient? client =
        await ref.watch(authRepositoryProvider).fetchAuthClient();

    if (client == null) {
      print('authClient is null');
      return;
    }

    try {
      final response = await client.patch(
        Uri.parse(
            'https://photoslibrary.googleapis.com/v1/albums/$albumID?updateMask=title'),
        headers: {
          'Authorization': 'Bearer ${client.credentials.accessToken.data}',
          'Content-Type': 'application/json', // Specify JSON content type
        },
        body: jsonEncode({
          'title': newTitle,
        }),
      );

      if (response.statusCode == 200) {
        print('Album title updated successfully.');
      } else {
        print(
            'Failed to update album title. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } on Exception catch (e) {
      print('Error updating album title: $e');
    }
  }

  @override
  Future<void> createAlbum(Album album) async {
    
    auth.AuthClient? client =
        await ref.watch(authRepositoryProvider).fetchAuthClient();

    if (client == null) {
      print('authClient is null');
      return;
    }
    try {
      final response = await client.post(
        Uri.parse('https://photoslibrary.googleapis.com/v1/albums'),
        headers: {
          'Authorization': 'Bearer ${client.credentials.accessToken.data}',
          'Content-Type': 'application/json', // Specify JSON content type
        },
        body: jsonEncode({
          'album': {
            'title': album.title
          }
        }),
      );
      if (response.statusCode == 200) {
        print('New album was created successfully.');
      } else {
        print(
            'Failed to create new album. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error creating new album: $e');
    }
  }
}

final albumRepositoryProvider = Provider((ref) => AlbumRepository(ref));

final albumsStreamDataProvider =
    StreamProvider((ref) => ref.watch(albumRepositoryProvider).listAlbum());

final albumFutureProvider = FutureProvider.family<Album?, String>(
  (ref, albumID) => ref.watch(albumRepositoryProvider).getAlbum(albumID),
);
