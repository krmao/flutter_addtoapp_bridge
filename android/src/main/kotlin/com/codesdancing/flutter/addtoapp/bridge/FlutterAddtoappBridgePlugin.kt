package com.codesdancing.flutter.addtoapp.bridge

import android.app.Activity
import android.content.Context
import android.content.SharedPreferences
import android.os.Build
import android.text.TextUtils
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
        if (onGlobalMethodCall != null) {
            onGlobalMethodCall?.onCall(activity, call, object : Result {
                override fun success(_result: Any?) {
                    result.success(_result)
                }

                override fun error(errorCode: String?, errorMessage: String?, errorDetails: Any?) {
                    result.error(errorCode, errorMessage, errorDetails)
                }

                override fun notImplemented() {
                    onDefaultGlobalMethodCall.onCall(activity, call, result)
                }
            })
        } else {
            onDefaultGlobalMethodCall.onCall(activity, call, result)
        }
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
        private var onDefaultGlobalMethodCall: OnGlobalMethodCall = object : OnGlobalMethodCall {
            override fun onCall(activity: Activity?, call: MethodCall, result: Result) {
                Log.d("onCall", "activity=${activity?.hashCode()}, method=${call.method}, arguments=${call.arguments}")
                if (call.method == "callPlatform") {
                    val argumentsWithFunctionNameArray = call.arguments as? ArrayList<*>
                    when (val functionName = argumentsWithFunctionNameArray?.first()) {
                        "getPlatformVersion" -> {
                            result.success(Build.VERSION.RELEASE)
                        }
                        "isAddToApp" -> {
                            result.success(onGlobalMethodCall != null)
                        }
                        "putString" -> {
                            val sharedPreferences = activity?.getSharedPreferences("flutter.addtoapp.sp", Context.MODE_PRIVATE)
                            val argumentsArray = argumentsWithFunctionNameArray.getOrNull(1) as? ArrayList<*>
                            val key = argumentsArray?.getOrNull(0) as? String
                            if (!TextUtils.isEmpty(key) && sharedPreferences != null) {
                                val value = argumentsArray?.getOrNull(1) as? String
                                val editor: SharedPreferences.Editor = sharedPreferences.edit()
                                editor.putString(key, value)
                                editor.apply()
                                result.success("0")
                            } else {
                                result.error("-1", "key=$key is empty", null)
                            }
                        }
                        "getString" -> {
                            val sharedPreferences = activity?.getSharedPreferences("flutter.addtoapp.sp", Context.MODE_PRIVATE)
                            val argumentsArray = argumentsWithFunctionNameArray.getOrNull(1) as? ArrayList<*>
                            val key = argumentsArray?.getOrNull(0) as? String
                            if (!TextUtils.isEmpty(key) && sharedPreferences != null) {
                                val defaultValue = argumentsArray?.getOrNull(1) as? String
                                result.success(sharedPreferences.getString(key, defaultValue))
                            } else {
                                result.error("-1", "key=$key is empty", null)
                            }
                        }
                        "putLong" -> {
                            val sharedPreferences = activity?.getSharedPreferences("flutter.addtoapp.sp", Context.MODE_PRIVATE)
                            val argumentsArray = argumentsWithFunctionNameArray.getOrNull(1) as? ArrayList<*>
                            val key = argumentsArray?.getOrNull(0) as? String
                            if (!TextUtils.isEmpty(key) && sharedPreferences != null) {
                                val value = argumentsArray?.getOrNull(1) as? Long ?: 0
                                val editor: SharedPreferences.Editor = sharedPreferences.edit()
                                editor.putLong(key, value)
                                editor.apply()
                                result.success("0")
                            } else {
                                result.error("-1", "key=$key is empty", null)
                            }
                        }
                        "getLong" -> {
                            val sharedPreferences = activity?.getSharedPreferences("flutter.addtoapp.sp", Context.MODE_PRIVATE)
                            val argumentsArray = argumentsWithFunctionNameArray.getOrNull(1) as? ArrayList<*>
                            val key = argumentsArray?.getOrNull(0) as? String
                            if (!TextUtils.isEmpty(key) && sharedPreferences != null) {
                                val defaultValue = argumentsArray?.getOrNull(1) as? Long ?: 0
                                result.success(sharedPreferences.getLong(key, defaultValue))
                            } else {
                                result.error("-1", "key=$key is empty", null)
                            }
                        }
                        "putFloat" -> {
                            val sharedPreferences = activity?.getSharedPreferences("flutter.addtoapp.sp", Context.MODE_PRIVATE)
                            val argumentsArray = argumentsWithFunctionNameArray.getOrNull(1) as? ArrayList<*>
                            val key = argumentsArray?.getOrNull(0) as? String
                            if (!TextUtils.isEmpty(key) && sharedPreferences != null) {
                                val value = argumentsArray?.getOrNull(1) as? Float ?: 0f
                                val editor: SharedPreferences.Editor = sharedPreferences.edit()
                                editor.putFloat(key, value)
                                editor.apply()
                                result.success("0")
                            } else {
                                result.error("-1", "key=$key is empty", null)
                            }
                        }
                        "getFloat" -> {
                            val sharedPreferences = activity?.getSharedPreferences("flutter.addtoapp.sp", Context.MODE_PRIVATE)
                            val argumentsArray = argumentsWithFunctionNameArray.getOrNull(1) as? ArrayList<*>
                            val key = argumentsArray?.getOrNull(0) as? String
                            if (!TextUtils.isEmpty(key) && sharedPreferences != null) {
                                val defaultValue = argumentsArray?.getOrNull(1) as? Float ?: 0f
                                result.success(sharedPreferences.getFloat(key, defaultValue))
                            } else {
                                result.error("-1", "key=$key is empty", null)
                            }
                        }
                        else -> {
                            result.notImplemented()
                        }
                    }
                } else {
                    result.notImplemented()
                }
            }
        }

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
