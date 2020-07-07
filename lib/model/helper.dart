/// Package imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Local imports
import '../sample_browser.dart';
import '../sb_web/web_view.dart';
import '../widgets/bottom_sheet.dart';
import '../widgets/flutter_backdrop.dart';
import '../widgets/shared/mobile.dart'
    if (dart.library.html) '../widgets/shared/web.dart';
import 'model.dart';
import 'sample_view.dart';
import 'view.dart';


/// On tap the button, select the samples.
void onTapControlItem(BuildContext context, SampleModel model,
    WidgetCategory category, int position) {
  category.selectedIndex = position;
  Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
          builder: (BuildContext context) =>
              LayoutPage(sampleModel: model, category: category)));
}

/// On tap the mouse, select the samples in web. 
void onTapControlItemWeb(BuildContext context, SampleModel model,
    WidgetCategory category, int position) {
  category.selectedIndex = position;
  Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
          builder: (BuildContext context) =>
              WebLayoutPage(sampleModel: model, category: category)));
}

/// On tap the expand button, get the fullview sample.
void expandSample(BuildContext context, SubItem subItem, SampleModel model) {
  model.isCardView = false;

/// Replace dynamic to SampleView.
  final dynamic _renderSample = model.sampleWidget[subItem.key];
  final SampleView _sampleView = _renderSample(GlobalKey<State>());
  Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => FullViewSampleLayout(
                sampleWidget: _sampleView,
                sample: subItem,
              )));
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
    final RenderBox _renderBoxRed =
        _globalKey.currentContext?.findRenderObject();
    final Size _size = _renderBoxRed?.size;
    final Offset _position = _renderBoxRed?.localToGlobal(Offset.zero);
    const double _appbarHeight = 60;
    BackdropState.frontPanelHeight = _position == null
        ? 0
        : (_position.dy + (_size.height - _appbarHeight) + 20);
  }

  @override
  Widget build(BuildContext context) {
    final SampleModel _model = SampleModel.instance;
    return Container(
      color: _model.paletteColor,
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
  }
}

class FullViewSampleLayout extends StatelessWidget {
  const FullViewSampleLayout({this.sample, this.sampleWidget});
  final SubItem sample;
  final Widget sampleWidget;
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> _frontPanelVisible = ValueNotifier<bool>(true);
    final SampleModel _model = SampleModel.instance;
    final bool _needsFloatingBotton =
        (sample.sourceLink != null && sample.sourceLink != '') ||
            sample.needsPropertyPanel == true;
    final bool _needPadding = sample.codeLink != null && sample.codeLink.contains('/chart/');
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => SafeArea(
              child: sample == null
                  ? Container()
                  : Backdrop(
                      toggleFrontLayer: sample.description != null &&
                          sample.description != '',
                      needCloseButton: false,
                      panelVisible: _frontPanelVisible,
                      sampleListModel: _model,
                      appBarAnimatedLeadingMenuIcon: AnimatedIcons.close_menu,
                      appBarActions: (sample.description != null &&
                              sample.description != '')
                          ? <Widget>[
                              (sample.codeLink != null && sample.codeLink != '')
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 10, 0),
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        child: HandCursor(
                                          child: IconButton(
                                            icon: Image.asset('images/code.png',
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
                                      icon: Image.asset('images/info.png',
                                          color: Colors.white),
                                      onPressed: () {
                                        if (_frontPanelVisible.value)
                                          _frontPanelVisible.value = false;
                                        else
                                          _frontPanelVisible.value = true;
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
                                          icon: Image.asset('images/code.png',
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
                      frontLayer: Scaffold(
                        backgroundColor: _model.cardThemeColor, 
                        body: Padding(
                          padding:_needPadding ? EdgeInsets.fromLTRB(
                              5, 0, 5, _needsFloatingBotton ? 50 : 0) :
                              const EdgeInsets.all(0),
                          child: Container(child: sampleWidget),
                        ),
                        floatingActionButton: _needsFloatingBotton
                            ? Stack(children: <Widget>[
                                (sample.sourceLink != null &&
                                        sample.sourceLink != '')
                                    ? Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(
                                              30, _needPadding ? 50 : 0, 0, 0),
                                          child: Container(
                                            height: 50,
                                            width: 250,
                                            child: InkWell(
                                              onTap: () =>
                                                  launch(sample.sourceLink),
                                              child: Row(
                                                children: <Widget>[
                                                  Text('Source: ',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: _model
                                                              .textColor)),
                                                  Text(sample.sourceText,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.blue)),
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
                                            final GlobalKey _sampleKey =
                                                sampleWidget.key;
                                            final SampleViewState _sampleState =
                                                _sampleKey.currentState;
                                            final Widget _settingsContent =
                                                _sampleState
                                                    .buildSettings(context);
                                            getBottomSheet(
                                                context, _settingsContent);
                                          },
                                          child: const Icon(Icons.graphic_eq,
                                              color: Colors.white),
                                          backgroundColor:
                                              _model.paletteColor,
                                        ),
                                      ),
                              ])
                            : null,
                      ),
                      sideDrawer: null,
                      headerClosingHeight: 350,
                      titleVisibleOnPanelClosed: true,
                      color: _model.cardThemeColor,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12), bottom: Radius.circular(0)),
                    ),
            ));
  }
}

