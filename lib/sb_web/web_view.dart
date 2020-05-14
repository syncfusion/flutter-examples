import 'package:flutter/material.dart';
import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/expansionTile.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';
import 'package:flutter_examples/widgets/search_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class WebLayoutPage extends StatefulWidget {
  const WebLayoutPage({this.sampleModel, this.category, Key key})
      : super(key: key);

  final SampleModel sampleModel;
  final Categoryy category;

  @override
  _WebLayoutPageState createState() => _WebLayoutPageState();
}

class _WebLayoutPageState extends State<WebLayoutPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey sampleInputKey = GlobalKey<State>();
  GlobalKey sampleOutputKey = GlobalKey<State>();

  SampleInputContainer inputContainer;

  SampleOutputContainer outputContainer;

  String selectSample;

  SampleModel model;
  Categoryy category;
  dynamic sample;
  dynamic subItems;
  String orginText;
  @override
  void initState() {
    model = widget.sampleModel;
    category = widget.category;
    sample = category.controlList[category.selectedIndex].subItems[0].type ==
            'parent'
        ? category.controlList[category.selectedIndex].subItems[0].subItems[0]
            .subItems[0]
        : category.controlList[category.selectedIndex].subItems[0].type ==
                'child'
            ? category
                .controlList[category.selectedIndex].subItems[0].subItems[0]
            : category.controlList[category.selectedIndex].subItems[0];
    orginText = category.controlList[category.selectedIndex].subItems[0].type ==
            'parent'
        ? category.controlList[category.selectedIndex].title +
            ' > ' +
            category.controlList[category.selectedIndex].subItems[0].title +
            ' > ' +
            category.controlList[category.selectedIndex].subItems[0].subItems[0]
                .title
        : category.controlList[category.selectedIndex].subItems[0].type ==
                'child'
            ? category.controlList[category.selectedIndex].title +
                ' > ' +
                category.controlList[category.selectedIndex].subItems[0].title +
                ' > ' +
                sample.title
            : category.controlList[category.selectedIndex].title +
                ' > ' +
                sample.title;
    subItems = category.controlList[category.selectedIndex].subItems[0].type ==
            'parent'
        ? category.controlList[category.selectedIndex].subItems[0].subItems[0]
            .subItems
        : null;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        drawer: (MediaQuery.of(context).size.width > 768)
            ? Container()
            : SizedBox(
                width: MediaQuery.of(context).size.width *
                    (MediaQuery.of(context).size.width < 500 ? 0.65 : 0.4),
                child: Drawer(
                    key: const PageStorageKey<String>('pagescrollmaintain'),
                    child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: SampleInputContainer(
                            sampleModel: model,
                            category: category,
                            key: sampleInputKey,
                            webLayoutPageState: this)))),
        endDrawer: showWebThemeSettings(model),
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Container(
              decoration: BoxDecoration(boxShadow: <BoxShadow>[
                BoxShadow(
                  color: model.backgroundColor,
                  offset: const Offset(0, 2.0),
                  blurRadius: 0.25,
                )
              ]),
              child: AppBar(
                leading: (MediaQuery.of(context).size.width > 768)
                    ? Container()
                    : HandCursor(
                        child: IconButton(
                          icon: Icon(Icons.menu, color: Colors.white),
                          onPressed: () {
                            if (outputContainer != null) {
                              final GlobalKey globalKey = outputContainer.key;
                              final SampleOutputContainerState
                                  outputContainerState = globalKey.currentState;
                              if (outputContainerState.outputScaffoldKey
                                  .currentState.isEndDrawerOpen) {
                                Navigator.pop(context);
                              }
                            }
                            scaffoldKey.currentState.openDrawer();
                          },
                        ),
                      ),
                automaticallyImplyLeading:
                    MediaQuery.of(context).size.width <= 768,
                elevation: 0.0,
                backgroundColor: model.backgroundColor,
                titleSpacing:
                    MediaQuery.of(context).size.width <= 768 ? 0 : -30,
                title: Row(children: <Widget>[
                  const Text('Flutter UI Widgets ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          letterSpacing: 0.53,
                          fontFamily: 'Roboto-Medium')),
                  Container(
                      padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                      decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Color.fromRGBO(245, 188, 14, 1)),
                      child: const Text(
                        'BETA',
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 0.26,
                            fontFamily: 'Roboto-Medium',
                            color: Colors.black),
                      ))
                ]),
                actions: <Widget>[
                  MediaQuery.of(context).size.width < 500
                      ? Container(height: 0, width: 9)
                      : Container(
                          child: Container(
                              padding: const EdgeInsets.only(top: 0, right: 10),
                              width: MediaQuery.of(context).size.width * 0.215,
                              height:
                                  MediaQuery.of(context).size.height * 0.0445,
                              child: HandCursor(
                                child: SearchBar(
                                  sampleListModel: model,
                                ),
                              ))),
                  Container(
                    height: 60,
                    width: 60,
                    child: HandCursor(
                      child: IconButton(
                        icon: Icon(Icons.settings, color: Colors.white),
                        onPressed: () {
                          if (outputContainer != null) {
                            final GlobalKey globalKey = outputContainer.key;
                            final SampleOutputContainerState
                                outputContainerState = globalKey.currentState;
                            if (outputContainerState.outputScaffoldKey
                                .currentState.isEndDrawerOpen) {
                              Navigator.pop(context);
                            }
                          }
                          scaffoldKey.currentState.openEndDrawer();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )),
        body: Material(
            child: Row(
          children: <Widget>[
            (MediaQuery.of(context).size.width <= 768)
                ? Container()
                : SizedBox(
                    width: MediaQuery.of(context).size.width * 0.17,
                    child: inputContainer = SampleInputContainer(
                        sampleModel: model,
                        category: category,
                        key: sampleInputKey,
                        webLayoutPageState: this)),
            outputContainer = SampleOutputContainer(
                sampleModel: model,
                category: category,
                initialSample: sample,
                orginText: orginText,
                initialSubItems: subItems,
                key: sampleOutputKey,
                webLayoutPageState: this)
          ],
        )));
  }
}

