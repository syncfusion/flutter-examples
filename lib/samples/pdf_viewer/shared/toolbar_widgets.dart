import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_examples/samples/pdf_viewer/shared/helper.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../pdf_viewer_custom_toolbar.dart';

/// File Explorer widget for mobile
class FileExplorer extends StatefulWidget {
  /// Creates a File Explorer
  const FileExplorer({this.brightness, this.onDocumentTap});

  /// Brightness theme for the file explorer.
  final Brightness? brightness;

  /// Called when the document is selected.
  final PdfDocumentTapCallback? onDocumentTap;

  @override
  FileExplorerState createState() => FileExplorerState();
}

/// State for the File Explorer widget
class FileExplorerState extends State<FileExplorer> {
  Color? _foregroundColor;
  Color? _backgroundColor;
  late bool _isLight;
  final List<Document> _documents = <Document>[
    Document('GIS Succinctly', 'assets/pdf/gis_succinctly.pdf'),
    Document('HTTP Succinctly', 'assets/pdf/http_succinctly.pdf'),
    Document('JavaScript Succinctly', 'assets/pdf/javascript_succinctly.pdf'),
    Document('Single Page Document', 'assets/pdf/single_page_document.pdf'),
    Document('Corrupted Document', 'assets/pdf/corrupted_document.pdf')
  ];

  @override
  void didChangeDependencies() {
    _isLight = widget.brightness == Brightness.light;
    _backgroundColor =
        _isLight ? const Color(0xFFFAFAFA) : const Color(0xFF424242);
    _foregroundColor = _isLight ? Colors.black : Colors.white;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Choose File', style: TextStyle(color: _foregroundColor)),
          backgroundColor: _backgroundColor,
        ),
        body: Container(
          color: _isLight ? Colors.white : const Color(0xFF212121),
          child: ListView.builder(
              itemCount: _documents.length,
              itemBuilder: (BuildContext context, int index) {
                final Document document = _documents[index];
                return ListTile(
                  title: Text(document.name,
                      style: TextStyle(color: _foregroundColor, fontSize: 14)),
                  leading: Icon(Icons.picture_as_pdf, color: _foregroundColor),
                  onTap: () {
                    widget.onDocumentTap!(document);
                  },
                );
              }),
        ));
  }
}

/// SearchToolbar widget
class SearchToolbar extends StatefulWidget {
  ///it describe search toolbar constructor
  const SearchToolbar({
    this.controller,
    this.onTap,
    this.canShowTooltip = true,
    this.brightness,
    this.primaryColor,
    Key? key,
  }) : super(key: key);

  /// Indicates whether tooltip for the search toolbar items need to be shown or not.
  final bool canShowTooltip;

  /// An object that is used to control the [SfPdfViewer].
  final PdfViewerController? controller;

  /// Called when the search toolbar item is selected.
  final SearchTapCallback? onTap;

  /// Brightness theme for text search overlay.
  final Brightness? brightness;

  /// Palette color for text search overlay.
  final Color? primaryColor;

  @override
  SearchToolbarState createState() => SearchToolbarState();
}

/// State for the SearchToolbar widget
class SearchToolbarState extends State<SearchToolbar> {
  int _searchTextLength = 0;
  Color? _color;
  Color? _textColor;
  late bool _isLight;

  /// Indicates whether search toolbar items need to be shown or not.
  bool _canShowItem = false;

  /// Indicates whether search toast need to be shown or not.
  bool canShowToast = false;

  ///An object that is used to retrieve the current value of the TextField.
  final TextEditingController _editingController = TextEditingController();

  /// An object that is used to retrieve the text search result.
  PdfTextSearchResult pdfTextSearchResult = PdfTextSearchResult();

