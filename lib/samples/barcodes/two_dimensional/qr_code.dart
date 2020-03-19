import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../widgets/bottom_sheet.dart';
import '../../../widgets/customDropDown.dart';

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



  QRCodeVersion _codeVersion;
  ErrorCorrectionLevel _errorCorrectionLevel;
  String _selectedErrorCorrectionLevel = 'High';
  QRInputMode _inputMode ;
  String _selectedInputMode = 'Binary';
  String _inputValue = 'http://www.syncfusion.com';
  TextEditingController _textEditingController;

  @override
  void initState() {

    _codeVersion = QRCodeVersion.auto;
    _errorCorrectionLevel = ErrorCorrectionLevel.high;
    _inputMode = QRInputMode.binary;
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    _textEditingController = TextEditingController.fromValue(
      TextEditingValue(
        text: _inputValue,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
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
      _margin = (MediaQuery
          .of(context)
          .size
          .width -
          MediaQuery
              .of(context)
              .size
              .width * 0.6) / 2;
      _padding = EdgeInsets.fromLTRB(_margin, 0, _margin, 0);
    }


    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          return Scaffold(
              backgroundColor: model.cardThemeColor,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                child: Container(
                    child: getQRCodeGenerator(_inputValue, _codeVersion,
                        _errorCorrectionLevel, _inputMode, _padding,
                        kIsWeb ? MediaQuery
                            .of(context)
                            .size
                            .height * 0.4 : null)),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  _showSettingsPanel(model);
                },
                child: Icon(Icons.graphic_eq, color: Colors.white),
                backgroundColor: model.backgroundColor,
              )
          );
        });
  }

  void _showSettingsPanel(SampleModel model) {
    //ignore: unused_local_variable
    final double height =
    (MediaQuery
        .of(context)
        .size
        .height > MediaQuery
        .of(context)
        .size
        .width)
        ? 0.3
        : 0.4;
    showRoundedModalBottomSheet<dynamic>(
        dismissOnTap: false,
        context: context,
        radius: 12.0,
        color: model.bottomSheetBackgroundColor,
        builder: (BuildContext context) =>
            ScopedModelDescendant<SampleModel>(
                rebuildOnChange: false,
                builder: (BuildContext context, _, SampleModel model) =>
                    SingleChildScrollView(
                      child: Container(
                          height: 300,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                15, 0, 0, 5),
                            child: Column(children: <Widget>[

                              Container(
                                height: 40,
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  children: <Widget>[
                                    Text('Settings',
                                        style: TextStyle(
                                            color: model
                                                .textColor,
                                            fontSize: 18,
                                            letterSpacing: 0.34,
                                            fontWeight: FontWeight
                                                .w500)),
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
                                padding:
                                const EdgeInsets.fromLTRB(
                                    10, 10, 0, 10),
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Input value:   ',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight
                                                  .bold,
                                              color: model
                                                  .textColor)),
                                      Container(
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              0, 5, 10, 0),
                                          height: 50,

                                          child: Align(
                                            alignment:
                                            Alignment.bottomLeft,
                                            child: Theme(
                                              data: Theme.of(
                                                  context)
                                                  .copyWith(
                                                  canvasColor: model
                                                      .bottomSheetBackgroundColor),
                                              child: TextField(

                                                  autofocus: false,
                                                  keyboardType: TextInputType
                                                      .text,
                                                  maxLines: null,
                                                  onChanged: (String _text) {
                                                    setState(() {
                                                      _inputValue =
                                                          _text;
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
                                padding:
                                const EdgeInsets.fromLTRB(
                                    10, 10, 0, 0),
                                child: Container(
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(child: Text(
                                        ' Input mode:',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight
                                                .bold,
                                            color: model
                                                .textColor),),),

                                      Expanded(child: Container(
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              15, 0, 0, 0),
                                          height: 50,

                                          child: Align(
                                            alignment:
                                            Alignment
                                                .bottomLeft,
                                            child: Theme(
                                              data: Theme.of(
                                                  context)
                                                  .copyWith(
                                                  canvasColor: model
                                                      .bottomSheetBackgroundColor),
                                              child: DropDown(
                                                  value:
                                                  _selectedInputMode,
                                                  item: _encoding
                                                      .map(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                            value: (value !=
                                                                null)
                                                                ? value
                                                                : 'Binary',
                                                            child: Text(
                                                                '$value',
                                                                textAlign: TextAlign
                                                                    .center,
                                                                style: TextStyle(
                                                                    color: model
                                                                        .textColor)));
                                                      })
                                                      .toList(),
                                                  valueChanged: (
                                                      dynamic value) {
                                                    _onInputModeChanged(
                                                        value);
                                                  }),
                                            ),
                                          )),)


                                    ],
                                  ),
                                ),
                              ),

                              Padding(
                                padding:
                                const EdgeInsets.fromLTRB(
                                    10, 10, 0, 0),
                                child: Container(
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          'Error level:   ',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight
                                                  .bold,
                                              color: model
                                                  .textColor),),
                                      )
                                      ,
                                      Expanded(
                                        child: Container(
                                            padding:
                                            const EdgeInsets
                                                .fromLTRB(
                                                15, 0, 0, 0),
                                            height: 50,

                                            child: Align(
                                              alignment:
                                              Alignment
                                                  .bottomLeft,
                                              child: Theme(
                                                data: Theme.of(
                                                    context)
                                                    .copyWith(
                                                    canvasColor: model
                                                        .bottomSheetBackgroundColor),
                                                child: DropDown(
                                                    value:
                                                    _selectedErrorCorrectionLevel,
                                                    item: _errorCorrectionLevels
                                                        .map(
                                                            (String value) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                              value: (value !=
                                                                  null)
                                                                  ? value
                                                                  : 'High',
                                                              child: Text(
                                                                  '$value',
                                                                  textAlign: TextAlign
                                                                      .center,
                                                                  style: TextStyle(
                                                                      color: model
                                                                          .textColor)));
                                                        })
                                                        .toList(),
                                                    valueChanged: (
                                                        dynamic value) {
                                                      _onErrorCorrectionLevelChanged(
                                                          value);
                                                    }),
                                              ),
                                            )),
                                      )


                                    ],
                                  ),
                                ),
                              ),

                            ]),
                          )
                      ),
                    )));
  }

  void _onInputModeChanged(String item) {
    setState(() {
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
    });
  }

  void _onErrorCorrectionLevelChanged(String item) {
    setState((){
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
    });
  }
}
Widget getQRCodeGenerator([String _inputValue, QRCodeVersion _version,
ErrorCorrectionLevel _correctionLevel, QRInputMode _inputMode,  EdgeInsets _padding, double height]) {
  return Center(
    child:  Container(
        height: height != null ? height : double.infinity,
        child: Padding(
          padding: _padding != null ? _padding : const EdgeInsets.all(30),
          child: SfBarcodeGenerator(value: _inputValue,
            textAlign: TextAlign.justify,
            textSpacing: 10,
            showValue: false, symbology: QRCode(
                inputMode:_inputMode, codeVersion: _version,
                errorCorrectionLevel: _correctionLevel),),
        )
    ),
  );
}
