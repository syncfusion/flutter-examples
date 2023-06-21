/// Dart import
import 'dart:convert';
import 'dart:io' show Platform;

/// Package imports
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/web_view.dart';

/// Local import
import '../sample_list.dart';
import '../widgets/search_bar.dart';

/// WidgetCategory of the each control as Data Visualization, Editors,etc.,
class WidgetCategory {
  /// Constructor holds the name, id, control collection of the [WidgetCategory]
  WidgetCategory(
      [this.categoryName,
      this.controlList,
      this.mobileCategoryId,
      this.webCategoryId,
      this.platformsToHide]);

  /// Getting the control details from the json file
  factory WidgetCategory.fromJson(Map<String, dynamic> json) {
    return WidgetCategory(
        json['categoryName'],
        json['controlList'],
        json['mobileCategoryId'],
        json['webCategoryId'],
        json['platformsToHide']);
  }

  /// Name of the category
  String? categoryName;

  /// Control collection under the particular category
  List<dynamic>? controlList;

  /// Sorting the categories based on this id in mobile.
  final int? mobileCategoryId;

  /// Sorting the categories based on this id in web.
  final int? webCategoryId;

  /// Selected control in the controllist under the particular category
  int? selectedIndex = 0;

  /// To specify the category not to show on the web/android/iOS/windows/linux/macOS
  /// platforms in list format.
  ///
  /// Eg: In json file we can specify like below,
  ///
  /// "platformsToHide": ["linux", "android"] => the specific category should not show on the linux and android platforms
  final List<dynamic>? platformsToHide;
}

/// Defines the control class.
class Control {
  /// Contructor holds the tile, description, status etc., of the [Control]
  Control(
      this.title,
      this.description,
      this.image,
      this.status,
      this.displayType,
      this.subItems,
      this.controlId,
      this.isBeta,
      this.platformsToHide);

  /// Getting the control details from the json file
  factory Control.fromJson(Map<String, dynamic> json) {
    return Control(
        json['title'],
        json['description'],
        json['image'],
        json['status'],
        json['displayType'],
        json['subItems'],
        json['controlId'],
        json['isBeta'],
        json['platformsToHide']);
  }

  /// Contains title of the control, display in the home page
  final String? title;

  /// Contains description of the control, display in the home page
  final String? description;

  /// Contains image relates to the control, display in the home page
  final String? image;

  /// Conatins status of the control New/Updated/Beta
  final String? status;

  /// Display the controls based on this order.
  final int? controlId;

  /// Need to mention this when samples directly given without any sub category
  /// Mention as card/fullView, by default it will taken as "fullView".
  final String? displayType;

  /// Contains the subItem list which comes under sample type
  List<SubItem>? sampleList;

  /// Contains the subItem list which comes under [child] type
  List<SubItem>? childList;

  /// Contains the sample details collection
  List<dynamic>? subItems;

  /// To specify the control is beta or not in `https://pub.dev/publishers/syncfusion.com/packages`
  final bool? isBeta;

  /// To specify the control not to show on the web/android/iOS/windows/linux/macOS
  /// platforms in list format.
  ///
  /// Eg: In json file we can specify like below,
  ///
  /// "platformsToHide": ["linux", "android"] => the current control should not show on the linux and android platforms
  final List<dynamic>? platformsToHide;
}

/// Contains the detail of sample in different hierarchy levels
/// parent, child, sample types
class SubItem {
  /// It holds the type, title, key, description etc., of the sample
  SubItem(
      [this.type,
      this.displayType,
      this.title,
      this.key,
      this.codeLink,
      this.description,
      this.status,
      this.subItems,
      this.sourceLink,
      this.sourceText,
      this.needsPropertyPanel,
      this.platformsToHide]);

  /// Getting the SubItem details from the json file
  factory SubItem.fromJson(Map<String, dynamic> json) {
    return SubItem(
        json['type'],
        json['displayType'],
        json['title'],
        json['key'],
        json['codeLink'],
        json['description'],
        json['status'],
        json['subItems'],
        json['sourceLink'],
        json['sourceText'],
        json['needsPropertyPanel'],
        json['platformsToHide']);
  }

  /// Type given as parent/child/sample.
  /// if "parent" is given then primary tab and secondary tab both come.
  /// for "parent", "child" type must be give to subItems(next hierarchy).
  /// if "child" is given only primary tab will come.
  /// if "sample" is given no tab will come.
  /// by default it taken as "sample".
  /// Note: In all cases displayType is given as "fullView",
  /// additionally sample's tab will come.
  final String? type;

