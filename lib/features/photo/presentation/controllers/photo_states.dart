import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhotoState {
  final AsyncValue<void> value;

  PhotoState({this.value = const AsyncValue.data(null)});

  PhotoState copyWith({AsyncValue<void>? value}) {
    return PhotoState(value: value ?? this.value);
  }
}