import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';
import 'package:flutter/foundation.dart';
import '../../../model/model.dart';

//ignore: must_be_immutable
class DataMatrixGenerator extends StatefulWidget {
  DataMatrixGenerator({this.sample, Key key}) : super(key: key);
  SubItem sample;
  @override
  _DataMatrixGeneratorState createState() => _DataMatrixGeneratorState(sample);
}

class _DataMatrixGeneratorState extends State<DataMatrixGenerator> {
  _DataMatrixGeneratorState(this.sample);

  final SubItem sample;
  bool panelOpen;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);
  List<String> subjectCollection;
  List<Color> colorCollection;

  String _inputValue;

  TextEditingController _textEditingController;

  Widget sampleWidget(SampleModel model) => DataMatrixGenerator();

  Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
      _showSettingsPanel(model, init, context);

  void initProperties([SampleModel sampleModel, bool init]) {
    _inputValue = 'http://www.syncfusion.com';
    if (sampleModel != null && init) {
      sampleModel.properties.addAll(<dynamic, dynamic>{
        'InputValue': _inputValue,
      });

      _textEditingController = TextEditingController.fromValue(
        TextEditingValue(
          text: sampleModel.properties['InputValue'],
        ),
      );
    }
  }

  @override
  void initState() {
    initProperties();
    _textEditingController = TextEditingController.fromValue(
      TextEditingValue(
        text: kIsWeb ? 'http://www.syncfusion.com' : _inputValue,
      ),
    );
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);

    super.initState();
  }

  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;

  @override
  void didUpdateWidget(DataMatrixGenerator oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build([BuildContext context]) {
    EdgeInsets _padding = const EdgeInsets.all(0);
    double _margin;
    if (!kIsWeb) {
      _margin = (MediaQuery.of(context).size.width -
              MediaQuery.of(context).size.width * 0.6) /
          2;
      _padding = EdgeInsets.fromLTRB(_margin, 0, _margin, 0);
    }

    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          if (model != null && model.isWeb && model.properties.isEmpty) {
            initProperties(model, true);
          }
          return Scaffold(
              backgroundColor:
                  model.isWeb ? Colors.transparent : model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                child: Container(
                    child: getDataMatrixGenerator(
                        _inputValue,
                        _padding,
                        kIsWeb
                            ? MediaQuery.of(context).size.height * 0.4
                            : null,
                        model)),
              ),
              floatingActionButton: model.isWeb
                  ? null
                  : FloatingActionButton(
                      onPressed: () {
                        _showSettingsPanel(model, false, context);
                      },
                      child: Icon(Icons.graphic_eq, color: Colors.white),
                      backgroundColor: model.backgroundColor,
                    ));
        });
  }

  Widget _showSettingsPanel(SampleModel model,
      [bool init, BuildContext context]) {
    //ignore: unused_local_variable
    final double height =
        (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width)
            ? 0.3
            : 0.4;
    Widget widget;
    if (model.isWeb) {
      initProperties(model, init);
      widget = Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: ListView(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Properties',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    HandCursor(
                        child: IconButton(
                      icon: Icon(Icons.close, color: model.textColor),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ))
                  ]),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text('Input value:   ',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: model.textColor)),
                      Container(
                          padding: const EdgeInsets.fromLTRB(0, 5, 10, 0),
                          height: 50,
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                  canvasColor:
                                      model.bottomSheetBackgroundColor),
                              child: TextField(
                                  style: TextStyle(color: model.textColor),
                                  decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: model.textColor))),
                                  autofocus: false,
                                  keyboardType: TextInputType.text,
                                  maxLines: null,
                                  onChanged: (String _text) {
                                    model.properties['InputValue'] =
                                        _inputValue = _text;
                                    if (model.isWeb) {
                                      model.sampleOutputContainer.outputKey
                                          .currentState
                                          .refresh();
                                    } else {
                                      setState(() {});
                                    }
                                  },
                                  controller: _textEditingController),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ));
    } else {
      showRoundedModalBottomSheet<dynamic>(
          dismissOnTap: false,
          context: context,
          radius: 12.0,
          color: model.bottomSheetBackgroundColor,
          builder: (BuildContext context) => ScopedModelDescendant<SampleModel>(
              rebuildOnChange: false,
              builder: (BuildContext context, _, SampleModel model) =>
                  SingleChildScrollView(
                    child: Container(
                        height: 300,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
                          child: Column(children: <Widget>[
                            Container(
                              height: 40,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Settings',
                                      style: TextStyle(
                                          color: model.textColor,
                                          fontSize: 18,
                                          letterSpacing: 0.34,
                                          fontWeight: FontWeight.w500)),
                                  IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: model.textColor,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Input value:   ',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: model.textColor)),
                                    Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 10, 0),
                                        height: 50,
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Theme(
                                            data: Theme.of(context).copyWith(
                                                canvasColor: model
                                                    .bottomSheetBackgroundColor),
                                            child: TextField(
                                                style: TextStyle(
                                                    color: model.textColor),
                                                decoration: InputDecoration(
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: model
                                                                    .textColor))),
                                                autofocus: false,
                                                keyboardType:
                                                    TextInputType.text,
                                                maxLines: null,
                                                onChanged: (String _text) {
                                                  setState(() {
                                                    _inputValue = _text;
                                                  });
                                                },
                                                controller:
                                                    _textEditingController),
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        )),
                  )));
    }
    return widget ?? Container();
  }
}

Widget getDataMatrixGenerator(
    [String _inputValue,
    EdgeInsets _padding,
    double height,
    SampleModel model]) {
  final bool isExistModel = model != null && model.isWeb;
  return Center(
    child: Container(
        height: height != null ? height : kIsWeb ? 300 : double.infinity,
        child: Padding(
          padding: _padding != null ? _padding : const EdgeInsets.all(30),
          child: SfBarcodeGenerator(
            value: isExistModel
                ? model.properties['InputValue'] ?? 'http://www.syncfusion.com'
                : _inputValue ?? 'http://www.syncfusion.com',
            textAlign: TextAlign.justify,
            textSpacing: 10,
            showValue: false,
            symbology: DataMatrix(encoding: DataMatrixEncoding.base256),
          ),
        )),
  );
}