  /// Mention the samples layout.
  /// displayType given as card/fullView.
  /// by default it taken as "fullView".
  /// Note: Need to mention this when on display type is child.
  final String? displayType;

  /// Need to mention in all type.
  final String? title;

  /// Below values need to give when type is "sample".
  final String? key;

  /// Contains Github sample link
  final String? codeLink;

  /// Contains the description of the sample
  /// to be displayed in the sample backpanel
  final String? description;

  /// Status of the sample, displays above the sample
  final String? status;

  /// SourceLink which will launch a url of the sample's source
  /// on tapping source text present under the sample.
  final String? sourceLink;

  /// Short form of the source link which will displays under the sample.
  final String? sourceText;

  /// No need to give when type is "sample".
  List<dynamic>? subItems;

  /// If current sample has property panel mention true.
  final bool? needsPropertyPanel;

  /// Contains appropriate category name
  String? categoryName;

  ///Holds the URL text
  String? breadCrumbText;

  ///Current parent subItem index
  int? parentIndex;

  ///Current child subItem index
  int? childIndex;

  ///Current child subItem index
  int? sampleIndex;

  /// Holds appropriate control
  Control? control;

  /// To specify the sample not to show on the web/android/iOS/windows/linux/macOS
  /// platforms in list format.
  ///
  /// Eg: In json file we can specify like below,
  ///
  /// "platformsToHide": ["linux", "android"] => the specific sample should not show on the linux and android platforms
  final List<dynamic>? platformsToHide;
}

/// SampleModel class is the base of the Sample browser
/// It contains the category, control, theme information
class SampleModel extends Listenable {
  /// Contains the category, control, theme information
  SampleModel() {
    isInitialRender = true;
    searchControlItems = <Control>[];
    sampleList = <SubItem>[];
    searchResults = <SubItem>[];
    searchSampleItems = <SubItem>[];
    categoryList = SampleModel._categoryList;
    controlList = SampleModel._controlList;
    routes = SampleModel._routes;
    searchControlItems.addAll(controlList);
    for (int index = 0; index < controlList.length; index++) {
      if (controlList[index].sampleList != null) {
        for (int i = 0; i < controlList[index].sampleList!.length; i++) {
          searchSampleItems.add(controlList[index].sampleList![i]);
        }
      } else if (controlList[index].childList != null) {
        for (int i = 0; i < controlList[index].childList!.length; i++) {
          for (int j = 0;
              j < controlList[index].childList![i].subItems!.length;
              j++) {
            if (controlList[index].childList![i].subItems![j].type != 'child') {
              searchSampleItems
                  .add(controlList[index].childList![i].subItems![j]);
            } else {
              //ignore: prefer_foreach
              for (final SubItem sample
                  in controlList[index].childList![i].subItems![j].subItems) {
                searchSampleItems.add(sample);
              }
            }
          }
        }
      } else {
        for (int i = 0; i < controlList[index].subItems!.length; i++) {
          for (int j = 0;
              j < controlList[index].subItems![i].subItems.length;
              j++) {
            for (int k = 0;
                k < controlList[index].subItems![i].subItems[j].subItems.length;
                k++) {
              searchSampleItems
                  .add(controlList[index].subItems![i].subItems[j].subItems[k]);
            }
          }
        }
      }
    }
  }

  /// Used to create the instance of [SampleModel]
  static SampleModel instance = SampleModel();

  /// Specifies the widget initial rendering
  late bool isInitialRender;

  /// Contains the output widget of sample
  /// appropriate key and output widget mapped
  final Map<String, Function> sampleWidget = getSampleWidget();
  //ignore:prefer_final_fields
  static List<Control> _controlList = <Control>[];
  //ignore:prefer_final_fields
  static List<WidgetCategory> _categoryList = <WidgetCategory>[];

  /// Holds the category list
  late List<WidgetCategory> categoryList;

  /// Holds the sorted control list
  late List<Control> controlList;

  /// Holds the searched control list
  late List<Control> searchControlItems;

  ///List of all the samples
  late List<SubItem> sampleList;

  /// To handle search
  late List<SubItem> searchSampleItems;

  /// To handle search
  late List<SubItem> searchResults;

  /// To handle the search bar
  CustomSearchBar? searchBar;

