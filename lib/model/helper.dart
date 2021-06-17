/// dart imports
import 'dart:io' show Platform;

/// Package imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Local imports
import '../widgets/bottom_sheet.dart';
import 'mobile_view.dart';
import 'model.dart';
import 'sample_view.dart';

/// On tap the button, select the samples.
void onTapControlInMobile(BuildContext context, SampleModel model,
    WidgetCategory category, int position) {
  category.selectedIndex = position;
  Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
          builder: (BuildContext context) =>
              LayoutPage(sampleModel: model, category: category)));
}

/// On tap the mouse, select the samples in web.
void onTapControlInWeb(BuildContext context, SampleModel model,
    WidgetCategory category, int position) {
  category.selectedIndex = position;
  final SubItem _subItem =
      category.controlList![category.selectedIndex!].subItems[0].type ==
              'parent'
          ? category.controlList![category.selectedIndex!].subItems[0]
              .subItems[0].subItems[0] as SubItem
          : category.controlList![category.selectedIndex!].subItems[0].type ==
                  'child'
              ? category.controlList![category.selectedIndex!].subItems[0]
                  .subItems[0] as SubItem
              : category.controlList![category.selectedIndex!].subItems[0]
                  as SubItem;

  Navigator.pushNamed(context, _subItem.breadCrumbText!);
}

/// On tap the expand button, get the fullview sample.
void onTapExpandSample(
    BuildContext context, SubItem subItem, SampleModel model) {
  model.isCardView = false;
  final Function _sampleWidget = model.sampleWidget[subItem.key]!;
  final SampleView _sampleView =
      _sampleWidget(GlobalKey<State>()) as SampleView;
  Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => _FullViewSampleLayout(
                sampleWidget: _sampleView,
                sample: subItem,
              )));
  model.sampleList.clear();
  model.editingController.text = '';
  //ignore: invalid_use_of_protected_member
  model.notifyListeners();
}

///On expanding sample, full view sample layout renders
class _FullViewSampleLayout extends StatelessWidget {
  const _FullViewSampleLayout({this.sample, this.sampleWidget});
  final SubItem? sample;
  final Widget? sampleWidget;
  @override
  Widget build(BuildContext context) {
    final SampleModel model = SampleModel.instance;
    final bool needsFloatingBotton =
        (sample!.sourceLink != null && sample!.sourceLink != '') ||
            sample!.needsPropertyPanel == true;
    final bool needPadding =
        sample!.codeLink != null && sample!.codeLink!.contains('/chart/');
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => SafeArea(
            child: sample == null
                ? Container()
                : Theme(
                    data: model.themeData,
                    child: Scaffold(
                      resizeToAvoidBottomInset: false,
                      backgroundColor: model.paletteColor,
                      appBar: PreferredSize(
                          preferredSize: const Size.fromHeight(60.0),
                          child: AppBar(
                            title: Text(sample!.title!),
                            actions: (sample!.description != null &&
                                    sample!.description != '')
                                ? <Widget>[
                                    if (sample!.codeLink != null &&
                                        sample!.codeLink != '')
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 8, 0),
                                        child: Container(
                                          height: 37,
                                          width: 37,
                                          child: IconButton(
                                            icon: Image.asset(
                                                'images/git_hub_mobile.png',
                                                color: Colors.white),
                                            onPressed: () {
                                              launch(sample!.codeLink!);
                                            },
                                          ),
                                        ),
                                      )
                                    else
                                      Container(),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 10, 0),
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        child: IconButton(
                                          icon: const Icon(Icons.info_outline,
                                              color: Colors.white),
                                          onPressed: () {
                                            showBottomInfo(
                                                context, sample!.description!);
                                          },
                                        ),
                                      ),
                                    ),
                                  ]
                                : (sample!.codeLink != null &&
                                        sample!.codeLink != '')
                                    ? (<Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 8, 0),
                                          child: Container(
                                            height: 37,
                                            width: 37,
                                            child: IconButton(
                                              icon: Image.asset(
                                                  'images/git_hub_mobile.png',
                                                  color: Colors.white),
                                              onPressed: () {
                                                launch(sample!.codeLink!);
                                              },
                                            ),
                                          ),
                                        ),
                                      ])
                                    : null,
                            elevation: 0.0,
                            backgroundColor: model.backgroundColor,
                            titleSpacing: NavigationToolbar.kMiddleSpacing,
                          )),
                      body: Container(
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                  bottom: Radius.circular(0)),
                              color: model.cardThemeColor),
                          padding: needPadding
                              ? EdgeInsets.fromLTRB(
                                  5, 0, 5, needsFloatingBotton ? 57 : 0)
                              : const EdgeInsets.all(0),
                          child: Container(child: sampleWidget)),
                      floatingActionButton: needsFloatingBotton
                          ? Stack(children: <Widget>[
                              if (sample!.sourceLink != null &&
                                  sample!.sourceLink != '')
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        30, needPadding ? 50 : 0, 0, 0),
                                    child: Container(
                                      height: 50,
                                      width: 230,
                                      child: InkWell(
                                        onTap: () =>
                                            launch(sample!.sourceLink!),
                                        child: Row(
                                          children: <Widget>[
                                            Text('Source: ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: model.textColor)),
                                            Text(sample!.sourceText!,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.blue)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              else
                                Container(),
                              if (sample!.needsPropertyPanel != true)
                                Container()
                              else
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: FloatingActionButton(
                                    heroTag: null,
                                    onPressed: () {
                                      final GlobalKey _sampleKey =
                                          sampleWidget!.key! as GlobalKey;
                                      final SampleViewState _sampleState =
                                          _sampleKey.currentState!
                                              as SampleViewState;
                                      final Widget _settingsContent =
                                          _sampleState.buildSettings(context)!;
                                      showBottomSheetSettingsPanel(
                                          context, _settingsContent);
                                    },
                                    backgroundColor: model.paletteColor,
                                    child: const Icon(Icons.graphic_eq,
                                        color: Colors.white),
                                  ),
                                ),
                            ])
                          : null,
                    ))));
  }
}

