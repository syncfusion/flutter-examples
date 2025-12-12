/// dart imports
import 'dart:io' show Platform;

/// Package imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Local imports
import '../meta_tag/meta_tag.dart';
import '../widgets/bottom_sheet.dart';
import '../widgets/search_bar.dart';
import 'mobile_view.dart';
import 'model.dart';
import 'sample_view.dart';

final WebMetaTagUpdate metaTagUpdate = WebMetaTagUpdate();

/// Callback for changing the theme.
typedef ChangeThemeCallback =
    void Function(bool isMaterial3, Brightness brightness);

/// The index of the selected palette color.
int selectedColorPaletteIndex = 0;

/// On tap the button, select the samples.
void onTapControlInMobile(
  BuildContext context,
  SampleModel model,
  WidgetCategory category,
  int position,
) {
  category.selectedIndex = position;
  Navigator.push<dynamic>(
    context,
    MaterialPageRoute<dynamic>(
      builder: (BuildContext context) =>
          LayoutPage(sampleModel: model, category: category),
    ),
  );
}

/// Resets the locale and textDirection values.
void resetLocaleValue(SampleModel model, SubItem currentSample) {
  model.sampleDetail = currentSample;

  if (currentSample != null &&
      (currentSample.title!.toLowerCase().contains('rtl') ||
          currentSample.title!.toLowerCase().contains('directionality'))) {
    model.textDirection = TextDirection.rtl;
    model.locale = const Locale('ar', 'AE');
    model.isInitialRender = true;
  } else if (currentSample != null &&
      currentSample.title!.toLowerCase().contains('localization')) {
    model.textDirection = TextDirection.ltr;
    model.locale = const Locale('en', 'US');
    model.isInitialRender = true;
  }
}

/// On tap the mouse, select the samples in web.
void onTapControlInWeb(
  BuildContext context,
  SampleModel model,
  WidgetCategory category,
  int position,
) {
  category.selectedIndex = position;
  final SubItem subItem =
      category.controlList![category.selectedIndex!].subItems[0].type ==
          'parent'
      ? category
                .controlList![category.selectedIndex!]
                .subItems[0]
                .subItems[0]
                .subItems[0]
            as SubItem
      : category.controlList![category.selectedIndex!].subItems[0].type ==
            'child'
      ? category.controlList![category.selectedIndex!].subItems[0].subItems[0]
            as SubItem
      : category.controlList![category.selectedIndex!].subItems[0] as SubItem;

  Navigator.pushNamed(context, subItem.breadCrumbText!);

  // Updates meta tag details when navigating from the home page
  // to a widget sample page.
  metaTagUpdate.update(
    subItem.title!,
    category.controlList![category.selectedIndex!].subItems[0].title,
  );
}

/// On tap the expand button, get the fullview sample.
void onTapExpandSample(
  BuildContext context,
  SubItem subItem,
  SampleModel model,
) {
  model.isCardView = false;
  final Function sampleWidget = model.sampleWidget[subItem.key]!;
  final SampleView sampleView = sampleWidget(GlobalKey<State>()) as SampleView;
  Navigator.push<dynamic>(
    context,
    MaterialPageRoute<dynamic>(
      builder: (BuildContext context) {
        return _FullViewSampleLayout(sampleWidget: sampleView, sample: subItem);
      },
    ),
  );
  model.sampleList.clear();
  model.editingController.text = '';
  final currentState = (model.searchBar!.key! as GlobalKey).currentState;
  if (!model.isWebFullView &&
      model.searchBar != null &&
      model.searchBar!.key != null &&
      currentState != null) {
    final SearchBarState searchBarState = currentState as SearchBarState;
    searchBarState.isFocus.unfocus();
    searchBarState.isOpen = false;
  }
  model.notifyListeners();
}

