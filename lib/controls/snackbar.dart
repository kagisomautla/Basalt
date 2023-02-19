import 'package:basalt/controls/text.dart';
import 'package:flutter/material.dart';

void snackBarControl({required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.lightBlueAccent,
      content: TextControl(
        text: message,
        color: Colors.white,
      ),
    ),
  );
}
