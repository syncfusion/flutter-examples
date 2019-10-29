import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_examples/samples/chart/cartesian_charts/bar_series/customized_bar_chart.dart';
import 'package:flutter_examples/widgets/animateOpacityWidget.dart';
import 'package:flutter_examples/widgets/bottom_sheet.dart';
import 'package:flutter_examples/widgets/search_bar.dart';
import 'package:flutter_examples/widgets/widget.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'model/helper.dart';
import 'model/model.dart';



class SampleBrowser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chart Flutter',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSelected = true;
  Color lightThemeSelected;
  Color lightThemeSelectedTextColor;
  Color darkThemeSelected;
  Color darkThemeSelectedTextColor;
  List<Color> defaultBorderColor;
  SampleListModel sampleListModel;
  List<Widget> colorPaletteWidgets;
  List<Color> colors;
  final dynamic controller = ScrollController();
  double cOpacity = 0.0;
  double screenHeight;
  ThemeData _currentThemeData;
  Color _currentBackgroundColor = const Color.fromRGBO(0, 116, 228, 1);
  Color _currentListIconColor;
  Color _currentPaletteColor;
  bool _lightThemeSelected = true;
  double _orientationPadding;

  @override
  void initState() {
    _currentThemeData = ThemeData.light();
    sampleListModel = SampleListModel();
    lightThemeSelected = sampleListModel.backgroundColor;
    darkThemeSelected = const Color.fromRGBO(249, 249, 249, 1);
    lightThemeSelectedTextColor = Colors.white;
    darkThemeSelectedTextColor = const Color.fromRGBO(51, 51, 51, 1);
    defaultBorderColor = <Color>[];
    addColors();
    init();
    super.initState();
  }

  Future<void> init() async {
    final ByteData data = await rootBundle.load('images/dashline.png');
    image = await loadImage(Uint8List.view(data.buffer));
  }

  Future<ui.Image> loadImage(List<int> img) async {
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
    screenHeight = MediaQuery.of(context).size.height;
    _orientationPadding = ((MediaQuery.of(context).size.width) / 100) * 20;
    final dynamic smallestDimension = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = smallestDimension < 600;
    sampleListModel.isTargetMobile = useMobileLayout;
    return ScopedModel<SampleListModel>(
        model: sampleListModel,
        child: ScopedModelDescendant<SampleListModel>(
          rebuildOnChange: true,
          builder: (BuildContext context, _, SampleListModel model) => MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SafeArea(
              child: Scaffold(
                  resizeToAvoidBottomPadding: true,
                  drawer: getSideDrawer(model),
                  appBar: PreferredSize(
                      preferredSize: Size.fromHeight(60.0),
                      child: Container(
                        decoration: BoxDecoration(boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: model.backgroundColor,
                            offset: const Offset(0, 2.0),
                            blurRadius: 0.25,
                          )
                        ]),
                        child: AppBar(
                          elevation: 0.0,
                          backgroundColor: model.backgroundColor,
                          title: AnimateOpacityWidget(
                              controller: controller,
                              opacity: cOpacity,
                              child: Text('Flutter UI Widgets',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'MontserratMedium'))),
                          actions: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Container(
                                height: 40,
                                width: 40,
                                child: IconButton(
                                  icon: Icon(Icons.settings,
                                      color: Colors.white),
                                  onPressed: () {
                                    _showSettingsPanel(model);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  body: Scaffold(
                    backgroundColor: model.slidingPanelColor,
                    body: SafeArea(
                      child: ListView.builder(
                          controller: controller,
                          physics: const ClampingScrollPhysics(),
                          itemCount: 2,
                          itemBuilder: (BuildContext context, num index) {
                            return Material(
                              color: model.backgroundColor,
                              child: CustomListView(
                                header: Container(
                                  color: model.backgroundColor,
                                  child: Column(
                                    children: <Widget>[
                                      index != 0
                                          ? Container(
                                              color: model.backgroundColor,
                                              height: 100.0,
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 0.0),
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        20, 20, 20, 0),
                                                    child: Container(
                                                        height: 50,
                                                        child: SearchBar(
                                                            sampleListModel:
                                                                model)),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 10, 0, 0),
                                                    child: Container(
                                                        height: 20,
                                                        width: double.infinity,
                                                        decoration: BoxDecoration(
                                                            color: model
                                                                .slidingPanelColor,
                                                            border: Border.all(
                                                                color: model
                                                                    .slidingPanelColor),
                                                            borderRadius: const BorderRadius
                                                                    .only(
                                                                topLeft:
                                                                    Radius
                                                                            .circular(
                                                                        12.0),
                                                                topRight:
                                                                    Radius
                                                                            .circular(
                                                                        12.0)),
                                                            boxShadow: <BoxShadow>[
                                                              BoxShadow(
                                                                color: model
                                                                    .slidingPanelColor,
                                                                offset: const Offset(
                                                                    0, 2.0),
                                                                blurRadius:
                                                                    0.25,
                                                              )
                                                            ])),
                                                  ),
                                                ],
                                              ))
                                          : Container(
                                              height: 0,
                                              color: model.backgroundColor),
                                    ],
                                  ),
                                ),
                                content: Container(
                                  color: model.backgroundColor,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        color: model.backgroundColor,
                                        width: double.infinity,
                                        child: index == 0
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 0, 0, 0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 0, 0, 0),
                                                        child: Text(
                                                            'Flutter UI Widgets',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 25,
                                                                letterSpacing:
                                                                    0.53,
                                                                fontFamily:
                                                                    'MontserratBold',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          0, 12, 0, 0),
                                                      child: Text(
                                                          'Fast . Fluid . Flexible',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                              letterSpacing:
                                                                  0.26,
                                                              fontFamily:
                                                                  'MontserratBold',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                    ),
                                                  ],
                                                ))
                                            : Container(
                                                color: model.slidingPanelColor,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 0, 20),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children:
                                                          getListViewChildrens(
                                                              model)),
                                                )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  )),
            ),
          ),
        ));
  }

  List<Widget> getListViewChildrens(SampleListModel model) {
    List<Widget> items;
    items = <Widget>[];
    for (int i = 0; i < model.controlList.length; i++) {
      items.add(Padding(
        padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
        child: Container(
          color: model.slidingPanelColor,
          child: ScopedModelDescendant<SampleListModel>(
              rebuildOnChange: true,
              builder: (BuildContext  context, _, SampleListModel model) => Material(
                  color: model.slidingPanelColor,
                  elevation: 0.0,
                  child: InkWell(
                      splashColor: Colors.grey.withOpacity(0.4),
                      onTap: () {
                        Feedback.forLongPress(context);
                        onTapControlItem(context, model, i);
                      },
                      child: Container(
                        child: ListTile(
                          leading: Image.asset(model.controlList[i].image,
                              fit: BoxFit.cover),
                          title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  model.controlList[i].title,
                                  textAlign: TextAlign.left,
                                  softWrap: true,
                                  textScaleFactor: 1,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: model.textColor,
                                      letterSpacing: 0.3,
                                      fontFamily: 'MontserratBold'),
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: model.controlList[i].status == 'New'
                                            ? const Color.fromRGBO(101, 193, 0, 1)
                                            : model.controlList[i].status == 'Updated'
                                                ? const Color.fromRGBO(
                                                    245, 166, 35, 1)
                                                : model.controlList[i].status == 'Preview'
                                                    ? const Color.fromRGBO(
                                                        238, 245, 255, 1)
                                                    : Colors.transparent,
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10))),
                                    padding: const EdgeInsets.fromLTRB(7, 3, 6, 3),
                                    child: Text(model.controlList[i].status,
                                        style: TextStyle(
                                            color: model.controlList[i].status ==
                                                    'Preview'
                                                ? const Color.fromRGBO(0, 98, 255, 1)
                                                : Colors.white,
                                            fontSize: 12)))
                              ]),
                          subtitle: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 7.0, 0.0, 0.0),
                            child: Text(
                              model.controlList[i].description,
                              textAlign: TextAlign.left,
                              softWrap: true,
                              textScaleFactor: 1,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 13,
                                letterSpacing: 0.24,
                                fontFamily: 'MontserratMedium',
                                color: model.listDescriptionTextColor,
                              ),
                            ),
                          ),
                        ),
                      )))),
        ),
      ));
      if (i != model.controlList.length - 1) {
        items.add(const Divider(height: 15.0));
      }
    }
    for (int i = 0; i < model.sampleList.length; i++) {
      items.add(ScopedModelDescendant<SampleListModel>(
          rebuildOnChange: true,
          builder: (BuildContext  context, _, SampleListModel model) => Material(
              elevation: 0.0,
              color: model.slidingPanelColor,
              child: InkWell(
                  splashColor: Colors.grey.withOpacity(0.4),
                  onTap: () {
                    Feedback.forLongPress(context);
                    onTapSampleItem(context, model.sampleList[i]);
                  },
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 5, 0),
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        softWrap: true,
                        maxLines: 1,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: '${model.sampleList[i].title} in ',
                                style: TextStyle(
                                    fontFamily: 'MontserratMedium',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14.0,
                                    color: model.textColor,
                                    letterSpacing: 0.3)),
                            TextSpan(
                                text: '${model.sampleList[0].category}',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'MontserratBold',
                                    color: model.textColor,
                                    letterSpacing: 0.3)),
                          ],
                        ),
                      ),
                    ),
                  )))));
      if (i != model.sampleList.length - 1) {
        items.add(const Divider(height: 15.0));
      }
    }

    if (model.sampleList.isEmpty&& model.controlList.isEmpty) {
      items.add(Padding(
        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
        child: Container(
            color: model.slidingPanelColor,
            child: Center(
                child: Text('No results found',
                    style: TextStyle(color: model.textColor, fontSize: 15)))),
      ));
    }

    return items;
  }

  void _showSettingsPanel(SampleListModel model) {
    showRoundedModalBottomSheet<dynamic>(
        dismissOnTap: false,
        context: context,
        radius: 12.0,
        color: model.bottomSheetBackgroundColor,
        builder: (BuildContext  context) => ScopedModel<SampleListModel>(
            model: sampleListModel,
            child: ScopedModelDescendant<SampleListModel>(
                rebuildOnChange: true,
                builder: (BuildContext context, _, SampleListModel model) => OrientationBuilder(
                      builder: (BuildContext  context, Orientation orientation) {
                        return Container(
                            height: 250,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 5, 0, 0),
                                  child: Stack(children: <Widget>[
                                    Container(
                                      height: 40,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text('Settings',
                                              style: TextStyle(
                                                  color: model.textColor,
                                                  fontSize: 18,
                                                  letterSpacing: 0.34,
                                                  fontFamily: 'MontserratBold',
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
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        child: Column(children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 10, 0, 0),
                                            child: MediaQuery.of(context)
                                                        .orientation ==
                                                    Orientation.portrait
                                                ? Container(
                                                    child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(15, 0, 10, 0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: RaisedButton(
                                                              elevation: 0,
                                                              color:
                                                                  lightThemeSelected,
                                                              onPressed: () =>
                                                                  _toggleLightTheme(
                                                                      model),
                                                              child: Text(
                                                                'Light theme',
                                                                style: TextStyle(
                                                                    color:
                                                                        lightThemeSelectedTextColor,
                                                                    fontFamily:
                                                                        'MontserratMedium'),
                                                              )),
                                                        ),
                                                        Expanded(
                                                          child: RaisedButton(
                                                              elevation: 0,
                                                              color:
                                                                  darkThemeSelected,
                                                              onPressed: () =>
                                                                  _toggleDarkTheme(
                                                                      model),
                                                              child: Text(
                                                                  'Dark theme',
                                                                  style: TextStyle(
                                                                      color:
                                                                          darkThemeSelectedTextColor,
                                                                      fontFamily:
                                                                          'MontserratMedium'))),
                                                        )
                                                      ],
                                                    ),
                                                  ))
                                                : Container(
                                                    child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(15, 0, 10, 0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    _orientationPadding,
                                                                    0,
                                                                    0,
                                                                    0),
                                                            child: RaisedButton(
                                                                elevation: 0,
                                                                color:
                                                                    lightThemeSelected,
                                                                onPressed: () =>
                                                                    _toggleLightTheme(
                                                                        model),
                                                                child: Text(
                                                                  'Light theme',
                                                                  style: TextStyle(
                                                                      color:
                                                                          lightThemeSelectedTextColor,
                                                                      fontFamily:
                                                                          'MontserratMedium'),
                                                                )),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    0,
                                                                    0,
                                                                    _orientationPadding,
                                                                    0),
                                                            child: RaisedButton(
                                                                elevation: 0,
                                                                color:
                                                                    darkThemeSelected,
                                                                onPressed: () =>
                                                                    _toggleDarkTheme(
                                                                        model),
                                                                child: Text(
                                                                    'Dark theme',
                                                                    style: TextStyle(
                                                                        color:
                                                                            darkThemeSelectedTextColor,
                                                                        fontFamily:
                                                                            'MontserratMedium'))),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                          )
                                        ]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 20, 0, 0),
                                        child: MediaQuery.of(context)
                                                    .orientation ==
                                                Orientation.portrait
                                            ? Container(
                                                child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          15, 0, 10, 30),
                                                      child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children:
                                                              addColorPalettes(
                                                                  model)),
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
                                                          _orientationPadding +
                                                              10,
                                                          0,
                                                          _orientationPadding +
                                                              10,
                                                          30),
                                                      child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children:
                                                              addColorPalettes(
                                                                  model)),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                      ),
                                    ],
                                  ),
                                ),
                                // This container holds the align
                                Container(
                                    // This align moves the children to the bottom
                                    child: Align(
                                  alignment: FractionalOffset.bottomCenter,
                                  // This container holds all the children that will be aligned
                                  // on the bottom and should not scroll with the above ListView
                                  child: Container(
                                    color: Colors.blueAccent,
                                    child: Container(
                                      height: 50,
                                      width: double.infinity,
                                      child: RaisedButton(
                                          color: model.backgroundColor,
                                          onPressed: () => _applySetting(model),
                                          child: Text('APPLY',
                                              style: TextStyle(
                                                  fontFamily:
                                                      'MontserratMedium',
                                                  color: Colors.white))),
                                    ),
                                  ),
                                ))
                              ],
                            ));
                      },
                    ))));
  }

  void _applySetting(SampleListModel model) {
    model.backgroundColor = _currentBackgroundColor;
    if (_lightThemeSelected) {
      lightThemeSelected = model.backgroundColor;
      darkThemeSelected = const Color.fromRGBO(249, 249, 249, 1);
    } else {
      darkThemeSelected = model.backgroundColor;
      lightThemeSelected = const Color.fromRGBO(249, 249, 249, 1);
    }
    model.listIconColor = _currentListIconColor;
    model.paletteColor = _currentPaletteColor;
    model.changeTheme(_currentThemeData);
    // ignore: invalid_use_of_protected_member
    model.notifyListeners();
    Navigator.pop(context);
  }

  void _toggleLightTheme(SampleListModel model) {
    _lightThemeSelected = true;
    lightThemeSelected = model.backgroundColor;
    darkThemeSelected = const Color.fromRGBO(249, 249, 249, 1);
    _currentThemeData = ThemeData.light();
    lightThemeSelectedTextColor = Colors.white;
    darkThemeSelectedTextColor = const Color.fromRGBO(51, 51, 51, 1);
    // ignore: invalid_use_of_protected_member
    model.notifyListeners();
  }

  void _toggleDarkTheme(SampleListModel model) {
    _lightThemeSelected = false;
    darkThemeSelected = model.backgroundColor;
    lightThemeSelected = const Color.fromRGBO(249, 249, 249, 1);
    _currentThemeData = ThemeData.dark();
    lightThemeSelectedTextColor = const Color.fromRGBO(51, 51, 51, 1);
    darkThemeSelectedTextColor = Colors.white;
    // ignore: invalid_use_of_protected_member
    model.notifyListeners();
  }

  void addColors() {
    colors = <Color>[];
    colors.add(const Color.fromRGBO(0, 116, 228, 1));
    colors.add(const Color.fromRGBO(255, 90, 25, 1));
    colors.add(const Color.fromRGBO(251, 53, 105, 1));
    colors.add(const Color.fromRGBO(73, 76, 162, 1));
    colors.add(const Color.fromRGBO(48, 171, 123, 1));
    defaultBorderColor.add(const Color.fromRGBO(87, 89, 208, 1));
    defaultBorderColor.add(Colors.transparent);
    defaultBorderColor.add(Colors.transparent);
    defaultBorderColor.add(Colors.transparent);
    defaultBorderColor.add(Colors.transparent);
  }

  List<Widget> addColorPalettes(SampleListModel model) {
    colorPaletteWidgets = <Widget>[];
    for (int i = 0; i < colors.length; i++) {
      colorPaletteWidgets.add(Material(
          child: Ink(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: defaultBorderColor[i], width: 2.0),
          shape: BoxShape.circle,
        ),
        child: InkWell(
          onTap: () => changeColorPalette(model, i),
          child: Icon(
            Icons.brightness_1,
            size: 40.0,
            color: colors[i],
          ),
        ),
      )));
    }
    return colorPaletteWidgets;
  }

  void changeColorPalette(SampleListModel model, int index) {
    for (int j = 0; j < defaultBorderColor.length; j++) {
      defaultBorderColor[j] = Colors.transparent;
    }
    defaultBorderColor[index] = colors[index];
    _currentBackgroundColor = colors[index];
    _currentListIconColor = colors[index];
    _currentPaletteColor = colors[index];
    // ignore: invalid_use_of_protected_member
    model.notifyListeners();
  }

  Widget getSideDrawer(SampleListModel _model) {
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
                  _lightThemeSelected
                      ? Container(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 30, 30, 10),
                            child: Image.asset('images/image_nav_banner.png',
                                fit: BoxFit.cover),
                          ),
                        )
                      : Container(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 30, 30, 10),
                            child: Image.asset(
                                'images/image_nav_banner_darktheme.png',
                                fit: BoxFit.cover),
                          ),
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
                                                      EdgeInsets.only(
                                                          top: 10)),
                                              Row(children: <Widget>[
                                                Image.asset(
                                                    'images/product.png',
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
                                                          fontWeight: FontWeight
                                                              .normal)),
                                                )
                                              ]),
                                              const Padding(
                                                  padding:
                                                      EdgeInsets.only(
                                                          top: 10)),
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
                                                      EdgeInsets.only(
                                                          top: 10)),
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
                                                          fontWeight: FontWeight
                                                              .normal)),
                                                )
                                              ]),
                                              const Padding(
                                                  padding:
                                                      EdgeInsets.only(
                                                          top: 10)),
                                            ],
                                          )))),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 100, 0),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 0, 0),
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
                                padding:
                                    EdgeInsets.fromLTRB(0, 15, 0, 0)),
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
                                            padding:
                                                EdgeInsets.only(top: 10)),
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
                                                        fontWeight: FontWeight
                                                            .normal))),
                                            Spacer(),
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
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
                                            padding:
                                                EdgeInsets.only(top: 10)),
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
                                            padding:
                                                EdgeInsets.only(top: 10)),
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
                                              padding:
                                                  const EdgeInsets.fromLTRB(
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
                                            Spacer(),
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
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
                                            padding:
                                                EdgeInsets.only(top: 10)),
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
                                            padding:
                                                EdgeInsets.only(top: 10)),
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
                                              padding:
                                                  const EdgeInsets.fromLTRB(
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
                                            Spacer(),
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
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
                                            padding:
                                                EdgeInsets.only(top: 10)),
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
                          child: Text('Version 17.3.14',
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

  @override
  void dispose() {
    super.dispose();
  }
}