  /// holds theme based current palette color
  Color backgroundColor = const Color.fromRGBO(0, 116, 227, 1);

  /// holds light theme current palette color
  Color paletteColor = const Color.fromRGBO(0, 116, 227, 1);

  /// holds current palette color
  /// on toggling the palette colors before or after apply settings
  Color currentPrimaryColor = const Color.fromRGBO(0, 116, 227, 1);

  /// holds the current theme data
  late ThemeData themeData;

  /// Holds theme baased color of web outputcontainer
  Color textColor = const Color.fromRGBO(51, 51, 51, 1);

  /// Holds theme based drawer text color
  Color drawerTextIconColor = Colors.black;

  /// Holds theme based bottom sheet color
  Color bottomSheetBackgroundColor = Colors.white;

  /// Holds theme based card color
  Color cardThemeColor = Colors.white;

  /// Holds theme based web page background color
  Color webBackgroundColor = const Color.fromRGBO(246, 246, 246, 1);

  /// Holds theme based color of icon
  Color webIconColor = const Color.fromRGBO(0, 0, 0, 0.54);

  /// Holds theme based input container color
  Color webInputColor = const Color.fromRGBO(242, 242, 242, 1);

  /// Holds theme based web outputcontainer color
  Color webOutputContainerColor = Colors.white;

  /// Holds the theme based card's color
  Color cardColor = Colors.white;

  /// Holds the theme based divider color
  Color dividerColor = const Color.fromRGBO(204, 204, 204, 1);

  /// Holds the old browser window's height and width
  Size? oldWindowSize;

  /// Holds the current browser window's height and width
  late Size currentWindowSize;

  static List<SampleRoute> _routes = <SampleRoute>[];

  /// List of navigation routes text and appropriate subitem
  late List<SampleRoute>? routes;

  /// Holds the current visible sample, only for web
  late dynamic currentRenderSample;

  /// Holds the current rendered sample's key, only for web
  late String? currentSampleKey;

  /// Contains the light theme pallete colors
  late List<Color>? paletteColors;

  /// Contains the pallete's border colors
  late List<Color>? paletteBorderColors;

  /// Contains dark theme theme palatte colors.
  late List<Color>? darkPaletteColors;

  /// Holds current theme data
  ThemeData? currentThemeData;

  /// Holds current pallete color
  Color currentPaletteColor = const Color.fromRGBO(0, 116, 227, 1);

  /// holds the index to finding the current theme
  /// In mobile sb - system 0, light 1, dark 2
  int selectedThemeIndex = 0;

  /// Holds the information of isCardView or not
  bool isCardView = true;

  /// Gets the locale assigned to [SampleModel].
  Locale? locale = const Locale('ar', 'AE');

  /// Gets the textDirection assigned to [SampleModel].
  TextDirection textDirection = TextDirection.rtl;

  /// Holds the information of isMobileResolution or not
  /// To render the appbar and search bar based on it
  late bool isMobileResolution;

  /// Holds the current system theme
  late ThemeData systemTheme;

  /// Editing controller which used in the search text field
  TextEditingController editingController = TextEditingController();

  /// Key of the property panel widget
  late GlobalKey<State> propertyPanelKey;

  /// Holds the information of to be maximize or not
  bool needToMaximize = false;

  ///Storing state of current output container
  late dynamic outputContainerState;

  ///Storing state of web output container
  late SampleOutputContainerState webOutputContainerState;

  ///check whether application is running on web/linuxOS/windowsOS/macOS
  bool isWebFullView = false;

  ///Check whether application is running on a mobile device
  bool isMobile = false;

  ///Check whether application is running on the web browser
  bool isWeb = false;

  ///Check whether application is running on the desktop
  bool isDesktop = false;

  ///Check whether application is running on the Android mobile device
  bool isAndroid = false;

  ///Check whether application is running on the Windows desktop OS
  bool isWindows = false;

  ///Check whether application is running on the iOS mobile device
  bool isIOS = false;

  ///Check whether application is running on the Linux desktop OS
  bool isLinux = false;

  ///Check whether application is running on the macOS desktop
  bool isMacOS = false;

  /// This controls to open / hide the property panel
  bool isPropertyPanelOpened = true;

  /// holds the current route of sample.
  late SampleRoute currentSampleRoute;

  /// Hold the current sample details.
  late SubItem sampleDetail;

