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
  /// Holds the search bar widget
  // ignore: tighten_type_of_initializing_formals
  const CustomSearchBar({Key? key, this.sampleListModel})
      : assert(sampleListModel != null),
        super(key: key);

  /// Contains the sampleModel
  final SampleModel? sampleListModel;

  @override
  // ignore: no_logic_in_create_state
  SearchBarState createState() => SearchBarState(sampleListModel);
}

/// Represents the search bar state
class SearchBarState extends State<CustomSearchBar>
    with WidgetsBindingObserver {
  /// Creates the search bar state
  SearchBarState(this.sampleListModel);

  /// Creates the instance of sample model
  final SampleModel? sampleListModel;

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

  @override
  void initState() {
    searchIcon = Icon(Icons.search,
        color: sampleListModel!.isWebFullView
            ? Colors.white.withOpacity(0.5)
            : Colors.grey);
    overlayEntries = <OverlayEntry>[];
    over = Overlay.of(context);
    duplicateControlItems = sampleListModel!.searchControlItems;
    duplicateSampleItems = sampleListModel!.searchSampleItems;
    sampleListModel!.searchResults.clear();
    sampleListModel!.editingController.text = '';
    isFocus.addListener(() {
      closeIcon =
          isFocus.hasFocus && sampleListModel!.editingController.text.isNotEmpty
              ? IconButton(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  icon: Icon(Icons.close,
                      size: sampleListModel!.isWebFullView ? 20 : 24,
                      color: sampleListModel!.isWebFullView
                          ? Colors.white
                          : Colors.grey),
                  onPressed: () {
                    sampleListModel!.editingController.text = '';
                    isFocus.unfocus();
                    filterSearchResults('');
                    if (sampleListModel!.isMobileResolution) {
                      sampleListModel!.sampleList.clear();
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
      if (isFocus.hasFocus && !sampleListModel!.isMobileResolution) {
        filterSearchResults(sampleListModel!.editingController.text);
      } else if (!sampleListModel!.isMobileResolution) {
        Timer(const Duration(milliseconds: 200), () {
          _removeOverlayEntries();
        });
      }
      if (sampleListModel!.editingController.text.isEmpty) {
        setState(() {
          searchIcon = isFocus.hasFocus ||
                  sampleListModel!.editingController.text.isNotEmpty
              ? null
              : Icon(Icons.search,
                  color: sampleListModel!.isWebFullView
                      ? Colors.white.withOpacity(0.5)
                      : Colors.grey);
        });
      }
      hint = isFocus.hasFocus ? '' : 'Search';
    });
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    sampleListModel!.searchResults.clear();
    sampleListModel!.editingController.text = '';
    isFocus.unfocus();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (isFocus.hasFocus && sampleListModel!.editingController.text.isEmpty) {
      if (!isOpen) {
        isOpen = true;
      } else if (isOpen && sampleListModel!.editingController.text.isNotEmpty) {
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
        if ((item.control!.title! + ' - ' + item.title!)
            .toLowerCase()
            .contains(query.toLowerCase())) {
          dummySampleData.add(item);
        }
      }

      sampleListModel!.controlList.clear();
      sampleListModel!.sampleList.clear();
      sampleListModel!.sampleList.addAll(dummySampleData);
      sampleListModel!.searchResults.clear();
      sampleListModel!.searchResults.addAll(dummySampleData);
      if (sampleListModel!.isMobileResolution) {
        //ignore: invalid_use_of_protected_member
        sampleListModel!.notifyListeners();
      } else {
        _overlayEntry = _createOverlayEntry();
        overlayEntries.add(_overlayEntry);
        over.insert(_overlayEntry);
        return;
      }
    } else {
      sampleListModel!.searchResults.clear();
      sampleListModel!.controlList.addAll(duplicateControlItems);
      sampleListModel!.sampleList.clear();
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

  /// Performing key board actions
  /// [ArrowDown], [ArrowUp], [Enter] RawKeyEvents
  void _performKeyBoardEvent(RawKeyEvent event) {
    /// We need RawKeyEventDataWeb, RawKeyEventDataWindows,
    /// RawKeyEventDataMacOs. So dynamic type used
    final dynamic rawKeyEventData = event.data;
    if (event is RawKeyDownEvent) {
      if (sampleListModel!.searchResults.isNotEmpty &&
          rawKeyEventData.logicalKey == LogicalKeyboardKey.arrowDown) {
        ///Arrow down key action
        _selectionIndex = _selectionIndex == null
            ? 0
            : (_selectionIndex! >= sampleListModel!.searchResults.length - 1)
                ? sampleListModel!.searchResults.length - 1
                : _selectionIndex! + 1;
        final List<int> indexes = _getVisibleIndexes();
        if (!indexes.contains(_selectionIndex)) {
          _scrollToDown(_selectionIndex!);
        }
        _overlaySetState(() {
          ///Notify overlay list to scroll down
        });
      } else if (sampleListModel!.searchResults.isNotEmpty &&
          rawKeyEventData.logicalKey == LogicalKeyboardKey.arrowUp) {
        ///Arrow up key action
        _selectionIndex = _selectionIndex == null
            ? 0
            : _selectionIndex == 0
                ? 0
                : _selectionIndex! - 1;
        final List<int> indexes = _getVisibleIndexes();
        if (!indexes.contains(_selectionIndex)) {
          _scrollToUp(_selectionIndex!);
        }
        _overlaySetState(() {
          ///Notify overlay list to scroll up
        });
      } else if (rawKeyEventData.logicalKey == LogicalKeyboardKey.escape) {
        ///Escape key action
        _selectionIndex = null;
        sampleListModel!.editingController.text = '';
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
    sampleListModel!.editingController.text = '';
    isFocus.unfocus();
    _overlayEntry.opaque = false;
    _removeOverlayEntries();
    _selectionIndex = null;
    final dynamic renderSample = sampleListModel!
        .sampleWidget[sampleListModel!.searchResults[index].key];
    if (renderSample != null) {
      if (sampleListModel!.isWebFullView) {
        Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
        Navigator.pushNamed(
            context, sampleListModel!.searchResults[index].breadCrumbText!);
      } else {
        onTapExpandSample(
            context, sampleListModel!.searchResults[index], sampleListModel!);
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

  ///Get the list of visible index of the listViewBuilder
  List<int> _getVisibleIndexes() {
    final Rect rect = _RectGetterFromListView.getRectFromKey(_globalKey)!;
    final List<int> items = <int>[];
    _keys.forEach((dynamic index, dynamic key) {
      final Rect itemRect = _RectGetterFromListView.getRectFromKey(
          key.currentContext == null ? _globalKey : key)!;
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
    final num height = (sampleListModel!.searchResults.length < 4
            ? 0.1 * sampleListModel!.searchResults.length
            : 0.4) *
        MediaQuery.of(context).size.height;

    _overlayHeight = ((height ~/ _itemHeight) * _itemHeight) + 6;

    return OverlayEntry(builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext buildContext, StateSetter setState) {
        _overlaySetState = setState;
        return Positioned(
          left: offset.dx,
          top: offset.dy + size.height - 5,
          width: size.width,
          height: sampleListModel!.searchResults.isEmpty &&
                  sampleListModel!.editingController.text.isNotEmpty &&
                  isFocus.hasFocus
              ? 0.1 * MediaQuery.of(context).size.height
              : _overlayHeight.toDouble(),
          child: Card(
            color: sampleListModel!.cardColor,
            child: sampleListModel!.editingController.text.isEmpty ||
                    isFocus.hasFocus == false
                ? null
                : (sampleListModel!.searchResults.isEmpty
                    ? ListTile(
                        title: Text('No results found',
                            style: TextStyle(
                                color: sampleListModel!.textColor,
                                fontSize: 13,
                                fontFamily: 'Roboto-Regular')),
                        onTap: () {},
                      )
                    : _RectGetterFromListView(
                        key: _globalKey,
                        child: ListView.builder(
                            controller: _controller,
                            padding: EdgeInsets.zero,
                            itemCount: sampleListModel!.searchResults.length,
                            itemBuilder: (BuildContext context, int index) {
                              _keys[index] =
                                  _RectGetterFromListView.createGlobalKey();
                              return _RectGetterFromListView(
                                  key: _keys[index],
                                  child: SizedBox(
                                    height: _itemHeight.toDouble(),
                                    child: Material(
                                        color: index == _selectionIndex
                                            ? Colors.grey.withOpacity(0.4)
                                            : sampleListModel!.cardColor,
                                        child: InkWell(
                                          hoverColor:
                                              Colors.grey.withOpacity(0.2),
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
                                                      text: sampleListModel!
                                                          .searchResults[index]
                                                          .control!
                                                          .title,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              sampleListModel!
                                                                  .textColor,
                                                          fontFamily:
                                                              'Roboto-Bold'),
                                                    ),
                                                    TextSpan(
                                                      text: ' - ' +
                                                          sampleListModel!
                                                              .searchResults[
                                                                  index]
                                                              .title!,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              sampleListModel!
                                                                  .textColor,
                                                          fontFamily:
                                                              'Roboto-Regular'),
                                                    )
                                                  ]),
                                            ),
                                          ),
                                        )),
                                  ));
                            }))),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _rawKeyFocusNode,
      onKey: (RawKeyEvent event) => !sampleListModel!.isMobileResolution
          ? _performKeyBoardEvent(event)
          : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: sampleListModel!.isWebFullView ? 35 : 45,
            width: double.infinity,
            decoration: BoxDecoration(
              color: sampleListModel!.isWebFullView
                  ? Colors.grey[100]!.withOpacity(0.2)
                  : Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  left: (isFocus.hasFocus || searchIcon == null) ? 10 : 0),
              child: Center(
                child: TextField(
                  onSubmitted: (String value) {
                    if (_selectionIndex != null) {
                      _navigateToSample(_selectionIndex!);
                    }
                  },
                  mouseCursor: MaterialStateMouseCursor.clickable,
                  cursorColor: sampleListModel!.isWebFullView
                      ? Colors.white
                      : Colors.grey,
                  focusNode: isFocus,
                  onChanged: (String value) {
                    closeIcon = isFocus.hasFocus &&
                            (sampleListModel!.editingController.text.isNotEmpty)
                        ? IconButton(
                            splashColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            icon: Icon(Icons.close,
                                size: sampleListModel!.isWebFullView ? 20 : 24,
                                color: sampleListModel!.isWebFullView
                                    ? Colors.white
                                    : Colors.grey),
                            onPressed: () {
                              sampleListModel!.editingController.text = '';
                              isFocus.unfocus();
                              filterSearchResults('');
                              if (sampleListModel!.isMobileResolution) {
                                sampleListModel!.sampleList.clear();
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
                    isFocus.unfocus();
                  },
                  style: TextStyle(
                    fontFamily: 'Roboto-Regular',
                    color: sampleListModel!.isWebFullView
                        ? Colors.white
                        : Colors.grey,
                    fontSize: 13,
                  ),
                  controller: sampleListModel!.editingController,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      fontFamily: 'Roboto-Regular',
                      color: sampleListModel!.isWebFullView
                          ? Colors.white
                          : Colors.grey,
                      fontSize: 13,
                    ),
                    hintText: hint,
                    hintStyle: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Roboto-Regular',
                      color: sampleListModel!.isWebFullView
                          ? Colors.white.withOpacity(0.5)
                          : Colors.grey,
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

/// Get the rect from list view using the global key
class _RectGetterFromListView extends StatefulWidget {
  const _RectGetterFromListView({this.key, this.child}) : super(key: key);
  @override
  final GlobalKey<_RectGetterFromListViewState>? key;
  final Widget? child;

  ///Get the rect of list view
  static Rect? getRectFromKey(
      GlobalKey<_RectGetterFromListViewState> globalKey) {
    final RenderObject object = globalKey.currentContext!.findRenderObject()!;
    final dynamic translation = object.getTransformTo(null).getTranslation();
    final Size size = object.semanticBounds.size;

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
  Widget build(BuildContext context) => widget.child!;
}
