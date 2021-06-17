import 'dart:typed_data';
import 'dart:ui' as ui;

///Package import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

///Signature pad imports.
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../shared/mobile_image_converter.dart'
    if (dart.library.html) '../shared/web_image_converter.dart';

///Renders the signature pad widget.
class GettingStartedSignaturePad extends SampleView {
  /// Creates getting started signature pad.
  const GettingStartedSignaturePad(Key key) : super(key: key);

  @override
  _GettingStartedSignaturePadState createState() =>
      _GettingStartedSignaturePadState();
}

class _GettingStartedSignaturePadState extends SampleViewState {
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

  List<Color> _strokeColors = <Color>[];
  double _minWidth = 1.0;
  double _maxWidth = 4.0;
  bool _isSigned = false;
  int _selectedPenIndex = 0;
  bool _isDark = false;

  late Color _strokeColor;
  Color? _backgroundColor;
  late Uint8List _signatureData;
  final double _fontSizeRegular = 12;
  late _ProductDataSource _productDataSource;
  late List<Widget> _strokeColorWidgets;
  late bool _isWebOrDesktop;

  @override
  void initState() {
    _addColors();
    _productDataSource = _ProductDataSource(_loadDataSource());
    _minWidth = kIsWeb ? 2.0 : 1.0;
    _maxWidth = kIsWeb ? 2.0 : 4.0;
    _isWebOrDesktop = defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        kIsWeb;
    super.initState();
  }

  List<_Product> _loadDataSource() {
    return <_Product>[
      const _Product(name: 'Jersey', price: 49.99, quantity: 3, total: 149.97),
      const _Product(
          name: 'AWC Logo Cap', price: 8.99, quantity: 2, total: 17.98),
      const _Product(
          name: 'ML Fork ', price: 175.49, quantity: 6, total: 1052.94)
    ];
  }

  void _addColors() {
    _strokeColors = <Color>[];
    _strokeColors.add(const Color.fromRGBO(0, 0, 0, 1));
    _strokeColors.add(const Color.fromRGBO(35, 93, 217, 1));
    _strokeColors.add(const Color.fromRGBO(77, 180, 36, 1));
    _strokeColors.add(const Color.fromRGBO(228, 77, 49, 1));
  }