/// Method to return list of text span from the provide sample description
List<TextSpan> getTextSpan(String description, SampleModel model) {
  final List<String> highlightList = <String>[];
  final List<String> list = <String>[];
  final List<String> value = description.split(' ');
  bool isHightlightStarted = false;
  String? highlightText;
  String? overallText;

  for (int i = 0; i < value.length; i++) {
    if (value[i].contains('<highlight>') &&
        value[i].contains('<endHighlight>')) {
      String word = value[i].replaceAll('<highlight>', '');
      word = word.replaceAll('<endHighlight>', '');
      if (word.isNotEmpty) {
        if (overallText != null) {
          list.add(overallText);
          overallText = null;
          list.add(word);
          highlightList.add(word);
        }
      }
    } else if (value[i] == '<highlight>' || value[i].contains('<highlight>')) {
      if (overallText != null) {
        list.add(overallText);
      }
      overallText = null;
      isHightlightStarted = true;

      if (value[i] == '<highlight>') {
        continue;
      }
    } else if (value[i] == '<endHighlight>' ||
        value[i].contains('<endHighlight>')) {
      String word = '';
      if (value[i].contains('<endHighlight>')) {
        word = value[i].replaceAll('<endHighlight>', '');
      }
      if (overallText != null) {
        list.add(overallText);
      }

      if (word.isNotEmpty) {
        list.add(word);
      }

      if (highlightText != null) {
        highlightList.add(highlightText);
      }

      if (word.isNotEmpty) {
        highlightList.add(word);
      }
      overallText = null;
      highlightText = null;
      isHightlightStarted = false;
      continue;
    }

    if (isHightlightStarted) {
      String word;
      if (value[i].contains('<highlight>')) {
        word = value[i].replaceAll('<highlight>', '');
      } else if (value[i].contains('<endHighlight>')) {
        word = value[i].replaceAll('<endHighlight>', '');
      } else {
        word = value[i];
      }
      if (overallText != null) {
        overallText = overallText + ' ' + word;
      } else {
        overallText = word;
      }

      if (highlightText != null) {
        highlightText = highlightText + ' ' + word;
      } else {
        highlightText = word;
      }
    } else if (!value[i].contains('<highlight>') &&
        !value[i].contains('<endHighlight>')) {
      if (overallText != null) {
        overallText = overallText + ' ' + value[i];
      } else {
        overallText = value[i];
      }
    }
  }

  if (overallText != null && !list.contains(overallText)) {
    list.add(overallText);
  }

  if (highlightText != null && !highlightList.contains(highlightText)) {
    highlightList.add(highlightText);
  }

  final List<TextSpan> textSpans = <TextSpan>[];
  for (int i = 0; i < list.length; i++) {
    if (list[i].contains('[')) {
      final List<String> splits = list[i].split('[');
      final String text = splits[0].isEmpty
          ? splits[1].contains(']')
                ? splits[1].replaceAll(']', '')
                : splits[1]
          : splits[0];
      if (i != 0) {
        textSpans.add(const TextSpan(text: ' '));
      }
      textSpans.add(
        TextSpan(
          text: text,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            letterSpacing: 0.25,
            fontFamily: 'Roboto-Regular',
            fontSize: 14,
            color: Color(0xFF0274E5),
            height: 1.2,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launchUrl(Uri.parse(splits[1].replaceAll(']', '')));
            },
        ),
      );
    } else if (highlightList.any((String element) => element == list[i])) {
      if (i != 0) {
        textSpans.add(const TextSpan(text: ' '));
      }

      textSpans.add(
        TextSpan(
          text: list[i],
          style: const TextStyle(
            backgroundColor: Color.fromRGBO(252, 228, 217, 0.6),
            letterSpacing: 0.25,
            fontSize: 12,
            fontFamily: 'Menlo',
            height: 1.2,
            fontWeight: FontWeight.normal,
            color: Color(0xFF83300C),
          ),
        ),
      );
    } else {
      textSpans.add(
        TextSpan(
          text: i == 0 ? list[i] : ' ' + list[i],
          style: model.isWebFullView
              ? TextStyle(
                  color: model.textColor,
                  fontFamily: 'Roboto-Regular',
                  letterSpacing: 0.3,
                )
              : TextStyle(
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.2,
                  fontSize: 15,
                  height: 1.2,
                  color: model.textColor,
                ),
        ),
      );
    }
  }
  return textSpans;
}

/// On expanding sample, full view sample layout renders.
class _FullViewSampleLayout extends StatelessWidget {
  const _FullViewSampleLayout({this.sample, this.sampleWidget});
  final SubItem? sample;
  final Widget? sampleWidget;

