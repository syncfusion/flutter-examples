/// package imports
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

///Local imports
import '../widgets/expansion_tile.dart';
import '../widgets/search_bar.dart';
import 'helper.dart';
import 'model.dart';
import 'sample_view.dart';

/// Renders web layout
class WebLayoutPage extends StatefulWidget {
  /// Holds the selected control's category, etc.,
  const WebLayoutPage(
      {this.sampleModel, this.category, Key? key, this.subItem, this.routeName})
      : super(key: key);

  /// Holds [SampleModel]
  final SampleModel? sampleModel;

  /// Hold the selected control's category information
  final WidgetCategory? category;

  ///Holds the sample details
  final SubItem? subItem;

  /// holds the route name of sample.
  final String? routeName;

  @override
  _WebLayoutPageState createState() => _WebLayoutPageState();
}

class _WebLayoutPageState extends State<WebLayoutPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey sampleInputKey = GlobalKey<State>();
  GlobalKey sampleOutputKey = GlobalKey<State>();

  late _SampleInputContainer inputContainer;

  late _SampleOutputContainer outputContainer;

  String? selectSample;

  late _Popup popup;

  late SampleModel model;
  late WidgetCategory category;
  late SubItem sample;
  List<SubItem>? subItems;
  late String orginText;

  @override
  void initState() {
    model = widget.sampleModel!;
    category = widget.category!;
    sample = widget.subItem!;
    if (sample.parentIndex != null) {
      orginText = sample.control!.title! +
          ' > ' +
          sample.control!.subItems![sample.parentIndex!].title +
          ' > ' +
          sample.control!.subItems![sample.parentIndex!]
              .subItems[sample.childIndex].title;
    } else {
      if (sample.childIndex != null &&
          (widget.subItem!.control!.subItems![sample.childIndex!]! as SubItem)
                  .subItems!
                  .length >
              1) {
        orginText = sample.control!.title! +
            ' > ' +
            widget.subItem!.control!.subItems![sample.childIndex!].title +
            ' > ' +
            sample.title!;
      } else {
        orginText = sample.control!.title! + ' > ' + sample.title!;
      }
    }

    subItems = sample.parentIndex != null
        ? sample.control!.subItems![sample.parentIndex!]
            .subItems[sample.childIndex].subItems as List<SubItem>
        : null;
    model.addListener(_handleChange);
    super.initState();
  }

  ///Notify the framework by calling this method
  void _handleChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    model.removeListener(_handleChange);
    super.dispose();
  }

  GlobalKey<State> popUpKey = GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    ///Checking the download button is currently hovered
    bool isHoveringDownloadButton = false;

    ///Checking the get package button is currently hovered
    bool isHoveringPubDevButton = false;

    model.currentSampleRoute = SampleRoute(
        // ignore: cast_nullable_to_non_nullable
        globalKey: widget.key as GlobalKey<State>,
        routeName: widget.routeName);
    if (SampleModel.sampleRoutes.isNotEmpty &&
        SampleModel.sampleRoutes.any((SampleRoute element) =>
            element.routeName != model.currentSampleRoute.routeName)) {
      SampleModel.sampleRoutes.add(model.currentSampleRoute);
    }

    return Scaffold(
        key: scaffoldKey,
        drawer: (MediaQuery.of(context).size.width > 768)
            ? Container()
            : SizedBox(
                width: MediaQuery.of(context).size.width *
                    (MediaQuery.of(context).size.width < 500 ? 0.65 : 0.4),
                child: Drawer(
                    key: const PageStorageKey<String>('pagescrollmaintain'),
                    child: Container(
                        color: model.webBackgroundColor,
                        padding: const EdgeInsets.only(top: 5),
                        child: _SampleInputContainer(
                            sampleModel: model,
                            category: category,
                            key: sampleInputKey,
                            webLayoutPageState: this)))),
        endDrawerEnableOpenDragGesture: false,
        endDrawer: showWebThemeSettings(model),
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Container(
              decoration: BoxDecoration(boxShadow: <BoxShadow>[
                BoxShadow(
                  color: model.paletteColor,
                  offset: const Offset(0, 2.0),
                  blurRadius: 0.25,
                )
              ]),
              child: AppBar(
                leading: (MediaQuery.of(context).size.width > 768)
                    ? Container()
                    : IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () {
                          if (outputContainer != null) {
                            final GlobalKey globalKey =
                                outputContainer.key! as GlobalKey;
                            final SampleOutputContainerState
                                outputContainerState = globalKey.currentState!
                                    as SampleOutputContainerState;
                            if (outputContainerState.outputScaffoldKey
                                .currentState!.isEndDrawerOpen) {
                              Navigator.pop(context);
                            }
                          }
                          if (popup != null) {
                            final GlobalKey globalkey = popup.key! as GlobalKey;
                            final _PopupState popupState =
                                globalkey.currentState! as _PopupState;
                            if (popupState.scaffoldKey.currentState != null &&
                                popupState.scaffoldKey.currentState!
                                    .isEndDrawerOpen) {
                              Navigator.pop(context);
                            }
                          }
                          scaffoldKey.currentState!.openDrawer();
                        },
                      ),
                automaticallyImplyLeading:
                    MediaQuery.of(context).size.width <= 768,
                elevation: 0.0,
                backgroundColor: model.paletteColor,
                titleSpacing:
                    MediaQuery.of(context).size.width <= 768 ? 0 : -30,
                title: const Text('Flutter UI Widgets ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        letterSpacing: 0.53,
                        fontFamily: 'Roboto-Medium')),
                actions: <Widget>[
                  if (model.isMobileResolution)
                    const SizedBox(height: 0, width: 9)
                  else
                    SizedBox(
                        child: Container(
                            padding: const EdgeInsets.only(right: 20),
                            width: MediaQuery.of(context).size.width * 0.215,
                            height: MediaQuery.of(context).size.height * 0.0445,
                            child: CustomSearchBar(
                              sampleListModel: model,
                            ))),

                  ///download option
                  if (model.isMobileResolution)
                    Container()
                  else
                    Container(
                        alignment: Alignment.center,
                        child: Container(
                            width: 115,
                            height: 32,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white)),
                            child: StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return MouseRegion(
                                onHover: (PointerHoverEvent event) {
                                  isHoveringDownloadButton = true;
                                  setState(() {});
                                },
                                onExit: (PointerExitEvent event) {
                                  isHoveringDownloadButton = false;
                                  setState(() {});
                                },
                                child: InkWell(
                                  hoverColor: Colors.white,
                                  onTap: () {
                                    launchUrl(Uri.parse(
                                        'https://www.syncfusion.com/downloads/flutter/confirm'));
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 9, 8, 9),
                                    child: Text('DOWNLOAD NOW',
                                        style: TextStyle(
                                            color: isHoveringDownloadButton
                                                ? model.paletteColor
                                                : Colors.white,
                                            fontSize: 12,
                                            fontFamily: 'Roboto-Medium')),
                                  ),
                                ),
                              );
                            }))),

                  ///Get package from pub.dev option
                  if (model.isMobileResolution)
                    Container()
                  else
                    Container(
                        padding: const EdgeInsets.only(left: 12),
                        alignment: Alignment.center,
                        child: Container(
                            width: 118,
                            height: 32,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white)),
                            child: StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return MouseRegion(
                                  onHover: (PointerHoverEvent event) {
                                    isHoveringPubDevButton = true;
                                    setState(() {});
                                  },
                                  onExit: (PointerExitEvent event) {
                                    isHoveringPubDevButton = false;
                                    setState(() {});
                                  },
                                  child: InkWell(
                                    hoverColor: Colors.white,
                                    onTap: () {
                                      launchUrl(Uri.parse(
                                          'https://pub.dev/publishers/syncfusion.com/packages'));
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 7, 8, 7),
                                      child: Row(children: <Widget>[
                                        Image.asset('images/pub_logo.png',
                                            fit: BoxFit.contain,
                                            height: 33,
                                            width: 33),
                                        Text('Get Packages',
                                            style: TextStyle(
                                                color: isHoveringPubDevButton
                                                    ? model.paletteColor
                                                    : Colors.white,
                                                fontSize: 12,
                                                fontFamily: 'Roboto-Medium'))
                                      ]),
                                    ),
                                  ));
                            }))),
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () {
                        if (outputContainer != null) {
                          final GlobalKey globalKey =
                              outputContainer.key! as GlobalKey;
                          final SampleOutputContainerState
                              outputContainerState = globalKey.currentState!
                                  as SampleOutputContainerState;
                          if (outputContainerState.outputScaffoldKey
                              .currentState!.isEndDrawerOpen) {
                            Navigator.pop(context);
                          }
                        }
                        if (popup != null) {
                          final GlobalKey globalkey = popup.key! as GlobalKey;
                          final _PopupState popupState =
                              globalkey.currentState! as _PopupState;
                          if (popupState.scaffoldKey.currentState != null &&
                              popupState
                                  .scaffoldKey.currentState!.isEndDrawerOpen) {
                            Navigator.pop(context);
                          }
                        }
                        scaffoldKey.currentState!.openEndDrawer();
                      },
                    ),
                  ),
                ],
              ),
            )),
        body: Material(
            child: Stack(children: <Widget>[
          Row(
            children: <Widget>[
              if (MediaQuery.of(context).size.width <= 768)
                Container()
              else
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.17,
                    child: inputContainer = _SampleInputContainer(
                        sampleModel: model,
                        category: category,
                        key: sampleInputKey,
                        webLayoutPageState: this)),
              outputContainer = _SampleOutputContainer(
                  sampleModel: model,
                  category: category,
                  initialSample: sample,
                  orginText: orginText,
                  initialSubItems: subItems,
                  key: sampleOutputKey,
                  webLayoutPageState: this)
            ],
          ),
          popup = _Popup(key: popUpKey, show: false)
        ])));
  }
}

