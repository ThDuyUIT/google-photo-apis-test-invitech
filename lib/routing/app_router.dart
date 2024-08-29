import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:googleapis/photoslibrary/v1.dart';
import 'package:test_invitech/features/photo/presentation/widgets/album_screen.dart';
import 'package:test_invitech/features/auth/presentation/widgets/login_screen.dart';
import 'package:test_invitech/features/auth/presentation/widgets/logout_screen.dart';
import 'package:test_invitech/features/photo/presentation/widgets/detail_photo_widget.dart';
import 'package:test_invitech/features/photo/presentation/widgets/grids_photos_widget.dart';

enum AppRoute { login, logout, album, photos, photo }

final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
        path: '/',
        name: AppRoute.login.name,
        pageBuilder: (context, state) =>
            MaterialPage(fullscreenDialog: true, child: LoginScreen()),
        routes: [
          GoRoute(
              path: 'album',
              name: AppRoute.album.name,
              builder: (context, state) {
                return AlbumScreen();
              },
              routes: [
                GoRoute(
                    path: 'album/:albumID',
                    name: AppRoute.photos.name,
                    builder: (context, state) {
                      final albumID = state.pathParameters['albumID']!;
                      return GridPhotosWidget(albumID: albumID);
                    },
                    routes: [
                      GoRoute(
                          path: 'photo/:photoID',
                          name: AppRoute.photo.name,
                          pageBuilder: (context, state) {
                            final photoID = state.pathParameters['photoID']!;
                            return MaterialPage(
                                fullscreenDialog: true,
                                child: DetailPhotoWidget(
                                  photoID: photoID,
                                ));
                          }),
                    ]),
              ]),
        ]),
  ],
);
