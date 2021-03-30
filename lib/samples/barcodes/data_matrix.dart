/// Flutter package imports
import 'package:flutter/material.dart';

/// Barcode imports
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

/// Local imports
import '../../model/sample_view.dart';

/// Renders the Data Matrix barcode generator sample
class DataMatrixGenerator extends SampleView {
  /// Creates the Data Matrix barcode generator sample
  const DataMatrixGenerator(Key key) : super(key: key);
  @override
  _DataMatrixGeneratorState createState() => _DataMatrixGeneratorState();
}

class _DataMatrixGeneratorState extends SampleViewState {
  _DataMatrixGeneratorState();

  late String _inputValue;

  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _inputValue = 'http://www.syncfusion.com';
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
    EdgeInsets _padding = const EdgeInsets.all(0);
    double _margin;
    if (!model.isWebFullView) {
      _margin = (MediaQuery.of(context).size.width -
              MediaQuery.of(context).size.width * 0.6) /
          2;
      _padding = EdgeInsets.fromLTRB(_margin, 0, _margin, 0);
    }
    return Scaffold(
      backgroundColor:
          model.isWebFullView ? Colors.transparent : model.cardThemeColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
        child:
            Container(child: _buildDataMatrixGenerator(_inputValue, _padding)),
      ),
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(shrinkWrap: true, children: <Widget>[
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
    ]);
  }

  /// Returns the data matrix barcode generator
  Widget _buildDataMatrixGenerator(String _inputValue, EdgeInsets _padding) {
    return Center(
      child: Container(
          height: model.isWebFullView ? 300 : double.infinity,
          child: Padding(
            padding: _padding,
            child: SfBarcodeGenerator(
              value: _inputValue,
              textAlign: TextAlign.justify,
              textSpacing: 10,
              showValue: false,
              symbology: DataMatrix(encoding: DataMatrixEncoding.base256),
            ),
          )),
    );
  }
}
