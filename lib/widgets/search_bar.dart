import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';

class SearchBar extends StatefulWidget {
  SearchBar({Key key, this.sampleListModel}) : super(key: key);
  final SampleListModel sampleListModel;

  @override
  _SearchBarState createState() => new _SearchBarState(sampleListModel);
}

class _SearchBarState extends State<SearchBar> with WidgetsBindingObserver {
  final SampleListModel sampleListModel;

  _SearchBarState(this.sampleListModel);

  TextEditingController editingController = TextEditingController();

  List<SampleList> duplicateControlItems;

  List<SubItemList> duplicateSampleItems;

  var items = List<SampleList>();
  Widget searchIcon = Icon(Icons.search, color: Colors.grey);
  final FocusNode _isFocus = FocusNode();
  bool isOpen = false;

  @override
  void initState() {
    duplicateControlItems = sampleListModel.searchControlListItems;
    duplicateSampleItems = sampleListModel.searchSampleListItems;
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
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
    List<SampleList> dummySearchControlList = List<SampleList>();
    dummySearchControlList.addAll(duplicateControlItems);

    List<SubItemList> dummySearchSamplesList = List<SubItemList>();
    dummySearchSamplesList.addAll(duplicateSampleItems);

    if (query.isNotEmpty) {
      searchIcon = null;
      List<SampleList> dummyControlListData = List<SampleList>();
      for (int i = 0; i < dummySearchControlList.length; i++) {
        var item = dummySearchControlList[i];
        if (item.title.toLowerCase().contains(query.toLowerCase())) {
          dummyControlListData.add(item);
        }
      }

      List<SubItemList> dummySampleListData = List<SubItemList>();
      for (int i = 0; i < dummySearchSamplesList.length; i++) {
        var item = dummySearchSamplesList[i];
        if (item.title.toLowerCase().contains(query.toLowerCase())) {
          dummySampleListData.add(item);
        }
      }

      sampleListModel.controlList.clear();
      sampleListModel.controlList.addAll(dummyControlListData);
      sampleListModel.sampleList.clear();
      sampleListModel.sampleList.addAll(dummySampleListData);
      // ignore: invalid_use_of_protected_member
      sampleListModel.notifyListeners();
      return;
    } else {
      searchIcon = Icon(Icons.search, color: Colors.grey);
      sampleListModel.controlList.clear();
      sampleListModel.controlList.addAll(duplicateControlItems);
      sampleListModel.sampleList.clear();
      // ignore: invalid_use_of_protected_member
      sampleListModel.notifyListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 45,
          width: double.infinity,
          decoration: BoxDecoration(
              color: sampleListModel.searchBoxColor,
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Container(
              child: TextField(
                  focusNode: _isFocus,
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                  onEditingComplete: () {
                    _isFocus.unfocus();
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(fontFamily: 'MontserratMedium'),
                      hintText: "Search",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                          fontSize: 15,
                          fontFamily: 'MontserratMedium',
                          color: Colors.grey),
                      prefixIcon: searchIcon)),
            ),
          ),
        ),
      ],
    );
  }
}
