import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/sample_browser.dart';
import 'package:syncfusion_flutter_core/core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await updateControl();
  // Register your license here
  SyncfusionLicense.registerLicense(null);
  runApp(SampleBrowser());
}
