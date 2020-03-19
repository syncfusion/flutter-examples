import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter_examples/samples/pdf/helper/save_file_mobile.dart'
    if (dart.library.html) 'package:flutter_examples/samples/pdf/helper/save_file_web.dart';

//ignore: must_be_immutable
class BulletsAndListsPdf extends StatefulWidget {
  BulletsAndListsPdf({this.sample, Key key}) : super(key: key);
  SubItem sample;
  @override
  _BulletsAndListsPdfState createState() => _BulletsAndListsPdfState(sample);
}

class _BulletsAndListsPdfState extends State<BulletsAndListsPdf> {
  _BulletsAndListsPdfState(this.sample);

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
                        'The Syncfusion Flutter PDF package provides support to create ordered list using numbers, alphabets and roman characters and unorder list with various built-in styles, custom images and templates.\r\n\r\nThis sample explains how to create bullets and lists in a PDF document.',
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

  void generatePDF() {
    //Create a PDF document.
    final PdfDocument document = PdfDocument();
    //Add a new PDF page.
    final PdfPage page = document.pages.add();

    //Draw text to the PDF page.
    page.graphics.drawString('Types of Animals',
        PdfStandardFont(PdfFontFamily.timesRoman, 18, style: PdfFontStyle.bold),
        brush: PdfBrushes.darkBlue,
        bounds: Rect.fromLTWH(
            0, 20, page.getClientSize().width, page.getClientSize().height));

    //Create bullets and lists
    final PdfList list = _createBulletsAndList();

    //Draw the list.
    list.draw(
        page: page,
        bounds: const Rect.fromLTWH(0, 60, 0, 0),
        format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate));

    //Save and dispose the document.
    final List<int> bytes = document.save();
    document.dispose();

    //Save and launch the PDF file
    FileSaveHelper.saveAndLaunchFile(bytes, 'Bullets and Lists.pdf');
  }

  PdfList _createBulletsAndList() {
//Create a PDF standard font.
    final PdfStandardFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
    //Create PDF lists.
    final PdfOrderedList animals = PdfOrderedList(
        font: PdfStandardFont(PdfFontFamily.helvetica, 12,
            style: PdfFontStyle.bold),
        style: PdfNumberStyle.numeric,
        items: PdfListItemCollection(<String>[
          'Mammals',
          'Reptiles',
          'Birds',
          'Insects',
          'Aquatic Animals'
        ]),
        markerHierarchy: true,
        textIndent: 10,
        format: PdfStringFormat(lineSpacing: 10));

    //Create sub list
    animals.items[0].subList = PdfOrderedList(
        marker: PdfOrderedMarker(font: font, style: PdfNumberStyle.numeric),
        font: font,
        style: PdfNumberStyle.numeric,
        items: PdfListItemCollection(<String>[
          'body covered by hair or fur',
          'warm-blooded',
          'have a backbone',
          'produce milk',
          'Examples'
        ]),
        markerHierarchy: true,
        indent: 20,
        textIndent: 8);

    final PdfUnorderedMarker unorderedMarker = PdfUnorderedMarker(
        font: PdfStandardFont(PdfFontFamily.courier, 10),
        style: PdfUnorderedMarkerStyle.circle);

    animals.items[0].subList.items[4].subList = PdfUnorderedList(
        marker: unorderedMarker,
        font: font,
        style: PdfUnorderedMarkerStyle.disk,
        indent: 28,
        textIndent: 8,
        items: PdfListItemCollection(<String>['Tiger', 'Bat']));

    animals.items[1].subList = PdfOrderedList(
        marker: PdfOrderedMarker(font: font, style: PdfNumberStyle.numeric),
        font: font,
        style: PdfNumberStyle.numeric,
        items: PdfListItemCollection(<String>[
          'body covered by scales',
          'cold-blooded',
          'have a backbone',
          'most lay hard-shelled eggs on land',
          'Examples'
        ]),
        markerHierarchy: true,
        indent: 20,
        textIndent: 8);

    animals.items[1].subList.items[4].subList = PdfUnorderedList(
        marker: unorderedMarker,
        font: font,
        style: PdfUnorderedMarkerStyle.disk,
        items: PdfListItemCollection(<String>['Snake', 'Lizard']),
        indent: 28,
        textIndent: 8);

    animals.items[2].subList = PdfOrderedList(
        marker: PdfOrderedMarker(font: font, style: PdfNumberStyle.numeric),
        font: font,
        style: PdfNumberStyle.numeric,
        items: PdfListItemCollection(<String>[
          'body covered by feathers',
          'warm-blooded',
          'have a backbone',
          'lay eggs',
          'Examples'
        ]),
        markerHierarchy: true,
        indent: 20,
        textIndent: 8);

    animals.items[2].subList.items[4].subList = PdfUnorderedList(
        marker: unorderedMarker,
        font: font,
        style: PdfUnorderedMarkerStyle.disk,
        items: PdfListItemCollection(<String>['Pigeon', 'Hen']),
        indent: 28,
        textIndent: 8);

    animals.items[3].subList = PdfOrderedList(
        marker: PdfOrderedMarker(font: font, style: PdfNumberStyle.numeric),
        font: font,
        style: PdfNumberStyle.numeric,
        items: PdfListItemCollection(<String>[
          'most are small air-breathing animals',
          '6 legs',
          '2 antennae',
          '3 body sections (head, thorax, abdomen)',
          'Examples'
        ]),
        markerHierarchy: true,
        indent: 20,
        textIndent: 8);

    animals.items[3].subList.items[4].subList = PdfUnorderedList(
        marker: unorderedMarker,
        font: font,
        style: PdfUnorderedMarkerStyle.disk,
        items: PdfListItemCollection(<String>['Butterfly', 'Spider']),
        indent: 28,
        textIndent: 8);

    animals.items[4].subList = PdfOrderedList(
        marker: PdfOrderedMarker(font: font, style: PdfNumberStyle.numeric),
        font: font,
        style: PdfNumberStyle.numeric,
        items: PdfListItemCollection(<String>[
          'most have gills',
          'found in lakes, rivers, and oceans',
          'Examples'
        ]),
        markerHierarchy: true,
        indent: 20,
        textIndent: 8);

    animals.items[4].subList.items[2].subList = PdfUnorderedList(
      marker: unorderedMarker,
      font: font,
      style: PdfUnorderedMarkerStyle.disk,
      items: PdfListItemCollection(<String>['Blue Shark', 'Fish']),
      indent: 28,
      textIndent: 8,
    );
    return animals;
  }
}