///Expansion key for expansion tile container
class _ExpansionKey {
  _ExpansionKey({this.expansionIndex, this.isExpanded, this.globalKey});
  bool? isExpanded;
  int? expansionIndex;
  GlobalKey? globalKey;
}

/// Renders samples titles in list view or in expansion tile,
/// in the left side of the web page
class _SampleInputContainer extends StatefulWidget {
  const _SampleInputContainer(
      {this.sampleModel, this.category, this.webLayoutPageState, this.key})
      : super(key: key);

  final SampleModel? sampleModel;
  final WidgetCategory? category;

  @override
  final Key? key;

  final _WebLayoutPageState? webLayoutPageState;

  @override
  State<StatefulWidget> createState() {
    return _SampleInputContainerState();
  }
}

class _SampleInputContainerState extends State<_SampleInputContainer> {
  late SampleModel sampleModel;
  late WidgetCategory category;

  late List<_ExpansionKey> expansionKey;

  late bool initialRender;

  /// Notify the framework
  void refresh() {
    initialRender = false;
    if (mounted) {
      setState(() {
        /// update the input changes
      });
    }
  }

  @override
  void initState() {
    expansionKey = <_ExpansionKey>[];
    initialRender = true;
    super.initState();
  }

  ///Get the widgets in expansionTile
  Widget _expandedChildren(
      SampleModel model, SubItem item, WidgetCategory category, int index) {
    GlobalKey<State>? currentGlobalKey;
    _ExpansionKey? currentExpansionKey;
    if (initialRender) {
      currentGlobalKey = GlobalKey<State>();
      currentExpansionKey = _ExpansionKey(
          expansionIndex: index,
          isExpanded: index == 0,
          globalKey: currentGlobalKey);
      expansionKey.add(currentExpansionKey);
    } else {
      if (expansionKey.isNotEmpty) {
        for (int i = 0; i < expansionKey.length; i++) {
          if (expansionKey[i].expansionIndex == index) {
            currentExpansionKey = expansionKey[i];
            break;
          }
        }
      }
    }

    late Widget childWidget;
    if (item.subItems != null && item.subItems!.isNotEmpty) {
      if (item.subItems!.length != 1) {
        childWidget = _TileContainer(
            key: currentGlobalKey,
            category: category,
            sampleModel: model,
            expansionKey: currentExpansionKey,
            webLayoutPageState: widget.webLayoutPageState,
            item: item);
      } else {
        final SubItem currentSample = widget.webLayoutPageState!.sample;
        final bool isNeedSelect =
            currentSample.breadCrumbText == item.subItems![0].breadCrumbText;
        childWidget = Material(
            color: model.webBackgroundColor,
            child: InkWell(
              hoverColor: Colors.grey.withOpacity(0.2),
              onTap: () {
                model.isPropertyPanelOpened = true;
                final _SampleInputContainerState sampleInputContainerState =
                    widget.webLayoutPageState!.sampleInputKey.currentState!
                        as _SampleInputContainerState;
                final GlobalKey globalKey = widget
                    .webLayoutPageState!.outputContainer.key! as GlobalKey;
                final SampleOutputContainerState outputContainerState =
                    globalKey.currentState! as SampleOutputContainerState;
                outputContainerState.subItems = item.subItems! as List<SubItem>;
                outputContainerState.sample = item.subItems![0] as SubItem;
                outputContainerState.tabIndex = 0;
                outputContainerState.needTabs = true;
                resetLocaleValue(model, outputContainerState.sample);

                if (outputContainerState
                        .outputScaffoldKey.currentState!.isEndDrawerOpen ||
                    widget.webLayoutPageState!.scaffoldKey.currentState!
                        .isDrawerOpen) {
                  Navigator.pop(context);
                }

                outputContainerState.orginText =
                    widget.webLayoutPageState!.sample.control!.title! +
                        ' > ' +
                        item.subItems![0].title!;

                widget.webLayoutPageState!.selectSample = item.title;
                widget.webLayoutPageState!.sample =
                    item.subItems != null ? item.subItems![0] as SubItem : item;
                if (model.currentSampleKey == null ||
                    (item.key != null
                        ? model.currentSampleKey != item.key
                        : model.currentSampleKey != item.subItems![0].key)) {
                  sampleInputContainerState.refresh();
                  outputContainerState.refresh();
                }
              },
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
                        height: 40,
                        padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                        alignment: Alignment.centerLeft,
                        child: const Opacity(opacity: 0.0, child: Text('1'))),
                    Expanded(
                        child: Container(
                            height: 40,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(
                                left: 11, top: 10, bottom: 10),
                            child: Text(item.subItems![0].title!,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Roboto-Medium',
                                    color: isNeedSelect
                                        ? model.backgroundColor
                                        : model.textColor)))),
                    if (item.subItems![0].status != null &&
                        item.subItems![0].status != '')
                      Container(
                          decoration: BoxDecoration(
                              color: item.subItems![0].status == 'New'
                                  ? const Color.fromRGBO(55, 153, 30, 1)
                                  : const Color.fromRGBO(246, 117, 0, 1),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0))),
                          padding: model.isWeb && model.isMobileResolution
                              ? const EdgeInsets.fromLTRB(3, 1, 3, 5.5)
                              : const EdgeInsets.fromLTRB(5, 2.7, 5, 2.7),
                          child: Text(item.subItems![0].status,
                              style: const TextStyle(
                                  fontSize: 10.5, color: Colors.white)))
                    else
                      Container(),
                    if (item.subItems![0].status != null &&
                        item.subItems![0].status != '')
                      const Padding(padding: EdgeInsets.only(right: 5))
                    else
                      Container(),
                  ])),
            ));
      }
    } else {
      childWidget = Material(
          color: model.webBackgroundColor,
          child: InkWell(
              hoverColor: Colors.grey.withOpacity(0.2),
              onTap: () {
                final GlobalKey globalKey = widget
                    .webLayoutPageState!.outputContainer.key! as GlobalKey;
                final SampleOutputContainerState outputContainerState =
                    globalKey.currentState! as SampleOutputContainerState;
                if (outputContainerState
                        .outputScaffoldKey.currentState!.isEndDrawerOpen ||
                    widget.webLayoutPageState!.scaffoldKey.currentState!
                        .isDrawerOpen) {
                  Navigator.pop(context);
                }
                outputContainerState.sample = item;
                outputContainerState.needTabs = false;
                outputContainerState.orginText =
                    widget.webLayoutPageState!.sample.control!.title! +
                        ' > ' +
                        item.title!;
                if (model.currentSampleKey == null ||
                    model.currentSampleKey != item.key) {
                  outputContainerState.refresh();
                }
              },
              child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                  alignment: Alignment.centerLeft,
                  child: Text(item.title!,
                      style: TextStyle(
                          color: model.textColor,
                          fontSize: 13,
                          fontFamily: 'Roboto-Regular')))));
    }
    return childWidget;
  }

  List<Widget> _getSampleList(SampleModel model, WidgetCategory category) {
    final List<SubItem> list =
        widget.webLayoutPageState!.sample.control!.subItems! as List<SubItem>;
    final List<Widget> children = <Widget>[];
    for (int i = 0; i < list.length; i++) {
      final bool isNeedSelect = widget.webLayoutPageState!.selectSample == null
          ? widget.webLayoutPageState!.sample.breadCrumbText ==
              list[i].breadCrumbText
          : widget.webLayoutPageState!.selectSample == list[i].title;
      children.add(Material(
          color: model.webBackgroundColor,
          child: list[i].type != 'parent' && list[i].type != 'child'
              ? InkWell(
                  hoverColor: Colors.grey.withOpacity(0.2),
                  onTap: () {
                    final _SampleInputContainerState sampleInputContainerState =
                        widget.webLayoutPageState!.sampleInputKey.currentState!
                            as _SampleInputContainerState;
                    final GlobalKey globalKey = widget
                        .webLayoutPageState!.outputContainer.key! as GlobalKey;
                    final SampleOutputContainerState outputContainerState =
                        globalKey.currentState! as SampleOutputContainerState;
                    if (outputContainerState
                            .outputScaffoldKey.currentState!.isEndDrawerOpen ||
                        widget.webLayoutPageState!.scaffoldKey.currentState!
                            .isDrawerOpen) {
                      Navigator.pop(context);
                    }
                    outputContainerState.sample = list[i];
                    outputContainerState.needTabs = false;
                    outputContainerState.orginText =
                        widget.webLayoutPageState!.sample.control!.title! +
                            ' > ' +
                            list[i].title!;
                    widget.webLayoutPageState!.selectSample = list[i].title;
                    resetLocaleValue(model, outputContainerState.sample);
                    if (model.currentSampleKey == null ||
                        (list[i].key != null
                            ? model.currentSampleKey != list[i].key
                            : model.currentSampleKey !=
                                list[i].subItems![0].key)) {
                      sampleInputContainerState.refresh();
                      outputContainerState.refresh();
                    }
                  },
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
                                  list[i].title!,
                                  style: TextStyle(
                                      color: isNeedSelect
                                          ? model.backgroundColor
                                          : model.textColor),
                                ))),
                        if (list[i].status != null &&
                            _getSampleStatus(model, list[i], context))
                          Container(
                              decoration: BoxDecoration(
                                  color: list[i].status!.toLowerCase() == 'new'
                                      ? const Color.fromRGBO(55, 153, 30, 1)
                                      : (list[i].status!.toLowerCase() ==
                                              'updated')
                                          ? const Color.fromRGBO(246, 117, 0, 1)
                                          : Colors.transparent,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              padding: (model.isWeb && model.isMobileResolution)
                                  ? const EdgeInsets.fromLTRB(3, 1, 3, 5.5)
                                  : const EdgeInsets.fromLTRB(5, 2.7, 5, 2.7),
                              child: Text(list[i].status!,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10.5)))
                        else
                          Container(),
                        if (list[i].status != null &&
                            _getSampleStatus(model, list[i], context))
                          const Padding(padding: EdgeInsets.only(right: 5))
                        else
                          Container(),
                      ])),
                )
              : _expandedChildren(model, list[i], category, i)));
    }

    return children;
  }

  /// Checks whether to display the sample status such as new, updated for the incoming sample
  bool _getSampleStatus(
      SampleModel model, SubItem sample, BuildContext context) {
    final Function? sampleView = model.sampleWidget[sample.key];
    final dynamic currentSample = sampleView!(GlobalKey<State>());
    bool? isPlatformSpecified;
    late bool hideStatus;
    try {
      isPlatformSpecified = currentSample.hideSampleStatus != null &&
          currentSample.hideSampleStatus! == true;
      // ignore: empty_catches
    } catch (e) {}
    hideStatus = sample.status != null &&
        (isPlatformSpecified == null || isPlatformSpecified == true);
    return hideStatus;
  }

  Future<void> onTapEvent() async {
    if (SampleModel.sampleRoutes.isNotEmpty) {
      SampleModel.sampleRoutes.removeAt(SampleModel.sampleRoutes.length - 1);
      bool isReplaced = false;
      if (SampleModel.sampleRoutes.isNotEmpty) {
        for (int i = SampleModel.sampleRoutes.length - 1; i >= 0; i--) {
          if (i >= 0 && i <= SampleModel.sampleRoutes.length - 1) {
            final SampleRoute currentSampleRoute = SampleModel.sampleRoutes[i];
            if (sampleModel.currentSampleRoute.routeName! !=
                currentSampleRoute.routeName!) {
              if (currentSampleRoute.routeName != null) {
                SampleModel.sampleRoutes.removeAt(i);
                isReplaced = true;
                await Navigator.of(context)
                    .pushReplacementNamed<dynamic, dynamic>(
                        currentSampleRoute.routeName!);
              }
            }
          }
        }
      }
      if (!isReplaced) {
        if (!mounted) {
          return;
        }
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
      if (MediaQuery.of(context).size.width <= 768) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    sampleModel = widget.sampleModel!;
    category = widget.category!;
    return Container(
        color: sampleModel.webBackgroundColor,
        height: MediaQuery.of(context).size.height - 45,
        width: MediaQuery.of(context).size.width * 0.2,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 5),
              height: 40,
              child: InkWell(
                onTap: () {
                  onTapEvent();
                },
                child: Row(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                    ),
                    Icon(Icons.arrow_back,
                        size: 20, color: sampleModel.backgroundColor),
                    Flexible(
                        child: Container(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(
                              widget.webLayoutPageState!.sample.control!.title!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  color: sampleModel.backgroundColor,
                                  fontSize: 16,
                                  fontFamily: 'Roboto-Medium'),
                            ))),
                    Container(width: 2),
                    const Padding(padding: EdgeInsets.only(top: 5)),
                  ],
                ),
              ),
            ),
            Expanded(
                child:
                    ListView(children: _getSampleList(sampleModel, category)))
          ],
        ));
  }
}

