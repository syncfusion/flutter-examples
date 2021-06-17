///Flutter package imports
import 'package:flutter/material.dart';

///Map import
// ignore: import_of_legacy_library_into_null_safe
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
  int _selectedIndex = -1;

  late List<_StateDetails> _electionResults;

  late MapShapeSource _selectionMapSource;

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
    _electionResults = <_StateDetails>[
      _StateDetails('Washington', 52.5, 36.8, 'Wash.', 'Democratic'),
      _StateDetails('Oregon', 50.1, 39.1, 'Ore.', 'Democratic'),
      _StateDetails('California', 61.5, 31.5, 'Calif.', 'Democratic'),
      _StateDetails('Nevada', 47.9, 45.5, 'Nev.', 'Democratic'),
      _StateDetails('Idaho', 59.2, 27.5, 'Idaho', 'Republican'),
      _StateDetails('Montana', 55.6, 35.4, 'Mont.', 'Republican'),
      _StateDetails('Wyoming', 68.2, 21.9, 'Wyo.', 'Republican'),
      _StateDetails('Utah', 45.1, 27.2, 'Utah', 'Republican'),
      _StateDetails('Arizona', 48.1, 44.6, 'Ariz.', 'Republican'),
      _StateDetails('Colorado', 48.2, 43.3, 'Colo.', 'Democratic'),
      _StateDetails('New Mexico', 48.3, 40.0, 'N.M.', 'Democratic'),
      _StateDetails('Texas', 52.2, 43.2, 'Tex.', 'Republican'),
      _StateDetails('Oklahoma', 65.3, 28.9, 'Okla.', 'Republican'),
      _StateDetails('Kansas', 56.2, 36.7, 'Kan.', 'Republican'),
      _StateDetails('Nebraska', 58.7, 33.7, 'Neb.', 'Republican'),
      _StateDetails('South Dakota', 61.5, 31.7, 'S.D.', 'Republican'),
      _StateDetails('North Dakota', 63.0, 27.2, 'N.D.', 'Republican'),
      _StateDetails('Minnesota', 46.4, 44.9, 'Minn.', 'Democratic'),
      _StateDetails('Lowa', 51.1, 41.7, 'Lowa', 'Republican'),
      _StateDetails('Missouri', 56.4, 37.9, 'Mo.', 'Republican'),
      _StateDetails('Arkansas', 60.6, 33.7, 'Ark.', 'Republican'),
      _StateDetails('Louisiana', 58.1, 38.4, 'La.', 'Republican'),
      _StateDetails('Mississippi', 57.9, 40.1, 'Miss.', 'Republican'),
      _StateDetails('Tennessee', 60.7, 34.7, 'Tenn.', 'Republican'),
      _StateDetails('Alabama', 62.1, 34.4, 'Ala.', 'Republican'),
      _StateDetails('Georgia', 50.4, 45.3, 'Ga.', 'Republican'),
      _StateDetails('Florida', 48.6, 47.4, 'Fla.', 'Republican'),
      _StateDetails('South Carolina', 54.9, 40.7, 'S.C.', 'Republican'),
      _StateDetails('North Carolina', 49.8, 46.2, 'N.C.', 'Republican'),
      _StateDetails('Virginia', 49.8, 44.4, 'Va.', 'Democratic'),
      _StateDetails('West Virginia', 67.9, 26.2, 'W.Va.', 'Republican'),
      _StateDetails('Kentucky', 62.5, 32.7, 'Ky.', 'Republican'),
      _StateDetails('Illinois', 55.2, 38.4, 'Ill.', 'Democratic'),
      _StateDetails('Indiana', 56.5, 37.5, 'Ind.', 'Republican'),
      _StateDetails('Ohio', 51.3, 43.2, 'Ohio', 'Republican'),
      _StateDetails('Pennsylvania', 48.2, 47.5, 'Pa', 'Republican'),
      _StateDetails('Maryland', 60.3, 33.9, 'Md.', 'Democratic'),
      _StateDetails('New Jersey', 55.0, 41.0, 'N.J.', 'Democratic'),
      _StateDetails('New York', 59.0, 36.5, 'N.Y.', 'Democratic'),
      _StateDetails('Wisconsin', 47.2, 46.5, 'Wis.', 'Republican'),
      _StateDetails('Michigan', 47.3, 47.0, 'Mich.', 'Republican'),
      _StateDetails('Connecticut', 60.0, 32.8, 'Conn.', 'Democratic'),
      _StateDetails('Massachusetts', 55.0, 41.0, 'Mass.', 'Democratic'),
      _StateDetails('Vermont', 56.7, 30.3, 'Vt.', 'Democratic'),
      _StateDetails('New Hampshire', 46.8, 46.5, 'N.H.', 'Democratic'),
      _StateDetails('Massachusetts', 55.0, 41.0, 'Mass.', 'Democratic'),
      _StateDetails('Maine', 47.8, 44.9, 'Me.', 'Democratic'),
      _StateDetails('Alaska', 51.3, 36.6, 'Alaska', 'Republican'),
      _StateDetails('Hawaii', 62.2, 30.0, 'Hawaii', 'Democratic'),
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
      shapeColorMappers: <MapColorMapper>[
        const MapColorMapper(value: 'Democratic', color: Colors.blue),
        const MapColorMapper(value: 'Republican', color: Colors.red),
      ],
    );
  }

  @override
  void dispose() {
    _electionResults.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            model.isWebFullView ? model.cardThemeColor : model.cardThemeColor,
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          final bool scrollEnabled = constraints.maxHeight > 400;
          double height = scrollEnabled ? constraints.maxHeight : 400;
          if (model.isWebFullView ||
              (model.isMobile &&
                  MediaQuery.of(context).orientation ==
                      Orientation.landscape)) {
            final double refHeight = height * 0.6;
            height =
                height > 500 ? (refHeight < 500 ? 500 : refHeight) : height;
          }
          return Center(
            child: SingleChildScrollView(
              child: SizedBox(
                width: constraints.maxWidth,
                height: height,
                child: _buildMapsWidget(scrollEnabled),
              ),
            ),
          );
        }));
  }

  Widget _buildMapsWidget(bool scrollEnabled) {
    return Center(
        child: Padding(
      padding: scrollEnabled
          ? EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.05,
              bottom: MediaQuery.of(context).size.height * 0.05,
              right: 10,
            )
          : const EdgeInsets.only(right: 10, bottom: 15),
      child: Column(children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 30),
            child: Align(
                alignment: Alignment.center,
                child: Text('2016 US Election Results',
                    style: Theme.of(context).textTheme.subtitle1))),
        Expanded(
            child: SfMaps(
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
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                                        .headline6!
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          ScaffoldMessenger.of(context)
                                              .removeCurrentSnackBar();
                                        },
                                        child: const Icon(Icons.close,
                                            color: Colors.white),
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
                                        .bodyText2!
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
                                        .bodyText2!
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
                                        .bodyText2!
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
                                        .bodyText2!
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
        )),
      ]),
    ));
  }
}

class _StateDetails {
  _StateDetails(this.primaryKey, this.wonVotePercent, this.lostVotePercent,
      this.state, this.wonBy);

  final String primaryKey;
  final double wonVotePercent;
  final double lostVotePercent;
  final String state;
  final String wonBy;
}