class SampleInputContainer extends StatefulWidget {
  const SampleInputContainer(
      {this.sampleModel, this.category, this.webLayoutPageState, this.key})
      : super(key: key);

  final SampleModel sampleModel;
  final Categoryy category;

  final Key key;

  final _WebLayoutPageState webLayoutPageState;

  @override
  State<StatefulWidget> createState() {
    return _SampleInputContainerState();
  }
}

class ExpansionKey {
  ExpansionKey({this.expansionIndex, this.isExpanded, this.globalKey});
  bool isExpanded;
  int expansionIndex;
  GlobalKey globalKey;
}

class _SampleInputContainerState extends State<SampleInputContainer> {
  SampleModel sampleModel;
  Categoryy category;

  List<ExpansionKey> expansionKey;

  bool initialRender;

  @override
  void didUpdateWidget(SampleInputContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void refresh() {
    initialRender = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    expansionKey = <ExpansionKey>[];
    initialRender = true;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget expandedChildren(
      SampleModel model, dynamic item, Categoryy category, int index) {
    GlobalKey<State> currentGlobalKey;
    ExpansionKey currentExpansionKey;
    if (initialRender) {
      currentGlobalKey = GlobalKey<State>();
      currentExpansionKey = ExpansionKey(
          expansionIndex: index,
          isExpanded: index == 0,
          globalKey: currentGlobalKey);
      expansionKey.add(currentExpansionKey);
    } else {
      if (expansionKey.isNotEmpty) {
        for (int m = 0; m < expansionKey.length; m++) {
          if (expansionKey[m].expansionIndex == index) {
            currentExpansionKey = expansionKey[m];
            break;
          }
        }
      }
    }
    return item.subItems != null && item.subItems.isNotEmpty
        ? TileContainer(
            key: currentGlobalKey,
            category: category,
            sampleModel: model,
            expansionKey: currentExpansionKey,
            webLayoutPageState: widget.webLayoutPageState,
            item: item)
        : Material(
            color: model.webBackgroundColor,
            child: HandCursor(
                child: InkWell(
                    hoverColor: Colors.grey.withOpacity(0.2),
                    onTap: () {
                      final GlobalKey globalKey =
                          widget.webLayoutPageState.outputContainer.key;
                      final SampleOutputContainerState outputContainerState =
                          globalKey.currentState;
                      if (outputContainerState
                          .outputScaffoldKey.currentState.isEndDrawerOpen) {
                        Navigator.pop(context);
                      }
                      outputContainerState.sample = item;
                      outputContainerState.needTabs = false;
                      outputContainerState.orginText =
                          category.controlList[category.selectedIndex].title +
                              ' > ' +
                              item.title;
                      outputContainerState.refresh();
                    },
                    child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                        alignment: Alignment.centerLeft,
                        child: Text(item.title,
                            style: TextStyle(
                                color: model.textColor,
                                fontSize: 13,
                                fontFamily: 'Roboto-Regular'))))));
  }

  List<Widget> _getSampleList(SampleModel model, Categoryy category) {
    final dynamic list = category.controlList[category.selectedIndex].subItems;
    final List<Widget> _children = <Widget>[];
    for (int i = 0; i < list.length; i++) {
      final bool isNeedSelect = widget.webLayoutPageState.selectSample == null
          ? i == 0
          : widget.webLayoutPageState.selectSample == list[i].title;
      _children.add(Material(
          color: model.webBackgroundColor,
          child: list[i].type != 'parent' && list[i].type != 'child'
              ? HandCursor(
                  child: InkWell(
                  hoverColor: model.webFooterColor,
                  child: Container(
                      color: isNeedSelect
                          ? Colors.grey.withOpacity(0.2)
                          : Colors.transparent,
                      child: Row(children: <Widget>[
                        Container(
                            color: isNeedSelect
                                ? model.backgroundColor
                                : Colors.transparent,
                            width: 5,
                            padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                            alignment: Alignment.centerLeft,
                            child:
                                const Opacity(opacity: 0.0, child: Text('1'))),
                        Expanded(
                            child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 10, 10),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  list[i].title,
                                  style: TextStyle(
                                      color: isNeedSelect
                                          ? model.backgroundColor
                                          : model.textColor),
                                ))),
                        list[i].status != null
                            ? Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: (list[i].status == 'New' ||
                                            list[i].status == 'new')
                                        ? const Color.fromRGBO(101, 193, 0, 1)
                                        : (list[i].status == 'Updated' ||
                                                list[i].status == 'updated')
                                            ? const Color.fromRGBO(
                                                245, 166, 35, 1)
                                            : Colors.transparent,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                padding: const EdgeInsets.fromLTRB(7, 3, 6, 3),
                                child: Text(list[i].status,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12)))
                            : Container(),
                        list[i].status != null
                            ? const Padding(padding: EdgeInsets.only(right: 5))
                            : Container(),
                      ])),
                  onTap: () {
                    final _SampleInputContainerState
                        _sampleInputContainerState =
                        widget.webLayoutPageState.sampleInputKey.currentState;
                    final GlobalKey globalKey =
                        widget.webLayoutPageState.outputContainer.key;
                    final SampleOutputContainerState outputContainerState =
                        globalKey.currentState;
                    if (outputContainerState
                        .outputScaffoldKey.currentState.isEndDrawerOpen) {
                      Navigator.pop(context);
                    }
                    outputContainerState.sample = list[i];
                    outputContainerState.needTabs = false;
                    outputContainerState.orginText =
                        category.controlList[category.selectedIndex].title +
                            ' > ' +
                            list[i].title;
                    widget.webLayoutPageState.selectSample = list[i].title;
                    _sampleInputContainerState.refresh();
                    outputContainerState.refresh();
                  },
                ))
              : expandedChildren(model, list[i], category, i)));
    }

    return _children;
  }

  @override
  Widget build(BuildContext context) {
    sampleModel = widget.sampleModel;
    category = widget.category;
    return Container(
        color: sampleModel.webBackgroundColor,
        height: MediaQuery.of(context).size.height - 45,
        width: MediaQuery.of(context).size.width * 0.2,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 10),
              height: 40,
              child: HandCursor(
                  child: InkWell(
                child: Row(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                    ),
                    Container(
                        child: Icon(Icons.arrow_back,
                            size: 20, color: sampleModel.backgroundColor)),
                    Container(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          category.controlList[category.selectedIndex].title,
                          style: TextStyle(
                              color: sampleModel.backgroundColor,
                              fontSize: 16,
                              fontFamily: 'Roboto-Medium'),
                        )),
                    const Spacer(),
                    const Padding(padding: EdgeInsets.only(top: 5)),
                  ],
                ),
                onTap: () {
                  changeCursorStyleOnNavigation();
                  Navigator.pop(context);
                  if (MediaQuery.of(context).size.width <= 768) {
                    Navigator.pop(context);
                  }
                },
              )),
            ),
            Expanded(
                child:
                    ListView(children: _getSampleList(sampleModel, category)))
          ],
        ));
  }
}