  @override
  Widget build(BuildContext context) {
    final SampleModel model = SampleModel.instance;
    final bool needsFloatingBotton =
        (sample!.sourceLink != null && sample!.sourceLink != '') ||
        (sample!.needsPropertyPanel ?? false);
    final bool needPadding =
        sample!.codeLink != null && sample!.codeLink!.contains('/chart/');
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SafeArea(
          child: sample == null
              ? Container()
              : Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: model.primaryColor,
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(60.0),
                    child: _buildAppBar(context, model),
                  ),
                  body: _buildSampleContent(
                    needPadding,
                    needsFloatingBotton,
                    model,
                  ),
                  floatingActionButton: needsFloatingBotton
                      ? Stack(
                          children: <Widget>[
                            if (sample!.sourceLink != null &&
                                sample!.sourceLink != '')
                              _buildSampleSourceLink(needPadding, model),
                            if (sample!.needsPropertyPanel ?? false)
                              _buildSettings(context, model),
                          ],
                        )
                      : null,
                ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, SampleModel model) {
    return AppBar(
      iconTheme: IconThemeData(color: model.baseAppBarItemColor),
      title: Text(
        sample!.title!,
        style: TextStyle(color: model.baseAppBarItemColor),
      ),
      actions: (sample!.description != null && sample!.description != '')
          ? <Widget>[
              if (sample!.codeLink != null && sample!.codeLink != '')
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: SizedBox(
                    height: 37,
                    width: 37,
                    child: IconButton(
                      icon: Image.asset(
                        'images/git_hub_mobile.png',
                        color: model.baseAppBarItemColor,
                      ),
                      onPressed: () {
                        launchUrl(Uri.parse(sample!.codeLink!));
                      },
                    ),
                  ),
                )
              else
                Container(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      color: model.baseAppBarItemColor,
                    ),
                    onPressed: () {
                      showBottomInfo(context, sample!.description!);
                    },
                  ),
                ),
              ),
            ]
          : (sample!.codeLink != null && sample!.codeLink != '')
          ? (<Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: SizedBox(
                  height: 37,
                  width: 37,
                  child: IconButton(
                    icon: Image.asset(
                      'images/git_hub_mobile.png',
                      color: model.baseAppBarItemColor,
                    ),
                    onPressed: () {
                      launchUrl(Uri.parse(sample!.codeLink!));
                    },
                  ),
                ),
              ),
            ])
          : null,
      elevation: 0.0,
      backgroundColor: model.primaryColor,
      titleSpacing: NavigationToolbar.kMiddleSpacing,
    );
  }

  Widget _buildSampleContent(
    bool needPadding,
    bool needsFloatingBotton,
    SampleModel model,
  ) {
    return Container(
      padding: needPadding
          ? EdgeInsets.fromLTRB(5, 0, 5, needsFloatingBotton ? 57 : 0)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        color: model.sampleOutputCardColor,
      ),
      child: sampleWidget,
    );
  }

  Widget _buildSampleSourceLink(bool needPadding, SampleModel model) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(30, needPadding ? 50 : 0, 0, 0),
        child: SizedBox(
          height: 20,
          width: 230,
          child: InkWell(
            hoverColor: model.hoverColor,
            highlightColor: model.splashColor,
            splashColor: model.splashColor,
            onTap: () => launchUrl(Uri.parse(sample!.sourceLink!)),
            child: Row(
              children: <Widget>[
                Text(
                  'Source: ',
                  style: TextStyle(fontSize: 16, color: model.textColor),
                ),
                Text(
                  sample!.sourceText!,
                  style: const TextStyle(fontSize: 14, color: Colors.blue),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettings(BuildContext context, SampleModel model) {
    return Align(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        heroTag: null,
        onPressed: () {
          final GlobalKey sampleKey = sampleWidget!.key! as GlobalKey;
          final SampleViewState sampleState =
              sampleKey.currentState! as SampleViewState;
          final Widget settingsContent = sampleState.buildSettings(context)!;
          showBottomPropertySettingsPanel(context, settingsContent);
        },
        backgroundColor: model.primaryColor,
        child: const Icon(Icons.graphic_eq, color: Colors.white),
      ),
    );
  }
}

/// Drawer to show the product related links.
Widget buildLeftSideDrawer(SampleModel model) {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      return SizedBox(
        width:
            MediaQuery.of(context).size.width *
            (MediaQuery.of(context).size.width < 600 ? 0.7 : 0.4),
        child: Drawer(
          child: ColoredBox(
            color: model.themeData.colorScheme.brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
            child: Column(
              children: <Widget>[
                _buildNavigationBannerImage(model),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      _buildSubHeading(model),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Column(
                          children: <Widget>[
                            _buildProductPageButton(context, model),
                            _buildDocumentationButton(context, model),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 40, 0),
                        child: Divider(height: 2, color: model.primaryColor),
                      ),
                      _buildOtherProducts(model, context),
                    ],
                  ),
                ),
                // This container holds the align
                _buildCompanyLogoAndAppVersion(model),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildSubHeading(SampleModel model) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Text(
        'Fast . Fluid . Flexible',
        style: TextStyle(
          color: model.drawerTextIconColor,
          fontSize: 14,
          letterSpacing: 0.26,
          fontFamily: 'Roboto-Regular',
          fontWeight: FontWeight.normal,
        ),
      ),
    ),
  );
}

Widget _buildNavigationBannerImage(SampleModel model) {
  if (model.themeData.colorScheme.brightness == Brightness.light) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 30, 30, 10),
      child: Image.asset('images/image_nav_banner.png', fit: BoxFit.cover),
    );
  } else {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 30, 30, 10),
      child: Image.asset(
        'images/image_nav_banner_darktheme.png',
        fit: BoxFit.cover,
      ),
    );
  }
}

