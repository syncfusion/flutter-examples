import 'package:flutter/material.dart';
import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:scoped_model/scoped_model.dart';

class PyramidFeatures extends StatefulWidget {
  const PyramidFeatures({Key key}) : super(key: key);

  @override
  _SeriesFeaturesState createState() => _SeriesFeaturesState();
}

class _SeriesFeaturesState extends State<PyramidFeatures> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleListModel model) => Theme(
            data: model.themeData,
            child: SafeArea(
              child: DefaultTabController(
                length:
                    model.controlList[model.selectedIndex].subItemList.length,
                child: Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    backgroundColor: model.backgroundColor,
                    title: Text(
                        model.controlList[model.selectedIndex].title.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.white,
                            letterSpacing: 0.3)),
                  ),
                  body: TabBarView(
                    children: getCardViewChildren(model),
                  ),
                ),
              ),
            )));
  }
}
