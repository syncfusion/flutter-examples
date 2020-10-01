///Dart import
import 'dart:async';

///Package import
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///Local import
import '../model/helper.dart';
import '../model/model.dart';
import 'shared/mobile.dart' if (dart.library.html) 'shared/web.dart';

/// Searchbar widget for searching particular sample
/// by typing the sample's title in the text editor present in the [SearchBar]
class SearchBar extends StatefulWidget {
  /// Holds the search bar widet
  const SearchBar({Key key, @required this.sampleListModel})
      : assert(sampleListModel != null),
        super(key: key);

  /// Contains the sampleModel
  final SampleModel sampleListModel;

  @override
  _SearchBarState createState() => _SearchBarState(sampleListModel);
}

class _SearchBarState extends State<SearchBar> with WidgetsBindingObserver {
  _SearchBarState(this.sampleListModel);
  final SampleModel sampleListModel;

  List<Control> duplicateControlItems;

  List<SubItem> duplicateSampleItems;

  List<Control> items = <Control>[];
  OverlayState over;
  Widget searchIcon = Icon(Icons.search,
      color: kIsWeb ? Colors.white.withOpacity(0.5) : Colors.grey);
  Widget closeIcon;
  final FocusNode _isFocus = FocusNode();
  bool isOpen = false;
  OverlayEntry _overlayEntry;
  String hint = 'Search';

  List<OverlayEntry> overlayEntries;

  /// Holds the current sample index which selected by keyboard event
  int _selectionIndex;

  /// Holds setState of overlay widget
  StateSetter _overlaySetState;

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
  num _overlayHeight;

  ///height of the each search results
  final num _itemHeight = 38;

