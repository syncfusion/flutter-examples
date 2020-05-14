import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_examples/model/view.dart';
import 'package:flutter_examples/sb_web/web_view.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'model.dart';

void onTapControlItem(BuildContext context, SampleModel model, int position) {
  model.selectedIndex = position;
  Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
          builder: (BuildContext context) =>
              (model.isWeb && !Platform.isAndroid && !Platform.isIOS)
                  ? WebLayoutPage(sampleModel: model)
                  : const LayoutPage()));
}

void onTapControlItemWeb(
    BuildContext context, SampleModel model, Categoryy category, int position) {
  category.selectedIndex = position;
  Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
          builder: (BuildContext context) =>
              WebLayoutPage(sampleModel: model, category: category)));
}

void onTapSampleItem(BuildContext context, SubItem sample, SampleModel model) {
  model.sampleWidget[sample.key][1].sample = sample;
  Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
          builder: (BuildContext context) =>
              model.sampleWidget[sample.key][1]));
}

class BackPanel extends StatefulWidget {
  //ignore:prefer_const_constructors_in_immutables
  BackPanel(this.sample);
  final SubItem sample;

  @override
  _BackPanelState createState() => _BackPanelState(sample);
}

class _BackPanelState extends State<BackPanel> {
  _BackPanelState(this.sample);
  final SubItem sample;
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  void _afterLayout(dynamic _) {
    _getSizesAndPosition();
  }

