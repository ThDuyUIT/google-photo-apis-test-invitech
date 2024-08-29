import 'dart:ffi';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_invitech/features/auth/data/auth_repository.dart';
import 'package:test_invitech/features/auth/presentation/controllers/auth_state.dart';
import 'package:test_invitech/untils/delay.dart';

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  AuthController({required this.authRepository}) : super(AuthState());

  Future<bool> onLogin() async {
    state = state.copyWith(value: const AsyncValue.loading());
    final result = await authRepository.login();
    await delay(true);
    state = state.copyWith(value: const AsyncValue.data(null));
    return result;
  }

  Future<bool> onLogout() async {
    // state = state.copyWith(value: const AsyncValue.loading());
    final result = await authRepository.logout();
    await delay(true);
    return result;
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository);
});
