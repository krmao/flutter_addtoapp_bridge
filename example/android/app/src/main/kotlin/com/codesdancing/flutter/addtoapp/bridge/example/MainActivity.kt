package com.codesdancing.flutter.addtoapp.bridge.example

import android.app.Activity
import android.util.Log
import android.widget.Toast
import com.codesdancing.flutter.addtoapp.bridge.FlutterAddtoappBridgePlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        init {
            FlutterAddtoappBridgePlugin.setOnGlobalMethodCall(object : FlutterAddtoappBridgePlugin.OnGlobalMethodCall {
                override fun onCall(activity: Activity?, call: MethodCall, result: MethodChannel.Result ) {
                    Log.d("onCall", "activity=${activity?.hashCode()}, method=${call.method}, arguments=${call.arguments}")
                    if (call.method == "callPlatform") {
                        val argumentsWithFunctionNameArray = call.arguments as? ArrayList<*>
                        when (val functionName = argumentsWithFunctionNameArray?.first()) {
                            "getPlatformVersion" -> result.success(android.os.Build.VERSION.RELEASE)
                            "open" -> {
                                val argumentsArray = argumentsWithFunctionNameArray.getOrNull(1) as? ArrayList<*>
                                Log.d("onCall", "open-> url=${argumentsArray?.getOrNull(0)}, arguments=${argumentsArray?.getOrNull(1) as? String ?: ""}}")
                                when (val url = argumentsArray?.getOrNull(0)) {
                                    "toast" -> {
                                        FlutterAddtoappBridgePlugin.showToast(activity, argumentsArray.getOrNull(1) as? String ?: "")
                                        result.success("0")
                                    }
                                    else -> {
                                        result.error("-2", "$url is not support", null)
                                    }
                                }
                            }
                            else -> result.error("-1", "$functionName is not support", null)
                        }
                    } else {
                        result.notImplemented()
                    }
                }
            })
        }
    }
}