  void _getSizesAndPosition() {
    final RenderBox renderBoxRed =
        _globalKey.currentContext?.findRenderObject();
    final Size size = renderBoxRed?.size;
    final Offset position = renderBoxRed?.localToGlobal(Offset.zero);
    const double appbarHeight = 60;
    BackdropState.frontPanelHeight = position == null
        ? 0
        : (position.dy + (size.height - appbarHeight) + 20);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleModel>(
      rebuildOnChange: true,
      builder: (BuildContext context, _, SampleModel model) {
        return Container(
          color: model.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  sample.title,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                      color: Colors.white,
                      letterSpacing: 0.53),
                ),
                sample.description != null
                    ? Padding(
                        key: _globalKey,
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text(
                          sample.description,
                          style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15.0,
                              color: Colors.white,
                              letterSpacing: 0.3,
                              height: 1.5),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FrontPanel extends StatefulWidget {
  //ignore:prefer_const_constructors_in_immutables
  FrontPanel(this.sampleList, this.sample, this.sourceLink, this.source);
  final SubItem sampleList;
  final dynamic sample;
  final String sourceLink;
  final String source;

  @override
  _FrontPanelState createState() =>
      _FrontPanelState(sampleList, sample, sourceLink, source);
}

class _FrontPanelState extends State<FrontPanel> {
  _FrontPanelState(this.sampleList, this.sample, this.sourceLink, this.source);
  final SubItem sampleList;
  final dynamic sample;
  final String sourceLink;
  final String source;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
              child: Container(child: sample),
            ),
            floatingActionButton: sourceLink == null
                ? null
                : Stack(children: <Widget>[
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 50, 0, 0),
                        child: Container(
                          height: 50,
                          child: InkWell(
                            onTap: () => launch(sourceLink),
                            child: Row(
                              children: <Widget>[
                                Text('Source: ',
                                    style: TextStyle(
                                        fontSize: 16, color: model.textColor)),
                                Text(source,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.blue)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ]),
          );
        });
  }
}

ScopedModelDescendant<SampleModel> getScopedModel(
    dynamic sampleWidget, SubItem sample,
    [Widget settingPanel, String sourceLink, String source]) {
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);
  return ScopedModelDescendant<SampleModel>(
      builder: (BuildContext context, _, SampleModel model) => SafeArea(
            child: sample == null
                ? Container()
                : Backdrop(
                    toggleFrontLayer:
                        sample.description != null && sample.description != '',
                    needCloseButton: false,
                    panelVisible: frontPanelVisible,
                    sampleListModel: model,
                    appBarAnimatedLeadingMenuIcon: AnimatedIcons.close_menu,
                    appBarActions: (sample.description != null &&
                            sample.description != '')
                        ? <Widget>[
                            (sample.codeLink != null && sample.codeLink != '')
                                ? Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      child: HandCursor(
                                        child: IconButton(
                                          icon: Image.asset(
                                              model.codeViewerIcon,
                                              color: Colors.white),
                                          onPressed: () {
                                            launch(sample.codeLink);
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Container(
                                height: 40,
                                width: 40,
                                child: HandCursor(
                                  child: IconButton(
                                    icon: Image.asset(model.informationIcon,
                                        color: Colors.white),
                                    onPressed: () {
                                      if (frontPanelVisible.value)
                                        frontPanelVisible.value = false;
                                      else
                                        frontPanelVisible.value = true;
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ]
                        : (sample.codeLink != null && sample.codeLink != '')
                            ? (<Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    child: HandCursor(
                                      child: IconButton(
                                        icon: Image.asset(model.codeViewerIcon,
                                            color: Colors.white),
                                        onPressed: () {
                                          launch(sample.codeLink);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ])
                            : null,
                    appBarTitle: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 1000),
                        child: Text(sample.title.toString())),
                    backLayer: BackPanel(sample),
                    frontLayer: settingPanel ??
                        FrontPanel(sample, sampleWidget, sourceLink, source),
                    sideDrawer: null,
                    headerClosingHeight: 350,
                    titleVisibleOnPanelClosed: true,
                    color: model.cardThemeColor,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12), bottom: Radius.circular(0)),
                  ),
          ));
}

Widget getSideDrawer(SampleModel _model) {
  return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
    double factor;
    if (_model.isTargetMobile) {
      if (constraints.maxHeight > constraints.maxWidth) {
        factor = 0.75;
      } else {
        factor = 0.45;
      }
    } else {
      if (constraints.maxHeight > constraints.maxWidth) {
        factor = 0.5;
      } else {
        factor = 0.4;
      }
    }
    return SizedBox(
        width: MediaQuery.of(context).size.width * factor,
        child: Drawer(
            child: Container(
          color: _model.drawerBackgroundColor,
          child: Column(
            children: <Widget>[
              Stack(children: <Widget>[
                _model.themeData.brightness == Brightness.light
                    ? Container(
                        padding: const EdgeInsets.fromLTRB(10, 30, 30, 10),
                        child: Image.asset('images/image_nav_banner.png',
                            fit: BoxFit.cover),
                      )
                    : Container(
                        padding: const EdgeInsets.fromLTRB(10, 30, 30, 10),
                        child: Image.asset(
                            'images/image_nav_banner_darktheme.png',
                            fit: BoxFit.cover),
                      )
              ]),
              Expanded(
                // ListView contains a group of widgets that scroll inside the drawer
                child: ListView(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                            child: Text('Fast . Fluid . Flexible',
                                style: TextStyle(
                                    color: _model.drawerTextIconColor,
                                    fontSize: 14,
                                    letterSpacing: 0.26,
                                    fontFamily: 'Roboto-Regular',
                                    fontWeight: FontWeight.normal)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                    splashColor: Colors.grey.withOpacity(0.4),
                                    onTap: () {
                                      Feedback.forLongPress(context);
                                      launch(
                                          'https://www.syncfusion.com/flutter-widgets');
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            25, 0, 0, 0),
                                        child: Column(
                                          children: <Widget>[
                                            const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10)),
                                            Row(children: <Widget>[
                                              Image.asset('images/product.png',
                                                  fit: BoxFit.contain,
                                                  height: 22,
                                                  width: 22,
                                                  color:
                                                      _model.drawerIconColor),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 0, 0, 0),
                                                child: Text('Product page',
                                                    style: TextStyle(
                                                        color: _model
                                                            .drawerTextIconColor,
                                                        fontSize: 16,
                                                        letterSpacing: 0.4,
                                                        fontFamily:
                                                            'Roboto-Regular',
                                                        fontWeight:
                                                            FontWeight.normal)),
                                              )
                                            ]),
                                            const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10)),
                                          ],
                                        )))),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                    splashColor: Colors.grey.withOpacity(0.4),
                                    onTap: () {
                                      Feedback.forLongPress(context);
                                      launch(
                                          'https://help.syncfusion.com/flutter/introduction/overview');
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            25, 0, 0, 0),
                                        child: Column(
                                          children: <Widget>[
                                            const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10)),
                                            Row(children: <Widget>[
                                              Image.asset(
                                                  'images/documentation.png',
                                                  fit: BoxFit.contain,
                                                  height: 22,
                                                  width: 22,
                                                  color:
                                                      _model.drawerIconColor),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 0, 0, 0),
                                                child: Text('Documentation',
                                                    style: TextStyle(
                                                        color: _model
                                                            .drawerTextIconColor,
                                                        fontSize: 16,
                                                        letterSpacing: 0.4,
                                                        fontFamily:
                                                            'Roboto-Regular',
                                                        fontWeight:
                                                            FontWeight.normal)),
                                              )
                                            ]),
                                            const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10)),
                                          ],
                                        )))),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 40, 0),
                      child: Container(
                          height: 2,
                          width: 5,
                          decoration:
                              BoxDecoration(color: _model.backgroundColor)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                            child: Row(children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: Text('Other products',
                                    style: TextStyle(
                                        color: _model.drawerTextIconColor,
                                        fontSize: 16,
                                        letterSpacing: 0.4,
                                        fontFamily: 'Roboto-Regular',
                                        fontWeight: FontWeight.bold)),
                              )
                            ]),
                          ),
                          const Padding(
                              padding: EdgeInsets.fromLTRB(0, 15, 0, 0)),
                          Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  splashColor: Colors.grey.withOpacity(0.4),
                                  onTap: () {
                                    Feedback.forLongPress(context);
                                    launch(
                                        'https://play.google.com/store/apps/details?id=com.syncfusion.samplebrowser&hl=en');
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      const Padding(
                                          padding: EdgeInsets.only(top: 10)),
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      25, 0, 0, 0),
                                              child: Image.asset(
                                                  'images/img_xamarin.png',
                                                  fit: BoxFit.contain,
                                                  height: 28,
                                                  width: 28)),
                                          Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 0, 0, 0),
                                              child: Text('Xamarin Demo',
                                                  style: TextStyle(
                                                      color: _model
                                                          .drawerTextIconColor,
                                                      fontSize: 16,
                                                      letterSpacing: 0.4,
                                                      fontFamily:
                                                          'Roboto-Regular',
                                                      fontWeight:
                                                          FontWeight.normal))),
                                          const Spacer(),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            child: Image.asset(
                                                'images/open_arrow.png',
                                                fit: BoxFit.contain,
                                                color: _model.paletteColor ??
                                                    Colors.blue,
                                                height: 16,
                                                width: 16),
                                          ),
                                        ],
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(top: 10)),
                                    ],
                                  ))),
                          Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  splashColor: Colors.grey.withOpacity(0.4),
                                  onTap: () {
                                    Feedback.forLongPress(context);
                                    launch(
                                        'https://play.google.com/store/apps/details?id=com.syncfusion.xamarin.uikit&hl=en');
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      const Padding(
                                          padding: EdgeInsets.only(top: 10)),
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      25, 0, 0, 0),
                                              child: Image.asset(
                                                  'images/img_xamarin_ui.png',
                                                  fit: BoxFit.contain,
                                                  height: 28,
                                                  width: 28)),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text('Xamarin UI kit Demo',
                                                style: TextStyle(
                                                    color: _model
                                                        .drawerTextIconColor,
                                                    fontSize: 16,
                                                    letterSpacing: 0.4,
                                                    fontFamily:
                                                        'Roboto-Regular',
                                                    fontWeight:
                                                        FontWeight.normal)),
                                          ),
                                          const Spacer(),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            child: Image.asset(
                                                'images/open_arrow.png',
                                                fit: BoxFit.contain,
                                                color: _model.paletteColor ??
                                                    Colors.blue,
                                                height: 16,
                                                width: 16),
                                          ),
                                        ],
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(top: 10)),
                                    ],
                                  ))),
                          Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  splashColor: Colors.grey.withOpacity(0.4),
                                  onTap: () {
                                    Feedback.forLongPress(context);
                                    launch(
                                        'https://play.google.com/store/apps/details?id=com.Syncfusion.ej2&hl=en');
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      const Padding(
                                          padding: EdgeInsets.only(top: 10)),
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      25, 0, 0, 0),
                                              child: Image.asset(
                                                  'images/img_JS.png',
                                                  fit: BoxFit.contain,
                                                  height: 28,
                                                  width: 28)),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text('JavaScript Demo',
                                                style: TextStyle(
                                                    color: _model
                                                        .drawerTextIconColor,
                                                    fontSize: 16,
                                                    letterSpacing: 0.4,
                                                    fontFamily:
                                                        'Roboto-Regular',
                                                    fontWeight:
                                                        FontWeight.normal)),
                                          ),
                                          const Spacer(),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            child: Image.asset(
                                                'images/open_arrow.png',
                                                fit: BoxFit.contain,
                                                color: _model.paletteColor ??
                                                    Colors.blue,
                                                height: 16,
                                                width: 16),
                                          ),
                                        ],
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(top: 10)),
                                    ],
                                  ))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // This container holds the align
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          'images/syncfusion.png',
                          fit: BoxFit.contain,
                          height: 50,
                          width: 100,
                          color: _model.drawerIconColor,
                        )),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Text('Version 18.1.52',
                            style: TextStyle(
                                color: _model.drawerTextIconColor,
                                fontSize: 12,
                                letterSpacing: 0.4,
                                fontFamily: 'Roboto-Regular',
                                fontWeight: FontWeight.normal)))
                  ],
                ),
              ),
            ],
          ),
        )));
  });
}