  ///An object that is used to obtain keyboard focus and to handle keyboard events.
  FocusNode? focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode?.requestFocus();
  }

  @override
  void dispose() {
    focusNode?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _isLight = widget.brightness == Brightness.light;
    _color = _isLight
        ? const Color(0x00000000).withOpacity(0.87)
        : const Color(0x00ffffff).withOpacity(0.87);
    _textColor = _isLight
        ? const Color.fromRGBO(0, 0, 0, 0.54).withOpacity(0.87)
        : const Color(0x00ffffff).withOpacity(0.54);
    super.didChangeDependencies();
  }

  /// Display the Alert Dialog to search from the beginning
  void _showSearchAlertDialog(BuildContext context) {
    showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Search Result',
                style: TextStyle(
                    color: _color,
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    decoration: TextDecoration.none),
              ),
              Container(
                height: 36, // height of close search menu button
                width: 36, // width of close search menu button
                child: RawMaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.clear,
                    color: _isLight
                        ? const Color.fromRGBO(0, 0, 0, 0.54)
                        : const Color.fromRGBO(255, 255, 255, 0.65),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor:
              _isLight ? const Color(0xFFFFFFFF) : const Color(0xFF424242),
          content: Container(
              width: 328,
              child: Text(
                'No more occurrences found. Would you like to continue to search from the beginning?',
                style: TextStyle(
                    color: _color,
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    decoration: TextDecoration.none),
              )),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                pdfTextSearchResult.clear();
                _editingController.clear();
                _canShowItem = false;
                focusNode?.requestFocus();
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                primary: Colors.transparent,
              ),
              child: Text(
                'NO',
                style: TextStyle(
                    color: widget.primaryColor,
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    decoration: TextDecoration.none),
              ),
            ),
            TextButton(
              onPressed: () {
                pdfTextSearchResult.nextInstance();
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                primary: Colors.transparent,
              ),
              child: Text(
                'YES',
                style: TextStyle(
                    color: widget.primaryColor,
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    decoration: TextDecoration.none),
              ),
            ),
          ],
          actionsPadding: const EdgeInsets.only(bottom: 10),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56, // height of search toolbar
      child: Row(
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: IconButton(
              // Back button to navigate to the main toolbar.
              icon: Icon(
                Icons.arrow_back,
                color: _isLight
                    ? const Color(0x00000000).withOpacity(0.54)
                    : const Color(0x00ffffff).withOpacity(0.54),
                size: 24,
              ),
              onPressed: () {
                widget.onTap?.call('Cancel Search');
                _editingController.clear();
                pdfTextSearchResult.clear();
              },
            ),
          ),
          // Search input text field
          Flexible(
            child: TextFormField(
              style: TextStyle(
                  color: _color,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Roboto',
                  fontStyle: FontStyle.normal,
                  fontSize: 16),
              enableInteractiveSelection: false,
              focusNode: focusNode,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              controller: _editingController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Find...',
                hintStyle: TextStyle(
                    color: _isLight
                        ? const Color(0x00000000).withOpacity(0.34)
                        : const Color(0x00ffffff).withOpacity(0.54),
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.normal,
                    fontSize: 16),
              ),
              onChanged: (String text) {
                if (_searchTextLength < _editingController.value.text.length) {
                  setState(() {});
                  _searchTextLength = _editingController.value.text.length;
                }
                if (_editingController.value.text.length < _searchTextLength) {
                  setState(() {
                    _canShowItem = false;
                  });
                }
              },
              onFieldSubmitted: (String value) async {
                pdfTextSearchResult = await widget.controller!
                    .searchText(_editingController.text);
                if (pdfTextSearchResult.totalInstanceCount == 0) {
                  widget.onTap?.call('noResultFound');
                } else {
                  _canShowItem = true;
                }
              },
            ),
          ),
          // Cancel search.
          Visibility(
            visible: _editingController.text.isNotEmpty,
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                icon: Icon(
                  Icons.clear,
                  size: 24,
                  color: _isLight
                      ? const Color.fromRGBO(0, 0, 0, 0.54)
                      : const Color.fromRGBO(255, 255, 255, 0.65),
                ),
                onPressed: () {
                  setState(() {
                    _editingController.clear();
                    pdfTextSearchResult.clear();
                    widget.controller!.clearSelection();
                    _canShowItem = false;
                    focusNode?.requestFocus();
                  });
                  widget.onTap?.call('Clear Text');
                },
                tooltip: widget.canShowTooltip ? 'Clear Text' : null,
              ),
            ),
          ),
          // Search result
          Visibility(
            visible: _canShowItem,
            child: Row(
              children: <Widget>[
                // Current instance
                Text(
                  '${pdfTextSearchResult.currentInstanceIndex}',
                  style: TextStyle(
                      color: _textColor,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.normal,
                      fontSize: 12),
                ),
                // `Of` label
                Text(
                  ' of ',
                  style: TextStyle(
                      color: _textColor,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.normal,
                      fontSize: 12),
                ),
                // Total search instance count
                Text(
                  '${pdfTextSearchResult.totalInstanceCount}',
                  style: TextStyle(
                      color: _textColor,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.normal,
                      fontSize: 12),
                ),
                // Navigate to previous search instance.
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: Icon(
                      Icons.navigate_before,
                      color: _isLight
                          ? const Color.fromRGBO(0, 0, 0, 0.54)
                          : const Color.fromRGBO(255, 255, 255, 0.65),
                      size: 24,
                    ),
                    onPressed: () {
                      setState(() {
                        pdfTextSearchResult.previousInstance();
                      });
                      widget.onTap?.call('Previous Instance');
                    },
                    tooltip: widget.canShowTooltip ? 'Previous' : null,
                  ),
                ),
                // Navigate to next search instance.
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: Icon(
                      Icons.navigate_next,
                      size: 24,
                      color: _isLight
                          ? const Color.fromRGBO(0, 0, 0, 0.54)
                          : const Color.fromRGBO(255, 255, 255, 0.65),
                    ),
                    onPressed: () {
                      setState(() {
                        if (pdfTextSearchResult.currentInstanceIndex ==
                                pdfTextSearchResult.totalInstanceCount &&
                            pdfTextSearchResult.currentInstanceIndex != 0 &&
                            pdfTextSearchResult.totalInstanceCount != 0) {
                          _showSearchAlertDialog(context);
                        } else {
                          widget.controller!.clearSelection();
                          pdfTextSearchResult.nextInstance();
                        }
                      });
                      widget.onTap?.call('Next Instance');
                    },
                    tooltip: widget.canShowTooltip ? 'Next' : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Toolbar item widget
class ToolbarItem extends StatelessWidget {
  ///Creates a toolbar item
  const ToolbarItem({
    this.height,
    this.width,
    @required this.child,
  });

  /// Height of the toolbar item
  final double? height;

  /// Width of the toolbar item
  final double? width;

  /// Child widget of the toolbar item
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: child,
    );
  }
}

