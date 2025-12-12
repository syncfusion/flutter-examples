import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

/// PDF Viewer import
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../model/model.dart';
import '../../model/sample_view.dart';
import 'shared/helper.dart';
import 'shared/toolbar_widgets.dart';

/// Signature for [SearchToolbar.onTap] callback.
typedef SearchTapCallback = void Function(Object item);

/// Signature for [FileExplorer.onDocumentTap] callback.
typedef PdfDocumentTapCallback = void Function(Document document);

/// Signature for [Toolbar.onTap] callback.
typedef TapCallback = void Function(Object item);

/// Widget of [SfPdfViewer] with custom toolbar.
class CustomToolbarPdfViewer extends SampleView {
  /// Creates a [SfPdfViewer] with custom toolbar.
  const CustomToolbarPdfViewer(Key key) : super(key: key);

  @override
  _CustomToolbarPdfViewerState createState() => _CustomToolbarPdfViewerState();
}

/// State for the [SfPdfViewer] widget with custom toolbar
class _CustomToolbarPdfViewerState extends SampleViewState {
  bool _canShowPdf = false;
  bool _canShowToolbar = true;
  bool _canShowBottomToolbar = false;
  bool _canShowScrollHead = true;
  OverlayEntry? _selectionOverlayEntry;
  Color? _contextMenuColor;
  OverlayEntry? _textSearchOverlayEntry;
  OverlayEntry? _chooseFileOverlayEntry;
  OverlayEntry? _zoomPercentageOverlay;
  OverlayEntry? _settingsOverlayEntry;
  OverlayEntry? _textMarkupOverlayEntry;
  OverlayEntry? _colorPaletteOverlayEntry;
  OverlayEntry? _stickyNoteIconMenuOverlayEntry;
  LocalHistoryEntry? _historyEntry;
  bool _needToMaximize = false;
  bool _isVerticalModeSelected = true;
  bool _isContinuousModeClicked = true;
  String? _documentPath;
  PdfInteractionMode _interactionMode = PdfInteractionMode.selection;
  PdfPageLayoutMode _pageLayoutMode = PdfPageLayoutMode.continuous;
  PdfScrollDirection _scrollDirection = PdfScrollDirection.vertical;
  final FocusNode _focusNode = FocusNode()..requestFocus();
  final GlobalKey<ToolbarState> _toolbarKey = GlobalKey();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final GlobalKey<SearchToolbarState> _textSearchKey = GlobalKey();
  final GlobalKey<TextSearchOverlayState> _textSearchOverlayKey = GlobalKey();
  late bool _isLight;
  late bool _useMaterial3;
  late bool _isDesktopWeb;
  final double _kSearchOverlayWidth = 412;
  final double _kTextMarkupMenuWidth = 161.0;
  final double _kTextMarkupMenuHeight = 176.0;
  final double _kTextMarkupMenuItemHeight = 40.0;
  final double _kColorPaletteWidth = 316.0;
  final double _kColorPaletteHeight = 312.0;
  final double _kStickyNoteIconMenuWidth = 185.0;
  final double _kStickyNoteIconMenuHeight = 300.0;
  final double _kStickyNoteIconMenuItemHeight = 40.0;

  bool _canShowToast = false;
  PdfTextSelectionChangedDetails? _textSelectionDetails;
  Color? _contextMenuTextColor;
  final double _kWebContextMenuHeight = 48;
  final double _kContextMenuMargin = 10;
  final double _kMobileContextMenuHeight = 40;
  final double _kContextMenuBottom = 55;
  final double _kMobileContextMenuWidth = 270;
  final double _kWebContextMenuWidth = 225;

  Color? _fillColor;
  Orientation? _deviceOrientation;
  final TextEditingController _textFieldController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _passwordDialogFocusNode = FocusNode();
  bool _passwordVisible = true;
  String? password;
  bool _hasPasswordDialog = false;
  String _errorText = '';

  final UndoHistoryController _undoHistoryController = UndoHistoryController();
  Annotation? _selectedAnnotation;
  Color? _selectedColor;
  double _opacity = 1;

  /// Flag to indicate whether the secondary toolbar is shown or not.
  bool _canShowDesktopSecondaryToolbar = false;

  @override
  void initState() {
    super.initState();
    _documentPath = 'assets/pdf/gis_succinctly.pdf';
    _isDesktopWeb =
        isDesktop &&
        model.isMobileResolution != null &&
        !model.isMobileResolution;
  }

