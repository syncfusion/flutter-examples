///Package imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///Pdf import
import 'package:syncfusion_flutter_pdf/pdf.dart';

///Local imports
import '../../model/sample_view.dart';
import 'helper/save_file_mobile.dart'
    if (dart.library.js_interop) 'helper/save_file_web.dart';

/// Encrypt PDF document
class SignPdf extends SampleView {
  /// Encrypt the PDF document
  const SignPdf(Key key) : super(key: key);
  @override
  _SignPdfState createState() => _SignPdfState();
}

class _SignPdfState extends SampleViewState {
  _SignPdfState();
  int _groupValue = 1;
  int _cryptoGroupValue = 1;
  void _digestChanged(int? value) {
    setState(() {
      _groupValue = value!;
    });
  }

  void _cryptoChanged(int? value) {
    setState(() {
      _cryptoGroupValue = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final List<Widget> digestChildWidgets = getDigestChildWidgets(context);
    final List<Widget> cryptographicChildWidgets = getCryptographicChildWidgets(
      context,
    );
    return Scaffold(
      backgroundColor: model.sampleOutputCardColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'This sample shows how to digitally sign the PDF document with .pfx certificates. It also supports various digest algorithms and cryptographic standards.',
                style: TextStyle(fontSize: 16, color: model.textColor),
              ),
              const SizedBox(height: 20, width: 30),
              Text(
                'Cryptographic Standard',
                style: TextStyle(
                  fontSize: 16,
                  color: model.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10, width: 30),
              RadioGroup<int>(
                groupValue: _cryptoGroupValue,
                onChanged: _cryptoChanged,
                child: (width > 800)
                    ? Row(children: cryptographicChildWidgets)
                    : Column(children: cryptographicChildWidgets),
              ),
              const SizedBox(height: 20, width: 30),
              Text(
                'Digest Algorithm',
                style: TextStyle(
                  fontSize: 16,
                  color: model.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10, width: 30),
              RadioGroup<int>(
                groupValue: _groupValue,
                onChanged: _digestChanged,
                child: (width > 800)
                    ? Row(children: digestChildWidgets)
                    : Column(children: digestChildWidgets),
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
                  onPressed: _signPDF,
                  child: const Text(
                    'Sign PDF',
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

  List<Widget> getDigestChildWidgets(BuildContext context) {
    return <Widget>[
      Row(
        children: <Widget>[
          const Radio<int>(value: 0),
          Text('SHA1', style: TextStyle(fontSize: 16, color: model.textColor)),
        ],
      ),
      Row(
        children: <Widget>[
          const Radio<int>(value: 1),
          Text(
            'SHA256',
            style: TextStyle(fontSize: 16, color: model.textColor),
          ),
        ],
      ),
      Row(
        children: <Widget>[
          const Radio<int>(value: 2),
          Text(
            'SHA384',
            style: TextStyle(fontSize: 16, color: model.textColor),
          ),
        ],
      ),
      Row(
        children: <Widget>[
          const Radio<int>(value: 3),
          Text(
            'SHA512',
            style: TextStyle(fontSize: 16, color: model.textColor),
          ),
        ],
      ),
    ];
  }

  List<Widget> getCryptographicChildWidgets(BuildContext context) {
    return <Widget>[
      Row(
        children: <Widget>[
          const Radio<int>(value: 0),
          Text('CMS', style: TextStyle(fontSize: 16, color: model.textColor)),
        ],
      ),
      Row(
        children: <Widget>[
          const Radio<int>(value: 1),
          Text('CAdES', style: TextStyle(fontSize: 16, color: model.textColor)),
        ],
      ),
    ];
  }

  Future<void> _signPDF() async {
    //Load the PDF document.
    final PdfDocument document = PdfDocument(
      inputBytes: await _readDocumentData('digital_signature_template.pdf'),
    );

    //Get the signature field.
    final PdfSignatureField signatureField =
        document.form.fields[6] as PdfSignatureField;

    //Create Pdf certificate.
    final PdfCertificate certificate = PdfCertificate(
      await _readDocumentData('certificate.pfx'),
      'password123',
    );

    //Get signature field and sign.
    signatureField.signature = PdfSignature(
      certificate: certificate,
      contactInfo: 'johndoe@owned.us',
      locationInfo: 'Honolulu, Hawaii',
      reason: 'I am author of this document.',
      digestAlgorithm: _getDigestAlgorithm(),
      cryptographicStandard: _cryptoGroupValue == 1
          ? CryptographicStandard.cades
          : CryptographicStandard.cms,
    );

    //Get the signatue field bounds.
    final Rect bounds = signatureField.bounds;

    //Draw appearance.
    //Get the signature field appearance graphics.
    final PdfGraphics? graphics = signatureField.appearance.normal.graphics;
    if (graphics != null) {
      graphics.drawRectangle(
        pen: PdfPens.black,
        bounds: Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      );
      graphics.drawImage(
        PdfBitmap(await _readDocumentData('signature.png', true)),
        const Rect.fromLTWH(2, 1, 30, 30),
      );
      //Get certificate subject name.
      final String subject = certificate.subjectName;
      graphics.drawString(
        'Digitally signed by $subject \r\nReason: Testing signature \r\nLocation: USA',
        PdfStandardFont(PdfFontFamily.helvetica, 7),
        bounds: Rect.fromLTWH(45, 0, bounds.width - 45, bounds.height),
        brush: PdfBrushes.black,
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle),
      );
    }

    //Save the PDF document
    final List<int> bytes = await document.save();
    //Dispose the document.
    document.dispose();
    //Save and launch file.
    await FileSaveHelper.saveAndLaunchFile(bytes, 'SignedPdf.pdf');
  }

  Future<List<int>> _readDocumentData(
    String name, [
    bool isImage = false,
  ]) async {
    final ByteData data = await rootBundle.load(
      isImage ? 'images/pdf/$name' : 'assets/pdf/$name',
    );
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  DigestAlgorithm _getDigestAlgorithm() {
    DigestAlgorithm algorithm;
    switch (_groupValue) {
      case 0:
        algorithm = DigestAlgorithm.sha1;
        break;
      case 2:
        algorithm = DigestAlgorithm.sha384;
        break;
      case 3:
        algorithm = DigestAlgorithm.sha512;
        break;
      default:
        algorithm = DigestAlgorithm.sha256;
        break;
    }
    return algorithm;
  }
}
