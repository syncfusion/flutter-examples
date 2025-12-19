///Package imports
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

///Pdf import
import 'package:syncfusion_flutter_pdf/pdf.dart';

///Local imports
import '../../model/sample_view.dart';
import 'helper/save_file_mobile.dart'
    if (dart.library.js_interop) 'helper/save_file_web.dart';

/// PDF conformance.
class ConformancePdf extends SampleView {
  /// PDF conformance.
  const ConformancePdf(Key key) : super(key: key);
  @override
  _ConformancePdfState createState() => _ConformancePdfState();
}

class _ConformancePdfState extends SampleViewState {
  _ConformancePdfState();
  int _groupValue = 0;
  void _changed(int? value) {
    setState(() {
      _groupValue = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: model.sampleOutputCardColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'This sample shows how to create various PDF conformance document like PDF/A-1B, PDF/A-2B, and PDF/A-3B',
                style: TextStyle(fontSize: 16, color: model.textColor),
              ),
              const SizedBox(height: 20, width: 30),
              Text(
                'Choose the conformance level:',
                style: TextStyle(
                  fontSize: 16,
                  color: model.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10, width: 25),
              RadioGroup<int>(
                groupValue: _groupValue,
                onChanged: _changed,
                child: (MediaQuery.of(context).size.width > 800)
                    ? Row(children: getChildWidgets(context))
                    : Column(children: getChildWidgets(context)),
              ),
              const SizedBox(height: 10, width: 30),
              Align(
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      model.primaryColor,
                    ),
                    padding: model.isMobile
                        ? null
                        : WidgetStateProperty.all(
                            const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 15,
                            ),
                          ),
                  ),
                  onPressed: _conformance,
                  child: const Text(
                    'Generate PDF',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getChildWidgets(BuildContext context) {
    return <Widget>[
      Row(
        children: <Widget>[
          const Radio<int>(value: 0),
          Text(
            'PDF/A-1B',
            style: TextStyle(fontSize: 16, color: model.textColor),
          ),
        ],
      ),
      Row(
        children: <Widget>[
          const Radio<int>(value: 1),
          Text(
            'PDF/A-2B',
            style: TextStyle(fontSize: 16, color: model.textColor),
          ),
        ],
      ),
      Row(
        children: <Widget>[
          const Radio<int>(value: 2),
          Text(
            'PDF/A-3B',
            style: TextStyle(fontSize: 16, color: model.textColor),
          ),
        ],
      ),
    ];
  }

  Future<void> _conformance() async {
    PdfDocument document;
    if (_groupValue == 0) {
      //Create document with PDF/A-1B standard.
      document = PdfDocument(conformanceLevel: PdfConformanceLevel.a1b);
    } else if (_groupValue == 1) {
      //Create document with PDF/A-2B standard.
      document = PdfDocument(conformanceLevel: PdfConformanceLevel.a2b);
    } else {
      //Create document with PDF/A-3B standard.
      document = PdfDocument(conformanceLevel: PdfConformanceLevel.a3b);
      const String text =
          'Adventure Works Cycles, the fictitious company on which the AdventureWorks sample databases are based, is a large, multinational manufacturing company. The company manufactures and sells metal and composite bicycles to North American, European and Asian commercial markets. While its base operation is located in Bothell, Washington with 290 employees, several regional sales teams are located throughout their market base.';
      document.attachments.add(
        PdfAttachment(
          'AdventureCycle.txt',
          utf8.encode(text),
          description: 'Adventure Works Cycles',
          mimeType: 'application/txt',
        ),
      );
    }
    //Add page to the PDF
    final PdfPage page = document.pages.add();
    //Get page client size
    final Size pageSize = page.getClientSize();
    //Draw rectangle
    page.graphics.drawRectangle(
      bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
      pen: PdfPen(PdfColor(142, 170, 219)),
    );
    //Read font file.
    final List<int> fontData = await _readData('Roboto-Regular.ttf');
    //Create a PDF true type font.
    final PdfFont contentFont = PdfTrueTypeFont(fontData, 9);
    final PdfFont headerFont = PdfTrueTypeFont(fontData, 30);
    final PdfFont footerFont = PdfTrueTypeFont(fontData, 18);
    //Generate PDF grid.
    final PdfGrid grid = _getGrid(contentFont);
    //Draw the header section by creating text element
    final PdfLayoutResult result = _drawHeader(
      page,
      pageSize,
      grid,
      contentFont,
      headerFont,
      footerFont,
    );
    //Draw grid
    _drawGrid(page, grid, result, contentFont);
    //Add invoice footer
    _drawFooter(page, pageSize, contentFont);
    //Save and dispose the document.
    final List<int> bytes = await document.save();
    document.dispose();
    //Save and launch file.
    await FileSaveHelper.saveAndLaunchFile(bytes, 'ConformancePDF.pdf');
  }

  Future<List<int>> _readData(String name) async {
    final ByteData data = await rootBundle.load('assets/fonts/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  //Draws the invoice header
  PdfLayoutResult _drawHeader(
    PdfPage page,
    Size pageSize,
    PdfGrid grid,
    PdfFont contentFont,
    PdfFont headerFont,
    PdfFont footerFont,
  ) {
    //Draw rectangle
    page.graphics.drawRectangle(
      brush: PdfSolidBrush(PdfColor(91, 126, 215)),
      bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90),
    );
    //Draw string
    page.graphics.drawString(
      'INVOICE',
      headerFont,
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 90),
      format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle),
    );
    page.graphics.drawRectangle(
      bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90),
      brush: PdfSolidBrush(PdfColor(65, 104, 205)),
    );
    page.graphics.drawString(
      r'$' + _getTotalAmount(grid).toString(),
      footerFont,
      bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 100),
      brush: PdfBrushes.white,
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
        lineAlignment: PdfVerticalAlignment.middle,
      ),
    );
    //Draw string
    page.graphics.drawString(
      'Amount',
      contentFont,
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
        lineAlignment: PdfVerticalAlignment.bottom,
      ),
    );
    //Create data foramt and convert it to text.
    final DateFormat format = DateFormat.yMMMMd('en_US');
    final String invoiceNumber =
        'Invoice Number: 2058557939\r\n\r\nDate: ' +
        format.format(DateTime.now());
    final Size contentSize = contentFont.measureString(invoiceNumber);
    const String address =
        'Bill To: \r\n\r\nAbraham Swearegin, \r\n\r\nUnited States, California, San Mateo, \r\n\r\n9920 BridgePointe Parkway, \r\n\r\n9365550136';
    PdfTextElement(text: invoiceNumber, font: contentFont).draw(
      page: page,
      bounds: Rect.fromLTWH(
        pageSize.width - (contentSize.width + 30),
        120,
        contentSize.width + 30,
        pageSize.height - 120,
      ),
    );
    return PdfTextElement(text: address, font: contentFont).draw(
      page: page,
      bounds: Rect.fromLTWH(
        30,
        120,
        pageSize.width - (contentSize.width + 30),
        pageSize.height - 120,
      ),
    )!;
  }

  //Draws the grid
  void _drawGrid(
    PdfPage page,
    PdfGrid grid,
    PdfLayoutResult result,
    PdfFont contentFont,
  ) {
    Rect? totalPriceCellBounds;
    Rect? quantityCellBounds;
    //Invoke the beginCellLayout event.
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };
    //Draw the PDF grid and get the result.
    result = grid.draw(
      page: page,
      bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0),
    )!;
    //Draw grand total.
    page.graphics.drawString(
      'Grand Total',
      contentFont,
      bounds: Rect.fromLTWH(
        quantityCellBounds!.left,
        result.bounds.bottom + 10,
        quantityCellBounds!.width,
        quantityCellBounds!.height,
      ),
    );
    page.graphics.drawString(
      _getTotalAmount(grid).toString(),
      contentFont,
      bounds: Rect.fromLTWH(
        totalPriceCellBounds!.left,
        result.bounds.bottom + 10,
        totalPriceCellBounds!.width,
        totalPriceCellBounds!.height,
      ),
    );
  }

  //Draw the invoice footer data.
  void _drawFooter(PdfPage page, Size pageSize, PdfFont contentFont) {
    final PdfPen linePen = PdfPen(
      PdfColor(142, 170, 219),
      dashStyle: PdfDashStyle.custom,
    );
    linePen.dashPattern = <double>[3, 3];
    //Draw line
    page.graphics.drawLine(
      linePen,
      Offset(0, pageSize.height - 100),
      Offset(pageSize.width, pageSize.height - 100),
    );
    const String footerContent =
        '800 Interchange Blvd.\r\n\r\nSuite 2501, Austin, TX 78721\r\n\r\nAny Questions? support@adventure-works.com';
    //Added 30 as a margin for the layout
    page.graphics.drawString(
      footerContent,
      contentFont,
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
      bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0),
    );
  }

  //Create PDF grid and return
  PdfGrid _getGrid(PdfFont contentFont) {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Secify the columns count to the grid.
    grid.columns.add(count: 5);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Product Id';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'Product Name';
    headerRow.cells[2].value = 'Price';
    headerRow.cells[3].value = 'Quantity';
    headerRow.cells[4].value = 'Total';
    _addProducts('CA-1098', 'AWC Logo Cap', 8.99, 2, 17.98, grid);
    _addProducts(
      'LJ-0192',
      'Long-Sleeve Logo Jersey,M',
      49.99,
      3,
      149.97,
      grid,
    );
    _addProducts('So-B909-M', 'Mountain Bike Socks,M', 9.5, 2, 19, grid);
    _addProducts(
      'LJ-0192',
      'Long-Sleeve Logo Jersey,M',
      49.99,
      4,
      199.96,
      grid,
    );
    _addProducts('FK-5136', 'ML Fork', 175.49, 6, 1052.94, grid);
    _addProducts('HL-U509', 'Sports-100 Helmet,Black', 34.99, 1, 34.99, grid);
    final PdfPen whitePen = PdfPen(PdfColor.empty, width: 0.5);
    final PdfBorders borders = PdfBorders();
    borders.all = PdfPen(PdfColor(142, 179, 219), width: 0.5);
    grid.rows.applyStyle(PdfGridCellStyle(borders: borders));
    grid.columns[1].width = 200;
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding = PdfPaddings(
        bottom: 5,
        left: 5,
        right: 5,
        top: 5,
      );
      headerRow.cells[i].style.borders.all = whitePen;
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      if (i.isEven) {
        row.style.backgroundBrush = PdfSolidBrush(PdfColor(217, 226, 243));
      }
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding = PdfPaddings(
          bottom: 5,
          left: 5,
          right: 5,
          top: 5,
        );
      }
    }
    //Set font
    grid.style.font = contentFont;
    return grid;
  }

  //Create and row for the grid.
  void _addProducts(
    String productId,
    String productName,
    double price,
    int quantity,
    double total,
    PdfGrid grid,
  ) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = productId;
    row.cells[1].value = productName;
    row.cells[2].value = price.toString();
    row.cells[3].value = quantity.toString();
    row.cells[4].value = total.toString();
  }

  //Get the total amount.
  double _getTotalAmount(PdfGrid grid) {
    double total = 0;
    for (int i = 0; i < grid.rows.count; i++) {
      final String value =
          grid.rows[i].cells[grid.columns.count - 1].value as String;
      total += double.parse(value);
    }
    return total;
  }
}
