/// Flutter package imports
import 'package:flutter/material.dart';

///Map import
import 'package:syncfusion_flutter_maps/maps.dart';

///Local import
import '../../../../model/sample_view.dart';

class MapOSMPage extends SampleView {
  /// Creates the map widget with OSM map.
  const MapOSMPage(Key key) : super(key: key);
  _TileLayerSampleState createState() => _TileLayerSampleState();
}

class _TileLayerSampleState extends SampleViewState {
  PageController _pageViewController;
  MapTileLayerController _mapController;

  MapZoomPanBehavior _zoomPanBehavior;

  List<WorldWonderModel> _data;

  int _currentSelectedIndex;
  int _previousSelectedIndex;
  int _tappedMarkerIndex;

  double _cardHeight;

  bool _canUpdateFocalLatLng;

  @override
  void initState() {
    super.initState();
    _currentSelectedIndex = 5;
    _canUpdateFocalLatLng = true;
    _mapController = MapTileLayerController();
    _data = <WorldWonderModel>[];

    _data.add(WorldWonderModel(
        place: 'Chichen Itza',
        country: 'Mexico',
        latitude: 20.6843,
        longitude: -88.5678,
        description:
            'Mayan ruins on Mexico\'s Yucatan Peninsula. It was one of the largest Maya cities, thriving from around A.D. 600 to 1200.',
        imagePath: 'images/maps_chichen_itza.jpg'));

    _data.add(WorldWonderModel(
        place: 'Machu Picchu',
        country: 'Peru',
        latitude: -13.1631,
        longitude: -72.5450,
        description:
            'An Inca citadel built in the mid-1400s. It was not widely known until the early twentieth century.',
        imagePath: 'images/maps_machu_pichu.jpg'));

    _data.add(WorldWonderModel(
        place: 'Christ the Redeemer',
        country: 'Brazil',
        latitude: -22.9519,
        longitude: -43.2105,
        description:
            'An enormous statue of Jesus Christ with open arms, constructed between 1922 and 1931.',
        imagePath: 'images/maps_christ_redeemer.jpg'));

    _data.add(WorldWonderModel(
        place: 'Colosseum',
        country: 'Rome',
        latitude: 41.8902,
        longitude: 12.4922,
        description:
            'Built between A.D. 70 and 80, it could accommodate 50,000 to 80,000 people in tiered seating. It is one of the most popular tourist attractions in Europe.',
        imagePath: 'images/maps_colosseum.jpg'));

    _data.add(WorldWonderModel(
        place: 'Petra',
        country: 'Jordan',
        latitude: 30.3285,
        longitude: 35.4444,
        description:
            'An ancient stone city located in southern Jordan. It became the capital city for the Nabataeans around the fourth century BC.',
        imagePath: 'images/maps_petra.jpg'));

    _data.add(WorldWonderModel(
        place: 'Taj Mahal',
        country: 'India',
        latitude: 27.1751,
        longitude: 78.0421,
        description:
            'A white marble mausoleum in Agra, India. It was commissioned in A.D. 1632 by the Mughal emperor Shah Jahan to hold the remains of his favorite wife. It was completed in 1653.',
        imagePath: 'images/maps_taj_mahal.jpg'));

    _data.add(WorldWonderModel(
        place: 'Great Wall of China',
        country: 'China',
        latitude: 40.4319,
        longitude: 116.5704,
        description:
            'A series of walls and fortifications built along the northern border of China to protect Chinese states from invaders. Counting all of its offshoots, its length is more than 13,000 miles.',
        imagePath: 'images/maps_great_wall_of_china.jpg'));

    _zoomPanBehavior = MapZoomPanBehavior(
      minZoomLevel: 3,
      maxZoomLevel: 10,
      zoomLevel: model.isWeb ? 5 : 4,
      focalLatLng: MapLatLng(_data[_currentSelectedIndex].latitude,
          _data[_currentSelectedIndex].longitude),
    );
  }

