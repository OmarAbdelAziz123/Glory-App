package com.app.glorygym

import android.provider.Settings
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            SECURE_SCREEN_CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "enable" -> {
                    window.setFlags(
                        WindowManager.LayoutParams.FLAG_SECURE,
                        WindowManager.LayoutParams.FLAG_SECURE,
                    )
                    result.success(null)
                }

                "disable" -> {
                    window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            NAVIGATION_MODE_CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "is3ButtonNav" -> {
                    val mode = Settings.Secure.getInt(
                        contentResolver,
                        "navigation_mode",
                        0,
                    )
                    // 0 = 3-button, 1 = 2-button, 2 = gesture
                    result.success(mode == 0)
                }

                else -> result.notImplemented()
            }
        }
    }

    companion object {
        private const val SECURE_SCREEN_CHANNEL = "com.app.glorygym/secure_screen"
        private const val NAVIGATION_MODE_CHANNEL = "com.app.glorygym/navigation_mode"
    }
}
