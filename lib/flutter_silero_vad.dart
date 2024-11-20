import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'flutter_silero_vad_platform_interface.dart';

class FlutterSileroVad {
  Future<String> _onnxModelToLocal() async {
    final data = await rootBundle
        .load('packages/flutter_silero_vad/assets/silero_vad.v5.onnx');
    final bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    final path =
        '${(await getApplicationSupportDirectory()).path}/silero_vad.v5.onnx';
    File(path).writeAsBytesSync(bytes);
    return path;
  }

  Future<String?> initialize({
    required int sampleRate,
    required int frameSize,
    required double threshold,
    required int minSilenceDurationMs,
    required int speechPadMs,
  }) async {
    final path = await _onnxModelToLocal();

    return FlutterSileroVadPlatform.instance.initialize(
      modelPath: path,
      sampleRate: sampleRate,
      frameSize: frameSize,
      threshold: threshold,
      minSilenceDurationMs: minSilenceDurationMs,
      speechPadMs: speechPadMs,
    );
  }

  Future<void> resetState() {
    return FlutterSileroVadPlatform.instance.resetState();
  }

  Future<bool?> predict(Float32List data) {
    return FlutterSileroVadPlatform.instance.predict(data);
  }
}
