import 'package:flutter/services.dart';

class WebViewCapture {
  const WebViewCapture({MethodChannel? channel})
    : _channel = channel ?? _defaultChannel;

  static const _defaultChannel = MethodChannel('dev.jotalopez.webview_capture');

  final MethodChannel _channel;

  /// Renders the whole document of the WebView with [webViewIdentifier]
  /// (`AndroidWebViewController.webViewIdentifier`), not just the visible
  /// viewport, and returns it as PNG bytes.
  Future<Uint8List> capturePng({required int webViewIdentifier}) async {
    final bytes = await _channel.invokeMethod<Uint8List>('capturePng', {
      'identifier': webViewIdentifier,
    });
    if (bytes == null) throw StateError('Empty WebView capture.');
    return bytes;
  }
}