/// Darwer to show the product related links.
Widget getLeftSideDrawer(SampleModel _model) {
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
                if (_model.themeData.brightness == Brightness.light)
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 30, 30, 10),
                    child: Image.asset('images/image_nav_banner.png',
                        fit: BoxFit.cover),
                  )
                else
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 30, 30, 10),
                    child: Image.asset('images/image_nav_banner_darktheme.png',
                        fit: BoxFit.cover),
                  )
              ]),
              Expanded(
                /// ListView contains a group of widgets
                /// that scroll inside the drawer
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
                          height: 2, width: 5, color: _model.backgroundColor),
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
                                                color: _model.backgroundColor),
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
                                                color: _model.backgroundColor),
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
                                                color: _model.backgroundColor),
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

              /// This container holds the align
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          _model.themeData.brightness == Brightness.dark
                              ? 'images/syncfusion_dark.png'
                              : 'images/syncfusion.png',
                          fit: BoxFit.contain,
                          height: 50,
                          width: 100,
                        )),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Text('Version 19.1.63',
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

/// Shows copyright message, product related links
/// at the bottom of the home page.
Widget getFooter(BuildContext context, SampleModel model) {
  return Container(
    height: 60,
    decoration: BoxDecoration(
      border: Border(
        top: BorderSide(width: 0.8, color: model.dividerColor),
      ),
      color: model.themeData.brightness == Brightness.dark
          ? const Color.fromRGBO(33, 33, 33, 1)
          : const Color.fromRGBO(234, 234, 234, 1),
    ),
    padding: model.isMobileResolution
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
                InkWell(
                  onTap: () => launch(
                      'https://help.syncfusion.com/flutter/introduction/overview'),
                  child: const Text('Documentation',
                      style: TextStyle(color: Colors.blue, fontSize: 12)),
                ),
                Text(' | ',
                    style: TextStyle(
                        fontSize: 12, color: model.textColor.withOpacity(0.7))),
                InkWell(
                  onTap: () =>
                      launch('https://www.syncfusion.com/forums/flutter'),
                  child: const Text('Forum',
                      style: TextStyle(color: Colors.blue, fontSize: 12)),
                ),
                Text(' | ',
                    style: TextStyle(
                        fontSize: 12, color: model.textColor.withOpacity(0.7))),
                InkWell(
                  onTap: () =>
                      launch('https://www.syncfusion.com/blogs/?s=flutter'),
                  child: const Text('Blog',
                      style: TextStyle(color: Colors.blue, fontSize: 12)),
                ),
                Text(' | ',
                    style: TextStyle(
                        fontSize: 12, color: model.textColor.withOpacity(0.7))),
                InkWell(
                  onTap: () => launch('https://www.syncfusion.com/kb/flutter'),
                  child: const Text('Knowledge base',
                      style: TextStyle(color: Colors.blue, fontSize: 12)),
                )
              ],
            ),
            Container(
                padding: const EdgeInsets.only(top: 10),
                child: Text('Copyright © 2001 - 2021 Syncfusion Inc.',
                    style: TextStyle(
                        color: model.textColor.withOpacity(0.7),
                        fontSize: 12,
                        letterSpacing: 0.23)))
          ],
        )),
        InkWell(
          onTap: () => launch('https://www.syncfusion.com'),
          child: Image.asset(
              model.themeData.brightness == Brightness.dark
                  ? 'images/syncfusion_dark.png'
                  : 'images/syncfusion.png',
              fit: BoxFit.contain,
              height: 25,
              width: model.isMobileResolution ? 80 : 120),
        ),
      ],
    ),
  );
}

