import 'package:flutter/material.dart';
import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({Key key}) : super(key: key);

  @override
  _LayoutPageState createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _index = 0;
  int _index1 = 0;
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) => Theme(
            data: ThemeData(
                brightness: model.themeData.brightness,
                primaryColor: model.backgroundColor),
            child: SafeArea(
              child: DefaultTabController(
                length: model.controlList[model.selectedIndex].subItems.length,
                child: Scaffold(
                    appBar: AppBar(
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context, false),
                      ),
                      backgroundColor: model.backgroundColor,
                      bottom:
                          (model.controlList[model.selectedIndex].sampleList !=
                                      null &&
                                  model.controlList[model.selectedIndex]
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
                                      model.controlList[model.selectedIndex]
                                          .subItems,
                                      'parent'),
                                ),
                      title: Text(
                          model.controlList[model.selectedIndex].title
                              .toString(),
                          style: model.isWeb
                              ? const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                  letterSpacing: 0.4)
                              : const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  letterSpacing: 0.3)),
                      actions: ((model.controlList[model.selectedIndex]
                                          .sampleList !=
                                      null &&
                                  model.controlList[model.selectedIndex]
                                          .displayType !=
                                      'card' &&
                                  model.controlList[model.selectedIndex]
                                          .sampleList[_index].codeLink !=
                                      null &&
                                  model.controlList[model.selectedIndex]
                                          .sampleList[_index].codeLink !=
                                      '') ||
                              (model.controlList[model.selectedIndex]
                                          .childList !=
                                      null &&
                                  model.controlList[model.selectedIndex]
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
                                      launch(model
                                                  .controlList[
                                                      model.selectedIndex]
                                                  .sampleList ==
                                              null
                                          ? model
                                              .controlList[model.selectedIndex]
                                              .childList[_index]
                                              .subItems[_index1]
                                              .codeLink
                                          : model
                                              .controlList[model.selectedIndex]
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
                            model.controlList[model.selectedIndex].sampleList !=
                                    null
                                ? _getSamples(
                                    model,
                                    model.controlList[model.selectedIndex]
                                        .sampleList,
                                    model.controlList[model.selectedIndex]
                                        .displayType)
                                : (model.controlList[model.selectedIndex]
                                                .childList !=
                                            null &&
                                        _checkType(model
                                            .controlList[model.selectedIndex]
                                            .subItems))
                                    ? _getChildTabViewChildren(
                                        model,
                                        model.controlList[model.selectedIndex]
                                            .childList)
                                    : _getParentTabViewChildren(
                                        model,
                                        model.controlList[model.selectedIndex]
                                            .subItems))),
              ),
            )));
  }

  bool _checkType(List<dynamic> list) {
    for (int i = 0; i < list.length; i++) {
      if (list[i].type != 'child') {
        return false;
      }
    }
    return true;
  }

  List<Widget> _getSamples(
          SampleModel model, List<dynamic> list, String displayType) =>
      displayType == 'card'
          ? _getCardViewChildren(model, list)
          : _getFullViewChildren(model, list);

  List<Widget> _getTabs(List<dynamic> list, [String tabView]) {
    final List<Widget> tabs = <Widget>[];
    for (int i = 0; i < list.length; i++) {
      if (list.isNotEmpty) {
        final String str = getStatus(list[i]);
        tabs.add(Tab(
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
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: str == 'N'
                          ? const Color.fromRGBO(101, 193, 0, 1)
                          : str == 'U'
                              ? const Color.fromRGBO(245, 166, 35, 1)
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
    return tabs;
  }

  List<Widget> _getFullViewChildren(SampleModel model, List<dynamic> list) {
    final List<Widget> tabs = <Widget>[];
    for (int j = 0; j < list.length; j++) {
      model.sampleWidget[list[j].key][1].sample = list[j];
      tabs.add(Container(child: model.sampleWidget[list[j].key][1]));
    }
    return tabs;
  }

  List<Widget> _getCardViewChildren(SampleModel model, List<dynamic> list) {
    final List<Widget> tabChildren = <Widget>[];
    for (int i = 0; i < list.length; i++) {
      tabChildren.add(ListView.builder(
          cacheExtent: (list.length).toDouble(),
          addAutomaticKeepAlives: true,
          itemCount: list.length,
          itemBuilder: (BuildContext context, int position) {
            final String status = list[position].status;
            final SubItem _subitem = list[position];
            return Container(
              color: model.slidingPanelColor,
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
                            onTapSampleItem(context, list[position], model);
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
                                    style: model.isWeb
                                        ? TextStyle(
                                            fontFamily: 'HeeboMedium',
                                            fontSize: 19.0,
                                            color: model.textColor,
                                            letterSpacing: 0.2)
                                        : TextStyle(
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
                                                          101, 193, 0, 1)
                                                      : const Color.fromRGBO(
                                                          245, 166, 35, 1))
                                                  : Colors.transparent,
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10.0))),
                                          padding: const EdgeInsets.fromLTRB(
                                              6, 3, 6, 3),
                                          child: Text(
                                              (status == 'New' || status == 'new')
                                                  ? 'New'
                                                  : (status == 'Updated' || status == 'updated') ? 'Updated' : '',
                                              style: const TextStyle(color: Colors.white))),
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
                                              color: model.listIconColor),
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
                                //ignore: avoid_as
                                width: model.isWeb
                                    ? _subitem != null &&
                                            _subitem.key == 'clock_sample'
                                        ? (MediaQuery.of(context).size.height *
                                            0.6)
                                        : double.infinity
                                    : double.infinity,
                                height: model.isWeb
                                    ? (MediaQuery.of(context).size.height * 0.6)
                                    : 230,
                                child: model.sampleWidget[list[position].key]
                                    [0]),
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
    return tabChildren;
  }

  ///if child type given to control subitems
  List<Widget> _getChildTabViewChildren(SampleModel model, List<dynamic> list) {
    final List<Widget> tabs = <Widget>[];
    for (int i = 0; i < list.length; i++) {
      if (list[i].subItems.isNotEmpty) {
        tabs.add(Container(
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
    return tabs;
  }

  ///if parent type given to control's subitem
  List<Widget> _getParentTabViewChildren(
      SampleModel model, List<dynamic> list) {
    final List<Widget> tabs = <Widget>[];
    for (int i = 0; i < list.length; i++) {
      if (list[i].subItems.isNotEmpty) {
        tabs.add(Container(
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
    return tabs;
  }
}
