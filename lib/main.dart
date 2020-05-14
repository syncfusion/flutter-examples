import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/sample_browser.dart';
import 'package:flutter_examples/sb_web/sample_browser_web.dart';
import 'package:syncfusion_flutter_core/core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await updateControl();
  // Register your license here
  SyncfusionLicense.registerLicense(null);
  runApp(kIsWeb ? WebSampleBrowser() : SampleBrowser());
}