/// Show Right drawer which contains theme settings for web.
Widget showWebThemeSettings(SampleModel model) {
  int _selectedValue = model.selectedThemeIndex;
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
                    IconButton(
                        icon: Icon(Icons.close, color: model.webIconColor),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
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
                                  model.currentThemeData = (value == 0)
                                      ? ThemeData.light()
                                      : ThemeData.dark();

                                  setState(() {
                                    /// update the theme changes
                                    /// tp [CupertinoSegmentedControl]
                                  });
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
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  model.paletteColor),
                            ),
                            onPressed: () => _applyThemeAndPaletteColor(
                                model, context, _selectedValue),
                            child: const Text('APPLY',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Roboto-Bold',
                                    color: Colors.white))),
                      )
                    ],
                  ),
                ),
              ],
            )));
  });
}

/// Apply the selected theme to the whole application.
void _applyThemeAndPaletteColor(
    SampleModel model, BuildContext context, int selectedValue) {
  model.selectedThemeIndex = selectedValue;
  model.backgroundColor = model.currentThemeData!.brightness == Brightness.dark
      ? model.currentPrimaryColor
      : model.currentPaletteColor;
  model.paletteColor = model.currentPaletteColor;
  model.changeTheme(model.currentThemeData!);
  // ignore: invalid_use_of_protected_member
  model.notifyListeners();
  Navigator.pop(context);
}

/// Adding the palette color in the theme setting panel.
List<Widget> _addColorPalettes(SampleModel model, [StateSetter? setState]) {
  final List<Widget> _colorPaletteWidgets = <Widget>[];
  for (int i = 0; i < model.paletteColors!.length; i++) {
    _colorPaletteWidgets.add(Material(
        color: model.bottomSheetBackgroundColor,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border:
                Border.all(color: model.paletteBorderColors![i], width: 2.0),
            shape: BoxShape.circle,
          ),
          child: InkWell(
            onTap: () => _changeColorPalette(model, i, setState),
            child: Icon(
              Icons.brightness_1,
              size: 40.0,
              color: model.paletteColors![i],
            ),
          ),
        )));
  }
  return _colorPaletteWidgets;
}

/// Changing the palete color of the application.
void _changeColorPalette(SampleModel model, int index,
    [StateSetter? setState]) {
  for (int j = 0; j < model.paletteBorderColors!.length; j++) {
    model.paletteBorderColors![j] = Colors.transparent;
  }
  model.paletteBorderColors![index] = model.paletteColors![index];
  model.currentPaletteColor = model.paletteColors![index];
  model.currentPrimaryColor = model.darkPaletteColors![index];

  model.isWebFullView
      ? setState!(() {
          /// update the palette color changes
        })
      :
      // ignore: invalid_use_of_protected_member
      model.notifyListeners();
}

/// Getting status of the control/subitems/sample.
String getStatusTag(SubItem item) {
  final bool _isWeb =
      kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux;
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
    for (int i = 0; i < item.subItems!.length; i++) {
      if (item.subItems![i].subItems == null) {
        if (item.subItems![i].status == 'New' ||
            item.subItems![i].status == 'new') {
          newCount++;
        } else if (item.subItems![i].status == 'Updated' ||
            item.subItems![i].status == 'updated') {
          updateCount++;
        }
      } else {
        for (int j = 0; j < item.subItems![i].subItems.length; j++) {
          if (item.subItems![i].subItems[j].status == 'New' ||
              item.subItems![i].subItems[j].status == 'new') {
            newCount++;
          } else if (item.subItems![i].subItems[j].status == 'Updated' ||
              item.subItems![i].subItems[j].status == 'updated') {
            updateCount++;
          }
        }
      }
    }
    status = (newCount != 0 && newCount == item.subItems!.length)
        ? (_isWeb ? 'New' : 'N')
        : (newCount != 0 || updateCount != 0)
            ? (_isWeb ? 'Updated' : 'U')
            : '';
  }
  return status;
}

