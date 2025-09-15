package com.example.flutter_application_1

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private lateinit var voskMethodCallHandler: VoskMethodCallHandler
    private lateinit var channel: MethodChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "vosk_speech_channel")
        voskMethodCallHandler = VoskMethodCallHandler(this)
        voskMethodCallHandler.setMethodChannel(channel)
        channel.setMethodCallHandler(voskMethodCallHandler)
    }

    override fun onDestroy() {
        super.onDestroy()
        voskMethodCallHandler.dispose()
    }
}
