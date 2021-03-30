/// Dart import
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:collection/collection.dart';

/// Renders column type data grid
class SwipingDataGrid extends SampleView {
  /// Creates column type data grid
  const SwipingDataGrid({Key? key}) : super(key: key);

  @override
  _SwipingDataGridState createState() => _SwipingDataGridState();
}

class _SwipingDataGridState extends SampleViewState {
  /// Determine to decide whether the device in landscape or in portrait.
  bool isLandscapeInMobileView = false;

  /// DataGridSource required for SfDataGrid to obtain the row data.
  late _EmployeeDataSource employeeDataSource;

  /// Editing controller for forms to perform update the values.
  TextEditingController? orderIdController,
      customerIdController,
      cityController,
      nameController,
      freightController,
      priceController;

  /// Used to validate the forms
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late bool isWebOrDesktop;

  @override
  void initState() {
    super.initState();
    isWebOrDesktop = (model.isWeb || model.isDesktop);
    employeeDataSource = _EmployeeDataSource(isWebOrDesktop: isWebOrDesktop);
    orderIdController = TextEditingController();
    customerIdController = TextEditingController();
    cityController = TextEditingController();
    nameController = TextEditingController();
    freightController = TextEditingController();
    priceController = TextEditingController();
  }

  /// Building the each field with label and TextFormField
  Widget _buildRow(
      {required TextEditingController controller, required String columnName}) {
    final keyboardType = ['City', 'Name'].contains(columnName)
        ? TextInputType.text
        : TextInputType.number;
    final inputFormatter = ['City', 'Name'].contains(columnName)
        ? FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))
        : FilteringTextInputFormatter.allow(RegExp('[0-9]'));

    return Row(
      children: [
        Container(
            width: isWebOrDesktop ? 150 : 130,
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text(columnName)),
        Container(
          width: isWebOrDesktop ? 150 : 130,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Field must not be empty';
              }
              return null;
            },
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: [inputFormatter],
          ),
        )
      ],
    );
  }

  /// Building the forms to edit the data
  Widget _buildAlertDialogContent() {
    return isWebOrDesktop
        ? Column(
            children: [
              _buildRow(controller: orderIdController!, columnName: 'Order ID'),
              _buildRow(
                  controller: customerIdController!, columnName: 'Customer ID'),
              _buildRow(controller: nameController!, columnName: 'Name'),
              _buildRow(controller: freightController!, columnName: 'Freight'),
              _buildRow(controller: cityController!, columnName: 'City'),
              _buildRow(controller: priceController!, columnName: 'Price'),
            ],
          )
        : Column(
            children: [
              _buildRow(controller: orderIdController!, columnName: 'Order ID'),
              _buildRow(
                  controller: customerIdController!, columnName: 'Customer ID'),
              _buildRow(controller: nameController!, columnName: 'Name'),
              _buildRow(controller: cityController!, columnName: 'City'),
            ],
          );
  }

  /// Updating the DataGridRows after changing the value and notify the DataGrid
  /// to refresh the view
  void _processCellUpdate(DataGridRow row, BuildContext buildContext) {
    final rowIndex = employeeDataSource.dataGridRows.indexOf(row);

    if (_formKey.currentState!.validate()) {
      employeeDataSource.employees[rowIndex] = _Employee(
        int.tryParse(orderIdController!.text)!,
        int?.tryParse(customerIdController!.text)!,
        nameController!.text,
        freightController!.text == ''
            ? 0.0
            : double.tryParse(freightController!.text)!,
        cityController!.text,
        priceController!.text == ''
            ? 0.0
            : double.tryParse(priceController!.text)!,
      );
      employeeDataSource.updateDataGridRow();
      employeeDataSource.updateDataSource();
      Navigator.pop(buildContext);
    }
  }

  // Updating the data to the TextEditingController
  void _updateTextFieldContext(DataGridRow row) {
    final orderId = row
        .getCells()
        .firstWhereOrNull((element) => element.columnName == 'id')
        ?.value
        .toString();
    orderIdController!.text = orderId ?? '';

    final customerId = row
        .getCells()
        .firstWhereOrNull((element) => element.columnName == 'customerId')
        ?.value
        .toString();

    customerIdController!.text = customerId ?? '';

    final name = row
        .getCells()
        .firstWhereOrNull((element) => element.columnName == 'name')
        ?.value
        .toString();

    nameController!.text = name ?? '';

    final freight = row
        .getCells()
        .firstWhereOrNull((element) => element.columnName == 'freight')
        ?.value;

    freightController!.text =
        freight == null ? '' : freight.roundToDouble().toString();

    final city = row
        .getCells()
        .firstWhereOrNull(
          (element) => element.columnName == 'city',
        )
        ?.value
        .toString();

    cityController!.text = city ?? '';

    final price = row
        .getCells()
        .firstWhereOrNull(
          (element) => element.columnName == 'price',
        )
        ?.value
        .toString();

    priceController!.text = price ?? '';
  }

  /// Building the option button on the bottom of the alert popup
  List<Widget> _buildActionButtons(DataGridRow row, BuildContext buildContext) {
    return [
      TextButton(
        onPressed: () => _processCellUpdate(row, buildContext),
        child: Text(
          'SAVE',
          style: TextStyle(color: model.backgroundColor),
        ),
      ),
      TextButton(
        onPressed: () => Navigator.pop(buildContext),
        child: Text(
          'CANCEL',
          style: TextStyle(color: model.backgroundColor),
        ),
      ),
    ];
  }

  /// Editing the DataGridRow
  void _handleEditWidgetTap(DataGridRow row) {
    _updateTextFieldContext(row);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        titleTextStyle: TextStyle(
            color: model.textColor, fontWeight: FontWeight.bold, fontSize: 16),
        title: Text('Edit Details'),
        actions: _buildActionButtons(row, context),
        content: Scrollbar(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Form(
              key: _formKey,
              child: _buildAlertDialogContent(),
            ),
          ),
        ),
      ),
    );
  }

  /// Deleting the DataGridRow
  void _handleDeleteWidgetTap(DataGridRow row) {
    final index = employeeDataSource.dataGridRows.indexOf(row);
    employeeDataSource.dataGridRows.remove(row);
    employeeDataSource.employees.remove(employeeDataSource.employees[index]);
    employeeDataSource.updateDataSource();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(color: model.backgroundColor),
            ),
          ),
        ],
        content: Text('Row deleted successfully'),
      ),
    );
  }

  /// Callback for left swiping, and it will flipped for RTL case
  Widget _buildStartSwipeWidget(BuildContext context, DataGridRow row) {
    return GestureDetector(
      onTap: () => _handleEditWidgetTap(row),
      child: Container(
        color: Colors.blueAccent,
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit, color: Colors.white, size: 20),
            SizedBox(width: 16.0),
            Text(
              'EDIT',
              style: TextStyle(color: Colors.white, fontSize: 15),
            )
          ],
        ),
      ),
    );
  }

  /// Callback for right swiping, and it will flipped for RTL case
  Widget _buildEndSwipeWidget(BuildContext context, DataGridRow row) {
    return GestureDetector(
      onTap: () => _handleDeleteWidgetTap(row),
      child: Container(
        color: Colors.redAccent,
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete, color: Colors.white, size: 20),
            SizedBox(width: 16.0),
            Text(
              'DELETE',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SfDataGrid(
        allowSwiping: true,
        swipeMaxOffset: 121.0,
        columns: getColumns(),
        source: employeeDataSource,
        columnWidthMode: ColumnWidthMode.fill,
        endSwipeActionsBuilder: _buildEndSwipeWidget,
        startSwipeActionsBuilder: _buildStartSwipeWidget,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLandscapeInMobileView = !isWebOrDesktop &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  List<GridColumn> getColumns() {
    List<GridColumn> columns;
    columns = isWebOrDesktop
        ? [
            GridTextColumn(
                columnName: 'id',
                width: (isWebOrDesktop && model.isMobileResolution)
                    ? 120.0
                    : double.nan,
                label: Container(
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Order ID',
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
            GridTextColumn(
                columnName: 'customerId',
                width: (isWebOrDesktop && model.isMobileResolution)
                    ? 150.0
                    : double.nan,
                label: Container(
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Customer ID',
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
            GridTextColumn(
              columnName: 'name',
              width: (isWebOrDesktop && model.isMobileResolution)
                  ? 120.0
                  : double.nan,
              label: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Name',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridTextColumn(
              columnName: 'freight',
              width: (isWebOrDesktop && model.isMobileResolution)
                  ? 110.0
                  : double.nan,
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: Text(
                  'Freight',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridTextColumn(
              columnName: 'city',
              width: (isWebOrDesktop && model.isMobileResolution)
                  ? 120.0
                  : double.nan,
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                child: Text(
                  'City',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridTextColumn(
              columnName: 'price',
              width: (isWebOrDesktop && model.isMobileResolution)
                  ? 120.0
                  : double.nan,
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: Text(
                  'Price',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ]
        : [
            GridTextColumn(
              columnName: 'id',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: Text(
                  'ID',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridTextColumn(
              columnName: 'customerId',
              columnWidthMode: isLandscapeInMobileView
                  ? ColumnWidthMode.fill
                  : ColumnWidthMode.none,
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: Text(
                  'Customer ID',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridTextColumn(
              columnName: 'name',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Name',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridTextColumn(
              columnName: 'city',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                child: Text(
                  'City',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ];
    return columns;
  }
}

class _Employee {
  _Employee(
      this.id, this.customerId, this.name, this.freight, this.city, this.price);
  final int id;
  final int customerId;
  final String name;
  final String city;
  final double freight;
  final double price;
}

class _EmployeeDataSource extends DataGridSource {
  _EmployeeDataSource({required this.isWebOrDesktop}) {
    employees = getEmployees(100);
    updateDataGridRow();
  }

  final bool isWebOrDesktop;
  List<DataGridRow> dataGridRows = [];
  List<_Employee> employees = [];

  // Building and Updating DataGridRows

  void updateDataGridRow() {
    dataGridRows = isWebOrDesktop
        ? employees.map<DataGridRow>((dataGridRow) {
            return DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: dataGridRow.id),
              DataGridCell<int>(
                  columnName: 'customerId', value: dataGridRow.customerId),
              DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
              DataGridCell<double>(
                  columnName: 'freight', value: dataGridRow.freight),
              DataGridCell<String>(columnName: 'city', value: dataGridRow.city),
              DataGridCell<double>(
                  columnName: 'price', value: dataGridRow.price),
            ]);
          }).toList()
        : employees.map<DataGridRow>((dataGridRow) {
            return DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: dataGridRow.id),
              DataGridCell<int>(
                  columnName: 'customerId', value: dataGridRow.customerId),
              DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
              DataGridCell<String>(columnName: 'city', value: dataGridRow.city),
            ]);
          }).toList();
  }

  // Overrides

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    if (isWebOrDesktop) {
      return DataGridRowAdapter(cells: [
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: Text(
            row.getCells()[0].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: Text(
            row.getCells()[1].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8),
          child: Text(
            row.getCells()[2].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: '\$')
                .format(row.getCells()[3].value)
                .toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            row.getCells()[4].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: Text(
            NumberFormat.currency(locale: 'en_US', symbol: '\$')
                .format(row.getCells()[5].value)
                .toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ]);
    } else {
      Widget buildWidget({
        AlignmentGeometry alignment = Alignment.centerLeft,
        EdgeInsetsGeometry padding = const EdgeInsets.all(8.0),
        TextOverflow textOverflow = TextOverflow.ellipsis,
        required Object value,
      }) {
        return Container(
          padding: padding,
          alignment: alignment,
          child: Text(
            value.toString(),
            overflow: textOverflow,
          ),
        );
      }

      return DataGridRowAdapter(
          cells: row.getCells().map<Widget>((dataCell) {
        if (dataCell.columnName == 'id' ||
            dataCell.columnName == 'customerId') {
          return buildWidget(
              alignment: Alignment.centerRight, value: dataCell.value);
        } else {
          return buildWidget(value: dataCell.value);
        }
      }).toList(growable: false));
    }
  }

  void updateDataSource() {
    notifyListeners();
  }

  final List<String> names = <String>[
    'Welli',
    'Blonp',
    'Folko',
    'Furip',
    'Folig',
    'Picco',
    'Frans',
    'Warth',
    'Linod',
    'Simop',
    'Merep',
    'Riscu',
    'Seves',
    'Vaffe',
    'Alfki',
  ];

  final List<String> cities = <String>[
    'Bruxelles',
    'Rosario',
    'Recife',
    'Graz',
    'Montreal',
    'Tsawassen',
    'Campinas',
    'Resende',
  ];

  List<_Employee> getEmployees(int count) {
    final Random random = Random();
    final List<_Employee> employeeData = <_Employee>[];
    for (int i = 0; i < count; i++) {
      employeeData.add(
        _Employee(
          1000 + i,
          1700 + i,
          names[i < names.length ? i : random.nextInt(names.length - 1)],
          random.nextInt(1000) + random.nextDouble(),
          cities[random.nextInt(cities.length - 1)],
          1500.0 + random.nextInt(100),
        ),
      );
    }
    return employeeData;
  }
}
