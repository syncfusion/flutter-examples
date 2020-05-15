import 'package:flutter_examples/widgets/search_bar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';
import '../model/helper.dart';
import '../model/model.dart';

class WebSampleBrowser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demos & Examples of Syncfusion Flutter Widgets',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSelected = true;
  SampleModel model;
  final dynamic controller = ScrollController();
  double cOpacity = 0.0;
  double screenHeight;
  int columnCount;

  @override
  void initState() {
    model = SampleModel();
    model.currentThemeData = ThemeData.light();
    model.lightThemeSelected = model.backgroundColor;
    model.darkThemeSelected = const Color.fromRGBO(247, 245, 245, 1);
    model.defaultBorderColor = <Color>[];
    model.changeTheme(model.currentThemeData);
    _addColors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    model.isWeb = true;
    final dynamic smallestDimension = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = smallestDimension < 600;
    model.isTargetMobile = useMobileLayout;
    return ScopedModel<SampleModel>(
        model: model,
        child: ScopedModelDescendant<SampleModel>(
          rebuildOnChange: true,
          builder: (BuildContext context, _, SampleModel model) => MaterialApp(
            title: 'Demos & Examples of Syncfusion Flutter Widgets',
            debugShowCheckedModeBanner: false,
            home: SafeArea(
              child: Scaffold(
                  key: scaffoldKey,
                  endDrawer: showWebThemeSettings(model),
                  resizeToAvoidBottomPadding: true,
                  // bottomNavigationBar: getFooter(context),
                  appBar: PreferredSize(
                      preferredSize: const Size.fromHeight(78.0),
                      child: AppBar(
                        leading: Container(),
                        elevation: 0.0,
                        backgroundColor: model.backgroundColor,
                        flexibleSpace: Container(
                            padding: const EdgeInsets.fromLTRB(24, 10, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(children: <Widget>[
                                  const Text('Flutter UI Widgets ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          letterSpacing: 0.53,
                                          fontFamily: 'Roboto-Bold')),
                                  Container(
                                      padding:
                                          const EdgeInsets.fromLTRB(3, 0, 3, 0),
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color:
                                              Color.fromRGBO(245, 188, 14, 1)),
                                      child: const Text(
                                        'BETA',
                                        style: TextStyle(
                                            fontSize: 14,
                                            letterSpacing: 0.26,
                                            fontFamily: 'Roboto-Medium',
                                            color: Colors.black),
                                      ))
                                ]),
                                const Text('Fast . Fluid . Flexible',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'Roboto-Regular',
                                        letterSpacing: 0.26,
                                        fontWeight: FontWeight.normal)),
                              ],
                            )),
                        actions: <Widget>[
                          MediaQuery.of(context).size.width < 500
                              ? Container(height: 0, width: 9)
                              : Container(
                                  child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 10, right: 10),
                                      width: MediaQuery.of(context).size.width *
                                          0.215,
                                      height:
                                          MediaQuery.of(context).size.height *
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
                                icon: Icon(Icons.settings, color: Colors.white),
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
          ),
        ));
  }

  List<Widget> _getControls(SampleModel model, BuildContext context) {
    final num verticalPadding = MediaQuery.of(context).size.height * 0.0204;
    final double deviceWidth = MediaQuery.of(context).size.width;
    if (deviceWidth > 1060) {
      columnCount = 3;
      return <Widget>[
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[_getWidget(model, model.categoryList[1])]),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _getWidget(model, model.categoryList[3]),
            Padding(padding: EdgeInsets.only(top: verticalPadding)),
            _getWidget(model, model.categoryList[0]),
          ],
        ),
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[_getWidget(model, model.categoryList[2])]),
      ];
    } else if (deviceWidth > 820) {
      columnCount = 2;
      return <Widget>[
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[_getWidget(model, model.categoryList[1])]),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _getWidget(model, model.categoryList[3]),
            Padding(padding: EdgeInsets.only(top: verticalPadding)),
            _getWidget(model, model.categoryList[0]),
            Padding(padding: EdgeInsets.only(top: verticalPadding)),
            _getWidget(model, model.categoryList[2]),
          ],
        ),
      ];
    } else {
      columnCount = 1;
      return <Widget>[
        Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _getWidget(model, model.categoryList[1]),
              Padding(padding: EdgeInsets.only(top: verticalPadding)),
              _getWidget(model, model.categoryList[3]),
              Padding(padding: EdgeInsets.only(top: verticalPadding)),
              _getWidget(model, model.categoryList[0]),
              Padding(padding: EdgeInsets.only(top: verticalPadding)),
              _getWidget(model, model.categoryList[2]),
            ])
      ];
    }
  }

  Widget _getWidget(SampleModel model, Categoryy category) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final num width = columnCount == 1
        ? deviceWidth * 0.8
        : columnCount == 2 ? deviceWidth * 0.39 : deviceWidth * 0.277;
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
            color: model.webDividerColor2,
            thickness: 1,
          ),
          Column(children: _getListView(category, model))
        ]));
  }

  List<Widget> _getListView(Categoryy category, SampleModel model) {
    final List<Widget> items = <Widget>[];
    for (int i = 0; i < category.controlList.length; i++) {
      final Control control = category.controlList[i];
      items.add(HandCursor(
        child: Container(
            color: model.webCardColor,
            child: ScopedModelDescendant<SampleModel>(
                rebuildOnChange: true,
                builder: (BuildContext context, _, SampleModel model) =>
                    Material(
                        color: model.webCardColor,
                        elevation: 0.0,
                        child: InkWell(
                            splashFactory: InkRipple.splashFactory,
                            hoverColor: Colors.grey.withOpacity(0.2),
                            onTap: () {
                              onTapControlItemWeb(context, model, category, i);
                              model.searchResults.clear();
                            },
                            child: Container(
                              child: ListTile(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(12, 2, 0, 0),
                                leading: Image.asset(control.image,
                                    fit: BoxFit.cover),
                                title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                      control.status != null
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  color: (control.status == 'New' || control.status == 'new')
                                                      ? const Color.fromRGBO(
                                                          55, 153, 30, 1)
                                                      : (control.status ==
                                                                  'Updated' ||
                                                              control.status ==
                                                                  'updated')
                                                          ? const Color.fromRGBO(
                                                              246, 117, 0, 1)
                                                          : (control.status == 'Preview' || control.status == 'preview')
                                                              ? const Color.fromRGBO(
                                                                  238, 245, 255, 1)
                                                              : Colors
                                                                  .transparent,
                                                  borderRadius: const BorderRadius.only(
                                                      topLeft: Radius.circular(10),
                                                      bottomLeft: Radius.circular(10))),
                                              padding: const EdgeInsets.fromLTRB(7, 3, 6, 3),
                                              child: Text(control.status, style: TextStyle(fontFamily: 'Roboto-Medium', color: (control.status == 'Preview' || control.status == 'preview') ? const Color.fromRGBO(0, 98, 255, 1) : Colors.white, fontSize: 12)))
                                          : Container()
                                    ]),
                                subtitle: Container(
                                    child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 7.0, 12.0, 0.0),
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
                            ))))),
      ));
    }
    return items;
  }

  void _addColors() {
    model.colors = <Color>[];
    model.colors.add(const Color.fromRGBO(0, 116, 228, 1));
    model.colors.add(const Color.fromRGBO(255, 90, 25, 1));
    model.colors.add(const Color.fromRGBO(251, 53, 105, 1));
    model.colors.add(const Color.fromRGBO(73, 76, 162, 1));
    model.colors.add(const Color.fromRGBO(48, 171, 123, 1));
    model.defaultBorderColor.add(const Color.fromRGBO(87, 89, 208, 1));
    model.defaultBorderColor.add(Colors.transparent);
    model.defaultBorderColor.add(Colors.transparent);
    model.defaultBorderColor.add(Colors.transparent);
    model.defaultBorderColor.add(Colors.transparent);
  }

  Widget _getWebBodyWidget(SampleModel model) {
    return MediaQuery.of(context).size.height < 700 ||
            MediaQuery.of(context).size.width <= 820 ||
            (MediaQuery.of(context).size.height < 840 &&
                MediaQuery.of(context).size.width <= 1060)
        ? SizedBox(
            height: MediaQuery.of(context).size.height - 70,
            child: ListView(children: <Widget>[
              Container(
                  color: model.backgroundColor,
                  child: Container(
                      decoration: BoxDecoration(
                          color: model.webBackgroundColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12))),
                      padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width * 0.0685,
                          MediaQuery.of(context).size.height * 0.0408,
                          MediaQuery.of(context).size.width * 0.0685,
                          MediaQuery.of(context).size.height * 0.0408),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _getControls(model, context),
                      ))),
              getFooter(context, model)
            ]))
        : SizedBox(
            child: ListView(children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height - 140,
                color: model.backgroundColor,
                child: Container(
                    decoration: BoxDecoration(
                        color: model.webBackgroundColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12))),
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.0685,
                        MediaQuery.of(context).size.height * 0.0408,
                        MediaQuery.of(context).size.width * 0.0685,
                        MediaQuery.of(context).size.height * 0.0408),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _getControls(model, context),
                    ))),
            getFooter(context, model)
          ]));
  }
}
