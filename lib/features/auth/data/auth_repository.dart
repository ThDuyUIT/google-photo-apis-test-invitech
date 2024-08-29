import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/photoslibrary/v1.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;

abstract class IAuthRepository {
  Future<bool> login();
  Future<bool> logout();
}

class AuthRepository implements IAuthRepository{
  Ref ref;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      PhotosLibraryApi.photoslibraryScope,
      PhotosLibraryApi.photoslibraryEditAppcreateddataScope
    ],
  );
  GoogleSignInAccount? _user;
  GoogleSignInAuthentication? googleAuth;
  AuthRepository(this.ref);

  @override
  Future<bool> login() async {
    try {
      _user = await _googleSignIn.signIn();
      if (_user != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _googleSignIn.signOut();
      return true;
    } catch (error) {
      return false;
    }
  }

  GoogleSignInAccount? getUser()  {
    return _user;
  }

  Future<auth.AuthClient?> fetchAuthClient() async {
    return await _googleSignIn.authenticatedClient();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository(ref));

final fetchAuthClientProvider =
    FutureProvider((ref) => ref.watch(authRepositoryProvider).fetchAuthClient());
