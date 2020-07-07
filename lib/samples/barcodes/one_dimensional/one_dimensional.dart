import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/foundation.dart';

//ignore: must_be_immutable
class OneDimensionalBarcodes extends StatefulWidget {
  OneDimensionalBarcodes({this.sample, Key key}) : super(key: key);
  SubItem sample;
  @override
  _OneDimensionalBarcodesState createState() =>
      _OneDimensionalBarcodesState(sample);
}

class _OneDimensionalBarcodesState extends State<OneDimensionalBarcodes> {
  _OneDimensionalBarcodesState(this.sample);

  final SubItem sample;
  bool panelOpen;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);
  List<String> subjectCollection;
  List<Color> colorCollection;
  Widget sampleWidget(SampleModel model) => OneDimensionalBarcodes();

  @override
  void initState() {
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    super.initState();
  }

  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;

  @override
  void didUpdateWidget(OneDimensionalBarcodes oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build([BuildContext context]) {
    EdgeInsets _padding = const EdgeInsets.fromLTRB(0, 20, 0, 0);
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      _padding = const EdgeInsets.fromLTRB(0, 20, 0, 0);
    } else {
      //ignore: prefer_final_locals
      double _margin = (MediaQuery.of(context).size.width -
              MediaQuery.of(context).size.width * 0.6) /
          2;

      _padding = EdgeInsets.fromLTRB(_margin, 20, _margin, 0);
    }
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          return Scaffold(
            backgroundColor:
                model.isWeb ? Colors.transparent : model.cardThemeColor,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
              child: Padding(
                padding: _padding,
                child: Container(child: getOneDimensionalBarcodes(context)),
              ),
            ),
          );
        });
  }
}

Widget getOneDimensionalBarcodes(BuildContext context) {
  return SingleChildScrollView(
    child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _getSampleWidget(context)),
  );
}

