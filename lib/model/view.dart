/// Package imports
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Local imports
import 'helper.dart';
import 'model.dart';
import 'sample_view.dart';

///Render the sample layout.
class LayoutPage extends StatefulWidget {
  const LayoutPage({this.category,this.sampleModel, Key key}) : super(key: key);
  final WidgetCategory category;
  final SampleModel sampleModel;
  @override
  _LayoutPageState createState() => _LayoutPageState();
}


/// State class of layout.
class _LayoutPageState extends State<LayoutPage> {
  SampleModel model;
  WidgetCategory category;
  
  @override
  void initState() {
      model = widget.sampleModel;
    category = widget.category;
  
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _index = 0;
  int _index1 = 0;
  @override
  Widget build(BuildContext context) {
    return Theme(
            data: ThemeData(
                brightness: model.themeData.brightness,
                primaryColor: model.backgroundColor),
            child: SafeArea(
              child: DefaultTabController(
                length: category.controlList[category.selectedIndex].subItems.length,
                child: Scaffold(
                    appBar: AppBar(
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context, false),
                      ),
                      backgroundColor: model.paletteColor,
                      bottom:
                          (category.controlList[category.selectedIndex].sampleList !=
                                      null &&
                                  category.controlList[category.selectedIndex]
                                          .displayType ==
                                      'card')
                              ? null
                              : TabBar(
                                  onTap: (int index) {
                                    _index = index;
                                  },
                                  indicator: const UnderlineTabIndicator(
                                    borderSide: BorderSide(
                                        width: 5.0,
                                        color: Color.fromRGBO(252, 220, 0, 1)),
                                  ),
                                  isScrollable: true,
                                  tabs: _getTabs(
                                      category.controlList[category.selectedIndex]
                                          .subItems,
                                      'parent'),
                                ),
                      title: Text(
                          category.controlList[category.selectedIndex].title
                              .toString(),
                          style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  letterSpacing: 0.3)),
                      actions: ((category.controlList[category.selectedIndex]
                                          .sampleList !=
                                      null &&
                                  category.controlList[category.selectedIndex]
                                          .displayType !=
                                      'card' &&
                                  category.controlList[category.selectedIndex]
                                          .sampleList[_index].codeLink !=
                                      null &&
                                  category.controlList[category.selectedIndex]
                                          .sampleList[_index].codeLink !=
                                      '') ||
                              (category.controlList[category.selectedIndex]
                                          .childList !=
                                      null &&
                                  category.controlList[category.selectedIndex]
                                          .childList[_index].displayType ==
                                      'tab'))
                          ? <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  child: IconButton(
                                    icon: Image.asset('images/code.png',
                                        color: Colors.white),
                                    onPressed: () {
                                      launch(category
                                                  .controlList[
                                                      category.selectedIndex]
                                                  .sampleList ==
                                              null
                                          ? category
                                              .controlList[category.selectedIndex]
                                              .childList[_index]
                                              .subItems[_index1]
                                              .codeLink
                                          : category
                                              .controlList[category.selectedIndex]
                                              .sampleList[_index]
                                              .codeLink);
                                    },
                                  ),
                                ),
                              ),
                            ]
                          : null,
                    ),
                    body: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children:
                            category.controlList[category.selectedIndex].sampleList !=
                                    null
                                ? _getSamples(
                                    model,
                                    category.controlList[category.selectedIndex]
                                        .sampleList,
                                    category.controlList[category.selectedIndex]
                                        .displayType)
                                : (category.controlList[category.selectedIndex]
                                                .childList !=
                                            null &&
                                        _checkType(category
                                            .controlList[category.selectedIndex]
                                            .subItems))
                                    ? _getChildTabViewChildren(
                                        model,
                                        category.controlList[category.selectedIndex]
                                            .childList)
                                    : _getParentTabViewChildren(
                                        model,
                                        category.controlList[category.selectedIndex]
                                            .subItems))),
              ),
            ));
  }