/// TextSearchOverlay widget for search operation.This is for web platform.
class TextSearchOverlay extends StatefulWidget {
  /// Constructor for TextSearchOverlay.
  const TextSearchOverlay(
      {Key? key,
      this.controller,
      this.textSearchOverlayEntry,
      this.onClose,
      this.brightness,
      this.primaryColor})
      : super(key: key);

  /// An object that is used to control the [SfPdfViewer].
  final PdfViewerController? controller;

  /// An object that is used to insert text search overlay.
  final OverlayEntry? textSearchOverlayEntry;

  /// Callback which triggers when closing the search overlay.
  final VoidCallback? onClose;

  /// Brightness theme for text search overlay.
  final Brightness? brightness;

  /// Palette color for text search overlay.
  final Color? primaryColor;

  @override
  TextSearchOverlayState createState() => TextSearchOverlayState();
}

/// State class of TextSearchOverlay widget.This is for web platform.
class TextSearchOverlayState extends State<TextSearchOverlay> {
  Color? _color;

  /// Indicates whether search toolbar items need to be shown or not.
  bool showItem = false;

  /// Indicates whether enter key is pressed or not.
  bool isEnterKeyPressed = false;

  /// An object that is used to retrieve the text search result.
  PdfTextSearchResult _pdfTextSearchResult = PdfTextSearchResult();

  /// An object that is used to retrieve the current value of the TextField.
  final TextEditingController _editingController = TextEditingController();

  ///Indicates whether text search option is match case
  bool isMatchCaseChecked = false;

  ///Indicates whether text search option is whole word
  bool isWholeWordChecked = false;

  /// Focus node for search overlay entry.
  final FocusNode _focusNode = FocusNode();

  late bool _isLight;