Widget getFooter(BuildContext context, SampleModel model) {
  final bool isMobile = MediaQuery.of(context).size.width < 500;
  return Container(
    height: 60,
    decoration: BoxDecoration(
      border: Border(
        top: BorderSide(width: 0.8, color: model.webDividerColor),
      ),
      color: model.webFooterColor,
    ),
    padding: isMobile
        ? EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.025, 0,
            MediaQuery.of(context).size.width * 0.025, 0)
        : EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.05, 0,
            MediaQuery.of(context).size.width * 0.05, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                HandCursor(
                  child: InkWell(
                    child: const Text('Documentation',
                        style: TextStyle(color: Colors.blue, fontSize: 12)),
                    onTap: () => launch(
                        'https://help.syncfusion.com/flutter/introduction/overview'),
                  ),
                ),
                Text(' | ',
                    style: TextStyle(
                        fontSize: 12, color: model.textColor.withOpacity(0.7))),
                HandCursor(
                  child: InkWell(
                    child: const Text('Forum',
                        style: TextStyle(color: Colors.blue, fontSize: 12)),
                    onTap: () =>
                        launch('https://www.syncfusion.com/forums/flutter'),
                  ),
                ),
                Text(' | ',
                    style: TextStyle(
                        fontSize: 12, color: model.textColor.withOpacity(0.7))),
                HandCursor(
                  child: InkWell(
                    child: const Text('Blog',
                        style: TextStyle(color: Colors.blue, fontSize: 12)),
                    onTap: () =>
                        launch('https://www.syncfusion.com/blogs/?s=flutter'),
                  ),
                ),
                Text(' | ',
                    style: TextStyle(
                        fontSize: 12, color: model.textColor.withOpacity(0.7))),
                HandCursor(
                  child: InkWell(
                    child: const Text('Knowledge base',
                        style: TextStyle(color: Colors.blue, fontSize: 12)),
                    onTap: () =>
                        launch('https://www.syncfusion.com/kb/flutter'),
                  ),
                )
              ],
            ),
            Container(
                padding: const EdgeInsets.only(top: 10),
                child: Text('Copyright © 2001 - 2020 Syncfusion Inc.',
                    style: TextStyle(
                        color: model.textColor.withOpacity(0.7),
                        fontSize: 12,
                        letterSpacing: 0.23)))
          ],
        )),
        isMobile
            ? HandCursor(
                child: InkWell(
                  onTap: () => launch('https://www.syncfusion.com'),
                  child: Image.asset(model.syncfusionIcon,
                      fit: BoxFit.contain, height: 25, width: 80),
                ),
              )
            : HandCursor(
                child: InkWell(
                  onTap: () => launch('https://www.syncfusion.com'),
                  child: Image.asset(model.syncfusionIcon,
                      fit: BoxFit.contain, height: 25, width: 120),
                ),
              ),
      ],
    ),
  );
}