Widget _buildProductPageButton(BuildContext context, SampleModel model) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        hoverColor: model.hoverColor,
        highlightColor: model.splashColor,
        splashColor: model.splashColor,
        onTap: () {
          Feedback.forLongPress(context);
          launchUrl(Uri.parse('https://www.syncfusion.com/flutter-widgets'));
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
          child: Column(
            children: <Widget>[
              const Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                children: <Widget>[
                  Image.asset(
                    'images/product.png',
                    fit: BoxFit.contain,
                    height: 22,
                    width: 22,
                    color: model.drawerIconColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Text(
                      'Product page',
                      style: TextStyle(
                        color: model.drawerTextIconColor,
                        fontSize: 16,
                        letterSpacing: 0.4,
                        fontFamily: 'Roboto-Regular',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildOtherProducts(SampleModel model, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 20, 3, 0),
    child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Text(
                  'Other products',
                  style: TextStyle(
                    color: model.drawerTextIconColor,
                    fontSize: 16,
                    letterSpacing: 0.4,
                    fontFamily: 'Roboto-Regular',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 0)),
        _buildMauiDemoButton(context, model),
        _buildXamarinDemoButton(context, model),
        _buildXamarinUiKitDemoButton(context, model),
      ],
    ),
  );
}

Widget _buildMauiDemoButton(BuildContext context, SampleModel model) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      hoverColor: model.hoverColor,
      highlightColor: model.splashColor,
      splashColor: model.splashColor,
      onTap: () {
        Feedback.forLongPress(context);
        launchUrl(
          Uri.parse(
            'https://play.google.com/store/apps/details?id=com.syncfusion.sampleBrowser.maui&pcampaignid=web_share',
          ),
        );
      },
      child: Column(
        children: <Widget>[
          const Padding(padding: EdgeInsets.only(top: 10)),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Image.asset(
                  'images/img_maui.png',
                  fit: BoxFit.contain,
                  height: 28,
                  width: 28,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                  'MAUI Demo',
                  style: TextStyle(
                    color: model.drawerTextIconColor,
                    fontSize: 16,
                    letterSpacing: 0.4,
                    fontFamily: 'Roboto-Regular',
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const Spacer(),
              Icon(Icons.arrow_forward, color: model.primaryColor),
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
        ],
      ),
    ),
  );
}

Widget _buildXamarinDemoButton(BuildContext context, SampleModel model) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      hoverColor: model.hoverColor,
      highlightColor: model.splashColor,
      splashColor: model.splashColor,
      onTap: () {
        Feedback.forLongPress(context);
        launchUrl(
          Uri.parse(
            'https://play.google.com/store/apps/details?id=com.syncfusion.samplebrowser&hl=en',
          ),
        );
      },
      child: Column(
        children: <Widget>[
          const Padding(padding: EdgeInsets.only(top: 10)),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Image.asset(
                  'images/img_xamarin.png',
                  fit: BoxFit.contain,
                  height: 28,
                  width: 28,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                  'Xamarin Demo',
                  style: TextStyle(
                    color: model.drawerTextIconColor,
                    fontSize: 16,
                    letterSpacing: 0.4,
                    fontFamily: 'Roboto-Regular',
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const Spacer(),
              Icon(Icons.arrow_forward, color: model.primaryColor),
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
        ],
      ),
    ),
  );
}

Widget _buildXamarinUiKitDemoButton(BuildContext context, SampleModel model) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      hoverColor: model.hoverColor,
      highlightColor: model.splashColor,
      splashColor: model.splashColor,
      onTap: () {
        Feedback.forLongPress(context);
        launchUrl(
          Uri.parse(
            'https://play.google.com/store/apps/details?id=com.syncfusion.xamarin.uikit&hl=en',
          ),
        );
      },
      child: Column(
        children: <Widget>[
          const Padding(padding: EdgeInsets.only(top: 10)),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Image.asset(
                  'images/img_xamarin_ui.png',
                  fit: BoxFit.contain,
                  height: 28,
                  width: 28,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                  'Xamarin UI kit Demo',
                  style: TextStyle(
                    color: model.drawerTextIconColor,
                    fontSize: 16,
                    letterSpacing: 0.4,
                    fontFamily: 'Roboto-Regular',
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const Spacer(),
              Icon(Icons.arrow_forward, color: model.primaryColor),
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
        ],
      ),
    ),
  );
}

