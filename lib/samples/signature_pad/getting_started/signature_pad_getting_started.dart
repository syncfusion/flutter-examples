import 'package:flutter/material.dart';

///Package import
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

/// Local imports
import '../../../model/sample_view.dart';
import '../shared/mobile_image_converter.dart'
    if (dart.library.html) '../shared/web_image_converter.dart';

///Signature pad imports.
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

List<_Product> _products = <_Product>[];

final _ProductDataSource _productDataSource = _ProductDataSource();

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
  List<Widget> _strokeColorWidgets;
  List<Color> _strokeColors = <Color>[];
  double _minWidth = 1.0;
  double _maxWidth = 4.0;
  bool _isSigned = false;
  int _selectedPenIndex = 0;
  Color _strokeColor;
  Color _backgroundColor;
  Uint8List _signatureData;
  double _fontSizeRegular = 12;
  bool _isDark = false;

  @override
  void initState() {
    _addColors();
    _loadDataSource();
    _minWidth = kIsWeb ? 2.0 : 1.0;
    _maxWidth = kIsWeb ? 2.0 : 4.0;
    super.initState();
  }

  void _loadDataSource() {
    _products = <_Product>[];
    _products.add(
        _Product(name: 'Jersey', price: 49.99, quantity: 3, total: 149.97));
    _products.add(
        _Product(name: 'AWC Logo Cap', price: 8.99, quantity: 2, total: 17.98));
    _products.add(
        _Product(name: 'ML Fork ', price: 175.49, quantity: 6, total: 1052.94));
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
            child: Ink(
              decoration: BoxDecoration(
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
                    children: [
                      Icon(Icons.brightness_1,
                          size: 25.0, color: _strokeColors[i]),
                      _selectedPenIndex != null && _selectedPenIndex == i
                          ? Padding(
                              child: Icon(Icons.check,
                                  size: 15.0,
                                  color: _isDark ? Colors.black : Colors.white),
                              padding: EdgeInsets.all(5),
                            )
                          : SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ),
            color: Colors.transparent),
      );
    }

    return _strokeColorWidgets;
  }

  void _handleOnSignStart() {
    _isSigned = true;
  }

  void _showPopup() {
    _isSigned = false;

    if (kIsWeb) {
      _backgroundColor = _isDark ? model.webBackgroundColor : Colors.white;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final Color backgroundColor = _backgroundColor;
            final Color textColor = _isDark ? Colors.white : Colors.black87;

            return AlertDialog(
              insetPadding: EdgeInsets.all(12.0),
              backgroundColor: backgroundColor,
              title: Row(children: [
                Text('Draw your signature',
                    style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto-Medium')),
                InkWell(
                  child: Icon(Icons.clear,
                      color: _isDark
                          ? Colors.grey[400]
                          : Color.fromRGBO(0, 0, 0, 0.54),
                      size: 24.0),
                  //ignore: sdk_version_set_literal
                  onTap: () => {Navigator.of(context).pop()},
                )
              ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
              titlePadding: EdgeInsets.all(16.0),
              content: SingleChildScrollView(
                child: Container(
                    child: Column(children: [
                      Container(
                        child: SfSignaturePad(
                            minimumStrokeWidth: _minWidth,
                            maximumStrokeWidth: _maxWidth,
                            strokeColor: _strokeColor,
                            backgroundColor: _backgroundColor,
                            onSignStart: _handleOnSignStart,
                            key: _signaturePadKey),
                        width: MediaQuery.of(context).size.width < 306
                            ? MediaQuery.of(context).size.width
                            : 306,
                        height: 172,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: _getBorderColor(), width: 1),
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(children: <Widget>[
                        Text(
                          'Pen Color',
                          style: TextStyle(
                              fontSize: 14.0,
                              color: textColor,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Roboto-Regular'),
                        ),
                        Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: _addStrokeColorPalettes(setState),
                            ),
                            width: 124)
                      ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                    ], mainAxisAlignment: MainAxisAlignment.center),
                    width: MediaQuery.of(context).size.width < 306
                        ? MediaQuery.of(context).size.width
                        : 306),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
              actionsPadding: EdgeInsets.all(8.0),
              buttonPadding: EdgeInsets.zero,
              actions: [
                FlatButton(
                    onPressed: _handleClearButtonPressed,
                    child: const Text(
                      'CLEAR',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          fontFamily: 'Roboto-Medium'),
                    ),
                    textColor: model.currentPaletteColor),
                SizedBox(width: 8.0),
                FlatButton(
                    onPressed: () {
                      _handleSaveButtonPressed();
                      Navigator.of(context).pop();
                    },
                    child: const Text('SAVE',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            fontFamily: 'Roboto-Medium')),
                    textColor: model.currentPaletteColor)
              ],
            );
          },
        );
      },
    );
  }

  void _handleClearButtonPressed() {
    _signaturePadKey.currentState.clear();
    _isSigned = false;
  }

  void _handleSaveButtonPressed() async {
    Uint8List data;

    if (kIsWeb) {
      RenderSignaturePad renderSignaturePad =
          _signaturePadKey.currentState.context.findRenderObject();
      data =
          await ImageConverter.toImage(renderSignaturePad: renderSignaturePad);
    } else {
      final imageData =
          await _signaturePadKey.currentState.toImage(pixelRatio: 3.0);
      if (imageData != null) {
        final bytes =
            await imageData.toByteData(format: ui.ImageByteFormat.png);
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
      child: Center(
        child: Text(
          'INVOICE',
          style: TextStyle(
              color: Color.fromRGBO(91, 126, 215, 1),
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
      height: 60,
    );
  }

  Widget _getProductDetails() {
    return Column(children: <Widget>[
      Container(
          child: IgnorePointer(
              child: SfDataGridTheme(
                data: SfDataGridThemeData(
                  headerStyle: DataGridHeaderCellStyle(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: _getTextColor()),
                      backgroundColor: Colors.transparent),
                  gridLineStrokeWidth: 1,
                  gridLineColor: _isDark ? Colors.grey[850] : Colors.grey[200],
                  cellStyle: DataGridCellStyle(
                      textStyle: TextStyle(
                          fontSize: _fontSizeRegular, color: _getTextColor()),
                      backgroundColor: Colors.transparent),
                ),
                child: SfDataGrid(
                  source: _productDataSource,
                  columnWidthMode: ColumnWidthMode.fill,
                  columns: [
                    GridTextColumn(mappingName: 'name', headerText: 'Product')
                      ..columnWidthMode = ColumnWidthMode.cells
                      ..headerTextSoftWrap = true
                      ..headerTextOverflow = TextOverflow.clip
                      ..padding = EdgeInsets.fromLTRB(10.0, 5.0, 0, 5.0),
                    GridNumericColumn(mappingName: 'price', headerText: 'Price')
                      ..headerTextSoftWrap = true
                      ..headerTextOverflow = TextOverflow.clip,
                    GridNumericColumn(
                        mappingName: 'quantity', headerText: 'Quantity')
                      ..headerTextSoftWrap = true
                      ..headerTextOverflow = TextOverflow.clip
                      ..padding = EdgeInsets.all(8),
                    GridNumericColumn(mappingName: 'total', headerText: 'Total')
                      ..headerTextSoftWrap = true
                      ..headerTextOverflow = TextOverflow.clip
                  ],
                ),
              ),
              ignoring: true),
          padding: EdgeInsets.all(20),
          height: 250),
      Align(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0, 20.0, 0),
            child: Text('Grand Total : \$1220.89',
                textScaleFactor: 1.0,
                style: TextStyle(
                    fontSize: _fontSizeRegular,
                    color: _getTextColor(),
                    fontWeight: FontWeight.w900),
                textAlign: TextAlign.end),
          ),
          alignment: Alignment.centerRight),
    ]);
  }

  Color _getTextColor() => _isDark ? Colors.grey[400] : Colors.grey[700];
  Color _getBorderColor() => _isDark ? Colors.grey[500] : Colors.grey[350];

  Widget _getBillingDetails() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedTime = formatter.format(now);

    return Container(
        child: Padding(
          child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      'Bill To:',
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          fontSize: _fontSizeRegular,
                          color: _getTextColor(),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 2),
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                Column(
                    children: [
                      Text('Invoice No: 2058557939',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: _fontSizeRegular,
                              color: _getTextColor()),
                          textAlign: TextAlign.end),
                      SizedBox(height: 5),
                      Text("Date: " + formattedTime,
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: _fontSizeRegular,
                              color: _getTextColor()),
                          textAlign: TextAlign.end),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end)
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start),
          padding: EdgeInsets.all(20.0),
        ),
        height: 150);
  }

  Widget _getBottomView() {
    return Expanded(
      child: Container(
          child: Row(
              children: [
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: _getBorderColor()),
                    ),
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
                    height: 78,
                    width: 138,
                  ),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  //ignore: sdk_version_set_literal
                  onTap: () => {_showPopup()},
                ),
                Column(
                    children: [
                      Text('800 Interchange Blvd.',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: _fontSizeRegular,
                              color: _getTextColor()),
                          textAlign: TextAlign.end),
                      SizedBox(height: 5),
                      Text('Austin, TX 78721',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: _fontSizeRegular,
                              color: _getTextColor()),
                          textAlign: TextAlign.end),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end)
              ],
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween),
          padding: EdgeInsets.fromLTRB(20.0, 20, 20.0, 10),
          color: Colors.transparent),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    //ignore: unused_local_variable
    final double _screenHeight = MediaQuery.of(context).size.height;
    _isDark = model.themeData.brightness == Brightness.dark;
    _strokeColors[0] = _isDark
        ? const Color.fromRGBO(255, 255, 255, 1)
        : const Color.fromRGBO(0, 0, 0, 1);
    _strokeColor = _strokeColors[_selectedPenIndex];

    return Container(
        child: Center(
          child: SingleChildScrollView(
              child: Container(
                  child: Column(children: [
                    _getInvoiceHeader(),
                    _getBillingDetails(),
                    _getProductDetails(),
                    _getBottomView()
                  ]),
                  width:
                      kIsWeb ? 500 : (_screenWidth > 400 ? 400 : _screenWidth),
                  height: 625,
                  margin: kIsWeb ? EdgeInsets.all(10.0) : null,
                  decoration: kIsWeb
                      ? BoxDecoration(
                          color:
                              _isDark ? model.webBackgroundColor : Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: _isDark
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.grey.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        )
                      : null)),
        ),
        color: _isDark
            ? Colors.transparent
            : const Color.fromRGBO(250, 250, 250, 1));
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(children: <Widget>[
        Padding(
            child: Text(
              'Minimum Width',
              style: TextStyle(fontSize: 16.0, color: model.textColor),
            ),
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
        SizedBox(height: 4),
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
                    if (newValue <= _maxWidth) {
                      _minWidth = newValue;
                    }
                  },
                );
              },
            )),
        SizedBox(height: 16),
        Padding(
            child: Text(
              'Maximum Width',
              style: TextStyle(fontSize: 16.0, color: model.textColor),
            ),
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
        SizedBox(height: 4),
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
                    if (newValue >= _minWidth) {
                      _maxWidth = newValue;
                    }
                  },
                );
              },
            )),
        SizedBox(height: 12)
      ]);
    });
  }
}

class _Product {
  const _Product(
      {this.productId, this.name, this.price, this.quantity, this.total});

  final String productId;
  final String name;
  final double price;
  final int quantity;
  final double total;
}

class _ProductDataSource extends DataGridSource {
  @override
  List<Object> get dataSource => _products;

  @override
  getCellValue(int rowIndex, String columnName) {
    switch (columnName) {
      case 'productId':
        return _products[rowIndex].productId;
        break;
      case 'name':
        return _products[rowIndex].name;
        break;
      case 'price':
        return _products[rowIndex].price;
        break;
      case 'quantity':
        return _products[rowIndex].quantity;
        break;
      case 'total':
        return _products[rowIndex].total;
        break;
      default:
        return ' ';
        break;
    }
  }
}
