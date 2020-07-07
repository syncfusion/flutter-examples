import 'package:flutter_examples/model/sample_view.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter/foundation.dart';
import '../../../model/model.dart';

class DataMatrixGenerator extends SampleView {
  const DataMatrixGenerator(Key key) : super(key: key);
  @override
  _DataMatrixGeneratorState createState() => _DataMatrixGeneratorState();
}

class _DataMatrixGeneratorState extends SampleViewState {
  _DataMatrixGeneratorState();

  bool panelOpen;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);
  List<String> subjectCollection;
  List<Color> colorCollection;

  String _inputValue;

  TextEditingController _textEditingController;

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
    return Scaffold(
        backgroundColor: model.isWeb ? Colors.transparent : model.cardThemeColor,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
          child:
              Container(child: getDataMatrixGenerator(_inputValue, _padding)),
        ),);
  }

  Widget buildSettings(BuildContext context) {
    //ignore: unused_local_variable
    return ListView(children: <Widget>[
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