class SampleOutputContainer extends StatefulWidget {
  const SampleOutputContainer(
      {this.sampleModel,
      this.category,
      this.initialSample,
      this.webLayoutPageState,
      this.initialSubItems,
      this.orginText,
      this.key})
      : super(key: key);

  final dynamic sampleModel;

  final Key key;
  final String orginText;

  final dynamic initialSample;
  final Categoryy category;
  final dynamic initialSubItems;

  final _WebLayoutPageState webLayoutPageState;

  @override
  State<StatefulWidget> createState() {
    return SampleOutputContainerState();
  }
}

class SampleOutputContainerState extends State<SampleOutputContainer> {
  dynamic sample;
  dynamic subItems;
  bool needTabs;
  String orginText;
  int tabIndex;
  GlobalKey<ScaffoldState> outputScaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<State> propertiesPanelKey = GlobalKey<State>();
  GlobalKey<State> outputKey = GlobalKey<State>();
  PropertiesPanel propertiesPanel;
  bool initialRender;

  @override
  void didUpdateWidget(SampleOutputContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    initialRender = true;
    orginText = widget.orginText;
    super.initState();
  }

  void refresh() {
    initialRender = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SampleModel model = widget.sampleModel;
    final GlobalKey globalKey = widget.webLayoutPageState.outputContainer.key;
    final SampleOutputContainerState outputContainerState =
        globalKey.currentState;
    model.sampleOutputContainer = outputContainerState;
    if (initialRender && widget.initialSubItems != null) {
      needTabs = true;
      subItems = widget.initialSubItems;
    }
    bool isNeedPropertyPanel = false;
    final dynamic _sample = initialRender ? widget.initialSample : sample;
    final int index = model.sampleWidget[_sample.key].length != 3
        ? 0
        : model.sampleWidget[_sample.key][0] == null ? 1 : 2;
    final dynamic output = model.sampleWidget[_sample.key][index];
    if (index == 2) {
      output.sample = _sample;
      isNeedPropertyPanel = true;
    }
    propertiesPanel = PropertiesPanel(
        sampleModel: model,
        key: propertiesPanelKey,
        webLayoutPageState: widget.webLayoutPageState,
        renderWidget: const Text('Properties'));
    return Theme(
      data: ThemeData(
          brightness: model.themeData.brightness,
          primaryColor: model.backgroundColor),
      child: Expanded(
          child: Container(
              color: model.webOutputContainerColor,
              padding: const EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(_sample.title,
                          style: TextStyle(
                              color: model.textColor,
                              letterSpacing: 0.39,
                              fontSize: 18,
                              fontFamily: 'Roboto-Medium'))),
                  Container(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                          needTabs == true
                              ? orginText + ' > ' + _sample.title
                              : orginText,
                          style: TextStyle(
                              color: model.textColor.withOpacity(0.65),
                              fontSize: 14,
                              letterSpacing: 0.3,
                              fontFamily: 'Roboto-Regular'))),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  Expanded(
                      child: Scaffold(
                          backgroundColor: model.webOutputContainerColor,
                          key: outputScaffoldKey,
                          endDrawer: propertiesPanel,
                          body: needTabs == true
                              ? DefaultTabController(
                                  initialIndex: tabIndex ?? 0,
                                  key: UniqueKey(),
                                  length: subItems.length,
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: model.webOutputContainerColor,
                                        border: Border.all(
                                            color:
                                                model.theme == Brightness.light
                                                    ? Colors.grey[300]
                                                    : Colors.transparent,
                                            width: 1),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                              height: 36,
                                              decoration: BoxDecoration(
                                                color: model.webInputColor,
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: model
                                                            .webDividerColor,
                                                        width: 0.8)),
                                              ),
                                              padding: MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      500
                                                  ? const EdgeInsets.fromLTRB(
                                                      2, 5, 2, 0)
                                                  : const EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                        width: MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            ((MediaQuery.of(context).size.width <=
                                                                        768 &&
                                                                    MediaQuery.of(context)
                                                                            .size
                                                                            .width >
                                                                        500)
                                                                ? 0.82
                                                                : 0.67),
                                                        child:
                                                            SingleChildScrollView(
                                                                key: PageStorageKey<
                                                                    String>((subItems
                                                                            .isNotEmpty
                                                                        ? subItems[0]
                                                                            .title
                                                                        : '') +
                                                                    'tabscroll'),
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                child: HandCursor(
                                                                    child: Material(
                                                                        color: model.webInputColor,
                                                                        child: InkWell(
                                                                            hoverColor: model.backgroundColor.withOpacity(0.3),
                                                                            child: TabBar(
                                                                              indicatorPadding: EdgeInsets.zero,
                                                                              indicatorColor: model.backgroundColor,
                                                                              onTap: (int value) {
                                                                                final GlobalKey globalKey = widget.webLayoutPageState.outputContainer.key;
                                                                                final SampleOutputContainerState outputContainerState = globalKey.currentState;
                                                                                outputContainerState.sample = subItems[value];
                                                                                outputContainerState.needTabs = true;
                                                                                outputContainerState.subItems = subItems;
                                                                                outputContainerState.tabIndex = value;
                                                                                outputContainerState.refresh();
                                                                              },
                                                                              labelColor: model.backgroundColor,
                                                                              unselectedLabelColor: model.webTabTextColor,
                                                                              isScrollable: true,
                                                                              tabs: _getTabs(subItems),
                                                                            )))))),
                                                    Container(
                                                      child: Row(
                                                        children: <Widget>[
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 15),
                                                          ),
                                                          Container(
                                                            height: 24,
                                                            width: 24,
                                                            child: HandCursor(
                                                              child: InkWell(
                                                                child: Icon(
                                                                    Icons.code,
                                                                    color: model
                                                                        .webIconColor),
                                                                onTap: () {
                                                                  launch(_sample
                                                                      .codeLink);
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 15),
                                                          ),
                                                          index == 2
                                                              ? Container(
                                                                  height: 24,
                                                                  width: 24,
                                                                  child:
                                                                      HandCursor(
                                                                    child:
                                                                        InkWell(
                                                                      child: Icon(
                                                                          Icons
                                                                              .menu,
                                                                          color:
                                                                              model.webIconColor),
                                                                      onTap:
                                                                          () {
                                                                        outputScaffoldKey
                                                                            .currentState
                                                                            .openEndDrawer();
                                                                      },
                                                                    ),
                                                                  ),
                                                                )
                                                              : Container(),
                                                        ],
                                                      ),
                                                    )
                                                  ])),
                                          Expanded(
                                              child: Container(
                                            color:
                                                model.webSampleBackgroundColor,
                                            child: TabBarView(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                children: _getTabViewChildren(
                                                    model, subItems)),
                                          )),
                                        ],
                                      )))
                              : Container(
                                  decoration: BoxDecoration(
                                    color: model.webOutputContainerColor,
                                    border: Border.all(
                                        color: model.theme == Brightness.light
                                            ? Colors.grey[300]
                                            : Colors.transparent,
                                        width: 1),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: model.webInputColor,
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: model.webDividerColor,
                                                  width: 0.8)),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 5, 10, 5),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              Container(
                                                  child: Row(
                                                children: <Widget>[
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15),
                                                  ),
                                                  Container(
                                                    height: 24,
                                                    width: 24,
                                                    child: HandCursor(
                                                        child: InkWell(
                                                      child: Icon(Icons.code,
                                                          color: model
                                                              .webIconColor),
                                                      onTap: () {
                                                        launch(
                                                            _sample.codeLink);
                                                      },
                                                    )),
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15),
                                                  ),
                                                  index == 2
                                                      ? Container(
                                                          height: 24,
                                                          width: 24,
                                                          child: HandCursor(
                                                              child: InkWell(
                                                            child: Icon(
                                                                Icons.menu,
                                                                color: model
                                                                    .webIconColor),
                                                            onTap: () {
                                                              outputScaffoldKey
                                                                  .currentState
                                                                  .openEndDrawer();
                                                            },
                                                          )),
                                                        )
                                                      : Container(),
                                                ],
                                              )),
                                            ]),
                                      ),
                                      Expanded(
                                          child: Column(
                                        children: <Widget>[
                                          Expanded(
                                              child: Container(
                                            color:
                                                model.webSampleBackgroundColor,
                                            child: OutputContainer(
                                                key: GlobalKey(),
                                                isPropertyPanelCreated: false,
                                                isNeedPropertyPanel:
                                                    isNeedPropertyPanel,
                                                propertiesPanel:
                                                    propertiesPanel,
                                                webLayoutPageState:
                                                    widget.webLayoutPageState,
                                                sampleModel: model,
                                                renderSample: output),
                                          )),
                                          _sample.sourceLink != null &&
                                                  _sample.sourceLink != ''
                                              ? Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(15, 0, 0, 20),
                                                    height: 35,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text(
                                                          'Source: ',
                                                          style: TextStyle(
                                                              color: model
                                                                  .textColor),
                                                        ),
                                                        InkWell(
                                                          onTap: () => launch(
                                                              _sample
                                                                  .sourceLink),
                                                          child: Text(
                                                              _sample
                                                                  .sourceText,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .blue)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : Container()
                                        ],
                                      )),
                                    ],
                                  )))),
                  _sample.description != null && _sample.description != ''
                      ? Container(
                          padding: const EdgeInsets.only(left: 10, top: 18),
                          alignment: Alignment.centerLeft,
                          child: Text(_sample.description,
                          textAlign: TextAlign.justify,
                              style: TextStyle(
                                  color: model.textColor,
                                  fontSize: 14,
                                  fontFamily: 'Roboto-Regular',
                                  letterSpacing: 0.3)))
                      : Container(),
                ],
              ))),
    );
  }

  List<Widget> _getTabs(List<dynamic> list) {
    final List<Widget> tabs = <Widget>[];
    for (int i = 0; i < list.length; i++) {
      if (list.isNotEmpty) {
        final String str = getStatus(list[i]);
        tabs.add(Tab(
            child: Row(
          children: <Widget>[
            Text(list[i].title.toString() + (str != '' ? '  ' : ''),
                style: const TextStyle(
                    letterSpacing: 0.5,
                    fontSize: 14,
                    fontFamily: 'Roboto-Medium')),
            str == ''
                ? Container()
                : Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: str == 'New'
                          ? const Color.fromRGBO(101, 193, 0, 1)
                          : str == 'Updated'
                              ? const Color.fromRGBO(245, 166, 35, 1)
                              : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      str == 'New' ? 'N' : str == 'Updated' ? 'U' : '',
                      style: const TextStyle(fontSize: 11, color: Colors.white),
                    ),
                  ),
          ],
        )));
      }
    }
    return tabs;
  }

  List<Widget> _getTabViewChildren(SampleModel model, List<dynamic> list) {
    final List<Widget> tabChildren = <Widget>[];
    for (int i = 0; i < list.length; i++) {
      bool isNeedPropertyPanel = false;
      final int index = model.sampleWidget[list[i].key].length != 3
          ? 0
          : model.sampleWidget[list[i].key][0] == null ? 1 : 2;

      final dynamic output = model.sampleWidget[list[i].key][index];
      if (index == 2) {
        output.sample = sample;
        isNeedPropertyPanel = true;
      }
      tabChildren.add(Column(children: <Widget>[
        Expanded(
          child: Container(
              color: model.webSampleBackgroundColor,
              padding: const EdgeInsets.all(5.0),
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: OutputContainer(
                      key: GlobalKey(),
                      isPropertyPanelCreated: false,
                      isNeedPropertyPanel: isNeedPropertyPanel,
                      propertiesPanel: propertiesPanel,
                      webLayoutPageState: widget.webLayoutPageState,
                      sampleModel: model,
                      renderSample: output))),
        ),
        list[i].sourceLink != null && list[i].sourceLink != ''
            ? Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
                  height: 35,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Source: ',
                        style: TextStyle(color: model.textColor),
                      ),
                      InkWell(
                        onTap: () => launch(list[i].sourceLink),
                        child: Text(list[i].sourceText,
                            style: const TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                ),
              )
            : Container()
      ]));
    }
    return tabChildren;
  }
}

