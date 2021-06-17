/// Dart import
import 'dart:convert';
import 'dart:io' show Platform;

/// Package imports
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:desktop_window/desktop_window.dart';

import '../model/web_view.dart';

/// Local import
import '../sample_list.dart';

/// WidgetCategory of the each control as Data Visualization, Editors,etc.,
class WidgetCategory {
  /// Contructor holds the name, id, control collection of the [WidgetCategory]
  WidgetCategory(
      [this.categoryName,
      this.controlList,
      this.mobileCategoryId,
      this.webCategoryId,
      this.showInWeb]);

  /// Getting the control details from the json file
  factory WidgetCategory.fromJson(Map<String, dynamic> json) {
    return WidgetCategory(json['categoryName'], json['controlList'],
        json['mobileCategoryId'], json['webCategoryId'], json['showInWeb']);
  }

  /// Name of the category
  String? categoryName;

  /// Control collection under the particular category
  List<dynamic>? controlList;

  /// Sorting the categories based on this id in mobile.
  final int? mobileCategoryId;

  /// Sorting the categories based on this id in web.
  final int? webCategoryId;

  /// Specify false if the category need not to show in web
  /// (as Viewer - not supported in web).
  final bool? showInWeb;

  /// Selected control in the controllist under the particular category
  int? selectedIndex = 0;
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
      this.showInWeb,
      this.isBeta);

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
        json['showInWeb'],
        json['isBeta']);
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

  /// Specify false if the control need not to show in web
  /// (as pdf viewer - not supported in web).
  final bool? showInWeb;

  /// Contains the subItem list which comes under sample type
  List<SubItem>? sampleList;

  /// Contains the subItem list which comes under [child] type
  List<SubItem>? childList;

  /// Contains the sample details collection
  List<dynamic>? subItems;

  /// To specify the control is beta or not in `https://pub.dev/publishers/syncfusion.com/packages`
  final bool? isBeta;
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
      this.showInWeb,
      this.sourceLink,
      this.sourceText,
      this.needsPropertyPanel]);

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
        json['showInWeb'],
        json['sourceLink'],
        json['sourceText'],
        json['needsPropertyPanel']);
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

  /// Specify false if the sample need not to show in web
  /// (as sample with dash array).
  final bool? showInWeb;

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
}