/// Remove this.
Widget getScopedModel(Widget widgetWithoutSettingPanel, SubItem sample,
    [Widget widgetWithSettingPanel, String sourceLink, String sourceText]) {
  return null;
}

/// Darwer to show the product related links.
Widget getSideDrawer(SampleModel _model) {
  return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
    return SizedBox(
        width: MediaQuery.of(context).size.width *
            (MediaQuery.of(context).size.width < 600 ? 0.7 : 0.4),
        child: Drawer(
            child: Container(
          color: _model.themeData.brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
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
                                                  color: _model.webIconColor),
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
                                                  color: _model.webIconColor),
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
                          color: _model.backgroundColor),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 3, 0),
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
                                                      15, 0, 0, 0),
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
                                            child: Icon(Icons.arrow_forward,
                                                color: _model.backgroundColor ??
                                                    Colors.blue),
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
                                                      15, 0, 0, 0),
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
                                            child: Icon(Icons.arrow_forward,
                                                color: _model.backgroundColor ??
                                                    Colors.blue),
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
                                                      15, 0, 0, 0),
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
                                            child: Icon(Icons.arrow_forward,
                                                color: _model.backgroundColor ??
                                                    Colors.blue),
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
                          _model.syncfusionIcon,
                          fit: BoxFit.contain,
                          height: 50,
                          width: 100,
                        )),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Text('Version 18.2.44',
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

/// Shows copyright message, product related links at the bottom of the home page.
Widget getFooter(BuildContext context, SampleModel model) {
  final bool _isMobile = MediaQuery.of(context).size.width < 768;
  return Container(
    height: 60,
    decoration: BoxDecoration(
      border: Border(
        top: BorderSide(width: 0.8, color: model.webDividerColor),
      ),
      color: model.themeData.brightness == Brightness.dark
          ? const Color.fromRGBO(33, 33, 33, 1)
          : const Color.fromRGBO(234, 234, 234, 1),
    ),
    padding: _isMobile
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
        _isMobile
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

/// Show Right drawer which contains theme settings for web.
Widget showWebThemeSettings(SampleModel model) {
  int _selectedValue = model.selectedThemeValue;
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    final double _width = MediaQuery.of(context).size.width * 0.4;
    final Color _textColor = model.themeData.brightness == Brightness.light
        ? const Color.fromRGBO(84, 84, 84, 1)
        : const Color.fromRGBO(218, 218, 218, 1);
    return Drawer(
        child: Container(
            color: model.bottomSheetBackgroundColor,
            child: Column(
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
                          icon: Icon(Icons.close, color: model.webIconColor),
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
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return CupertinoSegmentedControl<int>(
                                children: <int, Widget>{
                                  0: Container(
                                      width: _width,
                                      alignment: Alignment.center,
                                      child: Text('Light theme',
                                          style: TextStyle(
                                              color: _selectedValue == 0
                                                  ? Colors.white
                                                  : _textColor,
                                              fontFamily: 'Roboto-Medium'))),
                                  1: Container(
                                      width: _width,
                                      alignment: Alignment.center,
                                      child: Text('Dark theme',
                                          style: TextStyle(
                                              color: _selectedValue == 1
                                                  ? Colors.white
                                                  : _textColor,
                                              fontFamily: 'Roboto-Medium')))
                                },
                                padding: const EdgeInsets.all(5),
                                unselectedColor: Colors.transparent,
                                selectedColor: model.paletteColor,
                                pressedColor: model.paletteColor,
                                borderColor: model.paletteColor,
                                groupValue: _selectedValue,
                                onValueChanged: (int value) {
                                  _selectedValue = value;
                                  if (value == 0) {
                                    model.currentThemeData = ThemeData.light();
                                  } else {
                                    model.currentThemeData = ThemeData.dark();
                                  }
                                  setState(() {});
                                },
                              );
                            }))
                      ]),
                      Container(
                          padding: const EdgeInsets.only(top: 25, left: 15),
                          child: const Text(
                            'Theme colors',
                            style: TextStyle(
                                color: Color.fromRGBO(128, 128, 128, 1),
                                fontSize: 14,
                                fontFamily: 'Roboto-Regular'),
                          )),
                      Container(
                          padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 10, 30),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children:
                                          _addColorPalettes(model, setState)),
                                ),
                              ),
                            ],
                          )),
                      Container(
                        height: 44,
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: HandCursor(
                          child: RaisedButton(
                              color: model.paletteColor,
                              onPressed: () =>
                                  _applySetting(model, context, _selectedValue),
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
            )));
  });
}

