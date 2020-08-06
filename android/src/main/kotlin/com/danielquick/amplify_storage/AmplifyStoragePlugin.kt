package com.danielquick.amplify_storage

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

import java.io.File
import android.app.Activity

import com.amplifyframework.core.Amplify
import com.amplifyframework.storage.s3.AWSS3StoragePlugin

/** AmplifyStoragePlugin */
public class AmplifyStoragePlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var activity : Activity

   override fun onAttachedToActivity(activityPluginBinding : ActivityPluginBinding) {
    activity = activityPluginBinding.getActivity()
  }

  override fun onDetachedFromActivityForConfigChanges() {
  }

  override fun onReattachedToActivityForConfigChanges(activityPluginBinding : ActivityPluginBinding) {
  }

  override fun onDetachedFromActivity() {
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "amplify_storage")
    channel.setMethodCallHandler(this);
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "amplify_storage")
      channel.setMethodCallHandler(AmplifyStoragePlugin())
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "initialize" -> initialize(result)
      "uploadFile" -> uploadFile(call.argument<String>("path") ?: "", call.argument<String>("key") ?: "", result)
      else -> result.notImplemented()
    }
  }

  fun initialize(flutterResult: Result) {
    Amplify.addPlugin(AWSS3StoragePlugin())
    flutterResult.success(true)
  }

  fun uploadFile(path: String, key: String, flutterResult: Result) {
    Amplify.Storage.uploadFile(
      key,
      File(path),
      { result -> activity.runOnUiThread(
          java.lang.Runnable {
            flutterResult.success(true)
          }
        )
      },
      {
        error -> activity.runOnUiThread(
          java.lang.Runnable {
            flutterResult.error(error.message, error.cause.toString(), error)
          }
        )
      }
    )
  }
}
