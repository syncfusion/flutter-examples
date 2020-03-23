import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter_examples/samples/pdf/helper/save_file_mobile.dart'
    if (dart.library.html) 'package:flutter_examples/samples/pdf/helper/save_file_web.dart';

//ignore: must_be_immutable
class ImageToPdf extends StatefulWidget {
  ImageToPdf({this.sample, Key key}) : super(key: key);
  SubItem sample;
  @override
  _ImageToPdfState createState() => _ImageToPdfState(sample);
}

class _ImageToPdfState extends State<ImageToPdf> {
  _ImageToPdfState(this.sample);

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
                        'The Syncfusion Flutter PDF package allows users to convert and insert images (JPEG and PNG only) into a PDF document. It supports image manipulations such as rotate, crop, scaling, and transparency.\r\n\r\nThis sample explains how to insert images in a PDF document.',
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
    //Create a PDF document.
    final PdfDocument document = PdfDocument();
    //Get page graphics.
    final PdfGraphics graphics = document.pages.add().graphics;
    graphics.drawString('JPEG Image',
        PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(0, 40, 0, 0), brush: PdfBrushes.blue);
    //Load the JPEG image.
    PdfBitmap image = PdfBitmap(await _readImageData('image.jpg'));
    //Draw image.
    graphics.drawImage(image, const Rect.fromLTWH(0, 70, 515, 215));
    graphics.drawString('PNG Image',
        PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(0, 355, 0, 0), brush: PdfBrushes.blue);
    //Load the PNG image.
    image = PdfBitmap(await _readImageData('image.png'));
    //Draw image.
    graphics.drawImage(image, const Rect.fromLTWH(0, 365, 199, 300));

    //Save and dispose the PDF document.
    final List<int> bytes = document.save();
    document.dispose();

    //Save and launch/download the PDF file.
    FileSaveHelper.saveAndLaunchFile(bytes, 'Image to PDF.pdf');
  }

  Future<List<int>> _readImageData(String fileName) async {
    //Read image from assets.
    final ByteData bytes = await rootBundle.load('images/pdf/$fileName');
    return bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }
}