/// sample renders inside of this widget with tabs and without tabs
class _SampleOutputContainer extends StatefulWidget {
  const _SampleOutputContainer(
      {this.sampleModel,
      this.category,
      this.initialSample,
      this.webLayoutPageState,
      this.initialSubItems,
      this.orginText,
      this.key,
      // ignore: unused_element
      this.routes})
      : super(key: key);

  final SampleModel? sampleModel;

  @override
  final Key? key;
  final String? orginText;

  final SubItem? initialSample;
  final WidgetCategory? category;
  final List<SubItem>? initialSubItems;

  final _WebLayoutPageState? webLayoutPageState;

  final Map<String, WidgetBuilder>? routes;

  @override
  State<StatefulWidget> createState() {
    return SampleOutputContainerState();
  }
}

/// state of sample output container
class SampleOutputContainerState extends State<_SampleOutputContainer> {
  /// sample
  late SubItem sample;

  /// List of samples
  late List<SubItem> subItems;

  /// Flag for need Tabs
  bool? needTabs;

  /// Origin text
  late String orginText;

  /// index of tab
  int? tabIndex;

  /// Key of scaffold state
  GlobalKey<ScaffoldState> outputScaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<State> _propertiesPanelKey = GlobalKey<State>();
  late _PropertiesPanel _propertiesPanel;
  late bool _initialRender;
  late GlobalKey<State> _outputKey;
  double _tabTextWidth = 0;
  ScrollController? _controller;
  late StateSetter _setState;
  String? _prevCategory;
  String? _currentCategory;
  double? _prevPosition;
  Size? _prevSize;
  late bool _isMaximized;
  bool? _hasLeftSideScrolled;
  late bool _isLeftScrolled;
  late double _scrollbarWidth;
  late bool _isRightScrolled;
  bool? _hasRightSideScrolled;
  double? _prevScrollExtent;
  late bool _needsPropertyPanel;

  @override
  void initState() {
    _initialRender = true;
    orginText = widget.orginText!;
    _prevCategory = widget.webLayoutPageState != null &&
            widget.webLayoutPageState!.selectSample != null
        ? widget.webLayoutPageState!.selectSample
        : 'Line';
    super.initState();
  }

  void _onTabScroll() {
    _setState(() {
      // ignore: invalid_use_of_protected_member
      if (_controller!.positions.isNotEmpty) {
        _prevPosition = _controller!.position.pixels;
        _prevScrollExtent = _controller!.position.maxScrollExtent;
      } else {
        _prevPosition = null;
        _prevScrollExtent = null;
      }

      _isLeftSideScrolled();
      _isRightSideScrolled();
    });
  }

  /// Notify the framework
  void refresh() {
    _initialRender = false;
    _controller!.removeListener(_onTabScroll);
    _controller!.dispose();
    if (mounted) {
      setState(() {
        /// update the sample and sample details changes
      });
    }
  }

  /// Checks whether the property panel is enabled
  bool _checkPropertyPanelIsEnabled(SampleModel model, SubItem sample,
      _PropertiesPanel propertiesPanel, BuildContext context) {
    final Function? sampleView = model.sampleWidget[sample.key];
    final dynamic currentSample = sampleView!(GlobalKey<State>());
    _needsPropertyPanel = sample.needsPropertyPanel ?? false;
    bool? isPlatformSpecified;
    try {
      isPlatformSpecified = currentSample.needsPropertyPanel != null &&
          currentSample.needsPropertyPanel! == true;
      // ignore: empty_catches
    } catch (e) {}
    _needsPropertyPanel = (sample.needsPropertyPanel ?? false) &&
        (isPlatformSpecified == null || isPlatformSpecified == true);
    return _needsPropertyPanel;
  }

