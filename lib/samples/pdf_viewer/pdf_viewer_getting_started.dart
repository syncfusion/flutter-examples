///Package import
import 'package:flutter/material.dart';

/// Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

///PDF Viewer import
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

///Local import
import '../../model/sample_view.dart';
import 'shared/helper.dart';

///Widget of getting started PDF Viewer.
class GettingStartedPdfViewer extends SampleView {
  /// Creates default getting started PDF Viewer.
  const GettingStartedPdfViewer(Key key) : super(key: key);

  @override
  _GettingStartedPdfViewerState createState() =>
      _GettingStartedPdfViewerState();
}

class _GettingStartedPdfViewerState extends SampleViewState {
  late bool _canShowPdf;
  final PdfViewerController _pdfViewerController = PdfViewerController();

  @override
  void initState() {
    Future<dynamic>.delayed(const Duration(milliseconds: 600), () {
      if (super.mounted) {
        final FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.requestFocus(FocusNode());
        }
      }
    });
    super.initState();
    _canShowPdf = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: always_specify_types
      body: FutureBuilder(
          future: Future<dynamic>.delayed(const Duration(milliseconds: 200))
              .then((dynamic value) {
            _canShowPdf = true;
          }),
          builder: (BuildContext context, AsyncSnapshot<Object?> snapshot) {
            if (_canShowPdf) {
              return SfPdfViewerTheme(
                data: SfPdfViewerThemeData(
                    brightness: model.themeData.colorScheme.brightness),
                child: SfPdfViewer.asset(
                  'assets/pdf/flutter_succinctly.pdf',
                  controller: _pdfViewerController,
                ),
              );
            } else {
              return Container(
                color: SfPdfViewerTheme.of(context)!.backgroundColor,
              );
            }
          }),
    );
  }
}
