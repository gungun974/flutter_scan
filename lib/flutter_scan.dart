import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class FlutterScan {
  static const MethodChannel _channel =
      const MethodChannel('fr.gungun974/flutter_scan');

  static Future<File> scan() async {
    try {
      var result = await _channel.invokeMethod('scan');
      if (result is String) {
        return new File(result);
      }
      return null;
    } on MissingPluginException {
      return null;
    }
  }
}
