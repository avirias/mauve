package com.avirias.mauve

import android.util.Log
import androidx.annotation.NonNull
import com.avirias.mauve.common.Playback
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class MauvePlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var playback: Playback
    private val TAG: String = "MauvePlugin"


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "Initialized")
        val channel = MethodChannel(flutterPluginBinding.binaryMessenger, "mauve")
        val applicationContext = flutterPluginBinding.applicationContext
        this.playback = Playback.getInstance(applicationContext)
        channel.setMethodCallHandler(this)
    }


    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        Log.d(TAG, "Call Invoked")
        Log.d(TAG, this::playback.isInitialized.toString())
        if (this::playback.isInitialized) {
            val value: Any? = when (call.method) {
                "play" -> playback.play(call.arguments as String)
                "pause" -> playback.pause()
                "seek" -> playback.seek(call.arguments as Double)
                "mute" -> playback.mute()
                "stop" -> playback.stop()
                "resume" -> playback.resume()
                else -> result.success("Not Implemented")
            }
            result.success(value)
        }
    }


    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    }
}