/// show bottom sheet which contains theme settings.
void showBottomSettingsPanel(SampleModel model, BuildContext context) {
  int _selectedIndex = model.selectedThemeIndex;
  final double _orientationPadding =
      ((MediaQuery.of(context).size.width) / 100) * 10;
  final double _width = MediaQuery.of(context).size.width * 0.3;
  final Color _textColor = model.themeData.brightness == Brightness.light
      ? const Color.fromRGBO(84, 84, 84, 1)
      : const Color.fromRGBO(218, 218, 218, 1);
  showRoundedModalBottomSheet<dynamic>(
      context: context,
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
                /// ListView contains a group of widgets
                /// that scroll inside the drawer
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
                                            color: _selectedIndex == 0
                                                ? Colors.white
                                                : _textColor,
                                            fontFamily: 'HeeboMedium'))),
                                1: Container(
                                    width: _width,
                                    alignment: Alignment.center,
                                    child: Text('Light theme',
                                        style: TextStyle(
                                            color: _selectedIndex == 1
                                                ? Colors.white
                                                : _textColor,
                                            fontFamily: 'HeeboMedium'))),
                                2: Container(
                                    width: _width,
                                    alignment: Alignment.center,
                                    child: Text('Dark theme',
                                        style: TextStyle(
                                            color: _selectedIndex == 2
                                                ? Colors.white
                                                : _textColor,
                                            fontFamily: 'HeeboMedium')))
                              },
                              unselectedColor: Colors.transparent,
                              selectedColor: model.paletteColor,
                              pressedColor: model.paletteColor,
                              borderColor: model.paletteColor,
                              groupValue: _selectedIndex,
                              padding:
                                  const EdgeInsets.fromLTRB(10, 15, 10, 15),
                              onValueChanged: (int value) {
                                _selectedIndex = value;
                                if (value == 0) {
                                  model.currentThemeData =
                                      model.systemTheme.brightness !=
                                              Brightness.dark
                                          ? ThemeData.light()
                                          : ThemeData.dark();
                                } else if (value == 1) {
                                  model.currentThemeData = ThemeData.light();
                                } else {
                                  model.currentThemeData = ThemeData.dark();
                                }
                                setState(() {
                                  /// update the theme changes to
                                  /// [CupertinoSegmentedControl]
                                });
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
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              model.paletteColor),
                        ),
                        onPressed: () => _applyThemeAndPaletteColor(
                            model, context, _selectedIndex),
                        child: const Text('APPLY',
                            style: TextStyle(
                                fontFamily: 'HeeboMedium',
                                color: Colors.white))),
                  ))
            ],
          )));
}

///To show the settings panel content in the bottom sheet
void showBottomSheetSettingsPanel(BuildContext context, Widget propertyWidget) {
  final SampleModel _model = SampleModel.instance;
  showRoundedModalBottomSheet<dynamic>(
      context: context,
      color: _model.bottomSheetBackgroundColor,
      builder: (BuildContext context) => Container(
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
              Theme(
                  data: ThemeData(
                      brightness: _model.themeData.brightness,
                      primaryColor: _model.backgroundColor),
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 50, 0, 0),
                      child: propertyWidget))
            ]),
          ));
}

///To show the sample description in the bottom sheet
void showBottomInfo(BuildContext context, String information) {
  final SampleModel _model = SampleModel.instance;
  if (information != null && information != '') {
    showRoundedModalBottomSheet<dynamic>(
        context: context,
        color: _model.bottomSheetBackgroundColor,
        builder: (BuildContext context) => Theme(
            data: ThemeData(
                brightness: _model.themeData.brightness,
                primaryColor: _model.backgroundColor),
            child: Container(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
              child: Stack(children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Description',
                        style: TextStyle(
                            color: _model.textColor,
                            fontSize: 18,
                            letterSpacing: 0.34,
                            fontWeight: FontWeight.bold)),
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
                    padding: const EdgeInsets.fromLTRB(0, 45, 12, 15),
                    child: ListView(shrinkWrap: true, children: <Widget>[
                      Text(
                        information,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: _model.textColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 15.0,
                            letterSpacing: 0.2,
                            height: 1.2),
                      )
                    ]))
              ]),
            )));
  }
}
