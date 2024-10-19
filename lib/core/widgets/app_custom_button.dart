import 'package:flutter/material.dart';
import 'package:route_finder/core/resources/color_file.dart';

class AppCustomButton extends StatefulWidget {
  final String text;
  final Function()? onPressed;
  const AppCustomButton({super.key, required this.text, this.onPressed});

  @override
  State<AppCustomButton> createState() => _AppCustomButtonState();
}

class _AppCustomButtonState extends State<AppCustomButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            Colors.white,
          ),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))))),
      child: Text(
        widget.text,
        style: const TextStyle(color: ColorFile.primaryColor),
      ),
    );
  }
}
