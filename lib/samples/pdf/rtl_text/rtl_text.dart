import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter_examples/samples/pdf/helper/save_file_mobile.dart'
    if (dart.library.html) 'package:flutter_examples/samples/pdf/helper/save_file_web.dart';

//ignore: must_be_immutable
class RTLTextPdf extends StatefulWidget {
  RTLTextPdf({this.sample, Key key}) : super(key: key);
  SubItem sample;
  @override
  _RTLTextPdfState createState() => _RTLTextPdfState(sample);
}

class _RTLTextPdfState extends State<RTLTextPdf> {
  _RTLTextPdfState(this.sample);

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
                        'The Syncfusion Flutter PDF package provides support for right-to-left (RTL) language text such as Arabic, Hebrew, Persian, Urdu, etc. in a PDF document.\r\n\r\nThis sample explains RTL support in a PDF document.',
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
    //Create a PDF true type font.
    final PdfFont font = PdfTrueTypeFont(await _readFontData('arial.ttf'), 12);

    final PdfStringFormat format = PdfStringFormat();
    format.textDirection = PdfTextDirection.rightToLeft;
    format.alignment = PdfTextAlignment.right;
    format.paragraphIndent = 35;
    //Add page and draw string.
    document.pages.add().graphics.drawString(_rtlText, font,
        brush: PdfBrushes.black,
        bounds: const Rect.fromLTWH(0, 0, 515, 742),
        format: PdfStringFormat(
            textDirection: PdfTextDirection.rightToLeft,
            alignment: PdfTextAlignment.right,
            paragraphIndent: 35));
    //Save and dispose.
    final List<int> bytes = document.save();
    document.dispose();

    //Save and launch the PDF file
    FileSaveHelper.saveAndLaunchFile(bytes, 'RTL.pdf');
  }

  final String _rtlText =
      'سنبدأ بنظرة عامة مفاهيمية على مستند PDF بسيط. تم تصميم هذا الفصل ليكون توجيهًا مختصرًا قبل الغوص في مستند حقيقي وإنشاءه من البداية.\r\n \r\nيمكن تقسيم ملف PDF إلى أربعة أجزاء: الرأس والجسم والجدول الإسناد الترافقي والمقطورة. يضع الرأس الملف كملف PDF ، حيث يحدد النص المستند المرئي ، ويسرد جدول الإسناد الترافقي موقع كل شيء في الملف ، ويوفر المقطع الدعائي تعليمات حول كيفية بدء قراءة الملف.\r\n\r\nرأس الصفحة هو ببساطة رقم إصدار PDF وتسلسل عشوائي للبيانات الثنائية. البيانات الثنائية تمنع التطبيقات الساذجة من معالجة ملف PDF كملف نصي. سيؤدي ذلك إلى ملف تالف ، لأن ملف PDF يتكون عادةً من نص عادي وبيانات ثنائية (على سبيل المثال ، يمكن تضمين ملف خط ثنائي بشكل مباشر في ملف PDF).\r\n\r\nלאחר הכותרת והגוף מגיע טבלת הפניה המקושרת. הוא מתעדת את מיקום הבית של כל אובייקט בגוף הקובץ. זה מאפשר גישה אקראית של המסמך, ולכן בעת עיבוד דף, רק את האובייקטים הנדרשים עבור דף זה נקראים מתוך הקובץ. זה עושה מסמכי PDF הרבה יותר מהר מאשר קודמיו PostScript, אשר היה צריך לקרוא את כל הקובץ לפני עיבוד זה.';
  Future<List<int>> _readFontData(String fileName) async {
    //Read font from assets.
    final ByteData bytes = await rootBundle.load('assets/pdf/$fileName');
    return bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }
}
