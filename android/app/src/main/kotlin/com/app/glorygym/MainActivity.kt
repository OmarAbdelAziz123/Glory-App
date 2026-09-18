package com.app.glorygym

import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

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
        private const val NAVIGATION_MODE_CHANNEL = "com.app.glorygym/navigation_mode"
    }
}
