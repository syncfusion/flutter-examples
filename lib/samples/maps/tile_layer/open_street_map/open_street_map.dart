/// Flutter package imports
import 'package:flutter/material.dart';

///Map import
// ignore: import_of_legacy_library_into_null_safe
import 'package:syncfusion_flutter_maps/maps.dart';

///Local import
import '../../../../model/sample_view.dart';

/// Renders the map widget with OSM map.
class MapOSMPage extends SampleView {
  /// Creates the map widget with OSM map.
  const MapOSMPage(Key key) : super(key: key);

  @override
  _TileLayerSampleState createState() => _TileLayerSampleState();
}

class _TileLayerSampleState extends SampleViewState {
  late PageController _pageViewController;
  late MapTileLayerController _mapController;

  late MapZoomPanBehavior _zoomPanBehavior;

  late List<_WonderDetails> _worldWonders;

  late int _currentSelectedIndex;
  late int _previousSelectedIndex;
  late int _tappedMarkerIndex;

  late double _cardHeight;

  late bool _canUpdateFocalLatLng;
  late bool _canUpdateZoomLevel;
  late bool _isDesktop;

  @override
  void initState() {
    super.initState();
    _currentSelectedIndex = 5;
    _canUpdateFocalLatLng = true;
    _canUpdateZoomLevel = true;
    _mapController = MapTileLayerController();
    _worldWonders = <_WonderDetails>[];

    _worldWonders.add(
      const _WonderDetails(
        place: 'Chichen Itza',
        state: 'Yucatan',
        country: 'Mexico',
        latitude: 20.6843,
        longitude: -88.5678,
        description:
            "Mayan ruins on Mexico's Yucatan Peninsula. It was one of the largest Maya cities, thriving from around A.D. 600 to 1200.",
        imagePath: 'images/maps_chichen_itza.jpg',
        tooltipImagePath: 'images/maps-chichen-itza.jpg',
      ),
    );

    _worldWonders.add(
      const _WonderDetails(
        place: 'Machu Picchu',
        state: 'Cuzco',
        country: 'Peru',
        latitude: -13.1631,
        longitude: -72.5450,
        description:
            'An Inca citadel built in the mid-1400s. It was not widely known until the early twentieth century.',
        imagePath: 'images/maps_machu_pichu.jpg',
        tooltipImagePath: 'images/maps-machu-picchu.jpg',
      ),
    );

    _worldWonders.add(
      const _WonderDetails(
        place: 'Christ the Redeemer',
        state: 'Rio de Janeiro',
        country: 'Brazil',
        latitude: -22.9519,
        longitude: -43.2105,
        description:
            'An enormous statue of Jesus Christ with open arms, constructed between 1922 and 1931.',
        imagePath: 'images/maps_christ_redeemer.jpg',
        tooltipImagePath: 'images/maps-christ-the-redeemer.jpg',
      ),
    );

    _worldWonders.add(
      const _WonderDetails(
        place: 'Colosseum',
        state: 'Regio III Isis et Serapis',
        country: 'Rome',
        latitude: 41.8902,
        longitude: 12.4922,
        description:
            'Built between A.D. 70 and 80, it could accommodate 50,000 to 80,000 people in tiered seating. It is one of the most popular tourist attractions in Europe.',
        imagePath: 'images/maps_colosseum.jpg',
        tooltipImagePath: 'images/maps-colosseum.jpg',
      ),
    );

    _worldWonders.add(
      const _WonderDetails(
        place: 'Petra',
        state: "Ma'an Governorate",
        country: 'Jordan',
        latitude: 30.3285,
        longitude: 35.4444,
        description:
            'An ancient stone city located in southern Jordan. It became the capital city for the Nabataeans around the fourth century BC.',
        imagePath: 'images/maps_petra.jpg',
        tooltipImagePath: 'images/maps-petra.jpg',
      ),
    );

    _worldWonders.add(
      const _WonderDetails(
        place: 'Taj Mahal',
        state: 'Uttar Pradesh',
        country: 'India',
        latitude: 27.1751,
        longitude: 78.0421,
        description:
            'A white marble mausoleum in Agra, India. It was commissioned in A.D. 1632 by the Mughal emperor Shah Jahan to hold the remains of his favorite wife. It was completed in 1653.',
        imagePath: 'images/maps_taj_mahal.jpg',
        tooltipImagePath: 'images/maps-tajmahal.jpg',
      ),
    );

    _worldWonders.add(
      const _WonderDetails(
        place: 'Great Wall of China',
        state: 'Beijing',
        country: 'China',
        latitude: 40.4319,
        longitude: 116.5704,
        description:
            'A series of walls and fortifications built along the northern border of China to protect Chinese states from invaders. Counting all of its offshoots, its length is more than 13,000 miles.',
        imagePath: 'images/maps_great_wall_of_china.jpg',
        tooltipImagePath: 'images/maps-great-wall-of-china.png',
      ),
    );

    _zoomPanBehavior = MapZoomPanBehavior(
      minZoomLevel: 3,
      maxZoomLevel: 10,
      focalLatLng: MapLatLng(
        _worldWonders[_currentSelectedIndex].latitude,
        _worldWonders[_currentSelectedIndex].longitude,
      ),
      enableDoubleTapZooming: true,
    );
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _mapController.dispose();
    _worldWonders.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    _isDesktop =
        model.isWebFullView ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows ||
        themeData.platform == TargetPlatform.linux;
    if (_canUpdateZoomLevel) {
      _zoomPanBehavior.zoomLevel = _isDesktop ? 5 : 4;
      _canUpdateZoomLevel = false;
    }
    _cardHeight = (MediaQuery.of(context).orientation == Orientation.landscape)
        ? (_isDesktop ? 120 : 90)
        : 110;
    _pageViewController = PageController(
      initialPage: _currentSelectedIndex,
      viewportFraction:
          (MediaQuery.of(context).orientation == Orientation.landscape)
          ? (_isDesktop ? 0.5 : 0.7)
          : 0.8,
    );
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.asset(
            'images/maps_grid.png',
            repeat: ImageRepeat.repeat,
          ),
        ),
        SfMaps(
          layers: <MapLayer>[
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
              initialMarkersCount: _worldWonders.length,
              tooltipSettings: const MapTooltipSettings(
                color: Colors.transparent,
              ),
              markerTooltipBuilder: (BuildContext context, int index) {
                if (_isDesktop) {
                  return ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: 150,
                          height: 80,
                          color: Colors.grey,
                          child: Image.asset(
                            _worldWonders[index].tooltipImagePath,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                            top: 5.0,
                            bottom: 5.0,
                          ),
                          width: 150,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _worldWonders[index].place,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  _worldWonders[index].state +
                                      ', ' +
                                      _worldWonders[index].country,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox();
              },
              markerBuilder: (BuildContext context, int index) {
                final double markerSize = _currentSelectedIndex == index
                    ? 40
                    : 25;
                return MapMarker(
                  latitude: _worldWonders[index].latitude,
                  longitude: _worldWonders[index].longitude,
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
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
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      height: markerSize,
                      width: markerSize,
                      child: FittedBox(
                        child: Icon(
                          Icons.location_on,
                          color: _currentSelectedIndex == index
                              ? Colors.blue
                              : Colors.red,
                          size: markerSize,
                        ),
                      ),
                    ),
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
            padding: const EdgeInsets.only(bottom: 10),

            /// PageView which shows the world wonder details at the bottom.
            child: PageView.builder(
              itemCount: _worldWonders.length,
              onPageChanged: _handlePageChange,
              controller: _pageViewController,
              itemBuilder: (BuildContext context, int index) {
                final _WonderDetails item = _worldWonders[index];
                return Transform.scale(
                  scale: index == _currentSelectedIndex ? 1 : 0.85,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).brightness == Brightness.light
                              ? const Color.fromRGBO(255, 255, 255, 1)
                              : const Color.fromRGBO(66, 66, 66, 1),
                          border: Border.all(
                            color: const Color.fromRGBO(153, 153, 153, 1),
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: <Widget>[
                            // Adding title and description for card.
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 5.0,
                                  right: 5.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      item.place + ', ' + item.country,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    const SizedBox(height: 5),
                                    Expanded(
                                      child: Text(
                                        item.description,
                                        style: TextStyle(
                                          fontSize: _isDesktop ? 14 : 11,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: (index == 2 || index == 6)
                                            ? 2
                                            : 4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Adding Image for card.
                            ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(4),
                              ),
                              child: Image.asset(
                                item.imagePath,
                                height: _cardHeight - 10,
                                width: _cardHeight - 10,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Adding splash to card while tapping.
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: const BorderRadius.all(
                            Radius.elliptical(10, 10),
                          ),
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
        _worldWonders[_currentSelectedIndex].latitude,
        _worldWonders[_currentSelectedIndex].longitude,
      );
    }

    /// Updating the design of the selected marker. Please check the
    /// `markerBuilder` section in the build method to know how this is done.
    _mapController.updateMarkers(<int>[
      _currentSelectedIndex,
      _previousSelectedIndex,
    ]);
    _canUpdateFocalLatLng = true;
  }
}

class _WonderDetails {
  const _WonderDetails({
    required this.place,
    required this.state,
    required this.country,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.tooltipImagePath,
  });

  final String place;
  final String state;
  final String country;
  final double latitude;
  final double longitude;
  final String description;
  final String imagePath;
  final String tooltipImagePath;
}
