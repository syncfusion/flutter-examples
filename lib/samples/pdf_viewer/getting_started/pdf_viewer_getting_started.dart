///Package import
import 'package:flutter/material.dart';

///PDF Viewer import
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

/// Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Local import
import '../../../model/sample_view.dart';

///Widget of getting started PDF Viewer.
class GettingStartedPdfViewer extends SampleView {
  /// Creates default getting started PDF Viewer.
  const GettingStartedPdfViewer(Key key) : super(key: key);

  @override
  _GettingStartedPdfViewerState createState() =>
      _GettingStartedPdfViewerState();
}

class _GettingStartedPdfViewerState extends SampleViewState {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool _showPdf = false;
    // TODO: implement build
    return Scaffold(
      body: FutureBuilder(
          future: Future.delayed(Duration(milliseconds: 200)).then((value) {
            _showPdf = true;
          }),
          builder: (context, snapshot) {
            if (_showPdf) {
              return SfPdfViewerTheme(
                  data: SfPdfViewerThemeData(
                      brightness: model.themeData.brightness),
                  child:
                      SfPdfViewer.asset('assets/pdf/flutter_succinctly.pdf'));
            } else {
              return Container(
                color: SfPdfViewerTheme.of(context).backgroundColor,
              );
            }
          }),
    );
  }
}
