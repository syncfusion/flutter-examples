import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../model/sample_view.dart';

import '../pdf/helper/save_file_mobile.dart'
    if (dart.library.js_interop) '../pdf/helper/save_file_web.dart';

/// Form filling.
class FormFillingPdfViewer extends SampleView {
  /// Form filling.
  const FormFillingPdfViewer(Key key) : super(key: key);

  @override
  _FormFillingPdfViewerState createState() => _FormFillingPdfViewerState();
}

class _FormFillingPdfViewerState extends SampleViewState {
  final String _documentPath = 'assets/pdf/form_document.pdf';
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final UndoHistoryController _undoHistoryController = UndoHistoryController();
  Color? _iconEnabledColor;
  Color? _iconDisabledColor;
  late bool _useMaterial3;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _useMaterial3 = Theme.of(context).useMaterial3;
    _iconEnabledColor = _useMaterial3
        ? Theme.of(context).brightness == Brightness.light
              ? const Color.fromRGBO(73, 69, 79, 1)
              : const Color.fromRGBO(202, 196, 208, 1)
        : Theme.of(context).brightness == Brightness.light
        ? Colors.black.withValues(alpha: 0.54)
        : Colors.white.withValues(alpha: 0.65);
    _iconDisabledColor = _useMaterial3
        ? Theme.of(context).brightness == Brightness.light
              ? const Color.fromRGBO(28, 27, 31, 1).withValues(alpha: 0.38)
              : const Color.fromRGBO(230, 225, 229, 1).withValues(alpha: 0.38)
        : Theme.of(context).brightness == Brightness.light
        ? Colors.black12
        : Colors.white12;
  }

  @override
  void dispose() {
    _undoHistoryController.dispose();
    super.dispose();
    _pdfViewerController.dispose();
    _pdfViewerKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Tooltip(
                        decoration: _useMaterial3
                            ? BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.inverseSurface,
                                borderRadius: BorderRadius.circular(4),
                              )
                            : null,
                        textStyle: _useMaterial3
                            ? TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onInverseSurface,
                                fontSize: 14,
                              )
                            : null,
                        padding: _useMaterial3
                            ? const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              )
                            : null,
                        constraints: _useMaterial3
                            ? const BoxConstraints(maxHeight: 48)
                            : null,
                        message: 'Undo',
                        child: ValueListenableBuilder<UndoHistoryValue>(
                          valueListenable: _undoHistoryController,
                          builder:
                              (
                                BuildContext context,
                                UndoHistoryValue value,
                                Widget? child,
                              ) {
                                return MaterialButton(
                                  padding: EdgeInsets.zero,
                                  elevation: 0,
                                  focusElevation: 0,
                                  hoverElevation: 0,
                                  highlightElevation: 0,
                                  disabledElevation: 0,
                                  color: Colors.transparent,
                                  shape: _useMaterial3
                                      ? const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(4),
                                          ),
                                        )
                                      : null,
                                  onPressed: value.canUndo
                                      ? _undoHistoryController.undo
                                      : null,
                                  child: Icon(
                                    Icons.undo,
                                    size: 20,
                                    color: value.canUndo
                                        ? _iconEnabledColor
                                        : _iconDisabledColor,
                                  ),
                                );
                              },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Tooltip(
                        decoration: _useMaterial3
                            ? BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.inverseSurface,
                                borderRadius: BorderRadius.circular(4),
                              )
                            : null,
                        textStyle: _useMaterial3
                            ? TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onInverseSurface,
                                fontSize: 14,
                              )
                            : null,
                        padding: _useMaterial3
                            ? const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              )
                            : null,
                        constraints: _useMaterial3
                            ? const BoxConstraints(maxHeight: 48)
                            : null,
                        message: 'Redo',
                        child: ValueListenableBuilder<UndoHistoryValue>(
                          valueListenable: _undoHistoryController,
                          builder:
                              (
                                BuildContext context,
                                UndoHistoryValue value,
                                Widget? child,
                              ) {
                                return MaterialButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: value.canRedo
                                      ? _undoHistoryController.redo
                                      : null,
                                  elevation: 0,
                                  focusElevation: 0,
                                  hoverElevation: 0,
                                  highlightElevation: 0,
                                  disabledElevation: 0,
                                  color: Colors.transparent,
                                  shape: _useMaterial3
                                      ? const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(4),
                                          ),
                                        )
                                      : null,
                                  child: Icon(
                                    Icons.redo,
                                    size: 20,
                                    color: value.canRedo
                                        ? _iconEnabledColor
                                        : _iconDisabledColor,
                                  ),
                                );
                              },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Tooltip(
                        decoration: _useMaterial3
                            ? BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.inverseSurface,
                                borderRadius: BorderRadius.circular(4),
                              )
                            : null,
                        textStyle: _useMaterial3
                            ? TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onInverseSurface,
                                fontSize: 14,
                              )
                            : null,
                        padding: _useMaterial3
                            ? const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              )
                            : null,
                        constraints: _useMaterial3
                            ? const BoxConstraints(maxHeight: 48)
                            : null,
                        message: 'Save Document',
                        child: MaterialButton(
                          padding: EdgeInsets.zero,
                          elevation: 0,
                          focusElevation: 0,
                          hoverElevation: 0,
                          highlightElevation: 0,
                          disabledElevation: 0,
                          color: Colors.transparent,
                          shape: _useMaterial3
                              ? const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                )
                              : null,
                          onPressed: () async {
                            final List<int> savedBytes =
                                await _pdfViewerController.saveDocument();
                            _saveDocument(
                              savedBytes,
                              'The document was saved and reloaded in the viewer. Also,'
                                  ' it was saved at the location ',
                              'form.pdf',
                            );
                          },
                          child: Icon(
                            Icons.save,
                            color: _iconEnabledColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    _divider(),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Tooltip(
                        decoration: _useMaterial3
                            ? BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.inverseSurface,
                                borderRadius: BorderRadius.circular(4),
                              )
                            : null,
                        textStyle: _useMaterial3
                            ? TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onInverseSurface,
                                fontSize: 14,
                              )
                            : null,
                        padding: _useMaterial3
                            ? const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              )
                            : null,
                        constraints: _useMaterial3
                            ? const BoxConstraints(maxHeight: 48)
                            : null,
                        message: 'Import Form Data',
                        child: RawMaterialButton(
                          elevation: 0,
                          focusElevation: 0,
                          hoverElevation: 0,
                          highlightElevation: 0,
                          shape: _useMaterial3
                              ? const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                )
                              : const RoundedRectangleBorder(),
                          onPressed: () async {
                            final ByteData byteData = await rootBundle.load(
                              'assets/pdf/form_data.xfdf',
                            );
                            final List<int> formDataBytes = byteData.buffer
                                .asUint8List();
                            _pdfViewerController.importFormData(
                              formDataBytes,
                              DataFormat.xfdf,
                            );
                          },
                          child: ImageIcon(
                            const AssetImage('images/pdf_viewer/import.png'),
                            color: _iconEnabledColor,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Tooltip(
                        decoration: _useMaterial3
                            ? BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.inverseSurface,
                                borderRadius: BorderRadius.circular(4),
                              )
                            : null,
                        textStyle: _useMaterial3
                            ? TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onInverseSurface,
                                fontSize: 14,
                              )
                            : null,
                        padding: _useMaterial3
                            ? const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              )
                            : null,
                        constraints: _useMaterial3
                            ? const BoxConstraints(maxHeight: 48)
                            : null,
                        message: 'Export Form Data',
                        child: RawMaterialButton(
                          elevation: 0,
                          focusElevation: 0,
                          hoverElevation: 0,
                          highlightElevation: 0,
                          shape: _useMaterial3
                              ? const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                )
                              : const RoundedRectangleBorder(),
                          onPressed: () async {
                            final List<int> formDataBytes = _pdfViewerController
                                .exportFormData(dataFormat: DataFormat.xfdf);
                            _saveDocument(
                              formDataBytes,
                              'The exported file was saved in the location ',
                              'form.xfdf',
                            );
                          },
                          child: ImageIcon(
                            const AssetImage('images/pdf_viewer/export.png'),
                            color: _iconEnabledColor,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: _useMaterial3
            ? Theme.of(context).colorScheme.brightness == Brightness.light
                  ? const Color.fromRGBO(247, 242, 251, 1)
                  : const Color.fromRGBO(37, 35, 42, 1)
            : Theme.of(context).colorScheme.brightness == Brightness.light
            ? const Color(0xFFFAFAFA)
            : const Color(0xFF424242),
      ),
      body: SfPdfViewer.asset(
        _documentPath,
        key: _pdfViewerKey,
        controller: _pdfViewerController,
        undoController: _undoHistoryController,
      ),
    );
  }

  /// Save document
  Future<void> _saveDocument(
    List<int> dataBytes,
    String message,
    String fileName,
  ) async {
    if (kIsWeb) {
      await FileSaveHelper.saveAndLaunchFile(dataBytes, fileName);
    } else {
      final Directory directory = await getApplicationSupportDirectory();
      final String path = directory.path;
      final File file = File('$path${Platform.pathSeparator}$fileName');
      try {
        await file.writeAsBytes(dataBytes);
        _showDialog(
          'Document saved',
          message + path + Platform.pathSeparator + fileName,
        );
      } on PathAccessException catch (e) {
        _showDialog(
          'Error',
          e.osError?.message ?? 'Error in saving the document',
        );
      } catch (e) {
        _showDialog('Error', 'Error in saving the document');
      }
    }
  }

  /// Alert dialog for save and export
  void _showDialog(String title, String message) {
    showDialog<Widget>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: 328.0,
            child: Scrollbar(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                child: Text(message),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: _useMaterial3
                  ? TextButton.styleFrom(
                      fixedSize: const Size(double.infinity, 40),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                    )
                  : null,
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: VerticalDivider(
        width: 1.0,
        // width of vertical divider
        thickness: 1.0,
        // thickness of vertical divider
        indent: 12.0,
        // top indent of vertical divider
        endIndent: 12.0,
        // bottom indent of vertical divider
        color: model.themeData.colorScheme.brightness == Brightness.light
            ? Colors.black.withValues(alpha: 0.24)
            : const Color.fromRGBO(255, 255, 255, 0.26),
      ),
    );
  }
}
