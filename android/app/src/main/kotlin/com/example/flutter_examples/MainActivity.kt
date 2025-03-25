package com.syncfusion.flutter_examples

import android.Manifest
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.core.content.FileProvider
import androidx.core.content.PermissionChecker
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val CHANNEL = "launchFile"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "viewPdf", "viewExcel" -> {
                    val path: String? = call.argument("file_path")
                    if (path != null) {
                        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU && !checkPermission(Manifest.permission.READ_EXTERNAL_STORAGE)) {
                            requestPermission(arrayOf(Manifest.permission.READ_EXTERNAL_STORAGE))
                        } else {
                            launchFile(path)
                        }
                    } else {
                        result.error("INVALID_PATH", "File path is null", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun requestPermission(permissions: Array<String>) {
        ActivityCompat.requestPermissions(this, permissions, 1)
    }

    private fun checkPermission(permission: String): Boolean {
        return if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            true
        } else {
            ContextCompat.checkSelfPermission(this, permission) == PermissionChecker.PERMISSION_GRANTED
        }
    }

    private fun launchFile(filePath: String) {
        val file = File(filePath)
        if (file.exists()) {
            val intent = Intent(Intent.ACTION_VIEW)
            intent.flags = Intent.FLAG_ACTIVITY_SINGLE_TOP
            intent.addCategory(Intent.CATEGORY_DEFAULT)
            val uri: Uri = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                val packageName = this.packageName
                FileProvider.getUriForFile(this, "$packageName.fileProvider", file)
            } else {
                Uri.fromFile(file)
            }

            intent.setDataAndType(
                uri,
                if (filePath.contains(".pdf")) "application/pdf" else "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
            )

            try {
                startActivity(intent)
            } catch (e: Exception) {
                // Could not launch the file.
            }
        }
    }
}