List<Widget> _getWidgetForWeb(BuildContext context) {
  final ThemeData _themeData = Theme.of(context);
  final Color _color = _themeData.brightness == Brightness.dark
      ? const Color(0xFF666666)
      : const Color(0xFFC4C4C4);
  return <Widget>[
    Container(
      height: 125,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Container(
                width: 200,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(1, 10, 1, 10),
                  child: SfBarcodeGenerator(
                    textAlign: TextAlign.justify,
                    textSpacing: 10,
                    value: '123456789',
                    showValue: true,
                    symbology: Codabar(module: 1),
                  ),
                )),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 1, 1),
                child: Text('Codabar',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(15, 2, 1, 10),
                  child: Text(
                      'Supports 0-9,-,\$,:,/,.,+           '
                      '                                  ',
                      style: TextStyle(fontSize: 12)))
            ],
          )
        ],
      ),
    ),
    Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Divider(height: 20.0, indent: 5.0, color: _color)),
    Container(
      height: 125,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Container(
                width: 200,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 1, 10),
                  child: SfBarcodeGenerator(
                    textAlign: TextAlign.justify,
                    textSpacing: 10,
                    value: 'CODE39',
                    showValue: true,
                    symbology: Code39(module: 1),
                  ),
                )),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 1, 1),
                child: Text('Code39',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(15, 2, 1, 10),
                  child: Text(
                      'Supports A-Z, 0-9,-, ., \$, /, +, %, and space   '
                      '    ',
                      style: TextStyle(fontSize: 12)))
            ],
          ),
        ],
      ),
    ),
    Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Divider(height: 20.0, indent: 5.0, color: _color)),
    Container(
      height: 125,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Container(
                width: 200,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(1, 10, 1, 10),
                    child: Container(
                      child: SfBarcodeGenerator(
                        textAlign: TextAlign.justify,
                        // backgroundColor: Colors.red,
                        textSpacing: 10,
                        value: '051091',
                        showValue: true,
                        symbology: Code39Extended(module: 1),
                      ),
                    ))),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 1, 1),
                child: Text('Code39 Extended',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(15, 2, 1, 10),
                  child: Text(
                      'Supports only ASCII characters.           '
                      '            ',
                      style: TextStyle(fontSize: 12)))
            ],
          )
        ],
      ),
    ),
    Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Divider(height: 20.0, indent: 5.0, color: _color)),
    Container(
      height: 125,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Container(
                width: 200,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(1, 10, 20, 10),
                    child: Container(
                      child: SfBarcodeGenerator(
                        textAlign: TextAlign.justify,
                        //    backgroundColor: Colors.red,
                        textSpacing: 10,
                        value: '01234567',
                        showValue: true,
                        symbology: Code93(module: 1),
                      ),
                    ))),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 1, 1),
                child: Text('Code93',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(15, 2, 1, 10),
                  child: Text(
                      'Supports  A-Z, 0-9 , -, ., \$, /, +, % and space',
                      style: TextStyle(fontSize: 12)))
            ],
          ),
        ],
      ),
    ),
    Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Divider(height: 20.0, indent: 5.0, color: _color)),
    Container(
      height: 125,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Container(
                width: 200,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(1, 10, 25, 10),
                    child: Container(
                      child: SfBarcodeGenerator(
                        textAlign: TextAlign.justify,
                        textStyle: const TextStyle(fontSize: 10),
                        textSpacing: 3,
                        value: '72527273070',
                        showValue: true,
                        symbology: UPCA(module: 1),
                      ),
                    ))),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 1, 1),
                child: Text('UPC-A',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(15, 2, 1, 10),
                  child: Text(
                      'Supports 11 numbers as input                   '
                      '      ',
                      style: TextStyle(fontSize: 12)))
            ],
          ),
        ],
      ),
    ),
    Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Divider(height: 20.0, indent: 5.0, color: _color)),
    Container(
      height: 125,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Container(
                width: 200,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
                  child: Container(
                      child: SfBarcodeGenerator(
                    textAlign: TextAlign.justify,
                    // backgroundColor: Colors.red,
                    textSpacing: 3,
                    value: '123456',
                    showValue: true,
                    symbology: UPCE(module: kIsWeb ? 2 : 1),
                  )),
                )),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 1, 1),
                child: Text('UPC-E',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(15, 2, 1, 10),
                  child: Text(
                      'Supports 6 numbers as input                    '
                      '     ',
                      style: TextStyle(fontSize: 12)))
            ],
          )
        ],
      ),
    ),
    Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Divider(height: 20.0, indent: 5.0, color: _color)),
    Container(
      height: 125,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Container(
                width: 200,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(1, 10, 20, 10),
                    child: Container(
                      child: SfBarcodeGenerator(
                        textAlign: TextAlign.justify,
                        // backgroundColor: Colors.red,
                        textSpacing: 3,
                        value: '11223344',
                        showValue: true,
                        symbology: EAN8(module: 2),
                      ),
                    ))),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 1, 1),
                child: Text('EAN-8',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(15, 2, 1, 10),
                  child: Text('Supports 8 numbers as input                    ',
                      style: TextStyle(fontSize: 12)))
            ],
          )
        ],
      ),
    ),
    Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Divider(height: 20.0, indent: 5.0, color: _color)),
    Container(
      height: 125,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Container(
                width: 200,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(7, 10, 35, 10),
                    child: Container(
                      child: SfBarcodeGenerator(
                        textAlign: TextAlign.justify,
                        textStyle: const TextStyle(fontSize: 11),
                        textSpacing: 3,
                        value: '9735940564824',
                        showValue: true,
                        symbology: EAN13(module: 1),
                      ),
                    ))),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 1, 1),
                child: Text('EAN-13',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(15, 2, 1, 10),
                  child: Text(
                      'Supports 13 numbers as input                    ',
                      style: TextStyle(fontSize: 12)))
            ],
          )
        ],
      ),
    ),
    Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Divider(height: 20.0, indent: 5.0, color: _color)),
    Container(
      height: 125,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Container(
                width: 200,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 20, 10),
                    child: Container(
                      child: SfBarcodeGenerator(
                        textAlign: TextAlign.justify,
                        textSpacing: 10,
                        value: 'CODE128',
                        showValue: true,
                        symbology: Code128(module: 1),
                      ),
                    ))),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(25, 10, 1, 1),
                child: Text('Code128',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(25, 2, 1, 10),
                  child: Text('Support 0-9 A-Z a-z and special character.   ',
                      style: TextStyle(fontSize: 12)))
            ],
          )
        ],
      ),
    ),
    Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Divider(height: 20.0, indent: 5.0, color: _color)),
    Container(
      height: 125,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Container(
                width: 200,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 10, 30, 10),
                    child: Container(
                      child: SfBarcodeGenerator(
                        textAlign: TextAlign.justify,
                        textSpacing: 10,
                        value: 'CODE128A',
                        showValue: true,
                        symbology: Code128A(module: 1),
                      ),
                    ))),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 1, 1),
                child: Text('Code128A',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(15, 2, 1, 10),
                  child: Text(
                      'Support 0-9 A-Z and special character           ',
                      style: TextStyle(fontSize: 12)))
            ],
          )
        ],
      ),
    ),
    Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Divider(height: 20.0, indent: 5.0, color: _color)),
    Container(
      height: 125,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Container(
                width: 200,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 10, 20, 10),
                  child: Container(
                      child: SfBarcodeGenerator(
                    textAlign: TextAlign.justify,
                    textSpacing: 10,
                    value: 'Code128B',
                    showValue: true,
                    symbology: Code128B(module: 1),
                  )),
                )),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 1, 1),
                child: Text('Code128B',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(15, 2, 1, 10),
                  child: Text(
                      'Support 0-9 A-Z and special character           ',
                      style: TextStyle(fontSize: 12)))
            ],
          )
        ],
      ),
    ),
    Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Divider(height: 20.0, indent: 5.0, color: _color)),
    Container(
      height: 125,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Container(
                width: 200,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 10, 20, 10),
                    child: Container(
                      child: SfBarcodeGenerator(
                        textAlign: TextAlign.justify,
                        textSpacing: 10,
                        value: '0123456',
                        showValue: true,
                        symbology: Code128C(module: 1),
                      ),
                    ))),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(25, 10, 1, 1),
                child: Text('Code128C',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(25, 2, 1, 10),
                  child: Text('Support even number of digits                 ',
                      style: TextStyle(fontSize: 12)))
            ],
          )
        ],
      ),
    ),
  ];
}