//ignore: must_be_immutable
class OutputContainer extends StatefulWidget {
  OutputContainer(
      {this.sampleModel,
      this.renderSample,
      this.webLayoutPageState,
      this.propertiesPanel,
      this.key,
      this.isNeedPropertyPanel,
      this.isPropertyPanelCreated})
      : super(key: key);

  final SampleModel sampleModel;

  final Key key;

  dynamic renderSample;

  PropertiesPanel propertiesPanel;

  Widget updateWidget;

  bool isNeedPropertyPanel;

  bool isPropertyPanelCreated;

  final _WebLayoutPageState webLayoutPageState;

  @override
  State<StatefulWidget> createState() {
    return OutputContainerState();
  }
}

class OutputContainerState extends State<OutputContainer> {
  dynamic currentState;

  @override
  void didUpdateWidget(OutputContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
  }

  void refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  Widget _getUpdateWidget() {
    return currentState?.sampleWidget(widget.sampleModel);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _createPropertyPanel() {
    if (widget.isNeedPropertyPanel && !widget.isPropertyPanelCreated) {
      widget.isPropertyPanelCreated = true;
      widget.sampleModel.properties.clear();
      currentState = widget.renderSample.createState();
      final GlobalKey globalKey = widget.webLayoutPageState.outputContainer.key;
      final SampleOutputContainerState sampleOutputContainerState =
          globalKey.currentState;
      final PropertiesPanel propertiesPanel =
          sampleOutputContainerState.propertiesPanel;
      propertiesPanel.currentState = currentState;
      propertiesPanel.sampleModel = widget.sampleModel;
      propertiesPanel.initProperty = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.sampleModel.sampleOutputContainer.outputKey = widget.key;
    _createPropertyPanel();
    return Container(
        child: widget.isNeedPropertyPanel
            ? _getUpdateWidget()
            : widget.renderSample);
  }
}

//ignore: must_be_immutable
class PropertiesPanel extends StatefulWidget {
  PropertiesPanel(
      {this.sampleModel, this.webLayoutPageState, this.key, this.renderWidget})
      : super(key: key);
  dynamic renderWidget;

  SampleModel sampleModel;

  dynamic currentState;

  bool initProperty;

  final Key key;

  final _WebLayoutPageState webLayoutPageState;

  @override
  State<StatefulWidget> createState() {
    return PropertiesPanelState();
  }
}

class PropertiesPanelState extends State<PropertiesPanel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Widget renderWidget = widget.currentState
        ?.propertyWidget(widget.sampleModel, widget.initProperty, context);
    widget.initProperty = false;
    return Theme(
      data: ThemeData(
          brightness: widget.sampleModel.themeData.brightness,
          primaryColor: widget.sampleModel.backgroundColor),
      child: Drawer(
          elevation: 3,
          child: SizedBox(
              child: Container(
                  color: widget.sampleModel.webSampleBackgroundColor,
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: renderWidget))),
    );
  }
}

