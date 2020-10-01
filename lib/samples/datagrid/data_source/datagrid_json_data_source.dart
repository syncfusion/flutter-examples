import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'dart:convert';

List<Product> _productList = [];

/// Renders column type data grid
class JsonDataSourceDataGrid extends SampleView {
  /// Creates column type data grid
  const JsonDataSourceDataGrid({Key key}) : super(key: key);

  @override
  _JsonDataSourceDataGridState createState() => _JsonDataSourceDataGridState();
}

class _JsonDataSourceDataGridState extends SampleViewState {
  _JsonDataSourceDataGridState();

  Widget sampleWidget() => const JsonDataSourceDataGrid();

  final _JsonDataGridSource _jsonDataGridSource = _JsonDataGridSource();

  List<GridColumn> getColumns() {
    List<GridColumn> columns;
    columns = ([
      GridTextColumn(mappingName: 'id')
        ..softWrap = true
        ..overflow = TextOverflow.clip
        ..width = model.isWeb ? 135 : 90
        ..headerText = 'ID',
      GridTextColumn(mappingName: 'contactName')
        ..softWrap = true
        ..columnWidthMode =
            model.isWeb ? ColumnWidthMode.auto : ColumnWidthMode.header
        ..overflow = TextOverflow.clip
        ..headerText = 'Contact Name',
      GridTextColumn(mappingName: 'companyName')
        ..softWrap = true
        ..overflow = TextOverflow.clip
        ..width = model.isWeb ? 165 : 140
        ..headerText = 'Company',
      GridTextColumn(mappingName: 'city')
        ..softWrap = true
        ..overflow = TextOverflow.clip
        ..width = model.isWeb ? 150 : 120
        ..headerText = 'City',
      GridTextColumn(mappingName: 'country')
        ..softWrap = true
        ..overflow = TextOverflow.clip
        ..width = model.isWeb ? 150 : 120
        ..headerText = 'Country',
      GridTextColumn(mappingName: 'designation')
        ..softWrap = true
        ..overflow = TextOverflow.clip
        ..columnWidthMode = ColumnWidthMode.auto
        ..headerText = 'Job Title',
      GridTextColumn(mappingName: 'postalCode')
        ..columnWidthMode = ColumnWidthMode.header
        ..headerText = 'Postal Code',
      GridTextColumn(mappingName: 'phoneNumber')
        ..columnWidthMode = ColumnWidthMode.auto
        ..headerText = 'Phone Number'
    ]);
    return columns;
  }

  generateProductList() async {
    String responseBody =
        await rootBundle.loadString("assets/product_data.json");
    var list = json.decode(responseBody).cast<Map<String, dynamic>>();
    _productList = list.map<Product>((json) => Product.fromJson(json)).toList();
  }

  @override
  void initState() {
    super.initState();
    generateProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
            future: Future<dynamic>.delayed(
                Duration(milliseconds: 500), () => 'Loaded'),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return !_productList.isEmpty
                  ? SfDataGrid(
                      source: _jsonDataGridSource, columns: getColumns())
                  : Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    );
            }));
  }
}

class Product {
  Product(
      {this.id,
      this.contactName,
      this.companyName,
      this.city,
      this.country,
      this.designation,
      this.postalCode,
      this.phoneNumber});
  final String id;
  final String contactName;
  final String companyName;
  final String city;
  final String country;
  final String designation;
  final String postalCode;
  final String phoneNumber;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'] as String,
        contactName: json['contactName'] as String,
        companyName: json['companyName'] as String,
        city: json['city'] as String,
        country: json['country'] as String,
        designation: json['designation'] as String,
        postalCode: json['postalCode'] as String,
        phoneNumber: json['phoneNumber'] as String);
  }
}

class _JsonDataGridSource extends DataGridSource<Product> {
  _JsonDataGridSource();
  @override
  List<Product> get dataSource => _productList;
  @override
  Object getValue(Product _product, String columnName) {
    switch (columnName) {
      case 'id':
        return _product.id;
        break;
      case 'companyName':
        return _product.companyName;
        break;
      case 'contactName':
        return _product.contactName;
        break;
      case 'city':
        return _product.city;
        break;
      case 'country':
        return _product.country;
        break;
      case 'designation':
        return _product.designation;
        break;
      case 'postalCode':
        return _product.postalCode;
        break;
      case 'phoneNumber':
        return _product.phoneNumber;
        break;
      default:
        return 'empty';
        break;
    }
  }
}
