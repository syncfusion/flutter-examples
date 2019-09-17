import 'package:flutter/material.dart';
import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartesianTypes extends StatefulWidget {
  const CartesianTypes({Key key}) : super(key: key);

  @override
  _CartesianTypesState createState() => _CartesianTypesState();
}

class _CartesianTypesState extends State<CartesianTypes>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (context, _, model) => Theme(
            data: model.themeData,
            child: SafeArea(
              child: DefaultTabController(
                length:
                    model.controlList[model.selectedIndex].subItemList.length,
                child: Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    backgroundColor: model.backgroundColor,
                    bottom: TabBar(
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                            width: 5.0, color: Color.fromRGBO(252, 220, 0, 1)),
                      ),
                      isScrollable: true,
                      tabs: getTabs(model),
                    ),
                    title: Text(
                        model.controlList[model.selectedIndex].title.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.white,
                            letterSpacing: 0.3)),
                  ),
                  body: TabBarView(
                    children: getTabViewChildrens(model),
                  ),
                ),
              ),
            )));
  }

  List<Widget> getTabs(SampleListModel model) {
    List<Widget> tabs = <Widget>[];
    for (int i = 0;
        i < model.controlList[model.selectedIndex].subItemList.length;
        i++) {
      if (model.controlList[model.selectedIndex].subItemList[i].length > 0) {
        String str = getStatus(model
                .controlList[model.selectedIndex].subItemList[i]);
        tabs.add(Tab(
            child: Row(
          children: <Widget>[
            Text(model.controlList[model.selectedIndex].subItemList[i][0]
                    ?.category
                    .toString() +
                (str != '' ? '  ' : '')),
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: str == 'N'
                    ? Color.fromRGBO(101,193,0,1)
                    : str == 'U' ? Color.fromRGBO(245,166,35,1) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                str,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        )));
      }
    }
    return tabs;
  }

  List<Widget> getTabViewChildrens(SampleListModel model) {
    List<Widget> tabChildren = <Widget>[];
    for (int i = 0;
        i < model.controlList[model.selectedIndex].subItemList.length;
        i++) {
      tabChildren.add(ListView.builder(
          cacheExtent: model
              .controlList[model.selectedIndex].subItemList[i].length
              .toDouble(),
          addAutomaticKeepAlives: true,
          itemCount:
              model.controlList[model.selectedIndex].subItemList[i].length,
          itemBuilder: (BuildContext context, int position) {
            return Container(
              color: model.slidingPanelColor,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Card(
                            elevation: 2,
                            color: model.cardThemeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                            child: Column(
                              children: <Widget>[
                                InkWell(
                                  splashColor: Colors.grey.withOpacity(0.4),
                                  onTap: () {
                                    Feedback.forLongPress(context);
                                    onTapSampleItem(
                                        context,
                                        model.controlList[model.selectedIndex]
                                            .subItemList[i][position]);
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            '${model.controlList[model.selectedIndex].subItemList[i][position].title}',
                                            textAlign: TextAlign.left,
                                            softWrap: true,
                                            textScaleFactor: 1,
                                            overflow: TextOverflow.fade,
                                            style: TextStyle(
                                                fontFamily: 'MontserratMedium',
                                                fontSize: 16.0,
                                                color: model.textColor,
                                                letterSpacing: 0.3),
                                          ),
                                          Container(
                                              child: Row(
                                            children: <Widget>[
                                              Container(
                                                  decoration: BoxDecoration(
                                                      color: model
                                                                  .controlList[model
                                                                      .selectedIndex]
                                                                  .subItemList[i]
                                                                      [position]
                                                                  .status !=
                                                              null
                                                          ? (model.controlList[model.selectedIndex].subItemList[i][position].status ==
                                                                  'New'
                                                              ? Color.fromRGBO(
                                                                  101, 193, 0, 1)
                                                              : Color.fromRGBO(
                                                                  245,
                                                                  166,
                                                                  35,
                                                                  1))
                                                          : Colors.transparent,
                                                      shape: BoxShape.rectangle,
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(10.0))),
                                                  padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                                                  child: Text((model.controlList[model.selectedIndex].subItemList[i][position].status != null ? model.controlList[model.selectedIndex].subItemList[i][position].status : ''), style: TextStyle(color: Colors.white))),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 15),
                                              ),
                                              Container(
                                                height: 30,
                                                width: 30,
                                                color: Colors.transparent,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          5, 0, 5, 5),
                                                  child: Image.asset(
                                                      'images/fullscreen.png',
                                                      fit: BoxFit.contain,
                                                      height: 20,
                                                      width: 20,
                                                      color:
                                                          model.listIconColor),
                                                ),
                                              ),
                                            ],
                                          )),
                                        ]),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  splashColor: Colors.grey.withOpacity(0.4),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 230,
                                      child: model
                                          .controlList[model.selectedIndex]
                                          .subItemList[i][position]
                                          .previewWidget,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }));
    }
    return tabChildren;
  }

  @override
  bool get wantKeepAlive => false;
}
  