import 'package:flutter/material.dart';


class ButtonApp extends StatelessWidget {
  final IconData? icon;
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final double borderRadius;

  const ButtonApp(
      {super.key,
      required this.icon,
      required this.label,
      required this.onPressed,
      required this.backgroundColor,
      required this.foregroundColor,
      required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: double.infinity,
      child: icon == null
      ?TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
            backgroundColor:
                MaterialStateProperty.resolveWith((states) => backgroundColor),
            foregroundColor:
                MaterialStateProperty.resolveWith((states) => foregroundColor),
          ),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ))
      :TextButton.icon(
          onPressed: onPressed,
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
            backgroundColor:
                MaterialStateProperty.resolveWith((states) => backgroundColor),
            foregroundColor:
                MaterialStateProperty.resolveWith((states) => foregroundColor),
          ),
          icon: Icon(
            icon,
          ),
          label: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )),
    );
  }
}
