import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_invitech/services/string_validators.dart';

mixin FormAlbumValidators {
  final StringValidator minTitleValidator = MinLengthStringValidator(5);
}

class AlbumState with FormAlbumValidators {
  final AsyncValue<void> value;

  AlbumState({this.value = const AsyncValue.data(null)});

  AlbumState copyWith({AsyncValue<void>? value}) {
    return AlbumState(value: value ?? this.value);
  }

  bool isValidTitle(String title) => minTitleValidator.isValid(title);

  String? titleValidator(String title) {
    String errorText;
    if (title.isEmpty) {
      errorText = 'Length of title is empty!!';
      return errorText;
    }
    final bool showErrorText = !isValidTitle(title);
    errorText = 'Length of title is greater 4!!';
    return showErrorText ? errorText : null;
  }
}