  @override
  void dispose() {
    super.dispose();
    _closeOverlays();
    _textFieldController.dispose();
    _pdfViewerController.dispose();
    _undoHistoryController.dispose();
    _passwordDialogFocusNode.dispose();
    _focusNode.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _useMaterial3 = model.themeData.useMaterial3;
    _isLight = model.themeData.colorScheme.brightness == Brightness.light;
    _contextMenuTextColor = _isLight
        ? const Color(0xFF000000)
        : const Color(0xFFFFFFFF);
    _contextMenuColor = _useMaterial3
        ? _isLight
              ? const Color(0xFFEEE8F4)
              : const Color(0xFF302D38)
        : _isLight
        ? const Color(0xFFFFFFFF)
        : const Color(0xFF424242);
    if (_needToMaximize != model.needToMaximize) {
      _closeOverlays();
      _needToMaximize = model.needToMaximize;
    }
    _isDesktopWeb =
        isDesktop &&
        model.isMobileResolution != null &&
        !model.isMobileResolution;
    _fillColor = _useMaterial3
        ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08)
        : _isLight
        ? const Color(0xFFE5E5E5)
        : const Color(0xFF525252);
  }

  /// Show the customized password dialog for mobile
  Future<void> _showPasswordDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final Orientation orientation = model.isMobile
            ? MediaQuery.of(context).orientation
            : Orientation.portrait;
        return _buildPasswordDialog(context, orientation);
      },
    );
  }

  /// Builds the alert dialog for password dialog.
  AlertDialog _buildPasswordDialog(
    BuildContext context,
    Orientation orientation,
  ) {
    return AlertDialog(
      scrollable: true,
      insetPadding: EdgeInsets.zero,
      contentPadding: orientation == Orientation.portrait
          ? const EdgeInsets.all(24)
          : const EdgeInsets.only(right: 24, left: 24),
      buttonPadding: orientation == Orientation.portrait
          ? const EdgeInsets.all(8)
          : const EdgeInsets.all(4),
      backgroundColor:
          Theme.of(context).colorScheme.brightness == Brightness.light
          ? Colors.white
          : const Color(0xFF424242),
      title: _passwordDialogTitle(context),
      shape: _useMaterial3
          ? null
          : const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: SizedBox(
              width: 328,
              child: _passwordDialogDescription(context, setState),
            ),
          );
        },
      ),
      actions: _passwordDialogActions(context),
    );
  }

  /// Builds the dialog title for password dialog.
  Widget _passwordDialogTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Password required',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.87),
          ),
        ),
        SizedBox(
          height: 36,
          width: 36,
          child: RawMaterialButton(
            shape: _useMaterial3
                ? const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  )
                : const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
            onPressed: () {
              _closePasswordDialog(context);
            },
            child: Icon(
              Icons.clear,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  /// Closes the password dialog
  void _closePasswordDialog(BuildContext context) {
    Navigator.pop(context, 'Cancel');
    _hasPasswordDialog = false;
    _passwordDialogFocusNode.unfocus();
    _textFieldController.clear();
  }

  /// Dialog description for password dialog.
  Widget _passwordDialogDescription(
    BuildContext context,
    StateSetter setState,
  ) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
            child: Text(
              'The document is password protected. Please enter a password',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
        Form(
          key: _formKey,
          child: TextFormField(
            obscureText: _passwordVisible,
            obscuringCharacter: '*',
            decoration: _passwordInputDecoration(context, setState),
            enableInteractiveSelection: false,
            controller: _textFieldController,
            autofocus: true,
            focusNode: _passwordDialogFocusNode,
            onFieldSubmitted: (String value) {
              _handlePasswordValidation(value);
            },
            validator: (String? value) {
              if (_errorText.isNotEmpty) {
                return _errorText;
              }
              return null;
            },
            onChanged: (String value) {
              _formKey.currentState?.validate();
              _errorText = '';
            },
          ),
        ),
      ],
    );
  }

  /// Builds the input decoration for the password dialog.
  InputDecoration _passwordInputDecoration(
    BuildContext context,
    StateSetter setState,
  ) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: model.primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: model.primaryColor),
      ),
      hintText: 'Password: syncfusion',
      hintStyle: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
      ),
      labelText: 'Enter password',
      labelStyle: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.87),
      ),
      errorStyle: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.error,
      ),
      suffixIcon: IconButton(
        icon: Icon(
          _passwordVisible ? Icons.visibility : Icons.visibility_off,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        onPressed: () {
          setState(() {
            _passwordVisible = !_passwordVisible;
          });
        },
      ),
    );
  }

  /// Actions for the password dialog
  List<Widget> _passwordDialogActions(BuildContext context) {
    return <Widget>[
      TextButton(
        onPressed: () {
          _closePasswordDialog(context);
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
        child: Text(
          'CANCEL',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: model.primaryColor,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
        child: TextButton(
          onPressed: () {
            _handlePasswordValidation(_textFieldController.text);
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
          child: Text(
            'OPEN',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: model.primaryColor,
            ),
          ),
        ),
      ),
    ];
  }

  /// Validates the password entered in text field.
  void _handlePasswordValidation(String value) {
    setState(() {
      password = value;
      _passwordDialogFocusNode.requestFocus();
    });
  }

  /// Show the customized password dialog box for web.
  Widget _showWebPasswordDialogue() {
    return Visibility(
      visible: _hasPasswordDialog,
      child: Center(
        child: Material(
          color: Colors.transparent,
          elevation: _useMaterial3 ? 10 : 0,
          child: Container(
            height: _useMaterial3 ? 213 : 200,
            width: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_useMaterial3 ? 16 : 4),
              color: _useMaterial3
                  ? _isLight
                        ? const Color.fromRGBO(238, 232, 244, 1)
                        : const Color.fromRGBO(48, 45, 56, 1)
                  : Theme.of(context).colorScheme.brightness == Brightness.light
                  ? Colors.white
                  : const Color(0xFF424242),
            ),
            child: Column(
              children: <Widget>[
                _webPasswordDialogHeader(),
                _webPasswordDialogDescription(),
                _webPasswordDialogTextField(),
                _webPasswordDialogActions(),
                if (_useMaterial3) const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Web password dialog header.
  Padding _webPasswordDialogHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 17, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Password required',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.87),
            ),
          ),
          SizedBox(
            height: 36,
            width: 36,
            child: RawMaterialButton(
              onPressed: _closeWebPasswordDialog,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_useMaterial3 ? 4 : 2),
              ),
              child: Icon(
                Icons.clear,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Web password dialog description.
  Padding _webPasswordDialogDescription() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
      child: Text(
        'The document is password protected. Please enter a password',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  /// Web password dialog text field.
  SizedBox _webPasswordDialogTextField() {
    return SizedBox(
      width: 460,
      height: 65,
      child: TextFormField(
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.87),
        ),
        obscureText: _passwordVisible,
        obscuringCharacter: '*',
        decoration: InputDecoration(
          isDense: true,
          border: _useMaterial3
              ? OutlineInputBorder(
                  borderSide: BorderSide(color: model.primaryColor),
                )
              : UnderlineInputBorder(
                  borderSide: BorderSide(color: model.primaryColor),
                ),
          focusedBorder: _useMaterial3
              ? OutlineInputBorder(
                  borderSide: BorderSide(color: model.primaryColor),
                )
              : UnderlineInputBorder(
                  borderSide: BorderSide(color: model.primaryColor),
                ),
          contentPadding: _useMaterial3
              ? const EdgeInsets.only(left: 8, top: 18)
              : const EdgeInsets.fromLTRB(0, 18, 0, 0),
          hintText: 'Password: syncfusion',
          errorText: _errorText.isNotEmpty ? _errorText : null,
          hintStyle: _webPasswordDialogintStyle(),
          errorStyle: _webPasswordDialogErrorStyle(),
          suffixIcon: _webPasswordDialogSuffixIcon(),
        ),
        enableInteractiveSelection: false,
        controller: _textFieldController,
        autofocus: true,
        focusNode: _passwordDialogFocusNode,
        textInputAction: TextInputAction.none,
        onFieldSubmitted: _handlePasswordValidation,
      ),
    );
  }

  /// Sets the password dialog form field hint text style.
  TextStyle _webPasswordDialogintStyle() {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
    );
  }

  /// Sets the password dialog form field error style.
  TextStyle _webPasswordDialogErrorStyle() {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.error,
    );
  }

  /// Sets the show password icon visibility.
  IconButton _webPasswordDialogSuffixIcon() {
    return IconButton(
      icon: Icon(
        _passwordVisible ? Icons.visibility : Icons.visibility_off,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        size: 24,
      ),
      onPressed: () {
        setState(() {
          _passwordVisible = !_passwordVisible;
        });
      },
    );
  }

  /// Build the password dialog actions.
  Padding _webPasswordDialogActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 18, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          TextButton(
            onPressed: _closeWebPasswordDialog,
            style: _useMaterial3
                ? TextButton.styleFrom(
                    fixedSize: const Size(double.infinity, 40),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                  )
                : null,
            child: Text(
              'CANCEL',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: model.primaryColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () =>
                _handlePasswordValidation(_textFieldController.text),
            style: _useMaterial3
                ? TextButton.styleFrom(
                    fixedSize: const Size(double.infinity, 40),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                  )
                : null,
            child: Text(
              'OPEN',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: model.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Handles closing the password dialog.
  void _closeWebPasswordDialog() {
    setState(() {
      _hasPasswordDialog = false;
      _passwordDialogFocusNode.unfocus();
      _textFieldController.clear();
    });
  }

  /// Show Context menu for Text Selection.
  void _showContextMenu(BuildContext context, Offset? offset) {
    final RenderBox renderBoxContainer =
        context.findRenderObject()! as RenderBox;
    if (renderBoxContainer != null) {
      const List<BoxShadow> boxShadows = <BoxShadow>[
        BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.14), blurRadius: 2),
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
      ];
      final double contextMenuHeight = _isDesktopWeb
          ? _kWebContextMenuHeight
          : _kMobileContextMenuHeight;
      final double contextMenuWidth = _isDesktopWeb
          ? _kWebContextMenuWidth
          : _kMobileContextMenuWidth;
      final Size screenSize = MediaQuery.sizeOf(context);
      final Offset containerOffset = renderBoxContainer.localToGlobal(
        renderBoxContainer.paintBounds.topLeft,
      );
      if (_canShowContextMenu(containerOffset)) {
        final Rect globalSelectedRect =
            _textSelectionDetails!.globalSelectedRegion!;
        final Offset menuPosition = _calculateContextMenuPosition(
          globalSelectedRect,
          screenSize,
          contextMenuHeight,
          contextMenuWidth,
          offset,
        );
        _showContextMenuOverlay(
          context,
          menuPosition,
          contextMenuWidth,
          contextMenuHeight,
          boxShadows,
        );
      }
    }
  }

  /// Checks if the context menu can be shown.
  bool _canShowContextMenu(Offset containerOffset) {
    return _textSelectionDetails != null &&
        _textSelectionDetails!.globalSelectedRegion != null &&
        (containerOffset.dy <
                _textSelectionDetails!.globalSelectedRegion!.topLeft.dy -
                    _kContextMenuBottom ||
            containerOffset.dy <
                _textSelectionDetails!.globalSelectedRegion!.center.dy -
                    (_kContextMenuBottom / 2));
  }

  /// Calculates the context menu position.
  Offset _calculateContextMenuPosition(
    Rect globalSelectedRect,
    Size screenSize,
    double contextMenuHeight,
    double contextMenuWidth,
    Offset? offset,
  ) {
    double top;
    double left;
    if (offset != null) {
      top = offset.dy;
      left = offset.dx;
    } else if ((globalSelectedRect.top) <= screenSize.height / 2) {
      top =
          globalSelectedRect.bottomLeft.dy +
          _kContextMenuBottom -
          _kContextMenuBottom / 2;
      left = globalSelectedRect.bottomLeft.dx;
    } else {
      top = globalSelectedRect.height > contextMenuWidth
          ? globalSelectedRect.center.dy - (contextMenuHeight / 2)
          : globalSelectedRect.topLeft.dy - _kContextMenuBottom;
      left = globalSelectedRect.height > contextMenuWidth
          ? globalSelectedRect.center.dx - (contextMenuWidth / 2)
          : globalSelectedRect.bottomLeft.dx;
    }
    if (left + contextMenuWidth > screenSize.width - _kContextMenuMargin) {
      left = screenSize.width - contextMenuWidth - _kContextMenuMargin;
    }
    if (left < _kContextMenuMargin) {
      left = _kContextMenuMargin;
    }
    return Offset(left, top);
  }

  /// Overlay of the context menu.
  void _showContextMenuOverlay(
    BuildContext context,
    Offset menuPosition,
    double contextMenuWidth,
    double contextMenuHeight,
    List<BoxShadow> boxShadows,
  ) {
    final OverlayState overlayState = Overlay.of(context, rootOverlay: true);
    _selectionOverlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        top: menuPosition.dy,
        left: menuPosition.dx,
        child: Container(
          decoration: BoxDecoration(
            color: _contextMenuColor,
            boxShadow: boxShadows,
          ),
          constraints: BoxConstraints.tightFor(
            width: contextMenuWidth,
            height: contextMenuHeight,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCopyAction(),
              _buildTextMarkUpAction(
                'Highlight',
                _isLight
                    ? 'images/pdf_viewer/highlight_light.png'
                    : 'images/pdf_viewer/highlight_dark.png',
              ),
              _buildTextMarkUpAction(
                'Underline',
                _isLight
                    ? 'images/pdf_viewer/underline_light.png'
                    : 'images/pdf_viewer/underline_dark.png',
              ),
              _buildTextMarkUpAction(
                'Strikethrough',
                _isLight
                    ? 'images/pdf_viewer/strikethrough_light.png'
                    : 'images/pdf_viewer/strikethrough_dark.png',
              ),
              _buildTextMarkUpAction(
                'Squiggly',
                _isLight
                    ? 'images/pdf_viewer/squiggly_light.png'
                    : 'images/pdf_viewer/squiggly_dark.png',
              ),
            ],
          ),
        ),
      ),
    );
    overlayState.insert(_selectionOverlayEntry!);
  }

  /// Text mark up actions for the text selection context menu.
  Widget _buildTextMarkUpAction(String name, String iconPath) {
    return Tooltip(
      message: name,
      child: IconButton(
        onPressed: () => _handleAnnotationAction(name),
        icon: ImageIcon(
          AssetImage(iconPath),
          size: _isDesktopWeb ? 17 : 15,
          color: _contextMenuTextColor,
        ),
      ),
    );
  }

  /// Copy action for the text selection context menu.
  Widget _buildCopyAction() {
    return Tooltip(
      message: 'Copy',
      child: Padding(
        padding: const EdgeInsets.only(left: 9),
        child: IconButton(
          onPressed: () async {
            _handleContextMenuClose();
            _pdfViewerController.clearSelection();
            if (_textSearchKey.currentState != null &&
                _textSearchKey.currentState!.pdfTextSearchResult.hasResult) {
              setState(() {
                _canShowToolbar = false;
              });
            }
            await Clipboard.setData(
              ClipboardData(text: _textSelectionDetails!.selectedText!),
            );
            setState(() {
              _canShowToast = true;
            });
            await Future<dynamic>.delayed(const Duration(seconds: 1));
            setState(() {
              _canShowToast = false;
            });
          },
          icon: Icon(
            Icons.copy,
            size: _isDesktopWeb ? 17 : 15,
            color: _contextMenuTextColor,
          ),
        ),
      ),
    );
  }

  /// Handles annotations actions for the text selection context menu.
  void _handleAnnotationAction(String actionType) {
    _handleContextMenuClose();
    final List<PdfTextLine>? selectedTextLines = _pdfViewerKey.currentState
        ?.getSelectedTextLines();
    if (selectedTextLines != null && selectedTextLines.isNotEmpty) {
      switch (actionType) {
        case 'Highlight':
          final HighlightAnnotation highlightAnnotation = HighlightAnnotation(
            textBoundsCollection: selectedTextLines,
          );
          _pdfViewerController.addAnnotation(highlightAnnotation);
          break;
        case 'Underline':
          final UnderlineAnnotation underlineAnnotation = UnderlineAnnotation(
            textBoundsCollection: selectedTextLines,
          );
          _pdfViewerController.addAnnotation(underlineAnnotation);
          break;
        case 'Strikethrough':
          final StrikethroughAnnotation strikethroughAnnotation =
              StrikethroughAnnotation(textBoundsCollection: selectedTextLines);
          _pdfViewerController.addAnnotation(strikethroughAnnotation);
          break;
        case 'Squiggly':
          final SquigglyAnnotation squigglyAnnotation = SquigglyAnnotation(
            textBoundsCollection: selectedTextLines,
          );
          _pdfViewerController.addAnnotation(squigglyAnnotation);
          break;
      }
    }

    _pdfViewerController.clearSelection();
  }

  /// Check and close the text selection context menu.
  void _handleContextMenuClose() {
    if (_selectionOverlayEntry != null) {
      _selectionOverlayEntry?.remove();
      _selectionOverlayEntry = null;
    }
  }

  // Closes all overlay entry.
  void _closeOverlays() {
    _handleChooseFileClose();
    _handleZoomPercentageClose();
    _handleSearchMenuClose();
    _handleContextMenuClose();
    _handleSettingsMenuClose();
    _handleTextMarkupOverlayClose();
    _handleColorPaletteOverlayClose();
    _handleStickyNoteIconOverlayClose();
    _textSearchKey.currentState?.pdfTextSearchResult.clear();
  }

  /// Ensure the entry history of text search.
  void _ensureHistoryEntry() {
    if (_historyEntry == null) {
      final ModalRoute<dynamic>? route = ModalRoute.of(context);
      if (route != null) {
        _historyEntry = LocalHistoryEntry(onRemove: _handleHistoryEntryRemoved);
        route.addLocalHistoryEntry(_historyEntry!);
      }
    }
  }

  /// Remove history entry for text search.
  void _handleHistoryEntryRemoved() {
    _textSearchKey.currentState?.pdfTextSearchResult.clear();
    _historyEntry = null;
    _canShowScrollHead = true;
  }

  /// Drop down overlay for choose file and zoom percentage.
  OverlayEntry? _showDropDownOverlay(
    RenderBox toolbarItemRenderBox,
    OverlayEntry? overlayEntry,
    BoxConstraints constraints,
    Widget dropDownItems, [
    Offset? positionOverride,
    double? borderRadius,
  ]) {
    final Offset position =
        positionOverride ?? toolbarItemRenderBox.localToGlobal(Offset.zero);
    final OverlayState overlayState = Overlay.of(context, rootOverlay: true);
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) => _buildDropDownOverlay(
        position,
        dropDownItems,
        constraints,
        borderRadius,
      ),
    );
    overlayState.insert(overlayEntry);
    return overlayEntry;
  }

  /// Builds the positioned widget for the drop down overlay.
  Positioned _buildDropDownOverlay(
    Offset position,
    Widget dropDownItems,
    BoxConstraints constraints,
    double? borderRadius,
  ) {
    return Positioned(
      top: position.dy + 40.0,
      left: _settingsOverlayEntry != null ? position.dx - 151.0 : position.dx,
      child: Container(
        decoration: BoxDecoration(
          color: _useMaterial3
              ? (_isLight
                    ? const Color.fromRGBO(238, 232, 244, 1)
                    : const Color.fromRGBO(48, 45, 56, 1))
              : (_isLight ? const Color(0xFFFFFFFF) : const Color(0xFF424242)),
          boxShadow: _useMaterial3
              ? <BoxShadow>[
                  const BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                    spreadRadius: 2,
                  ),
                  const BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.3),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ]
              : <BoxShadow>[
                  const BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.26),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
          borderRadius: _useMaterial3
              ? BorderRadius.all(Radius.circular(borderRadius ?? 4.0))
              : null,
        ),
        constraints: constraints,
        child: dropDownItems,
      ),
    );
  }

  /// Show text search menu for web platform.
  void _showTextSearchMenu() {
    if (_textSearchOverlayEntry == null) {
      _toolbarKey.currentState?._changeToolbarItemFillColor('Search', true);
      final RenderBox searchRenderBox =
          (_toolbarKey.currentState?._searchKey.currentContext
                  ?.findRenderObject())!
              as RenderBox;
      if (searchRenderBox != null) {
        final Offset position = searchRenderBox.localToGlobal(Offset.zero);
        final OverlayState overlayState = Overlay.of(
          context,
          rootOverlay: true,
        );
        overlayState.insert(
          _textSearchOverlayEntry = OverlayEntry(
            builder: (BuildContext context) {
              return Positioned(
                top: position.dy + 40.0, // y position of search menu
                left:
                    (MediaQuery.of(context).size.width - 8) -
                    _kSearchOverlayWidth, // x position of search menu
                child: TextSearchOverlay(
                  key: _textSearchOverlayKey,
                  controller: _pdfViewerController,
                  textSearchOverlayEntry: _textSearchOverlayEntry,
                  onClose: _handleSearchMenuClose,
                  brightness: model.themeData.colorScheme.brightness,
                  primaryColor: model.primaryColor,
                ),
              );
            },
          ),
        );
      }
    }
  }

  /// Close search menu for web platform.
  void _handleSearchMenuClose() {
    if (_textSearchOverlayEntry != null) {
      _toolbarKey.currentState?._changeToolbarItemFillColor('Search', false);
      _textSearchOverlayKey.currentState?.clearSearchResult();
      _textSearchOverlayEntry?.remove();
      _textSearchOverlayEntry = null;
    }
  }

  /// Shows choose file menu for selecting PDF file to be
  /// loaded in SfPdfViewer Widget. This is for web platform.
  void _showChooseFileMenu(BuildContext context) {
    _toolbarKey.currentState?._changeToolbarItemFillColor('ChooseFile', true);
    final RenderBox chooseFileRenderBox =
        (_toolbarKey.currentState?._chooseFileKey.currentContext
                ?.findRenderObject())!
            as RenderBox;
    if (chooseFileRenderBox != null) {
      final Column child = Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _chooseFileEntry('GIS Succinctly', 'assets/pdf/gis_succinctly.pdf'),
          _chooseFileEntry('HTTP Succinctly', 'assets/pdf/http_succinctly.pdf'),
          _chooseFileEntry(
            'JavaScript Succinctly',
            'assets/pdf/javascript_succinctly.pdf',
          ),
          _chooseFileEntry(
            'Rotated Document',
            'assets/pdf/rotated_document.pdf',
          ),
          _chooseFileEntry(
            'Single Page Document',
            'assets/pdf/single_page_document.pdf',
          ),
          _chooseFileEntry(
            'Encrypted Document',
            'assets/pdf/encrypted_document.pdf',
          ),
          _chooseFileEntry(
            'Corrupted Document',
            'assets/pdf/corrupted_document.pdf',
          ),
        ],
      );
      _chooseFileOverlayEntry = _showDropDownOverlay(
        chooseFileRenderBox,
        _chooseFileOverlayEntry,
        _useMaterial3
            ? BoxConstraints.tightFor(
                width: 205,
                height: child.children.length * 40.0,
              )
            : BoxConstraints.tightFor(
                width: 202,
                height: child.children.length * 35.0,
              ),
        child,
      );
    }
  }

  /// Close choose file menu for web platform.
  void _handleChooseFileClose() {
    if (_chooseFileOverlayEntry != null) {
      _toolbarKey.currentState?._changeToolbarItemFillColor(
        'ChooseFile',
        false,
      );
      _chooseFileOverlayEntry?.remove();
      _chooseFileOverlayEntry = null;
    }
  }

  /// Get choose file entry to change pdf for web platform.
  Widget _chooseFileEntry(String fileName, String path) {
    return SizedBox(
      height: _useMaterial3 ? 40 : 32, // height of each file list
      width: _useMaterial3 ? 205 : 202, // width of each file list
      child: RawMaterialButton(
        onPressed: () {
          _handleChooseFileClose();
          setState(() {
            _documentPath = path;
            _passwordVisible = true;
            password = null;
          });
        },
        shape: _useMaterial3
            ? const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              )
            : const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
        hoverColor: _useMaterial3
            ? model.themeData.colorScheme.onSurface.withValues(alpha: 0.08)
            : null,
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.01),
            child: Text(
              fileName,
              style: _useMaterial3
                  ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )
                  : TextStyle(
                      color: _isLight
                          ? const Color(0x00000000).withValues(alpha: 0.87)
                          : const Color(0x00ffffff).withValues(alpha: 0.87),
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  /// Shows drop down list of zoom levels for web platform.
  void _showZoomPercentageMenu(BuildContext context) {
    _toolbarKey.currentState?._changeToolbarItemFillColor('Zoom', true);
    final RenderBox zoomPercentageRenderBox =
        (_toolbarKey.currentState?._zoomPercentageKey.currentContext
                ?.findRenderObject())!
            as RenderBox;
    if (zoomPercentageRenderBox != null) {
      final Column child = Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _zoomPercentageDropDownItem('100%', 1),
          _zoomPercentageDropDownItem('125%', 1.25),
          _zoomPercentageDropDownItem('150%', 1.50),
          _zoomPercentageDropDownItem('200%', 2),
          _zoomPercentageDropDownItem('300%', 3),
        ],
      );
      _zoomPercentageOverlay = _showDropDownOverlay(
        zoomPercentageRenderBox,
        _zoomPercentageOverlay,
        _useMaterial3
            ? const BoxConstraints.tightFor(width: 85, height: 216)
            : const BoxConstraints.tightFor(width: 120, height: 160),
        child,
      );
    }
  }

  /// Close zoom percentage menu for web platform.
  void _handleZoomPercentageClose() {
    if (_zoomPercentageOverlay != null) {
      _toolbarKey.currentState?._changeToolbarItemFillColor('Zoom', false);
      _zoomPercentageOverlay?.remove();
      _zoomPercentageOverlay = null;
    }
  }

  /// Get zoom percentage list for web platform.
  Widget _zoomPercentageDropDownItem(String percentage, double zoomLevel) {
    return SizedBox(
      height: _useMaterial3 ? 40 : 32, // height of each percentage list
      width: _useMaterial3 ? 85 : 120, // width of each percentage list
      child: RawMaterialButton(
        onPressed: () {
          _handleZoomPercentageClose();
          setState(() {
            _pdfViewerController.zoomLevel =
                _toolbarKey.currentState!._zoomLevel = zoomLevel;
          });
        },
        shape: _useMaterial3
            ? const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              )
            : const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
        hoverColor: _useMaterial3
            ? model.themeData.colorScheme.onSurface.withValues(alpha: 0.08)
            : null,
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: _useMaterial3
                ? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0)
                : const EdgeInsets.only(left: 16.0, top: 8.0),
            child: Text(
              percentage,
              style: _useMaterial3
                  ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )
                  : TextStyle(
                      color: _toolbarKey.currentState?._textColor,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  /// Shows the page layout mode and scroll direction options
  void _showSettingsMenu(BuildContext context) {
    _toolbarKey.currentState?._changeToolbarItemFillColor('Settings', true);
    final RenderBox settingsRenderBox =
        (_toolbarKey.currentState?._settingsKey.currentContext
                ?.findRenderObject())!
            as RenderBox;
    double landscapeHeight = 180.0;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      final Offset position = settingsRenderBox.localToGlobal(Offset.zero);
      landscapeHeight =
          MediaQuery.of(context).size.height - (position.dy + 40.0);
      if (landscapeHeight > 191.0) {
        landscapeHeight = 191.0;
      }
    }
    final double totalHeight =
        MediaQuery.of(context).orientation == Orientation.landscape
        ? landscapeHeight
        : 191.0;
    if (settingsRenderBox != null) {
      _settingsOverlayEntry = _showDropDownOverlay(
        settingsRenderBox,
        _settingsOverlayEntry,
        _useMaterial3
            ? BoxConstraints.tightFor(width: 205.0, height: totalHeight)
            : BoxConstraints.tightFor(width: 191.0, height: totalHeight),
        _buildSettingsMenuOptions(),
      );
    }
  }

  /// Builds the settings menu options.
  Widget _buildSettingsMenuOptions() {
    return SingleChildScrollView(
      child: SizedBox(
        height: 191.0,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _settingsDropDownItem(
                'images/pdf_viewer/continuous_page.png',
                'Continuous Page',
                _isContinuousModeClicked,
                () {
                  _updatePageLayoutMode(PdfPageLayoutMode.continuous, true);
                  _handleSettingsMenuClose();
                },
              ),
            ),
            _settingsDropDownItem(
              'images/pdf_viewer/page_by_page.png',
              'Page by page',
              !_isContinuousModeClicked,
              () {
                _updatePageLayoutMode(PdfPageLayoutMode.single, false);
                _handleSettingsMenuClose();
              },
            ),
            Divider(
              thickness: 1,
              color: _useMaterial3
                  ? model.themeData.colorScheme.outlineVariant
                  : _isLight
                  ? Colors.black.withValues(alpha: 0.24)
                  : const Color.fromRGBO(255, 255, 255, 0.26),
            ),
            _buildSettingsMenuScrollingOptions(),
          ],
        ),
      ),
    );
  }

  /// Build the scrolling options for the setting menu.
  Widget _buildSettingsMenuScrollingOptions() {
    return Column(
      children: <Widget>[
        _settingsDropDownItem(
          'images/pdf_viewer/vertical_scrolling.png',
          'Vertical scrolling',
          _isVerticalModeSelected,
          () {
            setState(() {
              _isVerticalModeSelected = true;
              _scrollDirection = PdfScrollDirection.vertical;
            });
            _handleSettingsMenuClose();
          },
        ),
        _settingsDropDownItem(
          'images/pdf_viewer/horizontal_scrolling.png',
          'Horizontal scrolling',
          !_isVerticalModeSelected,
          () {
            setState(() {
              _isVerticalModeSelected = false;
              _scrollDirection = PdfScrollDirection.horizontal;
            });
            _handleSettingsMenuClose();
          },
        ),
      ],
    );
  }

  /// Update the page layout mode.
  void _updatePageLayoutMode(PdfPageLayoutMode mode, bool isContinuous) {
    setState(() {
      _isContinuousModeClicked = isContinuous;
      if (_pageLayoutMode != mode) {
        _pageLayoutMode = mode;
        _scrollDirection = isContinuous
            ? PdfScrollDirection.vertical
            : PdfScrollDirection.horizontal;
        _isVerticalModeSelected = isContinuous;
      }
    });
  }

  /// Close settings overlay
  void _handleSettingsMenuClose() {
    _toolbarKey.currentState?._changeToolbarItemFillColor('Settings', false);
    if (_settingsOverlayEntry != null) {
      _settingsOverlayEntry?.remove();
      _settingsOverlayEntry = null;
    }
  }

  /// Settings drop down items for both mobile and desktop.
  Widget _settingsDropDownItem(
    String imagePath,
    String mode,
    bool canShowFillColor,
    Function() onPressed,
  ) {
    return SizedBox(
      height: 40.0, // height of each Option
      width: _useMaterial3 ? 205 : 191.0, // width of each Option
      child: RawMaterialButton(
        elevation: 0.0,
        hoverElevation: 0.0,
        highlightElevation: 0.0,
        onPressed: onPressed,
        hoverColor: _useMaterial3
            ? model.themeData.colorScheme.onSurface.withValues(alpha: 0.08)
            : null,
        fillColor: canShowFillColor ? _fillColor : null,
        child: _buildSettingsDropDownItem(imagePath, mode),
      ),
    );
  }

  /// Builds settings drop down items for both mobile and desktop.
  Widget _buildSettingsDropDownItem(String imagePath, String mode) {
    return Row(
      children: [
        Padding(
          padding: _useMaterial3
              ? const EdgeInsets.only(left: 16)
              : const EdgeInsets.only(left: 19),
          child: ImageIcon(
            AssetImage(imagePath),
            size: 24,
            color: _isLight ? Colors.black : const Color(0xFFFFFFFF),
          ),
        ),
        Padding(
          padding: _useMaterial3
              ? const EdgeInsets.only(left: 12)
              : const EdgeInsets.only(left: 10),
          child: Text(
            mode,
            style: TextStyle(
              color: _useMaterial3
                  ? Theme.of(context).colorScheme.onSurfaceVariant
                  : _isLight
                  ? const Color(0x00000000).withValues(alpha: 0.87)
                  : const Color(0x00ffffff).withValues(alpha: 0.87),
              fontSize: _useMaterial3 ? 16 : 14,
              letterSpacing: _useMaterial3 ? 0.15 : null,
              fontFamily: 'Roboto',
              fontWeight: _useMaterial3 ? FontWeight.w400 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  /// Shows drop down list of text markup types for desktop.
  void _showTextMarkupMenu(BuildContext context) {
    _toolbarKey.currentState?._changeToolbarItemFillColor('Text markup', true);
    _toolbarKey.currentState?._changeToolbarItemFillColor(
      'Sticky notes',
      false,
    );
    final RenderBox textMarkupRenderBox =
        (_toolbarKey.currentState?._textMarkupKey.currentContext
                ?.findRenderObject())!
            as RenderBox;
    if (textMarkupRenderBox != null) {
      final Widget child = Container(
        width: _kTextMarkupMenuWidth,
        height: _kTextMarkupMenuHeight,
        decoration: ShapeDecoration(
          color: _contextMenuColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextMarkupMenuItem(
                'Highlight',
                PdfAnnotationMode.highlight,
              ),
              _buildTextMarkupMenuItem(
                'Underline',
                PdfAnnotationMode.underline,
              ),
              _buildTextMarkupMenuItem(
                'Strikethrough',
                PdfAnnotationMode.strikethrough,
              ),
              _buildTextMarkupMenuItem('Squiggly', PdfAnnotationMode.squiggly),
            ],
          ),
        ),
      );
      _textMarkupOverlayEntry = _showDropDownOverlay(
        textMarkupRenderBox,
        _textMarkupOverlayEntry,
        BoxConstraints.tightFor(
          width: _kTextMarkupMenuWidth,
          height: _kTextMarkupMenuHeight,
        ),
        child,
      );
    }
  }

  /// Build text markup menu items.
  Widget _buildTextMarkupMenuItem(
    String mode,
    PdfAnnotationMode annotationMode,
  ) {
    return TextMarkupMenuItem(
      mode: mode,
      height: _kTextMarkupMenuItemHeight,
      width: _kTextMarkupMenuWidth,
      model: model,
      onPressed: () {
        _pdfViewerController.annotationMode = annotationMode;
        _toolbarKey.currentState?._changeToolbarItemVisibility(
          'Color Palette',
          true,
        );
        _handleTextMarkupOverlayClose();
      },
    );
  }

  /// Close text markup menu for web platform.
  void _handleTextMarkupOverlayClose() {
    if (_textMarkupOverlayEntry != null) {
      _textMarkupOverlayEntry?.remove();
      _textMarkupOverlayEntry = null;
    }
    _toolbarKey.currentState?._changeToolbarItemFillColor(
      'Text markup',
      _pdfViewerController.annotationMode != PdfAnnotationMode.none &&
          _pdfViewerController.annotationMode != PdfAnnotationMode.stickyNote,
    );
  }

  /// Shows color palette in desktop platform.
  void _showColorPaletteMenu(BuildContext context) {
    _toolbarKey.currentState?._changeToolbarItemFillColor(
      'Color Palette',
      true,
    );
    final RenderBox colorPaletteRenderBox =
        (_toolbarKey.currentState?._colorPaletteKey.currentContext
                ?.findRenderObject())!
            as RenderBox;
    if (colorPaletteRenderBox != null) {
      final Widget child = ColorPalette(
        pdfViewerController: _pdfViewerController,
        model: model,
        selectedAnnotation: _selectedAnnotation,
        selectedColor: _selectedColor,
        selectedOpacity: _opacity,
        onColorChanged: (Color color) {
          _selectedColor = color;
        },
      );
      final Offset position = colorPaletteRenderBox.localToGlobal(
        Offset(-(_kColorPaletteWidth - colorPaletteRenderBox.size.width), 0),
      );
      _colorPaletteOverlayEntry = _showDropDownOverlay(
        colorPaletteRenderBox,
        _colorPaletteOverlayEntry,
        BoxConstraints.tightFor(
          width: _kColorPaletteWidth,
          height: _kColorPaletteHeight,
        ),
        child,
        position,
        12,
      );
    }
  }

  /// Close color palette menu for web platform.
  void _handleColorPaletteOverlayClose() {
    if (_colorPaletteOverlayEntry != null) {
      _colorPaletteOverlayEntry?.remove();
      _colorPaletteOverlayEntry = null;
    }
    _toolbarKey.currentState?._changeToolbarItemFillColor(
      'Color Palette',
      false,
    );
  }

  /// Shows the sticky note icon menu for desktop platform.
  void _showStickyNoteAnnotationMenu(BuildContext context) {
    _toolbarKey.currentState?._changeToolbarItemFillColor(
      'Sticky note icons',
      true,
    );
    final RenderBox stickyNoteMenuRenderBox =
        (_toolbarKey.currentState?._stickyNoteKey.currentContext
                ?.findRenderObject())!
            as RenderBox;
    if (stickyNoteMenuRenderBox != null) {
      final Widget child = _stickyNoteIconMenuContainer();
      _stickyNoteIconMenuOverlayEntry = _showDropDownOverlay(
        stickyNoteMenuRenderBox,
        _stickyNoteIconMenuOverlayEntry,
        BoxConstraints.tightFor(
          width: _kStickyNoteIconMenuWidth,
          height: _kStickyNoteIconMenuHeight,
        ),
        child,
      );
    }
  }

  /// Builds the sticky note menu for web platform.
  Widget _stickyNoteIconMenuContainer() {
    return Container(
      width: _kStickyNoteIconMenuWidth,
      height: _kStickyNoteIconMenuHeight,
      decoration: ShapeDecoration(
        color: _contextMenuColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _stickyNoteIconMenuItem('Note', PdfStickyNoteIcon.note),
            _stickyNoteIconMenuItem('Insert', PdfStickyNoteIcon.insert),
            _stickyNoteIconMenuItem('Comment', PdfStickyNoteIcon.comment),
            _stickyNoteIconMenuItem('Key', PdfStickyNoteIcon.key),
            _stickyNoteIconMenuItem('Help', PdfStickyNoteIcon.help),
            _stickyNoteIconMenuItem('Paragraph', PdfStickyNoteIcon.paragraph),
            _stickyNoteIconMenuItem(
              'New Paragraph',
              PdfStickyNoteIcon.newParagraph,
            ),
          ],
        ),
      ),
    );
  }

  /// Sticky note icons menu item.
  Widget _stickyNoteIconMenuItem(String name, PdfStickyNoteIcon icon) {
    return StickyNoteIconMenuItem(
      stickyNoteIconName: name,
      icon: icon,
      model: model,
      onPressed: () => _handleStickyNoteIconSelection(icon),
      height: _kStickyNoteIconMenuItemHeight,
      width: _kStickyNoteIconMenuWidth,
    );
  }

  /// Handles sticky note icon selection.
  void _handleStickyNoteIconSelection(PdfStickyNoteIcon icon) {
    if (_selectedAnnotation != null &&
        _selectedAnnotation is StickyNoteAnnotation) {
      final StickyNoteAnnotation stickyNoteAnnotation =
          _selectedAnnotation! as StickyNoteAnnotation;
      stickyNoteAnnotation.icon = icon;
    } else {
      _pdfViewerController.annotationSettings.stickyNote.icon = icon;
    }
    _handleStickyNoteIconOverlayClose();
  }

  /// Close sticky note icon menu for web platform.
  void _handleStickyNoteIconOverlayClose() {
    _toolbarKey.currentState?._changeToolbarItemFillColor(
      'Sticky note icons',
      false,
    );
    if (_stickyNoteIconMenuOverlayEntry != null) {
      _stickyNoteIconMenuOverlayEntry?.remove();
      _stickyNoteIconMenuOverlayEntry = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      final bool? isDrawerOpened = model
          .webOutputContainerState
          .widget
          .webLayoutPageState
          ?.scaffoldKey
          .currentState
          ?.isEndDrawerOpen;
      if (isDrawerOpened != null && isDrawerOpened) {
        _closeOverlays();
      }
    }
    if (model.isMobile) {
      if (_deviceOrientation != MediaQuery.of(context).orientation) {
        if (_settingsOverlayEntry != null) {
          _handleSettingsMenuClose();
          Future<dynamic>.delayed(Duration.zero, () async {
            if (!context.mounted) {
              return;
            }
            _showSettingsMenu(context);
          });
        }
        _deviceOrientation = MediaQuery.of(context).orientation;
      }
    }
    PreferredSizeWidget appBar = AppBar(
      toolbarHeight:
          (_canShowDesktopSecondaryToolbar &&
              _pdfViewerController.pageCount != 0 &&
              _isDesktopWeb)
          ? 2 * kToolbarHeight
          : kToolbarHeight,
      flexibleSpace: Semantics(
        label: 'Custom toolbar',
        child: KeyboardListener(
          focusNode: _focusNode,
          onKeyEvent: (KeyEvent event) {
            final bool isPrimaryKeyPressed = kIsMacOS
                ? HardwareKeyboard.instance.isMetaPressed
                : HardwareKeyboard.instance.isControlPressed;
            if (isPrimaryKeyPressed &&
                event.logicalKey == LogicalKeyboardKey.keyF) {
              _pdfViewerController.clearSelection();
              _showTextSearchMenu();
            }
          },
          child: Toolbar(
            key: _toolbarKey,
            controller: _pdfViewerController,
            undoHistoryController: _undoHistoryController,
            model: model,
            selectedAnnotation: _selectedAnnotation,
            showDesktopSecondaryToolbar: _canShowDesktopSecondaryToolbar,
            onTap: (Object toolbarItem) {
              if (_isDesktopWeb) {
                if (toolbarItem == 'Pan mode') {
                  setState(() {
                    if (_interactionMode == PdfInteractionMode.selection) {
                      _pdfViewerController.clearSelection();
                      _interactionMode = PdfInteractionMode.pan;
                    } else {
                      _interactionMode = PdfInteractionMode.selection;
                    }
                  });
                } else if (toolbarItem == 'Choose file') {
                  _handleSearchMenuClose();
                  if (_chooseFileOverlayEntry == null) {
                    _showChooseFileMenu(context);
                  } else {
                    _handleChooseFileClose();
                  }
                  setState(() {
                    _hasPasswordDialog = false;
                    _passwordVisible = true;
                    password = null;
                    _textFieldController.clear();
                  });
                } else if (toolbarItem == 'Zoom Percentage') {
                  _handleSearchMenuClose();
                  if (_zoomPercentageOverlay == null) {
                    _showZoomPercentageMenu(context);
                  } else {
                    _handleZoomPercentageClose();
                  }
                } else if (toolbarItem == 'Annotations') {
                  _handleSearchMenuClose();
                  _handleColorPaletteOverlayClose();
                  _handleStickyNoteIconOverlayClose();
                  setState(() {
                    _canShowDesktopSecondaryToolbar =
                        !_canShowDesktopSecondaryToolbar &&
                        _pdfViewerController.pageCount != 0;
                  });
                  if (!_canShowDesktopSecondaryToolbar &&
                      _selectedAnnotation != null) {
                    _pdfViewerController.deselectAnnotation(
                      _selectedAnnotation!,
                    );
                  }
                  _toolbarKey.currentState?._changeToolbarItemVisibility(
                    'Annotations',
                    _canShowDesktopSecondaryToolbar,
                  );
                  _toolbarKey.currentState?._changeToolbarItemFillColor(
                    'Annotations',
                    _canShowDesktopSecondaryToolbar,
                  );
                }
                if (toolbarItem.toString() == 'Bookmarks') {
                  _handleSearchMenuClose();
                  _pdfViewerKey.currentState?.openBookmarkView();
                }
                if (toolbarItem.toString() != 'Bookmarks' &&
                    _pdfViewerKey.currentState!.isBookmarkViewOpen) {
                  Navigator.pop(context);
                }
                if (toolbarItem == 'Search') {
                  _showTextSearchMenu();
                }
                if (toolbarItem != 'Choose file') {
                  _handleChooseFileClose();
                }
                if (toolbarItem != 'Zoom Percentage') {
                  _handleZoomPercentageClose();
                }

                if (toolbarItem == 'Undo') {
                  _undoHistoryController.undo();
                  if (_selectedAnnotation != null) {
                    _toolbarKey.currentState?._setAnnotationLocked(
                      _selectedAnnotation!.isLocked,
                    );
                  }
                } else if (toolbarItem == 'Redo') {
                  _undoHistoryController.redo();
                  if (_selectedAnnotation != null) {
                    _toolbarKey.currentState?._setAnnotationLocked(
                      _selectedAnnotation!.isLocked,
                    );
                  }
                }

                if (toolbarItem == 'Text markup') {
                  _handleSearchMenuClose();
                  if (_textMarkupOverlayEntry == null) {
                    _showTextMarkupMenu(context);
                  } else {
                    _handleTextMarkupOverlayClose();
                  }
                } else if (toolbarItem != 'Text markup') {
                  _handleTextMarkupOverlayClose();
                }
                if (toolbarItem == 'Sticky notes') {
                  _toolbarKey.currentState?._changeToolbarItemFillColor(
                    'Text markup',
                    false,
                  );
                  _handleStickyNoteIconOverlayClose();
                  if (_pdfViewerController.annotationMode !=
                      PdfAnnotationMode.stickyNote) {
                    _pdfViewerController.annotationMode =
                        PdfAnnotationMode.stickyNote;
                    _toolbarKey.currentState?._changeToolbarItemFillColor(
                      'Sticky notes',
                      true,
                    );
                    _toolbarKey.currentState?._changeToolbarItemVisibility(
                      'Color Palette',
                      true,
                    );
                    _toolbarKey.currentState?._changeToolbarItemVisibility(
                      'Sticky note icons',
                      true,
                    );
                    _toolbarKey.currentState?._changeToolbarItemVisibility(
                      'Lock',
                      false,
                    );
                    _toolbarKey.currentState?._changeToolbarItemVisibility(
                      'Delete',
                      false,
                    );
                  } else {
                    _pdfViewerController.annotationMode =
                        PdfAnnotationMode.none;
                    _toolbarKey.currentState?._changeToolbarItemFillColor(
                      'Sticky notes',
                      false,
                    );
                    _toolbarKey.currentState?._changeToolbarItemVisibility(
                      'Color Palette',
                      false,
                    );
                    _toolbarKey.currentState?._changeToolbarItemVisibility(
                      'Sticky note icons',
                      false,
                    );
                  }
                }
                if (toolbarItem == 'Sticky note icons') {
                  _handleSearchMenuClose();
                  if (_stickyNoteIconMenuOverlayEntry == null) {
                    if (_selectedAnnotation == null ||
                        _selectedAnnotation != null &&
                            !_selectedAnnotation!.isLocked) {
                      _showStickyNoteAnnotationMenu(context);
                    }
                  } else {
                    _handleStickyNoteIconOverlayClose();
                  }
                } else if (toolbarItem != 'Sticky notes') {
                  _handleStickyNoteIconOverlayClose();
                }
                if (toolbarItem == 'None') {
                  _pdfViewerController.annotationMode = PdfAnnotationMode.none;
                  _toolbarKey.currentState?._changeToolbarItemVisibility(
                    'Color Palette',
                    false,
                  );
                  _toolbarKey.currentState?._changeToolbarItemVisibility(
                    'Sticky note icons',
                    false,
                  );
                  _toolbarKey.currentState?._changeToolbarItemFillColor(
                    'Sticky notes',
                    false,
                  );
                  _handleTextMarkupOverlayClose();
                  _handleStickyNoteIconOverlayClose();
                }

                if (toolbarItem == 'Delete') {
                  if (_selectedAnnotation != null) {
                    _pdfViewerController.removeAnnotation(_selectedAnnotation!);
                  }
                }

                if (toolbarItem == 'Color Palette') {
                  _handleSearchMenuClose();
                  if (_colorPaletteOverlayEntry == null) {
                    if (_selectedAnnotation == null ||
                        _selectedAnnotation != null &&
                            !_selectedAnnotation!.isLocked) {
                      _showColorPaletteMenu(context);
                    }
                  } else {
                    _handleColorPaletteOverlayClose();
                  }
                } else if (toolbarItem != 'Color Palette') {
                  _handleColorPaletteOverlayClose();
                }

                if (toolbarItem == 'Lock') {
                  if (_selectedAnnotation != null) {
                    _selectedAnnotation!.isLocked =
                        !_selectedAnnotation!.isLocked;
                    _toolbarKey.currentState?._setAnnotationLocked(
                      _selectedAnnotation!.isLocked,
                    );
                  }
                }
              } else {
                if (_pdfViewerKey.currentState!.isBookmarkViewOpen) {
                  Navigator.pop(context);
                }
                if (toolbarItem is Document) {
                  setState(() {
                    _documentPath = toolbarItem.path;
                    _hasPasswordDialog = false;
                    _passwordVisible = true;
                    _textFieldController.clear();
                    password = null;
                  });
                }
                if (toolbarItem.toString() == 'Bookmarks') {
                  _pdfViewerKey.currentState?.openBookmarkView();
                } else if (toolbarItem.toString() == 'Search') {
                  setState(() {
                    _canShowToolbar = false;
                    _canShowScrollHead = false;
                    _ensureHistoryEntry();
                  });
                }
                if (toolbarItem == 'Text markup') {
                  setState(() {
                    _canShowBottomToolbar = !_canShowBottomToolbar;
                  });
                  _toolbarKey.currentState?._changeToolbarItemFillColor(
                    'Text markup',
                    _canShowBottomToolbar,
                  );
                  _toolbarKey.currentState?._changeToolbarItemFillColor(
                    'Sticky notes',
                    false,
                  );
                  if (_pdfViewerController.annotationMode !=
                      PdfAnnotationMode.none) {
                    _pdfViewerController.annotationMode =
                        PdfAnnotationMode.none;
                    _toolbarKey.currentState?._changeToolbarItemVisibility(
                      'Color Palette',
                      false,
                    );
                    _toolbarKey.currentState?._changeToolbarItemVisibility(
                      'Sticky note icons',
                      false,
                    );
                    _handleTextMarkupOverlayClose();
                  }
                }
                if (toolbarItem == 'Sticky notes') {
                  setState(() {
                    if (_pdfViewerController.annotationMode !=
                        PdfAnnotationMode.stickyNote) {
                      _canShowBottomToolbar = true;
                      _pdfViewerController.annotationMode =
                          PdfAnnotationMode.stickyNote;
                      _toolbarKey.currentState?._changeToolbarItemFillColor(
                        'Sticky notes',
                        true,
                      );
                    } else {
                      _canShowBottomToolbar = !_canShowBottomToolbar;
                      _pdfViewerController.annotationMode =
                          PdfAnnotationMode.none;
                      _toolbarKey.currentState?._changeToolbarItemFillColor(
                        'Sticky notes',
                        false,
                      );
                    }
                  });
                  _toolbarKey.currentState?._changeToolbarItemFillColor(
                    'Text markup',
                    false,
                  );
                }
              }
              if (toolbarItem.toString() == 'View settings') {
                if (_settingsOverlayEntry == null) {
                  _showSettingsMenu(context);
                } else {
                  _handleSettingsMenuClose();
                }
              }
              if (toolbarItem.toString() != 'View settings') {
                _handleSettingsMenuClose();
              }
              if (toolbarItem.toString() != 'Bookmarks') {
                _handleContextMenuClose();
              }
              if (toolbarItem != 'Jump to the page') {
                final FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.requestFocus(FocusNode());
                }
              }
            },
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
    );
    if (!_isDesktopWeb) {
      appBar = _canShowToolbar
          ? appBar
          : !_pdfViewerKey.currentState!.isBookmarkViewOpen
          ? AppBar(
              flexibleSpace: Column(
                children: [
                  Expanded(
                    child: SearchToolbar(
                      key: _textSearchKey,
                      controller: _pdfViewerController,
                      brightness: model.themeData.colorScheme.brightness,
                      primaryColor: model.primaryColor,
                      onTap: (Object toolbarItem) async {
                        if (toolbarItem.toString() == 'Cancel Search') {
                          setState(() {
                            _canShowToolbar = true;
                            _canShowScrollHead = true;
                            if (Navigator.canPop(context)) {
                              Navigator.of(context).maybePop();
                            }
                          });
                        }
                        if (toolbarItem.toString() == 'Previous Instance') {
                          setState(() {
                            _canShowToolbar = false;
                          });
                        }
                        if (toolbarItem.toString() == 'Next Instance') {
                          setState(() {
                            _canShowToolbar = false;
                          });
                        }
                        if (toolbarItem.toString() == 'Clear Text') {
                          setState(() {
                            _canShowToolbar = false;
                          });
                        }
                        if (toolbarItem.toString() == 'Search Completed') {
                          setState(() {});
                        }
                        if (toolbarItem.toString() == 'noResultFound') {
                          setState(() {
                            _textSearchKey.currentState?.canShowToast = true;
                          });
                          await Future<dynamic>.delayed(
                            const Duration(seconds: 1),
                          );
                          setState(() {
                            _textSearchKey.currentState?.canShowToast = false;
                          });
                        }
                      },
                    ),
                  ),
                  // Progress bar to indicate whether search process is completed or not.
                  Visibility(
                    visible:
                        _textSearchKey.currentState != null &&
                        !_textSearchKey
                            .currentState!
                            .pdfTextSearchResult
                            .isSearchCompleted &&
                        _textSearchKey.currentState!.isSearchInitiated,
                    child: LinearProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              automaticallyImplyLeading: false,
              backgroundColor: _useMaterial3
                  ? Theme.of(context).colorScheme.brightness == Brightness.light
                        ? const Color.fromRGBO(247, 242, 251, 1)
                        : const Color.fromRGBO(37, 35, 42, 1)
                  : Theme.of(context).colorScheme.brightness == Brightness.light
                  ? const Color(0xFFFAFAFA)
                  : const Color(0xFF424242),
            )
          : PreferredSize(preferredSize: Size.zero, child: Container());
    }
    return Scaffold(
      appBar: appBar,
      // ignore: always_specify_types
      body: FutureBuilder(
        future: Future<dynamic>.delayed(const Duration(milliseconds: 200)).then(
          (dynamic value) {
            _canShowPdf = true;
          },
        ),
        builder: (BuildContext context, AsyncSnapshot<Object?> snapshot) {
          final Widget pdfViewer = Listener(
            onPointerDown: (PointerDownEvent details) {
              if (_isDesktopWeb) {
                _handleChooseFileClose();
                _handleZoomPercentageClose();
                _handleTextMarkupOverlayClose();
                _handleColorPaletteOverlayClose();
                _handleStickyNoteIconOverlayClose();
              }
              _handleSettingsMenuClose();
              _textSearchKey.currentState?.focusNode!.unfocus();
              _focusNode.unfocus();
            },
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: !_isDesktopWeb && _canShowBottomToolbar ? 56 : 0,
                  child: SfPdfViewer.asset(
                    _documentPath!,
                    key: _pdfViewerKey,
                    canShowTextSelectionMenu: false,
                    controller: _pdfViewerController,
                    undoController: _undoHistoryController,
                    interactionMode: _interactionMode,
                    scrollDirection: _scrollDirection,
                    pageLayoutMode: _pageLayoutMode,
                    password: password,
                    canShowPasswordDialog: false,
                    canShowScrollHead:
                        // ignore: avoid_bool_literals_in_conditional_expressions
                        isDesktop ? false : _canShowScrollHead,
                    onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                      if (_hasPasswordDialog) {
                        if (model.isMobile) {
                          Navigator.pop(context);
                        }
                        _hasPasswordDialog = false;
                        _passwordDialogFocusNode.unfocus();
                        _textFieldController.clear();
                      }
                      _toolbarKey.currentState?.documentChanged();
                    },
                    onTextSelectionChanged:
                        (PdfTextSelectionChangedDetails details) async {
                          if (details.selectedText == null &&
                              _selectionOverlayEntry != null) {
                            _textSelectionDetails = null;
                            _handleContextMenuClose();
                          } else if (details.selectedText != null &&
                              _selectionOverlayEntry == null) {
                            _textSelectionDetails = details;
                            _showContextMenu(context, null);
                          }
                        },
                    onDocumentLoadFailed:
                        (PdfDocumentLoadFailedDetails details) {
                          setState(() {
                            _canShowDesktopSecondaryToolbar = false;
                          });
                          _toolbarKey.currentState?.documentChanged();
                          if (details.description.contains('password')) {
                            if (details.description.contains('password') &&
                                _hasPasswordDialog) {
                              _errorText = 'Invalid password';
                              _formKey.currentState?.validate();
                              _textFieldController.clear();
                              _passwordDialogFocusNode.requestFocus();
                            } else {
                              _errorText = '';
                              if (model.isMobile) {
                                _showPasswordDialog();
                                _passwordDialogFocusNode.requestFocus();
                                _hasPasswordDialog = true;
                              } else {
                                setState(() {
                                  _hasPasswordDialog = true;
                                  if (!_passwordDialogFocusNode.hasFocus) {
                                    _passwordDialogFocusNode.requestFocus();
                                  }
                                });
                              }
                            }
                          } else {
                            showErrorDialog(
                              context,
                              details.error,
                              details.description,
                            );
                          }
                        },
                    onAnnotationEdited: (Annotation annotation) {
                      _selectedColor = annotation.color;
                      _opacity = annotation.opacity;
                    },
                    onAnnotationSelected: (Annotation annotation) {
                      _selectedAnnotation = annotation;
                      _selectedColor = annotation.color;
                      _opacity = annotation.opacity;
                      _pdfViewerController.annotationMode =
                          PdfAnnotationMode.none;
                      if (_isDesktopWeb) {
                        _toolbarKey.currentState?._changeToolbarItemFillColor(
                          'Text Markup',
                          false,
                        );
                        _toolbarKey.currentState?._changeToolbarItemFillColor(
                          'Sticky notes',
                          false,
                        );
                        _toolbarKey.currentState?._setAnnotationLocked(
                          annotation.isLocked,
                        );
                        _toolbarKey.currentState?._changeToolbarItemVisibility(
                          'Lock',
                          true,
                        );
                        _toolbarKey.currentState?._changeToolbarItemVisibility(
                          'Delete',
                          true,
                        );
                        _toolbarKey.currentState?._changeToolbarItemVisibility(
                          'Annotations',
                          true,
                        );
                        _toolbarKey.currentState?._changeToolbarItemFillColor(
                          'Annotations',
                          true,
                        );
                        _toolbarKey.currentState?._changeToolbarItemVisibility(
                          'Color Palette',
                          true,
                        );
                        if (_selectedAnnotation is StickyNoteAnnotation) {
                          _toolbarKey.currentState
                              ?._changeToolbarItemVisibility(
                                'Sticky note icons',
                                true,
                              );
                        }
                        setState(() {
                          _canShowDesktopSecondaryToolbar =
                              _pdfViewerController.pageCount != 0;
                        });
                      } else {
                        setState(() {
                          _canShowBottomToolbar = true;
                          _toolbarKey.currentState?._changeToolbarItemFillColor(
                            'Sticky notes',
                            false,
                          );
                        });
                      }
                    },
                    onAnnotationDeselected: (Annotation annotation) {
                      _selectedAnnotation = null;
                      _selectedColor = null;
                      setState(() {
                        _canShowDesktopSecondaryToolbar =
                            _pdfViewerController.annotationMode !=
                                PdfAnnotationMode.none &&
                            _pdfViewerController.pageCount != 0;
                      });
                      if (_isDesktopWeb) {
                        _toolbarKey.currentState?._changeToolbarItemVisibility(
                          'Lock',
                          false,
                        );
                        _toolbarKey.currentState?._changeToolbarItemVisibility(
                          'Delete',
                          false,
                        );
                        _toolbarKey.currentState?._changeToolbarItemVisibility(
                          'Color Palette',
                          false,
                        );
                        _toolbarKey.currentState?._changeToolbarItemVisibility(
                          'Sticky note icons',
                          false,
                        );
                        _toolbarKey.currentState?._changeToolbarItemFillColor(
                          'Sticky notes',
                          false,
                        );
                        _toolbarKey.currentState?._changeToolbarItemFillColor(
                          'Text markup',
                          false,
                        );
                        _toolbarKey.currentState?._changeToolbarItemVisibility(
                          'Annotations',
                          _canShowDesktopSecondaryToolbar,
                        );
                        _toolbarKey.currentState?._changeToolbarItemFillColor(
                          'Annotations',
                          _canShowDesktopSecondaryToolbar,
                        );
                      } else {
                        setState(() {
                          _canShowBottomToolbar = false;
                        });
                        _toolbarKey.currentState?._changeToolbarItemFillColor(
                          'Text markup',
                          false,
                        );
                      }
                    },
                  ),
                ),
                if (!_isDesktopWeb && _canShowBottomToolbar)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: BottomToolbar(
                      pdfViewerController: _pdfViewerController,
                      undoController: _undoHistoryController,
                      model: model,
                      showStickyNoteIcon: false,
                      showAddTextMarkupToolbar:
                          _pdfViewerController.annotationMode ==
                              PdfAnnotationMode.stickyNote
                          ? true
                          : false,
                      selectedAnnotation: _selectedAnnotation,
                      onBackButtonPressed: () {
                        if (_selectedAnnotation != null) {
                          _pdfViewerController.deselectAnnotation(
                            _selectedAnnotation!,
                          );
                        }
                      },
                    ),
                  ),
              ],
            ),
          );
          if (_canShowPdf) {
            if (_isDesktopWeb) {
              return Stack(
                children: <Widget>[
                  KeyboardListener(
                    focusNode: _focusNode,
                    onKeyEvent: (KeyEvent event) {
                      final bool isPrimaryKeyPressed = kIsMacOS
                          ? HardwareKeyboard.instance.isMetaPressed
                          : HardwareKeyboard.instance.isControlPressed;
                      if (isPrimaryKeyPressed &&
                          event.logicalKey == LogicalKeyboardKey.keyF) {
                        _showTextSearchMenu();
                      }
                    },
                    child: GestureDetector(
                      onSecondaryTapDown: (TapDownDetails details) {
                        if (_textSelectionDetails != null &&
                            _textSelectionDetails!.globalSelectedRegion !=
                                null &&
                            _textSelectionDetails!.globalSelectedRegion!
                                .contains(details.globalPosition)) {
                          if (_selectionOverlayEntry != null) {
                            _handleContextMenuClose();
                            _showContextMenu(context, details.globalPosition);
                          } else if (_selectionOverlayEntry == null) {
                            _showContextMenu(context, details.globalPosition);
                          }
                        }
                      },
                      child: pdfViewer,
                    ),
                  ),
                  showToast(
                    context,
                    _canShowToast,
                    Alignment.bottomCenter,
                    'Copied',
                  ),
                  _showWebPasswordDialogue(),
                ],
              );
            }
            return SfPdfViewerTheme(
              data: const SfPdfViewerThemeData(),
              child: PopScope(
                onPopInvokedWithResult: (bool value, Object? result) async {
                  setState(() {
                    _canShowToolbar = true;
                  });
                },
                child: Stack(
                  children: <Widget>[
                    pdfViewer,
                    showToast(
                      context,
                      _textSearchKey.currentState?.canShowToast ?? false,
                      Alignment.center,
                      'No result',
                    ),
                    showToast(
                      context,
                      _canShowToast,
                      Alignment.bottomCenter,
                      'Copied',
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container(
              color:
                  SfPdfViewerTheme.of(context)!.backgroundColor ??
                  Theme.of(context).colorScheme.surface.withValues(alpha: 0.08),
            );
          }
        },
      ),
    );
  }
}

/// Toolbar widget
class Toolbar extends StatefulWidget {
  ///it describe top toolbar constructor
  const Toolbar({
    this.controller,
    this.undoHistoryController,
    this.onTap,
    this.showTooltip = true,
    this.model,
    this.showDesktopSecondaryToolbar = false,
    Key? key,
    this.selectedAnnotation,
  }) : super(key: key);

  /// Indicates whether tooltip for the toolbar items need to be shown or not..
  final bool showTooltip;

  /// An object that is used to control the [SfPdfViewer].
  final PdfViewerController? controller;

  /// An object that is used to control the Undo History of the SfPdfViewer.
  final UndoHistoryController? undoHistoryController;

  /// Called when the toolbar item is selected.
  final TapCallback? onTap;

  /// Sample model of the entire SB.
  final SampleModel? model;

  /// The selected annotation.
  final Annotation? selectedAnnotation;

  /// Indicates whether the annotation toolbar need to be shown or not
  final bool showDesktopSecondaryToolbar;

  @override
  ToolbarState createState() => ToolbarState();
}

/// State for the Toolbar widget
class ToolbarState extends State<Toolbar> {
  Color? _color;
  Color? _disabledColor;
  Color? _textColor;
  Color? _fillColor;
  Color? _panFillColor;
  Color? _chooseFileFillColor;
  Color? _zoomFillColor;
  Color? _searchFillColor;
  Color? _settingsFillColor;
  Color? _stickyNoteAnnotationFillColor = Colors.transparent;
  Color? _stickyNoteIconMenuFillColor = Colors.transparent;
  Color _textMarkupFillColor = Colors.transparent;
  Color? _annotationsIconFillColor;
  Color? _colorPaletteFillColor;
  int _pageCount = 0;
  late bool _isLight;
  double _zoomLevel = 1;
  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _chooseFileKey = GlobalKey();
  final GlobalKey _zoomPercentageKey = GlobalKey();
  final GlobalKey _settingsKey = GlobalKey();
  final GlobalKey _textMarkupKey = GlobalKey();
  final GlobalKey _colorPaletteKey = GlobalKey();
  final GlobalKey _stickyNoteKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();
  bool _isWeb = false;

  bool _canShowColorPaletteIcon = false;
  bool _canShowStickyNoteIconMenu = false;
  bool _canShowDeleteIcon = false;
  bool _canShowLockIcon = false;
  bool _isAnnotationLocked = false;
  late bool _useMaterial3;

  /// An object that is used to control the Text Field.
  TextEditingController? _textEditingController;

  @override
  void initState() {
    widget.controller?.addListener(_pageChanged);
    _textEditingController = TextEditingController(
      text: widget.controller!.pageNumber.toString(),
    );
    _pageCount = widget.controller!.pageCount;
    super.initState();
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_pageChanged);
    super.dispose();
  }

  /// Called when the page changes and updates the page number text field.
  void _pageChanged({String? property}) {
    if (super.mounted) {
      if (_isWeb && _zoomLevel != widget.controller!.zoomLevel) {
        setState(() {
          _zoomLevel = widget.controller!.zoomLevel;
        });
      }
      if (widget.controller?.pageCount != null &&
          _pageCount != widget.controller!.pageCount) {
        _pageCount = widget.controller!.pageCount;
        setState(() {});
      }
      if (widget.controller?.pageNumber != null &&
          _textEditingController!.text !=
              widget.controller!.pageNumber.toString()) {
        Future<dynamic>.delayed(Duration.zero, () {
          _textEditingController!.text = widget.controller!.pageNumber
              .toString();
          setState(() {});
        });
      }
    }
  }

  /// Resets the annotations toolbar items on document change
  void documentChanged() {
    setState(() {
      _annotationsIconFillColor =
          widget.controller != null &&
              widget.controller!.pageCount != 0 &&
              widget.showDesktopSecondaryToolbar
          ? _fillColor
          : null;
      _textMarkupFillColor = Colors.transparent;
      _colorPaletteFillColor = null;
      _stickyNoteIconMenuFillColor = null;
      _stickyNoteAnnotationFillColor = null;
      _canShowColorPaletteIcon = false;
      _canShowDeleteIcon = false;
      _canShowLockIcon = false;
      _canShowStickyNoteIconMenu = false;
    });
  }

  @override
  void didChangeDependencies() {
    _isLight = Theme.of(context).brightness == Brightness.light;
    _useMaterial3 = Theme.of(context).useMaterial3;
    _color = _useMaterial3
        ? Theme.of(context).brightness == Brightness.light
              ? const Color.fromRGBO(73, 69, 79, 1)
              : const Color.fromRGBO(202, 196, 208, 1)
        : Theme.of(context).brightness == Brightness.light
        ? Colors.black.withValues(alpha: 0.54)
        : Colors.white.withValues(alpha: 0.65);
    _disabledColor = _useMaterial3
        ? Theme.of(context).brightness == Brightness.light
              ? const Color.fromRGBO(28, 27, 31, 1).withValues(alpha: 0.38)
              : const Color.fromRGBO(230, 225, 229, 1).withValues(alpha: 0.38)
        : Theme.of(context).brightness == Brightness.light
        ? Colors.black12
        : Colors.white12;
    _textColor = _isLight
        ? const Color(0x00000000).withValues(alpha: 0.87)
        : const Color(0x00ffffff).withValues(alpha: 0.87);
    _fillColor = _useMaterial3
        ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08)
        : _isLight
        ? const Color(0xFFD2D2D2)
        : const Color(0xFF525252);
    _isWeb =
        isDesktop && widget.model != null && !widget.model!.isMobileResolution;
    super.didChangeDependencies();
  }

  /// Changes the drop down fill colors while drop down is opened or closed.
  void _changeToolbarItemFillColor(String toolbarItem, bool isFocused) {
    setState(() {
      if (toolbarItem == 'ChooseFile') {
        _chooseFileFillColor = isFocused ? _fillColor : null;
      } else if (toolbarItem == 'Zoom') {
        _zoomFillColor = isFocused ? _fillColor : null;
      } else if (toolbarItem == 'Search') {
        _searchFillColor = isFocused ? _fillColor : null;
      } else if (toolbarItem == 'Settings') {
        _settingsFillColor = isFocused ? _fillColor : null;
      } else if (toolbarItem == 'Text markup') {
        _textMarkupFillColor = isFocused ? _fillColor! : Colors.transparent;
      } else if (toolbarItem == 'Color Palette') {
        _colorPaletteFillColor = isFocused ? _fillColor : null;
      } else if (toolbarItem == 'Sticky note icons') {
        _stickyNoteIconMenuFillColor = isFocused ? _fillColor : null;
      } else if (toolbarItem == 'Sticky notes') {
        _stickyNoteAnnotationFillColor = isFocused
            ? _fillColor
            : Colors.transparent;
      } else if (toolbarItem == 'Annotations') {
        _annotationsIconFillColor = isFocused ? _fillColor : Colors.transparent;
      }
    });
  }

  /// Sets the locked status of the selected annotation.
  void _setAnnotationLocked(bool isLocked) {
    setState(() {
      _isAnnotationLocked = isLocked;
    });
  }

  /// Changes the visibility of the toolbar items.
  void _changeToolbarItemVisibility(String toolbarItem, bool isVisible) {
    setState(() {
      if (toolbarItem == 'Color Palette') {
        _canShowColorPaletteIcon = isVisible;
      } else if (toolbarItem == 'Delete') {
        _canShowDeleteIcon = isVisible;
      } else if (toolbarItem == 'Lock') {
        _canShowLockIcon = isVisible;
      } else if (toolbarItem == 'Sticky note icons') {
        _canShowStickyNoteIconMenu = isVisible;
      }
    });
  }

  /// Constructs web toolbar item widget
  Widget _webToolbarItem(String toolTip, Widget child, {Key? key}) {
    return Padding(
      padding:
          toolTip == 'Bookmark' ||
              toolTip == 'Search' ||
              toolTip == 'View settings' ||
              toolTip == 'Lock' ||
              toolTip == 'Unlock'
          ? const EdgeInsets.only(right: 8)
          : const EdgeInsets.only(left: 8),
      child: Tooltip(
        message: toolTip,
        decoration: _useMaterial3
            ? BoxDecoration(
                color: Theme.of(context).colorScheme.inverseSurface,
                borderRadius: BorderRadius.circular(4),
              )
            : null,
        textStyle: _useMaterial3
            ? TextStyle(
                color: Theme.of(context).colorScheme.onInverseSurface,
                fontSize: 14,
              )
            : null,
        padding: _useMaterial3
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 14)
            : null,
        constraints: _useMaterial3 ? const BoxConstraints(maxHeight: 48) : null,
        child: SizedBox(
          key: key,
          height: 40,
          width:
              toolTip == 'Choose file' ||
                  toolTip == 'Text markup' ||
                  toolTip == 'Sticky note icons'
              ? (_useMaterial3 ? 56 : 50)
              : 40,
          child: child,
        ),
      ),
    );
  }

  Widget _webToolbarButton({
    required Widget child,
    required void Function()? onPressed,
    Color? fillColor,
    double elevation = 0,
    double focusElevation = 0,
    double hoverElevation = 0,
    double highlightElevation = 0,
    Color? hoverColor,
    required bool useMaterial3,
    required BuildContext context,
  }) {
    return RawMaterialButton(
      fillColor: fillColor,
      elevation: elevation,
      focusElevation: focusElevation,
      hoverElevation: hoverElevation,
      highlightElevation: highlightElevation,
      onPressed: onPressed,
      hoverColor:
          hoverColor ??
          (useMaterial3
              ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08)
              : null),
      shape: useMaterial3
          ? const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            )
          : const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
      child: child,
    );
  }

  /// Constructs the toolbar divider
  Widget _groupDivider(bool isPaddingLeft) {
    return Padding(
      padding: isPaddingLeft
          ? const EdgeInsets.only(left: 8)
          : const EdgeInsets.only(right: 8),
      child: VerticalDivider(
        width: 1.0,
        // width of vertical divider
        thickness: 1.0,
        // thickness of vertical divider
        indent: _useMaterial3 ? 16 : 12.0,
        // top indent of vertical divider
        endIndent: _useMaterial3 ? 16 : 12.0,
        // bottom indent of vertical divider
        color: _useMaterial3
            ? Theme.of(context).colorScheme.outlineVariant
            : _isLight
            ? Colors.black.withValues(alpha: 0.24)
            : const Color.fromRGBO(255, 255, 255, 0.26),
      ),
    );
  }

  /// Annotations toolbar
  Widget _webSecondaryToolbar() {
    return Container(
      height: kToolbarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: _buildToolbarDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // SizedBox is added to align the toolbar items at the center
          const SizedBox.square(dimension: 24),
          Row(
            children: [
              _buildTextMarkupItem(),
              _buildStickyNotesItem(),
              _buildVisibilityDivider(
                _canShowColorPaletteIcon && !_isAnnotationLocked,
              ),
              _buildColorPaletteItem(),
              _buildStickyNoteIconsItem(),
              _buildVisibilityDivider(_canShowDeleteIcon || _canShowLockIcon),
              _buildDeleteItem(),
              _buildLockItem(),
            ],
          ),
          _buildCloseItem(),
        ],
      ),
    );
  }

  BoxDecoration _buildToolbarDecoration() {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: _useMaterial3
              ? Theme.of(context).colorScheme.outlineVariant
              : _isLight
              ? Colors.black.withAlpha(0x24)
              : const Color.fromRGBO(255, 255, 255, 0.26),
        ),
      ),
    );
  }

  Widget _buildTextMarkupItem() {
    return _webToolbarItem(
      'Text markup',
      _webToolbarButton(
        child: SplitButton(
          height: 36,
          width: 56,
          onPrimaryButtonPressed: () {
            if (widget.controller!.annotationMode != PdfAnnotationMode.none) {
              widget.onTap?.call('None');
            } else {
              widget.onTap?.call('Text markup');
            }
          },
          onSecondaryButtonPressed: () {
            widget.onTap?.call('Text markup');
          },
          child: _textMarkupAnnotationIcon(widget.controller!.annotationMode),
        ),
        onPressed: () {
          widget.onTap?.call('Text markup');
        },
        fillColor: _textMarkupFillColor,
        useMaterial3: _useMaterial3,
        context: context,
      ),
      key: _textMarkupKey,
    );
  }

  Widget _buildStickyNotesItem() {
    return _webToolbarItem(
      'Sticky notes',
      _webToolbarButton(
        context: context,
        useMaterial3: _useMaterial3,
        fillColor: _stickyNoteAnnotationFillColor,
        onPressed: widget.controller!.pageNumber != 0
            ? () {
                widget.onTap?.call('Sticky notes');
              }
            : null,
        child: _stickyNoteIcon(),
      ),
    );
  }

  Widget _buildColorPaletteItem() {
    return Visibility(
      visible: _canShowColorPaletteIcon && !_isAnnotationLocked,
      child: _webToolbarItem(
        'Color Palette',
        _webToolbarButton(
          child: ImageIcon(
            const AssetImage('images/pdf_viewer/color_palette.png'),
            size: 17,
            color: _isLight ? Colors.black : const Color(0xFFFFFFFF),
          ),
          onPressed: widget.controller!.pageNumber != 0
              ? () {
                  widget.onTap?.call('Color Palette');
                }
              : null,
          fillColor: _colorPaletteFillColor,
          useMaterial3: _useMaterial3,
          context: context,
        ),
        key: _colorPaletteKey,
      ),
    );
  }

  Widget _buildStickyNoteIconsItem() {
    return Visibility(
      visible: _canShowStickyNoteIconMenu && !_isAnnotationLocked,
      child: _webToolbarItem(
        'Sticky note icons',
        _webToolbarButton(
          child: SplitButton(
            height: 36,
            width: 56,
            onPrimaryButtonPressed: () {
              widget.onTap?.call('Sticky note icon menu');
            },
            onSecondaryButtonPressed: () {
              widget.onTap?.call('Sticky note icons');
            },
            child: _stickyNoteIcon(),
          ),
          onPressed: widget.controller!.pageNumber != 0
              ? () {
                  widget.onTap?.call('Sticky note icons');
                }
              : null,
          fillColor: _stickyNoteIconMenuFillColor,
          useMaterial3: _useMaterial3,
          context: context,
        ),
        key: _stickyNoteKey,
      ),
    );
  }

  Widget _buildDeleteItem() {
    return Visibility(
      visible: _canShowDeleteIcon && !_isAnnotationLocked,
      child: _webToolbarItem(
        'Delete',
        _webToolbarButton(
          child: ImageIcon(
            const AssetImage('images/pdf_viewer/delete.png'),
            size: 17,
            color: _isLight ? Colors.black : const Color(0xFFFFFFFF),
          ),
          onPressed: () {
            widget.onTap?.call('Delete');
          },
          useMaterial3: _useMaterial3,
          context: context,
        ),
      ),
    );
  }

  Widget _buildLockItem() {
    return Visibility(
      visible: _canShowLockIcon,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: _webToolbarItem(
          _isAnnotationLocked ? 'Unlock' : 'Lock',
          _webToolbarButton(
            child: ImageIcon(
              AssetImage(
                _isAnnotationLocked
                    ? 'images/pdf_viewer/unlocked.png'
                    : 'images/pdf_viewer/locked.png',
              ),
              size: 18,
              color: widget.controller!.pageNumber != 0
                  ? (_isLight ? Colors.black : const Color(0xFFFFFFFF))
                  : _disabledColor,
            ),
            onPressed: widget.controller!.pageNumber != 0
                ? () {
                    widget.onTap?.call('Lock');
                  }
                : null,
            useMaterial3: _useMaterial3,
            context: context,
          ),
        ),
      ),
    );
  }

  Widget _buildCloseItem() {
    return _webToolbarItem(
      'Close',
      _webToolbarButton(
        child: Icon(
          Icons.close,
          color: widget.controller!.pageCount != 0 ? _color : _disabledColor,
        ),
        onPressed: () {
          setState(() {
            _annotationsIconFillColor = null;
          });
          widget.onTap?.call('Annotations');
        },
        useMaterial3: _useMaterial3,
        context: context,
      ),
    );
  }

  Widget _buildVisibilityDivider(bool visible) {
    return Visibility(visible: visible, child: _groupDivider(true));
  }

  /// Get custom toolbar for web platform.
  Widget _webToolbar(bool canJumpToPreviousPage, bool canJumpToNextPage) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        return AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          toolbarHeight:
              (widget.showDesktopSecondaryToolbar &&
                  widget.controller?.pageCount != 0)
              ? 2 * kToolbarHeight
              : kToolbarHeight,
          backgroundColor: _useMaterial3
              ? Theme.of(context).colorScheme.brightness == Brightness.light
                    ? const Color.fromRGBO(247, 242, 251, 1)
                    : const Color.fromRGBO(37, 35, 42, 1)
              : Theme.of(context).colorScheme.brightness == Brightness.light
              ? const Color(0xFFFAFAFA)
              : const Color(0xFF424242),
          flexibleSpace: Container(
            height: kToolbarHeight,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: _useMaterial3
                      ? Theme.of(context).colorScheme.outlineVariant
                      : _isLight
                      ? Colors.black.withValues(alpha: 0.24)
                      : const Color.fromRGBO(255, 255, 255, 0.26),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    // Choose file drop down
                    _webToolbarItem(
                      'Choose file',
                      _webToolbarButton(
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Icon(
                                Icons.folder_open,
                                color: _color,
                                size: _useMaterial3 ? 24 : 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: _color,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                        fillColor: _chooseFileFillColor,
                        onPressed: () {
                          widget.onTap?.call('Choose file');
                        },
                        useMaterial3: _useMaterial3,
                        context: context,
                      ),
                      key: _chooseFileKey,
                    ),
                    _groupDivider(true),
                    _webToolbarItem(
                      'Undo',
                      ValueListenableBuilder<UndoHistoryValue>(
                        valueListenable: widget.undoHistoryController!,
                        builder:
                            (
                              BuildContext context,
                              UndoHistoryValue value,
                              Widget? child,
                            ) {
                              return _webToolbarButton(
                                child: Icon(
                                  Icons.undo,
                                  color: value.canUndo
                                      ? _color
                                      : _disabledColor,
                                  size: 20,
                                ),
                                onPressed: value.canUndo
                                    ? () {
                                        widget.onTap?.call('Undo');
                                      }
                                    : null,
                                useMaterial3: _useMaterial3,
                                context: context,
                              );
                            },
                      ),
                    ),
                    _webToolbarItem(
                      'Redo',
                      ValueListenableBuilder<UndoHistoryValue>(
                        valueListenable: widget.undoHistoryController!,
                        builder:
                            (
                              BuildContext context,
                              UndoHistoryValue value,
                              Widget? child,
                            ) {
                              return _webToolbarButton(
                                child: Icon(
                                  Icons.redo,
                                  color: value.canRedo
                                      ? _color
                                      : _disabledColor,
                                  size: 20,
                                ),
                                onPressed: value.canRedo
                                    ? () {
                                        widget.onTap?.call('Redo');
                                      }
                                    : null,
                                useMaterial3: _useMaterial3,
                                context: context,
                              );
                            },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    // Text field for page number
                    Padding(
                      padding: _useMaterial3
                          ? EdgeInsets.zero
                          : const EdgeInsets.only(top: 4.0),
                      child: SizedBox(
                        height: _useMaterial3 ? 40 : 20, // height of text field
                        width: _useMaterial3 ? 54 : 48, // width of text field
                        child: paginationTextField(context),
                      ),
                    ),
                    // Total page count
                    Padding(
                      padding: EdgeInsets.only(
                        left: 6.0,
                        right: width < 800 ? 6.0 : 0,
                      ),
                      child: Text(
                        _useMaterial3
                            ? '/  ${widget.controller!.pageCount}'
                            : 'of  ${widget.controller!.pageCount}',
                        style: TextStyle(
                          color: _textColor,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Roboto',
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (width > 800) ...[
                      // Previous page button
                      _webToolbarItem(
                        'Previous page',
                        _webToolbarButton(
                          child: Icon(
                            _useMaterial3
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_left,
                            color: canJumpToPreviousPage
                                ? _color
                                : _disabledColor,
                            size: _useMaterial3 ? 24 : 20,
                          ),
                          onPressed: canJumpToPreviousPage
                              ? () {
                                  widget.onTap?.call('Previous Page');
                                  widget.controller?.previousPage();
                                }
                              : null,
                          useMaterial3: _useMaterial3,
                          context: context,
                        ),
                      ),
                      // Next page button
                      _webToolbarItem(
                        'Next page',
                        _webToolbarButton(
                          child: Icon(
                            _useMaterial3
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_right,
                            color: canJumpToNextPage ? _color : _disabledColor,
                            size: _useMaterial3 ? 24 : 21,
                          ),
                          onPressed: canJumpToNextPage
                              ? () {
                                  widget.onTap?.call('Next Page');
                                  widget.controller?.nextPage();
                                }
                              : null,
                          useMaterial3: _useMaterial3,
                          context: context,
                        ),
                      ),
                    ],
                    // Group divider
                    _groupDivider(true),
                    if (width > 800)
                      // Zoom level drop down
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                          key: _zoomPercentageKey,
                          height: 36, // height of zoom percentage menu
                          width: 72, // width of zoom percentage menu
                          child: _webToolbarButton(
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 7.0),
                                  child: Text(
                                    widget.controller!.pageNumber == 0
                                        ? '0%'
                                        : '${(_zoomLevel * 100).floor()}%',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Roboto',
                                      fontStyle: FontStyle.normal,
                                      color: _textColor,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: widget.controller!.pageNumber != 0
                                        ? _color
                                        : _disabledColor,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: widget.controller!.pageNumber != 0
                                ? () {
                                    widget.onTap?.call('Zoom Percentage');
                                  }
                                : null,
                            fillColor: _zoomFillColor,
                            useMaterial3: _useMaterial3,
                            context: context,
                          ),
                        ),
                      ),
                    // Zoom out button
                    _webToolbarItem(
                      'Zoom out',
                      _webToolbarButton(
                        child: Icon(
                          _useMaterial3
                              ? Icons.zoom_out
                              : Icons.remove_circle_outline,
                          color:
                              widget.controller!.pageCount != 0 &&
                                  _zoomLevel > 1
                              ? _color
                              : _disabledColor,
                          size: _useMaterial3 ? 24 : 20,
                        ),
                        onPressed:
                            widget.controller!.pageCount != 0 && _zoomLevel > 1
                            ? () {
                                widget.onTap?.call('Zoom Out');
                                setState(() {
                                  if (_zoomLevel > 1.0 && _zoomLevel <= 1.25) {
                                    _zoomLevel = 1.0;
                                  } else if (_zoomLevel > 1.25 &&
                                      _zoomLevel <= 1.50) {
                                    _zoomLevel = 1.25;
                                  } else if (_zoomLevel > 1.50 &&
                                      _zoomLevel <= 2.0) {
                                    _zoomLevel = 1.50;
                                  } else {
                                    _zoomLevel = 2.0;
                                  }
                                  widget.controller!.zoomLevel = _zoomLevel;
                                });
                              }
                            : null,
                        useMaterial3: _useMaterial3,
                        context: context,
                      ),
                    ),
                    // Zoom in button
                    _webToolbarItem(
                      'Zoom in',
                      _webToolbarButton(
                        child: Icon(
                          _useMaterial3
                              ? Icons.zoom_in
                              : Icons.add_circle_outline,
                          color:
                              widget.controller!.pageCount != 0 &&
                                  _zoomLevel < 3
                              ? _color
                              : _disabledColor,
                          size: _useMaterial3 ? 24 : 20,
                        ),
                        onPressed:
                            widget.controller!.pageCount != 0 && _zoomLevel < 3
                            ? () {
                                widget.onTap?.call('Zoom In');
                                setState(() {
                                  if (_zoomLevel >= 1.0 && _zoomLevel < 1.25) {
                                    _zoomLevel = 1.25;
                                  } else if (_zoomLevel >= 1.25 &&
                                      _zoomLevel < 1.50) {
                                    _zoomLevel = 1.50;
                                  } else if (_zoomLevel >= 1.50 &&
                                      _zoomLevel < 2.0) {
                                    _zoomLevel = 2.0;
                                  } else {
                                    _zoomLevel = 3.0;
                                  }
                                  widget.controller!.zoomLevel = _zoomLevel;
                                });
                              }
                            : null,
                        useMaterial3: _useMaterial3,
                        context: context,
                      ),
                    ),
                    // Group divider
                    _groupDivider(true),
                    if (width > 800)
                      // Pan mode toggle button
                      _webToolbarItem(
                        'Pan mode',
                        _webToolbarButton(
                          child: Icon(
                            Icons.pan_tool_rounded,
                            color: widget.controller!.pageCount != 0
                                ? _color
                                : _disabledColor,
                            size: _useMaterial3 ? 24 : 20,
                          ),
                          onPressed: widget.controller!.pageNumber != 0
                              ? () {
                                  setState(() {
                                    if (_panFillColor ==
                                            const Color(0xFFD2D2D2) ||
                                        _panFillColor ==
                                            const Color(0xFF525252) ||
                                        _panFillColor ==
                                            Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.08)) {
                                      _panFillColor = null;
                                    } else {
                                      _panFillColor = _fillColor;
                                    }
                                  });
                                  widget.onTap?.call('Pan mode');
                                }
                              : null,
                          fillColor: _panFillColor,
                          useMaterial3: _useMaterial3,
                          context: context,
                        ),
                      ),
                    _webToolbarItem(
                      'Annotations',
                      _webToolbarButton(
                        child: Icon(
                          Icons.draw,
                          color: widget.controller!.pageCount != 0
                              ? _color
                              : _disabledColor,
                          size: _useMaterial3 ? 24 : 20,
                        ),
                        onPressed: widget.controller!.pageNumber != 0
                            ? () {
                                widget.onTap?.call('Annotations');
                              }
                            : null,
                        fillColor: _annotationsIconFillColor,
                        useMaterial3: _useMaterial3,
                        context: context,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    // View settings button
                    _webToolbarItem(
                      'View settings',
                      _webToolbarButton(
                        child: Icon(
                          Icons.settings,
                          color: widget.controller!.pageCount != 0
                              ? _color
                              : _disabledColor,
                          size: 20,
                        ),
                        onPressed: widget.controller!.pageNumber != 0
                            ? () {
                                widget.controller!.clearSelection();
                                widget.onTap?.call('View settings');
                              }
                            : null,
                        fillColor: _settingsFillColor,
                        useMaterial3: _useMaterial3,
                        context: context,
                      ),
                      key: _settingsKey,
                    ),
                    // Bookmark button
                    _webToolbarItem(
                      'Bookmark',
                      _webToolbarButton(
                        child: Icon(
                          Icons.bookmark_border,
                          color: widget.controller!.pageCount != 0
                              ? _color
                              : _disabledColor,
                          size: _useMaterial3 ? 24 : 20,
                        ),
                        onPressed: widget.controller!.pageNumber != 0
                            ? () {
                                widget.onTap?.call('Bookmarks');
                              }
                            : null,
                        useMaterial3: _useMaterial3,
                        context: context,
                      ),
                    ),
                    // Group divider
                    _groupDivider(false),
                    // Search button
                    _webToolbarItem(
                      'Search',
                      _webToolbarButton(
                        child: Icon(
                          Icons.search,
                          color: widget.controller!.pageCount != 0
                              ? _color
                              : _disabledColor,
                          size: _useMaterial3 ? 24 : 20,
                        ),
                        onPressed: widget.controller!.pageNumber != 0
                            ? () {
                                widget.controller!.clearSelection();
                                widget.onTap?.call('Search');
                              }
                            : null,
                        fillColor: _searchFillColor,
                        useMaterial3: _useMaterial3,
                        context: context,
                      ),
                      key: _searchKey,
                    ),
                  ],
                ),
              ],
            ),
          ),
          bottom:
              widget.showDesktopSecondaryToolbar &&
                  widget.controller?.pageCount != 0
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: _webSecondaryToolbar(),
                )
              : null,
        );
      },
    );
  }

  /// Get the annotation icon based on the annotation mode.
  ImageIcon _textMarkupAnnotationIcon(PdfAnnotationMode mode) {
    String iconPath = '';
    double iconSize = 16;
    switch (mode) {
      case PdfAnnotationMode.none:
      case PdfAnnotationMode.stickyNote:
        iconPath = _isLight
            ? 'images/pdf_viewer/textmarkup_group_light.png'
            : 'images/pdf_viewer/textmarkup_group_dark.png';
        iconSize = isDesktop ? 30 : 18;
        break;
      case PdfAnnotationMode.highlight:
        iconPath = _isLight
            ? 'images/pdf_viewer/highlight_light.png'
            : 'images/pdf_viewer/highlight_dark.png';
        iconSize = 18;
        break;
      case PdfAnnotationMode.strikethrough:
        iconPath = _isLight
            ? 'images/pdf_viewer/strikethrough_light.png'
            : 'images/pdf_viewer/strikethrough_dark.png';
        iconSize = 18;
        break;
      case PdfAnnotationMode.underline:
        iconPath = _isLight
            ? 'images/pdf_viewer/underline_light.png'
            : 'images/pdf_viewer/underline_dark.png';
        iconSize = 18;
        break;
      case PdfAnnotationMode.squiggly:
        iconPath = _isLight
            ? 'images/pdf_viewer/squiggly_light.png'
            : 'images/pdf_viewer/squiggly_dark.png';
        iconSize = 18;
        break;
    }

    return ImageIcon(AssetImage(iconPath), size: iconSize, color: _textColor);
  }

  /// Get the sticky note icon for the sticky note annotation mode.
  ImageIcon _stickyNoteIcon() {
    return _isLight
        ? ImageIcon(
            const AssetImage('images/pdf_viewer/note_light.png'),
            size: 18,
            color: _textColor,
          )
        : ImageIcon(
            const AssetImage('images/pdf_viewer/note_dark.png'),
            size: 18,
            color: _textColor,
          );
  }

  /// Pagination text field widget.
  Widget paginationTextField(BuildContext context) {
    return TextField(
      style: _isWeb
          ? TextStyle(
              color: _textColor,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              fontFamily: 'Roboto',
              fontSize: 14,
            )
          : TextStyle(color: _color),
      enableInteractiveSelection: false,
      keyboardType: TextInputType.number,
      controller: _textEditingController,
      textAlign: TextAlign.center,
      maxLength: _isWeb ? 4 : 3,
      focusNode: _focusNode,
      decoration: _paginationTextFieldInputDecoration(context),
      enabled: widget.controller!.pageCount > 0,
      onTap: _paginationTextFieldOnPageNumberFieldTap,
      onSubmitted: (String text) => _focusNode.unfocus(),
      onEditingComplete: () => _paginationTextFieldOnEditingComplete(context),
    );
  }

  /// Input decoration for the pagination text field.
  InputDecoration _paginationTextFieldInputDecoration(BuildContext context) {
    return InputDecoration(
      counterText: '',
      contentPadding: _isWeb
          ? const EdgeInsets.only(bottom: 22)
          : isDesktop
          ? const EdgeInsets.only(bottom: 20)
          : null,
      border: _useMaterial3
          ? OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.38),
              ),
            )
          : const UnderlineInputBorder(),
      enabledBorder: _useMaterial3
          ? OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.38),
              ),
            )
          : null,
      focusedBorder: _useMaterial3
          ? OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.38),
              ),
            )
          : UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2.0,
              ),
            ),
    );
  }

  /// Pagination text field on page number field tap.
  void _paginationTextFieldOnPageNumberFieldTap() {
    if (widget.controller!.pageCount > 0) {
      _textEditingController!.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _textEditingController!.value.text.length,
      );
      _focusNode.requestFocus();
      widget.onTap?.call('Jump to the page');
    }
  }

  /// Pagination text field on editing complete.
  void _paginationTextFieldOnEditingComplete(BuildContext context) {
    final String str = _textEditingController!.text;
    if (str != widget.controller!.pageNumber.toString()) {
      try {
        final int index = int.parse(str);
        if (index > 0 && index <= widget.controller!.pageCount) {
          widget.controller?.jumpToPage(index);
          FocusScope.of(context).requestFocus(FocusNode());
          widget.onTap?.call('Navigated');
        } else {
          _textEditingController!.text = widget.controller!.pageNumber
              .toString();
          showErrorDialog(
            context,
            'Error',
            'Please enter a valid page number.',
          );
        }
      } catch (exception) {
        showErrorDialog(context, 'Error', 'Please enter a valid page number.');
      }
    }
    widget.onTap?.call('Navigated');
  }

  @override
  Widget build(BuildContext context) {
    final bool canJumpToPreviousPage = widget.controller!.pageNumber > 1;
    final bool canJumpToNextPage =
        widget.controller!.pageNumber < widget.controller!.pageCount;
    if (_isWeb) {
      return _webToolbar(canJumpToPreviousPage, canJumpToNextPage);
    } else {
      return GestureDetector(
        onTap: () {
          widget.onTap?.call('Toolbar');
        },
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          height: 56, // height of toolbar for mobile platform
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Choose file button.
              ToolbarItem(
                height: 40, // height of file explorer button
                width: 40, // width of file explorer button
                child: Material(
                  color: Colors.transparent,
                  child: Tooltip(
                    message: widget.showTooltip ? 'Choose file' : null,
                    child: RawMaterialButton(
                      shape: _useMaterial3
                          ? RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            )
                          : RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                      onPressed: () async {
                        widget.onTap?.call('File Explorer');
                        widget.controller!.clearSelection();
                        await Future<dynamic>.delayed(
                          const Duration(milliseconds: 50),
                        );
                        if (!mounted || !context.mounted) {
                          return;
                        }
                        await Navigator.of(context).push<dynamic>(
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => FileExplorer(
                              brightness: Theme.of(context).brightness,
                              onDocumentTap: (Document document) {
                                widget.onTap?.call(document);
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop(context);
                              },
                            ),
                          ),
                        );
                      },
                      child: Icon(Icons.folder_open, color: _color, size: 24),
                    ),
                  ),
                ),
              ),

              ToolbarItem(
                width: 40,
                height: 40,
                child: Tooltip(
                  message: widget.showTooltip ? 'Undo' : null,
                  child: ValueListenableBuilder<UndoHistoryValue>(
                    valueListenable: widget.undoHistoryController!,
                    builder:
                        (
                          BuildContext context,
                          UndoHistoryValue value,
                          Widget? child,
                        ) {
                          return Material(
                            color: Colors.transparent,
                            child: RawMaterialButton(
                              shape: _useMaterial3
                                  ? RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    )
                                  : RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                              onPressed: value.canUndo
                                  ? widget.undoHistoryController!.undo
                                  : null,
                              child: Icon(
                                Icons.undo,
                                color: value.canUndo ? _color : _disabledColor,
                                size: 20,
                              ),
                            ),
                          );
                        },
                  ),
                ),
              ),
              ToolbarItem(
                width: 40,
                height: 40,
                child: Tooltip(
                  message: widget.showTooltip ? 'Redo' : null,
                  child: ValueListenableBuilder<UndoHistoryValue>(
                    valueListenable: widget.undoHistoryController!,
                    builder:
                        (
                          BuildContext context,
                          UndoHistoryValue value,
                          Widget? child,
                        ) {
                          return Material(
                            color: Colors.transparent,
                            child: RawMaterialButton(
                              shape: _useMaterial3
                                  ? RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    )
                                  : RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                              onPressed: value.canRedo
                                  ? widget.undoHistoryController!.redo
                                  : null,
                              child: Icon(
                                Icons.redo,
                                color: value.canRedo ? _color : _disabledColor,
                                size: 20,
                              ),
                            ),
                          );
                        },
                  ),
                ),
              ),

              // Text markup button
              ToolbarItem(
                height: 40,
                width: 40,
                child: Tooltip(
                  message: widget.showTooltip ? 'Text markup' : null,
                  child: Material(
                    color: _textMarkupFillColor,
                    child: RawMaterialButton(
                      onPressed: () {
                        widget.onTap?.call('Text markup');
                      },
                      shape: _useMaterial3
                          ? RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            )
                          : RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                      child: ImageIcon(
                        _isLight
                            ? const AssetImage(
                                'images/pdf_viewer/textmarkup_group_light.png',
                              )
                            : const AssetImage(
                                'images/pdf_viewer/textmarkup_group_dark.png',
                              ),
                        color: _textColor,
                        size: 19,
                      ),
                    ),
                  ),
                ),
              ),
              ToolbarItem(
                height: 40,
                width: 40,
                child: Tooltip(
                  message: widget.showTooltip ? 'Sticky notes' : null,
                  child: Material(
                    color: _stickyNoteAnnotationFillColor,
                    child: RawMaterialButton(
                      onPressed: () {
                        widget.onTap?.call('Sticky notes');
                      },
                      shape: _useMaterial3
                          ? RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            )
                          : RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                      child: _stickyNoteIcon(),
                    ),
                  ),
                ),
              ),
              ToolbarItem(
                height: 40, // height of bookmark button
                width: 40, // width of bookmark button
                child: Material(
                  color: Colors.transparent,
                  child: Tooltip(
                    message: widget.showTooltip ? 'Bookmarks' : null,
                    child: RawMaterialButton(
                      shape: _useMaterial3
                          ? RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            )
                          : RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                      onPressed: widget.controller!.pageNumber == 0
                          ? null
                          : () {
                              _textEditingController!.selection =
                                  const TextSelection(
                                    baseOffset: -1,
                                    extentOffset: -1,
                                  );
                              widget.onTap?.call('Bookmarks');
                            },
                      child: Icon(
                        Icons.bookmark,
                        color: widget.controller!.pageNumber == 0
                            ? Colors.black12
                            : _color,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
              // Search button
              ToolbarItem(
                height: 40, // height of search button
                width: 40, // width of search button
                child: Material(
                  color: Colors.transparent,
                  child: Tooltip(
                    message: widget.showTooltip ? 'Search' : null,
                    child: RawMaterialButton(
                      shape: _useMaterial3
                          ? RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            )
                          : RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                      onPressed: widget.controller!.pageNumber == 0
                          ? null
                          : () {
                              widget.controller!.clearSelection();
                              widget.onTap?.call('Search');
                            },
                      child: Icon(
                        Icons.search,
                        color: widget.controller!.pageNumber == 0
                            ? Colors.black12
                            : _color,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
              // View settings button
              ToolbarItem(
                height: 40, // height of View settings button
                width: 40,
                key: _settingsKey, // width of View settings button
                child: Material(
                  color: Colors.transparent,
                  child: Tooltip(
                    message: widget.showTooltip ? 'View settings' : null,
                    child: RawMaterialButton(
                      shape: _useMaterial3
                          ? RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            )
                          : RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                      onPressed: widget.controller!.pageNumber == 0
                          ? null
                          : () {
                              widget.controller!.clearSelection();
                              widget.onTap?.call('View settings');
                            },
                      child: Icon(
                        Icons.settings,
                        color: widget.controller!.pageNumber == 0
                            ? Colors.black12
                            : _color,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

/// Text Selection menu item widget
class TextMarkupMenuItem extends StatefulWidget {
  /// Constructor for text selection menu item widget
  const TextMarkupMenuItem({
    required this.mode,
    this.model,
    required this.onPressed,
    required this.height,
    required this.width,
    super.key,
  });

  /// Indicates the text markup annotation mode.
  final String mode;

  /// Called when the menu item is selected.
  final VoidCallback onPressed;

  /// Height of the menu item.
  final double height;

  /// Width of the menu item.
  final double width;

  /// Sample model of the entire SB.
  final SampleModel? model;

  @override
  State<TextMarkupMenuItem> createState() => _TextMarkupMenuItemState();
}

class _TextMarkupMenuItemState extends State<TextMarkupMenuItem> {
  Color? _textColor;
  late bool _useMaterial3;

  @override
  void didChangeDependencies() {
    _useMaterial3 = Theme.of(context).useMaterial3;
    _textColor = _useMaterial3
        ? widget.model?.themeData.colorScheme.onSurfaceVariant
        : (widget.model?.themeData.brightness == Brightness.light)
        ? Colors.black.withValues(alpha: 0.87)
        : Colors.white;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: RawMaterialButton(
        onPressed: widget.onPressed,
        padding: const EdgeInsets.only(left: 16.0, top: 10.0, bottom: 10.0),
        hoverColor: _useMaterial3
            ? widget.model?.themeData.colorScheme.onSurface.withValues(
                alpha: 0.08,
              )
            : (widget.model?.themeData.colorScheme.brightness ==
                  Brightness.light)
            ? Colors.grey.withValues(alpha: 0.2)
            : Colors.grey.withValues(alpha: 0.5),
        child: Row(
          children: <Widget>[
            Image(
              image:
                  widget.model?.themeData.colorScheme.brightness ==
                      Brightness.light
                  ? AssetImage(
                      'images/pdf_viewer/${widget.mode.toLowerCase()}_light.png',
                    )
                  : AssetImage(
                      'images/pdf_viewer/${widget.mode.toLowerCase()}_dark.png',
                    ),
              width: 16,
              height: 16,
              color: _textColor,
            ),
            const Divider(indent: 12),
            Text(
              widget.mode,
              style: TextStyle(
                color:
                    (widget.model?.themeData.colorScheme.brightness ==
                        Brightness.light)
                    ? Colors.black.withValues(alpha: 0.87)
                    : Colors.white,
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                letterSpacing: 0.25,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sticky note icons menu item widget.
class StickyNoteIconMenuItem extends StatefulWidget {
  /// Constructor for Sticky note icons menu item widget.
  const StickyNoteIconMenuItem({
    required this.stickyNoteIconName,
    required this.icon,
    this.model,
    required this.onPressed,
    required this.height,
    required this.width,
    super.key,
  });

  /// Name of the icon.
  final String stickyNoteIconName;

  /// Icon of the menu item.
  final PdfStickyNoteIcon icon;

  /// Called when the menu item is selected.
  final VoidCallback onPressed;

  /// Height of the menu item.
  final double height;

  /// Width of the menu item.
  final double width;

  /// Sample model of the entire SB.
  final SampleModel? model;

  @override
  State<StickyNoteIconMenuItem> createState() => _StickyNoteIconMenuItemState();
}

class _StickyNoteIconMenuItemState extends State<StickyNoteIconMenuItem> {
  Color? _textColor;
  late bool _useMaterial3;

  @override
  void didChangeDependencies() {
    _useMaterial3 = Theme.of(context).useMaterial3;
    _textColor = _useMaterial3
        ? widget.model?.themeData.colorScheme.onSurfaceVariant
        : (widget.model?.themeData.brightness == Brightness.light)
        ? Colors.black.withValues(alpha: 0.87)
        : Colors.white;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: RawMaterialButton(
        onPressed: widget.onPressed,
        padding: const EdgeInsets.only(left: 16.0, top: 10.0, bottom: 10.0),
        hoverColor: _useMaterial3
            ? widget.model?.themeData.colorScheme.onSurface.withValues(
                alpha: 0.08,
              )
            : (widget.model?.themeData.colorScheme.brightness ==
                  Brightness.light)
            ? Colors.grey.withValues(alpha: 0.2)
            : Colors.grey.withValues(alpha: 0.5),
        child: Row(
          children: <Widget>[
            Image(
              image:
                  widget.model?.themeData.colorScheme.brightness ==
                      Brightness.light
                  ? AssetImage(
                      'images/pdf_viewer/${_stickyNoteIconFileName()}_light.png',
                    )
                  : AssetImage(
                      'images/pdf_viewer/${_stickyNoteIconFileName()}_dark.png',
                    ),
              width: 16,
              height: 16,
              color: _textColor,
            ),
            const Divider(indent: 12),
            Text(
              widget.stickyNoteIconName,
              style: TextStyle(
                color:
                    (widget.model?.themeData.colorScheme.brightness ==
                        Brightness.light)
                    ? Colors.black.withValues(alpha: 0.87)
                    : Colors.white,
                fontSize: 15.5,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                letterSpacing: 0.25,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Sticky note icon file name.
  String _stickyNoteIconFileName() {
    if (widget.stickyNoteIconName.toLowerCase() == 'new paragraph') {
      return 'new_paragraph';
    }
    return widget.stickyNoteIconName.toLowerCase();
  }
}