  @override
  void initState() {
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _isLight = widget.brightness == Brightness.light;
    _color = _isLight
        ? const Color(0x00000000).withOpacity(0.87)
        : const Color(0x00ffffff).withOpacity(0.87);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    const List<BoxShadow> boxShadows = <BoxShadow>[
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.26),
        blurRadius: 8,
        offset: Offset(0, 3),
      ),
    ];
    return Material(
      child: Container(
        height: 146, // height of search menu
        width: 412, // width of search menu
        decoration: BoxDecoration(
          color: _isLight ? const Color(0xFFFFFFFF) : const Color(0xFF424242),
          boxShadow: boxShadows,
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Search label for overlay
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16, // x position of search word in search menu
                    top: 15, // y position of search word in search menu
                  ),
                  child: Container(
                    height: 23, // height of search word in search menu
                    width: 66, // width of search word in search menu
                    child: Text(
                      'Search',
                      style: TextStyle(
                          color: _color,
                          fontFamily: 'Roboto',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          letterSpacing: -0.2,
                          decoration: TextDecoration.none),
                    ),
                  ),
                ),
                // Close button for search overlay
                Padding(
                  padding: const EdgeInsets.only(
                    right: 8, // x position of clear button in search menu
                    top: 8, // y position of clear button in search menu
                  ),
                  child: Container(
                    height: 36, // height of close search menu button
                    width: 36, // width of close search menu button
                    child: RawMaterialButton(
                      onPressed: () {
                        _closeSearchMenu();
                      },
                      child: Icon(
                        Icons.clear,
                        color: _isLight
                            ? const Color.fromRGBO(0, 0, 0, 0.54)
                            : const Color.fromRGBO(255, 255, 255, 0.65),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                // Search input field.
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16, // y position of text field in search menu
                    ),
                    child: TextFormField(
                      focusNode: _focusNode,
                      controller: _editingController,
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        color: _color,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(top: 20),
                        border: const UnderlineInputBorder(
                          borderSide: BorderSide(width: 1.0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: widget.primaryColor!, width: 2.0),
                        ),
                        hintText: 'Find in document',
                        hintStyle: TextStyle(
                            color: _isLight
                                ? const Color(0x00000000).withOpacity(0.34)
                                : const Color(0xFF949494),
                            fontSize: 15,
                            fontFamily: 'Roboto',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.none),
                        suffixIcon: !showItem
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, bottom: 6, top: 15),
                                child: Container(
                                  height:
                                      14.57, // height of search button in search menu
                                  width:
                                      14.57, // width of search button in search menu
                                  child: RawMaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        _handleSearch();
                                      });
                                    },
                                    child: Icon(
                                      Icons.search,
                                      color: _isLight
                                          ? Colors.black.withOpacity(0.54)
                                          : Colors.white.withOpacity(0.65),
                                      size: 18,
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, bottom: 6, top: 15),
                                child: Container(
                                  height:
                                      14.57, // height of clear search button
                                  width: 14.57, // width of clear search button
                                  child: RawMaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        _pdfTextSearchResult.clear();
                                        _editingController.clear();
                                        _focusNode.requestFocus();
                                        showItem = false;
                                      });
                                    },
                                    child: Icon(
                                      Icons.clear,
                                      color: _isLight
                                          ? Colors.black.withOpacity(0.54)
                                          : Colors.white.withOpacity(0.65),
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      onChanged: (String value) {
                        isEnterKeyPressed = false;
                      },
                      onFieldSubmitted: (String value) {
                        setState(() {
                          _handleSearch();
                        });
                      },
                    ),
                  ),
                ),
                // Search result status
                Visibility(
                  visible: showItem,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: <Widget>[
                        // Current search instance
                        Text(
                          _pdfTextSearchResult.currentInstanceIndex.toString(),
                          style: TextStyle(
                              color: _color,
                              fontSize: 15,
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none),
                        ),
                        Text(
                          '/',
                          style: TextStyle(
                              color: _color,
                              fontSize: 15,
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none),
                        ),
                        // Total search count
                        Text(
                          _pdfTextSearchResult.totalInstanceCount.toString(),
                          style: TextStyle(
                              color: _color,
                              fontSize: 15,
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none),
                        ),
                      ],
                    ),
                  ),
                ),
                // Group divider
                Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      height: 24, // height of vertical divider
                      child: VerticalDivider(
                        width: 24.0, // width of vertical divider
                        thickness: 1.0, // thickness of vertical divider
                        color: _isLight
                            ? Colors.black.withOpacity(0.24)
                            : const Color.fromRGBO(255, 255, 255, 0.26),
                      ),
                    )),
                // Previous search instance button
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    height: 36, // height of previous instance button
                    width: 36, // width of previous instance button
                    child: RawMaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      onPressed: _pdfTextSearchResult.hasResult
                          ? () {
                              setState(() {
                                _pdfTextSearchResult.previousInstance();
                              });
                            }
                          : null,
                      child: Icon(
                        Icons.keyboard_arrow_left,
                        color: _isLight
                            ? _pdfTextSearchResult.hasResult
                                ? const Color.fromRGBO(0, 0, 0, 0.54)
                                : Colors.black.withOpacity(0.28)
                            : _pdfTextSearchResult.hasResult
                                ? const Color.fromRGBO(255, 255, 255, 0.65)
                                : Colors.white12,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                // Next search instance button
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    right: 8,
                  ),
                  child: Container(
                    height: 36, // height of next instance button
                    width: 36, // width of next instance button
                    child: RawMaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      onPressed: _pdfTextSearchResult.hasResult
                          ? () {
                              setState(() {
                                _pdfTextSearchResult.nextInstance();
                              });
                            }
                          : null,
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: _isLight
                            ? _pdfTextSearchResult.hasResult
                                ? const Color.fromRGBO(0, 0, 0, 0.54)
                                : Colors.black.withOpacity(0.28)
                            : _pdfTextSearchResult.hasResult
                                ? const Color.fromRGBO(255, 255, 255, 0.65)
                                : Colors.white12,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                // Check box for case sensitive search.
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                  child: Container(
                    height: 18, // height of match case checkbox
                    width: 18, // width of match case checkbox
                    child: Theme(
                      data: ThemeData(
                        unselectedWidgetColor: _isLight
                            ? const Color.fromRGBO(0, 0, 0, 0.54)
                            : const Color.fromRGBO(255, 255, 255, 0.54),
                      ),
                      child: Checkbox(
                        value: isMatchCaseChecked,
                        activeColor: widget.primaryColor,
                        checkColor: Colors.white,
                        onChanged: (bool? value) {
                          setState(() {
                            isEnterKeyPressed = false;
                            isMatchCaseChecked = value ?? false;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                // Label for case sensitive search.
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 16, bottom: 16),
                  child: Text(
                    'Match case',
                    style: TextStyle(
                        color: _color,
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        decoration: TextDecoration.none),
                  ),
                ),
                // Check box for whole word search.
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                  child: Container(
                    height: 18, // height of whole word checkbox
                    width: 18, // height of whole word checkbox
                    child: Theme(
                      data: ThemeData(
                        unselectedWidgetColor: _isLight
                            ? const Color.fromRGBO(0, 0, 0, 0.54)
                            : const Color.fromRGBO(255, 255, 255, 0.54),
                      ),
                      child: Checkbox(
                        activeColor: widget.primaryColor,
                        checkColor: Colors.white,
                        value: isWholeWordChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isEnterKeyPressed = false;
                            isWholeWordChecked = value ?? false;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                // Label for whole word search.
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 16, bottom: 16),
                  child: Text(
                    'Whole word',
                    style: TextStyle(
                        color: _color,
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        decoration: TextDecoration.none),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Close search menu for web platform.
  void _closeSearchMenu() {
    setState(() {
      widget.onClose?.call();
      _pdfTextSearchResult.clear();
    });
  }

  ///Handle text search result
  void _handleSearch() {
    if (!isEnterKeyPressed) {
      _getSearchResult();
      showItem = true;
    } else {
      _pdfTextSearchResult.nextInstance();
    }
    _focusNode.requestFocus();
  }

  ///Get the text search result
  Future<void> _getSearchResult() async {
    isEnterKeyPressed = true;
    TextSearchOption? searchOption;
    if (isMatchCaseChecked && isWholeWordChecked) {
      searchOption = TextSearchOption.both;
    } else if (isMatchCaseChecked) {
      searchOption = TextSearchOption.caseSensitive;
    } else if (isWholeWordChecked) {
      searchOption = TextSearchOption.wholeWords;
    }
    _pdfTextSearchResult = await widget.controller!
        .searchText(_editingController.text, searchOption: searchOption);
  }

  /// Clears the search result.
  void clearSearchResult() {
    _pdfTextSearchResult.clear();
  }
}
