///Dart import
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///Local import
import '../model/helper.dart';
import '../model/model.dart';

/// Search bar widget for searching particular sample
/// by typing the sample's title in the text editor present in the [SearchBar]
class CustomSearchBar extends StatefulWidget {
  /// Holds the search bar widget.
  const CustomSearchBar({super.key, required this.sampleListModel});

  /// Contains the sampleModel
  final SampleModel sampleListModel;

  @override
  SearchBarState createState() => SearchBarState();
}

/// Represents the search bar state
class SearchBarState extends State<CustomSearchBar>
    with WidgetsBindingObserver {
  /// Creates the search bar state
  SearchBarState();

  /// Represents the list of duplicate control items
  late List<Control> duplicateControlItems;

  /// Represents the list of duplicate sample items
  late List<SubItem> duplicateSampleItems;

  /// Represents the list of items
  List<Control> items = <Control>[];

  /// Represents the overlay state
  late OverlayState over;

  /// Represents the search icon instance
  Widget? searchIcon;

  /// Represents the close icon instance
  Widget? closeIcon;

  /// Specifies the value of focus node
  final FocusNode isFocus = FocusNode();

  /// Specifies whether the keyboard is in open state
  bool isOpen = false;

  /// Specifies the value of overlay entry
  late OverlayEntry _overlayEntry;

  /// Specifies the hint value
  String hint = 'Search';

  /// Specifies the list of overlay entries
  late List<OverlayEntry> overlayEntries;

  /// Holds the current sample index which selected by keyboard event
  int? _selectionIndex;

  /// Holds setState of overlay widget
  late StateSetter _overlaySetState;

  /// Creates a focus node for RawKeyEvent
  final FocusNode _rawKeyFocusNode = FocusNode();

  /// Creates a controller for a list view builder widget.
  final ScrollController _controller = ScrollController();

  /// key used in [_RectGetterFromListView]
  final GlobalKey<_RectGetterFromListViewState> _globalKey =
      _RectGetterFromListView.createGlobalKey();

  /// Stores the searched results keys
  final Map<dynamic, dynamic> _keys = <dynamic, dynamic>{};

  /// Holds height of overlay entry
  late num _overlayHeight;

  ///height of the each search results
  final num _itemHeight = 38;

  /// Holds Material 3 search bar item color
  Color? _searchBarColorM3;

  Color? _searchBarBackgroundColorM3;

  @override
  void initState() {
    searchIcon = Icon(
      Icons.search,
      color: widget.sampleListModel.isWebFullView
          ? Colors.white.withValues(alpha: 0.5)
          : Colors.grey,
    );
    overlayEntries = <OverlayEntry>[];
    over = Overlay.of(context);
    duplicateControlItems = widget.sampleListModel.searchControlItems;
    duplicateSampleItems = widget.sampleListModel.searchSampleItems;
    widget.sampleListModel.searchResults.clear();
    widget.sampleListModel.editingController.text = '';
    isFocus.addListener(() {
      closeIcon =
          isFocus.hasFocus &&
              widget.sampleListModel.editingController.text.isNotEmpty
          ? IconButton(
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              icon: Icon(
                Icons.close,
                size: widget.sampleListModel.isWebFullView ? 20 : 24,
                color: widget.sampleListModel.isWebFullView
                    ? Colors.white
                    : Colors.grey,
              ),
              onPressed: () {
                widget.sampleListModel.editingController.text = '';
                isFocus.unfocus();
                filterSearchResults('');
                if (widget.sampleListModel.isMobileResolution) {
                  widget.sampleListModel.sampleList.clear();
                  setState(() {
                    closeIcon = null;
                  });
                } else {
                  // Remove the overlay on pressing close button.
                  _overlayEntry.opaque = false;
                  _removeOverlayEntries();
                }
              },
            )
          : null;
      if (isFocus.hasFocus && !widget.sampleListModel.isMobileResolution) {
        filterSearchResults(widget.sampleListModel.editingController.text);
      } else if (!widget.sampleListModel.isMobileResolution) {
        Timer(const Duration(milliseconds: 200), () {
          _removeOverlayEntries();
        });
      }
      if (widget.sampleListModel.editingController.text.isEmpty) {
        setState(() {
          searchIcon =
              isFocus.hasFocus ||
                  widget.sampleListModel.editingController.text.isNotEmpty
              ? null
              : Icon(
                  Icons.search,
                  color:
                      _searchBarColorM3 ??
                      (widget.sampleListModel.isWebFullView
                          ? Colors.white.withValues(alpha: 0.5)
                          : Colors.grey),
                );
        });
      }
      hint = isFocus.hasFocus ? '' : 'Search';
    });
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    widget.sampleListModel.searchResults.clear();
    widget.sampleListModel.editingController.text = '';
    isFocus.unfocus();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (isFocus.hasFocus &&
        widget.sampleListModel.editingController.text.isEmpty) {
      if (!isOpen) {
        isOpen = true;
      } else if (isOpen &&
          widget.sampleListModel.editingController.text.isNotEmpty) {
        isOpen = false;
        isFocus.unfocus();
      }
    }
  }

  /// method to filter the search results
  void filterSearchResults(String query) {
    _removeOverlayEntries();
    final List<Control> dummySearchControl = <Control>[];
    dummySearchControl.addAll(duplicateControlItems);
    final List<SubItem> dummySearchSamplesList = <SubItem>[];
    dummySearchSamplesList.addAll(duplicateSampleItems);

    if (query.isNotEmpty) {
      final List<Control> dummyControlData = <Control>[];
      for (int i = 0; i < dummySearchControl.length; i++) {
        final Control item = dummySearchControl[i];
        if (item.title!.toLowerCase().contains(query.toLowerCase())) {
          dummyControlData.add(item);
        }
      }
      final List<SubItem> dummySampleData = <SubItem>[];
      for (int i = 0; i < dummySearchSamplesList.length; i++) {
        final SubItem item = dummySearchSamplesList[i];
        if ((item.control!.title! + ' - ' + item.title!).toLowerCase().contains(
          query.toLowerCase(),
        )) {
          dummySampleData.add(item);
        }
      }

      widget.sampleListModel.controlList.clear();
      widget.sampleListModel.sampleList.clear();
      widget.sampleListModel.sampleList.addAll(dummySampleData);
      widget.sampleListModel.searchResults.clear();
      widget.sampleListModel.searchResults.addAll(dummySampleData);
      if (widget.sampleListModel.isMobileResolution) {
        widget.sampleListModel.notifyListeners();
      } else {
        _overlayEntry = _createOverlayEntry();
        overlayEntries.add(_overlayEntry);
        over.insert(_overlayEntry);
        return;
      }
    } else {
      widget.sampleListModel.searchResults.clear();
      widget.sampleListModel.controlList.addAll(duplicateControlItems);
      widget.sampleListModel.sampleList.clear();
    }
  }

  /// Method to remove the overlay entries
  void _removeOverlayEntries() {
    if (overlayEntries != null && overlayEntries.isNotEmpty) {
      for (final OverlayEntry overlayEntry in overlayEntries) {
        if (overlayEntry != null) {
          overlayEntry.remove();
        }
      }
    }
    overlayEntries.clear();
  }

  // Performing key board actions
  // [ArrowDown], [ArrowUp], [Enter] RawKeyEvents.
  void _performKeyBoardEvent(KeyEvent event) {
    // We need RawKeyEventDataWeb, RawKeyEventDataWindows,
    // RawKeyEventDataMacOs. So dynamic type used.
    if (event is KeyDownEvent) {
      if (widget.sampleListModel.searchResults.isNotEmpty &&
          event.logicalKey == LogicalKeyboardKey.arrowDown) {
        // Arrow down key action.
        _selectionIndex = _selectionIndex == null
            ? 0
            : (_selectionIndex! >=
                  widget.sampleListModel.searchResults.length - 1)
            ? widget.sampleListModel.searchResults.length - 1
            : _selectionIndex! + 1;
        final List<int> indexes = _visibleIndexes();
        if (!indexes.contains(_selectionIndex)) {
          _scrollToDown(_selectionIndex!);
        }
        _overlaySetState(() {
          // Notify overlay list to scroll down.
        });
      } else if (widget.sampleListModel.searchResults.isNotEmpty &&
          event.logicalKey == LogicalKeyboardKey.arrowUp) {
        // Arrow up key action.
        _selectionIndex = _selectionIndex == null
            ? 0
            : _selectionIndex == 0
            ? 0
            : _selectionIndex! - 1;
        final List<int> indexes = _visibleIndexes();
        if (!indexes.contains(_selectionIndex)) {
          _scrollToUp(_selectionIndex!);
        }
        _overlaySetState(() {
          // Notify overlay list to scroll up.
        });
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        // Escape key action.
        _selectionIndex = null;
        widget.sampleListModel.editingController.text = '';
        isFocus.unfocus();
        _overlayEntry.maintainState = false;
        _overlayEntry.opaque = false;
        _removeOverlayEntries();
      }
    }
  }

  /// Navigate to the selected sample
  Future<void> _navigateToSample(int index) async {
    _overlayEntry.maintainState = false;
    widget.sampleListModel.editingController.text = '';
    isFocus.unfocus();
    _overlayEntry.opaque = false;
    _removeOverlayEntries();
    _selectionIndex = null;
    final dynamic renderSample = widget
        .sampleListModel
        .sampleWidget[widget.sampleListModel.searchResults[index].key];
    if (renderSample != null) {
      if (widget.sampleListModel.isWebFullView) {
        Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
        Navigator.pushNamed(
          context,
          widget.sampleListModel.searchResults[index].breadCrumbText!,
        );
      } else {
        onTapExpandSample(
          context,
          widget.sampleListModel.searchResults[index],
          widget.sampleListModel,
        );
      }
    }
  }

  /// Scroll the list view position from its current value to the given value
  /// In up to down direction
  void _scrollToDown(int i) {
    _controller.jumpTo(_controller.position.pixels + _itemHeight);
  }

  /// Scroll the list view position from its current value to the given value
  /// In down to up direction
  void _scrollToUp(int i) {
    _controller.jumpTo(_itemHeight * i.toDouble());
  }

  /// Get the list of visible index of the listViewBuilder.
  List<int> _visibleIndexes() {
    final Rect rect = _RectGetterFromListView.getRectFromKey(_globalKey)!;
    final List<int> items = <int>[];
    _keys.forEach((dynamic index, dynamic key) {
      final Rect itemRect = _RectGetterFromListView.getRectFromKey(
        key.currentContext == null ? _globalKey : key,
      )!;
      if (itemRect != null &&
          (itemRect.top >= rect.top && itemRect.bottom <= rect.bottom + 2)) {
        items.add(index);
      }
    });
    return items;
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject()! as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    _selectionIndex = null;
    final num height =
        (widget.sampleListModel.searchResults.length < 4
            ? 0.1 * widget.sampleListModel.searchResults.length
            : 0.4) *
        MediaQuery.of(context).size.height;

    _overlayHeight = ((height ~/ _itemHeight) * _itemHeight) + 6;

    return OverlayEntry(
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext buildContext, StateSetter setState) {
            _overlaySetState = setState;
            return Positioned(
              left: offset.dx,
              top: offset.dy + size.height - 5,
              width: size.width,
              height:
                  widget.sampleListModel.searchResults.isEmpty &&
                      widget
                          .sampleListModel
                          .editingController
                          .text
                          .isNotEmpty &&
                      isFocus.hasFocus
                  ? 0.1 * MediaQuery.of(context).size.height
                  : _overlayHeight.toDouble(),
              child: Card(
                color: widget.sampleListModel.homeCardColor,
                child:
                    widget.sampleListModel.editingController.text.isEmpty ||
                        isFocus.hasFocus == false
                    ? null
                    : (widget.sampleListModel.searchResults.isEmpty
                          ? ListTile(
                              title: Text(
                                'No results found',
                                style: TextStyle(
                                  color: widget.sampleListModel.textColor,
                                  fontSize: 13,
                                  fontFamily: 'Roboto-Regular',
                                ),
                              ),
                              onTap: () {},
                            )
                          : _RectGetterFromListView(
                              key: _globalKey,
                              child: ListView.builder(
                                controller: _controller,
                                padding: EdgeInsets.zero,
                                itemCount:
                                    widget.sampleListModel.searchResults.length,
                                itemBuilder: (BuildContext context, int index) {
                                  _keys[index] =
                                      _RectGetterFromListView.createGlobalKey();
                                  return _RectGetterFromListView(
                                    key: _keys[index],
                                    child: SizedBox(
                                      height: _itemHeight.toDouble(),
                                      child: Material(
                                        color: index == _selectionIndex
                                            ? Colors.grey.withValues(alpha: 0.4)
                                            : widget
                                                  .sampleListModel
                                                  .homeCardColor,
                                        child: InkWell(
                                          hoverColor:
                                              widget.sampleListModel.hoverColor,
                                          highlightColor: widget
                                              .sampleListModel
                                              .splashColor,
                                          splashColor: widget
                                              .sampleListModel
                                              .splashColor,
                                          onTap: () {
                                            _navigateToSample(index);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: RichText(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              text: TextSpan(
                                                children: <InlineSpan>[
                                                  TextSpan(
                                                    text: widget
                                                        .sampleListModel
                                                        .searchResults[index]
                                                        .control!
                                                        .title,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: widget
                                                          .sampleListModel
                                                          .textColor,
                                                      fontFamily: 'Roboto-Bold',
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        ' - ' +
                                                        widget
                                                            .sampleListModel
                                                            .searchResults[index]
                                                            .title!,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: widget
                                                          .sampleListModel
                                                          .textColor,
                                                      fontFamily:
                                                          'Roboto-Regular',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _searchBarBackgroundColorM3 = widget.sampleListModel.themeData.useMaterial3
        ? widget.sampleListModel.baseAppBarItemColor.withValues(alpha: 0.2)
        : null;
    _searchBarColorM3 = widget.sampleListModel.themeData.useMaterial3
        ? widget.sampleListModel.baseAppBarItemColor
        : null;
    if (searchIcon != null) {
      searchIcon = Icon(
        Icons.search,
        color:
            _searchBarColorM3 ??
            (widget.sampleListModel.isWebFullView
                ? Colors.white.withValues(alpha: 0.5)
                : Colors.grey),
      );
    }
    return KeyboardListener(
      focusNode: _rawKeyFocusNode,
      onKeyEvent: (KeyEvent event) => !widget.sampleListModel.isMobileResolution
          ? _performKeyBoardEvent(event)
          : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: widget.sampleListModel.isWebFullView ? 35 : 45,
            width: double.infinity,
            decoration: BoxDecoration(
              color:
                  _searchBarBackgroundColorM3 ??
                  (widget.sampleListModel.isWebFullView
                      ? Colors.grey[100]!.withValues(alpha: 0.2)
                      : Colors.white),
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: (isFocus.hasFocus || searchIcon == null) ? 10 : 0,
              ),
              child: Center(
                child: TextField(
                  onSubmitted: (String value) {
                    if (_selectionIndex != null) {
                      _navigateToSample(_selectionIndex!);
                    }
                  },
                  mouseCursor: WidgetStateMouseCursor.clickable,
                  cursorColor:
                      _searchBarColorM3 ??
                      (widget.sampleListModel.isWebFullView
                          ? Colors.white
                          : Colors.grey),
                  focusNode: isFocus,
                  onChanged: (String value) {
                    closeIcon =
                        isFocus.hasFocus &&
                            (widget
                                .sampleListModel
                                .editingController
                                .text
                                .isNotEmpty)
                        ? IconButton(
                            splashColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            icon: Icon(
                              Icons.close,
                              size: widget.sampleListModel.isWebFullView
                                  ? 20
                                  : 24,
                              color:
                                  _searchBarColorM3 ??
                                  (widget.sampleListModel.isWebFullView
                                      ? Colors.white
                                      : Colors.grey),
                            ),
                            onPressed: () {
                              widget.sampleListModel.editingController.text =
                                  '';
                              isFocus.unfocus();
                              filterSearchResults('');
                              if (widget.sampleListModel.isMobileResolution) {
                                widget.sampleListModel.sampleList.clear();
                                setState(() {
                                  closeIcon = null;
                                });
                              } else {
                                _overlayEntry.opaque = false;
                                _removeOverlayEntries();
                              }
                            },
                          )
                        : null;
                    setState(() {
                      // searched results changed.
                    });
                    filterSearchResults(value);
                  },
                  onEditingComplete: () {
                    isFocus.unfocus();
                  },
                  style: TextStyle(
                    fontFamily: 'Roboto-Regular',
                    color:
                        _searchBarColorM3 ??
                        (widget.sampleListModel.isWebFullView
                            ? Colors.white
                            : Colors.grey),
                    fontSize: 13,
                  ),
                  controller: widget.sampleListModel.editingController,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      fontFamily: 'Roboto-Regular',
                      color:
                          _searchBarColorM3 ??
                          (widget.sampleListModel.isWebFullView
                              ? Colors.white
                              : Colors.grey),
                      fontSize: 13,
                    ),
                    hintText: hint,
                    hintStyle: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Roboto-Regular',
                      color:
                          _searchBarColorM3 ??
                          (widget.sampleListModel.isWebFullView
                              ? Colors.white.withValues(alpha: 0.5)
                              : Colors.grey),
                    ),
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    border: InputBorder.none,
                    suffixIcon: closeIcon,
                    prefixIcon: searchIcon,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Get the rect from list view using the global key.
class _RectGetterFromListView extends StatefulWidget {
  const _RectGetterFromListView({this.key, this.child}) : super(key: key);
  @override
  final GlobalKey<_RectGetterFromListViewState>? key;
  final Widget? child;

  // Get the rect of list view.
  static Rect? getRectFromKey(
    GlobalKey<_RectGetterFromListViewState> globalKey,
  ) {
    final RenderObject object = globalKey.currentContext!.findRenderObject()!;
    final dynamic translation = object.getTransformTo(null).getTranslation();
    final Size size = object.semanticBounds.size;

    if (translation != null && size != null) {
      return Rect.fromLTWH(
        translation.x,
        translation.y,
        size.width,
        size.height,
      );
    } else {
      return null;
    }
  }

  static GlobalKey<_RectGetterFromListViewState> createGlobalKey() {
    return GlobalKey<_RectGetterFromListViewState>();
  }

  @override
  _RectGetterFromListViewState createState() => _RectGetterFromListViewState();
}

class _RectGetterFromListViewState extends State<_RectGetterFromListView> {
  @override
  Widget build(BuildContext context) => widget.child!;
}