/// Return true, list type doesn't contain child.
  bool _checkType(List<SubItem> list) {
    for (int i = 0; i < list.length; i++) {
      if (list[i].type != 'child') {
        return false;
      }
    }
    return true;
  }

  List<Widget> _getSamples(
          SampleModel model, List<SubItem> list, String displayType) =>
      displayType == 'card'
          ? _getCardViewChildren(model, list)
          : _getFullViewChildren(model, list);

  List<Widget> _getTabs(List<SubItem> list, [String tabView]) {
    final List<Widget> _tabs = <Widget>[];
    for (int i = 0; i < list.length; i++) {
      if (list.isNotEmpty) {
        final String str = getStatus(list[i]);
        _tabs.add(Tab(
            child: Row(
          children: <Widget>[
            Text(list[i].title.toString() + (str != '' ? '  ' : ''),
                style: tabView != 'parent'
                    ? const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.normal)
                    : const TextStyle(fontSize: 15)),
            str == ''
                ? Container()
                : Container(
                    height: tabView != 'parent' ? 17 : 20,
                    width: tabView != 'parent' ? 17 : 20,
                    decoration: BoxDecoration(
                      color: str == 'N'
                          ? const Color.fromRGBO(55, 153, 30, 1)
                          : str == 'U'
                              ? const Color.fromRGBO(246, 117, 0, 1)
                              : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      str,
                      style: TextStyle(
                          fontSize: tabView != 'parent' ? 11 : 12,
                          color: Colors.white),
                    ),
                  ),
          ],
        )));
      }
    }
    return _tabs;
  }

