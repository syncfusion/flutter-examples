import 'package:flutter/material.dart';
import 'package:flutter_examples/model/view.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'model.dart';

void onTapControlItem(BuildContext context, SampleModel model, int position) {
  model.selectedIndex = position;
  Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => const LayoutPage()));
}

void onTapSampleItem(BuildContext context, SubItem sample,
    [SampleModel model]) {
  model.sampleWidget[sample.key][1].sample = sample;
  Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
          builder: (BuildContext context) =>
              model.sampleWidget[sample.key][1]));
}

class BackPanel extends StatefulWidget {
  //ignore:prefer_const_constructors_in_immutables
  BackPanel(this.sample);
  final SubItem sample;

  @override
  _BackPanelState createState() => _BackPanelState(sample);
}

class _BackPanelState extends State<BackPanel> {
  _BackPanelState(this.sample);
  final SubItem sample;
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  void _afterLayout(dynamic _) {
    _getSizesAndPosition();
  }

  void _getSizesAndPosition() {
    final RenderBox renderBoxRed =
        _globalKey.currentContext?.findRenderObject();
    final Size size = renderBoxRed?.size;
    final Offset position = renderBoxRed?.localToGlobal(Offset.zero);
    const double appbarHeight = 60;
    BackdropState.frontPanelHeight = position == null
        ? 0
        : (position.dy + (size.height - appbarHeight) + 20);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleModel>(
      rebuildOnChange: true,
      builder: (BuildContext context, _, SampleModel model) {
        return Container(
          color: model.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  sample.title,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                      color: Colors.white,
                      letterSpacing: 0.53),
                ),
                sample.description != null
                    ? Padding(
                        key: _globalKey,
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text(
                          sample.description,
                          style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15.0,
                              color: Colors.white,
                              letterSpacing: 0.3,
                              height: 1.5),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FrontPanel extends StatefulWidget {
  //ignore:prefer_const_constructors_in_immutables
  FrontPanel(this.sampleList, this.sample, this.sourceLink, this.source);
  final SubItem sampleList;
  final dynamic sample;
  final String sourceLink;
  final String source;

  @override
  _FrontPanelState createState() =>
      _FrontPanelState(sampleList, sample, sourceLink, source);
}

class _FrontPanelState extends State<FrontPanel> {
  _FrontPanelState(this.sampleList, this.sample, this.sourceLink, this.source);
  final SubItem sampleList;
  final dynamic sample;
  final String sourceLink;
  final String source;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
              child: Container(child: sample),
            ),
            floatingActionButton: sourceLink == null
                ? null
                : Stack(children: <Widget>[
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 50, 0, 0),
                        child: Container(
                          height: 50,
                          child: InkWell(
                            onTap: () => launch(sourceLink),
                            child: Row(
                              children: <Widget>[
                                Text('Source: ',
                                    style: TextStyle(
                                        fontSize: 16, color: model.textColor)),
                                Text(source,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.blue)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ]),
          );
        });
  }
}

ScopedModelDescendant<SampleModel> getScopedModel(
    dynamic sampleWidget, SubItem sample,
    [Widget settingPanel, String sourceLink, String source]) {
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);
  return ScopedModelDescendant<SampleModel>(
      builder: (BuildContext context, _, SampleModel model) => SafeArea(
            child: Backdrop(
              toggleFrontLayer:
                  sample.description != null && sample.description != '',
              needCloseButton: false,
              panelVisible: frontPanelVisible,
              sampleListModel: model,
              appBarAnimatedLeadingMenuIcon: AnimatedIcons.close_menu,
              appBarActions: (sample.description != null &&
                      sample.description != '')
                  ? <Widget>[
                      (sample.codeLink != null && sample.codeLink != '')
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Container(
                                height: 40,
                                width: 40,
                                child: IconButton(
                                  icon: Image.asset(model.codeViewerIcon,
                                      color: Colors.white),
                                  onPressed: () {
                                    launch(sample.codeLink);
                                  },
                                ),
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Container(
                          height: 40,
                          width: 40,
                          child: IconButton(
                            icon: Image.asset(model.informationIcon,
                                color: Colors.white),
                            onPressed: () {
                              if (frontPanelVisible.value)
                                frontPanelVisible.value = false;
                              else
                                frontPanelVisible.value = true;
                            },
                          ),
                        ),
                      ),
                    ]
                  : (sample.codeLink != null && sample.codeLink != '')
                      ? (<Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Container(
                              height: 40,
                              width: 40,
                              child: IconButton(
                                icon: Image.asset(model.codeViewerIcon,
                                    color: Colors.white),
                                onPressed: () {
                                  launch(sample.codeLink);
                                },
                              ),
                            ),
                          ),
                        ])
                      : null,
              appBarTitle: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 1000),
                  child: Text(sample.title.toString())),
              backLayer: BackPanel(sample),
              frontLayer: settingPanel ??
                  FrontPanel(sample, sampleWidget, sourceLink, source),
              sideDrawer: null,
              headerClosingHeight: 350,
              titleVisibleOnPanelClosed: true,
              color: model.cardThemeColor,
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12), bottom: Radius.circular(0)),
            ),
          ));
}
