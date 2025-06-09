// core/utils/notifier.dart

import 'package:flutter/material.dart';

class Notifier {
  static void showSnackbar(BuildContext context, String message, {Color color = Colors.black87}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
