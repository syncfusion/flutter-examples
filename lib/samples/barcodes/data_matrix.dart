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
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
        child: Container(
          child: _buildDataMatrixGenerator(_inputValue, padding),
        ),
      ),
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
              SizedBox(
                height: 50,
                child: Align(
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Returns the data matrix barcode generator
  Widget _buildDataMatrixGenerator(String inputValue, EdgeInsets padding) {
    return Center(
      child: SizedBox(
        height: model.isWebFullView ? 300 : double.infinity,
        child: Padding(
          padding: padding,
          child: SfBarcodeGenerator(
            value: inputValue,
            textAlign: TextAlign.justify,
            textSpacing: 10,
            symbology: DataMatrix(encoding: DataMatrixEncoding.base256),
          ),
        ),
      ),
    );
  }
}
