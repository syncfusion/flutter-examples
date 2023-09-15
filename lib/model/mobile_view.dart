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

  /// Method to get the widget's color based on the widget state
  Color? getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.selected,
    };
    if (states.any(interactiveStates.contains)) {
      return widget.sampleModel!.backgroundColor;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (isInitState) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
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
            checkboxTheme: CheckboxThemeData(
                fillColor: MaterialStateProperty.resolveWith(getColor)),
            brightness: _model.themeData.colorScheme.brightness,
            primaryColor: _model.backgroundColor,
            colorScheme: _model.themeData.colorScheme),
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

                                  if (currentSample != null &&
                                      currentSample!.subItems != null &&
                                      currentSample!.subItems!.length == 1) {
                                    currentSample =
                                        currentSample!.subItems![0] as SubItem;
                                  }

                                  resetLocaleValue(_model, currentSample!);

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
                                              'card') ||
                                      (_category
                                                  .controlList![
                                                      _category.selectedIndex!]
                                                  .subItems[index]
                                                  .type ==
                                              'parent' &&
                                          _category
                                                  .controlList![
                                                      _category.selectedIndex!]
                                                  .subItems[index]
                                                  .subItems[0]
                                                  .displayType ==
                                              'tab');
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
                                  child: SizedBox(
                                    height: 37,
                                    width: 37,
                                    child: IconButton(
                                      icon: Image.asset(
                                          'images/git_hub_mobile.png',
                                          color: Colors.white),
                                      onPressed: () {
                                        launchUrl(Uri.parse(
                                            currentSample!.codeLink!));
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
                                  child: SizedBox(
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
    final List<Widget> tabs = <Widget>[];
    String status;
    for (int i = 0; i < list.length; i++) {
      if (list.isNotEmpty) {
        status = getStatusTag(list[i]);
        tabs.add(Tab(
            child: Row(
          children: <Widget>[
            Text(list[i].title.toString() + (status != '' ? '  ' : ''),
                style: tabView != 'parent'
                    ? const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.normal)
                    : const TextStyle(fontSize: 15, color: Colors.white)),
            if (status == '')
              Container()
            else
              Container(
                height: tabView != 'parent' ? 17 : 20,
                width: tabView != 'parent' ? 17 : 20,
                decoration: BoxDecoration(
                  color: status == 'N'
                      ? const Color.fromRGBO(55, 153, 30, 1)
                      : status == 'U'
                          ? const Color.fromRGBO(246, 117, 0, 1)
                          : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  status,
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

  /// To displaying sample in full screen height,
  /// it doesn't contains expanded view.
  List<Widget> _getFullViewSamples(SampleModel model, List<SubItem> list) {
    final List<Widget> tabs = <Widget>[];
    SubItem sampleDetail;
    bool needsFloatingBotton;
    for (int j = 0; j < list.length; j++) {
      sampleDetail = list[j];
      needsFloatingBotton =
          (sampleDetail.sourceLink != null && sampleDetail.sourceLink != '') ||
              (sampleDetail.needsPropertyPanel ?? false);
      final Function? sampleWidget = model.sampleWidget[list[j].key];
      final SampleView sampleView =
          sampleWidget!(GlobalKey<State>()) as SampleView;

      tabs.add(
        Scaffold(
          backgroundColor: model.cardThemeColor,
          body: sampleView,
          floatingActionButton: needsFloatingBotton
              ? Stack(children: <Widget>[
                  if (sampleDetail.sourceLink != null &&
                      sampleDetail.sourceLink != '')
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: SizedBox(
                          height: 30,
                          width: 230,
                          child: InkWell(
                            onTap: () =>
                                launchUrl(Uri.parse(sampleDetail.sourceLink!)),
                            child: Row(
                              children: <Widget>[
                                Text('Source: ',
                                    style: TextStyle(
                                        fontSize: 16, color: model.textColor)),
                                Text(sampleDetail.sourceText!,
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
                  if (sampleDetail.needsPropertyPanel != true)
                    Container()
                  else
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        heroTag: null,
                        onPressed: () {
                          final GlobalKey sampleKey =
                              sampleView.key! as GlobalKey;
                          final Widget settingsContent =
                              _getSettingsView(sampleKey)!;
                          showBottomSheetSettingsPanel(
                              context, settingsContent);
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

    return tabs;
  }

  Widget? _getSettingsView(GlobalKey sampleKey) {
    final SampleViewState sampleState =
        sampleKey.currentState! as SampleViewState;
    final bool isLocalizationSample =
        sampleKey.currentState! is LocalizationSampleViewState;
    final bool isDirectionalitySample =
        sampleKey.currentState! is DirectionalitySampleViewState;
    if (isLocalizationSample || isDirectionalitySample) {
      return ListView(shrinkWrap: true, children: <Widget>[
        (sampleKey.currentState! as LocalizationSampleViewState)
            .localizationSelectorWidget(context),
        if (isDirectionalitySample)
          (sampleKey.currentState! as DirectionalitySampleViewState)
              .textDirectionSelectorWidget(context)
        else
          Container(),
        sampleState.buildSettings(context) ?? Container()
      ]);
    } else {
      return sampleState.buildSettings(context);
    }
  }

  /// To displaying sample in cards, it contains expanded sample view option.
  List<Widget> _getCardViewSamples(SampleModel model, List<SubItem> list) {
    final List<Widget> tabChildren = <Widget>[];
    Function sampleWidget;
    SampleView sampleView;
    for (int i = 0; i < list.length; i++) {
      tabChildren.add(ListView.builder(
          cacheExtent: (list.length).toDouble(),
          itemCount: list.length,
          itemBuilder: (BuildContext context, int position) {
            final String? status = list[position].status;
            sampleWidget = model.sampleWidget[list[position].key]!;
            sampleView = sampleWidget(GlobalKey<State>()) as SampleView;

            return Container(
              color: model.themeData.colorScheme.brightness == Brightness.dark
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
                                  Row(
                                    children: <Widget>[
                                      Container(
                                          decoration: BoxDecoration(
                                              color: (status != null && status != '')
                                                  ? (status == 'New' ||
                                                          status == 'new'
                                                      ? const Color.fromRGBO(
                                                          55, 153, 30, 1)
                                                      : const Color.fromRGBO(
                                                          246, 117, 0, 1))
                                                  : Colors.transparent,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10.0))),
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 2.7, 5, 2.7),
                                          child: Text(
                                              (status == 'New' ||
                                                      status == 'new')
                                                  ? 'New'
                                                  : (status == 'Updated' ||
                                                          status == 'updated')
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
                                  ),
                                ]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: SizedBox(
                              width: double.infinity,
                              height: 230,
                              child: sampleView),
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

  /// If child type given to control subitems.
  List<Widget> _getChildTabViewChildren(SampleModel model, List<SubItem> list) {
    final List<Widget> tabs = <Widget>[];
    for (int i = 0; i < list.length; i++) {
      if (list[i].subItems!.isNotEmpty) {
        tabs.add(Container(
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
    return tabs;
  }

  /// If parent type given to control's subitem.
  List<Widget> _getParentTabViewChildren(
      SampleModel model, List<SubItem> list) {
    final List<Widget> tabs = <Widget>[];
    for (int i = 0; i < list.length; i++) {
      if (list[i].subItems!.isNotEmpty) {
        tabs.add(Container(
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

    return tabs;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