/// Apply the selected theme to the whole application.
void _applySetting(SampleModel model, BuildContext context, int selectedValue) {
  model.selectedThemeValue = selectedValue;
  model.backgroundColor = model.currentThemeData.brightness == Brightness.dark 
                        ? model.currentPrimaryColor : model.currentPaletteColor;
  model.paletteColor = model.currentPaletteColor;
  model.changeTheme(model.currentThemeData);
  // ignore: invalid_use_of_protected_member
  model.notifyListeners();
  Navigator.pop(context);
}

/// Adding the palette color in the theme setting panel.
List<Widget> _addColorPalettes(SampleModel model, [StateSetter setState]) {
  final List<Widget> _colorPaletteWidgets = <Widget>[];
  for (int i = 0; i < model.paletteColors.length; i++) {
    _colorPaletteWidgets.add(Material(
        color: model.bottomSheetBackgroundColor,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: model.paletteBorderColors[i], width: 2.0),
            shape: BoxShape.circle,
          ),
          child: HandCursor(
            child: InkWell(
              onTap: () => _changeColorPalette(model, i, setState),
              child: Icon(
                Icons.brightness_1,
                size: 40.0,
                color: model.paletteColors[i],
              ),
            ),
          ),
        )));
  }
  return _colorPaletteWidgets;
}

/// Changing the palete color of the application.
void _changeColorPalette(SampleModel model, int index, [StateSetter setState]) {
  for (int j = 0; j < model.paletteBorderColors.length; j++) {
    model.paletteBorderColors[j] = Colors.transparent;
  }
  model.paletteBorderColors[index] = model.paletteColors[index];
  model.currentPaletteColor = model.paletteColors[index];
  model.currentPrimaryColor =  model.darkPaletteColors[index];
  // ignore: invalid_use_of_protected_member
  model.isWeb ? setState(() {}) : model.notifyListeners();
}

/// Getting status of the control/subitems/sample.
String getStatus(SubItem item) {
  const bool _isWeb = kIsWeb;
  String status = '';
  if (item.subItems == null) {
    status = (item.status == 'new' || item.status == 'New')
        ? (_isWeb ? 'New' : 'N')
        : (item.status == 'updated' || item.status == 'Updated')
            ? (_isWeb ? 'Updated' : 'U')
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
        ? (_isWeb ? 'New' : 'N')
        : (newCount != 0 || updateCount != 0) ? (_isWeb ? 'Updated' : 'U') : '';
  }
  return status;
}

