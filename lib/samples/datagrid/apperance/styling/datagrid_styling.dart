/// Package imports
import 'package:flutter/material.dart';

///Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

/// Datagrid import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Local import
import '../../../../model/sample_view.dart';
import '../../datagridsource/orderinfo_datagridsource.dart';

/// render data grid widget
class StylingDataGrid extends SampleView {
  /// Creates data grid widget
  const StylingDataGrid({Key? key}) : super(key: key);

  @override
  _StylingDataGridState createState() => _StylingDataGridState();
}

class _StylingDataGridState extends SampleViewState {
  /// Supported to notify the panel visibility
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);
  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;
  bool panelOpen = false;

  /// Determine to decide whether the device in landscape or in portrait
  bool isLandscapeInMobileView = false;

  /// Required for SfDataGrid to obtain the row data.
  late OrderInfoDataGridSource stylingDataGridSource;

  /// Determine to set the gridLineVisibility of SfDataGrid.
  late String gridLinesVisibility;

  /// Determine to set the gridLineVisibility of SfDataGrid.
  late GridLinesVisibility gridLineVisibility;

  late bool isWebOrDesktop;

  /// GridLineVisibility strings for drop down widget.
  final List<String> _encoding = <String>[
    'both',
    'horizontal',
    'none',
    'vertical',
  ];

  void _onGridLinesVisibilityChanges(String item) {
    gridLinesVisibility = item;
    switch (gridLinesVisibility) {
      case 'both':
        gridLineVisibility = GridLinesVisibility.both;
        break;
      case 'horizontal':
        gridLineVisibility = GridLinesVisibility.horizontal;
        break;
      case 'none':
        gridLineVisibility = GridLinesVisibility.none;
        break;
      case 'vertical':
        gridLineVisibility = GridLinesVisibility.vertical;
        break;
    }
    setState(() {});
  }

  List<GridColumn> getColumns() {
    const TextStyle textStyle =
        TextStyle(color: Color.fromRGBO(255, 255, 255, 1));
    return isWebOrDesktop
        ? <GridColumn>[
            GridColumn(
              columnName: 'orderId',
              width: (isWebOrDesktop && model.isMobileResolution)
                  ? 110.0
                  : double.nan,
              label: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Order ID',
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridColumn(
              columnName: 'customerId',
              width: 120.0,
              label: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Customer ID',
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridColumn(
              columnName: 'name',
              width: (isWebOrDesktop && model.isMobileResolution)
                  ? 110.0
                  : double.nan,
              label: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Name',
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridColumn(
              columnName: 'freight',
              width: (isWebOrDesktop && model.isMobileResolution)
                  ? 100.0
                  : double.nan,
              label: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Freight',
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridColumn(
              columnName: 'city',
              width: (isWebOrDesktop && model.isMobileResolution)
                  ? 100.0
                  : double.nan,
              label: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'City',
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridColumn(
              columnName: 'price',
              width: (isWebOrDesktop && model.isMobileResolution)
                  ? 115.0
                  : double.nan,
              label: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Price',
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ]
        : <GridColumn>[
            GridColumn(
              columnName: 'orderId',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: const Text(
                  'Order ID',
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridColumn(
              width: 100,
              columnName: 'customerId',
              columnWidthMode: isLandscapeInMobileView
                  ? ColumnWidthMode.fill
                  : ColumnWidthMode.none,
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child: const Text(
                  'Customer ID',
                  style: textStyle,
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
                  style: textStyle,
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
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ];
  }

  SfDataGridTheme _buildDataGrid(GridLinesVisibility gridLineVisibility) {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
          brightness: model.themeData.colorScheme.brightness,
          headerHoverColor: Colors.white.withOpacity(0.3),
          headerColor: model.backgroundColor),
      child: SfDataGrid(
        source: stylingDataGridSource,
        columnWidthMode: ColumnWidthMode.fill,
        gridLinesVisibility: gridLineVisibility,
        columns: getColumns(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    isWebOrDesktop = model.isWeb || model.isDesktop;
    stylingDataGridSource = OrderInfoDataGridSource(
        model: model, isWebOrDesktop: isWebOrDesktop, orderDataCount: 100);
    gridLinesVisibility = 'horizontal';
    gridLineVisibility = GridLinesVisibility.horizontal;
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLandscapeInMobileView = !isWebOrDesktop &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              model.isWebFullView
                  ? 'Grid lines \nvisibility'
                  : 'Grid lines visibility',
              softWrap: false,
              style: TextStyle(fontSize: 16.0, color: model.textColor),
            ),
            Theme(
              data: ThemeData(canvasColor: model.bottomSheetBackgroundColor),
              child: DropdownButton<String>(
                  focusColor: Colors.transparent,
                  value: gridLinesVisibility,
                  items: _encoding.map((String value) {
                    return DropdownMenuItem<String>(
                        value: (value != null) ? value : 'none',
                        child: Text(value,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: model.textColor)));
                  }).toList(),
                  onChanged: (dynamic value) {
                    _onGridLinesVisibilityChanges(value);
                    stateSetter(() {});
                  }),
            ),
          ]);
    });
  }

  BoxDecoration drawBorder() {
    final BorderSide borderSide = BorderSide(
        color: model.themeData.colorScheme.brightness == Brightness.light
            ? const Color.fromRGBO(0, 0, 0, 0.26)
            : const Color.fromRGBO(255, 255, 255, 0.26));

    // Restricts the right side border when Datagrid has gridlinesVisibility
    // to both and vertical to maintains the border thickness.
    switch (gridLineVisibility) {
      case GridLinesVisibility.none:
      case GridLinesVisibility.horizontal:
        return BoxDecoration(
            border: Border(
                left: borderSide, right: borderSide, bottom: borderSide));
      case GridLinesVisibility.both:
      case GridLinesVisibility.vertical:
        return BoxDecoration(
            border: Border(left: borderSide, bottom: borderSide));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: model.themeData.colorScheme.brightness == Brightness.light
            ? const Color(0xFFFAFAFA)
            : null,
        child: Card(
            margin: isWebOrDesktop
                ? const EdgeInsets.all(24.0)
                : const EdgeInsets.all(16.0),
            clipBehavior: Clip.antiAlias,
            elevation: 1.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DecoratedBox(
                  decoration: drawBorder(),
                  child: _buildDataGrid(gridLineVisibility)),
            )));
  }
}
