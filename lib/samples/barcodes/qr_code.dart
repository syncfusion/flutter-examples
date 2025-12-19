/// Flutter package imports
import 'package:flutter/material.dart';

/// Barcode imports
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

/// Local imports
import '../../model/sample_view.dart';

/// Renders the QR barcode generator sample
class QRCodeGenerator extends SampleView {
  /// Creates the QR barcode generator sample
  const QRCodeGenerator(Key key) : super(key: key);
  @override
  _QRCodeGeneratorState createState() => _QRCodeGeneratorState();
}

class _QRCodeGeneratorState extends SampleViewState {
  _QRCodeGeneratorState();

  late List<String> _encoding;
  late List<String> _errorCorrectionLevels;
  late ErrorCorrectionLevel _errorCorrectionLevel;
  late String _selectedErrorCorrectionLevel;
  late QRInputMode _inputMode;
  late String _selectedInputMode;
  late String _inputValue;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _encoding = <String>['numeric', 'alphaNumeric', 'binary'];
    _errorCorrectionLevels = <String>['high', 'quartile', 'medium', 'low'];
    _selectedInputMode = 'binary';
    _inputValue = 'http://www.syncfusion.com';
    _selectedErrorCorrectionLevel = 'quartile';
    _errorCorrectionLevel = ErrorCorrectionLevel.quartile;
    _inputMode = QRInputMode.binary;
    _textEditingController = TextEditingController.fromValue(
      TextEditingValue(
        text: model.isWebFullView ? 'http://www.syncfusion.com' : _inputValue,
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = EdgeInsets.zero;
    double margin;
    if (!model.isWebFullView) {
      margin =
          (MediaQuery.of(context).size.width -
              MediaQuery.of(context).size.width * 0.6) /
          2;
      padding = EdgeInsets.fromLTRB(margin, 0, margin, 0);
    }

    return Scaffold(
      backgroundColor: model.isWebFullView
          ? Colors.transparent
          : model.sampleOutputCardColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: Container(
          child: _buildQRCodeGenerator(
            _inputValue,
            _errorCorrectionLevel,
            _inputMode,
            padding,
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          children: <Widget>[
            SizedBox(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Input value:',
                    overflow: TextOverflow.clip,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: model.textColor,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(canvasColor: model.drawerBackgroundColor),
                      child: TextField(
                        style: TextStyle(color: model.textColor),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: model.textColor),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        onChanged: (String text) {
                          setState(() {
                            _inputValue = text;
                          });
                        },
                        controller: _textEditingController,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Input mode:',
                    overflow: TextOverflow.clip,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: model.textColor,
                    ),
                  ),
                ),
                DropdownButton<String>(
                  dropdownColor: model.drawerBackgroundColor,
                  focusColor: Colors.transparent,
                  underline: Container(
                    color: const Color(0xFFBDBDBD),
                    height: 1,
                  ),
                  value: _selectedInputMode,
                  items: _encoding.map((String value) {
                    return DropdownMenuItem<String>(
                      value: (value != null) ? value : 'binary',
                      child: Text(
                        value,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: model.textColor),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    _onInputModeChanged(value.toString());
                    stateSetter(() {});
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Error level:',
                    overflow: TextOverflow.clip,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: model.textColor,
                    ),
                  ),
                ),
                DropdownButton<String>(
                  dropdownColor: model.drawerBackgroundColor,
                  focusColor: Colors.transparent,
                  underline: Container(
                    color: const Color(0xFFBDBDBD),
                    height: 1,
                  ),
                  value: _selectedErrorCorrectionLevel,
                  items: _errorCorrectionLevels.map((String value) {
                    return DropdownMenuItem<String>(
                      value: (value != null) ? value : 'quartile',
                      child: Text(
                        value,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: model.textColor),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    _onErrorCorrectionLevelChanged(value.toString());
                    stateSetter(() {});
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Updating the input mode in QR barcode
  void _onInputModeChanged(String item) {
    _selectedInputMode = item;
    switch (_selectedInputMode) {
      case 'numeric':
        _inputMode = QRInputMode.numeric;
        break;
      case 'alphaNumeric':
        _inputMode = QRInputMode.alphaNumeric;
        break;
      case 'binary':
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
      case 'high':
        _errorCorrectionLevel = ErrorCorrectionLevel.high;
        break;
      case 'quartile':
        _errorCorrectionLevel = ErrorCorrectionLevel.quartile;
        break;
      case 'medium':
        _errorCorrectionLevel = ErrorCorrectionLevel.medium;
        break;
      case 'low':
        _errorCorrectionLevel = ErrorCorrectionLevel.low;
        break;
    }
    setState(() {
      ///Updating the error correction level
    });
  }

  /// Returns the QR barcode
  Widget _buildQRCodeGenerator(
    String inputValue,
    ErrorCorrectionLevel correctionLevel,
    QRInputMode inputMode,
    EdgeInsets padding,
  ) {
    return Center(
      child: SizedBox(
        height: model.isWebFullView ? 300 : double.infinity,
        child: Padding(
          padding: padding,
          child: SfBarcodeGenerator(
            value: inputValue,
            textAlign: TextAlign.justify,
            textSpacing: 10,
            symbology: QRCode(
              inputMode: inputMode,
              codeVersion: QRCodeVersion.auto,
              errorCorrectionLevel: correctionLevel,
            ),
          ),
        ),
      ),
    );
  }
}