  @override
  void dispose() {
    _pageViewController?.dispose();
    _mapController?.dispose();
    _data?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _cardHeight = (MediaQuery.of(context).orientation == Orientation.landscape)
        ? (model.isWeb ? 120 : 90)
        : 110;
    _pageViewController = PageController(
        initialPage: _currentSelectedIndex,
        viewportFraction:
            (MediaQuery.of(context).orientation == Orientation.landscape)
                ? (model.isWeb ? 0.5 : 0.7)
                : 0.8);
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'images/maps_grid.png',
            repeat: ImageRepeat.repeat,
          ),
        ),
        SfMaps(
          layers: [
            MapTileLayer(
              /// URL to request the tiles from the providers.
              ///
              /// The [urlTemplate] accepts the URL in WMTS format i.e. {z} —
              /// zoom level, {x} and {y} — tile coordinates.
              ///
              /// We will replace the {z}, {x}, {y} internally based on the
              /// current center point and the zoom level.
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              zoomPanBehavior: _zoomPanBehavior,
              controller: _mapController,
              initialMarkersCount: _data.length,
              markerBuilder: (BuildContext context, int index) {
                return MapMarker(
                  latitude: _data[index].latitude,
                  longitude: _data[index].longitude,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_currentSelectedIndex != index) {
                            _canUpdateFocalLatLng = false;
                            _tappedMarkerIndex = index;
                            _pageViewController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Icon(Icons.location_on,
                            color: _currentSelectedIndex == index
                                ? Colors.blue
                                : Colors.red,
                            size: _currentSelectedIndex == index ? 40 : 25),
                      ),
                      SizedBox(
                        height: (_currentSelectedIndex == index ? 40 : 25),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: _cardHeight,
            padding: EdgeInsets.only(bottom: 10),

            /// PageView which shows the world wonder details at the bottom.
            child: PageView.builder(
              itemCount: _data.length,
              onPageChanged: _handlePageChange,
              controller: _pageViewController,
              itemBuilder: (BuildContext context, int index) {
                final WorldWonderModel item = _data[index];
                return Transform.scale(
                  scale: index == _currentSelectedIndex ? 1 : 0.85,
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Color.fromRGBO(255, 255, 255, 1)
                                  : Color.fromRGBO(66, 66, 66, 1),
                          border: Border.all(
                            color: Color.fromRGBO(153, 153, 153, 1),
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(children: [
                          // Adding title and description for card.
                          Expanded(
                              child: Padding(
                            padding:
                                const EdgeInsets.only(top: 5.0, right: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.place + ', ' + item.country,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    textAlign: TextAlign.start),
                                SizedBox(height: 5),
                                Expanded(
                                    child: Text(
                                  item.description,
                                  style: TextStyle(
                                      fontSize: model.isWeb ? 14 : 11),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: (index == 2 || index == 6) ? 2 : 4,
                                ))
                              ],
                            ),
                          )),
                          // Adding Image for card.
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            child: Image.asset(
                              item.imagePath,
                              height: _cardHeight - 10,
                              width: _cardHeight - 10,
                              fit: BoxFit.fill,
                            ),
                          )
                        ]),
                      ),
                      // Adding splash to card while tapping.
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius:
                              BorderRadius.all(Radius.elliptical(10, 10)),
                          onTap: () {
                            if (_currentSelectedIndex != index) {
                              _pageViewController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _handlePageChange(int index) {
    /// While updating the page viewer through interaction, selected position's
    /// marker should be moved to the center of the maps. However, when the
    /// marker is directly clicked, only the respective card should be moved to
    /// center and the marker itself should not move to the center of the maps.
    if (!_canUpdateFocalLatLng) {
      if (_tappedMarkerIndex == index) {
        _updateSelectedCard(index);
      }
    } else if (_canUpdateFocalLatLng) {
      _updateSelectedCard(index);
    }
  }

  void _updateSelectedCard(int index) {
    setState(() {
      _previousSelectedIndex = _currentSelectedIndex;
      _currentSelectedIndex = index;
    });

    /// While updating the page viewer through interaction, selected position's
    /// marker should be moved to the center of the maps. However, when the
    /// marker is directly clicked, only the respective card should be moved to
    /// center and the marker itself should not move to the center of the maps.
    if (_canUpdateFocalLatLng) {
      _zoomPanBehavior.focalLatLng = MapLatLng(
          _data[_currentSelectedIndex].latitude,
          _data[_currentSelectedIndex].longitude);
    }

    /// Updating the design of the selected marker. Please check the
    /// `markerBuilder` section in the build method to know how this is done.
    _mapController
        .updateMarkers([_currentSelectedIndex, _previousSelectedIndex]);
    _canUpdateFocalLatLng = true;
  }
}

class WorldWonderModel {
  const WorldWonderModel(
      {this.place,
      this.country,
      this.imagePath,
      this.latitude,
      this.longitude,
      this.description});

  final String place;
  final String country;
  final double latitude;
  final double longitude;
  final String description;
  final String imagePath;
}
