/// package imports
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
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
  const WebLayoutPage({this.sampleModel, this.category, Key? key, this.subItem})
      : super(key: key);

  /// Holds [SampleModel]
  final SampleModel? sampleModel;

  /// Hold the selected control's category information
  final WidgetCategory? category;

  ///Holds the sample details
  final SubItem? subItem;

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
  late List<SubItem>? subItems;
  late String orginText;
  @override
  void initState() {
    model = widget.sampleModel!;
    category = widget.category!;
    sample = widget.subItem!;
    orginText = sample.parentIndex != null
        ? sample.control!.title! +
            ' > ' +
            sample.control!.subItems![sample.parentIndex!].title +
            ' > ' +
            sample.control!.subItems![sample.parentIndex!]
                .subItems[sample.childIndex].title
        : sample.childIndex != null
            ? sample.control!.title! +
                ' > ' +
                widget.subItem!.control!.subItems![sample.childIndex!].title +
                ' > ' +
                sample.title!
            : sample.control!.title! + ' > ' + sample.title!;
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
      setState(() {
        /// The listenable's state was changed already.
      });
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
                                _outputContainerState = globalKey.currentState!
                                    as SampleOutputContainerState;
                            if (_outputContainerState.outputScaffoldKey
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
                    Container(height: 0, width: 9)
                  else
                    Container(
                        child: Container(
                            padding: const EdgeInsets.only(top: 0, right: 20),
                            width: MediaQuery.of(context).size.width * 0.215,
                            height: MediaQuery.of(context).size.height * 0.0445,
                            child: SearchBar(
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
                                    launch(
                                        'https://www.syncfusion.com/downloads/flutter/confirm');
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
                                      launch(
                                          'https://pub.dev/publishers/syncfusion.com/packages');
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
                  Container(
                    height: 60,
                    width: 60,
                    child: IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () {
                        if (outputContainer != null) {
                          final GlobalKey globalKey =
                              outputContainer.key! as GlobalKey;
                          final SampleOutputContainerState
                              _outputContainerState = globalKey.currentState!
                                  as SampleOutputContainerState;
                          if (_outputContainerState.outputScaffoldKey
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
    GlobalKey<State>? _currentGlobalKey;
    _ExpansionKey? _currentExpansionKey;
    if (initialRender) {
      _currentGlobalKey = GlobalKey<State>();
      _currentExpansionKey = _ExpansionKey(
          expansionIndex: index,
          isExpanded: index == 0,
          globalKey: _currentGlobalKey);
      expansionKey.add(_currentExpansionKey);
    } else {
      if (expansionKey.isNotEmpty) {
        for (int i = 0; i < expansionKey.length; i++) {
          if (expansionKey[i].expansionIndex == index) {
            _currentExpansionKey = expansionKey[i];
            break;
          }
        }
      }
    }
    return item.subItems != null && item.subItems!.isNotEmpty
        ? _TileContainer(
            key: _currentGlobalKey,
            category: category,
            sampleModel: model,
            expansionKey: _currentExpansionKey,
            webLayoutPageState: widget.webLayoutPageState!,
            item: item)
        : Material(
            color: model.webBackgroundColor,
            child: InkWell(
                hoverColor: Colors.grey.withOpacity(0.2),
                onTap: () {
                  final GlobalKey globalKey = widget
                      .webLayoutPageState!.outputContainer.key! as GlobalKey;
                  final SampleOutputContainerState _outputContainerState =
                      globalKey.currentState! as SampleOutputContainerState;
                  if (_outputContainerState
                          .outputScaffoldKey.currentState!.isEndDrawerOpen ||
                      widget.webLayoutPageState!.scaffoldKey.currentState!
                          .isDrawerOpen) {
                    Navigator.pop(context);
                  }
                  _outputContainerState.sample = item;
                  _outputContainerState.needTabs = false;
                  _outputContainerState.orginText =
                      widget.webLayoutPageState!.sample.control!.title! +
                          ' > ' +
                          item.title!;
                  if (model.currentSampleKey == null ||
                      model.currentSampleKey != item.key) {
                    _outputContainerState.refresh();
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

  List<Widget> _getSampleList(SampleModel model, WidgetCategory category) {
    final List<SubItem> _list =
        widget.webLayoutPageState!.sample.control!.subItems! as List<SubItem>;
    final List<Widget> _children = <Widget>[];
    for (int i = 0; i < _list.length; i++) {
      final bool _isNeedSelect = widget.webLayoutPageState!.selectSample == null
          ? widget.webLayoutPageState!.sample.breadCrumbText ==
              _list[i].breadCrumbText
          : widget.webLayoutPageState!.selectSample == _list[i].title;
      _children.add(Material(
          color: model.webBackgroundColor,
          child: _list[i].type != 'parent' && _list[i].type != 'child'
              ? InkWell(
                  hoverColor: Colors.grey.withOpacity(0.2),
                  onTap: () {
                    final _SampleInputContainerState
                        _sampleInputContainerState = widget
                            .webLayoutPageState!
                            .sampleInputKey
                            .currentState! as _SampleInputContainerState;
                    final GlobalKey globalKey = widget
                        .webLayoutPageState!.outputContainer.key! as GlobalKey;
                    final SampleOutputContainerState _outputContainerState =
                        globalKey.currentState! as SampleOutputContainerState;
                    if (_outputContainerState
                            .outputScaffoldKey.currentState!.isEndDrawerOpen ||
                        widget.webLayoutPageState!.scaffoldKey.currentState!
                            .isDrawerOpen) {
                      Navigator.pop(context);
                    }
                    _outputContainerState.sample = _list[i];
                    _outputContainerState.needTabs = false;
                    _outputContainerState.orginText =
                        widget.webLayoutPageState!.sample.control!.title! +
                            ' > ' +
                            _list[i].title!;
                    widget.webLayoutPageState!.selectSample = _list[i].title!;
                    if (model.currentSampleKey == null ||
                        (_list[i].key != null
                            ? model.currentSampleKey != _list[i].key
                            : model.currentSampleKey !=
                                _list[i].subItems![0].key)) {
                      _sampleInputContainerState.refresh();
                      _outputContainerState.refresh();
                    }
                  },
                  child: Container(
                      color: _isNeedSelect
                          ? Colors.grey.withOpacity(0.2)
                          : Colors.transparent,
                      child: Row(children: <Widget>[
                        Container(
                            color: _isNeedSelect
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
                                  _list[i].title!,
                                  style: TextStyle(
                                      color: _isNeedSelect
                                          ? model.backgroundColor
                                          : model.textColor),
                                ))),
                        if (_list[i].status != null)
                          Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: _list[i].status!.toLowerCase() == 'new'
                                      ? const Color.fromRGBO(55, 153, 30, 1)
                                      : (_list[i].status!.toLowerCase() ==
                                              'updated')
                                          ? const Color.fromRGBO(246, 117, 0, 1)
                                          : Colors.transparent,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              padding:
                                  const EdgeInsets.fromLTRB(5, 2.7, 5, 2.7),
                              child: Text(_list[i].status!,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10.5)))
                        else
                          Container(),
                        if (_list[i].status != null)
                          const Padding(padding: EdgeInsets.only(right: 5))
                        else
                          Container(),
                      ])),
                )
              : _expandedChildren(model, _list[i], category, i)));
    }

    return _children;
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
                  Navigator.pop(context);
                  if (MediaQuery.of(context).size.width <= 768) {
                    Navigator.pop(context);
                  }
                },
                child: Row(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                    ),
                    Container(
                        child: Icon(Icons.arrow_back,
                            size: 20, color: sampleModel.backgroundColor)),
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

  @override
  void initState() {
    _initialRender = true;
    orginText = widget.orginText!;
    super.initState();
  }

  /// Notify the framework
  void refresh() {
    _initialRender = false;
    if (mounted) {
      setState(() {
        /// update the sample and sample details changes
      });
    }
  }

  @override
  void dispose() {
    tabIndex = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SampleModel _model = widget.sampleModel!;
    _model.webOutputContainerState = this;
    final double width = MediaQuery.of(context).size.width;
    if (_initialRender && widget.initialSubItems != null) {
      needTabs = true;
      subItems = widget.initialSubItems!;
    }
    final SubItem _sample = (_initialRender ? widget.initialSample : sample)!;
    _propertiesPanel =
        _PropertiesPanel(sampleModel: _model, key: _propertiesPanelKey);
    _tabTextWidth = 0;
    final List<Widget>? tabs =
        needTabs == true && subItems.length > 1 ? _getTabs(subItems) : null;
    final double _scrollbarWidth = width *
        ((_model.isMobileResolution && width > 600)
            ? 0.75
            : (width <= 500
                ? 0.585
                : width < 890
                    ? 0.58
                    : 0.65));
    return Theme(
      data: ThemeData(
          brightness: _model.themeData.brightness,
          primaryColor: _model.backgroundColor),
      child: Expanded(
          child: Container(
              color: _model.webOutputContainerColor,
              padding: const EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,

                      ///Space added for avoiding text hide issue of the
                      ///string having `infinite` word
                      child: Text(_sample.title! + ' ',
                          style: TextStyle(
                              color: _model.textColor,
                              letterSpacing: 0.39,
                              fontSize: 18,
                              fontFamily: 'Roboto-Medium'))),
                  Container(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                          needTabs == true && subItems.length != 1
                              ? orginText + ' > ' + _sample.title!
                              : orginText,
                          style: TextStyle(
                              color: _model.textColor.withOpacity(0.65),
                              letterSpacing: 0.3,
                              fontFamily: 'Roboto-Regular'))),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  Expanded(
                      child: Scaffold(
                          backgroundColor: _model.webOutputContainerColor,
                          key: outputScaffoldKey,
                          endDrawer: _propertiesPanel,
                          body: needTabs == true
                              ? DefaultTabController(
                                  initialIndex: (tabIndex ??
                                      widget.webLayoutPageState!.sample
                                          .sampleIndex)!,
                                  key: UniqueKey(),
                                  length: subItems.length,
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: _model.webOutputContainerColor,
                                        border: Border.all(
                                            color:
                                                (_model.themeData.brightness ==
                                                        Brightness.light
                                                    ? Colors.grey[300]
                                                    : Colors.transparent)!,
                                            width: 1),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                              height: 36,
                                              decoration: BoxDecoration(
                                                color: _model.webInputColor,
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color:
                                                            _model.dividerColor,
                                                        width: 0.8)),
                                              ),
                                              padding: width < 500
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
                                                      width: _scrollbarWidth,
                                                      child: Stack(
                                                        children: <Widget>[
                                                          SingleChildScrollView(
                                                              key: PageStorageKey<
                                                                  String>((subItems
                                                                          .isNotEmpty
                                                                      ? subItems[
                                                                              0]
                                                                          .title!
                                                                      : '') +
                                                                  'tabscroll'),
                                                              scrollDirection:
                                                                  Axis
                                                                      .horizontal,
                                                              child: Material(
                                                                  color: _model
                                                                      .webInputColor,
                                                                  child: InkWell(
                                                                      hoverColor: _model.paletteColor.withOpacity(0.3),
                                                                      child: subItems.length == 1
                                                                          ? Container()
                                                                          : TabBar(
                                                                              indicatorPadding: EdgeInsets.zero,
                                                                              indicatorColor: _model.backgroundColor,
                                                                              onTap: (int value) {
                                                                                widget.sampleModel!.needToMaximize = false;
                                                                                final GlobalKey globalKey = widget.webLayoutPageState!.outputContainer.key! as GlobalKey;
                                                                                final SampleOutputContainerState _outputContainerState = globalKey.currentState! as SampleOutputContainerState;
                                                                                _outputContainerState.sample = subItems[value];
                                                                                _outputContainerState.needTabs = true;
                                                                                _outputContainerState.subItems = subItems;
                                                                                _outputContainerState.tabIndex = value;
                                                                                if (_model.currentSampleKey == null || _model.currentSampleKey != _outputContainerState.sample.key) {
                                                                                  _outputContainerState.refresh();
                                                                                }
                                                                              },
                                                                              labelColor: _model.backgroundColor,
                                                                              unselectedLabelColor: _model.themeData.brightness == Brightness.dark ? Colors.white : const Color.fromRGBO(89, 89, 89, 1),
                                                                              isScrollable: true,
                                                                              tabs: tabs!,
                                                                            )))),
                                                          if ((_scrollbarWidth +
                                                                  10) <
                                                              _tabTextWidth)
                                                            Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          gradient:
                                                                              LinearGradient(
                                                                    colors: <
                                                                        Color>[
                                                                      _model
                                                                          .webInputColor
                                                                          .withOpacity(
                                                                              0.21),
                                                                      _model
                                                                          .webInputColor
                                                                          .withOpacity(
                                                                              1.0)
                                                                    ],
                                                                    stops: const <
                                                                        double>[
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
                                                                size:
                                                                    Size.zero),
                                                          if ((_scrollbarWidth +
                                                                  10) <
                                                              _tabTextWidth)
                                                            Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  child: Image.asset(
                                                                      'images/scroll_arrow.png',
                                                                      color: _model.themeData.brightness == Brightness.dark
                                                                          ? const Color.fromRGBO(
                                                                              255,
                                                                              255,
                                                                              255,
                                                                              0.65)
                                                                          : const Color.fromRGBO(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              0.54),
                                                                      fit: BoxFit
                                                                          .contain,
                                                                      height:
                                                                          18,
                                                                      width:
                                                                          18),
                                                                ))
                                                          else
                                                            SizedBox.fromSize(
                                                                size:
                                                                    Size.zero),
                                                        ],
                                                      ),
                                                    ),
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
                                                                      launch(_sample
                                                                          .codeLink!);
                                                                    },
                                                                    child: Ink(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              _model.webInputColor,
                                                                          border: Border.all(
                                                                              color: Colors.transparent,
                                                                              width: 6),
                                                                          shape:
                                                                              BoxShape.circle,
                                                                        ),
                                                                        child: SizedBox(
                                                                            height: 21,
                                                                            width: 21,
                                                                            child: Image.asset(
                                                                              _model.themeData.brightness == Brightness.dark ? 'images/git_hub_dark.png' : 'images/git_hub.png',
                                                                              fit: BoxFit.contain,
                                                                            ))))),
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
                                                                        _model,
                                                                        _sample);
                                                                  },
                                                                  child: Ink(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: _model
                                                                            .webInputColor,
                                                                        border: Border.all(
                                                                            color:
                                                                                Colors.transparent,
                                                                            width: 4),
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child: Transform
                                                                          .scale(
                                                                        scale:
                                                                            0.85,
                                                                        child: Icon(
                                                                            Icons
                                                                                .open_in_full,
                                                                            color:
                                                                                _model.webIconColor),
                                                                      ))),
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
                                                            child: _sample
                                                                        .needsPropertyPanel ==
                                                                    true
                                                                ? Material(
                                                                    shape:
                                                                        const CircleBorder(),
                                                                    clipBehavior:
                                                                        Clip
                                                                            .hardEdge,
                                                                    child:
                                                                        InkWell(
                                                                            hoverColor: Colors.grey.withOpacity(
                                                                                0.3),
                                                                            onTap:
                                                                                () {
                                                                              outputScaffoldKey.currentState!.openEndDrawer();
                                                                            },
                                                                            child:
                                                                                Ink(
                                                                              decoration: BoxDecoration(
                                                                                color: _model.webInputColor,
                                                                                border: Border.all(color: Colors.transparent, width: 4),
                                                                                shape: BoxShape.circle,
                                                                              ),
                                                                              child: Icon(Icons.menu, color: _model.webIconColor),
                                                                            )))
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
                                            color: _model.cardThemeColor,
                                            child: TabBarView(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                children: _getTabViewChildren(
                                                    _model, subItems)),
                                          )),
                                        ],
                                      )))
                              : Container(
                                  decoration: BoxDecoration(
                                    color: _model.webOutputContainerColor,
                                    border: Border.all(
                                        color: (_model.themeData.brightness ==
                                                Brightness.light
                                            ? Colors.grey[300]
                                            : Colors.transparent)!,
                                        width: 1),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: _model.webInputColor,
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: _model.dividerColor,
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
                                                        launch(
                                                            _sample.codeLink!);
                                                      },
                                                      child: Ink(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: _model
                                                                .webInputColor,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .transparent,
                                                                width: 6),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: SizedBox(
                                                              height: 21,
                                                              width: 21,
                                                              child:
                                                                  Image.asset(
                                                                _model.themeData
                                                                            .brightness ==
                                                                        Brightness
                                                                            .dark
                                                                    ? 'images/git_hub_dark.png'
                                                                    : 'images/git_hub.png',
                                                                fit: BoxFit
                                                                    .contain,
                                                              ))))),
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
                                                          _model, _sample);
                                                    },
                                                    child: Ink(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: _model
                                                              .webInputColor,
                                                          border: Border.all(
                                                              color: Colors
                                                                  .transparent,
                                                              width: 4),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Transform.scale(
                                                          scale: 0.85,
                                                          child: Icon(
                                                              Icons
                                                                  .open_in_full,
                                                              color: _model
                                                                  .webIconColor),
                                                        ))),
                                              ),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: width < 500 ? 3 : 6)),
                                            Flexible(
                                              child: _sample
                                                          .needsPropertyPanel ==
                                                      true
                                                  ? Material(
                                                      shape:
                                                          const CircleBorder(),
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      child: InkWell(
                                                          hoverColor: Colors
                                                              .grey
                                                              .withOpacity(0.3),
                                                          onTap: () {
                                                            outputScaffoldKey
                                                                .currentState!
                                                                .openEndDrawer();
                                                          },
                                                          child: Ink(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: _model
                                                                  .webInputColor,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .transparent,
                                                                  width: 4),
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: Icon(
                                                                Icons.menu,
                                                                color: _model
                                                                    .webIconColor),
                                                          )))
                                                  : SizedBox.fromSize(
                                                      size: Size.zero),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          child: Container(
                                              color: _model.cardThemeColor,
                                              child: Column(
                                                children: <Widget>[
                                                  Expanded(
                                                      child: Container(
                                                    color:
                                                        _model.cardThemeColor,
                                                    child: _OutputContainer(
                                                        key: GlobalKey(),
                                                        sampleOutputContainerState:
                                                            this,
                                                        subItem: _sample,
                                                        sampleView:
                                                            _model.sampleWidget[
                                                                _sample.key]!,
                                                        sampleModel: _model),
                                                  )),
                                                  if (_sample.sourceLink !=
                                                          null &&
                                                      _sample.sourceLink != '')
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                15, 10, 0, 13),
                                                        height: 40,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Text(
                                                              'Source: ',
                                                              style: TextStyle(
                                                                  color: _model
                                                                      .textColor
                                                                      .withOpacity(
                                                                          0.65),
                                                                  fontSize: 12),
                                                            ),
                                                            InkWell(
                                                              onTap: () =>
                                                                  launch(_sample
                                                                      .sourceLink!),
                                                              child: Text(
                                                                  _sample
                                                                      .sourceText!,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .blue)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  else
                                                    Container()
                                                ],
                                              ))),
                                    ],
                                  )))),
                  if (_sample.description != null && _sample.description != '')
                    Container(
                        padding: const EdgeInsets.only(left: 10, top: 18),
                        alignment: Alignment.centerLeft,
                        child: Text(_sample.description!,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: _model.textColor,
                                fontFamily: 'Roboto-Regular',
                                letterSpacing: 0.3)))
                  else
                    Container(),
                ],
              ))),
    );
  }

  /// Method to maximize sample
  void performMaximize(SampleModel model, SubItem sample) {
    model.needToMaximize = true;
    final _PopupState state =
        widget.webLayoutPageState!.popUpKey.currentState! as _PopupState;
    state._sampleDetails = sample;
    state._currentWidgetKey = model.currentRenderSample.key as GlobalKey;
    final _OutputContainerState _outputContainerState =
        _outputKey.currentState! as _OutputContainerState;
    _outputContainerState.setState(() {});
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
    final List<Widget> _tabs = <Widget>[];
    _tabTextWidth = 0;
    for (int i = 0; i < list.length; i++) {
      if (list.isNotEmpty) {
        final String _status = getStatusTag(list[i]);
        _tabTextWidth += _measureTextSize(
                    list[i].title.toString() + (_status != '' ? '  ' : ''),
                    const TextStyle(
                        letterSpacing: 0.5, fontFamily: 'Roboto-Medium'))
                .width +
            _measureTextSize(
                    _status == 'New'
                        ? 'N'
                        : _status == 'Updated'
                            ? 'U'
                            : '',
                    const TextStyle(fontSize: 11, color: Colors.white))
                .width +
            32 /*labelPadding*/;
        _tabs.add(Tab(
            child: Row(
          children: <Widget>[
            Text(list[i].title.toString() + (_status != '' ? '  ' : ''),
                style: const TextStyle(
                    letterSpacing: 0.5, fontFamily: 'Roboto-Medium')),
            if (_status == '')
              Container()
            else
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: _status == 'New'
                      ? const Color.fromRGBO(55, 153, 30, 1)
                      : _status == 'Updated'
                          ? const Color.fromRGBO(246, 117, 0, 1)
                          : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  _status == 'New'
                      ? 'N'
                      : _status == 'Updated'
                          ? 'U'
                          : '',
                  style: const TextStyle(fontSize: 11, color: Colors.white),
                ),
              ),
          ],
        )));
      }
    }
    return _tabs;
  }

  /// Get tab view widgets which length is equal to list length
  List<Widget> _getTabViewChildren(SampleModel model, List<SubItem> list) {
    final List<Widget> _tabChildren = <Widget>[];
    for (int i = 0; i < list.length; i++) {
      _tabChildren.add(Column(children: <Widget>[
        Expanded(
          child: Container(
              color: model.cardThemeColor,
              child: _OutputContainer(
                  key: GlobalKey(),
                  sampleOutputContainerState: this,
                  sampleModel: model,
                  subItem: list[i],
                  sampleView: model.sampleWidget[list[i].key])),
        ),
        if (list[i].sourceLink != null && list[i].sourceLink != '')
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.fromLTRB(15, 10, 0, 13),
              height: 40,
              child: Row(
                children: <Widget>[
                  Text(
                    'Source: ',
                    style: TextStyle(
                        color: model.textColor.withOpacity(0.65), fontSize: 12),
                  ),
                  InkWell(
                    onTap: () => launch(list[i].sourceLink!),
                    child: Text(list[i].sourceText!,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.blue)),
                  ),
                ],
              ),
            ),
          )
        else
          Container()
      ]));
    }
    return _tabChildren;
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

  @override
  void initState() {
    renderOutputKey = GlobalKey<State>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      widget.sampleModel!.currentSampleKey = widget.subItem!.key!;
      return widget.sampleModel!.needToMaximize
          ? Container()
          : Container(child: widget.sampleModel!.currentRenderSample);
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
              theme: ThemeData(
                  brightness: widget.sampleModel!.themeData.brightness,
                  primaryColor: widget.sampleModel!.backgroundColor),
              initialRoute: widget.subItem!.breadCrumbText,
              routes: <String, WidgetBuilder>{
            widget.subItem!.breadCrumbText!: (BuildContext cotext) => Scaffold(
                backgroundColor: widget.sampleModel!.cardThemeColor,
                body: widget.sampleModel!.needToMaximize
                    ? Container()
                    : widget.sampleModel!.currentRenderSample)
          }));
    }
  }
}

