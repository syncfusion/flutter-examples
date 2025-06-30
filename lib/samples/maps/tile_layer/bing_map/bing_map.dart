///Flutter package imports
import 'package:flutter/material.dart';

///Map import
// ignore: import_of_legacy_library_into_null_safe
import 'package:syncfusion_flutter_maps/maps.dart';

///URL launcher import
import 'package:url_launcher/url_launcher.dart' show launchUrl;

///Local import
import '../../../../model/sample_view.dart';

/// Renders the map widget with bing map.
class MapBingPage extends SampleView {
  /// Creates the map widget with bing map.
  const MapBingPage(Key key) : super(key: key);
  @override
  _BingMapState createState() => _BingMapState();
}

class _BingMapState extends SampleViewState {
  late TextEditingController _textFieldController;

  late MapZoomPanBehavior _zoomPanBehavior;

  late String _bingURL;
  late String _bingKey;

  int _selectedMapViewIndex = 0;

  bool _hasBingMapKey = false;
  bool _showEmptyKeyError = false;
  bool _showKeyError = false;

  @override
  void initState() {
    super.initState();
    _textFieldController = TextEditingController();
    _zoomPanBehavior = MapZoomPanBehavior(
      minZoomLevel: 3,
      maxZoomLevel: 10,
      zoomLevel: model.isWebFullView ? 5 : 4,
      focalLatLng: const MapLatLng(27.1751, 78.0421),
      enableDoubleTapZooming: true,
    );
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// If the key is empty, we will validate and show the error. If the key is
    /// entered and if it is invalid or the network connection is not available,
    /// we will show the respective error message.
    ///
    /// For Bing Maps, you have to use `getBingUrlTemplate` as shown below
    /// to get the URL template in the required format. You will need to
    /// pass the URL to this method along with the map type and subscription
    /// key.
    return _hasBingMapKey
        ? FutureBuilder<String?>(
            future: getBingUrlTemplate(_bingURL),
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  final String urlTemplate = snapshot.data!;
                  return _buildBingMap(urlTemplate);
                } else {
                  _hasBingMapKey = false;
                  _showEmptyKeyError = false;
                  _showKeyError = true;
                  return _buildKeyValidationScreen();
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          )
        : _buildKeyValidationScreen();
  }

  /// Home screen with the `TextField` to get the subscription key.
  Widget _buildKeyValidationScreen() {
    return Center(
      child: SizedBox(
        width:
            MediaQuery.of(context).size.width *
            (model.isWebFullView ? 0.4 : 0.8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _textFieldController,
              onSubmitted: (String text) => _handleKeyValidation(),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(
                  20.0,
                  15.0,
                  20.0,
                  15.0,
                ),
                hintText: 'Enter the Bing Maps key',
                errorText: _getErrorMessage(),
                helperText: '',
                errorMaxLines: 3,
                suffixIcon: IconButton(
                  splashRadius: 20,
                  icon: const Icon(Icons.send),
                  onPressed: () => _handleKeyValidation(),
                  color: (_showEmptyKeyError || _showKeyError)
                      ? Colors.red
                      : const Color.fromRGBO(153, 153, 153, 1),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(153, 153, 153, 1),
                    width: 0.5,
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(153, 153, 153, 1),
                    width: 0.5,
                  ),
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(153, 153, 153, 1),
                    width: 0.5,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 10),
                  const Text(
                    'Note:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 3),
                  Wrap(
                    children: <Widget>[
                      const Text(
                        '1. Please use the ',
                        style: TextStyle(fontSize: 11),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            launchUrl(
                              Uri.parse(
                                'https://docs.microsoft.com/en-us/bingmaps/getting-started/bing-maps-dev-center-help/getting-a-bing-maps-key',
                              ),
                            );
                          },
                          child: const Text(
                            'development or testing key',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 11,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      const Text('.', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    '2. The key entered here is used only for testing this feature from your side. We will not upload it to any server or use it for any other purposes.',
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBingMap(String urlTemplate) {
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
              urlTemplate: urlTemplate,
              zoomPanBehavior: _zoomPanBehavior,
            ),
          ],
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 10.0,
            children: <Widget>[
              _buildChip(0, 'Road View'),
              _buildChip(1, 'Aerial View'),
              _buildChip(2, 'Aerial View With Labels'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChip(int index, String mapType) {
    return ChoiceChip(
      label: Text(mapType),
      selected: _selectedMapViewIndex == index,
      labelStyle: TextStyle(color: model.textColor, fontSize: 12),
      onSelected: (bool isSelected) {
        if (_selectedMapViewIndex != index) {
          setState(() {
            _selectedMapViewIndex = index;
            _zoomPanBehavior.zoomLevel = _zoomPanBehavior.zoomLevel
                .floorToDouble();
            _setBingMapView(_selectedMapViewIndex);
          });
        }
      },
    );
  }

  /// Changing the Bing Maps type on clicking the chip.
  void _setBingMapView(int index) {
    switch (index) {
      /// Road view
      case 0:
        _bingURL =
            'https://dev.virtualearth.net/REST/V1/Imagery/Metadata/RoadOnDemand?output=json&uriScheme=https&include=ImageryProviders&key=' +
            _bingKey;
        break;

      /// Aerial view
      case 1:
        _bingURL =
            'https://dev.virtualearth.net/REST/V1/Imagery/Metadata/Aerial?output=json&uriScheme=https&include=ImageryProviders&key=' +
            _bingKey;
        break;
      case 2:

        /// Aerial view with labels
        _bingURL =
            'https://dev.virtualearth.net/REST/V1/Imagery/Metadata/AerialWithLabels?output=json&uriScheme=https&include=ImageryProviders&key=' +
            _bingKey;
        break;
    }
  }

  void _handleKeyValidation() {
    if (_textFieldController.text.isNotEmpty) {
      setState(() {
        _showEmptyKeyError = false;
        _showKeyError = false;
        _bingKey = _textFieldController.text;
        _hasBingMapKey = true;
        _setBingMapView(_selectedMapViewIndex);
      });
    } else {
      setState(() {
        _showEmptyKeyError = true;
        _showKeyError = false;
      });
    }
  }

  String? _getErrorMessage() {
    if (_showEmptyKeyError) {
      return 'Key should not be empty.';
    } else if (_showKeyError) {
      return 'Please make sure you have entered a valid key and have an active internet connection.';
    }

    return null;
  }
}