  @override
  void dispose() {
    tabIndex = null;
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller = ScrollController();
    _controller!.addListener(_onTabScroll);
    final SampleModel model = widget.sampleModel!;
    model.webOutputContainerState = this;
    final double width = MediaQuery.of(context).size.width;
    _isMaximized = false;
    if (_prevSize == null) {
      _prevSize = MediaQuery.of(context).size;
    } else {
      if (_prevSize != MediaQuery.of(context).size) {
        _isMaximized = true;
        _prevSize = MediaQuery.of(context).size;
      }
    }
    if (_initialRender && widget.initialSubItems != null) {
      needTabs = true;
      subItems = widget.initialSubItems!;
    }
    if (_currentCategory == null) {
      _currentCategory = widget.webLayoutPageState != null &&
              widget.webLayoutPageState!.selectSample != null
          ? widget.webLayoutPageState!.selectSample
          : 'Line';
    } else {
      if (widget.webLayoutPageState != null &&
          widget.webLayoutPageState!.selectSample != null &&
          _currentCategory != widget.webLayoutPageState!.selectSample) {
        _prevCategory = _currentCategory;
        _currentCategory = widget.webLayoutPageState!.selectSample;
      }
    }
    final SubItem sampleSubItem =
        (_initialRender ? widget.initialSample : sample)!;
    _propertiesPanel =
        _PropertiesPanel(sampleModel: model, key: _propertiesPanelKey);
    _tabTextWidth = 0;
    final List<Widget>? tabs =
        (needTabs ?? false) && subItems.length > 1 ? _getTabs(subItems) : null;
    _scrollbarWidth = width *
        ((model.isMobileResolution && width > 600)
            ? 0.75
            : (width <= 500
                ? 0.585
                : width < 890
                    ? 0.58
                    : 0.65));
    final List<bool> isSelected = <bool>[true];
    _isLeftSideScrolled();
    _isRightSideScrolled();

    model.isPropertyPanelTapped = false;
    List<TextSpan>? textSpans;
    TextSpan? textSpan;
    if (sampleSubItem.description != null && sampleSubItem.description != '') {
      textSpans = getTextSpan(sampleSubItem.description!, model);
      textSpan = textSpans[0];
      textSpans.removeAt(0);
    }

    return Theme(
      data: ThemeData(
          brightness: model.themeData.colorScheme.brightness,
          primaryColor: model.backgroundColor,
          colorScheme: model.themeData.colorScheme),
      child: Expanded(
          child: Container(
              color: model.webOutputContainerColor,
              padding: const EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,

                      ///Space added for avoiding text hide issue of the
                      ///string having `infinite` word
                      child: Text(sampleSubItem.title! + ' ',
                          style: TextStyle(
                              color: model.textColor,
                              letterSpacing: 0.39,
                              fontSize: 18,
                              fontFamily: 'Roboto-Medium'))),
                  Container(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                          (needTabs ?? false) && subItems.length != 1
                              ? orginText + ' > ' + sampleSubItem.title!
                              : orginText,
                          style: TextStyle(
                              color: model.textColor.withOpacity(0.65),
                              letterSpacing: 0.3,
                              fontFamily: 'Roboto-Regular'))),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  Expanded(
                      child: Scaffold(
                          backgroundColor: model.webOutputContainerColor,
                          key: outputScaffoldKey,
                          endDrawerEnableOpenDragGesture: false,
                          endDrawer: _checkPropertyPanelIsEnabled(model,
                                  sampleSubItem, _propertiesPanel, context)
                              ? _propertiesPanel
                              : null,
                          body: (needTabs ?? false)
                              ? DefaultTabController(
                                  initialIndex: (tabIndex ??
                                      widget.webLayoutPageState!.sample
                                          .sampleIndex)!,
                                  key: UniqueKey(),
                                  length: subItems.length,
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: model.webOutputContainerColor,
                                        border: Border.all(
                                            color: (model.themeData.colorScheme
                                                        .brightness ==
                                                    Brightness.light
                                                ? Colors.grey[300]
                                                : Colors.transparent)!),
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
                                                        color:
                                                            model.dividerColor,
                                                        width: 0.8)),
                                              ),
                                              padding: width < 500
                                                  ? const EdgeInsets.fromLTRB(
                                                      2, 5, 2, 0)
                                                  : const EdgeInsets.fromLTRB(
                                                      5, 0, 10, 0),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    StatefulBuilder(builder:
                                                        (BuildContext context,
                                                            StateSetter
                                                                stateSetter) {
                                                      _setState = stateSetter;
                                                      return SizedBox(
                                                        width: _scrollbarWidth,
                                                        child: Stack(
                                                          children: <Widget>[
                                                            Padding(
                                                                padding: EdgeInsets.only(
                                                                    left:
                                                                        _isLeftScrolled
                                                                            ? 2
                                                                            : 0),
                                                                child: ScrollConfiguration(
                                                                    behavior: ScrollConfiguration.of(context).copyWith(dragDevices: <PointerDeviceKind>{
                                                                      PointerDeviceKind
                                                                          .touch,
                                                                      PointerDeviceKind
                                                                          .mouse,
                                                                    }),
                                                                    child: SingleChildScrollView(
                                                                        controller: _controller,
                                                                        key: PageStorageKey<String>((subItems.isNotEmpty ? subItems[0].title! : '') + 'tabscroll'),
                                                                        scrollDirection: Axis.horizontal,
                                                                        child: Material(
                                                                            color: model.webInputColor,
                                                                            child: InkWell(
                                                                                hoverColor: model.paletteColor.withOpacity(0.3),
                                                                                child: subItems.length == 1
                                                                                    ? Container()
                                                                                    : Padding(
                                                                                        padding: const EdgeInsets.only(left: 25, right: 30),
                                                                                        child: TabBar(
                                                                                          indicatorPadding: const EdgeInsets.only(left: 2, right: 2),
                                                                                          indicatorColor: model.backgroundColor,
                                                                                          onTap: (int value) {
                                                                                            model.isPropertyPanelOpened = true;
                                                                                            widget.sampleModel!.needToMaximize = false;
                                                                                            final GlobalKey globalKey = widget.webLayoutPageState!.outputContainer.key! as GlobalKey;
                                                                                            final SampleOutputContainerState outputContainerState = globalKey.currentState! as SampleOutputContainerState;
                                                                                            outputContainerState.sample = subItems[value];
                                                                                            outputContainerState.needTabs = true;
                                                                                            outputContainerState.subItems = subItems;
                                                                                            outputContainerState.tabIndex = value;
                                                                                            if (model.currentSampleKey == null || model.currentSampleKey != outputContainerState.sample.key) {
                                                                                              outputContainerState.refresh();
                                                                                            }
                                                                                          },
                                                                                          labelColor: model.backgroundColor,
                                                                                          unselectedLabelColor: model.themeData.colorScheme.brightness == Brightness.dark ? Colors.white : const Color.fromRGBO(89, 89, 89, 1),
                                                                                          isScrollable: true,
                                                                                          tabs: tabs!,
                                                                                        ))))))),
                                                            if (_scrollbarWidth +
                                                                    10 <
                                                                _tabTextWidth)
                                                              Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            gradient:
                                                                                LinearGradient(
                                                                      colors: <Color>[
                                                                        model
                                                                            .webInputColor
                                                                            .withOpacity(0.21),
                                                                        model
                                                                            .webInputColor
                                                                            .withOpacity(1.0)
                                                                      ],
                                                                      stops: const <double>[
                                                                        0.0,
                                                                        0.7
                                                                      ],
                                                                    )),
                                                                    width: 55,
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                  ))
                                                            else
                                                              SizedBox.fromSize(
                                                                  size: Size
                                                                      .zero),
                                                            if (_scrollbarWidth +
                                                                    10 <
                                                                _tabTextWidth)
                                                              Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  child:
                                                                      Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    child: Material(
                                                                        shape: const CircleBorder(),
                                                                        clipBehavior: Clip.hardEdge,
                                                                        child: InkWell(
                                                                            hoverColor: _isRightScrolled ? Colors.grey.withOpacity(0.3) : Colors.transparent,
                                                                            highlightColor: _isRightScrolled ? Colors.transparent : null,
                                                                            splashColor: _isRightScrolled ? Colors.transparent : null,
                                                                            focusColor: _isRightScrolled ? Colors.transparent : null,
                                                                            onTap: () {
                                                                              if (_controller!.position.maxScrollExtent > _controller!.position.pixels + 12) {
                                                                                _controller!.animateTo(_controller!.position.pixels + 150, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
                                                                              }
                                                                              stateSetter(() {});
                                                                            },
                                                                            child: Ink(
                                                                                decoration: BoxDecoration(
                                                                                  color: model.webInputColor,
                                                                                  border: Border.all(color: Colors.transparent, width: 6),
                                                                                  shape: BoxShape.circle,
                                                                                ),
                                                                                child: SizedBox(
                                                                                  height: 18,
                                                                                  width: 18,
                                                                                  child: Image.asset('images/scroll_arrow.png',
                                                                                      // ignore: invalid_use_of_protected_member
                                                                                      color: _isRightScrolled ? model.textColor : model.textColor.withOpacity(0.5),
                                                                                      fit: BoxFit.contain),
                                                                                )))),
                                                                  ))
                                                            else
                                                              SizedBox.fromSize(
                                                                  size: Size
                                                                      .zero),
                                                            if (_scrollbarWidth +
                                                                    10 <
                                                                _tabTextWidth)
                                                              Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            gradient:
                                                                                LinearGradient(
                                                                      colors: <Color>[
                                                                        model
                                                                            .webInputColor
                                                                            .withOpacity(1.0),
                                                                        model
                                                                            .webInputColor
                                                                            .withOpacity(1.0),
                                                                        model
                                                                            .webInputColor
                                                                            .withOpacity(0.21),
                                                                      ],
                                                                      stops: const <double>[
                                                                        0.0,
                                                                        0.5,
                                                                        0.9
                                                                      ],
                                                                    )),
                                                                    width: 55,
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                  ))
                                                            else
                                                              SizedBox.fromSize(
                                                                  size: Size
                                                                      .zero),
                                                            if (_scrollbarWidth +
                                                                    10 <
                                                                _tabTextWidth)
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Material(
                                                                    shape:
                                                                        const CircleBorder(),
                                                                    clipBehavior:
                                                                        Clip.hardEdge,
                                                                    child: InkWell(
                                                                        hoverColor: _isLeftScrolled ? Colors.grey.withOpacity(0.3) : Colors.transparent,
                                                                        highlightColor: _isLeftScrolled ? Colors.transparent : null,
                                                                        splashColor: _isLeftScrolled ? Colors.transparent : null,
                                                                        focusColor: _isLeftScrolled ? Colors.transparent : null,
                                                                        onTap: () {
                                                                          if (_controller!.position.pixels !=
                                                                              0) {
                                                                            _controller!.animateTo(_controller!.position.pixels - 150,
                                                                                duration: const Duration(milliseconds: 250),
                                                                                curve: Curves.easeOut);
                                                                          }
                                                                          stateSetter(
                                                                              () {});
                                                                        },
                                                                        child: Ink(
                                                                            decoration: BoxDecoration(
                                                                              color: model.webInputColor,
                                                                              border: Border.all(color: Colors.transparent, width: 6),
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                            child: SizedBox(
                                                                              height: 18,
                                                                              width: 18,
                                                                              child: Image.asset('images/scroll-arrow-left.png',
                                                                                  // ignore: invalid_use_of_protected_member
                                                                                  color: _isLeftScrolled ? model.textColor : model.textColor.withOpacity(0.5),
                                                                                  fit: BoxFit.contain),
                                                                            )))),
                                                              )
                                                            else
                                                              SizedBox.fromSize(
                                                                  size: Size
                                                                      .zero),
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          Flexible(
                                                            child: Material(
                                                                shape:
                                                                    const CircleBorder(),
                                                                clipBehavior: Clip
                                                                    .hardEdge,
                                                                child: InkWell(
                                                                    hoverColor: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.3),
                                                                    onTap: () {
                                                                      launchUrl(
                                                                          Uri.parse(
                                                                              sampleSubItem.codeLink!));
                                                                    },
                                                                    child: Tooltip(
                                                                        message: 'Code',
                                                                        child: Ink(
                                                                            decoration: BoxDecoration(
                                                                              color: model.webInputColor,
                                                                              border: Border.all(color: Colors.transparent, width: 6),
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                            child: SizedBox(
                                                                                height: 21,
                                                                                width: 21,
                                                                                child: Image.asset(
                                                                                  model.themeData.colorScheme.brightness == Brightness.dark ? 'images/git_hub_dark.png' : 'images/git_hub.png',
                                                                                  fit: BoxFit.contain,
                                                                                )))))),
                                                          ),
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: width <
                                                                              500
                                                                          ? 3
                                                                          : 6)),
                                                          Flexible(
                                                            child: Material(
                                                              shape:
                                                                  const CircleBorder(),
                                                              clipBehavior:
                                                                  Clip.hardEdge,
                                                              child: InkWell(
                                                                  hoverColor: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.3),
                                                                  onTap: () {
                                                                    performMaximize(
                                                                        model,
                                                                        sampleSubItem);
                                                                  },
                                                                  child: Tooltip(
                                                                      message: 'Maximize',
                                                                      child: Ink(
                                                                          decoration: BoxDecoration(
                                                                            color:
                                                                                model.webInputColor,
                                                                            border:
                                                                                Border.all(color: Colors.transparent, width: 4),
                                                                            shape:
                                                                                BoxShape.circle,
                                                                          ),
                                                                          child: Transform.scale(
                                                                            scale:
                                                                                0.85,
                                                                            child:
                                                                                Icon(Icons.open_in_full, color: model.webIconColor),
                                                                          )))),
                                                            ),
                                                          ),
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: width <
                                                                              500
                                                                          ? 3
                                                                          : 6)),
                                                          Flexible(
                                                            child:
                                                                _needsPropertyPanel
                                                                    ? StatefulBuilder(builder: (BuildContext
                                                                            context,
                                                                        StateSetter
                                                                            stateSetter) {
                                                                        return Material(
                                                                            color: model
                                                                                .webInputColor,
                                                                            shape:
                                                                                const CircleBorder(),
                                                                            clipBehavior:
                                                                                Clip.hardEdge,
                                                                            child: ToggleButtons(
                                                                                constraints: const BoxConstraints(minHeight: 30, minWidth: 30),
                                                                                fillColor: Colors.grey.withOpacity(0.3),
                                                                                splashColor: Colors.grey.withOpacity(0.3),
                                                                                borderColor: Colors.transparent,
                                                                                isSelected: isSelected,
                                                                                hoverColor: Colors.grey.withOpacity(0.3),
                                                                                onPressed: (int index) {
                                                                                  isSelected[index] = !isSelected[index];
                                                                                  if (MediaQuery.of(context).size.width > 720) {
                                                                                    stateSetter(() {
                                                                                      model.isPropertyPanelOpened = !model.isPropertyPanelOpened;
                                                                                      if (!model.isPropertyPanelOpened) {
                                                                                        model.isPropertyPanelTapped = true;
                                                                                      }
                                                                                      final _OutputContainerState outputContainerState = model.outputContainerState as _OutputContainerState;
                                                                                      outputContainerState.propertyPanelStateChange(() {
                                                                                        outputContainerState.show = model.isPropertyPanelOpened;
                                                                                      });
                                                                                    });
                                                                                  } else {
                                                                                    outputScaffoldKey.currentState!.openEndDrawer();
                                                                                  }
                                                                                },
                                                                                children: <Widget>[
                                                                                  Tooltip(
                                                                                    message: MediaQuery.of(context).size.width <= 720 || !model.isPropertyPanelOpened ? 'Open Property Panel' : 'Close Property Panel',
                                                                                    child: Icon(Icons.menu, color: model.webIconColor),
                                                                                  )
                                                                                ]));
                                                                      })
                                                                    : SizedBox.fromSize(
                                                                        size: Size
                                                                            .zero),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ])),
                                          Expanded(
                                              child: Container(
                                            color: model.cardThemeColor,
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
                                        color: (model.themeData.colorScheme
                                                    .brightness ==
                                                Brightness.light
                                            ? Colors.grey[300]
                                            : Colors.transparent)!),
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
                                                  color: model.dividerColor,
                                                  width: 0.8)),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Flexible(
                                              child: Material(
                                                  shape: const CircleBorder(),
                                                  clipBehavior: Clip.hardEdge,
                                                  child: InkWell(
                                                      hoverColor: Colors.grey
                                                          .withOpacity(0.3),
                                                      onTap: () {
                                                        launchUrl(Uri.parse(
                                                            sampleSubItem
                                                                .codeLink!));
                                                      },
                                                      child: Tooltip(
                                                          message: 'Code',
                                                          child: Ink(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: model
                                                                    .webInputColor,
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .transparent,
                                                                    width: 6),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: SizedBox(
                                                                  height: 21,
                                                                  width: 21,
                                                                  child: Image
                                                                      .asset(
                                                                    model.themeData.colorScheme.brightness ==
                                                                            Brightness.dark
                                                                        ? 'images/git_hub_dark.png'
                                                                        : 'images/git_hub.png',
                                                                    fit: BoxFit
                                                                        .contain,
                                                                  )))))),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: width < 500 ? 3 : 6)),
                                            Flexible(
                                              child: Material(
                                                shape: const CircleBorder(),
                                                clipBehavior: Clip.hardEdge,
                                                child: InkWell(
                                                    hoverColor: Colors.grey
                                                        .withOpacity(0.3),
                                                    onTap: () {
                                                      performMaximize(
                                                          model, sampleSubItem);
                                                    },
                                                    child: Tooltip(
                                                        message: 'Maximize',
                                                        child: Ink(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: model
                                                                  .webInputColor,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .transparent,
                                                                  width: 4),
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child:
                                                                Transform.scale(
                                                              scale: 0.85,
                                                              child: Icon(
                                                                  Icons
                                                                      .open_in_full,
                                                                  color: model
                                                                      .webIconColor),
                                                            )))),
                                              ),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: width < 500 ? 3 : 6)),
                                            Flexible(
                                              child: _needsPropertyPanel
                                                  ? StatefulBuilder(builder:
                                                      (BuildContext context,
                                                          StateSetter
                                                              stateSetter) {
                                                      return Material(
                                                          color: model
                                                              .webInputColor,
                                                          shape:
                                                              const CircleBorder(),
                                                          clipBehavior:
                                                              Clip.hardEdge,
                                                          child: ToggleButtons(
                                                              constraints:
                                                                  const BoxConstraints(
                                                                      minHeight:
                                                                          30,
                                                                      minWidth:
                                                                          30),
                                                              fillColor: Colors
                                                                  .grey
                                                                  .withOpacity(
                                                                      0.3),
                                                              splashColor: Colors.grey
                                                                  .withOpacity(
                                                                      0.3),
                                                              borderColor: Colors
                                                                  .transparent,
                                                              isSelected:
                                                                  isSelected,
                                                              hoverColor: Colors
                                                                  .grey
                                                                  .withOpacity(
                                                                      0.3),
                                                              onPressed:
                                                                  (int index) {
                                                                isSelected[
                                                                        index] =
                                                                    !isSelected[
                                                                        index];
                                                                if (MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width >
                                                                    720) {
                                                                  stateSetter(
                                                                      () {
                                                                    model.isPropertyPanelOpened =
                                                                        !model
                                                                            .isPropertyPanelOpened;
                                                                    if (!model
                                                                        .isPropertyPanelOpened) {
                                                                      model.isPropertyPanelTapped =
                                                                          true;
                                                                    }
                                                                    final _OutputContainerState
                                                                        outputContainerState =
                                                                        model.outputContainerState
                                                                            as _OutputContainerState;
                                                                    outputContainerState
                                                                        .propertyPanelStateChange(
                                                                            () {
                                                                      outputContainerState
                                                                              .show =
                                                                          model
                                                                              .isPropertyPanelOpened;
                                                                    });
                                                                  });
                                                                } else {
                                                                  outputScaffoldKey
                                                                      .currentState!
                                                                      .openEndDrawer();
                                                                }
                                                              },
                                                              children: <Widget>[
                                                                Tooltip(
                                                                  message: MediaQuery.of(context).size.width <=
                                                                              720 ||
                                                                          !model
                                                                              .isPropertyPanelOpened
                                                                      ? 'Open Property Panel'
                                                                      : 'Close Property Panel',
                                                                  child: Icon(
                                                                      Icons
                                                                          .menu,
                                                                      color: model
                                                                          .webIconColor),
                                                                )
                                                              ]));
                                                    })
                                                  : SizedBox.fromSize(
                                                      size: Size.zero),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          child: Container(
                                              color: model.cardThemeColor,
                                              child: _OutputContainer(
                                                  key: GlobalKey(),
                                                  sampleOutputContainerState:
                                                      this,
                                                  subItem: sampleSubItem,
                                                  sampleView:
                                                      model.sampleWidget[
                                                          sampleSubItem.key],
                                                  sampleModel: model))),
                                    ],
                                  )))),
                  if (sampleSubItem.description != null &&
                      sampleSubItem.description != '')
                    Container(
                        padding: const EdgeInsets.only(left: 10, top: 18),
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            text: textSpan!.text,
                            style: TextStyle(
                              color: model.textColor,
                              fontFamily: 'Roboto-Regular',
                              letterSpacing: 0.3,
                            ),
                            children: textSpans,
                          ),
                        ))
                  else
                    Container(),
                ],
              ))),
    );
  }

  /// To check whether the scroll has done in left side
  bool _isLeftSideScrolled() {
    if (_isMaximized) {
      _isLeftScrolled = _hasLeftSideScrolled!;
    }
    // ignore: invalid_use_of_protected_member
    if ((_scrollbarWidth + 10 < _tabTextWidth) &&
            // ignore: invalid_use_of_protected_member
            (_controller!.positions.isNotEmpty &&
                _controller!.position.pixels > 25) ||
        (_prevCategory == _currentCategory &&
            _prevPosition != null &&
            _prevPosition! > 25)) {
      _isLeftScrolled = true;
    } else {
      _isLeftScrolled = false;
    }

    _hasLeftSideScrolled = _isLeftScrolled;
    return _isLeftScrolled;
  }

  /// To check whether the scroll has done in right side
  bool _isRightSideScrolled() {
    if (_isMaximized) {
      _isRightScrolled = _hasRightSideScrolled!;
      _isMaximized = false;
    }

    if (_scrollbarWidth + 10 < _tabTextWidth &&
        // ignore: invalid_use_of_protected_member
        ((_controller!.positions.isNotEmpty &&
                (_controller!.position.pixels -
                            _controller!.position.maxScrollExtent)
                        .abs() >
                    25) ||
            (_prevCategory == _currentCategory &&
                _prevPosition != null &&
                (_prevPosition! - _prevScrollExtent!).abs() > 25) ||
            // ignore: invalid_use_of_protected_member
            (_controller!.positions.isEmpty &&
                (_prevPosition == null ||
                    _prevCategory != _currentCategory)))) {
      _isRightScrolled = true;
    } else {
      _isRightScrolled = false;
    }

    if (_prevCategory != _currentCategory) {
      _prevCategory = _currentCategory;
    }

    _hasRightSideScrolled = _isRightScrolled;
    return _isRightScrolled;
  }

  /// Method to maximize sample
  void performMaximize(SampleModel model, SubItem sample) {
    model.needToMaximize = true;
    if (model.isPropertyPanelTapped) {
      model.isPropertyPanelTapped = false;
    }
    final _PopupState state =
        widget.webLayoutPageState!.popUpKey.currentState! as _PopupState;
    state._sampleDetails = sample;
    state._currentWidgetKey = model.currentRenderSample.key as GlobalKey;
    final _OutputContainerState outputContainerState =
        _outputKey.currentState! as _OutputContainerState;
    outputContainerState.setState(() {});
    state.refresh(true);
  }

  Size _measureTextSize(String textValue, TextStyle textStyle) {
    final TextPainter textPainter = TextPainter(
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        text: TextSpan(text: textValue, style: textStyle));
    textPainter.layout();
    return Size(textPainter.width, textPainter.height);
  }

  /// Get tabs which length is equal to list length
  List<Widget> _getTabs(List<SubItem> list) {
    final List<Widget> tabs = <Widget>[];
    _tabTextWidth = 0;
    for (int i = 0; i < list.length; i++) {
      if (list.isNotEmpty) {
        final String status = getStatusTag(list[i]);
        _tabTextWidth += _measureTextSize(
                    list[i].title.toString() + (status != '' ? '  ' : ''),
                    const TextStyle(
                        letterSpacing: 0.5, fontFamily: 'Roboto-Medium'))
                .width +
            _measureTextSize(
                    status == 'New'
                        ? 'N'
                        : status == 'Updated'
                            ? 'U'
                            : '',
                    const TextStyle(fontSize: 11, color: Colors.white))
                .width +
            32 /*labelPadding*/;
        tabs.add(Tab(
            child: Row(
          children: <Widget>[
            Text(list[i].title.toString() + (status != '' ? '  ' : ''),
                style: const TextStyle(
                    letterSpacing: 0.5, fontFamily: 'Roboto-Medium')),
            if (status == '')
              Container()
            else
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: status == 'New'
                      ? const Color.fromRGBO(55, 153, 30, 1)
                      : status == 'Updated'
                          ? const Color.fromRGBO(246, 117, 0, 1)
                          : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  status == 'New'
                      ? 'N'
                      : status == 'Updated'
                          ? 'U'
                          : '',
                  style: const TextStyle(fontSize: 11, color: Colors.white),
                ),
              ),
          ],
        )));
      }
    }
    return tabs;
  }

  /// Get tab view widgets which length is equal to list length
  List<Widget> _getTabViewChildren(SampleModel model, List<SubItem> list) {
    final List<Widget> tabChildren = <Widget>[];
    for (int i = 0; i < list.length; i++) {
      tabChildren.add(
        Container(
            color: model.cardThemeColor,
            child: _OutputContainer(
                key: GlobalKey(),
                sampleOutputContainerState: this,
                sampleModel: model,
                subItem: list[i],
                sampleView: model.sampleWidget[list[i].key])),
      );
    }

    return tabChildren;
  }
}

