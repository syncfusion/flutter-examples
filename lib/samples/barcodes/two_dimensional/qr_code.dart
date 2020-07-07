import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../model/model.dart';
import '../../../model/sample_view.dart';
import '../../../widgets/customDropDown.dart';

//ignore: must_be_immutable
class QRCodeGenerator extends SampleView {
  QRCodeGenerator(Key key) : super(key: key);
  SubItem sample;
  @override
  _QRCodeGeneratorState createState() => _QRCodeGeneratorState();
}

class _QRCodeGeneratorState extends SampleViewState {
  _QRCodeGeneratorState();

  // final SubItem sample;
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

  @override
  void initState() {
    _selectedInputMode = 'Binary';
    _inputValue = 'http://www.syncfusion.com';
    _selectedErrorCorrectionLevel = 'Quartile';
    _errorCorrectionLevel = ErrorCorrectionLevel.quartile;
    _inputMode = QRInputMode.binary;
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

    return Scaffold(
        backgroundColor: model.isWeb ? Colors.transparent : model.cardThemeColor,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: Container(
              child: _getQRCodeGenerator(
                  _inputValue, _errorCorrectionLevel, _inputMode, _padding)),
        ),);
  }

  @override
  Widget buildSettings(BuildContext context) {
    return  ListView(
      padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
        children: <Widget>[
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
        child: Container(
          height: 100,
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
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  height: 50,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          canvasColor: model.bottomSheetBackgroundColor),
                      child: TextField(
                          style: TextStyle(color: model.textColor),
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: model.textColor))),
                          autofocus: false,
                          keyboardType: TextInputType.text,
                          maxLines: null,
                          onChanged: (String _text) {
                            setState(() {
                              _inputValue = _text;
                            });
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
          height: 50,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  'Input mode:',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: model.textColor),
                ),
              ),
              Expanded(
                child: Container(
                    height: 50,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            canvasColor: model.bottomSheetBackgroundColor),
                        child: DropDown(
                            value: _selectedInputMode,
                            item: _encoding.map((String value) {
                              return DropdownMenuItem<String>(
                                  value: (value != null) ? value : 'Binary',
                                  child: Text('$value',
                                      textAlign: TextAlign.center,
                                      style:
                                          TextStyle(color: model.textColor)));
                            }).toList(),
                            valueChanged: (dynamic value) {
                              _onInputModeChanged(value, model);
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
          height: 70,
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
                    height: 50,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            canvasColor: model.bottomSheetBackgroundColor),
                        child: DropDown(
                            value: _selectedErrorCorrectionLevel,
                            item: _errorCorrectionLevels.map((String value) {
                              return DropdownMenuItem<String>(
                                  value: (value != null) ? value : 'Quartile',
                                  child: Text('$value',
                                      textAlign: TextAlign.center,
                                      style:
                                          TextStyle(color: model.textColor)));
                            }).toList(),
                            valueChanged: (dynamic value) {
                              _onErrorCorrectionLevelChanged(value, model);
                            }),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    ]);
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
    setState(() {});
  }

  Widget _getQRCodeGenerator(
      [String _inputValue,
      ErrorCorrectionLevel _correctionLevel,
      QRInputMode _inputMode,
      EdgeInsets _padding,
      double height]) {
    return Center(
      child: Container(
          height: height != null ? height : kIsWeb ? 300 : double.infinity,
          child: Padding(
            padding: _padding != null ? _padding : const EdgeInsets.all(30),
            child: SfBarcodeGenerator(
              value: _inputValue ?? 'http://www.syncfusion.com',
              textAlign: TextAlign.justify,
              textSpacing: 10,
              showValue: false,
              symbology: QRCode(
                  inputMode: _inputMode ?? QRInputMode.binary,
                  codeVersion: QRCodeVersion.auto,
                  errorCorrectionLevel:
                      _correctionLevel ?? ErrorCorrectionLevel.quartile),
            ),
          )),
    );
  }
}
