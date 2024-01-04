package com.syncfusion.flutter_examples;

import android.Manifest;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;
import androidx.core.content.PermissionChecker;

import java.io.File;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "launchFile")
                .setMethodCallHandler(
                    (call, result) -> {
                      if (call.method.equals("viewPdf") || call.method.equals("viewExcel")) {
                        String path = call.argument("file_path");
                        if(!checkPermission(Manifest.permission.READ_EXTERNAL_STORAGE)){
                          requestPermission(new String[]{Manifest.permission.READ_EXTERNAL_STORAGE});
                        } else {
                          launchFile(path);
                        }
                      }
                }
        );
    }
  private void requestPermission(String[] permission){
    ActivityCompat.requestPermissions(this, permission, 1);
  }
  private boolean checkPermission(String permission) {
    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
      return true;
    } else {
      if (ContextCompat.checkSelfPermission(this, permission) == PermissionChecker.PERMISSION_GRANTED) {
        return true;
      } else {
        return false;
      }
    }
  }
  private void launchFile(String filePath){
    File file = new File(filePath);
    if(file.exists()){
      Intent intent = new Intent(Intent.ACTION_VIEW);
      intent.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
      intent.addCategory("android.intent.category.DEFAULT");
      Uri uri = null;
      if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP){
        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        String packageName = this.getPackageName();
        uri = FileProvider.getUriForFile(this, packageName + ".fileProvider", new File(filePath));
      }else {
        uri = Uri.fromFile(file);
      }
      if(filePath.contains(".pdf"))
        intent.setDataAndType(uri, "application/pdf");
      else
        intent.setDataAndType(uri, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
      try{
        this.startActivity(intent);
      }catch (Exception e){
        //Could not launch the file.
      }
    }
  }
}
