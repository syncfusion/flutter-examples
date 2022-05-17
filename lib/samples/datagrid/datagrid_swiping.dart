/// Package imports
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// DataGrid import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../model/sample_view.dart';
import 'datagridsource/orderinfo_datagridsource.dart';

/// Local import
import 'model/orderinfo.dart';

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
  late OrderInfoDataGridSource dataSource;

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
    isWebOrDesktop = model.isWeb || model.isDesktop;
    dataSource = OrderInfoDataGridSource(
        isWebOrDesktop: isWebOrDesktop, orderDataCount: 100);
    orderIdController = TextEditingController();
    customerIdController = TextEditingController();
    cityController = TextEditingController();
    nameController = TextEditingController();
    freightController = TextEditingController();
    priceController = TextEditingController();
  }

  RegExp _getRegExp(TextInputType keyboardType, String columnName) {
    return keyboardType == TextInputType.number
        ? columnName == 'Freight' || columnName == 'Price'
            ? RegExp('[0-9.]')
            : RegExp('[0-9]')
        : RegExp('[a-zA-Z ]');
  }

  /// Building the each field with label and TextFormField
  Widget _buildRow(
      {required TextEditingController controller, required String columnName}) {
    final TextInputType keyboardType =
        <String>['City', 'Name'].contains(columnName)
            ? TextInputType.text
            : TextInputType.number;

    // Holds the regular expression pattern based on the column type.
    final RegExp regExp = _getRegExp(keyboardType, columnName);

    return Row(
      children: <Widget>[
        Container(
            width: isWebOrDesktop ? 150 : 130,
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(columnName)),
        SizedBox(
          width: isWebOrDesktop ? 150 : 130,
          child: TextFormField(
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Field must not be empty';
              }
              return null;
            },
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(regExp)
            ],
          ),
        )
      ],
    );
  }

  /// Building the forms to edit the data
  Widget _buildAlertDialogContent() {
    return isWebOrDesktop
        ? Column(
            children: <Widget>[
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
            children: <Widget>[
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
    final int rowIndex = dataSource.dataGridRows.indexOf(row);

    if (_formKey.currentState!.validate()) {
      dataSource.orders[rowIndex] = OrderInfo(
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
      dataSource.buildDataGridRows();
      dataSource.updateDataSource();
      Navigator.pop(buildContext);
    }
  }

  // Updating the data to the TextEditingController
  void _updateTextFieldContext(DataGridRow row) {
    final String? orderId = row
        .getCells()
        .firstWhereOrNull((DataGridCell element) => element.columnName == 'id')
        ?.value
        .toString();
    orderIdController!.text = orderId ?? '';

    final String? customerId = row
        .getCells()
        .firstWhereOrNull(
            (DataGridCell element) => element.columnName == 'customerId')
        ?.value
        .toString();

    customerIdController!.text = customerId ?? '';

    final String? name = row
        .getCells()
        .firstWhereOrNull(
            (DataGridCell element) => element.columnName == 'name')
        ?.value
        .toString();

    nameController!.text = name ?? '';

    final dynamic freight = row
        .getCells()
        .firstWhereOrNull(
            (DataGridCell element) => element.columnName == 'freight')
        ?.value;

    freightController!.text =
        freight == null ? '' : freight.roundToDouble().toString();

    final String? city = row
        .getCells()
        .firstWhereOrNull(
          (DataGridCell element) => element.columnName == 'city',
        )
        ?.value
        .toString();

    cityController!.text = city ?? '';

    final String? price = row
        .getCells()
        .firstWhereOrNull(
          (DataGridCell element) => element.columnName == 'price',
        )
        ?.value
        .toString();

    priceController!.text = price ?? '';
  }

  /// Building the option button on the bottom of the alert popup
  List<Widget> _buildActionButtons(DataGridRow row, BuildContext buildContext) {
    return <Widget>[
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
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        scrollable: true,
        titleTextStyle: TextStyle(
            color: model.textColor, fontWeight: FontWeight.bold, fontSize: 16),
        title: const Text('Edit Details'),
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
    final int index = dataSource.dataGridRows.indexOf(row);
    dataSource.dataGridRows.remove(row);
    dataSource.orders.remove(dataSource.orders[index]);
    dataSource.updateDataSource();
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(color: model.backgroundColor),
            ),
          ),
        ],
        content: const Text('Row deleted successfully'),
      ),
    );
  }

  /// Callback for left swiping, and it will flipped for RTL case
  Widget _buildStartSwipeWidget(
      BuildContext context, DataGridRow row, int rowIndex) {
    return GestureDetector(
      onTap: () => _handleEditWidgetTap(row),
      child: Container(
        color: Colors.blueAccent,
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
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
  Widget _buildEndSwipeWidget(
      BuildContext context, DataGridRow row, int rowIndex) {
    return GestureDetector(
      onTap: () => _handleDeleteWidgetTap(row),
      child: Container(
        color: Colors.redAccent,
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
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
    return SfDataGrid(
      allowSwiping: true,
      swipeMaxOffset: 121.0,
      columns: getColumns(),
      source: dataSource,
      columnWidthMode: ColumnWidthMode.fill,
      endSwipeActionsBuilder: _buildEndSwipeWidget,
      startSwipeActionsBuilder: _buildStartSwipeWidget,
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
        ? <GridColumn>[
            GridColumn(
                columnName: 'id',
                width: (isWebOrDesktop && model.isMobileResolution)
                    ? 120.0
                    : double.nan,
                label: Container(
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.centerRight,
                  child: const Text(
                    'Order ID',
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
            GridColumn(
                columnName: 'customerId',
                width: (isWebOrDesktop && model.isMobileResolution)
                    ? 150.0
                    : double.nan,
                label: Container(
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.centerRight,
                  child: const Text(
                    'Customer ID',
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
            GridColumn(
              columnName: 'name',
              width: (isWebOrDesktop && model.isMobileResolution)
                  ? 120.0
                  : double.nan,
              label: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(8),
                child: const Text(
                  'Name',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridColumn(
              columnName: 'freight',
              width: (isWebOrDesktop && model.isMobileResolution)
                  ? 110.0
                  : double.nan,
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: const Text(
                  'Freight',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridColumn(
              columnName: 'city',
              width: (isWebOrDesktop && model.isMobileResolution)
                  ? 120.0
                  : double.nan,
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'City',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridColumn(
              columnName: 'price',
              width: (isWebOrDesktop && model.isMobileResolution)
                  ? 120.0
                  : double.nan,
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: const Text(
                  'Price',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ]
        : <GridColumn>[
            GridColumn(
              columnName: 'id',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: const Text(
                  'ID',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridColumn(
              columnName: 'customerId',
              columnWidthMode: isLandscapeInMobileView
                  ? ColumnWidthMode.fill
                  : ColumnWidthMode.none,
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: const Text(
                  'Customer ID',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridColumn(
              columnName: 'name',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Name',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridColumn(
              columnName: 'city',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'City',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ];
    return columns;
  }
}