  List<Widget> _addStrokeColorPalettes(StateSetter stateChanged) {
    _strokeColorWidgets = <Widget>[];
    for (int i = 0; i < _strokeColors.length; i++) {
      _strokeColorWidgets.add(
        Material(
          color: Colors.transparent,
          child: Ink(
            decoration: const BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: InkWell(
              onTap: () => stateChanged(
                () {
                  _strokeColor = _strokeColors[i];
                  _selectedPenIndex = i;
                },
              ),
              child: Center(
                child: Stack(
                  children: <Widget>[
                    Icon(Icons.brightness_1,
                        size: 25.0, color: _strokeColors[i]),
                    if (_selectedPenIndex != null && _selectedPenIndex == i)
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Icon(Icons.check,
                            size: 15.0,
                            color: _isDark ? Colors.black : Colors.white),
                      )
                    else
                      const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return _strokeColorWidgets;
  }

  void _handleOnSignStart() {
    _isSigned = true;
  }

  void _showPopup() {
    _isSigned = false;

    if (_isWebOrDesktop) {
      _backgroundColor = _isDark ? model.webBackgroundColor : Colors.white;
    }

    showDialog<Widget>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            final Color? backgroundColor = _backgroundColor;
            final Color textColor = _isDark ? Colors.white : Colors.black87;

            return AlertDialog(
              insetPadding: const EdgeInsets.all(12.0),
              backgroundColor: backgroundColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Draw your signature',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto-Medium')),
                  InkWell(
                    //ignore: sdk_version_set_literal
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.clear,
                        color: _isDark
                            ? Colors.grey[400]
                            : const Color.fromRGBO(0, 0, 0, 0.54),
                        size: 24.0),
                  )
                ],
              ),
              titlePadding: const EdgeInsets.all(16.0),
              content: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width < 306
                      ? MediaQuery.of(context).size.width
                      : 306,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width < 306
                            ? MediaQuery.of(context).size.width
                            : 306,
                        height: 172,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: _getBorderColor()!, width: 1),
                        ),
                        child: SfSignaturePad(
                            minimumStrokeWidth: _minWidth,
                            maximumStrokeWidth: _maxWidth,
                            strokeColor: _strokeColor,
                            backgroundColor: _backgroundColor,
                            onSignStart: _handleOnSignStart,
                            key: _signaturePadKey),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Pen Color',
                            style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Roboto-Regular'),
                          ),
                          Container(
                            width: 124,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: _addStrokeColorPalettes(setState),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
              actionsPadding: const EdgeInsets.all(8.0),
              buttonPadding: EdgeInsets.zero,
              actions: <Widget>[
                TextButton(
                  onPressed: _handleClearButtonPressed,
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        model.currentPaletteColor),
                  ),
                  child: const Text(
                    'CLEAR',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto-Medium'),
                  ),
                ),
                const SizedBox(width: 8.0),
                TextButton(
                  onPressed: () {
                    _handleSaveButtonPressed();
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        model.currentPaletteColor),
                  ),
                  child: const Text('SAVE',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto-Medium')),
                )
              ],
            );
          },
        );
      },
    );
  }

  void _handleClearButtonPressed() {
    _signaturePadKey.currentState!.clear();
    _isSigned = false;
  }

  Future<void> _handleSaveButtonPressed() async {
    late Uint8List data;

    if (kIsWeb) {
      final RenderSignaturePad renderSignaturePad =
          _signaturePadKey.currentState!.context.findRenderObject()!
              as RenderSignaturePad;
      data =
          await ImageConverter.toImage(renderSignaturePad: renderSignaturePad);
    } else {
      final ui.Image imageData =
          await _signaturePadKey.currentState!.toImage(pixelRatio: 3.0);
      final ByteData? bytes =
          await imageData.toByteData(format: ui.ImageByteFormat.png);
      if (bytes != null) {
        data = bytes.buffer.asUint8List();
      }
    }

    setState(
      () {
        _signatureData = data;
      },
    );
  }

  Widget _getInvoiceHeader() {
    return Container(
      height: 60,
      child: const Center(
        child: Text(
          'INVOICE',
          style: TextStyle(
              color: Color.fromRGBO(91, 126, 215, 1),
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _getProductDetails() {
    return Column(children: <Widget>[
      Container(
        padding: const EdgeInsets.all(20),
        height: 250,
        child: IgnorePointer(
          ignoring: true,
          child: SfDataGridTheme(
            data: SfDataGridThemeData(
              brightness: _isDark ? Brightness.dark : Brightness.light,
              headerColor: Colors.transparent,
              gridLineStrokeWidth: 1,
              gridLineColor: _isDark ? Colors.grey[850] : Colors.grey[200],
            ),
            child: SfDataGrid(
              source: _productDataSource,
              columnWidthMode: ColumnWidthMode.fill,
              columns: <GridColumn>[
                GridTextColumn(
                  columnName: 'name',
                  label: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(10.0, 5.0, 0, 5.0),
                    color: Colors.transparent,
                    child: Text(
                      'Product',
                      softWrap: true,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: _getTextColor()),
                    ),
                  ),
                ),
                GridTextColumn(
                  columnName: 'price',
                  label: Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.centerRight,
                    color: Colors.transparent,
                    child: Text(
                      'Price',
                      overflow: TextOverflow.clip,
                      softWrap: true,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: _getTextColor()),
                    ),
                  ),
                ),
                GridTextColumn(
                  columnName: 'quantity',
                  label: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.all(8),
                    color: Colors.transparent,
                    child: Text(
                      'Quantity',
                      softWrap: true,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: _getTextColor()),
                    ),
                  ),
                ),
                GridTextColumn(
                  columnName: 'total',
                  label: Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.centerRight,
                    color: Colors.transparent,
                    child: Text(
                      'Total',
                      overflow: TextOverflow.clip,
                      softWrap: true,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: _getTextColor()),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0, 20.0, 0),
          child: Text(r'Grand Total : $1220.89',
              textScaleFactor: 1.0,
              style: TextStyle(
                  fontSize: _fontSizeRegular,
                  color: _getTextColor(),
                  fontWeight: FontWeight.w900),
              textAlign: TextAlign.end),
        ),
      ),
    ]);
  }

  Color? _getTextColor() => _isDark ? Colors.grey[400] : Colors.grey[700];
  Color? _getBorderColor() => _isDark ? Colors.grey[500] : Colors.grey[350];

  Widget _getBillingDetails() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedTime = formatter.format(now);

    return Container(
      height: 150,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Bill To:',
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontSize: _fontSizeRegular,
                      color: _getTextColor(),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  'Abraham Swearegin,',
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontSize: _fontSizeRegular, color: _getTextColor()),
                ),
                Text(
                  '9920 Bridge Parkway,',
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontSize: _fontSizeRegular, color: _getTextColor()),
                ),
                Text(
                  'San Mateo, California,',
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontSize: _fontSizeRegular, color: _getTextColor()),
                ),
                Text(
                  'United States.',
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontSize: _fontSizeRegular, color: _getTextColor()),
                ),
                Text(
                  '9365550136',
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontSize: _fontSizeRegular, color: _getTextColor()),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('Invoice No: 2058557939',
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        fontSize: _fontSizeRegular, color: _getTextColor()),
                    textAlign: TextAlign.end),
                const SizedBox(height: 5),
                Text('Date: ' + formattedTime,
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        fontSize: _fontSizeRegular, color: _getTextColor()),
                    textAlign: TextAlign.end),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _getBottomView() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20.0, 20, 20.0, 10),
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              //ignore: sdk_version_set_literal
              onTap: () {
                _showPopup();
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: _getBorderColor()!),
                ),
                height: 78,
                width: 138,
                child: _isSigned
                    ? Image.memory(_signatureData)
                    : Center(
                        child: Text(
                          'Tap here to sign',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: _fontSizeRegular,
                              fontWeight: FontWeight.bold,
                              color: _getTextColor()),
                        ),
                      ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('800 Interchange Blvd.',
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        fontSize: _fontSizeRegular, color: _getTextColor()),
                    textAlign: TextAlign.end),
                const SizedBox(height: 5),
                Text('Austin, TX 78721',
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        fontSize: _fontSizeRegular, color: _getTextColor()),
                    textAlign: TextAlign.end),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    //ignore: unused_local_variable
    final double _screenHeight = MediaQuery.of(context).size.height;
    _isDark = _productDataSource.isDark =
        Theme.of(context).brightness == Brightness.dark;
    _strokeColors[0] = _isDark
        ? const Color.fromRGBO(255, 255, 255, 1)
        : const Color.fromRGBO(0, 0, 0, 1);
    _strokeColor = _strokeColors[_selectedPenIndex];

    return Container(
      color:
          _isDark ? Colors.transparent : const Color.fromRGBO(250, 250, 250, 1),
      child: Center(
        child: SingleChildScrollView(
            child: Container(
          width:
              _isWebOrDesktop ? 500 : (_screenWidth > 400 ? 400 : _screenWidth),
          height: 625,
          margin: _isWebOrDesktop ? const EdgeInsets.all(10.0) : null,
          decoration: _isWebOrDesktop
              ? BoxDecoration(
                  color: _isDark ? model.webBackgroundColor : Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: _isDark
                          ? Colors.black.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                )
              : null,
          child: Column(children: <Widget>[
            _getInvoiceHeader(),
            _getBillingDetails(),
            _getProductDetails(),
            _getBottomView()
          ]),
        )),
      ),
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(shrinkWrap: true, children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: Text(
            'Minimum Width',
            style: TextStyle(fontSize: 16.0, color: model.textColor),
          ),
        ),
        const SizedBox(height: 4),
        SfSliderTheme(
            data: SfSliderThemeData(
                activeTrackColor: model.currentPrimaryColor,
                thumbColor: model.currentPrimaryColor,
                overlayRadius: 15,
                activeLabelStyle:
                    TextStyle(color: model.textColor, fontSize: 14),
                inactiveLabelStyle:
                    TextStyle(color: model.textColor, fontSize: 14),
                overlayColor: model.currentPrimaryColor.withOpacity(0.2),
                inactiveTrackColor: model.currentPrimaryColor.withOpacity(0.3)),
            child: SfSlider(
              min: 1.0,
              max: 10.0,
              stepSize: 1.0,
              showLabels: true,
              interval: 1.0,
              showTicks: true,
              value: _minWidth,
              onChanged: (dynamic newValue) {
                stateSetter(
                  () {
                    if (newValue <= _maxWidth == true) {
                      _minWidth = newValue as double;
                    }
                  },
                );
              },
            )),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: Text(
            'Maximum Width',
            style: TextStyle(fontSize: 16.0, color: model.textColor),
          ),
        ),
        const SizedBox(height: 4),
        SfSliderTheme(
            data: SfSliderThemeData(
                activeTrackColor: model.currentPrimaryColor,
                thumbColor: model.currentPrimaryColor,
                overlayRadius: 15,
                activeLabelStyle:
                    TextStyle(color: model.textColor, fontSize: 14),
                inactiveLabelStyle:
                    TextStyle(color: model.textColor, fontSize: 14),
                overlayColor: model.currentPrimaryColor.withOpacity(0.2),
                inactiveTrackColor: model.currentPrimaryColor.withOpacity(0.3)),
            child: SfSlider(
              min: 1.0,
              max: 10.0,
              showTicks: true,
              showLabels: true,
              interval: 1.0,
              stepSize: 1.0,
              value: _maxWidth,
              onChanged: (dynamic newValue) {
                stateSetter(
                  () {
                    if (newValue >= _minWidth == true) {
                      _maxWidth = newValue as double;
                    }
                  },
                );
              },
            )),
        const SizedBox(height: 12)
      ]);
    });
  }
}