List<Widget> _getWidget(BuildContext context) {
  final ThemeData _themeData = Theme.of(context);
  final Color _color = _themeData.brightness == Brightness.dark
      ? const Color(0xFF666666)
      : const Color(0xFFC4C4C4);
  return <Widget>[
    Container(
      height: 125,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(1, 10, 1, 10),
              child: SfBarcodeGenerator(
                textAlign: TextAlign.justify,
                textSpacing: 10,
                value: '123456789',
                showValue: true,
                symbology: Codabar(),
              ),
            )),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 1, 1),
                  child: Text('Codabar',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(15, 2, 1, 10),
                    child: Text('Supports Supports 0-9,-,\$,:,/,.,+',
                        style: TextStyle(fontSize: 12)))
              ],
            ),
          )
        ],
      ),
    ),
    Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Divider(height: 20.0, indent: 5.0, color: _color)),
    Container(
      height: 125,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(1, 10, 1, 10),
              child: SfBarcodeGenerator(
                textAlign: TextAlign.justify,
                textSpacing: 10,
                value: 'CODE39',
                showValue: true,
                symbology: Code39(),
              ),
            )),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 1, 1),
                  child: Text('Code39',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(15, 2, 1, 10),
                    child: Text(
                        'Supports A-Z, 0-9,-, ., \$, /, +, %, and space ',
                        style: TextStyle(fontSize: 12)))
              ],
            ),
          )
        ],
      ),
    ),
    Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Divider(height: 20.0, indent: 5.0, color: _color)),
    Container(
      height: 125,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(1, 10, 1, 10),
                    child: Container(
                      child: SfBarcodeGenerator(
                        textAlign: TextAlign.justify,
                        // backgroundColor: Colors.red,
                        textSpacing: 10,
                        value: '051091',
                        showValue: true,
                        symbology: Code39Extended(),
                      ),
                    ))),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 1, 1),
                  child: Text('Code39 Extended',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(15, 2, 1, 10),
                    child: Text('Supports only ASCII characters.',
                        style: TextStyle(fontSize: 12)))
              ],
            ),
          )
        ],
      ),
    ),
    Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Divider(height: 20.0, indent: 5.0, color: _color)),
    Container(
      height: 125,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(1, 10, 1, 10),
                    child: Container(
                      child: SfBarcodeGenerator(
                        textAlign: TextAlign.justify,
                        //    backgroundColor: Colors.red,
                        textSpacing: 10,
                        value: '01234567',
                        showValue: true,
                        symbology: Code93(),
                      ),
                    ))),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 1, 1),
                  child: Text('Code93',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(15, 2, 1, 10),
                    child: Text('A-Z, 0-9 , -, ., \$, /, +, % and space',
                        style: TextStyle(fontSize: 12)))
              ],
            ),
          )
        ],
      ),
    ),
    Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Divider(height: 20.0, indent: 5.0, color: _color)),
    Container(
      height: 125,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(1, 10, 1, 10),
                    child: Container(
                      child: SfBarcodeGenerator(
                        textAlign: TextAlign.justify,
                        //   backgroundColor: Colors.red,
                        textSpacing: 3,
                        value: '72527273070',
                        showValue: true,
                        textStyle: const TextStyle(fontSize: 11),
                        symbology: UPCA(),
                      ),
                    ))),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 1, 1),
                  child: Text('UPC-A',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(15, 2, 1, 10),
                    child: Text('Supports 11 numbers as input',
                        style: TextStyle(fontSize: 12)))
              ],
            ),
          )
        ],
      ),
    ),
    Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Divider(height: 20.0, indent: 5.0, color: _color)),
    Container(
      height: 125,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(1, 10, 1, 10),
              child: Container(
                  child: SfBarcodeGenerator(
                textAlign: TextAlign.justify,
                // backgroundColor: Colors.red,
                textSpacing: 3,
                value: '123456',
                showValue: true,
                symbology: UPCE(),
              )),
            )),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 1, 1),
                  child: Text('UPC-E',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(15, 2, 1, 10),
                    child: Text('Supports 6 numbers as input',
                        style: TextStyle(fontSize: 12)))
              ],
            ),
          )
        ],
      ),
    ),
    Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Divider(height: 20.0, indent: 5.0, color: _color)),
    Container(
      height: 125,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(1, 10, 1, 10),
                    child: Container(
                      child: SfBarcodeGenerator(
                        textAlign: TextAlign.justify,
                        // backgroundColor: Colors.red,
                        textSpacing: 3,
                        value: '11223344',
                        showValue: true,
                        symbology: EAN8(),
                      ),
                    ))),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 1, 1),
                  child: Text('EAN-8',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(15, 2, 1, 10),
                    child: Text('Supports 8 numbers as input',
                        style: TextStyle(fontSize: 12)))
              ],
            ),
          )
        ],
      ),
    ),
    Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Divider(height: 20.0, indent: 5.0, color: _color)),
    Container(
      height: 125,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(1, 10, 1, 10),
                    child: Container(
                      child: SfBarcodeGenerator(
                        textAlign: TextAlign.justify,
                        textSpacing: 3,
                        value: '9735940564824',
                        showValue: true,
                        textStyle: const TextStyle(fontSize: 11),
                        symbology: EAN13(module: 1),
                      ),
                    ))),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 1, 1),
                  child: Text('EAN-13',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(15, 2, 1, 10),
                    child: Text('Supports 13 numbers as input',
                        style: TextStyle(fontSize: 12)))
              ],
            ),
          )
        ],
      ),
    ),
    Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Divider(height: 20.0, indent: 5.0, color: _color)),
    Container(
      height: 125,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(1, 10, 1, 10),
                    child: Container(
                      child: SfBarcodeGenerator(
                        textAlign: TextAlign.justify,
                        textSpacing: 10,
                        value: 'CODE128',
                        showValue: true,
                        symbology: Code128(),
                      ),
                    ))),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 1, 1),
                  child: Text('Code128',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(15, 2, 1, 10),
                    child: Text('Support 0-9 A-Z a-z and special character',
                        style: TextStyle(fontSize: 12)))
              ],
            ),
          )
        ],
      ),
    ),
    Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Divider(height: 20.0, indent: 5.0, color: _color)),
    Container(
      height: 125,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(1, 10, 1, 10),
                    child: Container(
                      child: SfBarcodeGenerator(
                        textAlign: TextAlign.justify,
                        textSpacing: 10,
                        value: 'CODE128A',
                        showValue: true,
                        symbology: Code128A(),
                      ),
                    ))),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 1, 1),
                  child: Text('Code128A',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(15, 2, 1, 10),
                    child: Text('Support 0-9 A-Z and special character',
                        style: TextStyle(fontSize: 12)))
              ],
            ),
          )
        ],
      ),
    ),
    Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Divider(height: 20.0, indent: 5.0, color: _color)),
    Container(
      height: 125,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(1, 10, 1, 10),
              child: Container(
                  child: SfBarcodeGenerator(
                textAlign: TextAlign.justify,
                textSpacing: 10,
                value: 'Code128B',
                showValue: true,
                symbology: Code128B(),
              )),
            )),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 1, 1),
                  child: Text('Code128B',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(15, 2, 1, 10),
                    child: Text('Support 0-9 A-Z and special character',
                        style: TextStyle(fontSize: 12)))
              ],
            ),
          )
        ],
      ),
    ),
    Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Divider(height: 20.0, indent: 5.0, color: _color)),
    Container(
      height: 125,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(1, 10, 1, 10),
                    child: Container(
                      child: SfBarcodeGenerator(
                        textAlign: TextAlign.justify,
                        textSpacing: 10,
                        value: '0123456',
                        showValue: true,
                        symbology: Code128C(),
                      ),
                    ))),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 1, 1),
                  child: Text('Code128C',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(15, 2, 1, 10),
                    child: Text('Support even number of digits',
                        style: TextStyle(fontSize: 12)))
              ],
            ),
          )
        ],
      ),
    ),
  ];
}

List<Widget> _getSampleWidget(BuildContext context) {
  if (kIsWeb) {
    return _getWidgetForWeb(context);
  } else {
    return _getWidget(context);
  }
}