/// Output sample renders inside of this widget
class _OutputContainer extends StatefulWidget {
  const _OutputContainer(
      {this.sampleModel,
      this.key,
      this.subItem,
      this.sampleView,
      this.sampleOutputContainerState})
      : super(key: key);

  final SampleModel? sampleModel;

  @override
  final Key? key;

  final SubItem? subItem;

  final Function? sampleView;

  final SampleOutputContainerState? sampleOutputContainerState;

  @override
  State<StatefulWidget> createState() {
    return _OutputContainerState();
  }
}

class _OutputContainerState extends State<_OutputContainer> {
  _OutputContainerState();
  late GlobalKey<State>? renderOutputKey;

  Widget? renderWidget;

  late StateSetter propertyPanelStateChange;

  bool show = true;

  GlobalKey<State> propertyPanelWidgetKey = GlobalKey<State>();

  @override
  void initState() {
    renderOutputKey = GlobalKey<State>();
    super.initState();
  }

  late bool _needsPropertyPanel;

  /// Checks whether the property panel is enabled
  bool _checkPropertyPanelIsEnabled(SampleModel model, BuildContext context) {
    final Function? sampleView = model.sampleWidget[widget.subItem!.key];
    final dynamic currentSample = sampleView!(GlobalKey<State>());
    _needsPropertyPanel = widget.subItem!.needsPropertyPanel ?? false;
    bool? isPlatformSpecified;
    try {
      isPlatformSpecified = currentSample.needsPropertyPanel != null &&
          currentSample.needsPropertyPanel! == true;
      // ignore: empty_catches
    } catch (e) {}
    _needsPropertyPanel = (widget.subItem!.needsPropertyPanel ?? false) &&
        (isPlatformSpecified == null || isPlatformSpecified == true);
    return _needsPropertyPanel;
  }

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
    _checkPropertyPanelIsEnabled(widget.sampleModel!, context);
    widget.sampleModel!.outputContainerState = this;
    widget.sampleOutputContainerState!._outputKey = widget.key! as GlobalKey;
    widget.sampleModel!.oldWindowSize =
        widget.sampleModel!.oldWindowSize == null
            ? MediaQuery.of(context).size
            : widget.sampleModel!.currentWindowSize;