/// show bottom sheet which contains theme settings.
void showBottomSettingsPanel(
    SampleModel model, BuildContext context, HomePage widget) {
  int _selectedValue = model.selectedThemeValue;
  final double _orientationPadding =
      ((MediaQuery.of(context).size.width) / 100) * 10;
  final double _width = MediaQuery.of(context).size.width * 0.3;
  final Color _textColor = model.themeData.brightness == Brightness.light
        ? const Color.fromRGBO(84, 84, 84, 1)
        : const Color.fromRGBO(218, 218, 218, 1);
  showRoundedModalBottomSheet<dynamic>(
      dismissOnTap: false,
      context: context,
      radius: 12.0,
      color: model.bottomSheetBackgroundColor,
      builder: (BuildContext context) => Container(
          height: 250,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                child: Stack(children: <Widget>[
                  Container(
                    height: 40,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Settings',
                            style: TextStyle(
                                color: model.textColor,
                                fontSize: 18,
                                letterSpacing: 0.34,
                                fontFamily: 'HeeboBold',
                                fontWeight: FontWeight.w500)),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: model.textColor,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  )
                ]),
              ),
              Expanded(
                // ListView contains a group of widgets that scroll inside the drawer
                child: ListView(
                  children: <Widget>[
                    Column(children: <Widget>[
                      Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return CupertinoSegmentedControl<int>(
                              children: <int, Widget>{
                                0: Container(
                                    width: _width,
                                    alignment: Alignment.center,
                                    child: Text('System theme',
                                        style: TextStyle(
                                            color: _selectedValue == 0
                                                ? Colors.white
                                                : _textColor,
                                            fontFamily: 'HeeboMedium'))),
                                1: Container(
                                    width: _width,
                                    alignment: Alignment.center,
                                    child: Text('Light theme',
                                        style: TextStyle(
                                            color: _selectedValue == 1
                                                ? Colors.white
                                                : _textColor,
                                            fontFamily: 'HeeboMedium'))),
                                2: Container(
                                    width: _width,
                                    alignment: Alignment.center,
                                    child: Text('Dark theme',
                                        style: TextStyle(
                                            color: _selectedValue == 2
                                                ? Colors.white
                                                : _textColor,
                                            fontFamily: 'HeeboMedium')))
                              },
                              unselectedColor: Colors.transparent,
                              selectedColor: model.paletteColor,
                              pressedColor: model.paletteColor,
                              borderColor: model.paletteColor,
                              groupValue: _selectedValue,
                              padding:
                                  const EdgeInsets.fromLTRB(10, 15, 10, 15),
                              onValueChanged: (int value) {
                                _selectedValue = value;
                                if (value == 0) {
                                  model.currentThemeData = widget.sampleBrowser
                                              .systemTheme.brightness !=
                                          Brightness.dark
                                      ? ThemeData.light()
                                      : ThemeData.dark();
                                } else if (value == 1) {
                                  model.currentThemeData = ThemeData.light();
                                } else {
                                  model.currentThemeData = ThemeData.dark();
                                }
                                setState(() {});
                              },
                            );
                          }))
                    ]),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? Container(
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
                                            MainAxisAlignment.spaceBetween,
                                        children: _addColorPalettes(model)),
                                  ),
                                ),
                              ],
                            ))
                          : Container(
                              child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        _orientationPadding + 10,
                                        0,
                                        _orientationPadding + 10,
                                        30),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: _addColorPalettes(model)),
                                  ),
                                ),
                              ],
                            )),
                    ),
                  ],
                ),
              ),
              Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.all(0),
                    height: 50,
                    width: double.infinity,
                    child: RaisedButton(
                        color: model.paletteColor,
                        onPressed: () =>
                            _applySetting(model, context, _selectedValue),
                        child: const Text('APPLY',
                            style: TextStyle(
                                fontFamily: 'HeeboMedium',
                                color: Colors.white))),
                  ))
            ],
          )));
}

void getBottomSheet(BuildContext context, Widget propertyWidget) {
  final SampleModel _model = SampleModel.instance;
  showRoundedModalBottomSheet<dynamic>(
      dismissOnTap: false,
      context: context,
      radius: 12.0,
      color: _model.bottomSheetBackgroundColor,
      builder: (BuildContext context) => Container(
            height: 150,
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
            child: Stack(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Settings',
                      style: TextStyle(
                          color: _model.textColor,
                          fontSize: 18,
                          letterSpacing: 0.34,
                          fontWeight: FontWeight.w500)),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: _model.textColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(10, 50, 0, 0),
                  child: propertyWidget)
            ]),
          ));
}