///Right drawer theme settings for web
Widget showWebThemeSettings(SampleModel model) {
  return Drawer(
      child: Container(
          color: model.bottomSheetBackgroundColor,
          child: ScopedModel<SampleModel>(
              model: model,
              child: ScopedModelDescendant<SampleModel>(
                  rebuildOnChange: true,
                  builder: (BuildContext context, _, SampleModel model) =>
                      Column(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(top: 15),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('   Settings',
                                  style: TextStyle(
                                      color: model.textColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto-Medium')),
                              HandCursor(
                                child: IconButton(
                                    icon: Icon(Icons.close,
                                        color: model.webIconColor),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                              )
                            ],
                          ),
                          Expanded(
                            child: ListView(
                              children: <Widget>[
                                Column(children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 20, 0, 0),
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 0, 10, 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Expanded(
                                              child: HandCursor(
                                                child: RaisedButton(
                                                    color: model
                                                        .lightThemeSelected,
                                                    onPressed: () =>
                                                        _toggleLightTheme(
                                                            model),
                                                    child: Text(
                                                      'Light theme',
                                                      style: TextStyle(
                                                          color: model.lightThemeSelected ==
                                                                  const Color
                                                                          .fromRGBO(
                                                                      247,
                                                                      245,
                                                                      245,
                                                                      1)
                                                              ? Colors.black
                                                              : Colors.white,
                                                          fontSize: 14,
                                                          fontFamily:
                                                              'Roboto-Medium'),
                                                    )),
                                              ),
                                            ),
                                            Expanded(
                                              child: HandCursor(
                                                child: RaisedButton(
                                                    color:
                                                        model.darkThemeSelected,
                                                    onPressed: () =>
                                                        _toggleDarkTheme(model),
                                                    child: Text('Dark theme',
                                                        style: TextStyle(
                                                            color: model.darkThemeSelected ==
                                                                    const Color
                                                                            .fromRGBO(
                                                                        247,
                                                                        245,
                                                                        245,
                                                                        1)
                                                                ? Colors.black
                                                                : Colors.white,
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'Roboto-Medium'))),
                                              ),
                                            )
                                          ],
                                        ),
                                      ))
                                ]),
                                Container(
                                    padding: const EdgeInsets.only(
                                        top: 25, left: 15),
                                    child: const Text(
                                      'Theme colors',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(128, 128, 128, 1),
                                          fontSize: 14,
                                          fontFamily: 'Roboto-Regular'),
                                    )),
                                Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 25, 0, 0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 0, 10, 30),
                                            child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children:
                                                    _addColorPalettes(model)),
                                          ),
                                        ),
                                      ],
                                    )),
                                Container(
                                  height: 44,
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: HandCursor(
                                    child: RaisedButton(
                                        color: model.backgroundColor,
                                        onPressed: () =>
                                            _applySetting(model, context),
                                        child: const Text('APPLY',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Roboto-Bold',
                                                color: Colors.white))),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )))));
}

