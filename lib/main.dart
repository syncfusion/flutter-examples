import 'package:flutter/material.dart';
import 'model/model.dart';
import 'sample_browser.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await updateControlItems();
  runApp(const SampleBrowser());
}