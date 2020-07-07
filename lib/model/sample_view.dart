/// Package import
import 'package:flutter/material.dart';

/// Local import
import 'model.dart';


/// Render the sampleview. 
abstract class SampleView extends StatefulWidget {
  const SampleView({Key key}) : super(key: key);
}

abstract class SampleViewState extends State<SampleView> {
  SampleModel model;
  bool isCardView;

  @override
  void initState() {
    model = SampleModel.instance;
    isCardView = model.isCardView && !model.isWeb;
    super.initState();
  }

  @override
  /// Must call super.
  void dispose() {
    model.isCardView = true;
    super.dispose();
  }


  /// Get the settings panel content.
  Widget buildSettings(BuildContext context) {
    return null;
  }

}