void _applySetting(SampleModel model, BuildContext context) {
  model.backgroundColor = model.currentBackgroundColor;
  if (model.isLightThemeSelected) {
    model.lightThemeSelected = model.backgroundColor;
    model.darkThemeSelected = model.themeData.brightness == Brightness.light
        ? const Color.fromRGBO(79, 85, 102, 1)
        : const Color.fromRGBO(247, 245, 245, 1);
  } else {
    model.darkThemeSelected = model.backgroundColor;
    model.lightThemeSelected = model.themeData.brightness == Brightness.light
        ? const Color.fromRGBO(79, 85, 102, 1)
        : const Color.fromRGBO(247, 245, 245, 1);
  }
  model.listIconColor = model.currentListIconColor;
  model.paletteColor = model.currentPaletteColor;
  model.changeTheme(model.currentThemeData);
  // ignore: invalid_use_of_protected_member
  model.notifyListeners();
  Navigator.pop(context);
}

void _toggleLightTheme(SampleModel model) {
  model.isLightThemeSelected = true;
  model.lightThemeSelected = model.backgroundColor;
  model.darkThemeSelected = model.themeData.brightness == Brightness.light
      ? const Color.fromRGBO(247, 245, 245, 1)
      : const Color.fromRGBO(79, 85, 102, 1);
  model.currentThemeData = ThemeData.light();
  // ignore: invalid_use_of_protected_member
  model.notifyListeners();
}

