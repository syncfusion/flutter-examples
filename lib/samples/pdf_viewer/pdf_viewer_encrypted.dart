import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../model/sample_view.dart';

/// Read the encrypted PDF document.
class EncryptedPdfViewer extends SampleView {
  /// Read the encrypted PDF document.
  const EncryptedPdfViewer(Key key) : super(key: key);

  @override
  _EncryptedPdfViewerState createState() => _EncryptedPdfViewerState();
}

class _EncryptedPdfViewerState extends SampleViewState {
  bool _showMasterPage = true;
  final String _documentPath = 'assets/pdf/encrypted_document.pdf';
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _showMasterPage
          ? model.sampleOutputCardColor
          : Theme.of(context).useMaterial3
          ? Theme.of(context).colorScheme.brightness == Brightness.light
                ? const Color.fromRGBO(247, 242, 251, 1)
                : const Color.fromRGBO(37, 35, 42, 1)
          : (Theme.of(context).colorScheme.brightness == Brightness.light)
          ? const Color(0xFFD6D6D6)
          : const Color(0xFF303030),
      body: _showMasterPage
          ? Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'This sample demonstrates viewing of encrypted or password protected PDF document in SfPdfViewer Widget.',
                    style: TextStyle(fontSize: 18, color: model.textColor),
                  ),
                  const SizedBox(height: 20, width: 30),
                  Text.rich(
                    TextSpan(
                      text: 'Note: ',
                      style: TextStyle(
                        fontSize: 18,
                        color: model.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Password to view the sample PDF document is ',
                          style: TextStyle(
                            fontSize: 18,
                            color: model.textColor,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        TextSpan(
                          text: 'syncfusion',
                          style: TextStyle(
                            fontSize: 18,
                            color: model.textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15, width: 30),
                  Align(
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          Theme.of(context).colorScheme.primary,
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
                      onPressed: () {
                        setState(() {
                          _showMasterPage = false;
                        });
                      },
                      child: Text(
                        'View PDF',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : SfPdfViewer.asset(_documentPath, key: _pdfViewerKey),
    );
  }
}
