import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'model/model.dart';
import 'sample_browser.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await updateControl();
  // Register your license here
  SyncfusionLicense.registerLicense(null);
  runApp(SampleBrowser());
}
