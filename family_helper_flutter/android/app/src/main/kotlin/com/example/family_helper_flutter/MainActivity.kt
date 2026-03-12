package com.example.family_helper_flutter

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL_NAME,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getNotificationPermissionStatus" -> {
                    result.success(getNotificationPermissionStatus())
                }
                "openNotificationSettings" -> {
                    result.success(openNotificationSettings())
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun getNotificationPermissionStatus(): Map<String, Any> {
        val notificationsEnabled = NotificationManagerCompat.from(this)
            .areNotificationsEnabled()
        val needsRuntimePermission = Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU
        val permissionGranted = if (needsRuntimePermission) {
            ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.POST_NOTIFICATIONS,
            ) == PackageManager.PERMISSION_GRANTED
        } else {
            true
        }
        val canAskAgain = if (needsRuntimePermission && !permissionGranted) {
            ActivityCompat.shouldShowRequestPermissionRationale(
                this,
                Manifest.permission.POST_NOTIFICATIONS,
            )
        } else {
            false
        }

        return mapOf(
            "isGranted" to (permissionGranted && notificationsEnabled),
            "notificationsEnabled" to notificationsEnabled,
            "needsRuntimePermission" to needsRuntimePermission,
            "canAskAgain" to canAskAgain,
        )
    }

    private fun openNotificationSettings(): Boolean {
        return try {
            val intent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS).apply {
                    putExtra(Settings.EXTRA_APP_PACKAGE, packageName)
                }
            } else {
                Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                    data = Uri.fromParts("package", packageName, null)
                }
            }
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
            true
        } catch (_: Exception) {
            false
        }
    }

    private companion object {
        const val CHANNEL_NAME = "family_helper/notification_permissions"
    }
}
