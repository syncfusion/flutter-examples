import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';
import '../model/helper.dart';

class SearchBar extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  SearchBar({Key key, this.sampleListModel}) : super(key: key);
  final SampleModel sampleListModel;

  @override
  _SearchBarState createState() => _SearchBarState(sampleListModel);
}

class _SearchBarState extends State<SearchBar> with WidgetsBindingObserver {
  _SearchBarState(this.sampleListModel);
  final SampleModel sampleListModel;

  TextEditingController editingController = TextEditingController();

  List<Control> duplicateControlItems;

  List<SubItem> duplicateSampleItems;

  //ignore: prefer_collection_literals
  List<Control> items = List<Control>();
  OverlayState over;
  Widget searchIcon = Icon(Icons.search,
      color: kIsWeb ? Colors.white.withOpacity(0.5) : Colors.grey);
  Widget closeIcon;
  final FocusNode _isFocus = FocusNode();
  bool isOpen = false;
  OverlayEntry _overlayEntry;
  String hint = 'Search';
  @override
  void initState() {
    over = Overlay.of(context);
    duplicateControlItems = sampleListModel.searchControlItems;
    duplicateSampleItems = sampleListModel.searchSampleItems;
    sampleListModel.searchResults.clear();
    editingController.text = '';
    _isFocus.addListener(() {
      closeIcon = _isFocus.hasFocus && editingController.text.isNotEmpty
          ? IconButton(
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              icon: const Icon(Icons.close,
                  size: kIsWeb ? 20 : 24,
                  color: kIsWeb ? Colors.white : Colors.grey),
              onPressed: () {
                editingController.text = '';
                filterSearchResults('');
                if (!kIsWeb)
                  setState(() {
                    closeIcon = null;
                  });
              })
          : null;
      if (_isFocus.hasFocus && sampleListModel.isWeb) {
        filterSearchResults(editingController.text);
        _overlayEntry = _createOverlayEntry();
        try {
          _overlayEntry.remove();
          over.insert(_overlayEntry);
        } catch (e) {
          over.insert(_overlayEntry);
        }
      } else if (sampleListModel.isWeb) {
        Timer(const Duration(milliseconds: 200), () {
          if (_overlayEntry != null) {
            try {
              _overlayEntry.remove();
              try {
                over.dispose();
              } catch (e) {
                over.dispose();
              }
            } catch (e) {
              over.dispose();
            }
          }
        });
      }
      if (editingController.text.isEmpty)
        setState(() {
          searchIcon = _isFocus.hasFocus || editingController.text.isNotEmpty
              ? null
              : Icon(Icons.search,
                  color: kIsWeb ? Colors.white.withOpacity(0.5) : Colors.grey);
        });
      hint = _isFocus.hasFocus ? '' : 'Search';
    });
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    sampleListModel.searchResults.clear();
    editingController.text = '';
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
    // ignore: prefer_collection_literals
    final List<Control> dummySearchControl = List<Control>();
    dummySearchControl.addAll(duplicateControlItems);

    // ignore: prefer_collection_literals
    final List<SubItem> dummySearchSamplesList = List<SubItem>();
    dummySearchSamplesList.addAll(duplicateSampleItems);

    if (query.isNotEmpty) {
      // ignore: prefer_collection_literals
      final List<Control> dummyControlData = List<Control>();
      for (int i = 0; i < dummySearchControl.length; i++) {
        final Control item = dummySearchControl[i];
        if (item.title.toLowerCase().contains(query.toLowerCase())) {
          dummyControlData.add(item);
        }
      }
      // ignore: prefer_collection_literals
      final List<SubItem> dummySampleData = List<SubItem>();
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
      // ignore: invalid_use_of_protected_member
      sampleListModel.notifyListeners();
      return;
    } else {
      sampleListModel.searchResults.clear();
      sampleListModel.controlList.addAll(duplicateControlItems);
      sampleListModel.sampleList.clear();
      // ignore: invalid_use_of_protected_member
      sampleListModel.notifyListeners();
    }
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject();
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        maintainState: false,
        builder: (BuildContext context) {
          return Positioned(
            left: offset.dx,
            top: offset.dy + size.height - 5,
            width: size.width,
            height: sampleListModel.searchResults.isEmpty &&
                    editingController.text.isNotEmpty &&
                    _isFocus.hasFocus
                ? 0.1 * MediaQuery.of(context).size.height
                : (sampleListModel.searchResults.length < 4
                        ? 0.1 * sampleListModel.searchResults.length
                        : 0.4) *
                    MediaQuery.of(context).size.height,
            child: Scrollbar(
              child: Card(
                color: sampleListModel.webCardColor,
                child:
                    editingController.text.isEmpty || _isFocus.hasFocus == false
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
                            : ListView.builder(
                                padding: const EdgeInsets.all(0),
                                itemCount: sampleListModel.searchResults.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return HandCursor(
                                      child: SizedBox(
                                          height: 38,
                                          child: Material(
                                              color:
                                                  sampleListModel.webCardColor,
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
                                                    try {
                                                      _overlayEntry.remove();
                                                    }
                                                    //ignore: empty_catches
                                                    catch (e) {}
                                                    _overlayEntry
                                                        .maintainState = false;
                                                    changeCursorStyleOnNavigation();
                                                    over.deactivate();
                                                    try {
                                                      _overlayEntry.opaque =
                                                          false;
                                                      _overlayEntry.remove();
                                                    } catch (e) {
                                                      over.deactivate();
                                                    }
                                                    sampleListModel.sampleWidget[
                                                                sampleListModel
                                                                    .searchResults[
                                                                        index]
                                                                    .key][0] !=
                                                            null
                                                        ? Navigator.push<
                                                                dynamic>(
                                                            context,
                                                            MaterialPageRoute<
                                                                    dynamic>(
                                                                builder:
                                                                    (BuildContext
                                                                            context) =>
                                                                        Scaffold(
                                                                          appBar:
                                                                              AppBar(
                                                                            backgroundColor:
                                                                                sampleListModel.backgroundColor,
                                                                            title:
                                                                                Text(sampleListModel.searchResults[index].title),
                                                                          ),
                                                                          body:
                                                                              Theme(
                                                                            data:
                                                                                ThemeData(brightness: sampleListModel.themeData.brightness, primaryColor: sampleListModel.backgroundColor),
                                                                            child:
                                                                                Container(
                                                                              color: sampleListModel.webCardColor,
                                                                              padding: const EdgeInsets.all(10),
                                                                              child: sampleListModel.sampleWidget[sampleListModel.searchResults[index].key][0],
                                                                            ),
                                                                          ),
                                                                        )))
                                                        : onTapSampleItem(
                                                            context,
                                                            sampleListModel
                                                                    .searchResults[
                                                                index],
                                                            sampleListModel);
                                                  }))));
                                })),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: sampleListModel.isWeb ? 35 : 45,
          width: double.infinity,
          decoration: BoxDecoration(
              color: kIsWeb
                  ? (Colors.grey[100]).withOpacity(0.2)
                  : sampleListModel.searchBoxColor,
              borderRadius: const BorderRadius.all(Radius.circular(5.0))),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Container(
                child: TextField(
              cursorColor: kIsWeb ? Colors.white : Colors.grey,
              focusNode: _isFocus,
              onChanged: (String value) {
                closeIcon =
                    _isFocus.hasFocus && editingController.text.isNotEmpty
                        ? IconButton(
                            splashColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            icon: const Icon(Icons.close,
                                size: kIsWeb ? 20 : 24,
                                color: kIsWeb ? Colors.white : Colors.grey),
                            onPressed: () {
                              editingController.text = '';
                              filterSearchResults('');
                              if (!kIsWeb)
                                setState(() {
                                  closeIcon = null;
                                });
                            })
                        : null;
                filterSearchResults(value);
              },
              onEditingComplete: () {
                _isFocus.unfocus();
              },
              style: const TextStyle(
                  fontFamily: 'Roboto-Regular',
                  color: kIsWeb ? Colors.white : Colors.grey,
                  fontSize: 13),
              controller: editingController,
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
                      color:
                          kIsWeb ? Colors.white.withOpacity(0.5) : Colors.grey),
                  suffixIcon: closeIcon,
                  prefixIcon: searchIcon),
            )),
          ),
        ),
      ],
    );
  }
}
