///Package imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///Pdf import
import 'package:syncfusion_flutter_pdf/pdf.dart';

///Local imports
import '../../model/sample_view.dart';
import 'helper/save_file_mobile.dart'
    if (dart.library.js_interop) 'helper/save_file_web.dart';

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
      backgroundColor: model.sampleOutputCardColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'This sample shows how to create annotations such as rectangle, ellipse, polygon, and line in a PDF document. ',
                style: TextStyle(fontSize: 16, color: model.textColor),
              ),
              const SizedBox(height: 10, width: 30),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: flatten,
                    activeColor: model.primaryColor,
                    onChanged: (bool? value) {
                      setState(() {
                        flatten = value!;
                      });
                    },
                  ),
                  Text(
                    'Flatten Annotation',
                    style: TextStyle(fontSize: 16, color: model.textColor),
                  ),
                ],
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
                  onPressed: _generatePDF,
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

  Future<void> _generatePDF() async {
    //Load the PDF document.
    final PdfDocument document = PdfDocument(
      inputBytes: await _readDocumentData('annotation_template.pdf'),
    );
    //Get the page.
    final PdfPage page = document.pages[0];
    //Create a line annotation.
    final PdfLineAnnotation lineAnnotation = PdfLineAnnotation(
      <int>[60, 710, 187, 710],
      'Introduction',
      color: PdfColor(0, 0, 255),
      author: 'John Milton',
      border: PdfAnnotationBorder(2),
      setAppearance: true,
      lineIntent: PdfLineIntent.lineDimension,
    );
    //Add the line annotation to the page.
    page.annotations.add(lineAnnotation);

    //Create a ellipse Annotation.
    final PdfEllipseAnnotation ellipseAnnotation = PdfEllipseAnnotation(
      const Rect.fromLTRB(475, 771, 549, 815),
      'Page Number',
      author: 'John Milton',
      border: PdfAnnotationBorder(2),
      color: PdfColor(255, 0, 0),
      setAppearance: true,
    );
    //Add the ellipse annotation to the page.
    page.annotations.add(ellipseAnnotation);

    //Create a rectangle annotation.
    final PdfRectangleAnnotation rectangleAnnotation = PdfRectangleAnnotation(
      const Rect.fromLTRB(57, 250, 565, 349),
      'Usage',
      color: PdfColor(255, 170, 0),
      border: PdfAnnotationBorder(2),
      author: 'John Milton',
      setAppearance: true,
    );
    //Add the rectangle annotation to the page.
    page.annotations.add(rectangleAnnotation);

    //Create a polygon annotation.
    final PdfPolygonAnnotation polygonAnnotation = PdfPolygonAnnotation(
      <int>[
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
        356,
      ],
      'Chapter 1 Conceptual Overview',
      color: PdfColor(255, 0, 0),
      border: PdfAnnotationBorder(2),
      author: 'John Milton',
      setAppearance: true,
    );
    //Add the polygon annotation to the page.
    page.annotations.add(polygonAnnotation);

    //Create a text markup annotation.
    final PdfTextMarkupAnnotation textMarkupAnnotation =
        PdfTextMarkupAnnotation(
          const Rect.fromLTWH(60, 165, 495, 45),
          'Introduction',
          PdfColor(255, 255, 0),
          author: 'John Milton',
        );
    //Add the bounds collection to highlight the text on more than one line.
    textMarkupAnnotation.boundsCollection = <Rect>[
      const Rect.fromLTWH(251, 165, 304, 15),
      const Rect.fromLTWH(60, 180, 495, 15),
      const Rect.fromLTWH(60, 195, 100, 15),
    ];

    //Add the text markup annotation to the page.
    page.annotations.add(textMarkupAnnotation);

    //Create a popup annotation.
    final PdfPopupAnnotation popupAnnotation = PdfPopupAnnotation(
      const Rect.fromLTWH(225, 371, 20, 20),
      'PDF Standard',
      author: 'John Milton',
      color: PdfColor(255, 255, 0),
      icon: PdfPopupIcon.comment,
      open: true,
      setAppearance: true,
    );

    //Add the popup annotation to the page.
    page.annotations.add(popupAnnotation);

    if (flatten) {
      //Flatten all the annotations.
      page.annotations.flattenAllAnnotations();
    }

    //Save and dispose the document.
    final List<int> bytes = await document.save();
    document.dispose();
    //Launch file.
    await FileSaveHelper.saveAndLaunchFile(bytes, 'Annotations.pdf');
  }

  Future<List<int>> _readDocumentData(String name) async {
    final ByteData data = await rootBundle.load('assets/pdf/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
}