  /// holds the collection of all sample routes.
  static List<SampleRoute> sampleRoutes = <SampleRoute>[];

  /// Holds the value whether the property panel option is tapped
  late bool isPropertyPanelTapped;

  /// Switching between light, dark, system themes
  void changeTheme(ThemeData currentThemeData) {
    themeData = currentThemeData;
    switch (currentThemeData.colorScheme.brightness) {
      case Brightness.dark:
        {
          dividerColor = const Color.fromRGBO(61, 61, 61, 1);
          cardColor = const Color.fromRGBO(48, 48, 48, 1);
          webIconColor = const Color.fromRGBO(255, 255, 255, 0.65);
          webOutputContainerColor = const Color.fromRGBO(23, 23, 23, 1);
          webInputColor = const Color.fromRGBO(44, 44, 44, 1);
          webBackgroundColor = const Color.fromRGBO(33, 33, 33, 1);
          drawerTextIconColor = Colors.white;
          bottomSheetBackgroundColor = const Color.fromRGBO(34, 39, 51, 1);
          textColor = const Color.fromRGBO(242, 242, 242, 1);
          cardThemeColor = const Color.fromRGBO(33, 33, 33, 1);
          break;
        }
      // ignore: no_default_cases
      default:
        {
          dividerColor = const Color.fromRGBO(204, 204, 204, 1);
          cardColor = Colors.white;
          webIconColor = const Color.fromRGBO(0, 0, 0, 0.54);
          webOutputContainerColor = Colors.white;
          webInputColor = const Color.fromRGBO(242, 242, 242, 1);
          webBackgroundColor = const Color.fromRGBO(246, 246, 246, 1);
          drawerTextIconColor = Colors.black;
          bottomSheetBackgroundColor = Colors.white;
          textColor = const Color.fromRGBO(51, 51, 51, 1);
          cardThemeColor = Colors.white;
          break;
        }
    }
  }

  //ignore: prefer_collection_literals
  final Set<VoidCallback> _listeners = Set<VoidCallback>();
  @override

  /// [listener] will be invoked when the model changes.
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override

  /// [listener] will no longer be invoked when the model changes.
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  /// Should be called only by [Model] when the model has changed.
  @protected
  void notifyListeners() {
    _listeners.toList().forEach((VoidCallback listener) => listener());
  }
}

