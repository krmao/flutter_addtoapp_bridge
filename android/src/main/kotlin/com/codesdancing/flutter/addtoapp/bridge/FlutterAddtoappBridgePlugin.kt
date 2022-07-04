package com.codesdancing.flutter.addtoapp.bridge

import android.app.Activity
import android.app.Application
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Build
import android.os.Bundle
import android.text.TextUtils
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.annotation.Nullable
import androidx.annotation.UiThread
import io.flutter.FlutterInjector
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterActivityLaunchConfigs
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.FlutterEngineGroup
import io.flutter.embedding.engine.dart.DartExecutor.DartEntrypoint
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.ref.SoftReference


/** FlutterAddtoappBridgePlugin */
class FlutterAddtoappBridgePlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private var currentBindingActivityRefKey: String? = null
    private var currentBindingActivityRef: SoftReference<Activity>? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "onAttachedToEngine activityLinkedHashMap=${activityLinkedHashMapString()}")
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_addtoapp_bridge")
        channel?.setMethodCallHandler(this)

        var context = flutterPluginBinding.applicationContext
        var lastContext: Context? = null
        while (context != lastContext) {
            Log.d(TAG, "onAttachedToEngine trying to resolve Application from Context: ${context.javaClass.name}")
            lastContext = context

            val tmpApplication = context as? Application
            if (tmpApplication != null) {
                application = tmpApplication
                flutterEngineGroup = FlutterEngineGroup(tmpApplication)
                break
            } else {
                context = context.applicationContext
            }
        }
        Log.w(TAG, "onAttachedToEngine ${if (application == null) "failure" else "success"} to resolve Application from Context")

        application?.unregisterActivityLifecycleCallbacks(activityLifecycleCallbacks)
        application?.registerActivityLifecycleCallbacks(activityLifecycleCallbacks)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        Log.d(TAG, "onMethodCall activity=${currentBindingActivityRef?.get()?.toString()}, method=${call.method}, arguments=${call.arguments}, activityLinkedHashMap=${activityLinkedHashMapString()}")
        if (onGlobalMethodCall != null) {
            onGlobalMethodCall?.onCall(currentBindingActivityRef?.get(), call, object : Result {
                override fun success(_result: Any?) {
                    result.success(_result)
                }

                override fun error(errorCode: String?, errorMessage: String?, errorDetails: Any?) {
                    result.error(errorCode, errorMessage, errorDetails)
                }

                override fun notImplemented() {
                    onDefaultGlobalMethodCall.onCall(currentBindingActivityRef?.get(), call, result)
                }
            })
        } else {
            onDefaultGlobalMethodCall.onCall(currentBindingActivityRef?.get(), call, result)
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        val activityRef = SoftReference(binding.activity)
        this.currentBindingActivityRefKey = binding.activity.hashCode().toString()
        this.currentBindingActivityRef = activityRef
        activityLinkedHashMap[binding.activity.hashCode().toString()] = activityRef
        Log.d(TAG, "onAttachedToActivity activityLinkedHashMap=${activityLinkedHashMapString()}")
    }

    override fun onDetachedFromActivityForConfigChanges() {
        val activityRefKey = this.currentBindingActivityRefKey
        if (activityRefKey != null) {
            activityLinkedHashMap.remove(activityRefKey)
            this.currentBindingActivityRefKey = null
            this.currentBindingActivityRef = null
        }
        Log.d(TAG, "onDetachedFromActivityForConfigChanges activityLinkedHashMap=${activityLinkedHashMapString()}")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        val activityRef = SoftReference(binding.activity)
        this.currentBindingActivityRefKey = binding.activity.hashCode().toString()
        this.currentBindingActivityRef = activityRef
        activityLinkedHashMap[binding.activity.hashCode().toString()] = activityRef
        Log.d(TAG, "onReattachedToActivityForConfigChanges activityLinkedHashMap=${activityLinkedHashMapString()}")
    }

    override fun onDetachedFromActivity() {
        val activityRefKey = this.currentBindingActivityRefKey
        if (activityRefKey != null) {
            activityLinkedHashMap.remove(activityRefKey)
            this.currentBindingActivityRefKey = null
            this.currentBindingActivityRef = null
        }
        Log.d(TAG, "onDetachedFromActivity activityLinkedHashMap=${activityLinkedHashMapString()}")
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "onDetachedFromEngine activityLinkedHashMap=${activityLinkedHashMapString()}")
        channel?.setMethodCallHandler(null)
    }

    interface OnGlobalMethodCall {
        fun onCall(@Nullable activity: Activity?, @NonNull call: MethodCall, @NonNull result: Result)
    }

    @Suppress("unused")
    companion object {
        @JvmStatic
        private var onGlobalMethodCall: OnGlobalMethodCall? = null

        const val TAG: String = "flutter_addtoapp_bridge"

        @JvmStatic
        private var onDefaultGlobalMethodCall: OnGlobalMethodCall = object : OnGlobalMethodCall {
            override fun onCall(activity: Activity?, call: MethodCall, result: Result) {
                Log.d(TAG, "onDefaultGlobalMethodCall activityLinkedHashMap=${activityLinkedHashMapString()}")
                Log.d(TAG, "onDefaultGlobalMethodCall activity=${activity?.hashCode()}, method=${call.method}, arguments=${call.arguments}")
                if (call.method == "callPlatform") {
                    val argumentsWithFunctionNameArray = call.arguments as? ArrayList<*>
                    when (argumentsWithFunctionNameArray?.first()) {
                        "getPlatformVersion" -> {
                            result.success(Build.VERSION.RELEASE)
                        }
                        "isAddToApp" -> {
                            result.success(onGlobalMethodCall != null)
                        }
                        "putString" -> {
                            val sharedPreferences = application?.getSharedPreferences("flutter.addtoapp.sp", Context.MODE_PRIVATE)
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
                            val sharedPreferences = application?.getSharedPreferences("flutter.addtoapp.sp", Context.MODE_PRIVATE)
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
                            val sharedPreferences = application?.getSharedPreferences("flutter.addtoapp.sp", Context.MODE_PRIVATE)
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
                            val sharedPreferences = application?.getSharedPreferences("flutter.addtoapp.sp", Context.MODE_PRIVATE)
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
                            val sharedPreferences = application?.getSharedPreferences("flutter.addtoapp.sp", Context.MODE_PRIVATE)
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
                            val sharedPreferences = application?.getSharedPreferences("flutter.addtoapp.sp", Context.MODE_PRIVATE)
                            val argumentsArray = argumentsWithFunctionNameArray.getOrNull(1) as? ArrayList<*>
                            val key = argumentsArray?.getOrNull(0) as? String
                            if (!TextUtils.isEmpty(key) && sharedPreferences != null) {
                                val defaultValue = argumentsArray?.getOrNull(1) as? Float ?: 0f
                                result.success(sharedPreferences.getFloat(key, defaultValue))
                            } else {
                                result.error("-1", "key=$key is empty", null)
                            }
                        }
                        "exitApp" -> {
                            activityLinkedHashMap.forEach { it.value.get()?.finish() }
                            result.success(true)
                        }
                        "back" -> {
                            val argumentsArray = argumentsWithFunctionNameArray.getOrNull(1) as? ArrayList<*>
                            val count: Int = argumentsArray?.getOrNull(0) as? Int ?: 1
                            back(count)
                            result.success(true)
                        }
                        "showToast" -> {
                            val argumentsArray = argumentsWithFunctionNameArray.getOrNull(1) as? ArrayList<*>
                            val message: String = argumentsArray?.getOrNull(0) as? String ?: ""
                            showToast(activity, message)
                            result.success(true)
                        }
                        "openContainer" -> {
                            val argumentsArray = argumentsWithFunctionNameArray.getOrNull(1) as? ArrayList<*>
                            val entrypoint: String = argumentsArray?.getOrNull(0) as? String ?: ""
                            val argumentsMap = argumentsArray?.getOrNull(1) as? HashMap<*, *> ?: hashMapOf<String, String?>()
                            val initialRoute: String = argumentsMap["initialRoute"] as? String ?: "/"
                            val destroyEngine: Boolean = argumentsMap["destroyEngine"] as? Boolean ?: false
                            val transparent: Boolean = argumentsMap["transparent"] as? Boolean ?: false
                            openContainer(activity, entrypoint, initialRoute, destroyEngine, transparent)
                            result.success(true)
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

        @JvmStatic
        @JvmOverloads
        fun back(count: Int = 1) {
            var finalCount = count
            val activityLinkedHashMapKeys = activityLinkedHashMap.keys
            if (activityLinkedHashMapKeys.size > 0) {
                if (finalCount > activityLinkedHashMapKeys.size) {
                    finalCount = 1
                }
                if (count == -1) {
                    finalCount = activityLinkedHashMapKeys.size - 1
                }
                for (index in activityLinkedHashMapKeys.size - 1 downTo activityLinkedHashMapKeys.size - finalCount step 1) {
                    val key = activityLinkedHashMapKeys.elementAt(index)
                    activityLinkedHashMap[key]?.get()?.finish()
                    activityLinkedHashMap.remove(key)
                }
            }
        }

        private var channel: MethodChannel? = null

        private var application: Application? = null
        private var flutterEngineGroup: FlutterEngineGroup? = null
        private var activityLinkedHashMap = linkedMapOf<String, SoftReference<Activity>>()

        @JvmStatic
        fun activityLinkedHashMapString(): String {
            return "(${activityLinkedHashMap.keys.size}${activityLinkedHashMap.keys})"
        }

        private var activityLifecycleCallbacks: Application.ActivityLifecycleCallbacks? = object : Application.ActivityLifecycleCallbacks {
            override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
                activityLinkedHashMap[activity.hashCode().toString()] = SoftReference(activity)
                Log.d(TAG, "onActivityCreated $activity activityLinkedHashMap=${activityLinkedHashMapString()}")
            }

            override fun onActivityStarted(activity: Activity) {}

            override fun onActivityResumed(activity: Activity) {}

            override fun onActivityPaused(activity: Activity) {}

            override fun onActivityStopped(activity: Activity) {}

            override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {}

            override fun onActivityDestroyed(activity: Activity) {
                activityLinkedHashMap.remove(activity.hashCode().toString())
                Log.d(TAG, "onActivityDestroyed $activity activityLinkedHashMap=${activityLinkedHashMapString()}")
            }
        }

        /**
         * @return false if innerMethodChannel is null
         */
        @UiThread
        @JvmStatic
        @JvmOverloads
        fun callFlutter(method: String, @Nullable arguments: Any? = null, @Nullable callback: Result? = null): Boolean {
            Log.d(TAG, "callFlutter activityLinkedHashMap=${activityLinkedHashMapString()}")
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

        @JvmStatic
        @JvmOverloads
        fun openContainer(context: Context?, entrypoint: String? = "main", initialRoute: String = "/", destroyEngine: Boolean = false, transparent: Boolean = false) {
            if (context == null || (context is Activity && context.isFinishing) || entrypoint == null) {
                return
            }
            val intent = getIntentWithEntrypoint(context, entrypoint, initialRoute, destroyEngine, transparent)
            if (intent != null) {
                context.startActivity(intent)
            }
        }

        /**
         * https://flutter.cn/docs/development/add-to-app/android/add-flutter-screen
         */
        @JvmStatic
        @JvmOverloads
        fun getIntentWithEntrypoint(
            context: Context?, entrypoint: String? = "main", initialRoute: String = "/", destroyEngine: Boolean = false, transparent: Boolean = false
        ): Intent? {
            val tmpFlutterEngineGroup = flutterEngineGroup
            if (context == null || (context is Activity && context.isFinishing) || tmpFlutterEngineGroup == null || entrypoint == null) {
                return null
            }
            val cachedEngine = FlutterEngineCache.getInstance().get(entrypoint)
            val dartEntrypoint = DartEntrypoint(FlutterInjector.instance().flutterLoader().findAppBundlePath(), entrypoint)
            if (cachedEngine == null) {
                val flutterEngine = tmpFlutterEngineGroup.createAndRunEngine(context, dartEntrypoint, initialRoute)
                FlutterEngineCache.getInstance().put(entrypoint, flutterEngine)
            }
            return FlutterActivity.CachedEngineIntentBuilder(FlutterActivity::class.java, entrypoint)
                .backgroundMode(if (transparent) FlutterActivityLaunchConfigs.BackgroundMode.transparent else FlutterActivityLaunchConfigs.BackgroundMode.opaque)
                .destroyEngineWithActivity(destroyEngine)
                .build(context)
        }
    }
}
