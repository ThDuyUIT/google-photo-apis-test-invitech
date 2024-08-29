import 'package:flutter/material.dart';
import 'package:test_invitech/constants/app_colors.dart';
import 'package:test_invitech/constants/app_sizes.dart';

class TextFormFieldApp extends StatelessWidget {
  final String hintText;
  final String labelText;
  final IconData icon;
  final String? Function(String?)? validator;
  final void Function()? onEditingComplete;
  final TextEditingController? controller;
  final bool isNumInput;
  final bool isReadOnly;

  const TextFormFieldApp(
      {super.key,
      required this.hintText,
      required this.labelText,
      required this.icon,
      this.validator,
      this.onEditingComplete,
      this.controller,
      this.isNumInput = false,
      this.isReadOnly = false
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: isReadOnly,
      keyboardType: isNumInput ? TextInputType.number: null,
      controller: controller,
      validator: validator,
      onEditingComplete: onEditingComplete,
      style: const TextStyle(
        fontSize: Sizes.p16,
        color: ColorApp.black,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: Sizes.p16,
          fontWeight: FontWeight.bold,
          color: ColorApp.black,
        ),
        hintStyle: const TextStyle(
          fontSize: Sizes.p12,
          color: ColorApp.grey,
        ),
        suffixIcon: Icon(
          icon,
          color: ColorApp.primary,
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorApp.primary, width: 3),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorApp.primary, width: 3),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorApp.primary, width: 3),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorApp.primary, width: 2),
        ),
      ),
    );
  }
}
