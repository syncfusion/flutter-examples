import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:flutter_examples/model/sample_view.dart';

class MapSelection extends SampleView {
  const MapSelection(Key key) : super(key: key);

  @override
  _MapSelectionState createState() => _MapSelectionState();
}

class _MapSelectionState extends SampleViewState {
  List<ElectionResultModel> _electionResults;

  MapShapeLayerDelegate _selectionMapDelegate;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // Data source to the map.
    //
    // [primaryKey]: Field name in the .json file to identify the shape.
    // This is the name to be mapped with shapes in .json file.
    // This should be exactly same as the value of the [shapeDataField] in the .json file
    //
    // [wonBy]: On the basis of this value, color mapping color has been
    // applied to the shape.
    _electionResults = <ElectionResultModel>[
      ElectionResultModel('Washington', 52.5, 36.8, 'Wash.', 'Democratic'),
      ElectionResultModel('Oregon', 50.1, 39.1, 'Ore.', 'Democratic'),
      ElectionResultModel('California', 61.5, 31.5, 'Calif.', 'Democratic'),
      ElectionResultModel('Nevada', 47.9, 45.5, 'Nev.', 'Democratic'),
      ElectionResultModel('Idaho', 59.2, 27.5, 'Idaho', 'Republican'),
      ElectionResultModel('Montana', 55.6, 35.4, 'Mont.', 'Republican'),
      ElectionResultModel('Wyoming', 68.2, 21.9, 'Wyo.', 'Republican'),
      ElectionResultModel('Utah', 45.1, 27.2, 'Utah', 'Republican'),
      ElectionResultModel('Arizona', 48.1, 44.6, 'Ariz.', 'Republican'),
      ElectionResultModel('Colorado', 48.2, 43.3, 'Colo.', 'Democratic'),
      ElectionResultModel('New Mexico', 48.3, 40.0, 'N.M.', 'Democratic'),
      ElectionResultModel('Texas', 52.2, 43.2, 'Tex.', 'Republican'),
      ElectionResultModel('Oklahoma', 65.3, 28.9, 'Okla.', 'Republican'),
      ElectionResultModel('Kansas', 56.2, 36.7, 'Kan.', 'Republican'),
      ElectionResultModel('Nebraska', 58.7, 33.7, 'Neb.', 'Republican'),
      ElectionResultModel('South Dakota', 61.5, 31.7, 'S.D.', 'Republican'),
      ElectionResultModel('North Dakota', 63.0, 27.2, 'N.D.', 'Republican'),
      ElectionResultModel('Minnesota', 46.4, 44.9, 'Minn.', 'Democratic'),
      ElectionResultModel('Lowa', 51.1, 41.7, 'Lowa', 'Republican'),
      ElectionResultModel('Missouri', 56.4, 37.9, 'Mo.', 'Republican'),
      ElectionResultModel('Arkansas', 60.6, 33.7, 'Ark.', 'Republican'),
      ElectionResultModel('Louisiana', 58.1, 38.4, 'La.', 'Republican'),
      ElectionResultModel('Mississippi', 57.9, 40.1, 'Miss.', 'Republican'),
      ElectionResultModel('Tennessee', 60.7, 34.7, 'Tenn.', 'Republican'),
      ElectionResultModel('Alabama', 62.1, 34.4, 'Ala.', 'Republican'),
      ElectionResultModel('Georgia', 50.4, 45.3, 'Ga.', 'Republican'),
      ElectionResultModel('Florida', 48.6, 47.4, 'Fla.', 'Republican'),
      ElectionResultModel('South Carolina', 54.9, 40.7, 'S.C.', 'Republican'),
      ElectionResultModel('North Carolina', 49.8, 46.2, 'N.C.', 'Republican'),
      ElectionResultModel('Virginia', 49.8, 44.4, 'Va.', 'Democratic'),
      ElectionResultModel('West Virginia', 67.9, 26.2, 'W.Va.', 'Republican'),
      ElectionResultModel('Kentucky', 62.5, 32.7, 'Ky.', 'Republican'),
      ElectionResultModel('Illinois', 55.2, 38.4, 'Ill.', 'Democratic'),
      ElectionResultModel('Indiana', 56.5, 37.5, 'Ind.', 'Republican'),
      ElectionResultModel('Ohio', 51.3, 43.2, 'Ohio', 'Republican'),
      ElectionResultModel('Pennsylvania', 48.2, 47.5, 'Pa', 'Republican'),
      ElectionResultModel('Maryland', 60.3, 33.9, 'Md.', 'Democratic'),
      ElectionResultModel('New Jersey', 55.0, 41.0, 'N.J.', 'Democratic'),
      ElectionResultModel('New York', 59.0, 36.5, 'N.Y.', 'Democratic'),
      ElectionResultModel('Wisconsin', 47.2, 46.5, 'Wis.', 'Republican'),
      ElectionResultModel('Michigan', 47.3, 47.0, 'Mich.', 'Republican'),
      ElectionResultModel('Connecticut', 60.0, 32.8, 'Conn.', 'Democratic'),
      ElectionResultModel('Massachusetts', 55.0, 41.0, 'Mass.', 'Democratic'),
      ElectionResultModel('Vermont', 56.7, 30.3, 'Vt.', 'Democratic'),
      ElectionResultModel('New Hampshire', 46.8, 46.5, 'N.H.', 'Democratic'),
      ElectionResultModel('Massachusetts', 55.0, 41.0, 'Mass.', 'Democratic'),
      ElectionResultModel('Maine', 47.8, 44.9, 'Me.', 'Democratic'),
      ElectionResultModel('Alaska', 51.3, 36.6, 'Alaska', 'Republican'),
      ElectionResultModel('Hawaii', 62.2, 30.0, 'Hawaii', 'Democratic'),
    ];

