///Dart import
import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/model/sample_view.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart'
    hide Alignment, Column, Row, Border;

// Platform specific import
import '../common/export/save_file_mobile.dart'
    if (dart.library.html) '../common/export/save_file_web.dart' as helper;

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
  late _ExportingDataSource dataGridSource;

  /// Determine to decide whether the device in landscape or in portrait.
  late bool isLandscapeInMobileView;

  /// Help to identify the desktop or mobile.
  late bool isWebOrDesktop;

  @override
  void initState() {
    super.initState();
    isWebOrDesktop = model.isWeb || model.isDesktop;
    dataGridSource = _ExportingDataSource(model);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dataGridSource.sampleModel = model;
    isLandscapeInMobileView = !isWebOrDesktop &&
        MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildExportingButtons(),
        _buildDataGrid(context),
      ],
    ));
  }

  Widget _buildExportingButtons() {
    Future<void> exportDataGridToExcel() async {
      final Workbook workbook = _key.currentState!.exportToExcelWorkbook(
          cellExport: (DataGridCellExcelExportDetails details) {
        if (details.cellType == DataGridExportCellType.columnHeader) {
          final bool isRightAlign = details.columnName == 'Product No' ||
              details.columnName == 'Shipped Date' ||
              details.columnName == 'Price';
          details.excelRange.cellStyle.hAlign =
              isRightAlign ? HAlignType.right : HAlignType.left;
        }
      });
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
                details.pdfCell.value = DateFormat('MM/dd/yyyy')
                    .format(DateTime.parse(details.pdfCell.value));
              }
            }
          },
          headerFooterExport: (DataGridPdfHeaderFooterExportDetails details) {
            final double width = details.pdfPage.getClientSize().width;
            final PdfPageTemplateElement header =
                PdfPageTemplateElement(Rect.fromLTWH(0, 0, width, 65));

            header.graphics.drawImage(
                PdfBitmap(data.buffer
                    .asUint8List(data.offsetInBytes, data.lengthInBytes)),
                Rect.fromLTWH(width - 148, 0, 148, 60));

            header.graphics.drawString(
              'Product Details',
              PdfStandardFont(PdfFontFamily.helvetica, 13,
                  style: PdfFontStyle.bold),
              bounds: const Rect.fromLTWH(0, 25, 200, 60),
            );

            details.pdfDocumentTemplate.top = header;
          });
      final List<int> bytes = document.save();
      await helper.FileSaveHelper.saveAndLaunchFile(bytes, 'DataGrid.pdf');
      document.dispose();
    }

    return Row(
      children: <Widget>[
        _buildExportingButton('Export to Excel', 'images/ExcelExport.png',
            onPressed: exportDataGridToExcel),
        _buildExportingButton('Export to PDF', 'images/PdfExport.png',
            onPressed: exportDataGridToPdf)
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
                    color: model.themeData.brightness == Brightness.light
                        ? const Color.fromRGBO(0, 0, 0, 0.26)
                        : const Color.fromRGBO(255, 255, 255, 0.26),
                    width: 1))),
        child: SfDataGrid(
          key: _key,
          source: dataGridSource,
          columnWidthMode: isWebOrDesktop
              ? (isWebOrDesktop && model.isMobileResolution)
                  ? ColumnWidthMode.none
                  : ColumnWidthMode.fill
              : isLandscapeInMobileView
                  ? ColumnWidthMode.fill
                  : ColumnWidthMode.none,
          columns: <GridColumn>[
            GridColumn(
                columnName: 'Product No',
                width: isWebOrDesktop ? double.nan : 110,
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.centerRight,
                  child: const Text(
                    'Product No',
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
            GridColumn(
                columnName: 'Dealer Name',
                width: isWebOrDesktop ? double.nan : 110,
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Dealer Name',
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
            GridColumn(
                columnName: 'Shipped Date',
                width: isWebOrDesktop ? double.nan : 110,
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.centerRight,
                  child: const Text(
                    'Shipped Date',
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
            GridColumn(
                columnName: 'Ship Country',
                width: isWebOrDesktop ? double.nan : 110,
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Ship Country',
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
            GridColumn(
                columnName: 'Ship City',
                width: isWebOrDesktop ? double.nan : 110,
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Ship City',
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
            GridColumn(
                columnName: 'Price',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.centerRight,
                  child: const Text(
                    'Price',
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildExportingButton(String buttonName, String imagePath,
      {required VoidCallback onPressed}) {
    return Container(
      height: 60.0,
      padding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
      child: MaterialButton(
        onPressed: onPressed,
        color: model.backgroundColor,
        child: SizedBox(
          width: 150.0,
          height: 40.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
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

class _ExportingDataSource extends DataGridSource {
  _ExportingDataSource(this.sampleModel) {
    textStyle = sampleModel.themeData.brightness == Brightness.light
        ? const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.black87)
        : const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color.fromRGBO(255, 255, 255, 1));
    dealers = getDealerDetails(100);
    buildDataGridRows();
  }

  /// Helps to change the widget appearance based on the sample browser theme.
  SampleModel sampleModel;

  /// Collection of dealer info.
  late List<_DealerInfo> dealers;

  /// Collection of [DataGridRow].
  late List<DataGridRow> dataGridRows;

  /// Helps to change the [TextStyle] of editable widget.
  /// Decide the text appearance of editable widget based on [Brightness].
  late TextStyle textStyle;

  /// Building the [DataGridRow]'s.
  void buildDataGridRows() {
    dataGridRows = dealers
        .map<DataGridRow>((_DealerInfo dealer) => dealer.getDataGridRow())
        .toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((DataGridCell dataGridCell) {
      final bool isRightAlign = dataGridCell.columnName == 'Product No' ||
          dataGridCell.columnName == 'Shipped Date' ||
          dataGridCell.columnName == 'Price';

      String value = dataGridCell.value.toString();

      if (dataGridCell.columnName == 'Price') {
        value = NumberFormat.currency(locale: 'en_US', symbol: r'$')
            .format(dataGridCell.value)
            .toString();
      } else if (dataGridCell.columnName == 'Shipped Date') {
        value = DateFormat('MM/dd/yyyy').format(dataGridCell.value).toString();
      }

      return Container(
        padding: const EdgeInsets.all(8.0),
        alignment: isRightAlign ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          value,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList());
  }

  // ------------- Populating the dealer info collection's. ----------------
  // ------------------------------------------------------------------------

  final Random random = Random();

  List<_DealerInfo> getDealerDetails(int count) {
    final List<_DealerInfo> dealerDetails = <_DealerInfo>[];
    final List<DateTime> shippedDate = getDateBetween(2001, 2016, count);
    for (int i = 1; i <= count; i++) {
      final String selectedShipCountry = shipCountry[random.nextInt(5)];
      final List<String> selectedShipCities = shipCity[selectedShipCountry]!;
      final _DealerInfo ord = _DealerInfo(
          productNo[random.nextInt(15)],
          i.isEven
              ? customersMale[random.nextInt(15)]
              : customersFemale[random.nextInt(14)],
          shippedDate[i - 1],
          selectedShipCountry,
          selectedShipCities[random.nextInt(selectedShipCities.length - 1)],
          next(2000, 10000).toDouble());
      dealerDetails.add(ord);
    }

    return dealerDetails;
  }

  /// Helps to populate the random number between the [min] and [max] value.
  int next(int min, int max) => min + random.nextInt(max - min);

  /// Populate the random date between the [startYear] and [endYear]
  List<DateTime> getDateBetween(int startYear, int endYear, int count) {
    final List<DateTime> date = <DateTime>[];
    for (int i = 0; i < count; i++) {
      final int year = next(startYear, endYear);
      final int month = random.nextInt(12);
      final int day = random.nextInt(30);
      date.add(DateTime(year, month, day));
    }

    return date;
  }

  final Map<String, List<String>> shipCity = <String, List<String>>{
    'Argentina': <String>['Rosario', 'Catamarca', 'Formosa', 'Salta'],
    'Austria': <String>['Graz', 'Salzburg', 'Linz', 'Wels'],
    'Belgium': <String>['Bruxelles', 'Charleroi', 'Namur', 'Mons'],
    'Brazil': <String>[
      'Campinas',
      'Resende',
      'Recife',
      'Manaus',
    ],
    'Canada': <String>[
      'Alberta',
      'Montreal',
      'Tsawwassen',
      'Vancouver',
    ],
    'Denmark': <String>[
      'Svendborg',
      'Farum',
      'Åarhus',
      'København',
    ],
    'Finland': <String>['Helsinki', 'Espoo', 'Oulu'],
    'France': <String>[
      'Lille',
      'Lyon',
      'Marseille',
      'Nantes',
      'Paris',
      'Reims',
      'Strasbourg',
      'Toulouse',
      'Versailles'
    ],
    'Germany': <String>[
      'Aachen',
      'Berlin',
      'Brandenburg',
      'Cunewalde',
      'Frankfurt',
      'Köln',
      'Leipzig',
      'Mannheim',
      'München',
      'Münster',
      'Stuttgart'
    ],
    'Ireland': <String>['Cork', 'Waterford', 'Bray', 'Athlone'],
    'Italy': <String>[
      'Bergamo',
      'Reggio Calabria',
      'Torino',
      'Genoa',
    ],
    'Mexico': <String>[
      'Mexico City',
      'Puebla',
      'León',
      'Zapopan',
    ],
    'Norway': <String>['Stavern', 'Hamar', 'Harstad', 'Narvik'],
    'Poland': <String>['Warszawa', 'Gdynia', 'Rybnik', 'Legnica'],
    'Portugal': <String>['Lisboa', 'Albufeira', 'Elvas', 'Estremoz'],
    'Spain': <String>[
      'Barcelona',
      'Madrid',
      'Sevilla',
      'Bilboa',
    ],
    'Sweden': <String>['Bräcke', 'Piteå', 'Robertsfors', 'Luleå'],
    'Switzerland': <String>[
      'Bern',
      'Genève',
      'Charrat',
      'Châtillens',
    ],
    'UK': <String>['Colchester', 'Hedge End', 'London', 'Bristol'],
    'USA': <String>[
      'Albuquerque',
      'Anchorage',
      'Boise',
      'Butte',
      'Elgin',
      'Eugene',
      'Kirkland',
      'Lander',
      'Portland',
      'San Francisco',
      'Seattle',
    ],
    'Venezuela': <String>[
      'Barquisimeto',
      'Caracas',
      'Isla de Margarita',
      'San Cristóbal',
      'Cantaura',
    ],
  };

  List<String> customersMale = <String>[
    'Adams',
    'Owens',
    'Thomas',
    'Doran',
    'Jefferson',
    'Spencer',
    'Vargas',
    'Grimes',
    'Edwards',
    'Stark',
    'Cruise',
    'Fitz',
    'Chief',
    'Blanc',
    'Stone',
    'Williams',
    'Jobs',
    'Holmes'
  ];

  List<String> customersFemale = <String>[
    'Crowley',
    'Waddell',
    'Irvine',
    'Keefe',
    'Ellis',
    'Gable',
    'Mendoza',
    'Rooney',
    'Lane',
    'Landry',
    'Perry',
    'Perez',
    'Newberry',
    'Betts',
    'Fitzgerald',
  ];

  List<int> productNo = <int>[
    1803,
    1345,
    4523,
    4932,
    9475,
    5243,
    4263,
    2435,
    3527,
    3634,
    2523,
    3652,
    3524,
    6532,
    2123
  ];

  List<String> shipCountry = <String>[
    'Argentina',
    'Austria',
    'Belgium',
    'Brazil',
    'Canada',
    'Denmark',
    'Finland',
    'France',
    'Germany',
    'Ireland',
    'Italy',
    'Mexico',
    'Norway',
    'Poland',
    'Portugal',
    'Spain',
    'Sweden',
    'UK',
    'USA',
  ];
}

class _DealerInfo {
  _DealerInfo(this.productNo, this.dealerName, this.shippedDate,
      this.shipCountry, this.shipCity, this.productPrice);

  int productNo;
  String dealerName;
  double productPrice;
  DateTime shippedDate;
  String shipCity;
  String shipCountry;

  DataGridRow getDataGridRow() {
    return DataGridRow(cells: <DataGridCell>[
      DataGridCell<int>(columnName: 'Product No', value: productNo),
      DataGridCell<String>(columnName: 'Dealer Name', value: dealerName),
      DataGridCell<DateTime>(columnName: 'Shipped Date', value: shippedDate),
      DataGridCell<String>(columnName: 'Ship Country', value: shipCountry),
      DataGridCell<String>(columnName: 'Ship City', value: shipCity),
      DataGridCell<double>(columnName: 'Price', value: productPrice),
    ]);
  }
}
