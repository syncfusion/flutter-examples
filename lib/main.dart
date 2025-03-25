import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/model.dart';
import 'sample_browser.dart';
import 'showcase_samples/expense_tracker/notifiers/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await updateControlItems();

  runApp(
    MultiProvider(providers: buildProviders(), child: const SampleBrowser()),
  );
}
