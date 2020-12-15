///Flutter package imports
import 'package:flutter/material.dart';

///Map import
import 'package:syncfusion_flutter_maps/maps.dart';

///Local import
import '../../../../model/sample_view.dart';

/// Renders the map widget with range color mapping
class MapSelectionPage extends SampleView {
  /// Creates the map widget with range color mapping
  const MapSelectionPage(Key key) : super(key: key);

  @override
  _MapSelectionPageState createState() => _MapSelectionPageState();
}

class _MapSelectionPageState extends SampleViewState {
  int _selectedIndex;

  List<_ElectionResultModel> _electionResults;

  MapShapeSource _selectionMapSource;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // Data source to the map.
    //
    // [primaryKey]: Field name in the .json file to identify the shape.
    // This is the name to be mapped with shapes in .json file.
    // This should be exactly same as the value of the
    // [shapeDataField] in the .json file
    //
    // [wonBy]: On the basis of this value, color mapping color has been
    // applied to the shape.
    _electionResults = <_ElectionResultModel>[
      _ElectionResultModel('Washington', 52.5, 36.8, 'Wash.', 'Democratic'),
      _ElectionResultModel('Oregon', 50.1, 39.1, 'Ore.', 'Democratic'),
      _ElectionResultModel('California', 61.5, 31.5, 'Calif.', 'Democratic'),
      _ElectionResultModel('Nevada', 47.9, 45.5, 'Nev.', 'Democratic'),
      _ElectionResultModel('Idaho', 59.2, 27.5, 'Idaho', 'Republican'),
      _ElectionResultModel('Montana', 55.6, 35.4, 'Mont.', 'Republican'),
      _ElectionResultModel('Wyoming', 68.2, 21.9, 'Wyo.', 'Republican'),
      _ElectionResultModel('Utah', 45.1, 27.2, 'Utah', 'Republican'),
      _ElectionResultModel('Arizona', 48.1, 44.6, 'Ariz.', 'Republican'),
      _ElectionResultModel('Colorado', 48.2, 43.3, 'Colo.', 'Democratic'),
      _ElectionResultModel('New Mexico', 48.3, 40.0, 'N.M.', 'Democratic'),
      _ElectionResultModel('Texas', 52.2, 43.2, 'Tex.', 'Republican'),
      _ElectionResultModel('Oklahoma', 65.3, 28.9, 'Okla.', 'Republican'),
      _ElectionResultModel('Kansas', 56.2, 36.7, 'Kan.', 'Republican'),
      _ElectionResultModel('Nebraska', 58.7, 33.7, 'Neb.', 'Republican'),
      _ElectionResultModel('South Dakota', 61.5, 31.7, 'S.D.', 'Republican'),
      _ElectionResultModel('North Dakota', 63.0, 27.2, 'N.D.', 'Republican'),
      _ElectionResultModel('Minnesota', 46.4, 44.9, 'Minn.', 'Democratic'),
      _ElectionResultModel('Lowa', 51.1, 41.7, 'Lowa', 'Republican'),
      _ElectionResultModel('Missouri', 56.4, 37.9, 'Mo.', 'Republican'),
      _ElectionResultModel('Arkansas', 60.6, 33.7, 'Ark.', 'Republican'),
      _ElectionResultModel('Louisiana', 58.1, 38.4, 'La.', 'Republican'),
      _ElectionResultModel('Mississippi', 57.9, 40.1, 'Miss.', 'Republican'),
      _ElectionResultModel('Tennessee', 60.7, 34.7, 'Tenn.', 'Republican'),
      _ElectionResultModel('Alabama', 62.1, 34.4, 'Ala.', 'Republican'),
      _ElectionResultModel('Georgia', 50.4, 45.3, 'Ga.', 'Republican'),
      _ElectionResultModel('Florida', 48.6, 47.4, 'Fla.', 'Republican'),
      _ElectionResultModel('South Carolina', 54.9, 40.7, 'S.C.', 'Republican'),
      _ElectionResultModel('North Carolina', 49.8, 46.2, 'N.C.', 'Republican'),
      _ElectionResultModel('Virginia', 49.8, 44.4, 'Va.', 'Democratic'),
      _ElectionResultModel('West Virginia', 67.9, 26.2, 'W.Va.', 'Republican'),
      _ElectionResultModel('Kentucky', 62.5, 32.7, 'Ky.', 'Republican'),
      _ElectionResultModel('Illinois', 55.2, 38.4, 'Ill.', 'Democratic'),
      _ElectionResultModel('Indiana', 56.5, 37.5, 'Ind.', 'Republican'),
      _ElectionResultModel('Ohio', 51.3, 43.2, 'Ohio', 'Republican'),
      _ElectionResultModel('Pennsylvania', 48.2, 47.5, 'Pa', 'Republican'),
      _ElectionResultModel('Maryland', 60.3, 33.9, 'Md.', 'Democratic'),
      _ElectionResultModel('New Jersey', 55.0, 41.0, 'N.J.', 'Democratic'),
      _ElectionResultModel('New York', 59.0, 36.5, 'N.Y.', 'Democratic'),
      _ElectionResultModel('Wisconsin', 47.2, 46.5, 'Wis.', 'Republican'),
      _ElectionResultModel('Michigan', 47.3, 47.0, 'Mich.', 'Republican'),
      _ElectionResultModel('Connecticut', 60.0, 32.8, 'Conn.', 'Democratic'),
      _ElectionResultModel('Massachusetts', 55.0, 41.0, 'Mass.', 'Democratic'),
      _ElectionResultModel('Vermont', 56.7, 30.3, 'Vt.', 'Democratic'),
      _ElectionResultModel('New Hampshire', 46.8, 46.5, 'N.H.', 'Democratic'),
      _ElectionResultModel('Massachusetts', 55.0, 41.0, 'Mass.', 'Democratic'),
      _ElectionResultModel('Maine', 47.8, 44.9, 'Me.', 'Democratic'),
      _ElectionResultModel('Alaska', 51.3, 36.6, 'Alaska', 'Republican'),
      _ElectionResultModel('Hawaii', 62.2, 30.0, 'Hawaii', 'Democratic'),
    ];

