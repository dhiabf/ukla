import 'package:flutter/material.dart';

class Helpers {
  static void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static bool isVideoLengthValid(Duration duration) {
    return duration.inSeconds >= 30; // Check if the video is at least 30 seconds
  }
}