class _Product {
  const _Product(
      {required this.name,
      required this.price,
      required this.quantity,
      required this.total});

  final String name;
  final double price;
  final int quantity;
  final double total;
}

class _ProductDataSource extends DataGridSource {
  _ProductDataSource(List<_Product> products) {
    _products = products.map<DataGridRow>((_Product e) {
      return DataGridRow(cells: <DataGridCell<Object>>[
        DataGridCell<String>(
          columnName: 'name',
          value: e.name,
        ),
        DataGridCell<double>(
          columnName: 'price',
          value: e.price,
        ),
        DataGridCell<int>(
          columnName: 'quantity',
          value: e.quantity,
        ),
        DataGridCell<double>(
          columnName: 'total',
          value: e.total,
        ),
      ]);
    }).toList();
  }

  late bool isDark;

  late List<DataGridRow> _products;

  @override
  List<DataGridRow> get rows => _products;

  Color? _getTextColor() => isDark ? Colors.grey[400] : Colors.grey[700];

  final double _fontSizeRegular = 12;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: <Widget>[
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.fromLTRB(10.0, 5.0, 0, 5.0),
        color: Colors.transparent,
        child: Text(
          row.getCells()[0].value.toString(),
          softWrap: true,
          overflow: TextOverflow.clip,
          style: TextStyle(fontSize: _fontSizeRegular, color: _getTextColor()),
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8),
        color: Colors.transparent,
        child: Text(
          row.getCells()[1].value.toString(),
          softWrap: true,
          overflow: TextOverflow.clip,
          style: TextStyle(fontSize: _fontSizeRegular, color: _getTextColor()),
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8),
        color: Colors.transparent,
        child: Text(
          row.getCells()[2].value.toString(),
          softWrap: true,
          overflow: TextOverflow.clip,
          style: TextStyle(fontSize: _fontSizeRegular, color: _getTextColor()),
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8),
        color: Colors.transparent,
        child: Text(
          row.getCells()[3].value.toString(),
          softWrap: true,
          overflow: TextOverflow.clip,
          style: TextStyle(fontSize: _fontSizeRegular, color: _getTextColor()),
        ),
      ),
    ]);
  }
}
