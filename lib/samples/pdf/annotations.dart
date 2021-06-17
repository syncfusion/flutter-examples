///Package imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///Pdf import
import 'package:syncfusion_flutter_pdf/pdf.dart';

///Local imports
import '../../model/sample_view.dart';
import 'helper/save_file_mobile.dart'
    if (dart.library.html) 'helper/save_file_web.dart';

/// Render pdf with annotations
class AnnotationsPdf extends SampleView {
  /// Creates pdf with annotations
  const AnnotationsPdf(Key key) : super(key: key);
  @override
  _AnnotationsPdfState createState() => _AnnotationsPdfState();
}

class _AnnotationsPdfState extends SampleViewState {
  _AnnotationsPdfState();
  bool flatten = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: model.cardThemeColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  'This sample shows how to create annotations such as rectangle, ellipse, polygon, and line in a PDF document. ',
                  style: TextStyle(fontSize: 16, color: model.textColor)),
              const SizedBox(height: 10, width: 30),
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Checkbox(
                      value: flatten,
                      activeColor: model.backgroundColor,
                      onChanged: (bool? value) {
                        setState(() {
                          flatten = value!;
                        });
                      }),
                  Text('Flatten Annotation',
                      style: TextStyle(fontSize: 16, color: model.textColor)),
                ],
              )),
              const SizedBox(height: 10, width: 30),
              Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          model.backgroundColor),
                      padding: model.isMobile
                          ? null
                          : MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15)),
                    ),
                    onPressed: _generatePDF,
                    child: const Text('Generate PDF',
                        style: TextStyle(color: Colors.white)),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _generatePDF() async {
    //Load the PDF document.
    final PdfDocument document = PdfDocument(
        inputBytes: await _readDocumentData('annotation_template.pdf'));
    //Get the page.
    final PdfPage page = document.pages[0];
    //Create a line annotation.
    final PdfLineAnnotation lineAnnotation = PdfLineAnnotation(
        <int>[60, 710, 187, 710], 'Introduction',
        color: PdfColor(0, 0, 255),
        author: 'John Milton',
        border: PdfAnnotationBorder(2),
        lineCaption: false,
        setAppearance: true,
        lineIntent: PdfLineIntent.lineDimension);
    //Add the line annotation to the page.
    page.annotations.add(lineAnnotation);

    //Create a ellipse Annotation.
    final PdfEllipseAnnotation ellipseAnnotation = PdfEllipseAnnotation(
        const Rect.fromLTRB(475, 771, 549, 815), 'Page Number',
        author: 'John Milton',
        border: PdfAnnotationBorder(2),
        color: PdfColor(255, 0, 0),
        setAppearance: true);
    //Add the ellipse annotation to the page.
    page.annotations.add(ellipseAnnotation);

    //Create a rectangle annotation.
    final PdfRectangleAnnotation rectangleAnnotation = PdfRectangleAnnotation(
        const Rect.fromLTRB(57, 250, 565, 349), 'Usage',
        color: PdfColor(255, 170, 0),
        border: PdfAnnotationBorder(2),
        author: 'John Milton',
        setAppearance: true);
    //Add the rectangle annotation to the page.
    page.annotations.add(rectangleAnnotation);

    //Create a polygon annotation.
    final PdfPolygonAnnotation polygonAnnotation = PdfPolygonAnnotation(<int>[
      129,
      356,
      486,
      356,
      532,
      333,
      486,
      310,
      129,
      310,
      83,
      333,
      129,
      356
    ], 'Chapter 1 Conceptual Overview',
        color: PdfColor(255, 0, 0),
        border: PdfAnnotationBorder(2),
        author: 'John Milton',
        setAppearance: true);
    //Add the polygon annotation to the page.
    page.annotations.add(polygonAnnotation);

    if (flatten) {
      //Flatten all the annotations.
      page.annotations.flattenAllAnnotations();
    }

    //Save and dispose the document.
    final List<int> bytes = document.save();
    document.dispose();
    //Launch file.
    await FileSaveHelper.saveAndLaunchFile(bytes, 'Annotations.pdf');
  }

  Future<List<int>> _readDocumentData(String name) async {
    final ByteData data = await rootBundle.load('assets/pdf/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
}