/// To displaying sample in full screen height, it doesn't contains expanded view.
  List<Widget> _getFullViewChildren(SampleModel model, List<SubItem> list) {
    final List<dynamic> _tabs = <Widget>[];
    for (int j = 0; j < list.length; j++) {
      final SubItem sample = list[j];
      final bool _needsFloatingBotton =
          (sample.sourceLink != null && sample.sourceLink != '') ||
              sample.needsPropertyPanel == true;
      dynamic _sampleView = model.sampleWidget[list[j].key];
      _sampleView = _sampleView(GlobalKey<State>());
      _tabs.add(
        Scaffold(
          backgroundColor: model.cardThemeColor,
          body:  Container(child: _sampleView),          
          floatingActionButton: _needsFloatingBotton
              ? Stack(children: <Widget>[
                  (sample.sourceLink != null && sample.sourceLink != '')
                      ? Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                            child: Container(
                              height: 50,
                              width: 250,
                              child: InkWell(
                                onTap: () => launch(sample.sourceLink),
                                child: Row(
                                  children: <Widget>[
                                    Text('Source: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: model.textColor)),
                                    Text(sample.sourceText,
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.blue)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  sample.needsPropertyPanel != true
                      ? Container()
                      : Align(
                          alignment: Alignment.bottomRight,
                          child: FloatingActionButton(
                            heroTag: null,
                            onPressed: () {
                              final GlobalKey _sampleKey = _sampleView.key;
                              final SampleViewState _sampleState =
                                  _sampleKey.currentState;
                              final Widget _settingsContent =
                                  _sampleState.buildSettings(context);
                              getBottomSheet(context, _settingsContent);
                            },
                            child: const Icon(Icons.graphic_eq,
                                color: Colors.white),
                            backgroundColor: model.paletteColor,
                          ),
                        ),
                ])
              : null,
        ),
      );
    }
    return _tabs;
  }


/// To displaying sample in cards, it contains expanded sample view option.
  List<Widget> _getCardViewChildren(SampleModel model, List<SubItem> list) {
    final List<Widget> _tabChildren = <Widget>[];
    dynamic sample;
    for (int i = 0; i < list.length; i++) {    
      _tabChildren.add(ListView.builder(
          cacheExtent: (list.length).toDouble(),
          addAutomaticKeepAlives: true,
          itemCount: list.length,
          itemBuilder: (BuildContext context, int position) {
            final String status = list[position].status;
            sample = model.sampleWidget[list[position].key];
            sample = sample(GlobalKey<State>());
            return Container(
              color: model.themeData.brightness == Brightness.dark ? Colors.black : const Color.fromRGBO(250, 250, 250, 1),
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Card(
                    elevation: 2,
                    color: model.cardThemeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        InkWell(
                          splashColor: Colors.grey.withOpacity(0.4),
                          onTap: () {
                            Feedback.forLongPress(context);
                            expandSample(context, list[position], model);
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    '${list[position].title}',
                                    textAlign: TextAlign.left,
                                    softWrap: true,
                                    textScaleFactor: 1,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                            fontFamily: 'HeeboMedium',
                                            fontSize: 16.0,
                                            color: model.textColor,
                                            letterSpacing: 0.2),
                                  ),
                                  Container(
                                      child: Row(
                                    children: <Widget>[
                                      Container(
                                          decoration: BoxDecoration(
                                              color: (status != null && status != '')
                                                  ? (status == 'New' || status == 'new'
                                                      ? const Color.fromRGBO(
                                                          55, 153, 30, 1)
                                                      : const Color.fromRGBO(
                                                          246, 117, 0, 1))
                                                  : Colors.transparent,
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10.0))),
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 2.7, 5, 2.7),
                                          child: Text(
                                              (status == 'New' || status == 'new')
                                                  ? 'New'
                                                  : (status == 'Updated' || status == 'updated') ? 'Updated' : '',
                                              style: const TextStyle(fontSize: 12, color: Colors.white))),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 15),
                                      ),
                                      Container(
                                        height: 24,
                                        width: 24,
                                        color: Colors.transparent,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 0, 5, 5),
                                          child: Image.asset(
                                              'images/fullscreen.png',
                                              fit: BoxFit.contain,
                                              height: 20,
                                              width: 20,
                                              color: model.backgroundColor),
                                        ),
                                      ),
                                    ],
                                  )),
                                ]),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: SizedBox(
                                width: double.infinity,
                                height: 230,
                                child: sample),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }));
    }
    return _tabChildren;
  }

  /// If child type given to control subitems.
  List<Widget> _getChildTabViewChildren(SampleModel model, List<SubItem> list) {
    final List<Widget> _tabs = <Widget>[];
    for (int i = 0; i < list.length; i++) {
      if (list[i].subItems.isNotEmpty) {
        _tabs.add(Container(
          alignment: Alignment.center,
          child: DefaultTabController(
              length: list[i].subItems.length,
              child: Scaffold(
                  appBar: list[i].displayType == 'card'
                      ? null
                      : PreferredSize(
                          child: AppBar(
                            backgroundColor:
                                const Color.fromRGBO(241, 241, 241, 1),
                            bottom: TabBar(
                              onTap: (int index) {
                                _index1 = index;
                              },
                              unselectedLabelColor: Colors.black,
                              labelColor: Colors.blue,
                              indicatorColor: Colors.transparent,
                              indicatorWeight: 0.1,
                              isScrollable: true,
                              tabs: _getTabs(list[i].subItems),
                            ),
                          ),
                          preferredSize: const Size.fromHeight(46.1),
                        ),
                  body: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: _getSamples(
                          model, list[i].subItems, list[i].displayType)))),
        ));
      }
    }
    return _tabs;
  }

  /// If parent type given to control's subitem.
  List<Widget> _getParentTabViewChildren(
      SampleModel model, List<SubItem> list) {
    final List<Widget> _tabs = <Widget>[];
    for (int i = 0; i < list.length; i++) {
      if (list[i].subItems.isNotEmpty) {
        _tabs.add(Container(
          alignment: Alignment.center,
          child: DefaultTabController(
              length: list[i].subItems.length,
              child: Scaffold(
                  appBar:
                      list[i].type == 'child' && list[i].displayType == 'card'
                          ? null
                          : PreferredSize(
                              child: AppBar(
                                backgroundColor:
                                    const Color.fromRGBO(241, 241, 241, 1),
                                bottom: TabBar(
                                  unselectedLabelColor: Colors.black,
                                  labelColor: Colors.blue,
                                  indicatorColor: Colors.transparent,
                                  indicatorWeight: 0.1,
                                  isScrollable: true,
                                  tabs: _getTabs(list[i].subItems),
                                ),
                              ),
                              preferredSize: const Size.fromHeight(46.1),
                            ),
                  body: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: list[i].type == 'child'
                          ? _getSamples(
                              model, list[i].subItems, list[i].displayType)
                          : _getChildTabViewChildren(
                              model, list[i].subItems)))),
        ));
      }
    }
    return _tabs;
  }
}