    widget.sampleModel!.currentWindowSize = MediaQuery.of(context).size;
    if (widget.sampleModel!.oldWindowSize!.width !=
            widget.sampleModel!.currentWindowSize.width ||
        widget.sampleModel!.oldWindowSize!.height !=
            widget.sampleModel!.currentWindowSize.height) {
      widget.sampleModel!.currentSampleKey = widget.subItem!.key;
      return widget.sampleModel!.needToMaximize
          ? Container()
          : StatefulBuilder(
              builder: (BuildContext context, StateSetter stateSetter) {
              propertyPanelStateChange = stateSetter;
              return Row(children: <Widget>[
                Expanded(
                    child: Column(
                  children: <Widget>[
                    Expanded(child: widget.sampleModel!.currentRenderSample),
                    if (widget.subItem!.sourceLink != null &&
                        widget.subItem!.sourceLink != '')
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          height: 20,
                          child: Row(
                            children: <Widget>[
                              Text(
                                'Source: ',
                                style: TextStyle(
                                    color: widget.sampleModel!.textColor
                                        .withOpacity(0.65),
                                    fontSize: 12),
                              ),
                              InkWell(
                                onTap: () => launchUrl(
                                    Uri.parse(widget.subItem!.sourceLink!)),
                                child: Text(widget.subItem!.sourceText!,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.blue)),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Container()
                  ],
                )),
                if (_needsPropertyPanel &&
                    MediaQuery.of(context).size.width > 720 &&
                    (widget.sampleModel!.isPropertyPanelOpened ||
                        (!widget.sampleModel!.isPropertyPanelOpened &&
                            widget.sampleModel!.isPropertyPanelTapped)))
                  _PropertiesPanel(
                    sampleModel: widget.sampleModel,
                    key: propertyPanelWidgetKey,
                    openState: true,
                  )
                else
                  Container()
              ]);
            });
    } else {
      widget.sampleModel!.currentRenderSample =
          renderWidget ?? widget.sampleView!(GlobalKey<State>());
      renderWidget = null;
      widget.sampleModel!.propertyPanelKey =
          widget.sampleModel!.currentRenderSample.key as GlobalKey;
      widget.sampleModel!.currentSampleKey = widget.subItem!.key;
      return ClipRect(
          child: MaterialApp(
              debugShowCheckedModeBanner: false,
              //ignore: always_specify_types
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                SfGlobalLocalizations.delegate
              ],
              //ignore: always_specify_types
              supportedLocales: const [
                Locale('en', 'US'),
                Locale('ar', 'AE'),
              ],
              locale: const Locale('en', 'US'),
              theme: ThemeData(
                  checkboxTheme: CheckboxThemeData(
                      fillColor: MaterialStateProperty.resolveWith(getColor)),
                  brightness:
                      widget.sampleModel!.themeData.colorScheme.brightness,
                  primaryColor: widget.sampleModel!.backgroundColor,
                  colorScheme: widget.sampleModel!.themeData.colorScheme),
              initialRoute: widget.subItem!.breadCrumbText,
              routes: <String, WidgetBuilder>{
                widget.subItem!.breadCrumbText!: (BuildContext cotext) =>
                    Scaffold(
                        backgroundColor: widget.sampleModel!.cardThemeColor,
                        body: widget.sampleModel!.needToMaximize
                            ? Container()
                            : StatefulBuilder(builder: (BuildContext context,
                                StateSetter stateSetter) {
                                propertyPanelStateChange = stateSetter;
                                return Row(children: <Widget>[
                                  Expanded(
                                      child: Column(
                                    children: <Widget>[
                                      Expanded(
                                          child: widget.sampleModel!
                                              .currentRenderSample),
                                      if (widget.subItem!.sourceLink != null &&
                                          widget.subItem!.sourceLink != '')
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 0, 0, 0),
                                            height: 20,
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  'Source: ',
                                                  style: TextStyle(
                                                      color: widget.sampleModel!
                                                          .textColor
                                                          .withOpacity(0.65),
                                                      fontSize: 12),
                                                ),
                                                InkWell(
                                                  onTap: () => launchUrl(
                                                      Uri.parse(widget.subItem!
                                                          .sourceLink!)),
                                                  child: Text(
                                                      widget
                                                          .subItem!.sourceText!,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.blue)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      else
                                        Container()
                                    ],
                                  )),
                                  if (_needsPropertyPanel &&
                                      MediaQuery.of(context).size.width > 720 &&
                                      (widget.sampleModel!
                                              .isPropertyPanelOpened ||
                                          (!widget.sampleModel!
                                                  .isPropertyPanelOpened &&
                                              widget.sampleModel!
                                                  .isPropertyPanelTapped)))
                                    _PropertiesPanel(
                                        sampleModel: widget.sampleModel,
                                        subItem: widget.subItem,
                                        key: propertyPanelWidgetKey,
                                        openState: true)
                                  else
                                    Container()
                                ]);
                              }))
              }));
    }
  }
}