/// SampleModel class is the base of the Sample browser
/// It contains the category, control, theme information
class SampleModel extends Listenable {
  /// Contains the category, control, theme information
  SampleModel() {
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

  /// Contains dark theme theme palatte colors
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

  /// Switching between light, dark, system themes
  void changeTheme(ThemeData _themeData) {
    themeData = _themeData;
    switch (_themeData.brightness) {
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

  bool _isSample = false;
  bool _isChild = false;
  final bool _isWeb =
      kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  final String _jsonText =
      await rootBundle.loadString('lib/sample_details.json');
  List<SubItem> _firstLevelSubItems = <SubItem>[];
  List<SubItem> _secondLevelSubItems = <SubItem>[];
  List<SubItem> _thirdLevelSubItems = <SubItem>[];
  final List<SampleRoute> sampleRoutes = <SampleRoute>[];

  final List<dynamic> categoryList = json.decode(_jsonText) as List<dynamic>;
  for (int index = 0; index < categoryList.length; index++) {
    SampleModel._categoryList.add(WidgetCategory.fromJson(categoryList[index]));
    final List<Control> controlList = <Control>[];
    if ((!_isWeb || SampleModel._categoryList[index].showInWeb != false) &&
        (SampleModel._categoryList[index].categoryName != 'Viewer' ||
            kIsWeb ||
            (!Platform.isWindows && !Platform.isLinux))) {
      for (int i = 0;
          i < SampleModel._categoryList[index].controlList!.length;
          i++) {
        controlList.add(
            Control.fromJson(SampleModel._categoryList[index].controlList![i]));
        if (!_isWeb || controlList[i].showInWeb != false) {
          for (int j = 0; j < controlList[i].subItems!.length; j++) {
            _firstLevelSubItems
                .add(SubItem.fromJson(controlList[i].subItems![j]));
            if (_firstLevelSubItems[j].type == 'parent') {
              for (int k = 0;
                  k < _firstLevelSubItems[j].subItems!.length;
                  k++) {
                if (!_isWeb ||
                    SubItem.fromJson(_firstLevelSubItems[j].subItems![k])
                            .showInWeb !=
                        false) {
                  _secondLevelSubItems.add(
                      SubItem.fromJson(_firstLevelSubItems[j].subItems![k]));
                  for (int l = 0;
                      l <
                          _secondLevelSubItems[_secondLevelSubItems.length - 1]
                              .subItems!
                              .length;
                      l++) {
                    if (!_isWeb ||
                        SubItem.fromJson(_secondLevelSubItems[
                                        _secondLevelSubItems.length - 1]
                                    .subItems![l])
                                .showInWeb !=
                            false) {
                      _thirdLevelSubItems.add(SubItem.fromJson(
                          _secondLevelSubItems[_secondLevelSubItems.length - 1]
                              .subItems![l]));
                    }
                    _thirdLevelSubItems[_thirdLevelSubItems.length - 1]
                        .parentIndex = j;
                    _thirdLevelSubItems[_thirdLevelSubItems.length - 1]
                        .childIndex = k;
                    _thirdLevelSubItems[_thirdLevelSubItems.length - 1]
                        .sampleIndex ??= _thirdLevelSubItems.length - 1;
                    _thirdLevelSubItems[_thirdLevelSubItems.length - 1]
                        .control = controlList[i];
                    final String breadCrumbText = ('/' +
                            controlList[i].title! +
                            '/' +
                            _firstLevelSubItems[j].title! +
                            '/' +
                            _secondLevelSubItems[
                                    _secondLevelSubItems.length - 1]
                                .title! +
                            (_secondLevelSubItems[
                                            _secondLevelSubItems.length - 1]
                                        .subItems!
                                        .length ==
                                    1
                                ? ''
                                : ('/' +
                                    _thirdLevelSubItems[
                                            _thirdLevelSubItems.length - 1]
                                        .title!)))
                        .replaceAll(' ', '-')
                        .toLowerCase();
                    _thirdLevelSubItems[_thirdLevelSubItems.length - 1]
                        .breadCrumbText = breadCrumbText;
                    _thirdLevelSubItems[_thirdLevelSubItems.length - 1]
                            .categoryName =
                        SampleModel._categoryList[index].categoryName!;
                    sampleRoutes.add(SampleRoute(
                        routeName: breadCrumbText,
                        subItem: _thirdLevelSubItems[
                            _thirdLevelSubItems.length - 1]));
                  }
                  _secondLevelSubItems[_secondLevelSubItems.length - 1]
                      .subItems = _thirdLevelSubItems;
                  _thirdLevelSubItems = <SubItem>[];
                }
              }
              _firstLevelSubItems[j].subItems = _secondLevelSubItems;
              _secondLevelSubItems = <SubItem>[];
            } else if (_firstLevelSubItems[j].type == 'child') {
              if (!_isWeb || _firstLevelSubItems[j].showInWeb != false) {
                _isChild = true;
                for (int k = 0;
                    k < _firstLevelSubItems[j].subItems!.length;
                    k++) {
                  if (!_isWeb ||
                      SubItem.fromJson(_firstLevelSubItems[j].subItems![k])
                              .showInWeb !=
                          false) {
                    _secondLevelSubItems.add(
                        SubItem.fromJson(_firstLevelSubItems[j].subItems![k]));
                    _secondLevelSubItems[_secondLevelSubItems.length - 1]
                        .childIndex = j;
                    _secondLevelSubItems[_secondLevelSubItems.length - 1]
                        .sampleIndex ??= k;
                    _secondLevelSubItems[_secondLevelSubItems.length - 1]
                        .control = controlList[i];
                    final String breadCrumbText = ('/' +
                            controlList[i].title! +
                            '/' +
                            _firstLevelSubItems[j].title! +
                            '/' +
                            _secondLevelSubItems[
                                    _secondLevelSubItems.length - 1]
                                .title!)
                        .replaceAll(' ', '-')
                        .toLowerCase();
                    _secondLevelSubItems[_secondLevelSubItems.length - 1]
                        .breadCrumbText = breadCrumbText;
                    _secondLevelSubItems[_secondLevelSubItems.length - 1]
                            .categoryName =
                        SampleModel._categoryList[index].categoryName!;
                    sampleRoutes.add(SampleRoute(
                        routeName: breadCrumbText,
                        subItem: _secondLevelSubItems[
                            _secondLevelSubItems.length - 1]));
                  }
                }
                _firstLevelSubItems[j].subItems = _secondLevelSubItems;
                _secondLevelSubItems = <SubItem>[];
              } else {
                _firstLevelSubItems.removeAt(j);
                controlList[i].subItems!.removeAt(j);
                j--;
              }
            } else {
              _isSample = true;
              _firstLevelSubItems[j].sampleIndex ??= j;
              if (!_isWeb || _firstLevelSubItems[j].showInWeb != false) {
                final String breadCrumbText = ('/' +
                        controlList[i].title! +
                        '/' +
                        _firstLevelSubItems[j].title!)
                    .replaceAll(' ', '-')
                    .toLowerCase();
                _firstLevelSubItems[j].breadCrumbText = breadCrumbText;
                _firstLevelSubItems[j].control = controlList[i];
                _firstLevelSubItems[j].categoryName =
                    SampleModel._categoryList[index].categoryName!;
                sampleRoutes.add(SampleRoute(
                    routeName: breadCrumbText,
                    subItem: _firstLevelSubItems[j]));
                _secondLevelSubItems.add(_firstLevelSubItems[j]);
              }
            }
          }
          if (_isSample) {
            controlList[i].sampleList = _secondLevelSubItems;
            controlList[i].subItems = _secondLevelSubItems;
            _secondLevelSubItems = <SubItem>[];
          } else if (_isChild) {
            controlList[i].childList = _firstLevelSubItems;
            _secondLevelSubItems = <SubItem>[];
            _isChild = false;
          }
          (!_isSample)
              ? controlList[i].subItems = _firstLevelSubItems
              : _isSample = false;

          _firstLevelSubItems = <SubItem>[];
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

  if (_isWeb) {
    /// Sorting categories based on [webCategoryId]
    SampleModel._categoryList.sort((WidgetCategory a, WidgetCategory b) =>
        a.webCategoryId!.compareTo(b.webCategoryId!));
  } else {
    /// Sorting categories based on [mobileCategoryId]
    SampleModel._categoryList.sort((WidgetCategory a, WidgetCategory b) =>
        a.mobileCategoryId!.compareTo(b.mobileCategoryId!));
  }
}

///Holds the [SubItem] and the appropriate route name
class SampleRoute {
  ///Contains the URL routes of the appropriate subItem
  SampleRoute({this.routeName, this.subItem});

  ///Holds the text which show in the URL
  final String? routeName;

  ///Holds the sample details
  final SubItem? subItem;
}
