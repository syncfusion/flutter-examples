import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/foundation.dart';
import '../sample_list.dart';

/// Categoryy of the each control as Data Visualization, Editors,etc.,
class Categoryy {
  String categoryName;
  List<Control> controlList;
  int selectedIndex = 0;
}

class Control {
  Control(this.title, this.description, this.image, this.status,
      this.displayType, this.subItems, this.category, this.controlId);
  factory Control.fromJson(Map<dynamic, dynamic> json) {
    return Control(
        json['title'],
        json['description'],
        json['image'],
        json['status'],
        json['displayType'],
        json['subItems'],
        json['category'],
        json['controlId']);
  }
  final String title;
  final String description;
  final String image;
  final String status;

  /// display the controls based on this order
  final int controlId;

  /// Specify the category of the control as
  /// Data Visualization, Editors, Calendar, File formats
  final String category;

  /// Need to mention this when samples directly given without any sub category.
  /// Mention as card/fullView
  /// by default it will taken as "fullView"
  final String displayType;
  List<dynamic> sampleList;
  List<dynamic> childList;
  List<dynamic> subItems;
}

class SubItem {
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
      this.sourceText]);
  factory SubItem.fromJson(Map<dynamic, dynamic> json) {
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
        json['sourceText']);
  }

  /// type given as parent/child/sample.
  /// if "parent" is given then primary tab and secondary tab both come.
  /// for "parent", "child" type must be give to subItems(next hierarchy).
  /// if "child" is given only primary tab will come.
  /// if "sample" is given no tab will come.
  /// by default it taken as "sample".
  /// Note: In all cases displayType is given as "fullView", additionally sample's tab will come.
  final String type;

  /// Mention the samples layout.
  /// displayType given as card/fullView.
  /// by default it taken as "fullView".
  /// Note: Need to mention this when on display type is child.
  final String displayType;

  /// Need to mention in all type
  final String title;

  /// Below values need to give when type is "sample"
  final String key;
  final String codeLink;
  final String description;
  final String status;

  /// Specify false if the sample need not to show in web
  /// (as sample with dash array)
  final bool showInWeb;

  /// sourceLink which will launch a url of the sample's source
  /// on tapping source text present under the sample
  final String sourceLink;

  /// Short form of the source link which will displays under the sample
  final String sourceText;

  ///No need to give when type is "sample"
  List<dynamic> subItems;
}

