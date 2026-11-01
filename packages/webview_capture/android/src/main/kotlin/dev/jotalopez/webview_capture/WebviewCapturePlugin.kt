package dev.jotalopez.webview_capture

import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.webkit.WebView
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugins.webviewflutter.WebViewFlutterAndroidExternalApi
import java.io.ByteArrayOutputStream

class WebviewCapturePlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var binding: FlutterPlugin.FlutterPluginBinding

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        // Must run before the first WebView exists, otherwise draw() only
        // paints the visible viewport instead of the whole document.
        WebView.enableSlowWholeDocumentDraw()
        this.binding = binding
        channel = MethodChannel(binding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method != "capturePng") {
            result.notImplemented()
            return
        }
        val identifier = call.argument<Number>("identifier")?.toLong()
        val webView = identifier?.let {
            WebViewFlutterAndroidExternalApi.getWebView(binding, it)
        }
        if (webView == null) {
            result.error("no_webview", "WebView not found", null)
            return
        }
        // Content size is read from the page itself: the WebView shrinks wide
        // pages to fit, so the rendered height is scrollHeight at the view's
        // width over scrollWidth.
        webView.evaluateJavascript(CONTENT_SIZE_SCRIPT) { value ->
            try {
                result.success(render(webView, value))
            } catch (e: Exception) {
                result.error("capture_failed", e.message, null)
            } catch (e: OutOfMemoryError) {
                result.error("capture_failed", "Out of memory", null)
            }
        }
    }

    private fun render(webView: WebView, scriptValue: String?): ByteArray {
        val (contentWidth, contentHeight) = scriptValue
            ?.trim('"')
            ?.split(',')
            ?.mapNotNull { it.toDoubleOrNull() }
            ?.takeIf { it.size == 2 && it.all { size -> size > 0 } }
            ?: throw IllegalStateException("Unreadable content size")

        val width = webView.width
        val height = (width * contentHeight / contentWidth).toInt()
        require(width > 0 && height in 1..MAX_HEIGHT) { "Invalid capture size" }

        val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
        try {
            val canvas = Canvas(bitmap)
            canvas.drawColor(Color.WHITE)
            webView.draw(canvas)
            val out = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, out)
            return out.toByteArray()
        } finally {
            bitmap.recycle()
        }
    }

    private companion object {
        const val CHANNEL = "dev.jotalopez.webview_capture"
        const val MAX_HEIGHT = 16384
        const val CONTENT_SIZE_SCRIPT =
            "document.documentElement.scrollWidth + ',' + document.documentElement.scrollHeight"
    }
}
