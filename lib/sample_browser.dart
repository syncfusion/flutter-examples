import 'dart:async';
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'model/helper.dart';
import 'model/model.dart';
import 'samples/chart/cartesian_charts/bar_series/customized_bar_chart.dart';
import 'widgets/animateOpacityWidget.dart';
import 'widgets/search_bar.dart';
import 'widgets/shared/mobile.dart'
    if (dart.library.html) 'widgets/shared/web.dart';

//ignore: must_be_immutable
class SampleBrowser extends StatelessWidget {
  ThemeData systemTheme;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Demos & Examples of Syncfusion Flutter Widgets',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        home: Builder(builder: (BuildContext context) {
          systemTheme = Theme.of(context);
          return HomePage(sampleBrowser: this);
        }));
  }
}

//ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({this.sampleBrowser});
  SampleBrowser sampleBrowser;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SampleModel sampleListModel;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int columnCount;
  double _cardWidth;
  double _sidePadding;
  final dynamic controller = ScrollController();
  @override
  void initState() {
    sampleListModel = SampleModel.instance;
    sampleListModel.isWeb = kIsWeb;
    if (sampleListModel.isWeb) {
      sampleListModel.currentThemeData = ThemeData.light();
      sampleListModel.paletteBorderColors = <Color>[];
      sampleListModel.changeTheme(sampleListModel.currentThemeData);
    } else {
      sampleListModel.currentThemeData =
          widget.sampleBrowser.systemTheme.brightness != Brightness.dark
              ? ThemeData.light()
              : ThemeData.dark();
      sampleListModel.changeTheme(widget.sampleBrowser.systemTheme);
    }
    _addColors();
    _init();
    sampleListModel.addListener(_handleChange);
    super.initState();
  }

  void _handleChange() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _init() async {
    final ByteData data = await rootBundle.load('images/dashline.png');
    image = await _loadImage(Uint8List.view(data.buffer));
  }

  Future<ui.Image> _loadImage(List<int> img) async {
    final Completer<ui.Image> completer = Completer<ui.Image>();
    ui.decodeImageFromList(img, (ui.Image img) {
      setState(() {
        isImageloaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final SampleModel model = sampleListModel;
    model.isMobileResolution = (MediaQuery.of(context).size.width) < 768;
    return MaterialApp(
      title: 'Demos & Examples of Syncfusion Flutter Widgets',
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: model.isMobileResolution
            ? Scaffold(
                resizeToAvoidBottomPadding: true,
                drawer: getSideDrawer(model),
                key: scaffoldKey,
                backgroundColor: model.webBackgroundColor,
                endDrawer: model.isWeb ? showWebThemeSettings(model) : null,
                appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(46.0),
                    child: AppBar(
                      elevation: 0.0,
                      backgroundColor: model.paletteColor,
                      title: AnimateOpacityWidget(
                          controller: controller,
                          opacity: 0,
                          child: const Text('Flutter UI Widgets',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: 'HeeboMedium'))),
                      actions: <Widget>[
                        Container(
                          height: 40,
                          width: 40,
                          child: IconButton(
                            icon:
                                const Icon(Icons.settings, color: Colors.white),
                            onPressed: () {
                              model.isWeb
                                  ? scaffoldKey.currentState.openEndDrawer()
                                  : showBottomSettingsPanel(
                                      model, context, widget);
                            },
                          ),
                        ),
                      ],
                    )),
                body: Container(
                    transform: Matrix4.translationValues(0, -1, 0),
                    child: _getScrollableWidget(model)))
            : Scaffold(
                key: scaffoldKey,
                backgroundColor: model.webBackgroundColor,
                endDrawer: showWebThemeSettings(model),
                resizeToAvoidBottomPadding: true,
                appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(90.0),
                    child: AppBar(
                      leading: Container(),
                      elevation: 0.0,
                      backgroundColor: model.paletteColor,
                      flexibleSpace: Container(
                          transform: Matrix4.translationValues(0, 4, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(24, 10, 0, 0),
                                  child: Row(children: <Widget>[
                                    const Text('Flutter UI Widgets ',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 28,
                                            letterSpacing: 0.53,
                                            fontFamily: 'Roboto-Bold')),
                                    Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            3, 0, 3, 0),
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: Color.fromRGBO(
                                                245, 188, 14, 1)),
                                        child: const Text(
                                          'BETA',
                                          style: TextStyle(
                                              fontSize: 14,
                                              letterSpacing: 0.26,
                                              fontFamily: 'Roboto-Medium',
                                              color: Colors.black),
                                        ))
                                  ])),
                              const Padding(
                                  padding: EdgeInsets.fromLTRB(24, 0, 0, 0),
                                  child: Text('Fast . Fluid . Flexible',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: 'Roboto-Regular',
                                          letterSpacing: 0.26,
                                          fontWeight: FontWeight.normal))),
                              const Padding(
                                padding: EdgeInsets.only(top: 15),
                              ),
                              Container(
                                  alignment: Alignment.bottomCenter,
                                  width: double.infinity,
                                  height: 16,
                                  decoration: BoxDecoration(
                                      color: model.webBackgroundColor,
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12.0),
                                          topRight: Radius.circular(12.0)),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: model.webBackgroundColor,
                                          offset: const Offset(0, 2.0),
                                          blurRadius: 0.25,
                                        )
                                      ]))
                            ],
                          )),
                      actions: <Widget>[
                        MediaQuery.of(context).size.width < 500
                            ? Container(height: 0, width: 9)
                            : Container(
                                child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 10, right: 10),
                                    width: MediaQuery.of(context).size.width >=
                                            830
                                        ? 400
                                        : MediaQuery.of(context).size.width / 2,
                                    height: MediaQuery.of(context).size.height *
                                        0.0445,
                                    child: HandCursor(
                                      child: SearchBar(
                                        sampleListModel: model,
                                      ),
                                    ))),
                        Container(
                          padding: MediaQuery.of(context).size.width < 500
                              ? const EdgeInsets.only(top: 20, left: 5)
                              : const EdgeInsets.only(top: 10, right: 20),
                          height: 60,
                          width: 60,
                          child: HandCursor(
                            child: IconButton(
                              icon: const Icon(Icons.settings,
                                  color: Colors.white),
                              onPressed: () {
                                scaffoldKey.currentState.openEndDrawer();
                              },
                            ),
                          ),
                        ),
                      ],
                    )),
                body: _getWebBodyWidget(model)),
      ),
    );
  }

  /// get scrollable widget to getting stickable view
  Widget _getScrollableWidget(SampleModel model) {
    final List<Widget> searchResults = _getSearchedItems(model);
    return Container(
        color: model.paletteColor,
        child: GlowingOverscrollIndicator(
            color: model.paletteColor,
            axisDirection: AxisDirection.down,
            child: CustomScrollView(
              controller: controller,
              physics: const ClampingScrollPhysics(),
              slivers: <Widget>[
                SliverToBoxAdapter(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Text('Flutter UI Widgets',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              letterSpacing: 0.53,
                              fontFamily: 'HeeboBold',
                              fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 8, 0, 0),
                      child: Text('Fast . Fluid . Flexible',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              letterSpacing: 0.26,
                              fontFamily: 'HeeboBold',
                              fontWeight: FontWeight.normal)),
                    )
                  ],
                )),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: PersistentHeaderDelegate(model),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(<Widget>[
                    Container(
                        color: model.webBackgroundColor,
                        child: searchResults.isNotEmpty
                            ? Container(
                                height: MediaQuery.of(context).size.height,
                                child: ListView(children: searchResults))
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _getControls(model, context))),
                  ]),
                )
              ],
            )));
  }

  /// Add the palette colors
  void _addColors() {
    sampleListModel.paletteColors = <Color>[
      const Color.fromRGBO(0, 116, 227, 1),
      const Color.fromRGBO(230, 74, 25, 1),
      const Color.fromRGBO(216, 27, 96, 1),
      const Color.fromRGBO(103, 58, 184, 1),
      const Color.fromRGBO(2, 137, 123, 1)
    ];
    sampleListModel.darkPaletteColors = <Color>[
      const Color.fromRGBO(68, 138, 255, 1),
      const Color.fromRGBO(255, 110, 64, 1),
      const Color.fromRGBO(238, 79, 132, 1),
      const Color.fromRGBO(180, 137, 255, 1),
      const Color.fromRGBO(29, 233, 182, 1)
    ];
    sampleListModel.paletteBorderColors = <Color>[
      const Color.fromRGBO(0, 116, 227, 1),
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent
    ];
  }

  /// get the home page body contents in the web
  Widget _getWebBodyWidget(SampleModel model) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    _sidePadding = deviceWidth > 1060
        ? deviceWidth * 0.038
        : deviceWidth >= 768 ? deviceWidth * 0.041 : deviceWidth * 0.05;
    final Widget _controlWidget = Container(
        padding: EdgeInsets.only(
           top:deviceWidth > 1060 ? 15 : 10),
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _getControls(model, context),
        ));
    return MediaQuery.of(context).size.height < 700 ||
            (MediaQuery.of(context).size.height < 840 &&
                MediaQuery.of(context).size.width <= 1060)
        ? SizedBox(
            height: MediaQuery.of(context).size.height - 60,
            child: ListView(children: <Widget>[
              Container(color: model.webBackgroundColor, child: _controlWidget),
              Container(height: _sidePadding),
              getFooter(context, model)
            ]))
        : SizedBox(
            child: ListView(children: <Widget>[
            Container(
              padding: const EdgeInsets.only(bottom: 4),
                height: MediaQuery.of(context).size.height - 150,
                color: model.webBackgroundColor,
                child: _controlWidget),
            getFooter(context, model)
          ]));
  }

  /// get category wise control list resolution base
  List<Widget> _getControls(SampleModel model, BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    num padding;
    if (deviceWidth > 1060) {
      padding = deviceWidth * 0.011;
      _cardWidth = (deviceWidth * 0.9) / 3;
      ///setting max cardwidth, spcing between cards in higher resolutions
      if (deviceWidth > 3000){
        _cardWidth = 2800/3;
        _sidePadding = (deviceWidth - 2740) * 0.5;
        padding = 30;
      }
      columnCount = 3;
      return <Widget>[
        Padding(padding: EdgeInsets.only(left: _sidePadding)),
        Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          _getCategoryWidget(model, model.categoryList[0]),
          Padding(padding: EdgeInsets.only(top: padding)),
          _getCategoryWidget(model, model.categoryList[2]),
          Padding(padding: EdgeInsets.only(top: padding)),
          _getCategoryWidget(model, model.categoryList[3]),
        ]),
        Padding(padding: EdgeInsets.only(left: padding)),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[_getCategoryWidget(model, model.categoryList[1])],
        ),
        Padding(padding: EdgeInsets.only(left: padding)),
        Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          _getCategoryWidget(model, model.categoryList[4]),
        ]),
        Padding(padding: EdgeInsets.only(left: _sidePadding))
      ];
    } else if (deviceWidth >= 768) {
      padding = deviceWidth * 0.018;
      _cardWidth = (deviceWidth * 0.9) / 2;
      columnCount = 2;
      return <Widget>[
        Padding(padding: EdgeInsets.only(left: _sidePadding)),
        Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          _getCategoryWidget(model, model.categoryList[0]),
          Padding(padding: EdgeInsets.only(top: padding)),
          _getCategoryWidget(model, model.categoryList[1])
        ]),
        Padding(padding: EdgeInsets.only(left: padding)),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _getCategoryWidget(model, model.categoryList[2]),
            Padding(padding: EdgeInsets.only(top: padding)),
            _getCategoryWidget(model, model.categoryList[3]),
            Padding(padding: EdgeInsets.only(top: padding)),
            _getCategoryWidget(model, model.categoryList[4]),
            Padding(padding: EdgeInsets.only(top: padding)),
          ],
        ),
        Padding(padding: EdgeInsets.only(left: _sidePadding)),
      ];
    } else {
      columnCount = 1;
      _cardWidth = deviceWidth * 0.9;
      padding = deviceWidth * 0.035;
      _sidePadding = (deviceWidth * 0.1) / 2;
      return <Widget>[
        Padding(padding: EdgeInsets.only(left: _sidePadding)),
        Column(children: <Widget>[
          Padding(padding: EdgeInsets.only(top: (_sidePadding - 16).abs())),
          _getCategoryWidget(model, model.categoryList[0]),
          Padding(padding: EdgeInsets.only(top: padding)),
          _getCategoryWidget(model, model.categoryList[1]),
          Padding(padding: EdgeInsets.only(top: padding)),
          _getCategoryWidget(model, model.categoryList[2]),
          Padding(padding: EdgeInsets.only(top: padding)),
          _getCategoryWidget(model, model.categoryList[3]),
          Padding(padding: EdgeInsets.only(top: padding)),
          _getCategoryWidget(model, model.categoryList[4]),
          Padding(padding: EdgeInsets.only(top: _sidePadding)),
        ]),
        Padding(padding: EdgeInsets.only(left: _sidePadding)),
      ];
    }
  }

  /// get the rounded corner layout for given category
  Widget _getCategoryWidget(SampleModel model, WidgetCategory category) {
    final double width = _cardWidth;
    return Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: model.webCardColor,
            border: Border.all(
                color: const Color.fromRGBO(0, 0, 0, 0.12), width: 1.1),
            borderRadius: const BorderRadius.all(Radius.circular(12))),
        width: width,
        child: Column(children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 15, bottom: 2),
            child: Text(
              category.categoryName,
              style: TextStyle(
                  color: model.backgroundColor,
                  fontSize: 16,
                  fontFamily: 'Roboto-Bold'),
            ),
          ),
          Divider(
            color: model.themeData.brightness == Brightness.dark
                ? const Color.fromRGBO(61, 61, 61, 1)
                : const Color.fromRGBO(238, 238, 238, 1),
            thickness: 1,
          ),
          Column(children: _getControlListView(category, model))
        ]));
  }

  /// get the list view of the controls in the specified category
  List<Widget> _getControlListView(WidgetCategory category, SampleModel model) {
    final List<Widget> items = <Widget>[];
    String status;
    for (int i = 0; i < category.controlList.length; i++) {
      final Control control = category.controlList[i];
      status =
          (control.status == 'preview' || control.status == 'Preview') &&
                  !model.isWeb &&
                  Platform.isIOS
              ? 'New'
              : control.status;
      items.add(HandCursor(
        child: Container(
            color: model.webCardColor,
            child: Material(
                color: model.webCardColor,
                elevation: 0.0,
                child: InkWell(
                    splashFactory: InkRipple.splashFactory,
                    hoverColor: Colors.grey.withOpacity(0.2),
                    onTap: () {
                      !model.isWeb
                          ? onTapControlItem(context, model, category, i)
                          : onTapControlItemWeb(context, model, category, i);
                      model.searchResults.clear();
                    },
                    child: Container(
                      child: ListTile(
                        contentPadding:  EdgeInsets.fromLTRB(12, 2, 0, category.controlList.length > 3 ? 6 :0),
                        leading: Image.asset(control.image, fit: BoxFit.cover),
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                control.title,
                                textAlign: TextAlign.left,
                                softWrap: true,
                                textScaleFactor: 1,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                    fontSize: 12,
                                    letterSpacing: 0.1,
                                    color: model.textColor,
                                    fontFamily: 'Roboto-Bold'),
                              ),
                              status != null
                                  ? Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: status.toLowerCase() == 'new'
                                              ? const Color.fromRGBO(
                                                  55, 153, 30, 1)
                                              : status.toLowerCase() == 'updated'
                                                  ? const Color.fromRGBO(
                                                      246, 117, 0, 1)
                                                  : status.toLowerCase() == 'preview'
                                                      ? const Color.fromRGBO(
                                                          74, 90, 231, 1)
                                                      : Colors.transparent,
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10))),
                                      padding: const EdgeInsets.fromLTRB(6, 2.7, 4, 2.7),
                                      child: Text(status, style: const TextStyle(fontFamily: 'Roboto-Medium', color: Colors.white, fontSize: 10.5)))
                                  : Container()
                            ]),
                        subtitle: Container(
                            child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 7.0, 12.0, 0.0),
                          child: Text(
                            control.description,
                            textAlign: TextAlign.left,
                            softWrap: true,
                            textScaleFactor: 1,
                            overflow: TextOverflow.fade,
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                              color: Color.fromRGBO(128, 128, 128, 1),
                            ),
                          ),
                        )),
                      ),
                    )))),
      ));
    }
    return items;
  }

  /// returns searched result
  List<Widget> _getSearchedItems(SampleModel model) {
    final List<Widget> items = <Widget>[];
    for (int i = 0; i < model.sampleList.length; i++) {
      items.add(Material(
          elevation: 0.0,
          color: model.webBackgroundColor,
          child: InkWell(
              splashColor: Colors.grey.withOpacity(0.4),
              onTap: () {
                Feedback.forLongPress(context);
                expandSample(context, model.sampleList[i], model);
              },
              child: Container(
                alignment: Alignment.centerLeft,
                height: 40,
                padding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  softWrap: true,
                  maxLines: 1,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: model.sampleList[i].title,
                          style: TextStyle(
                              fontFamily: 'HeeboMedium',
                              fontWeight: FontWeight.normal,
                              fontSize: 14.0,
                              color: model.textColor,
                              letterSpacing: 0.3)),
                    ],
                  ),
                ),
              ))));
      items.add(Divider(
        color: model.webDividerColor,
        thickness: 1,
      ));
    }

    if (model.sampleList.isEmpty && model.controlList.isEmpty) {
      items.add(
        Container(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            color: model.webBackgroundColor,
            child: Center(
                child: Text('No results found',
                    style: TextStyle(color: model.textColor, fontSize: 15)))),
      );
    }
    return items;
  }
}

/// Search bar, rounded corner
class PersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  PersistentHeaderDelegate(SampleModel sampleModel) {
    _sampleListModel = sampleModel;
  }
  SampleModel _sampleListModel;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      height: 90,
      child: Container(
          color: _sampleListModel.paletteColor,
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                height: 70,
                child: SearchBar(sampleListModel: _sampleListModel),
              ),
              Container(
                  height: 20,
                  decoration: BoxDecoration(
                      color: _sampleListModel.webBackgroundColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: _sampleListModel.webBackgroundColor,
                          offset: const Offset(0, 2.0),
                          blurRadius: 0.25,
                        )
                      ])),
            ],
          )),
    );
  }

  @override
  double get maxExtent => 90;

  @override
  double get minExtent => 90;

  @override
  bool shouldRebuild(PersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