/// Get the Proeprty panel widget in the drawer
class _PropertiesPanel extends StatefulWidget {
  const _PropertiesPanel({this.sampleModel, this.key}) : super(key: key);
  final SampleModel? sampleModel;

  @override
  final Key? key;

  @override
  State<StatefulWidget> createState() {
    return _PropertiesPanelState();
  }
}

class _PropertiesPanelState extends State<_PropertiesPanel> {
  late GlobalKey<State>? _sampleKey;

  @override
  Widget build(BuildContext context) {
    final SampleModel model = widget.sampleModel!;
    _sampleKey = model.propertyPanelKey;
    final SampleViewState _sampleViewState =
        _sampleKey!.currentState! as SampleViewState;
    final Widget _settingPanelContent =
        _sampleViewState.buildSettings(context)!;

    return Theme(
      data: ThemeData(
          brightness: widget.sampleModel!.themeData.brightness,
          primaryColor: widget.sampleModel!.backgroundColor),
      child: Drawer(
          elevation: 3,
          child: SizedBox(
              width: 280,
              child: Container(
                  decoration: BoxDecoration(
                    color: widget.sampleModel!.cardThemeColor,
                    border: Border.all(
                        color: const Color.fromRGBO(0, 0, 0, 0.12), width: 2),
                  ),
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 20),
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: ListView(
                        children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text(
                                  'Properties',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Material(
                                    color: widget.sampleModel!.cardThemeColor,
                                    shape: const CircleBorder(),
                                    clipBehavior: Clip.hardEdge,
                                    child: IconButton(
                                      hoverColor: Colors.grey.withOpacity(0.3),
                                      icon: Icon(Icons.close,
                                          color:
                                              widget.sampleModel!.webIconColor),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ))
                              ]),
                          Container(
                              padding: const EdgeInsets.only(right: 5),
                              height: 600,
                              width: 238,
                              alignment: Alignment.topCenter,
                              child: _settingPanelContent)
                        ],
                      ))))),
    );
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
    final SampleModel _model = widget.sampleModel!;
    return CustomExpansionTile(
      headerBackgroundColor: _model.webBackgroundColor,
      onExpansionChanged: (bool value) {
        final _SampleInputContainerState _sampleInputContainerState = widget
            .webLayoutPageState!
            .sampleInputKey
            .currentState! as _SampleInputContainerState;
        final List<_ExpansionKey> expansionKey =
            _sampleInputContainerState.expansionKey;
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
              color: _model.textColor,
              fontSize: 13,
              letterSpacing: -0.19,
              fontFamily: 'Roboto-Medium')),
      key: PageStorageKey<String>(widget.item!.title!),
      children: _getNextLevelChildren(
          _model, widget.item!.subItems! as List<SubItem>, widget.item!.title!),
    );
  }

  /// Get expanded children
  List<Widget> _getNextLevelChildren(
      SampleModel model, List<SubItem> list, String text) {
    final List<Widget> _nextLevelChildren = <Widget>[];
    final SubItem currenSample = widget.webLayoutPageState!.sample;
    if (list != null && list.isNotEmpty) {
      for (int i = 0; i < list.length; i++) {
        final String _status = getStatusTag(list[i]);
        bool _isNeedSelect = false;
        if (list[i].subItems != null) {
          for (int j = 0; j < list[i].subItems!.length; j++) {
            if (currenSample.breadCrumbText ==
                list[i].subItems![j].breadCrumbText) {
              _isNeedSelect = true;
              break;
            } else {
              continue;
            }
          }
        } else {
          _isNeedSelect = currenSample.breadCrumbText == list[i].breadCrumbText;
        }
        _nextLevelChildren.add(list[i].type == 'sample'
            ? Material(
                color: model.webBackgroundColor,
                child: InkWell(
                    hoverColor: Colors.grey.withOpacity(0.2),
                    onTap: () {
                      final _SampleInputContainerState
                          _sampleInputContainerState = widget
                              .webLayoutPageState!
                              .sampleInputKey
                              .currentState! as _SampleInputContainerState;
                      final GlobalKey _globalKey = widget.webLayoutPageState!
                          .outputContainer.key! as GlobalKey;
                      final SampleOutputContainerState _outputContainerState =
                          _globalKey.currentState!
                              as SampleOutputContainerState;
                      if (_outputContainerState.outputScaffoldKey.currentState!
                              .isEndDrawerOpen ||
                          widget.webLayoutPageState!.scaffoldKey.currentState!
                              .isDrawerOpen) {
                        Navigator.pop(context);
                      }
                      _outputContainerState.sample = list[i];
                      _outputContainerState.needTabs = false;
                      _outputContainerState.orginText =
                          widget.webLayoutPageState!.sample.control!.title! +
                              ' > ' +
                              text +
                              ' > ' +
                              list[i].title!;

                      widget.webLayoutPageState!.selectSample = list[i].title!;
                      widget.webLayoutPageState!.sample =
                          list[i].subItems != null
                              ? list[i].subItems![0] as SubItem
                              : list[i];
                      if (model.currentSampleKey == null ||
                          (list[i].key != null
                              ? model.currentSampleKey != list[i].key
                              : model.currentSampleKey !=
                                  list[i].subItems![0].key)) {
                        _sampleInputContainerState.refresh();
                        _outputContainerState.refresh();
                      }
                    },
                    child: Container(
                        color: _isNeedSelect
                            ? Colors.grey.withOpacity(0.2)
                            : Colors.transparent,
                        child: Row(children: <Widget>[
                          Container(
                              width: 5,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.fromLTRB(1, 10, 10, 10),
                              color: _isNeedSelect
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
                                          color: _isNeedSelect
                                              ? model.backgroundColor
                                              : model.textColor)))),
                          Container(
                              decoration: BoxDecoration(
                                  color: (_status != null && _status != '')
                                      ? (_status == 'New'
                                          ? const Color.fromRGBO(55, 153, 30, 1)
                                          : const Color.fromRGBO(
                                              246, 117, 0, 1))
                                      : Colors.transparent,
                                  shape: BoxShape.rectangle,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0))),
                              padding:
                                  const EdgeInsets.fromLTRB(5, 2.7, 5, 2.7),
                              child: Text(_status,
                                  style: const TextStyle(
                                      fontSize: 10.5, color: Colors.white))),
                          if (_status != null && _status != '')
                            const Padding(padding: EdgeInsets.only(right: 5))
                          else
                            Container(),
                        ]))))
            : Material(
                color: model.webBackgroundColor,
                child: InkWell(
                  hoverColor: Colors.grey.withOpacity(0.2),
                  onTap: () {
                    final _SampleInputContainerState
                        _sampleInputContainerState = widget
                            .webLayoutPageState!
                            .sampleInputKey
                            .currentState! as _SampleInputContainerState;
                    final GlobalKey _globalKey = widget
                        .webLayoutPageState!.outputContainer.key! as GlobalKey;
                    final SampleOutputContainerState _outputContainerState =
                        _globalKey.currentState! as SampleOutputContainerState;
                    if (list[i].subItems != null &&
                        list[i].subItems!.isNotEmpty) {
                      _outputContainerState.subItems =
                          list[i].subItems! as List<SubItem>;
                      _outputContainerState.sample =
                          list[i].subItems![0] as SubItem;
                      _outputContainerState.tabIndex = 0;
                      _outputContainerState.needTabs = true;
                    } else {
                      _outputContainerState.sample = list[i];
                      _outputContainerState.needTabs = false;
                    }
                    if (_outputContainerState
                            .outputScaffoldKey.currentState!.isEndDrawerOpen ||
                        widget.webLayoutPageState!.scaffoldKey.currentState!
                            .isDrawerOpen) {
                      Navigator.pop(context);
                    }
                    _outputContainerState.orginText =
                        widget.webLayoutPageState!.sample.control!.title! +
                            ' > ' +
                            text +
                            ' > ' +
                            list[i].title!;

                    widget.webLayoutPageState!.selectSample = list[i].title!;
                    widget.webLayoutPageState!.sample = list[i].subItems != null
                        ? list[i].subItems![0] as SubItem
                        : list[i];
                    if (model.currentSampleKey == null ||
                        (list[i].key != null
                            ? model.currentSampleKey != list[i].key
                            : model.currentSampleKey !=
                                list[i].subItems![0].key)) {
                      _sampleInputContainerState.refresh();
                      _outputContainerState.refresh();
                    }
                  },
                  child: Container(
                      color: _isNeedSelect
                          ? Colors.grey.withOpacity(0.2)
                          : Colors.transparent,
                      child: Row(children: <Widget>[
                        Container(
                            width: 5,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(
                                left: 1, top: 7, bottom: 7),
                            color: _isNeedSelect
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
                                        color: _isNeedSelect
                                            ? model.backgroundColor
                                            : model.textColor)))),
                        if (_status != null && _status != '')
                          Container(
                              decoration: BoxDecoration(
                                  color: _status == 'New'
                                      ? const Color.fromRGBO(55, 153, 30, 1)
                                      : const Color.fromRGBO(246, 117, 0, 1),
                                  shape: BoxShape.rectangle,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0))),
                              padding:
                                  const EdgeInsets.fromLTRB(5, 2.7, 5, 2.7),
                              child: Text(_status,
                                  style: const TextStyle(
                                      fontSize: 10.5, color: Colors.white)))
                        else
                          Container(),
                        if (_status != null && _status != '')
                          const Padding(padding: EdgeInsets.only(right: 5))
                        else
                          Container(),
                      ])),
                )));
      }
    }
    return _nextLevelChildren;
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

  late GlobalKey<State>? _currentWidgetKey;

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
  @override
  Widget build(BuildContext context) {
    model = SampleModel.instance;
    _propertiesPanel =
        _PropertiesPanel(sampleModel: model, key: _propertiesPanelKey);
    return IgnorePointer(
        ignoring: !show,
        child: Container(
            color: show ? Colors.black54 : Colors.transparent,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Container(
                child: Opacity(
                    opacity: show ? 1.0 : 0.0,
                    child: _sampleDetails != null
                        ? Theme(
                            data: ThemeData(
                                brightness: model!.themeData.brightness,
                                primaryColor: model!.backgroundColor),
                            child: Scaffold(
                                key: scaffoldKey,
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
                                        backgroundColor:
                                            model!.webBackgroundColor,
                                        actions: <Widget>[
                                          if (_sampleDetails!
                                                  .needsPropertyPanel ==
                                              true)
                                            Container(
                                                height: 40,
                                                width: 40,
                                                child: Material(
                                                    color: model!
                                                        .webBackgroundColor,
                                                    shape: const CircleBorder(),
                                                    clipBehavior: Clip.hardEdge,
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
                                                    )))
                                          else
                                            Container(),
                                          Container(
                                            height: 40,
                                            width: 40,
                                            child: Material(
                                                color:
                                                    model!.webBackgroundColor,
                                                shape: const CircleBorder(),
                                                clipBehavior: Clip.hardEdge,
                                                child: IconButton(
                                                  hoverColor: Colors.grey
                                                      .withOpacity(0.3),
                                                  icon: Icon(Icons.close,
                                                      color:
                                                          model!.webIconColor),
                                                  onPressed: () {
                                                    model!.needToMaximize =
                                                        false;
                                                    final _OutputContainerState
                                                        _outputContainerState =
                                                        model!.outputContainerState
                                                            as _OutputContainerState;
                                                    _outputContainerState
                                                        .setState(() {
                                                      _outputContainerState
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
                                backgroundColor: model!.themeData.brightness ==
                                        Brightness.dark
                                    ? const Color.fromRGBO(33, 33, 33, 1)
                                    : Colors.white,
                                body: _currentWidgetKey?.currentWidget))
                        : Container()))));
  }
}