void _toggleDarkTheme(SampleModel model) {
  model.isLightThemeSelected = false;
  model.darkThemeSelected = model.backgroundColor;
  model.lightThemeSelected = model.themeData.brightness == Brightness.light
      ? const Color.fromRGBO(247, 245, 245, 1)
      : const Color.fromRGBO(79, 85, 102, 1);
  model.currentThemeData = ThemeData.dark();
  // ignore: invalid_use_of_protected_member
  model.notifyListeners();
}

List<Widget> _addColorPalettes(SampleModel model) {
  final List<Widget> colorPaletteWidgets = <Widget>[];
  for (int i = 0; i < model.colors.length; i++) {
    colorPaletteWidgets.add(Material(
        color: model.bottomSheetBackgroundColor,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: model.defaultBorderColor[i], width: 2.0),
            shape: BoxShape.circle,
          ),
          child: HandCursor(
            child: InkWell(
              onTap: () => _changeColorPalette(model, i),
              child: Icon(
                Icons.brightness_1,
                size: 40.0,
                color: model.colors[i],
              ),
            ),
          ),
        )));
  }
  return colorPaletteWidgets;
}

void _changeColorPalette(SampleModel model, int index) {
  for (int j = 0; j < model.defaultBorderColor.length; j++) {
    model.defaultBorderColor[j] = Colors.transparent;
  }
  model.defaultBorderColor[index] = model.colors[index];
  model.currentBackgroundColor = model.colors[index];
  model.currentListIconColor = model.colors[index];
  model.currentPaletteColor = model.colors[index];
  // ignore: invalid_use_of_protected_member
  model.notifyListeners();
}

String getStatus(
  SubItem item,
) {
  const bool isWeb = kIsWeb;
  String status = '';
  if (item.subItems == null) {
    status = (item.status == 'new' || item.status == 'New')
        ? (isWeb ? 'New' : 'N')
        : (item.status == 'updated' || item.status == 'Updated')
            ? (isWeb ? 'Updated' : 'U')
            : '';
  } else {
    int newCount = 0;
    int updateCount = 0;
    for (int i = 0; i < item.subItems.length; i++) {
      if (item.subItems[i].subItems == null) {
        if (item.subItems[i].status == 'New' ||
            item.subItems[i].status == 'new') {
          newCount++;
        } else if (item.subItems[i].status == 'Updated' ||
            item.subItems[i].status == 'updated') {
          updateCount++;
        }
      } else {
        for (int j = 0; j < item.subItems[i].subItems.length; j++) {
          if (item.subItems[i].subItems[j].status == 'New' ||
              item.subItems[i].subItems[j].status == 'new') {
            newCount++;
          } else if (item.subItems[i].subItems[j].status == 'Updated' ||
              item.subItems[i].subItems[j].status == 'updated') {
            updateCount++;
          }
        }
      }
    }
    status = (newCount != 0 && newCount == item.subItems.length)
        ? (isWeb ? 'New' : 'N')
        : (newCount != 0 || updateCount != 0) ? (isWeb ? 'Updated' : 'U') : '';
  }
  return status;
}
