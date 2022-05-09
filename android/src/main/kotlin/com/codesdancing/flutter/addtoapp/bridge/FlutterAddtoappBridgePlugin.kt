package com.codesdancing.flutter.addtoapp.bridge

import android.app.Activity
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.annotation.Nullable
import androidx.annotation.UiThread
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterAddtoappBridgePlugin */
class FlutterAddtoappBridgePlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private var activity: Activity? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Log.d("flutter_addtoapp_bridge", "onAttachedToEngine")
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_addtoapp_bridge")
        channel?.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        Log.d("flutter_addtoapp_bridge", "onMethodCall activity=${activity?.hashCode()}, method=${call.method}, arguments=${call.arguments}")
        onGlobalMethodCall?.onCall(activity, call, result)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        Log.d("flutter_addtoapp_bridge", "onAttachedToActivity ${binding.activity}")
        this.activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        Log.d("flutter_addtoapp_bridge", "onDetachedFromActivityForConfigChanges")
        this.activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        Log.d("flutter_addtoapp_bridge", "onReattachedToActivityForConfigChanges")
        this.activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        Log.d("flutter_addtoapp_bridge", "onDetachedFromActivity")
        this.activity = null
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d("flutter_addtoapp_bridge", "onDetachedFromEngine")
        channel?.setMethodCallHandler(null)
    }

    interface OnGlobalMethodCall {
        fun onCall(@Nullable activity: Activity?, @NonNull call: MethodCall, @NonNull result: Result)
    }

    @Suppress("unused")
    companion object {
        @JvmStatic
        private var onGlobalMethodCall: OnGlobalMethodCall? = null

        @JvmStatic
        fun setOnGlobalMethodCall(onGlobalMethodCall: OnGlobalMethodCall?) {
            this.onGlobalMethodCall = onGlobalMethodCall
        }

        private var channel: MethodChannel? = null

        /**
         * @return false if innerMethodChannel is null
         */
        @UiThread
        @JvmStatic
        @JvmOverloads
        fun callFlutter(method: String, @Nullable arguments: Any? = null, @Nullable callback: Result? = null): Boolean {
            val innerMethodChannel = channel

            return if (innerMethodChannel != null) {
                innerMethodChannel.invokeMethod(method, arguments, callback)
                true
            } else {
                Log.e("BridgePlugin", "methodChannel is null")
                false
            }
        }

        @JvmStatic
        fun showToast(activity: Activity?, message: String?) {
            if (activity != null && !activity.isFinishing && message != null && message.isNotEmpty()) {
                Toast.makeText(activity, message, Toast.LENGTH_SHORT).show()
            }
        }
    }
}