//ignore: must_be_immutable
class TileContainer extends StatefulWidget {
  TileContainer(
      {this.sampleModel,
      this.category,
      this.initialSample,
      this.webLayoutPageState,
      this.initialSubItems,
      this.item,
      this.expansionKey,
      this.key})
      : super(key: key);

  SampleModel sampleModel;
  Key key;
  dynamic item;
  dynamic initialSample;
  Categoryy category;
  dynamic initialSubItems;
  _WebLayoutPageState webLayoutPageState;
  ExpansionKey expansionKey;

  @override
  State<StatefulWidget> createState() {
    return TileContainerState();
  }
}

class TileContainerState extends State<TileContainer> {
  @override
  void didUpdateWidget(TileContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
  }

  List<Widget> _getNextLevelChild(
      SampleModel model, dynamic list, String text) {
    final List<Widget> nextLevelChildren = <Widget>[];
    if (list != null && list.isNotEmpty) {
      for (int i = 0; i < list.length; i++) {
        final String status = getStatus(list[i]);
        final bool isNeedSelect = widget.webLayoutPageState.selectSample == null
            ? i == 0 && widget.expansionKey.expansionIndex == 0
            : widget.webLayoutPageState.selectSample == list[i].title;
        nextLevelChildren.add(list[i].type == 'sample'
            ? Material(
                color: model.webBackgroundColor,
                child: HandCursor(
                    child: InkWell(
                        hoverColor: Colors.grey.withOpacity(0.2),
                        onTap: () {
                          final _SampleInputContainerState
                              _sampleInputContainerState = widget
                                  .webLayoutPageState
                                  .sampleInputKey
                                  .currentState;
                          final GlobalKey globalKey =
                              widget.webLayoutPageState.outputContainer.key;
                          final SampleOutputContainerState
                              outputContainerState = globalKey.currentState;
                          if (outputContainerState
                              .outputScaffoldKey.currentState.isEndDrawerOpen) {
                            Navigator.pop(context);
                          }
                          outputContainerState.sample = list[i];
                          outputContainerState.needTabs = false;
                          outputContainerState.orginText = widget
                                  .category
                                  .controlList[widget.category.selectedIndex]
                                  .title +
                              ' > ' +
                              text +
                              ' > ' +
                              list[i].title;
                          widget.webLayoutPageState.selectSample = widget
                              .webLayoutPageState.selectSample = list[i].title;
                          _sampleInputContainerState.refresh();
                          outputContainerState.refresh();
                        },
                        child: Container(
                            color: isNeedSelect
                                ? Colors.grey.withOpacity(0.2)
                                : Colors.transparent,
                            child: Row(children: <Widget>[
                              Container(
                                  width: 5,
                                  alignment: Alignment.centerLeft,
                                  padding:
                                      const EdgeInsets.fromLTRB(1, 10, 10, 10),
                                  color: isNeedSelect
                                      ? model.backgroundColor
                                      : Colors.transparent,
                                  child: const Opacity(
                                      opacity: 0.0, child: Text('1'))),
                              Expanded(
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 10, 10, 10),
                                      child: Text(list[i].title,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontFamily: 'Roboto-Regular',
                                              color: isNeedSelect
                                                  ? model.backgroundColor
                                                  : model.textColor)))),
                              Container(
                                  decoration: BoxDecoration(
                                      color: (status != null && status != '')
                                          ? (status == 'New'
                                              ? const Color.fromRGBO(
                                                  101, 193, 0, 1)
                                              : const Color.fromRGBO(
                                                  245, 166, 35, 1))
                                          : Colors.transparent,
                                      shape: BoxShape.rectangle,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0))),
                                  padding:
                                      const EdgeInsets.fromLTRB(6, 3, 6, 3),
                                  child: Text(status,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.white))),
                              status != null && status != ''
                                  ? const Padding(
                                      padding: EdgeInsets.only(right: 5))
                                  : Container(),
                            ])))))
            : Material(
                color: model.webBackgroundColor,
                child: InkWell(
                  hoverColor: Colors.grey.withOpacity(0.2),
                  child: Container(
                      color: isNeedSelect
                          ? Colors.grey.withOpacity(0.2)
                          : Colors.transparent,
                      child: Row(children: <Widget>[
                        Container(
                            width: 5,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(
                                left: 1, top: 7, bottom: 7),
                            color: isNeedSelect
                                ? model.backgroundColor
                                : Colors.transparent,
                            child:
                                const Opacity(opacity: 0.0, child: Text('1'))),
                        Expanded(
                            child: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(
                                    left: 18, top: 7, bottom: 7),
                                child: Text(list[i].title,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'Roboto-Regular',
                                        color: isNeedSelect
                                            ? model.backgroundColor
                                            : model.textColor)))),
                        status != null && status != ''
                            ? Container(
                                decoration: BoxDecoration(
                                    color: status == 'New'
                                        ? const Color.fromRGBO(101, 193, 0, 1)
                                        : const Color.fromRGBO(245, 166, 35, 1),
                                    shape: BoxShape.rectangle,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0))),
                                padding: const EdgeInsets.fromLTRB(6, 3, 6, 3),
                                child: Text(status,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.white)))
                            : Container(),
                        status != null && status != ''
                            ? const Padding(padding: EdgeInsets.only(right: 5))
                            : Container(),
                      ])),
                  onTap: () {
                    final _SampleInputContainerState
                        _sampleInputContainerState =
                        widget.webLayoutPageState.sampleInputKey.currentState;
                    final GlobalKey globalKey =
                        widget.webLayoutPageState.outputContainer.key;
                    final SampleOutputContainerState outputContainerState =
                        globalKey.currentState;
                    if (list[i].subItems != null &&
                        list[i].subItems.isNotEmpty) {
                      outputContainerState.subItems = list[i].subItems;
                      outputContainerState.sample = list[i].subItems[0];
                      outputContainerState.tabIndex = 0;
                      outputContainerState.needTabs = true;
                    } else {
                      outputContainerState.sample = list[i];
                      outputContainerState.needTabs = false;
                    }
                    if (outputContainerState
                        .outputScaffoldKey.currentState.isEndDrawerOpen) {
                      Navigator.pop(context);
                    }
                    outputContainerState.orginText = widget.category
                            .controlList[widget.category.selectedIndex].title +
                        ' > ' +
                        text +
                        ' > ' +
                        list[i].title;

                    widget.webLayoutPageState
                      ..selectSample = widget.webLayoutPageState.selectSample =
                          list[i].title;
                    _sampleInputContainerState.refresh();
                    outputContainerState.refresh();
                  },
                )));
      }
    }
    return nextLevelChildren;
  }

  @override
  Widget build(BuildContext context) {
    final SampleModel model = widget.sampleModel;
    return HandCursor(
        child: CustomExpansionTile(
      headerBackgroundColor: model.webBackgroundColor,
      onExpansionChanged: (bool value) {
        final _SampleInputContainerState _sampleInputContainerState =
            widget.webLayoutPageState.sampleInputKey.currentState;
        final List<ExpansionKey> expansionKey =
            _sampleInputContainerState.expansionKey;
        for (int k = 0; k < expansionKey.length; k++) {
          if (expansionKey[k].expansionIndex ==
              widget.expansionKey.expansionIndex) {
            expansionKey[k].isExpanded = value;
            break;
          }
        }
      },
      initiallyExpanded: widget.expansionKey.isExpanded,
      title: Text(widget.item.title,
          style: TextStyle(
              color: model.textColor,
              fontSize: 13,
              letterSpacing: -0.19,
              fontFamily: 'Roboto-Medium')),
      key: MediaQuery.of(context).size.width <= 768
          ? PageStorageKey<String>(widget.item.title)
          : UniqueKey(),
      children:
          _getNextLevelChild(model, widget.item.subItems, widget.item.title),
    ));
  }

  void refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
