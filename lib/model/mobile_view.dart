/// Package imports
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:url_launcher/url_launcher.dart';

/// Local imports
import 'helper.dart';
import 'model.dart';
import 'sample_view.dart';

/// Renders the Mobile layout
class LayoutPage extends StatefulWidget {
  /// Holds the _category, model of the current selected control
  const LayoutPage({this.category, this.sampleModel, Key? key})
      : super(key: key);

  /// Holds the selected control's _category information
  final WidgetCategory? category;

  /// Holds the sampleModel details
  final SampleModel? sampleModel;
  @override
  _LayoutPageState createState() => _LayoutPageState();
}

/// State of mobile layout widget.
class _LayoutPageState extends State<LayoutPage> {
  late SampleModel _model;
  late WidgetCategory _category;
  StateSetter? codeIconChangeSetState;
  StateSetter? infoIconChangeSetState;
  SubItem? currentSample;
  bool isInitState = false;

  @override
  void initState() {
    _model = widget.sampleModel!;
    _category = widget.category!;
    isInitState = true;
    super.initState();
  }

  int _primaryTabIndex = 0;
  int _secondaryTabIndex = 0;
  bool _showIcon = false;

  @override
  Widget build(BuildContext context) {
    if (isInitState) {
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        isInitState = false;
      });
    }
    _showIcon = _category
                .controlList![_category.selectedIndex!].subItems[0].type ==
            'sample' ||
        (_category.controlList![_category.selectedIndex!].subItems[0].type !=
                'parent' &&
            _category.controlList![_category.selectedIndex!].subItems[0]
                    .displayType !=
                'card');
    currentSample = _category
                .controlList![_category.selectedIndex!].subItems[0].type ==
            'sample'
        ? _category.controlList![_category.selectedIndex!].subItems[0]
            as SubItem
        : (_category.controlList![_category.selectedIndex!].subItems[0].type !=
                    'parent' &&
                _category.controlList![_category.selectedIndex!].subItems[0]
                        .displayType !=
                    'card' &&
                _category.controlList![_category.selectedIndex!].subItems[0]
                        .subItems !=
                    null)
            ? _category.controlList![_category.selectedIndex!].subItems[0]
                .subItems[0] as SubItem
            : null;
    return Theme(
        data: ThemeData(
            brightness: _model.themeData.brightness,
            primaryColor: _model.backgroundColor),
        child: SafeArea(
          child: DefaultTabController(
            length: _category
                .controlList![_category.selectedIndex!].subItems.length,
            child: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.maybePop(context, false),
                  ),
                  backgroundColor: _model.paletteColor,
                  bottom: (_category.controlList![_category.selectedIndex!]
                                      .sampleList !=
                                  null &&
                              _category.controlList![_category.selectedIndex!]
                                      .displayType ==
                                  'card') ||
                          _category.controlList![_category.selectedIndex!]
                                  .subItems.length ==
                              1
                      ? null
                      : TabBar(
                          onTap: (int index) {
                            if (index != _primaryTabIndex) {
                              _primaryTabIndex = index;
                              _secondaryTabIndex = 0;
                              if (codeIconChangeSetState != null) {
                                codeIconChangeSetState!(() {
                                  currentSample = _category.controlList![_category.selectedIndex!].subItems[index].type ==
                                          'sample'
                                      ? _category.controlList![_category.selectedIndex!].subItems[index]
                                          as SubItem
                                      : ((_category.controlList![_category.selectedIndex!].subItems[index].type !=
                                                  'parent' &&
                                              _category.controlList![_category.selectedIndex!].subItems[index].displayType !=
                                                  'card' &&
                                              _category
                                                      .controlList![_category
                                                          .selectedIndex!]
                                                      .subItems[index]
                                                      .subItems
                                                      .length ==
                                                  1)
                                          ? _category.controlList![_category.selectedIndex!].subItems[index].subItems[0]
                                              as SubItem
                                          : _category
                                              .controlList![_category.selectedIndex!]
                                              .subItems[index]
                                              .subItems[0] as SubItem);

                                  _showIcon = _category
                                              .controlList![
                                                  _category.selectedIndex!]
                                              .subItems[index]
                                              .type ==
                                          'sample' ||
                                      (_category
                                                  .controlList![
                                                      _category.selectedIndex!]
                                                  .subItems[index]
                                                  .type !=
                                              'parent' &&
                                          _category
                                                  .controlList![
                                                      _category.selectedIndex!]
                                                  .subItems[index]
                                                  .displayType !=
                                              'card');
                                  infoIconChangeSetState!(() {});
                                });
                              }
                            }
                          },
                          indicator: const UnderlineTabIndicator(
                            borderSide: BorderSide(
                                width: 5.0,
                                color: Color.fromRGBO(252, 220, 0, 1)),
                          ),
                          isScrollable: true,
                          tabs: _getTabs(
                              _category.controlList![_category.selectedIndex!]
                                  .subItems,
                              'parent'),
                        ),
                  title: Text(
                      _category.controlList![_category.selectedIndex!].title
                          .toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.white,
                          letterSpacing: 0.3)),
                  actions: ((_category.controlList![_category.selectedIndex!]
                                      .sampleList !=
                                  null &&
                              _category.controlList![_category.selectedIndex!]
                                      .displayType !=
                                  'card') ||
                          (_category.controlList![_category.selectedIndex!]
                                      .childList !=
                                  null &&
                              _category
                                      .controlList![_category.selectedIndex!]
                                      .childList[_primaryTabIndex]
                                      .displayType !=
                                  'card') ||
                          isInitState)
                      ? <Widget>[
                          StatefulBuilder(builder: (BuildContext buildContext,
                              StateSetter setState) {
                            codeIconChangeSetState = setState;
                            return Visibility(
                                visible: _showIcon && currentSample != null,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                  child: Container(
                                    height: 37,
                                    width: 37,
                                    child: IconButton(
                                      icon: Image.asset(
                                          'images/git_hub_mobile.png',
                                          color: Colors.white),
                                      onPressed: () {
                                        launch(currentSample!.codeLink!);
                                      },
                                    ),
                                  ),
                                ));
                          }),
                          StatefulBuilder(builder: (BuildContext buildContext,
                              StateSetter setState) {
                            infoIconChangeSetState = setState;
                            return Visibility(
                                visible: _showIcon &&
                                    currentSample != null &&
                                    currentSample!.description != null &&
                                    currentSample!.description != '',
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    child: IconButton(
                                      icon: const Icon(Icons.info_outline,
                                          color: Colors.white),
                                      onPressed: () {
                                        showBottomInfo(context,
                                            currentSample!.description!);
                                      },
                                    ),
                                  ),
                                ));
                          })
                        ]
                      : null,
                ),
                body: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: (_category.controlList![_category.selectedIndex!]
                                    .sampleList !=
                                null) ||
                            _category.controlList![_category.selectedIndex!]
                                    .subItems.length ==
                                1
                        ? _getSamples(
                            _model,
                            _category.controlList![_category.selectedIndex!]
                                .sampleList,
                            _category.controlList![_category.selectedIndex!]
                                .displayType)
                        : (_category.controlList![_category.selectedIndex!]
                                        .childList !=
                                    null &&
                                _checkSubItemsType(_category
                                    .controlList![_category.selectedIndex!]
                                    .subItems))
                            ? _getChildTabViewChildren(
                                _model,
                                _category.controlList![_category.selectedIndex!]
                                    .childList)
                            : _getParentTabViewChildren(
                                _model,
                                _category.controlList![_category.selectedIndex!]
                                    .subItems))),
          ),
        ));
  }

  /// Returns true, if the list doesn't contain any child type.
  bool _checkSubItemsType(List<SubItem> list) {
    for (int i = 0; i < list.length; i++) {
      if (list[i].type != 'child') {
        return false;
      }
    }
    return true;
  }

  /// Get the samples based on display type
  List<Widget> _getSamples(
          SampleModel model, List<SubItem> list, String? displayType) =>
      displayType == 'card'
          ? _getCardViewSamples(model, list)
          : _getFullViewSamples(model, list);

  /// Get tabs which length is equal to list length
  List<Widget> _getTabs(List<SubItem> list, [String? tabView]) {
    final List<Widget> _tabs = <Widget>[];
    String _status;
    for (int i = 0; i < list.length; i++) {
      if (list.isNotEmpty) {
        _status = getStatusTag(list[i]);
        _tabs.add(Tab(
            child: Row(
          children: <Widget>[
            Text(list[i].title.toString() + (_status != '' ? '  ' : ''),
                style: tabView != 'parent'
                    ? const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.normal)
                    : const TextStyle(fontSize: 15, color: Colors.white)),
            if (_status == '')
              Container()
            else
              Container(
                height: tabView != 'parent' ? 17 : 20,
                width: tabView != 'parent' ? 17 : 20,
                decoration: BoxDecoration(
                  color: _status == 'N'
                      ? const Color.fromRGBO(55, 153, 30, 1)
                      : _status == 'U'
                          ? const Color.fromRGBO(246, 117, 0, 1)
                          : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  _status,
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

  /// To displaying sample in full screen height,
  /// it doesn't contains expanded view.
  List<Widget> _getFullViewSamples(SampleModel model, List<SubItem> list) {
    final List<Widget> _tabs = <Widget>[];
    SubItem _sampleDetail;
    bool _needsFloatingBotton;
    for (int j = 0; j < list.length; j++) {
      _sampleDetail = list[j];
      _needsFloatingBotton = (_sampleDetail.sourceLink != null &&
              _sampleDetail.sourceLink != '') ||
          _sampleDetail.needsPropertyPanel == true;
      final Function? _sampleWidget = model.sampleWidget[list[j].key];
      final SampleView _sampleView =
          _sampleWidget!(GlobalKey<State>()) as SampleView;
      _tabs.add(
        Scaffold(
          backgroundColor: model.cardThemeColor,
          body: Container(child: _sampleView),
          floatingActionButton: _needsFloatingBotton
              ? Stack(children: <Widget>[
                  if (_sampleDetail.sourceLink != null &&
                      _sampleDetail.sourceLink != '')
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Container(
                          height: 50,
                          width: 230,
                          child: InkWell(
                            onTap: () => launch(_sampleDetail.sourceLink!),
                            child: Row(
                              children: <Widget>[
                                Text('Source: ',
                                    style: TextStyle(
                                        fontSize: 16, color: model.textColor)),
                                Text(_sampleDetail.sourceText!,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.blue)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    Container(),
                  if (_sampleDetail.needsPropertyPanel != true)
                    Container()
                  else
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        heroTag: null,
                        onPressed: () {
                          final GlobalKey _sampleKey =
                              _sampleView.key! as GlobalKey;
                          final SampleViewState _sampleState =
                              _sampleKey.currentState! as SampleViewState;
                          final Widget _settingsContent =
                              _sampleState.buildSettings(context)!;
                          showBottomSheetSettingsPanel(
                              context, _settingsContent);
                        },
                        backgroundColor: model.paletteColor,
                        child:
                            const Icon(Icons.graphic_eq, color: Colors.white),
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
  List<Widget> _getCardViewSamples(SampleModel model, List<SubItem> list) {
    final List<Widget> _tabChildren = <Widget>[];
    Function _sampleWidget;
    SampleView _sampleView;
    for (int i = 0; i < list.length; i++) {
      _tabChildren.add(ListView.builder(
          cacheExtent: (list.length).toDouble(),
          addAutomaticKeepAlives: true,
          itemCount: list.length,
          itemBuilder: (BuildContext context, int position) {
            final String? _status = list[position].status;
            _sampleWidget = model.sampleWidget[list[position].key]!;
            _sampleView = _sampleWidget(GlobalKey<State>()) as SampleView;
            return Container(
              color: model.themeData.brightness == Brightness.dark
                  ? Colors.black
                  : const Color.fromRGBO(250, 250, 250, 1),
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
                            onTapExpandSample(context, list[position], model);
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    list[position].title!,
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
                                              color: (_status != null && _status != '')
                                                  ? (_status == 'New' ||
                                                          _status == 'new'
                                                      ? const Color.fromRGBO(
                                                          55, 153, 30, 1)
                                                      : const Color.fromRGBO(
                                                          246, 117, 0, 1))
                                                  : Colors.transparent,
                                              shape: BoxShape.rectangle,
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(10.0))),
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 2.7, 5, 2.7),
                                          child: Text(
                                              (_status == 'New' ||
                                                      _status == 'new')
                                                  ? 'New'
                                                  : (_status == 'Updated' ||
                                                          _status == 'updated')
                                                      ? 'Updated'
                                                      : '',
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
                                child: _sampleView),
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
      if (list[i].subItems!.isNotEmpty) {
        _tabs.add(Container(
          alignment: Alignment.center,
          child: DefaultTabController(
              length: list[i].subItems!.length,
              child: Scaffold(
                  appBar: list[i].displayType == 'card' ||
                          (list[i].displayType != 'card' &&
                              list[i].subItems!.length == 1)
                      ? null
                      : PreferredSize(
                          preferredSize: const Size.fromHeight(46.1),
                          child: AppBar(
                            backgroundColor:
                                const Color.fromRGBO(241, 241, 241, 1),
                            bottom: TabBar(
                              onTap: (int index) {
                                if (_secondaryTabIndex != index &&
                                    codeIconChangeSetState != null) {
                                  codeIconChangeSetState!(() {
                                    _secondaryTabIndex = index;
                                    currentSample =
                                        list[i].subItems![index] as SubItem;
                                    infoIconChangeSetState!(() {});
                                  });
                                }
                              },
                              unselectedLabelColor: Colors.black,
                              labelColor: Colors.blue,
                              indicatorColor: Colors.transparent,
                              indicatorWeight: 0.1,
                              isScrollable: true,
                              tabs:
                                  _getTabs(list[i].subItems! as List<SubItem>),
                            ),
                          )),
                  body: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: _getSamples(
                          model,
                          list[i].subItems! as List<SubItem>,
                          list[i].displayType)))),
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
      if (list[i].subItems!.isNotEmpty) {
        _tabs.add(Container(
          alignment: Alignment.center,
          child: DefaultTabController(
              length: list[i].subItems!.length,
              child: Scaffold(
                  appBar: (list[i].type == 'child' &&
                              list[i].displayType == 'card') ||
                          (list[i].type == 'child' &&
                              list[i].displayType != 'card' &&
                              list[i].subItems!.length == 1)
                      ? null
                      : PreferredSize(
                          preferredSize: const Size.fromHeight(46.1),
                          child: AppBar(
                            backgroundColor:
                                const Color.fromRGBO(241, 241, 241, 1),
                            bottom: TabBar(
                              onTap: (int index) {
                                if (_secondaryTabIndex != index) {
                                  _secondaryTabIndex = index;
                                  codeIconChangeSetState!(() {
                                    _showIcon =
                                        list[i].subItems![index].displayType !=
                                                'card' ||
                                            list[i]
                                                    .subItems![index]
                                                    .subItems
                                                    .length ==
                                                1;
                                    currentSample = _showIcon
                                        ? list[i].subItems![index].subItems[0]
                                            as SubItem
                                        : null;
                                    infoIconChangeSetState!(() {});
                                  });
                                }
                              },
                              unselectedLabelColor: Colors.black,
                              labelColor: Colors.blue,
                              indicatorColor: Colors.transparent,
                              indicatorWeight: 0.1,
                              isScrollable: true,
                              tabs:
                                  _getTabs(list[i].subItems! as List<SubItem>),
                            ),
                          ),
                        ),
                  body: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: list[i].type == 'child'
                          ? _getSamples(
                              model,
                              list[i].subItems! as List<SubItem>,
                              list[i].displayType)
                          : _getChildTabViewChildren(
                              model, list[i].subItems! as List<SubItem>)))),
        ));
      }
    }
    return _tabs;
  }
}
