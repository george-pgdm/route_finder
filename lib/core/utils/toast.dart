import 'package:flutter/material.dart';

import '../resources/color_file.dart';

void toast(BuildContext context, String msg) {
  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        msg,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      duration: const Duration(
        milliseconds: 3000,
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: ColorFile.primaryColor,
      showCloseIcon: true,
      closeIconColor: Colors.white70,
      dismissDirection: DismissDirection.down,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),
    ),
  );
}
