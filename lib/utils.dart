import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

final IMAGE_POST_URL = 'https://screenshot-manager.herokuapp.com/api/test';

final primaryColor = Color(0xFF34495E);
final accentColor = Color(0xFF798EA5);

final headingTextStyle = TextStyle(
  color: primaryColor,
  fontSize: 25,
  fontWeight: FontWeight.bold,
);

class Utility {
  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fitWidth,
    );
  }
}