/// Get the Proeprty panel widget in the drawer
class _PropertiesPanel extends StatefulWidget {
  const _PropertiesPanel(
      {this.sampleModel, this.openState, this.subItem, this.key})
      : super(key: key);
  final SampleModel? sampleModel;

  final bool? openState;

  final SubItem? subItem;

  @override
  final Key? key;

  @override
  State<StatefulWidget> createState() {
    return _PropertiesPanelState();
  }
}

class _PropertiesPanelState extends State<_PropertiesPanel>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;
  bool initialRender = true;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _PropertiesPanel oldWidget) {
    initialRender = false;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget? _getSettingsView(GlobalKey sampleKey) {
    if (sampleKey.currentState != null) {
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

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final SampleModel model = widget.sampleModel!;
    final Widget? settingPanelContent =
        _getSettingsView(model.propertyPanelKey);

    if (settingPanelContent != null) {
      animation =
          Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
      final _OutputContainerState outputContainerState =
          model.outputContainerState as _OutputContainerState;
      if (!initialRender) {
        if (outputContainerState.show) {
          animationController.forward(from: 0.0);
        } else {
          animationController.reverse(from: 1.0);
        }
      } else {
        animationController.forward(from: 1.0);
      }
      return AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData(
                  brightness:
                      widget.sampleModel!.themeData.colorScheme.brightness,
                  primaryColor: widget.sampleModel!.backgroundColor,
                  colorScheme: widget.sampleModel!.themeData.colorScheme),
              child: SizedBox(
                  width: (widget.openState ?? false)
                      ? animation.value * 275
                      : (animation.value * 275),
                  child: Drawer(
                      elevation: 3,
                      child: Container(
                          decoration: BoxDecoration(
                            color: widget.sampleModel!.cardThemeColor,
                            border: (widget.openState ?? false)
                                ? Border(
                                    left: BorderSide(
                                        color: widget.sampleModel!.textColor
                                            .withOpacity(0.3),
                                        width: 0.5))
                                : Border.all(
                                    color: const Color.fromRGBO(0, 0, 0, 0.12),
                                    width: 2),
                          ),
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 20),
                          child: Container(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: ListView(
                                shrinkWrap: true,
                                children: <Widget>[
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        const Text(
                                          'Properties',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        if (widget.openState ?? false)
                                          Container()
                                        else
                                          Material(
                                              color: widget
                                                  .sampleModel!.cardThemeColor,
                                              shape: const CircleBorder(),
                                              clipBehavior: Clip.hardEdge,
                                              child: IconButton(
                                                hoverColor: Colors.grey
                                                    .withOpacity(0.3),
                                                icon: Icon(Icons.close,
                                                    color: widget.sampleModel!
                                                        .webIconColor),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ))
                                      ]),
                                  Container(
                                      padding: const EdgeInsets.only(
                                          right: 5, top: 5),
                                      width: 238,
                                      alignment: Alignment.topCenter,
                                      child: settingPanelContent)
                                ],
                              ))))),
            );
          });
    } else {
      return SizedBox.fromSize(size: Size.zero);
    }
  }
}

/// Get the sample list in an expansion tile
class _TileContainer extends StatefulWidget {
  const _TileContainer(
      {this.sampleModel,
      this.category,
      this.webLayoutPageState,
      this.item,
      this.expansionKey,
      this.key})
      : super(key: key);

  final SampleModel? sampleModel;
  @override
  final Key? key;
  final SubItem? item;
  final WidgetCategory? category;
  final _WebLayoutPageState? webLayoutPageState;
  final _ExpansionKey? expansionKey;

  @override
  State<StatefulWidget> createState() {
    return _TileContainerState();
  }
}

class _TileContainerState extends State<_TileContainer> {
  @override
  Widget build(BuildContext context) {
    final SampleModel model = widget.sampleModel!;
    return CustomExpansionTile(
      headerBackgroundColor: model.webBackgroundColor,
      onExpansionChanged: (bool value) {
        final _SampleInputContainerState sampleInputContainerState = widget
            .webLayoutPageState!
            .sampleInputKey
            .currentState! as _SampleInputContainerState;
        final List<_ExpansionKey> expansionKey =
            sampleInputContainerState.expansionKey;
        for (int k = 0; k < expansionKey.length; k++) {
          if (expansionKey[k].expansionIndex ==
              widget.expansionKey!.expansionIndex) {
            expansionKey[k].isExpanded = value;
            break;
          }
        }
      },
      initiallyExpanded: true,
      title: Text(widget.item!.title!,
          style: TextStyle(
              color: model.textColor,
              fontSize: 13,
              letterSpacing: -0.19,
              fontFamily: 'Roboto-Medium')),
      key: PageStorageKey<String>(widget.item!.title!),
      children: _getNextLevelChildren(
          model, widget.item!.subItems! as List<SubItem>, widget.item!.title!),
    );
  }

