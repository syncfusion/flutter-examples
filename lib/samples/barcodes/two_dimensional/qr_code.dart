/// Flutter package imports
import 'package:flutter/material.dart';

/// Barcode imports
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../../../widgets/custom_dropdown.dart';

/// Renders the QR barcode generator sample
class QRCodeGenerator extends SampleView {
  /// Creates the QR barcode generator sample
  const QRCodeGenerator(Key key) : super(key: key);
  @override
  _QRCodeGeneratorState createState() => _QRCodeGeneratorState();
}

class _QRCodeGeneratorState extends SampleViewState {
  _QRCodeGeneratorState();

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
    super.initState();
    _selectedInputMode = 'Binary';
    _inputValue = 'http://www.syncfusion.com';
    _selectedErrorCorrectionLevel = 'Quartile';
    _errorCorrectionLevel = ErrorCorrectionLevel.quartile;
    _inputMode = QRInputMode.binary;
    _textEditingController = TextEditingController.fromValue(
      TextEditingValue(
        text: model.isWeb ? 'http://www.syncfusion.com' : _inputValue,
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build([BuildContext context]) {
    EdgeInsets _padding = const EdgeInsets.all(0);
    double _margin;
    if (!model.isWeb) {
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
      ),
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
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
                                          style: TextStyle(
                                              color: model.textColor)));
                                }).toList(),
                                valueChanged: (dynamic value) {
                                  _onInputModeChanged(value);
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
                                item:
                                    _errorCorrectionLevels.map((String value) {
                                  return DropdownMenuItem<String>(
                                      value:
                                          (value != null) ? value : 'Quartile',
                                      child: Text('$value',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: model.textColor)));
                                }).toList(),
                                valueChanged: (dynamic value) {
                                  _onErrorCorrectionLevelChanged(value);
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

  /// Updating the input mode in QR barcode
  void _onInputModeChanged(String item) {
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
    setState(() {
      /// update the QR input mode changes
    });
  }

  /// Updating the error correction level in QR barcode
  void _onErrorCorrectionLevelChanged(String item) {
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
    setState(() {
      ///Updating the error correction level
    });
  }

  /// Returns the QR barcode
  Widget _getQRCodeGenerator(
      [String _inputValue,
      ErrorCorrectionLevel _correctionLevel,
      QRInputMode _inputMode,
      EdgeInsets _padding]) {
    return Center(
      child: Container(
          height: model.isWeb ? 300 : double.infinity,
          child: Padding(
            padding: _padding ?? const EdgeInsets.all(30),
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
