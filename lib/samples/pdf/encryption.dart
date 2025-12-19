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
class EncryptPdf extends SampleView {
  /// Encrypt the PDF document
  const EncryptPdf(Key key) : super(key: key);
  @override
  _EncryptPdfState createState() => _EncryptPdfState();
}

class _EncryptPdfState extends SampleViewState {
  _EncryptPdfState();
  int _groupValue = 3;
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
                'This sample shows how to encrypt the existing PDF document with encryption standard like 40-bit RC4, 128-bit RC4, 128-bit AES, 256-bit AES, and advanced encryption standard 256-bit AES Revision 6 (PDF 2.0) to protect documents against unauthorized access.',
                style: TextStyle(fontSize: 16, color: model.textColor),
              ),
              const SizedBox(height: 20, width: 30),
              Text(
                'Encryption Type',
                style: TextStyle(
                  fontSize: 16,
                  color: model.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10, width: 30),
              RadioGroup<int>(
                groupValue: _groupValue,
                onChanged: _changed,
                child: (MediaQuery.of(context).size.width > 800)
                    ? Row(children: getChildWidgets(context))
                    : Column(children: getChildWidgets(context)),
              ),
              const SizedBox(height: 10, width: 30),
              Row(
                children: <Widget>[
                  Text(
                    'User Password: ',
                    style: TextStyle(
                      fontSize: 16,
                      color: model.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'password@123',
                    style: TextStyle(fontSize: 16, color: model.textColor),
                  ),
                ],
              ),
              const SizedBox(height: 15, width: 30),
              Row(
                children: <Widget>[
                  Text(
                    'Owner Password: ',
                    style: TextStyle(
                      fontSize: 16,
                      color: model.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'syncfusion',
                    style: TextStyle(fontSize: 16, color: model.textColor),
                  ),
                ],
              ),
              const SizedBox(height: 15, width: 30),
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
                  onPressed: _encryptPDF,
                  child: const Text(
                    'Encrypt PDF',
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
            '40-bit RC4',
            style: TextStyle(fontSize: 16, color: model.textColor),
          ),
        ],
      ),
      Row(
        children: <Widget>[
          const Radio<int>(value: 1),
          Text(
            '128-bit RC4',
            style: TextStyle(fontSize: 16, color: model.textColor),
          ),
        ],
      ),
      Row(
        children: <Widget>[
          const Radio<int>(value: 2),
          Text(
            '128-bit AES',
            style: TextStyle(fontSize: 16, color: model.textColor),
          ),
        ],
      ),
      Row(
        children: <Widget>[
          const Radio<int>(value: 3),
          Text(
            '256-bit AES',
            style: TextStyle(fontSize: 16, color: model.textColor),
          ),
        ],
      ),
      Row(
        children: <Widget>[
          const Radio<int>(value: 4),
          Text(
            '256-bit AES Revision 6',
            style: TextStyle(fontSize: 16, color: model.textColor),
          ),
        ],
      ),
    ];
  }

  Future<void> _encryptPDF() async {
    //Load the PDF document.
    final PdfDocument document = PdfDocument(
      inputBytes: await _readDocumentData('credit_card_statement.pdf'),
    );

    // Get the PDF security.
    final PdfSecurity security = document.security;

    //Set passwords
    security.userPassword = 'password@123';
    security.ownerPassword = 'syncfusion';

    //Set the encryption algorithm.
    security.algorithm = _getAlgorithm();

    //Set the permissions.
    security.permissions.addAll(<PdfPermissionsFlags>[
      PdfPermissionsFlags.print,
      PdfPermissionsFlags.fullQualityPrint,
    ]);

    //Save and launch the document
    final List<int> bytes = await document.save();

    //Dispose the document.
    document.dispose();
    //Save and launch file.
    await FileSaveHelper.saveAndLaunchFile(bytes, 'EncryptedPDF.pdf');
  }

  Future<List<int>> _readDocumentData(String name) async {
    final ByteData data = await rootBundle.load('assets/pdf/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  PdfEncryptionAlgorithm _getAlgorithm() {
    PdfEncryptionAlgorithm algorithm;
    switch (_groupValue) {
      case 0:
        algorithm = PdfEncryptionAlgorithm.rc4x40Bit;
        break;
      case 1:
        algorithm = PdfEncryptionAlgorithm.rc4x128Bit;
        break;
      case 2:
        algorithm = PdfEncryptionAlgorithm.aesx128Bit;
        break;
      case 3:
        algorithm = PdfEncryptionAlgorithm.aesx256Bit;
        break;
      case 4:
        algorithm = PdfEncryptionAlgorithm.aesx256BitRevision6;
        break;
      default:
        algorithm = PdfEncryptionAlgorithm.aesx256Bit;
        break;
    }
    return algorithm;
  }
}
