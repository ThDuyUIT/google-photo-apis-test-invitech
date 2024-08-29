import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final AsyncValue<void> value;

  AuthState({this.value = const AsyncValue.data(null)});

  AuthState copyWith({AsyncValue<void>? value}) {
    return AuthState(value: value ?? this.value);
  }
}