    _selectionMapSource = MapShapeSource.asset(
      // Path of the GeoJSON file.
      'assets/usa.json',
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

    _selectedIndex = -1;
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
            model.isWeb ? model.cardThemeColor : model.cardThemeColor,
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
            '2016 US Election Results',
            padding: EdgeInsets.only(top: 15, bottom: 30),
          ),
          layers: <MapLayer>[
            MapShapeLayer(
              loadingBuilder: (BuildContext context) {
                return Container(
                  height: 25,
                  width: 25,
                  child: const CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                );
              },
              source: _selectionMapSource,
              // Selection will not work if [MapShapeLayerDelegate.dataCount]
              // is null or empty.
              selectedIndex: _selectedIndex,
              strokeColor: Colors.white30,
              legend: const MapLegend(
                MapElement.shape,
                position: MapLegendPosition.bottom,
                padding: EdgeInsets.only(top: 15),
              ),
              selectionSettings: const MapSelectionSettings(
                  color: Color.fromRGBO(252, 177, 0, 1),
                  strokeColor: Colors.white,
                  strokeWidth: 2),
              // Passes the tapped or clicked shape index to the callback.
              onSelectionChanged: (int index) {
                if (index != _selectedIndex) {
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
                // Tapped or clicked shape UI won't change until the parent widget
                // rebuilds the maps widget with the new selected [index].
                //
                // Passing -1 to the [MapShapeLayer.selectedIndex] for unselecting
                // the previous selected shape.
                setState(() {
                  _selectedIndex = (index == _selectedIndex) ? -1 : index;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ElectionResultModel {
  _ElectionResultModel(this.primaryKey, this.wonVotePercent,
      this.lostVotePercent, this.state, this.wonBy);

  final String primaryKey;
  final double wonVotePercent;
  final double lostVotePercent;
  final String state;
  final String wonBy;
}
