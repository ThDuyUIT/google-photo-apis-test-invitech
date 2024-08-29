import 'package:flutter/material.dart';
import 'package:test_invitech/constants/app_colors.dart';

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget(this.errorMessage, {super.key});
  final String errorMessage;
  @override
  Widget build(BuildContext context) {
    return Text(
      errorMessage,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: ColorApp.error),
    );
  }
}