    _selectionMapDelegate = MapShapeLayerDelegate(
      // Path of the GeoJSON file.
      shapeFile: 'assets/usa.json',
      // Field or group name in the .json file to identify the shapes.
      //
      // Which is used to map the respective shape to data source.
      //
      // On the basis of this value, shape tooltip text is rendered.
      shapeDataField: 'name',
      // The number of data in your data source collection.
      //
      // The callback for the [primaryValueMapper] will be called
      // the number of times equal to the [dataCount].
      // The value returned in the [primaryValueMapper] should be
      // exactly matched with the value of the [shapeDataField]
      // in the .json file. This is how the mapping between the
      // data source and the shapes in the .json file is done.
      dataCount: _electionResults.length,
      primaryValueMapper: (int index) => _electionResults[index].primaryKey,
      // Used for color mapping.
      //
      // The value of the [MapColorMapper.value] will be compared with the value
      // returned in the [shapeColorValueMapper]. If it is equal, the respective
      // [MapColorMapper.color] will be applied to the shape.
      shapeColorValueMapper: (int index) => _electionResults[index].wonBy,
      // Group and differentiate the shapes using the color
      // based on [MapColorMapper.value] value.
      //
      // The value of the [MapColorMapper.value]
      // will be compared with the value returned in the
      // [shapeColorValueMapper] and the respective [MapColorMapper.color]
      // will be applied to the shape.
      shapeColorMappers: const <MapColorMapper>[
        MapColorMapper(value: 'Democratic', color: Colors.blue),
        MapColorMapper(value: 'Republican', color: Colors.red),
      ],
    );
  }

  @override
  void dispose() {
    _electionResults?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor:
            model.isWeb ? model.webSampleBackgroundColor : model.cardThemeColor,
        body: MediaQuery.of(context).orientation == Orientation.portrait ||
                model.isWeb
            ? _getMapsWidget()
            : SingleChildScrollView(child: _getMapsWidget()));
  }

  Widget _getMapsWidget() {
    return Center(
      child: Padding(
        padding: MediaQuery.of(context).orientation == Orientation.portrait ||
                model.isWeb
            ? EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.05,
                bottom: MediaQuery.of(context).size.height * 0.05,
                right: 10,
              )
            : const EdgeInsets.only(right: 10, bottom: 15),
        child: SfMaps(
          title: const MapTitle(
            text: '2016 US Election Results',
            padding: EdgeInsets.only(top: 15, bottom: 30),
          ),
          layers: <MapLayer>[
            MapShapeLayer(
              loadingBuilder: (_) {
                return Container(
                  height: 25,
                  width: 25,
                  child: const CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                );
              },
              delegate: _selectionMapDelegate,
              showLegend: true,
              // Selection will not work if [MapShapeLayerDelegate.dataCount] is null or empty.
              enableSelection: true,
              strokeColor: Colors.white30,
              legendSettings: const MapLegendSettings(
                  position: MapLegendPosition.bottom,
                  padding: EdgeInsets.only(top: 15)),
              selectionSettings: const MapSelectionSettings(
                  color: Color.fromRGBO(252, 177, 0, 1),
                  strokeColor: Colors.white,
                  strokeWidth: 2),
              onSelectionChanged: (int index) {
                if (index != -1) {
                  _scaffoldKey.currentState.hideCurrentSnackBar();
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    backgroundColor:
                        _electionResults[index].wonBy == 'Republican'
                            ? Colors.red
                            : Colors.blue,
                    content: Container(
                      height: 100,
                      padding: const EdgeInsets.only(top: 8),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(_electionResults[index].primaryKey,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        child: const Icon(Icons.close,
                                            color: Colors.white),
                                        onTap: () {
                                          _scaffoldKey.currentState
                                              .hideCurrentSnackBar();
                                        },
                                      )),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                Text('Won candidate :   ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                Text(
                                    _electionResults[index].wonBy ==
                                            'Republican'
                                        ? 'Trump'
                                        : 'Clinton',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.white))
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                Text('Percentage :         ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                Text(
                                    _electionResults[index]
                                            .wonVotePercent
                                            .toString() +
                                        '%',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.white))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    duration: const Duration(seconds: 3),
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ElectionResultModel {
  ElectionResultModel(this.primaryKey, this.wonVotePercent,
      this.lostVotePercent, this.state, this.wonBy);

  final String primaryKey;
  final double wonVotePercent;
  final double lostVotePercent;
  final String state;
  final String wonBy;
}
