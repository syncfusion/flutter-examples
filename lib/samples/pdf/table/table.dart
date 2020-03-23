import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter_examples/samples/pdf/helper/save_file_mobile.dart'
    if (dart.library.html) 'package:flutter_examples/samples/pdf/helper/save_file_web.dart';

//ignore: must_be_immutable
class PdfTable extends StatefulWidget {
  PdfTable({this.sample, Key key}) : super(key: key);
  SubItem sample;
  @override
  _PdfTableState createState() => _PdfTableState(sample);
}

class _PdfTableState extends State<PdfTable> {
  _PdfTableState(this.sample);

  final SubItem sample;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                        'The Syncfusion Flutter PDF package supports creating PDF tables. The PDF table is used to display data from data sources and direct data binding in a tabular format. It is designed for high-performance with advanced customization, styling, and formatting.\r\n\r\nThis sample explains how to create tables (grid) in a PDF document.',
                        style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 20, width: 30),
                    Align(
                        alignment: Alignment.center,
                        child: FlatButton(
                            child: const Text('Generate PDF',
                                style: TextStyle(color: Colors.white)),
                            color: model.backgroundColor,
                            onPressed: generatePDF))
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> generatePDF() async {
    //Create a new PDF document.
    final PdfDocument document = PdfDocument();
    //Add a PDF page.
    final PdfPage page = document.pages.add();
    //String format for table cells.
    final PdfStringFormat format = PdfStringFormat(
        alignment: PdfTextAlignment.center,
        lineAlignment: PdfVerticalAlignment.middle);
    //Draw line
    page.graphics.drawLine(PdfPen(PdfColor(0, 0, 110), width: 2),
        const Offset(0, 3), Offset(page.getClientSize().width, 3));
    //Draw string
    page.graphics.drawString('Northwind Customers',
        PdfStandardFont(PdfFontFamily.helvetica, 18, style: PdfFontStyle.bold),
        brush: PdfSolidBrush(PdfColor(17, 50, 140)),
        format: format,
        bounds: Rect.fromLTWH(0, 5, page.getClientSize().width, 50));
    //Draw line
    page.graphics.drawLine(PdfPen(PdfColor(0, 0, 110), width: 3),
        const Offset(0, 55), Offset(page.getClientSize().width, 55));
    //Draw image
    page.graphics.drawImage(PdfBitmap(await _readImageData('logo.jpg')),
        Rect.fromLTWH(page.getClientSize().width - 120, 9, 120, 42));
    //Create a PDF header border
    final PdfBorders headerBorder = PdfBorders();
    headerBorder.all = PdfPen(PdfColor(17, 50, 140), width: 1);
    //Create a PDF header style.
    final PdfGridCellStyle headerStyle = PdfGridCellStyle(
        borders: headerBorder,
        format: format,
        font: PdfStandardFont(PdfFontFamily.helvetica, 6),
        cellPadding: PdfPaddings(left: 2, right: 2, top: 1, bottom: 1),
        textBrush: PdfBrushes.white,
        backgroundBrush: PdfSolidBrush(PdfColor(58, 78, 133)));
    //Row border and row style.
    final PdfBorders rowBorder = PdfBorders();
    rowBorder.all = PdfPen(PdfColor(17, 50, 140), width: 0.5);
    final PdfGridCellStyle rowStyle = PdfGridCellStyle(
        borders: rowBorder,
        font: PdfStandardFont(PdfFontFamily.helvetica, 6),
        cellPadding: PdfPaddings(left: 2, right: 2, top: 1, bottom: 1),
        format: format);
    //Read json data.
    final dynamic data =
        json.decode(await rootBundle.loadString('assets/pdf/northwind.json'));
    final dynamic details = data['Customers'];

    //Create a PDF grid.
    final PdfGrid grid = PdfGrid();
    //Add columns
    grid.columns.add(count: details[0].length);
    //Enable repeat header.
    grid.repeatHeader = true;
    //Create header row.
    final PdfGridRow header = grid.headers.add(1)[0];
    int i = 0;
    //Set value to the header row.
    details[0].forEach((String key, dynamic value) {
      header.cells[i].value = key;
      header.cells[i++].style = headerStyle;
    });
    //Set values to the row
    for (i = 0; i < details.length; i++) {
      final PdfGridRow row = grid.rows.add();
      int j = 0;
      details[i].forEach((String key, dynamic value) {
        row.cells[j++].value = value;
        if (i % 2 != 0) {
          row.style.backgroundBrush = PdfSolidBrush(PdfColor(176, 196, 222));
        }
      });
    }
    grid.rows.applyStyle(rowStyle);
    //Draw grid.
    grid.draw(
        page: page,
        bounds: Rect.fromLTWH(0, 65, page.getClientSize().width,
            page.getClientSize().height - 70));
    //Save and dispose document.
    final List<int> bytes = document.save();
    document.dispose();

    //Save and launch the PDF file
    FileSaveHelper.saveAndLaunchFile(bytes, 'Table.pdf');
  }

  Future<List<int>> _readImageData(String fileName) async {
    //Read json file from assets.
    final ByteData bytes = await rootBundle.load('images/pdf/$fileName');
    return bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }
}
