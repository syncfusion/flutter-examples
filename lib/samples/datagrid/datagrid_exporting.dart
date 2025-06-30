///Dart import
// ignore_for_file: depend_on_referenced_packages

import 'dart:core';

/// Packages import
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row, Border;

import '../../model/sample_view.dart';
// Platform specific import
import '../common/export/save_file_mobile.dart'
    if (dart.library.js_interop) '../common/export/save_file_web.dart'
    as helper;

/// Local import
import 'datagridsource/dealer_datagridsource.dart';

/// Render data grid with editing.
class ExportingDataGrid extends SampleView {
  /// Create data grid with editing.
  const ExportingDataGrid({Key? key}) : super(key: key);

  @override
  _ExportingDataGridState createState() => _ExportingDataGridState();
}

class _ExportingDataGridState extends SampleViewState {
  /// Creates a key to the `SfDataGridState` to access its methods.
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();

  /// DataGridSource of [SfDataGrid]
  late DealerDataGridSource _dataGridSource;

  /// Determine to decide whether the device in landscape or in portrait.
  late bool _isLandscapeInMobileView;

  /// Help to identify the desktop or mobile.
  late bool _isWebOrDesktop;

  @override
  void initState() {
    super.initState();
    _isWebOrDesktop = model.isWeb || model.isDesktop;
    _dataGridSource = DealerDataGridSource(model);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dataGridSource.sampleModel = model;
    _isLandscapeInMobileView =
        !_isWebOrDesktop &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[_buildExportingButtons(), _buildDataGrid(context)],
    );
  }

  Widget _buildExportingButtons() {
    Future<void> exportDataGridToExcel() async {
      final Workbook workbook = _key.currentState!.exportToExcelWorkbook(
        cellExport: (DataGridCellExcelExportDetails details) {
          if (details.cellType == DataGridExportCellType.columnHeader) {
            final bool isRightAlign =
                details.columnName == 'Product No' ||
                details.columnName == 'Shipped Date' ||
                details.columnName == 'Price';
            details.excelRange.cellStyle.hAlign = isRightAlign
                ? HAlignType.right
                : HAlignType.left;
          }
        },
      );
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();
      await helper.FileSaveHelper.saveAndLaunchFile(bytes, 'DataGrid.xlsx');
    }

    Future<void> exportDataGridToPdf() async {
      final ByteData data = await rootBundle.load('images/syncfusion_logo.jpg');
      final PdfDocument document = _key.currentState!.exportToPdfDocument(
        fitAllColumnsInOnePage: true,
        cellExport: (DataGridCellPdfExportDetails details) {
          if (details.cellType == DataGridExportCellType.row) {
            if (details.columnName == 'Shipped Date') {
              details.pdfCell.value = DateFormat(
                'MM/dd/yyyy',
              ).format(DateTime.parse(details.pdfCell.value));
            }
          }
        },
        headerFooterExport: (DataGridPdfHeaderFooterExportDetails details) {
          final double width = details.pdfPage.getClientSize().width;
          final PdfPageTemplateElement header = PdfPageTemplateElement(
            Rect.fromLTWH(0, 0, width, 65),
          );

          header.graphics.drawImage(
            PdfBitmap(
              data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
            ),
            Rect.fromLTWH(width - 148, 0, 148, 60),
          );

          header.graphics.drawString(
            'Product Details',
            PdfStandardFont(
              PdfFontFamily.helvetica,
              13,
              style: PdfFontStyle.bold,
            ),
            bounds: const Rect.fromLTWH(0, 25, 200, 60),
          );

          details.pdfDocumentTemplate.top = header;
        },
      );
      final List<int> bytes = document.saveSync();
      await helper.FileSaveHelper.saveAndLaunchFile(bytes, 'DataGrid.pdf');
      document.dispose();
    }

    return Row(
      children: <Widget>[
        _buildExportingButton(
          'Export to Excel',
          'images/ExcelExport.png',
          onPressed: exportDataGridToExcel,
        ),
        _buildExportingButton(
          'Export to PDF',
          'images/PdfExport.png',
          onPressed: exportDataGridToPdf,
        ),
      ],
    );
  }

  Widget _buildDataGrid(BuildContext context) {
    return Expanded(
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: model.themeData.colorScheme.brightness == Brightness.light
                  ? const Color.fromRGBO(0, 0, 0, 0.26)
                  : const Color.fromRGBO(255, 255, 255, 0.26),
            ),
          ),
        ),
        child: SfDataGrid(
          key: _key,
          source: _dataGridSource,
          columnWidthMode: _isWebOrDesktop
              ? (_isWebOrDesktop && model.isMobileResolution)
                    ? ColumnWidthMode.none
                    : ColumnWidthMode.fill
              : _isLandscapeInMobileView
              ? ColumnWidthMode.fill
              : ColumnWidthMode.none,
          columns: _obtainColumns(),
        ),
      ),
    );
  }

  List<GridColumn> _obtainColumns() {
    return <GridColumn>[
      GridColumn(
        columnName: 'Product No',
        width: _isWebOrDesktop ? double.nan : 110,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerRight,
          child: const Text('Product No', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'Dealer Name',
        width: _isWebOrDesktop ? double.nan : 110,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: const Text('Dealer Name', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'Shipped Date',
        width: _isWebOrDesktop ? double.nan : 110,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerRight,
          child: const Text('Shipped Date', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'Ship Country',
        width: _isWebOrDesktop ? double.nan : 110,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: const Text('Ship Country', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'Ship City',
        width: _isWebOrDesktop ? double.nan : 110,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: const Text('Ship City', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'Price',
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerRight,
          child: const Text('Price', overflow: TextOverflow.ellipsis),
        ),
      ),
    ];
  }

  Widget _buildExportingButton(
    String buttonName,
    String imagePath, {
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 60.0,
      padding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
      child: MaterialButton(
        onPressed: onPressed,
        color: model.primaryColor,
        child: SizedBox(
          width: 150.0,
          height: 40.0,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: ImageIcon(
                  AssetImage(imagePath),
                  size: 30,
                  color: Colors.white,
                ),
              ),
              Text(buttonName, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