class SampleModel extends Model {
  SampleModel() {
    categoryList = <Categoryy>[];
    controlList = <Control>[];
    searchControlItems = <Control>[];
    sampleList = <SubItem>[];
    searchResults = <SubItem>[];
    searchSampleItems = <SubItem>[];
    categoryList = SampleModel.categoryList1;
    controlList = SampleModel.controlList1;
    // For search results
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
            if (controlList[index].childList[i].subItems[j].type != 'child')
              searchSampleItems
                  .add(controlList[index].childList[i].subItems[j]);
            else {
              //ignore: prefer_foreach
              for (SubItem sample
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
  final Map<String, List<dynamic>> sampleWidget = getSampleWidget();
  static List<Control> controlList1 = <Control>[];
  static List<Categoryy> categoryList1 = <Categoryy>[];
  bool isTargetMobile;
  List<Categoryy> categoryList;
  List<Control> controlList;
  List<Control> searchControlItems; // To handle search
  List<SubItem> sampleList;
  List<SubItem> searchSampleItems; // To handle search
  List<SubItem> searchResults;
  int selectedIndex = 0;
  Color backgroundColor = const Color.fromRGBO(0, 116, 228, 1);
  Color slidingPanelColor = const Color.fromRGBO(250, 250, 250, 1);
  Color paletteColor;
  ThemeData themeData;
  Color searchBoxColor = Colors.white;
  Color listIconColor = const Color.fromRGBO(0, 116, 228, 1);
  Color listDescriptionTextColor = Colors.grey;
  Color textColor = const Color.fromRGBO(51, 51, 51, 1);
  String codeViewerIcon = 'images/code.png';
  String informationIcon = 'images/info.png';
  Brightness theme = Brightness.light;
  Color drawerTextIconColor = Colors.black;
  Color drawerIconColor = Colors.black;
  Color drawerBackgroundColor = Colors.white;
  Color bottomSheetBackgroundColor = Colors.white;
  final bool isTileView = true;
  Color cardThemeColor = Colors.white;
  Color webBackgroundColor = const Color.fromRGBO(246, 246, 246, 1);
  Color webIconColor = const Color.fromRGBO(111, 111, 111, 1);
  bool isWeb = false;
  Color webInputColor = const Color.fromRGBO(242, 242, 242, 1);
  Color webOutputContainerColor = Colors.white;
  Color webCardColor = Colors.white;
  Color webFooterColor = const Color.fromRGBO(234, 234, 234, 1);
  Color webDividerColor = const Color.fromRGBO(204, 204, 204, 1);
  Color webSampleBackgroundColor = Colors.white;
  Color webTabTextColor = const Color.fromRGBO(89, 89, 89, 1);
  String syncfusionIcon = 'images/syncfusion.png';
  Color webDividerColor2 = const Color.fromRGBO(238, 238, 238, 1);

  Color lightThemeSelected;
  Color darkThemeSelected;
  List<Color> colors;
  List<Color> defaultBorderColor;
  ThemeData currentThemeData;
  Color currentBackgroundColor = const Color.fromRGBO(0, 116, 228, 1);
  Color currentListIconColor;
  Color currentPaletteColor;
  bool isLightThemeSelected = true;

  dynamic sampleOutputContainer;
  Map<dynamic, dynamic> properties = <dynamic, dynamic>{};
  GlobalKey globalKey;

  void changeTheme(ThemeData _themeData) {
    themeData = _themeData;
    switch (_themeData.brightness) {
      case Brightness.dark:
        {
          syncfusionIcon = 'images/syncfusion_dark.png';
          webDividerColor = const Color.fromRGBO(61, 61, 61, 1);
          webDividerColor2 = const Color.fromRGBO(61, 61, 61, 1);
          webTabTextColor = Colors.white;
          webCardColor = const Color.fromRGBO(48, 48, 48, 1);
          webIconColor = const Color.fromRGBO(230, 230, 230, 1);
          webOutputContainerColor = const Color.fromRGBO(23, 23, 23, 1);
          webInputColor = const Color.fromRGBO(44, 44, 44, 1);
          webBackgroundColor = const Color.fromRGBO(33, 33, 33, 1);
          webFooterColor = const Color.fromRGBO(33, 33, 33, 1);
          webSampleBackgroundColor = const Color.fromRGBO(33, 33, 33, 1);
          drawerTextIconColor = Colors.white;
          drawerIconColor = Colors.white;
          slidingPanelColor =
              Colors.black; //const Color.fromRGBO(32, 33, 37, 1);
          drawerBackgroundColor = Colors.black;
          bottomSheetBackgroundColor = const Color.fromRGBO(34, 39, 51, 1);
          backgroundColor =
              paletteColor ?? const Color.fromRGBO(0, 116, 228, 1);
          listIconColor = paletteColor ?? Colors.white;
          searchBoxColor = Colors.white;
          listDescriptionTextColor = const Color.fromRGBO(242, 242, 242, 1);
          textColor = const Color.fromRGBO(242, 242, 242, 1);
          theme = Brightness.dark;
          cardThemeColor = const Color.fromRGBO(23, 27, 36, 1);
          break;
        }
      default:
        {
          syncfusionIcon = 'images/syncfusion.png';
          webDividerColor = const Color.fromRGBO(204, 204, 204, 1);
          webDividerColor2 = const Color.fromRGBO(238, 238, 238, 1);
          webTabTextColor = const Color.fromRGBO(89, 89, 89, 1);
          webCardColor = Colors.white;
          webIconColor = const Color.fromRGBO(111, 111, 111, 1);
          webOutputContainerColor = Colors.white;
          webInputColor = const Color.fromRGBO(242, 242, 242, 1);
          webBackgroundColor = const Color.fromRGBO(246, 246, 246, 1);
          webFooterColor = const Color.fromRGBO(234, 234, 234, 1);
          webSampleBackgroundColor = Colors.white;
          drawerTextIconColor = Colors.black;
          drawerIconColor = Colors.black;
          slidingPanelColor = Colors.white;
          drawerIconColor = Colors.black;
          drawerBackgroundColor = Colors.white;
          bottomSheetBackgroundColor = Colors.white;
          backgroundColor =
              paletteColor ?? const Color.fromRGBO(0, 116, 228, 1);
          listIconColor = paletteColor ?? const Color.fromRGBO(0, 116, 228, 1);
          searchBoxColor = Colors.white;
          listDescriptionTextColor = Colors.grey;
          textColor = const Color.fromRGBO(51, 51, 51, 1);
          theme = Brightness.light;
          cardThemeColor = Colors.white;
          break;
        }
    }
  }
}

Future<void> updateControl() async {
  bool isSample = false;
  bool isChild = false;
  const bool isWeb = kIsWeb;
  final String jsonText =
      await rootBundle.loadString('lib/sample_details.json');
  final List<dynamic> controlList = json.decode(jsonText);
  List<SubItem> subItems = <SubItem>[];
  List<SubItem> subItems1 = <SubItem>[];
  List<SubItem> subItems2 = <SubItem>[];
  for (int i = 0; i < controlList.length; i++) {
    SampleModel.controlList1.add(Control.fromJson(controlList[i]));
    for (int j = 0; j < SampleModel.controlList1[i].subItems.length; j++) {
      subItems.add(SubItem.fromJson(SampleModel.controlList1[i].subItems[j]));
      if (subItems[j].type == 'parent') {
        for (int k = 0; k < subItems[j].subItems.length; k++) {
          if (!isWeb ||
              SubItem.fromJson(subItems[j].subItems[k]).showInWeb != false) {
            subItems1.add(SubItem.fromJson(subItems[j].subItems[k]));
            for (int l = 0;
                l < subItems1[subItems1.length - 1].subItems.length;
                l++) {
              if (!isWeb ||
                  SubItem.fromJson(subItems1[subItems1.length - 1].subItems[l])
                          .showInWeb !=
                      false)
                subItems2.add(SubItem.fromJson(
                    subItems1[subItems1.length - 1].subItems[l]));
            }
            subItems1[subItems1.length - 1].subItems = subItems2;
            subItems2 = <SubItem>[];
          }
        }
        subItems[j].subItems = subItems1;
        subItems1 = <SubItem>[];
      } else if (subItems[j].type == 'child' &&
          (!isWeb || subItems[j].showInWeb != false)) {
        isChild = true;
        for (int k = 0; k < subItems[j].subItems.length; k++) {
          if (!isWeb ||
              SubItem.fromJson(subItems[j].subItems[k]).showInWeb != false) {
            subItems1.add(SubItem.fromJson(subItems[j].subItems[k]));
          }
        }
        subItems[j].subItems = subItems1;
        subItems1 = <SubItem>[];
      } else {
        isSample = true;
        if (!isWeb || subItems[j].showInWeb != false)
          subItems1.add(subItems[j]);
      }
    }
    if (isSample) {
      SampleModel.controlList1[i].sampleList = subItems1;
      SampleModel.controlList1[i].subItems = subItems1;
      subItems1 = <SubItem>[];
    } else if (isChild) {
      SampleModel.controlList1[i].childList = subItems;
      subItems1 = <SubItem>[];
      isChild = false;
    }
    if (!isSample) {
      SampleModel.controlList1[i].subItems = subItems;
    } else {
      isSample = false;
    }

    subItems = <SubItem>[];
  }

  ///sorting the controls based on control id (only for web)
  if (isWeb)
    SampleModel.controlList1
        .sort((Control a, Control b) => a.controlId.compareTo(b.controlId));

  ///Setting control's category
  final List<String> categoryNames = <String>[];
  for (int i = 0; i < SampleModel.controlList1.length; i++) {
    final String controlCategory =
        SampleModel.controlList1[i].category.toUpperCase();
    if (!categoryNames.contains(controlCategory)) {
      categoryNames.add(controlCategory);
      SampleModel.categoryList1.add(Categoryy());
      SampleModel.categoryList1[SampleModel.categoryList1.length - 1]
          .categoryName = controlCategory;
    }
  }

  /// reordering the category for web view
  Categoryy temp;
  temp = SampleModel.categoryList1[0];
  SampleModel.categoryList1[0] = SampleModel.categoryList1[2];
  SampleModel.categoryList1[2] = SampleModel.categoryList1[3];
  SampleModel.categoryList1[3] = SampleModel.categoryList1[1];
  SampleModel.categoryList1[1] = temp;
  ////

  for (int j = 0; j < SampleModel.categoryList1.length; j++) {
    final Categoryy category = SampleModel.categoryList1[j];
    category.controlList = <Control>[];
    for (int i = 0; i < SampleModel.controlList1.length; i++) {
      final Control control = SampleModel.controlList1[i];
      if (control.category.toUpperCase() == category.categoryName) {
        category.controlList.add(control);
      }
    }
  }
}

class ChartSampleData {
  ChartSampleData(
      {this.x,
      this.y,
      this.xValue,
      this.yValue,
      this.yValue2,
      this.yValue3,
      this.pointColor,
      this.size,
      this.text,
      this.open,
      this.close});
  final dynamic x;
  final num y;
  final dynamic xValue;
  final num yValue;
  final num yValue2;
  final num yValue3;
  final Color pointColor;
  final num size;
  final String text;
  final num open;
  final num close;
}
