import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';
import 'package:flutter/foundation.dart';
import '../../../model/model.dart';

//ignore: must_be_immutable
class QRCodeGenerator extends StatefulWidget {
  QRCodeGenerator({this.sample, Key key}) : super(key: key);
  SubItem sample;
  @override
  _QRCodeGeneratorState createState() => _QRCodeGeneratorState(sample);
}

class _QRCodeGeneratorState extends State<QRCodeGenerator> {
  _QRCodeGeneratorState(this.sample);

  final SubItem sample;
  bool panelOpen;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);
  List<String> subjectCollection;
  List<Color> colorCollection;

  final List<String> _encoding = <String>[
    'Numeric',
    'AlphaNumeric',
    'Binary',
  ];

  final List<String> _errorCorrectionLevels = <String>[
    'High',
    'Quartile',
    'Medium',
    'Low'
  ];

  ErrorCorrectionLevel _errorCorrectionLevel;
  String _selectedErrorCorrectionLevel;
  QRInputMode _inputMode;
  String _selectedInputMode;
  String _inputValue;
  TextEditingController _textEditingController;
  Widget sampleWidget(SampleModel model) => QRCodeGenerator();

  Widget propertyWidget(SampleModel model, bool init, BuildContext context) =>
      _showSettingsPanel(model, init, context);

  void initProperties([SampleModel sampleModel, bool init]) {
    _selectedInputMode = 'Binary';
    _inputValue = 'http://www.syncfusion.com';
    _selectedErrorCorrectionLevel = 'Quartile';
    _errorCorrectionLevel = ErrorCorrectionLevel.quartile;
    _inputMode = QRInputMode.binary;
    if (sampleModel != null && init) {
      sampleModel.properties.addAll(<dynamic, dynamic>{
        'InputValue': _inputValue,
        'SelectedInputMode': _selectedInputMode,
        'InputMode': _inputMode,
        'SelectedErrorCorrectionLevel': _selectedErrorCorrectionLevel,
        'ErrorCorrectionLevel': _errorCorrectionLevel
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
  void didUpdateWidget(QRCodeGenerator oldWidget) {
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
          return Scaffold(
              backgroundColor:
                  model.isWeb ? Colors.transparent : model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                child: Container(
                    child: getQRCodeGenerator(
                        _inputValue,
                        _errorCorrectionLevel,
                        _inputMode,
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
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Text('Input mode:',
                          style: TextStyle(
                              color: model.textColor,
                              fontSize: 16,
                              letterSpacing: 0.34,
                              fontWeight: FontWeight.normal)),
                      Container(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          height: 50,
                          width: 180,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                  canvasColor:
                                      model.bottomSheetBackgroundColor),
                              child: DropDown(
                                  value: model.properties['SelectedInputMode'],
                                  item: _encoding.map((String value) {
                                    return DropdownMenuItem<String>(
                                        value:
                                            (value != null) ? value : 'Binary',
                                        child: Text('$value',
                                            style: TextStyle(
                                                color: model.textColor)));
                                  }).toList(),
                                  valueChanged: (dynamic value) {
                                    _onInputModeChanged(value, model);
                                  }),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Text('Error level:     ',
                          style: TextStyle(
                              color: model.textColor,
                              fontSize: 16,
                              letterSpacing: 0.34,
                              fontWeight: FontWeight.normal)),
                      Container(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          height: 50,
                          width: 100,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                  canvasColor:
                                      model.bottomSheetBackgroundColor),
                              child: DropDown(
                                  value: model.properties[
                                      'SelectedErrorCorrectionLevel'],
                                  item: _errorCorrectionLevels
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                        value: (value != null)
                                            ? value
                                            : 'Quartile',
                                        child: Text('$value',
                                            style: TextStyle(
                                                color: model.textColor)));
                                  }).toList(),
                                  valueChanged: (dynamic value) {
                                    _onErrorCorrectionLevelChanged(
                                        value, model);
                                  }),
                            ),
                          )),
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
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                              child: Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        ' Input mode:',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: model.textColor),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 0, 0, 0),
                                          height: 50,
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Theme(
                                              data: Theme.of(context).copyWith(
                                                  canvasColor: model
                                                      .bottomSheetBackgroundColor),
                                              child: DropDown(
                                                  value: _selectedInputMode,
                                                  item: _encoding
                                                      .map((String value) {
                                                    return DropdownMenuItem<String>(
                                                        value: (value != null)
                                                            ? value
                                                            : 'Binary',
                                                        child: Text('$value',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: model
                                                                    .textColor)));
                                                  }).toList(),
                                                  valueChanged:
                                                      (dynamic value) {
                                                    _onInputModeChanged(
                                                        value, model);
                                                  }),
                                            ),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                              child: Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        'Error level:   ',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: model.textColor),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 0, 0, 0),
                                          height: 50,
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Theme(
                                              data: Theme.of(context).copyWith(
                                                  canvasColor: model
                                                      .bottomSheetBackgroundColor),
                                              child: DropDown(
                                                  value:
                                                      _selectedErrorCorrectionLevel,
                                                  item: _errorCorrectionLevels
                                                      .map((String value) {
                                                    return DropdownMenuItem<String>(
                                                        value: (value != null)
                                                            ? value
                                                            : 'Quartile',
                                                        child: Text('$value',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: model
                                                                    .textColor)));
                                                  }).toList(),
                                                  valueChanged:
                                                      (dynamic value) {
                                                    _onErrorCorrectionLevelChanged(
                                                        value, model);
                                                  }),
                                            ),
                                          )),
                                    )
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

  void _onInputModeChanged(String item, SampleModel model) {
    _selectedInputMode = item;
    switch (_selectedInputMode) {
      case 'Numeric':
        _inputMode = QRInputMode.numeric;
        break;
      case 'AlphaNumeric':
        _inputMode = QRInputMode.alphaNumeric;
        break;
      case 'Binary':
        _inputMode = QRInputMode.binary;
        break;
    }

    model.properties['SelectedInputMode'] = _selectedInputMode;
    model.properties['InputMode'] = _inputMode;
    if (model.isWeb)
      model.sampleOutputContainer.outputKey.currentState.refresh();
    else
      setState(() {});
  }

  void _onErrorCorrectionLevelChanged(String item, SampleModel model) {
    _selectedErrorCorrectionLevel = item;
    switch (_selectedErrorCorrectionLevel) {
      case 'High':
        _errorCorrectionLevel = ErrorCorrectionLevel.high;
        break;
      case 'Quartile':
        _errorCorrectionLevel = ErrorCorrectionLevel.quartile;
        break;
      case 'Medium':
        _errorCorrectionLevel = ErrorCorrectionLevel.medium;
        break;
      case 'Low':
        _errorCorrectionLevel = ErrorCorrectionLevel.low;
        break;
    }

    model.properties['SelectedErrorCorrectionLevel'] =
        _selectedErrorCorrectionLevel;
    model.properties['ErrorCorrectionLevel'] = _errorCorrectionLevel;
    if (model.isWeb)
      model.sampleOutputContainer.outputKey.currentState.refresh();
    else
      setState(() {});
  }
}

Widget getQRCodeGenerator(
    [String _inputValue,
    ErrorCorrectionLevel _correctionLevel,
    QRInputMode _inputMode,
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
            symbology: QRCode(
                inputMode: isExistModel
                    ? model.properties['InputMode']
                    : _inputMode ?? QRInputMode.binary,
                codeVersion: QRCodeVersion.auto,
                errorCorrectionLevel: isExistModel
                    ? model.properties['ErrorCorrectionLevel']
                    : _correctionLevel ?? ErrorCorrectionLevel.quartile),
          ),
        )),
  );
}
