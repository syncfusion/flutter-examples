/// Dart import
import 'dart:convert';

/// Package imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// Local import
import '../sample_list.dart';
import 'sample_view.dart';

/// WidgetCategory of the each control as Data Visualization, Editors,etc.,
class WidgetCategory {
  /// Name of the category
  String categoryName;

  /// Control collection under the particular category
  List<Control> controlList;

  /// Selected control in the controllist under the particular category
  int selectedIndex = 0;
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
      this.category,
      this.controlId,
      this.showInWeb);

  /// Getting the control details from the json file
  factory Control.fromJson(Map<String, dynamic> json) {
    return Control(
        json['title'],
        json['description'],
        json['image'],
        json['status'],
        json['displayType'],
        json['subItems'],
        json['category'],
        json['controlId'],
        json['showInWeb']);
  }

  /// Contains title of the control, display in the home page
  final String title;

  /// Contains description of the control, display in the home page
  final String description;

  /// Contains image relates to the control, display in the home page
  final String image;

  /// Conatins status of the control New/Updated/Preview
  final String status;

  /// Display the controls based on this order.
  final int controlId;

  /// Specify the category of the control as
  /// Data Visualization, Editors, Calendar, File format
  final String category;

  /// Need to mention this when samples directly given without any sub category
  /// Mention as card/fullView, by default it will taken as "fullView".
  final String displayType;

  /// Specify false if the control need not to show in web
  /// (as pdf viewer - not supported in web).
  final bool showInWeb;

  /// Contains the subItem list which comes under sample type
  List<SubItem> sampleList;

  /// Contains the subItem list which comes under [child] type
  List<SubItem> childList;

  /// Contains the sample details collection
  List<dynamic> subItems;
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
  final String type;

  /// Mention the samples layout.
  /// displayType given as card/fullView.
  /// by default it taken as "fullView".
  /// Note: Need to mention this when on display type is child.
  final String displayType;

  /// Need to mention in all type.
  final String title;

  /// Below values need to give when type is "sample".
  final String key;

  /// Contains Github sample link
  final String codeLink;

  /// Contains the description of the sample
  /// to be displayed in the sample backpanel
  final String description;

  /// Status of the sample, displays above the sample
  final String status;

  /// Specify false if the sample need not to show in web
  /// (as sample with dash array).
  final bool showInWeb;

  /// SourceLink which will launch a url of the sample's source
  /// on tapping source text present under the sample.
  final String sourceLink;

  /// Short form of the source link which will displays under the sample.
  final String sourceText;

  /// No need to give when type is "sample".
  List<dynamic> subItems;

  /// If current sample has property panel mention true.
  final bool needsPropertyPanel;

  /// Contains appropriate category name
  String categoryName;

  ///Holds the URL text
  String breadCrumbText;

  ///Current parent subItem index
  int parentIndex;

  ///Current child subItem index
  int childIndex;

  ///Current child subItem index
  int sampleIndex;

  /// Holds appropriate control
  Control control;
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
        for (int i = 0; i < controlList[index].sampleList.length; i++) {
          searchSampleItems.add(controlList[index].sampleList[i]);
        }
      } else if (controlList[index].childList != null) {
        for (int i = 0; i < controlList[index].childList.length; i++) {
          for (int j = 0;
              j < controlList[index].childList[i].subItems.length;
              j++) {
            if (controlList[index].childList[i].subItems[j].type != 'child') {
              searchSampleItems
                  .add(controlList[index].childList[i].subItems[j]);
            } else {
              //ignore: prefer_foreach
              for (final SubItem sample
                  in controlList[index].childList[i].subItems[j].subItems) {
                searchSampleItems.add(sample);
              }
            }
          }
        }
      } else {
        for (int i = 0; i < controlList[index].subItems.length; i++) {
          for (int j = 0;
              j < controlList[index].subItems[i].subItems.length;
              j++) {
            for (int k = 0;
                k < controlList[index].subItems[i].subItems[j].subItems.length;
                k++) {
              searchSampleItems
                  .add(controlList[index].subItems[i].subItems[j].subItems[k]);
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
  List<WidgetCategory> categoryList;

  /// Holds the sorted control list
  List<Control> controlList, searchControlItems;

  ///List of all the samples
  List<SubItem> sampleList;

  /// To handle search
  List<SubItem> searchSampleItems, searchResults;

  /// holds theme based current palette color
  Color backgroundColor = const Color.fromRGBO(0, 116, 227, 1);

  /// holds light theme current palette color
  Color paletteColor = const Color.fromRGBO(0, 116, 227, 1);

  /// holds current palette color
  /// on toggling the palette colors before or after apply settings
  Color currentPrimaryColor = const Color.fromRGBO(0, 116, 227, 1);

  /// holds the current theme data
  ThemeData themeData;

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
  Color webIconColor = const Color.fromRGBO(55, 55, 55, 1);

  /// set [kISWeb] result
  bool isWeb = false;

  /// Holds theme based input container color
  Color webInputColor = const Color.fromRGBO(242, 242, 242, 1);

  /// Holds theme based web outputcontainer color
  Color webOutputContainerColor = Colors.white;

  /// Holds the theme based card's color
  Color cardColor = Colors.white;

  /// Holds the theme based divider color
  Color dividerColor = const Color.fromRGBO(204, 204, 204, 1);

  /// Holds the old and current browser window's height and width
  Size oldWindowSize, currentWindowSize;
  static List<SampleRoute> _routes;

  /// List of navigation routes text and appropriate subitem
  List<SampleRoute> routes;

  /// Holds the current visible sample, only for web
  SampleView currentRenderSample;

  /// Holds the current rendered sample's key, only for web
  String currentSampleKey;

  /// Contains the light theme pallete colors
  List<Color> paletteColors;

  /// Contains the pallete's border colors
  List<Color> paletteBorderColors;

  /// Contains dark theme theme palatte colors
  List<Color> darkPaletteColors;

  /// Holds current theme data
  ThemeData currentThemeData;

  /// Holds current pallete color
  Color currentPaletteColor = const Color.fromRGBO(0, 116, 227, 1);

  /// holds the index to finding the current theme
  /// In mobile sb - system 0, light 1, dark 2
  int selectedThemeIndex = 0;

  /// Holds the information of isCardView or not
  bool isCardView = true;

  /// Holds the information of isMobileResolution or not
  /// To render the appbar and search bar based on it
  bool isMobileResolution;

  /// Holds the current system theme
  ThemeData systemTheme;

  /// Editing controller which used in the search text field
  TextEditingController editingController = TextEditingController();

  /// Switching between light, dark, system themes
  void changeTheme(ThemeData _themeData) {
    themeData = _themeData;
    switch (_themeData.brightness) {
      case Brightness.dark:
        {
          dividerColor = const Color.fromRGBO(61, 61, 61, 1);
          cardColor = const Color.fromRGBO(48, 48, 48, 1);
          webIconColor = const Color.fromRGBO(230, 230, 230, 1);
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
          webIconColor = const Color.fromRGBO(55, 55, 55, 1);
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
  bool _isSample = false;
  bool _isChild = false;
  const bool _isWeb = kIsWeb;
  final String _jsonText =
      await rootBundle.loadString('lib/sample_details.json');
  final List<dynamic> _controlList = json.decode(_jsonText);
  List<SubItem> _firstLevelSubItems = <SubItem>[];
  List<SubItem> _secondLevelSubItems = <SubItem>[];
  List<SubItem> _thirdLevelSubItems = <SubItem>[];
  final List<SampleRoute> sampleRoutes = <SampleRoute>[];
  for (int i = 0; i < _controlList.length; i++) {
    SampleModel._controlList.add(Control.fromJson(_controlList[i]));
    if (!_isWeb || SampleModel._controlList[i].showInWeb != false) {
      for (int j = 0; j < SampleModel._controlList[i].subItems.length; j++) {
        _firstLevelSubItems
            .add(SubItem.fromJson(SampleModel._controlList[i].subItems[j]));
        if (_firstLevelSubItems[j].type == 'parent') {
          for (int k = 0; k < _firstLevelSubItems[j].subItems.length; k++) {
            if (!_isWeb ||
                SubItem.fromJson(_firstLevelSubItems[j].subItems[k])
                        .showInWeb !=
                    false) {
              _secondLevelSubItems
                  .add(SubItem.fromJson(_firstLevelSubItems[j].subItems[k]));
              for (int l = 0;
                  l <
                      _secondLevelSubItems[_secondLevelSubItems.length - 1]
                          .subItems
                          .length;
                  l++) {
                if (!_isWeb ||
                    SubItem.fromJson(_secondLevelSubItems[
                                    _secondLevelSubItems.length - 1]
                                .subItems[l])
                            .showInWeb !=
                        false) {
                  _thirdLevelSubItems.add(SubItem.fromJson(
                      _secondLevelSubItems[_secondLevelSubItems.length - 1]
                          .subItems[l]));
                }
                _thirdLevelSubItems[_thirdLevelSubItems.length - 1]
                    .parentIndex = j;
                _thirdLevelSubItems[_thirdLevelSubItems.length - 1].childIndex =
                    k;
                _thirdLevelSubItems[_thirdLevelSubItems.length - 1]
                    .sampleIndex ??= _thirdLevelSubItems.length - 1;
                _thirdLevelSubItems[_thirdLevelSubItems.length - 1].control =
                    SampleModel._controlList[i];
                final String _breadCrumbText = ('/' +
                        SampleModel._controlList[i].title +
                        '/' +
                        _firstLevelSubItems[j].title +
                        '/' +
                        _secondLevelSubItems[_secondLevelSubItems.length - 1]
                            .title +
                        '/' +
                        _thirdLevelSubItems[_thirdLevelSubItems.length - 1]
                            .title)
                    .replaceAll(' ', '-')
                    .toLowerCase();
                _thirdLevelSubItems[_thirdLevelSubItems.length - 1]
                    .breadCrumbText = _breadCrumbText;
                _thirdLevelSubItems[_thirdLevelSubItems.length - 1]
                    .categoryName = SampleModel._controlList[i].category;
                sampleRoutes.add(SampleRoute(
                    routeName: _breadCrumbText,
                    subItem:
                        _thirdLevelSubItems[_thirdLevelSubItems.length - 1]));
              }
              _secondLevelSubItems[_secondLevelSubItems.length - 1].subItems =
                  _thirdLevelSubItems;
              _thirdLevelSubItems = <SubItem>[];
            }
          }
          _firstLevelSubItems[j].subItems = _secondLevelSubItems;
          _secondLevelSubItems = <SubItem>[];
        } else if (_firstLevelSubItems[j].type == 'child') {
          if (!_isWeb || _firstLevelSubItems[j].showInWeb != false) {
            _isChild = true;
            for (int k = 0; k < _firstLevelSubItems[j].subItems.length; k++) {
              if (!_isWeb ||
                  SubItem.fromJson(_firstLevelSubItems[j].subItems[k])
                          .showInWeb !=
                      false) {
                _secondLevelSubItems
                    .add(SubItem.fromJson(_firstLevelSubItems[j].subItems[k]));
                _secondLevelSubItems[_secondLevelSubItems.length - 1]
                    .childIndex = j;
                _secondLevelSubItems[_secondLevelSubItems.length - 1]
                    .sampleIndex ??= k;
                _secondLevelSubItems[_secondLevelSubItems.length - 1].control =
                    SampleModel._controlList[i];
                final String _breadCrumbText = ('/' +
                        SampleModel._controlList[i].title +
                        '/' +
                        _firstLevelSubItems[j].title +
                        '/' +
                        _secondLevelSubItems[_secondLevelSubItems.length - 1]
                            .title)
                    .replaceAll(' ', '-')
                    .toLowerCase();
                _secondLevelSubItems[_secondLevelSubItems.length - 1]
                    .breadCrumbText = _breadCrumbText;
                _secondLevelSubItems[_secondLevelSubItems.length - 1]
                    .categoryName = SampleModel._controlList[i].category;
                sampleRoutes.add(SampleRoute(
                    routeName: _breadCrumbText,
                    subItem:
                        _secondLevelSubItems[_secondLevelSubItems.length - 1]));
              }
            }
            _firstLevelSubItems[j].subItems = _secondLevelSubItems;
            _secondLevelSubItems = <SubItem>[];
          } else {
            _firstLevelSubItems.removeAt(j);
            SampleModel._controlList[i].subItems.removeAt(j);
            j--;
          }
        } else {
          _isSample = true;
          _firstLevelSubItems[j].sampleIndex ??= j;
          if (!_isWeb || _firstLevelSubItems[j].showInWeb != false) {
            final String _breadCrumbText = ('/' +
                    SampleModel._controlList[i].title +
                    '/' +
                    _firstLevelSubItems[j].title)
                .replaceAll(' ', '-')
                .toLowerCase();
            _firstLevelSubItems[j].breadCrumbText = _breadCrumbText;
            _firstLevelSubItems[j].control = SampleModel._controlList[i];
            _firstLevelSubItems[j].categoryName =
                SampleModel._controlList[i].category;
            sampleRoutes.add(SampleRoute(
                routeName: _breadCrumbText, subItem: _firstLevelSubItems[j]));
            _secondLevelSubItems.add(_firstLevelSubItems[j]);
          }
        }
      }
      if (_isSample) {
        SampleModel._controlList[i].sampleList = _secondLevelSubItems;
        SampleModel._controlList[i].subItems = _secondLevelSubItems;
        _secondLevelSubItems = <SubItem>[];
      } else if (_isChild) {
        SampleModel._controlList[i].childList = _firstLevelSubItems;
        _secondLevelSubItems = <SubItem>[];
        _isChild = false;
      }
      (!_isSample)
          ? SampleModel._controlList[i].subItems = _firstLevelSubItems
          : _isSample = false;

      _firstLevelSubItems = <SubItem>[];
    } else {
      SampleModel._controlList.removeAt(i);
      _controlList.removeAt(i);
      i--;
    }
  }

  SampleModel._routes = sampleRoutes;

  /// Sorting the controls based on control id.
  SampleModel._controlList
      .sort((Control a, Control b) => a.controlId.compareTo(b.controlId));

  /// Setting control's category.
  final List<String> _categoryNames = <String>[];
  String _controlCategory;
  for (int i = 0; i < SampleModel._controlList.length; i++) {
    _controlCategory = SampleModel._controlList[i].category.toUpperCase();
    if (!_categoryNames.contains(_controlCategory)) {
      _categoryNames.add(_controlCategory);
      SampleModel._categoryList.add(WidgetCategory());
      SampleModel._categoryList[SampleModel._categoryList.length - 1]
          .categoryName = _controlCategory;
    }
  }
  WidgetCategory _category;
  for (int j = 0; j < SampleModel._categoryList.length; j++) {
    _category = SampleModel._categoryList[j];
    _category.controlList = <Control>[];
    for (int i = 0; i < SampleModel._controlList.length; i++) {
      final Control control = SampleModel._controlList[i];
      if (control.category.toUpperCase() == _category.categoryName) {
        _category.controlList.add(control);
      }
    }
  }
}

///Holds the [SubItem] and the appropriate route name
class SampleRoute {
  ///Contains the URL routes of the appropriate subItem
  SampleRoute({this.routeName, this.subItem});

  ///Holds the text which show in the URL
  final String routeName;

  ///Holds the sample details
  final SubItem subItem;
}