Widget _buildDocumentationButton(BuildContext context, SampleModel model) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        hoverColor: model.hoverColor,
        highlightColor: model.splashColor,
        splashColor: model.splashColor,
        onTap: () {
          Feedback.forLongPress(context);
          launchUrl(
            Uri.parse(
              'https://help.syncfusion.com/flutter/introduction/overview',
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
          child: Column(
            children: <Widget>[
              const Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                children: <Widget>[
                  Image.asset(
                    'images/documentation.png',
                    fit: BoxFit.contain,
                    height: 22,
                    width: 22,
                    color: model.drawerIconColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Text(
                      'Documentation',
                      style: TextStyle(
                        color: model.drawerTextIconColor,
                        fontSize: 16,
                        letterSpacing: 0.4,
                        fontFamily: 'Roboto-Regular',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildCompanyLogoAndAppVersion(SampleModel model) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Align(
          alignment: Alignment.bottomCenter,
          child: Image.asset(
            model.themeData.colorScheme.brightness == Brightness.dark
                ? 'images/syncfusion_dark.png'
                : 'images/syncfusion.png',
            fit: BoxFit.contain,
            height: 50,
            width: 100,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            'Version 28.1.33',
            style: TextStyle(
              color: model.drawerTextIconColor,
              fontSize: 12,
              letterSpacing: 0.4,
              fontFamily: 'Roboto-Regular',
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    ),
  );
}

/// Shows copyright message, product related links
/// at the bottom of the home page.
Widget buildFooter(BuildContext context, SampleModel model) {
  final Color textColor = model.primaryColor;
  return Container(
    height: 60,
    decoration: BoxDecoration(
      border: Border(top: BorderSide(width: 0.8, color: model.dividerColor)),
      color: model.footerColor,
    ),
    padding: model.isMobileResolution
        ? EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width * 0.025,
            0,
            MediaQuery.of(context).size.width * 0.025,
            0,
          )
        : EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width * 0.05,
            0,
            MediaQuery.of(context).size.width * 0.05,
            0,
          ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                InkWell(
                  onTap: () => launchUrl(
                    Uri.parse(
                      'https://help.syncfusion.com/flutter/introduction/overview',
                    ),
                  ),
                  child: Text(
                    'Documentation',
                    style: TextStyle(color: textColor, fontSize: 12),
                  ),
                ),
                Text(' | ', style: TextStyle(fontSize: 12, color: textColor)),
                InkWell(
                  onTap: () => launchUrl(
                    Uri.parse('https://www.syncfusion.com/forums/flutter'),
                  ),
                  child: Text(
                    'Forum',
                    style: TextStyle(color: textColor, fontSize: 12),
                  ),
                ),
                Text(' | ', style: TextStyle(fontSize: 12, color: textColor)),
                InkWell(
                  onTap: () => launchUrl(
                    Uri.parse('https://www.syncfusion.com/blogs/?s=flutter'),
                  ),
                  child: Text(
                    'Blog',
                    style: TextStyle(color: textColor, fontSize: 12),
                  ),
                ),
                Text(' | ', style: TextStyle(color: textColor, fontSize: 12)),
                InkWell(
                  onTap: () => launchUrl(
                    Uri.parse('https://www.syncfusion.com/kb/flutter'),
                  ),
                  child: Text(
                    'Knowledge base',
                    style: TextStyle(color: textColor, fontSize: 12),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Copyright © 2001 - 2025 Syncfusion® Inc.',
                style: TextStyle(
                  color: model.themeData.colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  letterSpacing: 0.23,
                ),
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () => launchUrl(Uri.parse('https://www.syncfusion.com')),
          child: Image.asset(
            model.themeData.colorScheme.brightness == Brightness.dark
                ? 'images/syncfusion_dark.png'
                : 'images/syncfusion.png',
            fit: BoxFit.contain,
            height: 25,
            width: model.isMobileResolution ? 80 : 120,
          ),
        ),
      ],
    ),
  );
}

/// Show Right drawer which contains theme settings for web.
Widget buildWebThemeSettings(
  SampleModel model,
  BuildContext context,
  ChangeThemeCallback refresh,
) {
  int selectedValue = model.selectedThemeIndex;
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      final double width = MediaQuery.of(context).size.width * 0.4;
      final Color textColor =
          model.themeData.colorScheme.brightness == Brightness.light
          ? const Color.fromRGBO(84, 84, 84, 1)
          : const Color.fromRGBO(218, 218, 218, 1);
      return Drawer(
        child: Container(
          color: model.drawerBackgroundColor,
          padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
          child: Column(
            children: <Widget>[
              const Padding(padding: EdgeInsets.only(top: 15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Settings',
                    style: TextStyle(
                      color: model.themeData.colorScheme.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto-Medium',
                    ),
                  ),
                  IconButton(
                    color: model.themeData.colorScheme.onSurface,
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 25),
              if (MediaQuery.of(context).size.width < 1020)
                Align(
                  alignment: Alignment.centerLeft,
                  child: buildM2ToM3SwapOption(
                    model,
                    context,
                    MainAxisSize.max,
                    textColor,
                    refresh,
                  ),
                ),
              if (MediaQuery.of(context).size.width < 1020)
                const SizedBox(height: 25),
              StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return CupertinoSegmentedControl<int>(
                    padding: EdgeInsets.zero,
                    children: <int, Widget>{
                      0: Container(
                        width: width,
                        padding: const EdgeInsets.symmetric(vertical: 12.5),
                        alignment: Alignment.center,
                        child: Text(
                          'Light theme',
                          style: TextStyle(
                            color: selectedValue == 0
                                ? model.baseAppBarItemColor
                                : textColor,
                            fontFamily: 'Roboto-Medium',
                          ),
                        ),
                      ),
                      1: Container(
                        width: width,
                        alignment: Alignment.center,
                        child: Text(
                          'Dark theme',
                          style: TextStyle(
                            color: selectedValue == 1
                                ? model.baseAppBarItemColor
                                : textColor,
                            fontFamily: 'Roboto-Medium',
                          ),
                        ),
                      ),
                    },
                    unselectedColor: Colors.transparent,
                    selectedColor: model.primaryColor,
                    pressedColor: model.primaryColor,
                    borderColor: model.primaryColor,
                    groupValue: selectedValue,
                    onValueChanged: (int value) {
                      setState(() {
                        selectedValue = value;
                        model.selectedThemeIndex = value;
                        final Brightness brightness = value == 0
                            ? Brightness.light
                            : Brightness.dark;
                        refresh(model.themeData.useMaterial3, brightness);
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 25),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Theme colors',
                  style: TextStyle(
                    color: Color.fromRGBO(128, 128, 128, 1),
                    fontSize: 14,
                    fontFamily: 'Roboto-Regular',
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _buildColorPalettes(
                        model,
                        context,
                        selectedValue,
                        refresh,
                        setState,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Adding the palette color in the theme setting panel.
List<Widget> _buildColorPalettes(
  SampleModel model,
  BuildContext context,
  int selectedValue,
  ChangeThemeCallback refresh, [
  StateSetter? setState,
]) {
  final List<Widget> colorPaletteWidgets = <Widget>[];
  for (int i = 0; i < model.paletteColors.length; i++) {
    colorPaletteWidgets.add(
      Material(
        color: model.drawerBackgroundColor,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border:
                model.paletteBorderColors.isNotEmpty &&
                    model.paletteBorderColorsM3.isNotEmpty
                ? Border.all(
                    color: model.themeData.useMaterial3
                        ? model.paletteBorderColorsM3[i]
                        : model.paletteBorderColors[i],
                    width: 2.0,
                  )
                : const Border(),
            shape: BoxShape.circle,
          ),
          child: InkWell(
            hoverColor: model.hoverColor,
            highlightColor: model.splashColor,
            splashColor: model.splashColor,
            borderRadius: BorderRadius.circular(20.0),
            onTap: () {
              selectedColorPaletteIndex = i;
              changeColorPalette(
                model,
                context,
                selectedValue,
                model.themeData.useMaterial3,
                refresh,
                setState,
              );
            },
            child: Icon(
              Icons.brightness_1,
              size: 40.0,
              color: model.themeData.useMaterial3
                  ? model.themeData.brightness == Brightness.light
                        ? model.paletteColorsM3[i]
                        : model.darkPaletteColorsM3[i]
                  : model.paletteColors[i],
            ),
          ),
        ),
      ),
    );
  }
  return colorPaletteWidgets;
}

/// Changing the palette color of the application.
void changeColorPalette(
  SampleModel model,
  BuildContext context,
  int selectedThemeValue,
  bool isMaterial3,
  ChangeThemeCallback refresh, [
  StateSetter? setState,
]) {
  for (int j = 0; j < model.paletteBorderColors.length; j++) {
    model.paletteBorderColors[j] = Colors.transparent;
    model.paletteBorderColorsM3[j] = Colors.transparent;
  }

  final Brightness brightness = selectedThemeValue == -1
      ? model.systemTheme.brightness
      : selectedThemeValue == 0
      ? Brightness.light
      : Brightness.dark;
  setState?.call(() {});
  refresh(isMaterial3, brightness);
}

/// UI for switching m2 and m3.
Widget buildM2ToM3SwapOption(
  SampleModel model,
  BuildContext context,
  MainAxisSize mainAxisSize,
  Color textColor,
  ChangeThemeCallback refresh,
) {
  final bool isMaterial3 = model.themeData.useMaterial3;
  final Widget themeSwitch = SwitchTheme(
    data: SwitchThemeData(
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.selected)
            ? model.baseAppBarItemColor
            : null;
      }),
      trackOutlineWidth: WidgetStateProperty.resolveWith((states) {
        return 1.0;
      }),
    ),
    child: Switch(
      value: isMaterial3,
      onChanged: (bool value) {
        changeColorPalette(
          model,
          context,
          model.themeData.brightness == Brightness.light ? 0 : 1,
          value,
          refresh,
        );
      },
    ),
  );
  return SizedBox(
    height: 35,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: mainAxisSize,
      children: <Widget>[
        Text('Material 3', style: TextStyle(color: textColor)),
        if (isMaterial3) const SizedBox(width: 5),
        if (mainAxisSize == MainAxisSize.min)
          themeSwitch
        else
          Expanded(
            child: Align(alignment: Alignment.centerRight, child: themeSwitch),
          ),
      ],
    ),
  );
}

/// Getting status of the control/subitems/sample.
String statusTag(SubItem item) {
  final bool isWeb =
      kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux;
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
        ? (isWeb ? 'New' : 'N')
        : (newCount != 0 || updateCount != 0)
        ? (isWeb ? 'Updated' : 'U')
        : '';
  }
  return status;
}

/// show bottom sheet which contains theme settings.
void showBottomSettingsPanel(
  SampleModel model,
  BuildContext context,
  ChangeThemeCallback refresh,
) {
  int selectedValue = model.selectedThemeIndex;
  final double width = MediaQuery.of(context).size.width * 0.3;
  showRoundedModalBottomSheet<dynamic>(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        final Color textColor =
            model.themeData.colorScheme.brightness == Brightness.light
            ? const Color.fromRGBO(84, 84, 84, 1)
            : const Color.fromRGBO(218, 218, 218, 1);
        return Container(
          height: 300,
          color: model.drawerBackgroundColor,
          padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Settings',
                    style: TextStyle(
                      color: model.themeData.colorScheme.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto-Medium',
                    ),
                  ),
                  IconButton(
                    color: model.themeData.colorScheme.onSurface,
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: buildM2ToM3SwapOption(
                  model,
                  context,
                  MainAxisSize.max,
                  textColor,
                  refresh,
                ),
              ),
              const SizedBox(height: 25),
              StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return CupertinoSegmentedControl<int>(
                    padding: EdgeInsets.zero,
                    children: <int, Widget>{
                      0: Container(
                        width: width,
                        padding: const EdgeInsets.symmetric(vertical: 12.5),
                        alignment: Alignment.center,
                        child: Text(
                          'System theme',
                          style: TextStyle(
                            color: selectedValue == 0
                                ? model.baseAppBarItemColor
                                : textColor,
                            fontFamily: 'HeeboMedium',
                          ),
                        ),
                      ),
                      1: Container(
                        width: width,
                        alignment: Alignment.center,
                        child: Text(
                          'Light theme',
                          style: TextStyle(
                            color: selectedValue == 1
                                ? model.baseAppBarItemColor
                                : textColor,
                            fontFamily: 'HeeboMedium',
                          ),
                        ),
                      ),
                      2: Container(
                        width: width,
                        alignment: Alignment.center,
                        child: Text(
                          'Dark theme',
                          style: TextStyle(
                            color: selectedValue == 2
                                ? model.baseAppBarItemColor
                                : textColor,
                            fontFamily: 'HeeboMedium',
                          ),
                        ),
                      ),
                    },
                    unselectedColor: Colors.transparent,
                    selectedColor: model.primaryColor,
                    pressedColor: model.primaryColor,
                    borderColor: model.primaryColor,
                    groupValue: selectedValue,
                    onValueChanged: (int value) {
                      setState(() {
                        selectedValue = value;
                        model.selectedThemeIndex = value;
                        Brightness brightness;
                        if (value == 0) {
                          brightness = model.systemTheme.brightness;
                        } else if (value == 1) {
                          brightness = Brightness.light;
                        } else {
                          brightness = Brightness.dark;
                        }
                        refresh(model.themeData.useMaterial3, brightness);
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 25),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Theme colors',
                  style: TextStyle(
                    color: Color.fromRGBO(128, 128, 128, 1),
                    fontSize: 14,
                    fontFamily: 'HeeboMedium',
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _buildColorPalettes(
                        model,
                        context,
                        selectedValue == 0
                            ? -1
                            : selectedValue == 1
                            ? 0
                            : 1,
                        refresh,
                        setState,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}

/// To show the settings panel content in the bottom sheet.
void showBottomPropertySettingsPanel(
  BuildContext context,
  Widget propertyWidget,
) {
  final SampleModel model = SampleModel.instance;
  showRoundedModalBottomSheet<dynamic>(
    context: context,
    color: model.drawerBackgroundColor,
    builder: (BuildContext context) => Container(
      padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Settings',
                style: TextStyle(
                  color: model.textColor,
                  fontSize: 18,
                  letterSpacing: 0.34,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: model.textColor),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 50, 0, 0),
            child: propertyWidget,
          ),
        ],
      ),
    ),
  );
}

/// To show the sample description in the bottom sheet
void showBottomInfo(BuildContext context, String information) {
  final SampleModel model = SampleModel.instance;
  if (information != null && information != '') {
    List<TextSpan>? textSpans;
    TextSpan? textSpan;
    textSpans = getTextSpan(information, model);
    textSpan = textSpans[0];
    textSpans.removeAt(0);
    showRoundedModalBottomSheet<dynamic>(
      context: context,
      color: model.drawerBackgroundColor,
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
        child: Stack(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Description',
                  style: TextStyle(
                    color: model.textColor,
                    fontSize: 18,
                    letterSpacing: 0.34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: model.textColor),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 45, 12, 15),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text: textSpan!.text,
                      style: TextStyle(
                        color: model.textColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 15.0,
                        letterSpacing: 0.2,
                        height: 1.2,
                      ),
                      children: textSpans,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
