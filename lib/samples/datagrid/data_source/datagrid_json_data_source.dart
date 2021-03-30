import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_examples/model/sample_view.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Renders column type data grid
class JsonDataSourceDataGrid extends SampleView {
  /// Creates column type data grid
  const JsonDataSourceDataGrid({Key? key}) : super(key: key);

  @override
  _JsonDataSourceDataGridState createState() => _JsonDataSourceDataGridState();
}

class _JsonDataSourceDataGridState extends SampleViewState {
  /// DataGridSource Required for SfDataGrid to obtain the row data.
  final _JsonDataGridSource jsonDataGridSource = _JsonDataGridSource();

  late bool isWebOrDesktop;

  Widget sampleWidget() => const JsonDataSourceDataGrid();

  List<GridColumn> getColumns() {
    List<GridColumn> columns;
    columns = ([
      GridTextColumn(
        columnName: 'id',
        width: isWebOrDesktop ? 135 : 90,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            'ID',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridTextColumn(
        columnName: 'contactName',
        width: 150,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            'Contact Name',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridTextColumn(
        columnName: 'companyName',
        width: isWebOrDesktop ? 165 : 140,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            'Company',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridTextColumn(
        columnName: 'city',
        width: isWebOrDesktop ? 150 : 120,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            'City',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridTextColumn(
        columnName: 'country',
        width: isWebOrDesktop ? 150 : 120,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            'Country',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridTextColumn(
        columnName: 'designation',
        width: 170,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            'Job Title',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridTextColumn(
        columnName: 'postalCode',
        width: 110,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text('Postal Code'),
        ),
      ),
      GridTextColumn(
        columnName: 'phoneNumber',
        width: 150,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: Text('Phone Number'),
        ),
      )
    ]);
    return columns;
  }

  @override
  void initState() {
    super.initState();
    isWebOrDesktop = (model.isWeb || model.isDesktop);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
            future: Future<dynamic>.delayed(
                Duration(milliseconds: 500), () => 'Loaded'),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return jsonDataGridSource.products.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    )
                  : SfDataGrid(
                      source: jsonDataGridSource, columns: getColumns());
            }));
  }
}

class _Product {
  factory _Product.fromJson(Map<String, dynamic> json) {
    return _Product(
        id: json['id'],
        contactName: json['contactName'],
        companyName: json['companyName'],
        city: json['city'],
        country: json['country'],
        designation: json['designation'],
        postalCode: json['postalCode'],
        phoneNumber: json['phoneNumber']);
  }
  _Product(
      {required this.id,
      required this.contactName,
      required this.companyName,
      required this.city,
      required this.country,
      required this.designation,
      required this.postalCode,
      required this.phoneNumber});
  final String id;
  final String contactName;
  final String companyName;
  final String city;
  final String country;
  final String designation;
  final String postalCode;
  final String phoneNumber;
}

class _JsonDataGridSource extends DataGridSource {
  _JsonDataGridSource() {
    populateData();
  }

  List<DataGridRow> dataGridRows = [];

  List<_Product> products = [];

  // Populate Data from the json file

  Future<void> generateProductList() async {
    final String responseBody =
        await rootBundle.loadString('assets/product_data.json');
    final list = await json.decode(responseBody).cast<Map<String, dynamic>>();
    products =
        await list.map<_Product>((json) => _Product.fromJson(json)).toList();
  }

  Future<void> populateData() async {
    await generateProductList();
    buildDataGridRow();
  }

  // Building DataGridRows

  void buildDataGridRow() {
    dataGridRows = products.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'id', value: dataGridRow.id),
        DataGridCell<String>(
            columnName: 'contactName', value: dataGridRow.contactName),
        DataGridCell<String>(
            columnName: 'companyName', value: dataGridRow.companyName),
        DataGridCell<String>(columnName: 'city', value: dataGridRow.city),
        DataGridCell<String>(columnName: 'country', value: dataGridRow.country),
        DataGridCell<String>(
            columnName: 'designation', value: dataGridRow.designation),
        DataGridCell<String>(
            columnName: 'postalCode', value: dataGridRow.postalCode),
        DataGridCell<String>(
            columnName: 'phoneNumber', value: dataGridRow.phoneNumber),
      ]);
    }).toList(growable: false);
  }

  // Overrides

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataCell) {
      if (dataCell.columnName == 'phoneNumber') {
        return Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.centerRight,
            child: Text(dataCell.value.toString(), maxLines: 1));
      } else {
        return Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(dataCell.value.toString(),
              maxLines: (dataCell.columnName == 'companyName') ? 1 : null),
        );
      }
    }).toList());
  }
}
