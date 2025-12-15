package io.flutter.plugins.deviceinfoexample.example

import android.os.Build
import android.os.Bundle
import android.os.StrictMode
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Ensures correct use of Activity Context to obtain the WindowManager
            StrictMode.setVmPolicy(StrictMode.VmPolicy.Builder()
                .detectIncorrectContextUse()
                .penaltyLog()
                .penaltyDeath()
                .build())
        }
        super.onCreate(savedInstanceState)
    }
}
