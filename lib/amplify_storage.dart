// You have generated a new plugin project without
// specifying the `--platforms` flag. A plugin project supports no platforms is generated.
// To add platforms, run `flutter create -t plugin --platforms <platforms> .` under the same
// directory. You can also find a detailed instruction on how to add platforms in the `pubspec.yaml` at https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'dart:async';

import 'package:flutter/services.dart';

class AmplifyStorage {
  static const MethodChannel _channel = const MethodChannel('amplify_storage');

  static Future<void> initialize({Function(dynamic) onError}) async {
    try {
      await _channel.invokeMethod("initialize");
    } catch (e) {
      if (onError != null)
        onError(e);
      else
        print(e);
    }
  }

  static Future<bool> uploadFile(String path, String key,
      {Function(dynamic) onError}) async {
    try {
      final result = await _channel.invokeMethod("uploadFile", {
        "path": path,
        "key": key,
      });

      return result;
    } catch (e) {
      if (onError != null)
        onError(e);
      else
        print(e);

      return false;
    }
  }
}