  @override
  void initState() {
    overlayEntries = <OverlayEntry>[];
    over = Overlay.of(context);
    duplicateControlItems = sampleListModel.searchControlItems;
    duplicateSampleItems = sampleListModel.searchSampleItems;
    sampleListModel.searchResults.clear();
    sampleListModel.editingController.text = '';
    _isFocus.addListener(() {
      closeIcon =
          _isFocus.hasFocus && sampleListModel.editingController.text.isNotEmpty
              ? IconButton(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  icon: const Icon(Icons.close,
                      size: kIsWeb ? 20 : 24,
                      color: kIsWeb ? Colors.white : Colors.grey),
                  onPressed: () {
                    sampleListModel.editingController.text = '';
                    _isFocus.unfocus();
                    filterSearchResults('');
                    if (sampleListModel.isMobileResolution) {
                      sampleListModel.sampleList.clear();
                      setState(() {
                        closeIcon = null;
                      });
                    } else {
                      ///Remove the overlay on pressing close button
                      _overlayEntry.opaque = false;
                      _removeOverlayEntries();
                    }
                  })
              : null;
      if (_isFocus.hasFocus && !sampleListModel.isMobileResolution) {
        filterSearchResults(sampleListModel.editingController.text);
      } else if (!sampleListModel.isMobileResolution) {
        Timer(const Duration(milliseconds: 200), () {
          _removeOverlayEntries();
        });
      }
      if (sampleListModel.editingController.text.isEmpty) {
        setState(() {
          searchIcon = _isFocus.hasFocus ||
                  sampleListModel.editingController.text.isNotEmpty
              ? null
              : Icon(Icons.search,
                  color: sampleListModel.isWeb
                      ? Colors.white.withOpacity(0.5)
                      : Colors.grey);
        });
      }
      hint = _isFocus.hasFocus ? '' : 'Search';
    });
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    sampleListModel.searchResults.clear();
    sampleListModel.editingController.text = '';
    _isFocus.unfocus();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (_isFocus.hasFocus) {
      if (!isOpen) {
        isOpen = true;
      } else if (isOpen) {
        isOpen = false;
        _isFocus.unfocus();
      }
    }
  }

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
        if (item.title.toLowerCase().contains(query.toLowerCase())) {
          dummyControlData.add(item);
        }
      }
      final List<SubItem> dummySampleData = <SubItem>[];
      for (int i = 0; i < dummySearchSamplesList.length; i++) {
        final SubItem item = dummySearchSamplesList[i];
        if (item.title.toLowerCase().contains(query.toLowerCase())) {
          dummySampleData.add(item);
        }
      }

      sampleListModel.controlList.clear();
      sampleListModel.sampleList.clear();
      sampleListModel.sampleList.addAll(dummySampleData);
      sampleListModel.searchResults.clear();
      sampleListModel.searchResults.addAll(dummySampleData);
      if (sampleListModel.isMobileResolution) {
        //ignore: invalid_use_of_protected_member
        sampleListModel.notifyListeners();
      } else {
        _overlayEntry = _createOverlayEntry();
        overlayEntries.add(_overlayEntry);
        over.insert(_overlayEntry);
        return;
      }
    } else {
      sampleListModel.searchResults.clear();
      sampleListModel.controlList.addAll(duplicateControlItems);
      sampleListModel.sampleList.clear();
    }
  }

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

  /// Performing key board actions
  /// [ArrowDown], [ArrowUp], [Enter] RawKeyEvents
  void _performKeyBoardEvent(RawKeyEvent event) {
    final RawKeyEventDataWeb rawKeyEventDataWeb = event.data;
    if (event is RawKeyDownEvent) {
      if (sampleListModel.searchResults.isNotEmpty &&
          rawKeyEventDataWeb.code == 'ArrowDown') {
        ///Arrow down key action
        _selectionIndex = _selectionIndex == null
            ? 0
            : (_selectionIndex >= sampleListModel.searchResults.length - 1)
                ? sampleListModel.searchResults.length - 1
                : _selectionIndex + 1;
        final List<int> indexes = _getVisibleIndexes();
        if (!indexes.contains(_selectionIndex)) {
          _scrollToDown(_selectionIndex);
        }
        _overlaySetState(() {
          ///Notify overlay list to scroll down
        });
      } else if (sampleListModel.searchResults.isNotEmpty &&
          rawKeyEventDataWeb.code == 'ArrowUp') {
        ///Arrow up key action
        _selectionIndex = _selectionIndex == null
            ? 0
            : _selectionIndex == 0 ? 0 : _selectionIndex - 1;
        final List<int> indexes = _getVisibleIndexes();
        if (!indexes.contains(_selectionIndex)) {
          _scrollToUp(_selectionIndex);
        }
        _overlaySetState(() {
          ///Notify overlay list to scroll up
        });
      } else if (rawKeyEventDataWeb.code == 'Escape') {
        ///Escape key action
        _selectionIndex = null;
        sampleListModel.editingController.text = '';
        _isFocus.unfocus();
        _overlayEntry.maintainState = false;
        changeCursorStyleOnNavigation();
        _overlayEntry.opaque = false;
        _removeOverlayEntries();
      }
    }
  }

  /// Navigate to the selected sample
  void _navigateToSample(int index) {
    _overlayEntry.maintainState = false;
    changeCursorStyleOnNavigation();
    sampleListModel.editingController.text = '';
    _isFocus.unfocus();
    _overlayEntry.opaque = false;
    _removeOverlayEntries();
    final dynamic renderSample =
        sampleListModel.sampleWidget[sampleListModel.searchResults[index].key];
    if (renderSample != null) {
      sampleListModel.isWeb
          ? Navigator.pushNamed(
              context, sampleListModel.searchResults[index].breadCrumbText)
          : onTapExpandSample(
              context, sampleListModel.searchResults[index], sampleListModel);
    }
  }

  /// Scroll the list view position from its current value to the given value
  /// In up to down direction
  void _scrollToDown(num i) {
    _controller.jumpTo(_controller.position.pixels + _itemHeight);
  }

  /// Scroll the list view position from its current value to the given value
  /// In down to up direction
  void _scrollToUp(num i) {
    _controller.jumpTo(_itemHeight * i);
  }

  ///Get the list of visible index of the listViewBuilder
  List<int> _getVisibleIndexes() {
    final Rect rect = _RectGetterFromListView.getRectFromKey(_globalKey);
    final List<int> items = <int>[];
    _keys.forEach((dynamic index, dynamic key) {
      final Rect itemRect = _RectGetterFromListView.getRectFromKey(key);
      if (itemRect != null &&
          (itemRect.top >= rect.top && itemRect.bottom <= rect.bottom + 2)) {
        items.add(index);
      }
    });
    return items;
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject();
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    _selectionIndex = null;
    final num height = (sampleListModel.searchResults.length < 4
            ? 0.1 * sampleListModel.searchResults.length
            : 0.4) *
        MediaQuery.of(context).size.height;

    _overlayHeight = ((height ~/ _itemHeight) * _itemHeight) + 6;

    return OverlayEntry(
        maintainState: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext buildContext, StateSetter setState) {
            _overlaySetState = setState;
            return Positioned(
              left: offset.dx,
              top: offset.dy + size.height - 5,
              width: size.width,
              height: sampleListModel.searchResults.isEmpty &&
                      sampleListModel.editingController.text.isNotEmpty &&
                      _isFocus.hasFocus
                  ? 0.1 * MediaQuery.of(context).size.height
                  : _overlayHeight.toDouble(),
              child: CupertinoScrollbar(
                child: Card(
                  color: sampleListModel.cardColor,
                  child: sampleListModel.editingController.text.isEmpty ||
                          _isFocus.hasFocus == false
                      ? null
                      : (sampleListModel.searchResults.isEmpty
                          ? ListTile(
                              title: Text('No results found',
                                  style: TextStyle(
                                      color: sampleListModel.textColor,
                                      fontSize: 13,
                                      fontFamily: 'Roboto-Regular')),
                              onTap: () {},
                            )
                          : _RectGetterFromListView(
                              key: _globalKey,
                              child: ListView.builder(
                                  controller: _controller,
                                  padding: const EdgeInsets.all(0),
                                  itemCount:
                                      sampleListModel.searchResults.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    _keys[index] = _RectGetterFromListView
                                        .createGlobalKey();
                                    return _RectGetterFromListView(
                                        key: _keys[index],
                                        child: HandCursor(
                                            child: SizedBox(
                                          height: _itemHeight.toDouble(),
                                          child: Material(
                                              color: index == _selectionIndex
                                                  ? Colors.grey.withOpacity(0.4)
                                                  : sampleListModel.cardColor,
                                              child: InkWell(
                                                  hoverColor: Colors.grey
                                                      .withOpacity(0.2),
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Text(
                                                        sampleListModel
                                                            .searchResults[
                                                                index]
                                                            .title,
                                                        style: TextStyle(
                                                            color:
                                                                sampleListModel
                                                                    .textColor,
                                                            fontSize: 13,
                                                            fontFamily:
                                                                'Roboto-Regular'),
                                                      )),
                                                  onTap: () {
                                                    _selectionIndex = null;
                                                    _navigateToSample(index);
                                                  })),
                                        )));
                                  }))),
                ),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
        focusNode: _rawKeyFocusNode,
        onKey: (RawKeyEvent event) => !sampleListModel.isMobileResolution
            ? _performKeyBoardEvent(event)
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: sampleListModel.isWeb ? 35 : 45,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: kIsWeb
                      ? (Colors.grey[100]).withOpacity(0.2)
                      : Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(5.0))),
              child: Padding(
                padding: EdgeInsets.only(
                    left: (_isFocus.hasFocus || searchIcon == null) ? 10 : 0),
                child: Container(
                    child: TextField(
                  mouseCursor: MaterialStateMouseCursor.clickable,
                  cursorColor: kIsWeb ? Colors.white : Colors.grey,
                  focusNode: _isFocus,
                  onChanged: (String value) {
                    closeIcon = _isFocus.hasFocus &&
                            (sampleListModel.editingController.text.isNotEmpty)
                        ? IconButton(
                            splashColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            icon: const Icon(Icons.close,
                                size: kIsWeb ? 20 : 24,
                                color: kIsWeb ? Colors.white : Colors.grey),
                            onPressed: () {
                              sampleListModel.editingController.text = '';
                              _isFocus.unfocus();
                              filterSearchResults('');
                              if (sampleListModel.isMobileResolution) {
                                sampleListModel.sampleList.clear();
                                setState(() {
                                  closeIcon = null;
                                });
                              } else {
                                _overlayEntry.opaque = false;
                                _removeOverlayEntries();
                              }
                            })
                        : null;
                    setState(() {
                      /// searched results changed
                    });
                    filterSearchResults(value);
                  },
                  onEditingComplete: () {
                    _isFocus.unfocus();
                  },
                  style: const TextStyle(
                      fontFamily: 'Roboto-Regular',
                      color: kIsWeb ? Colors.white : Colors.grey,
                      fontSize: 13),
                  controller: sampleListModel.editingController,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                      labelStyle: const TextStyle(
                          fontFamily: 'Roboto-Regular',
                          color: kIsWeb ? Colors.white : Colors.grey,
                          fontSize: 13),
                      hintText: hint,
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Roboto-Regular',
                          color: kIsWeb
                              ? Colors.white.withOpacity(0.5)
                              : Colors.grey),
                      suffixIcon: closeIcon,
                      prefixIcon: searchIcon),
                )),
              ),
            ),
          ],
        ));
  }
}

/// Get the rect from list view using the global key
class _RectGetterFromListView extends StatefulWidget {
  const _RectGetterFromListView({@required this.key, @required this.child})
      : super(key: key);
  final GlobalKey<_RectGetterFromListViewState> key;
  final Widget child;

  ///Get the rect of list view
  static Rect getRectFromKey(
      GlobalKey<_RectGetterFromListViewState> _globalKey) {
    final RenderObject object = _globalKey?.currentContext?.findRenderObject();
    final dynamic translation = object?.getTransformTo(null)?.getTranslation();
    final Size size = object?.semanticBounds?.size;

    if (translation != null && size != null) {
      return Rect.fromLTWH(
          translation.x, translation.y, size.width, size.height);
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
  Widget build(BuildContext context) => widget.child;
}
