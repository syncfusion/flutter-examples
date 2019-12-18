import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import '../sample_list.dart';

class Control {
  Control(this.title, this.description, this.image,
      [this.status, this.displayType, this.subItems]);
  factory Control.fromJson(Map<dynamic, dynamic> json) {
    return Control(json['title'], json['description'], json['image'],
        json['status'], json['displayType'], json['subItems']);
  }
  final String title;
  final String description;
  final String image;
  final String status;

  /// Need to mention this when samples directly given without any sub category
  /// mention as card/fullView
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
      this.subItems]);
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
    );
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

  ///No need to give when type is "sample"
  List<dynamic> subItems;
}

class SampleModel extends Model {
  SampleModel() {
    controlList = <Control>[];
    searchControlItems = <Control>[];
    sampleList = <SubItem>[];
    searchSampleItems = <SubItem>[];
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
            searchSampleItems.add(controlList[index].childList[i].subItems[j]);
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
  bool isTargetMobile;
  List<Control> controlList;
  List<Control> searchControlItems; // To handle search
  List<SubItem> sampleList;
  List<SubItem> searchSampleItems; // To handle search
  int selectedIndex = 0;
  Color backgroundColor = const Color.fromRGBO(0, 116, 228, 1);
  Color slidingPanelColor = const Color.fromRGBO(250, 250, 250, 1);
  Color paletteColor;
  ThemeData themeData = ThemeData.light();
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

  void changeTheme(ThemeData _themeData) {
    themeData = _themeData;
    switch (_themeData.brightness) {
      case Brightness.dark:
        {
          drawerTextIconColor = Colors.white;
          drawerIconColor = Colors.white;
          slidingPanelColor = const Color.fromRGBO(32, 33, 37, 1);
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
          subItems1.add(SubItem.fromJson(subItems[j].subItems[k]));
          for (int l = 0; l < subItems1[k].subItems.length; l++) {
            subItems2.add(SubItem.fromJson(subItems1[k].subItems[l]));
          }
          subItems1[k].subItems = subItems2;
          subItems2 = <SubItem>[];
        }
        subItems[j].subItems = subItems1;
        subItems1 = <SubItem>[];
      } else if (subItems[j].type == 'child') {
        isChild = true;
        for (int k = 0; k < subItems[j].subItems.length; k++) {
          subItems1.add(SubItem.fromJson(subItems[j].subItems[k]));
        }
        subItems[j].subItems = subItems1;
        subItems1 = <SubItem>[];
      } else {
        isSample = true;
        subItems1.add(subItems[j]);
      }
    }
    if (isSample) {
      SampleModel.controlList1[i].sampleList = subItems1;
      subItems1 = <SubItem>[];
      isSample = false;
    } else if (isChild) {
      SampleModel.controlList1[i].childList = subItems;
      subItems1 = <SubItem>[];
      isChild = false;
    }

    SampleModel.controlList1[i].subItems = subItems;
    subItems = <SubItem>[];
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
      this.text});
  final dynamic x;
  final num y;
  final dynamic xValue;
  final num yValue;
  final num yValue2;
  final num yValue3;
  final Color pointColor;
  final num size;
  final String text;
}
