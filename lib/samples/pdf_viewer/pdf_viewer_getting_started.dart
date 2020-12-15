///Package import
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///PDF Viewer import
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

/// Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Local import
import '../../model/sample_view.dart';

///Widget of getting started PDF Viewer.
class GettingStartedPdfViewer extends SampleView {
  /// Creates default getting started PDF Viewer.
  const GettingStartedPdfViewer(Key key) : super(key: key);

  @override
  _GettingStartedPdfViewerState createState() =>
      _GettingStartedPdfViewerState();
}

class _GettingStartedPdfViewerState extends SampleViewState {
  bool _showPdf;
  bool _showToast;
  OverlayEntry _overlayEntry;
  Color _contextMenuColor;
  Color _copyColor;
  double _contextMenuWidth;
  double _contextMenuHeight;
  final PdfViewerController _pdfViewerController = PdfViewerController();

  @override
  void initState() {
    _showPdf = false;
    _showToast = false;
    _contextMenuHeight = 48;
    _contextMenuWidth = 100;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    /// Used figma colors for context menu color and copy text color.
    _contextMenuColor = model.themeData.brightness == Brightness.light
        ? Color(0xFFFFFFFF)
        : Color(0xFF424242);
    _copyColor = model.themeData.brightness == Brightness.light
        ? Color(0xFF000000)
        : Color(0xFFFFFFFF);
    super.didChangeDependencies();
  }

  /// Show Context menu for Text Selection.
  void _showContextMenu(
      BuildContext context, PdfTextSelectionChangedDetails details) {
    final RenderBox renderBoxContainer =
        context.findRenderObject() as RenderBox;
    final Offset containerOffset = renderBoxContainer.localToGlobal(
      renderBoxContainer.paintBounds.topLeft,
    );
    if (containerOffset.dy < details.globalSelectedRegion.topLeft.dy - 55 ||
        (containerOffset.dy <
                details.globalSelectedRegion.center.dy -
                    (_contextMenuHeight / 2) &&
            details.globalSelectedRegion.height > _contextMenuWidth)) {
      double top = details.globalSelectedRegion.height > _contextMenuWidth
          ? details.globalSelectedRegion.center.dy - (_contextMenuHeight / 2)
          : details.globalSelectedRegion.topLeft.dy - 55;
      double left = details.globalSelectedRegion.height > _contextMenuWidth
          ? details.globalSelectedRegion.center.dx - (_contextMenuWidth / 2)
          : details.globalSelectedRegion.bottomLeft.dx;
      if ((details.globalSelectedRegion.top) >
          MediaQuery.of(context).size.height / 2) {
        top = details.globalSelectedRegion.topLeft.dy - 55;
        left = details.globalSelectedRegion.bottomLeft.dx;
      }
      final OverlayState _overlayState = Overlay.of(context);
      _overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: top,
          left: left,
          child: Container(
            decoration: BoxDecoration(
              color: _contextMenuColor,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.14),
                  blurRadius: 2,
                  offset: Offset(0, 0),
                ),
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.12),
                  blurRadius: 2,
                  offset: Offset(0, 2),
                ),
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.2),
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            constraints: BoxConstraints.tightFor(
                width: _contextMenuWidth, height: _contextMenuHeight),
            child: FlatButton(
              child: Text(
                'Copy',
                style: TextStyle(fontSize: 17, color: _copyColor),
              ),
              onPressed: () async {
                _checkAndCloseContextMenu();
                _pdfViewerController.clearSelection();
                await Clipboard.setData(
                    ClipboardData(text: details.selectedText));
                setState(() {
                  _showToast = true;
                });
                await Future.delayed(Duration(seconds: 1));
                setState(() {
                  _showToast = false;
                });
              },
            ),
          ),
        ),
      );
      _overlayState.insert(_overlayEntry);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                child: Stack(children: [
                  SfPdfViewer.asset(
                    'assets/pdf/flutter_succinctly.pdf',
                    controller: _pdfViewerController,
                    onTextSelectionChanged:
                        (PdfTextSelectionChangedDetails details) {
                      if (details.selectedText == null &&
                          _overlayEntry != null) {
                        _checkAndCloseContextMenu();
                      } else if (details.selectedText != null &&
                          _overlayEntry == null) {
                        _showContextMenu(context, details);
                      }
                    },
                  ),
                  Visibility(
                    visible: _showToast,
                    child: Positioned.fill(
                      bottom: 25.0,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                  left: 16, top: 6, right: 16, bottom: 6),
                              decoration: BoxDecoration(
                                color: Colors.grey[500],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16.0),
                                ),
                              ),
                              child: Text(
                                'Copied',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
              );
            } else {
              return Container(
                color: SfPdfViewerTheme.of(context).backgroundColor,
              );
            }
          }),
    );
  }

  /// Check and close the context menu.
  void _checkAndCloseContextMenu() {
    if (_overlayEntry != null) {
      _overlayEntry.remove();
      _overlayEntry = null;
    }
  }
}
