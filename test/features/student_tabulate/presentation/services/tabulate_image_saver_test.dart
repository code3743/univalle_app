import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/student_tabulate/presentation/services/tabulate_image_saver.dart';
import 'package:webview_capture/webview_capture.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('test/webview_capture');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  test('captures the WebView and hands the PNG to the gallery', () async {
    Object? sentArguments;
    messenger.setMockMethodCallHandler(channel, (call) async {
      sentArguments = call.arguments;
      return Uint8List.fromList([1, 2, 3]);
    });
    Uint8List? saved;
    final saver = TabulateImageSaver(
      capture: const WebViewCapture(channel: channel),
      saveToGallery: (bytes, name) async => saved = bytes,
    );

    await saver.save(webViewIdentifier: 7);

    expect(sentArguments, {'identifier': 7});
    expect(saved, [1, 2, 3]);
  });

  test('throws when the native side returns nothing', () async {
    messenger.setMockMethodCallHandler(channel, (_) async => null);
    final saver = TabulateImageSaver(
      capture: const WebViewCapture(channel: channel),
      saveToGallery: (_, _) async {},
    );

    expect(saver.save(webViewIdentifier: 1), throwsStateError);
  });
}