  /// Get expanded children
  List<Widget> _getNextLevelChildren(
      SampleModel model, List<SubItem> list, String text) {
    final List<Widget> nextLevelChildren = <Widget>[];
    final SubItem currentSample = widget.webLayoutPageState!.sample;
    if (list != null && list.isNotEmpty) {
      for (int i = 0; i < list.length; i++) {
        final String status = getStatusTag(list[i]);
        bool isNeedSelect = false;
        if (list[i].subItems != null) {
          for (int j = 0; j < list[i].subItems!.length; j++) {
            if (currentSample.breadCrumbText ==
                list[i].subItems![j].breadCrumbText) {
              isNeedSelect = true;
              break;
            } else {
              continue;
            }
          }
        } else {
          isNeedSelect = currentSample.breadCrumbText == list[i].breadCrumbText;
        }
        nextLevelChildren.add(list[i].type == 'sample'
            ? Material(
                color: model.webBackgroundColor,
                child: InkWell(
                    hoverColor: Colors.grey.withOpacity(0.2),
                    onTap: () {
                      final _SampleInputContainerState
                          sampleInputContainerState = widget
                              .webLayoutPageState!
                              .sampleInputKey
                              .currentState! as _SampleInputContainerState;
                      final GlobalKey globalKey = widget.webLayoutPageState!
                          .outputContainer.key! as GlobalKey;
                      final SampleOutputContainerState outputContainerState =
                          globalKey.currentState! as SampleOutputContainerState;
                      if (outputContainerState.outputScaffoldKey.currentState!
                              .isEndDrawerOpen ||
                          widget.webLayoutPageState!.scaffoldKey.currentState!
                              .isDrawerOpen) {
                        Navigator.pop(context);
                      }
                      outputContainerState.sample = list[i];
                      outputContainerState.needTabs = false;
                      final String prevBreadCrumbText =
                          outputContainerState.orginText;
                      outputContainerState.orginText =
                          widget.webLayoutPageState!.sample.control!.title! +
                              ' > ' +
                              text +
                              ' > ' +
                              list[i].title!;

                      widget.webLayoutPageState!.selectSample = list[i].title;
                      widget.webLayoutPageState!.sample =
                          list[i].subItems != null
                              ? list[i].subItems![0] as SubItem
                              : list[i];
                      if (model.currentSampleKey == null ||
                          (list[i].key != null
                              ? (model.currentSampleKey != list[i].key ||
                                  (model.currentSampleKey == list[i].key &&
                                      prevBreadCrumbText !=
                                          list[i].breadCrumbText))
                              : model.currentSampleKey !=
                                  list[i].subItems![0].key)) {
                        model.isPropertyPanelOpened = true;
                        sampleInputContainerState.refresh();
                        outputContainerState.refresh();
                      }
                    },
                    child: Container(
                        color: isNeedSelect
                            ? Colors.grey.withOpacity(0.2)
                            : Colors.transparent,
                        child: Row(children: <Widget>[
                          Container(
                              width: 5,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.fromLTRB(1, 10, 10, 10),
                              color: isNeedSelect
                                  ? model.backgroundColor
                                  : Colors.transparent,
                              child: const Opacity(
                                  opacity: 0.0, child: Text('1'))),
                          Expanded(
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 10, 10),
                                  child: Text(list[i].title!,
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
                                          ? const Color.fromRGBO(55, 153, 30, 1)
                                          : const Color.fromRGBO(
                                              246, 117, 0, 1))
                                      : Colors.transparent,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0))),
                              padding: model.isWeb && model.isMobileResolution
                                  ? const EdgeInsets.fromLTRB(3, 1, 3, 5.5)
                                  : const EdgeInsets.fromLTRB(5, 2.7, 5, 2.7),
                              child: Text(status,
                                  style: const TextStyle(
                                      fontSize: 10.5, color: Colors.white))),
                          if (status != null && status != '')
                            const Padding(padding: EdgeInsets.only(right: 5))
                          else
                            Container(),
                        ]))))
            : Material(
                color: model.webBackgroundColor,
                child: InkWell(
                  hoverColor: Colors.grey.withOpacity(0.2),
                  onTap: () {
                    model.isPropertyPanelOpened = true;
                    final _SampleInputContainerState sampleInputContainerState =
                        widget.webLayoutPageState!.sampleInputKey.currentState!
                            as _SampleInputContainerState;
                    final GlobalKey globalKey = widget
                        .webLayoutPageState!.outputContainer.key! as GlobalKey;
                    final SampleOutputContainerState outputContainerState =
                        globalKey.currentState! as SampleOutputContainerState;
                    final String prevBreadCrumbText =
                        outputContainerState.orginText;
                    if (list[i].subItems != null &&
                        list[i].subItems!.isNotEmpty) {
                      outputContainerState.subItems =
                          list[i].subItems! as List<SubItem>;
                      outputContainerState.sample =
                          list[i].subItems![0] as SubItem;
                      outputContainerState.tabIndex = 0;
                      outputContainerState.needTabs = true;
                    } else {
                      outputContainerState.sample = list[i];
                      outputContainerState.needTabs = false;
                    }
                    resetLocaleValue(model, currentSample);

                    if (outputContainerState
                            .outputScaffoldKey.currentState!.isEndDrawerOpen ||
                        widget.webLayoutPageState!.scaffoldKey.currentState!
                            .isDrawerOpen) {
                      Navigator.pop(context);
                    }
                    outputContainerState.orginText =
                        widget.webLayoutPageState!.sample.control!.title! +
                            ' > ' +
                            text +
                            ' > ' +
                            list[i].title!;

                    widget.webLayoutPageState!.selectSample = list[i].title;
                    widget.webLayoutPageState!.sample = list[i].subItems != null
                        ? list[i].subItems![0] as SubItem
                        : list[i];
                    if (model.currentSampleKey == null ||
                        (list[i].key != null
                            ? (model.currentSampleKey != list[i].key ||
                                (model.currentSampleKey == list[i].key &&
                                    prevBreadCrumbText !=
                                        list[i].breadCrumbText))
                            : model.currentSampleKey !=
                                list[i].subItems![0].key)) {
                      sampleInputContainerState.refresh();
                      outputContainerState.refresh();
                    }
                  },
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
                                child: Text(list[i].title!,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'Roboto-Regular',
                                        color: isNeedSelect
                                            ? model.backgroundColor
                                            : model.textColor)))),
                        if (status != null && status != '')
                          Container(
                              decoration: BoxDecoration(
                                  color: status == 'New'
                                      ? const Color.fromRGBO(55, 153, 30, 1)
                                      : const Color.fromRGBO(246, 117, 0, 1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0))),
                              padding: model.isWeb && model.isMobileResolution
                                  ? const EdgeInsets.fromLTRB(3, 1, 3, 5.5)
                                  : const EdgeInsets.fromLTRB(5, 2.7, 5, 2.7),
                              child: Text(status,
                                  style: const TextStyle(
                                      fontSize: 10.5, color: Colors.white)))
                        else
                          Container(),
                        if (status != null && status != '')
                          const Padding(padding: EdgeInsets.only(right: 5))
                        else
                          Container(),
                      ])),
                )));
      }
    }
    return nextLevelChildren;
  }
}

/// Showing the expanded sample in a pop-up widget
class _Popup extends StatefulWidget {
  const _Popup({this.key, this.show}) : super(key: key);
  @override
  final Key? key;
  final bool? show;
  @override
  // ignore: no_logic_in_create_state
  _PopupState createState() => _PopupState(show!);
}

class _PopupState extends State<_Popup> {
  _PopupState(this.show);

  bool show;
  SubItem? _sampleDetails;

  GlobalKey<State>? _currentWidgetKey;

  @override
  void initState() {
    model = SampleModel.instance;
    super.initState();
  }

  void refresh(bool popupShow) {
    setState(() {
      show = popupShow;
    });
  }

  @override
  void dispose() {
    SampleModel.instance.needToMaximize = false;
    super.dispose();
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late _PropertiesPanel? _propertiesPanel;
  final GlobalKey<State> _propertiesPanelKey = GlobalKey<State>();

  SampleModel? model;
  late bool _needsPropertyPanel;

  /// Checks whether the property panel is enabled
  bool _checkPropertyPanelIsEnabled(BuildContext context) {
    final Function? sampleView = model!.sampleWidget[_sampleDetails!.key];
    final dynamic currentSample = sampleView!(GlobalKey<State>());
    _needsPropertyPanel = _sampleDetails!.needsPropertyPanel ?? false;
    bool? isPlatformSpecified;
    try {
      isPlatformSpecified = currentSample.needsPropertyPanel != null &&
          currentSample.needsPropertyPanel! == true;
      // ignore: empty_catches
    } catch (e) {}
    _needsPropertyPanel = (_sampleDetails!.needsPropertyPanel ?? false) &&
        (isPlatformSpecified == null || isPlatformSpecified == true);
    return _needsPropertyPanel;
  }

  @override
  Widget build(BuildContext context) {
    _propertiesPanel =
        _PropertiesPanel(sampleModel: model, key: _propertiesPanelKey);

    return IgnorePointer(
        ignoring: !show,
        child: Container(
            color: show ? Colors.black54 : Colors.transparent,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Opacity(
                opacity: show ? 1.0 : 0.0,
                child: _sampleDetails != null
                    ? Theme(
                        data: ThemeData(
                            checkboxTheme: CheckboxThemeData(
                                fillColor: MaterialStateProperty.resolveWith(
                                    getColor)),
                            brightness: model!.themeData.colorScheme.brightness,
                            primaryColor: model!.backgroundColor,
                            colorScheme: model!.themeData.colorScheme),
                        child: Scaffold(
                            key: scaffoldKey,
                            endDrawerEnableOpenDragGesture: false,
                            endDrawer: _propertiesPanel,
                            appBar: PreferredSize(
                                preferredSize: const Size.fromHeight(40),
                                child: AppBar(
                                    title: Text(_sampleDetails!.title!,
                                        style: TextStyle(
                                            fontFamily: 'Roboto-Medium',
                                            fontSize: 16,
                                            color: model!.textColor)),
                                    automaticallyImplyLeading: false,
                                    backgroundColor: model!.webBackgroundColor,
                                    actions: <Widget>[
                                      if (_checkPropertyPanelIsEnabled(context))
                                        SizedBox(
                                            height: 40,
                                            width: 40,
                                            child: Material(
                                                color:
                                                    model!.webBackgroundColor,
                                                shape: const CircleBorder(),
                                                clipBehavior: Clip.hardEdge,
                                                child: Tooltip(
                                                    message: 'Options',
                                                    child: IconButton(
                                                      hoverColor: Colors.grey
                                                          .withOpacity(0.3),
                                                      icon: Icon(Icons.menu,
                                                          color: model!
                                                              .webIconColor),
                                                      onPressed: () {
                                                        model!.propertyPanelKey =
                                                            _currentWidgetKey!;
                                                        scaffoldKey
                                                            .currentState!
                                                            .openEndDrawer();
                                                      },
                                                    ))))
                                      else
                                        Container(),
                                      SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: Material(
                                            color: model!.webBackgroundColor,
                                            shape: const CircleBorder(),
                                            clipBehavior: Clip.hardEdge,
                                            child: IconButton(
                                              hoverColor:
                                                  Colors.grey.withOpacity(0.3),
                                              icon: Icon(Icons.close,
                                                  color: model!.webIconColor),
                                              onPressed: () {
                                                model!.needToMaximize = false;
                                                final _OutputContainerState
                                                    outputContainerState =
                                                    model!.outputContainerState
                                                        as _OutputContainerState;
                                                outputContainerState
                                                    .setState(() {
                                                  outputContainerState
                                                          .renderWidget =
                                                      _currentWidgetKey
                                                          ?.currentWidget;
                                                });
                                                _sampleDetails = null;
                                                refresh(false);
                                              },
                                            )),
                                      )
                                    ])),
                            backgroundColor:
                                model!.themeData.colorScheme.brightness ==
                                        Brightness.dark
                                    ? const Color.fromRGBO(33, 33, 33, 1)
                                    : Colors.white,
                            body: _currentWidgetKey?.currentWidget))
                    : Container())));
  }

  /// Method to get the widget's color based on the widget state
  Color? getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.selected,
    };

    if (states.any(interactiveStates.contains)) {
      return model!.backgroundColor;
    }

    return null;
  }
}
