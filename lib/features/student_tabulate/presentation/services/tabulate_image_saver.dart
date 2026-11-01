import 'dart:typed_data';

import 'package:gal/gal.dart';
import 'package:webview_capture/webview_capture.dart';

typedef GallerySave = Future<void> Function(Uint8List bytes, String name);

class TabulateImageSaver {
  const TabulateImageSaver({
    this.capture = const WebViewCapture(),
    this.saveToGallery = _saveWithGal,
  });

  final WebViewCapture capture;
  final GallerySave saveToGallery;

  static Future<void> _saveWithGal(Uint8List bytes, String name) =>
      Gal.putImageBytes(bytes, name: name);

  Future<void> save({required int webViewIdentifier}) async {
    final bytes = await capture.capturePng(
      webViewIdentifier: webViewIdentifier,
    );
    final stamp = DateTime.now().millisecondsSinceEpoch;
    await saveToGallery(bytes, 'tabulado_$stamp');
  }
}