/// Get the control details category wise, by parsing [sample_details.json]
/// Then store the details in [SampleModel._categoryList]
/// and [SampleModel._controlList]
Future<void> updateControlItems() async {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    await DesktopWindow.setMinWindowSize(const Size(775, 230));
  }

  bool isSample = false;
  bool isChild = false;
  final bool isWeb =
      kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  final String jsonText =
      await rootBundle.loadString('lib/sample_details.json');
  List<SubItem> firstLevelSubItems = <SubItem>[];
  List<SubItem> secondLevelSubItems = <SubItem>[];
  List<SubItem> thirdLevelSubItems = <SubItem>[];
  final List<SampleRoute> sampleRoutes = <SampleRoute>[];

  final List<dynamic> categoryList = json.decode(jsonText) as List<dynamic>;
  for (int index = 0; index < categoryList.length; index++) {
    SampleModel._categoryList.add(WidgetCategory.fromJson(categoryList[index]));
    final List<Control> controlList = <Control>[];
    if (SampleModel._categoryList[index].platformsToHide == null ||
        _needToShow(SampleModel._categoryList[index].platformsToHide)) {
      for (int i = 0;
          i < SampleModel._categoryList[index].controlList!.length;
          i++) {
        controlList.add(
            Control.fromJson(SampleModel._categoryList[index].controlList![i]));
        if (controlList[i].platformsToHide == null ||
            _needToShow(controlList[i].platformsToHide)) {
          for (int j = 0; j < controlList[i].subItems!.length; j++) {
            firstLevelSubItems
                .add(SubItem.fromJson(controlList[i].subItems![j]));
            if (firstLevelSubItems[j].type == 'parent') {
              for (int k = 0; k < firstLevelSubItems[j].subItems!.length; k++) {
                if (SubItem.fromJson(firstLevelSubItems[j].subItems![k])
                            .platformsToHide ==
                        null ||
                    _needToShow(
                        SubItem.fromJson(firstLevelSubItems[j].subItems![k])
                            .platformsToHide)) {
                  secondLevelSubItems.add(
                      SubItem.fromJson(firstLevelSubItems[j].subItems![k]));
                  for (int l = 0;
                      l <
                          secondLevelSubItems[secondLevelSubItems.length - 1]
                              .subItems!
                              .length;
                      l++) {
                    if (SubItem.fromJson(secondLevelSubItems[
                                        secondLevelSubItems.length - 1]
                                    .subItems![l])
                                .platformsToHide ==
                            null ||
                        _needToShow(SubItem.fromJson(secondLevelSubItems[
                                    secondLevelSubItems.length - 1]
                                .subItems![l])
                            .platformsToHide)) {
                      thirdLevelSubItems.add(SubItem.fromJson(
                          secondLevelSubItems[secondLevelSubItems.length - 1]
                              .subItems![l]));
                    }
                    thirdLevelSubItems[thirdLevelSubItems.length - 1]
                        .parentIndex = j;
                    thirdLevelSubItems[thirdLevelSubItems.length - 1]
                        .childIndex = k;
                    thirdLevelSubItems[thirdLevelSubItems.length - 1]
                        .sampleIndex ??= thirdLevelSubItems.length - 1;
                    thirdLevelSubItems[thirdLevelSubItems.length - 1].control =
                        controlList[i];
                    final String breadCrumbText = ('/' +
                            controlList[i].title! +
                            '/' +
                            firstLevelSubItems[j].title! +
                            '/' +
                            secondLevelSubItems[secondLevelSubItems.length - 1]
                                .title! +
                            (secondLevelSubItems[secondLevelSubItems.length - 1]
                                        .subItems!
                                        .length ==
                                    1
                                ? ''
                                : ('/' +
                                    thirdLevelSubItems[
                                            thirdLevelSubItems.length - 1]
                                        .title!)))
                        .replaceAll(' ', '-')
                        .toLowerCase();
                    thirdLevelSubItems[thirdLevelSubItems.length - 1]
                        .breadCrumbText = breadCrumbText;
                    thirdLevelSubItems[thirdLevelSubItems.length - 1]
                            .categoryName =
                        SampleModel._categoryList[index].categoryName;
                    sampleRoutes.add(SampleRoute(
                        routeName: breadCrumbText,
                        subItem:
                            thirdLevelSubItems[thirdLevelSubItems.length - 1]));
                  }
                  secondLevelSubItems[secondLevelSubItems.length - 1].subItems =
                      thirdLevelSubItems;
                  thirdLevelSubItems = <SubItem>[];
                }
              }
              firstLevelSubItems[j].subItems = secondLevelSubItems;
              secondLevelSubItems = <SubItem>[];
            } else if (firstLevelSubItems[j].type == 'child') {
              if (firstLevelSubItems[j].platformsToHide == null ||
                  _needToShow(firstLevelSubItems[j].platformsToHide)) {
                isChild = true;
                for (int k = 0;
                    k < firstLevelSubItems[j].subItems!.length;
                    k++) {
                  if (SubItem.fromJson(firstLevelSubItems[j].subItems![k])
                              .platformsToHide ==
                          null ||
                      _needToShow(
                          SubItem.fromJson(firstLevelSubItems[j].subItems![k])
                              .platformsToHide)) {
                    secondLevelSubItems.add(
                        SubItem.fromJson(firstLevelSubItems[j].subItems![k]));
                    secondLevelSubItems[secondLevelSubItems.length - 1]
                        .childIndex = j;
                    secondLevelSubItems[secondLevelSubItems.length - 1]
                        .sampleIndex ??= k;
                    secondLevelSubItems[secondLevelSubItems.length - 1]
                        .control = controlList[i];
                    String breadCrumbText;
                    if (firstLevelSubItems[j].subItems!.length == 1 &&
                        secondLevelSubItems.length == 1) {
                      breadCrumbText = ('/' +
                              controlList[i].title! +
                              '/' +
                              secondLevelSubItems[
                                      secondLevelSubItems.length - 1]
                                  .title!)
                          .replaceAll(' ', '-')
                          .toLowerCase();
                    } else {
                      breadCrumbText = ('/' +
                              controlList[i].title! +
                              '/' +
                              firstLevelSubItems[j].title! +
                              '/' +
                              secondLevelSubItems[
                                      secondLevelSubItems.length - 1]
                                  .title!)
                          .replaceAll(' ', '-')
                          .toLowerCase();
                    }

                    secondLevelSubItems[secondLevelSubItems.length - 1]
                        .breadCrumbText = breadCrumbText;
                    secondLevelSubItems[secondLevelSubItems.length - 1]
                            .categoryName =
                        SampleModel._categoryList[index].categoryName;
                    sampleRoutes.add(SampleRoute(
                        routeName: breadCrumbText,
                        subItem: secondLevelSubItems[
                            secondLevelSubItems.length - 1]));
                  }
                }
                firstLevelSubItems[j].subItems = secondLevelSubItems;
                secondLevelSubItems = <SubItem>[];
              } else {
                firstLevelSubItems.removeAt(j);
                controlList[i].subItems!.removeAt(j);
                j--;
              }
            } else {
              isSample = true;
              firstLevelSubItems[j].sampleIndex ??= j;
              if (firstLevelSubItems[j].platformsToHide == null ||
                  _needToShow(firstLevelSubItems[j].platformsToHide)) {
                final String breadCrumbText = ('/' +
                        controlList[i].title! +
                        '/' +
                        firstLevelSubItems[j].title!)
                    .replaceAll(' ', '-')
                    .toLowerCase();
                firstLevelSubItems[j].breadCrumbText = breadCrumbText;
                firstLevelSubItems[j].control = controlList[i];
                firstLevelSubItems[j].categoryName =
                    SampleModel._categoryList[index].categoryName;
                sampleRoutes.add(SampleRoute(
                    routeName: breadCrumbText, subItem: firstLevelSubItems[j]));
                secondLevelSubItems.add(firstLevelSubItems[j]);
              }
            }
          }
          if (isSample) {
            controlList[i].sampleList = secondLevelSubItems;
            controlList[i].subItems = secondLevelSubItems;
            secondLevelSubItems = <SubItem>[];
          } else if (isChild) {
            controlList[i].childList = firstLevelSubItems;
            secondLevelSubItems = <SubItem>[];
            isChild = false;
          }
          (!isSample)
              ? controlList[i].subItems = firstLevelSubItems
              : isSample = false;

          firstLevelSubItems = <SubItem>[];
        } else {
          controlList.removeAt(i);
          SampleModel._categoryList[index].controlList!.removeAt(i);
          i--;
        }
      }

      SampleModel._categoryList[index].controlList = controlList;
      SampleModel._controlList.addAll(controlList);
    } else {
      categoryList.removeAt(index);
      SampleModel._categoryList.removeAt(index);
      index--;
    }
  }

  SampleModel._routes = sampleRoutes;

  /// Sorting the controls based on control id category wise.
  for (int i = 0; i < SampleModel._categoryList.length; i++) {
    SampleModel._categoryList[i].controlList!.sort(
        (dynamic a, dynamic b) => a.controlId.compareTo(b.controlId) as int);
  }

  if (isWeb) {
    /// Sorting categories based on [webCategoryId]
    SampleModel._categoryList.sort((WidgetCategory a, WidgetCategory b) =>
        a.webCategoryId!.compareTo(b.webCategoryId!));
  } else {
    /// Sorting categories based on [mobileCategoryId]
    SampleModel._categoryList.sort((WidgetCategory a, WidgetCategory b) =>
        a.mobileCategoryId!.compareTo(b.mobileCategoryId!));
  }
}

bool _needToShow(List<dynamic>? platforms) {
  return !((platforms!.contains('web') && kIsWeb) ||
      (!kIsWeb &&
          ((platforms.contains('linux') && Platform.isLinux) ||
              (platforms.contains('android') && Platform.isAndroid) ||
              (platforms.contains('iOS') && Platform.isIOS) ||
              (platforms.contains('windows') && Platform.isWindows) ||
              (platforms.contains('macOS') && Platform.isMacOS))));
}

///Holds the [SubItem] and the appropriate route name
class SampleRoute {
  ///Contains the URL routes of the appropriate subItem
  SampleRoute(
      {this.routeName,
      this.subItem,
      this.currentContext,
      this.currentState,
      this.currentWidget,
      this.globalKey});

  ///Holds the sample details
  final SubItem? subItem;

  ///Holds the global key
  final GlobalKey<State>? globalKey;

  ///Holds the text which show in the URL
  String? routeName;

  ///Holds the current state
  State? currentState;

  ///Holds the current context
  BuildContext? currentContext;

  ///Holds the current widget
  Widget? currentWidget;
}
