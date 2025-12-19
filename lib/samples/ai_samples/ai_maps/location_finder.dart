import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../../../model/sample_view.dart';
import '../../helper/ai_pop_up_api_key.dart';
import 'datasource.dart';

class MapLocationFinder extends SampleView {
  const MapLocationFinder(Key? key) : super(key: key);
  @override
  _MapLocationFinderState createState() => _MapLocationFinderState();
}

class _MapLocationFinderState extends SampleViewState
    with SingleTickerProviderStateMixin {
  final TextEditingController _textFieldController = TextEditingController();
  final List<String> _validSentences = [
    'Hospitals in New York',
    'Hotels in Denver',
  ];
  String errorPrompt = '';
  final List<MapLocation> _data = [];
  late MapTileLayerController _controller;
  late MapZoomPanBehavior _zoomPanBehavior;
  bool _isLoading = false;
  bool _isButtonVisible = false;
  bool _noResultFound = false;
  late AnimationController _animationController;
  late Animation<double> _sizeAnimation;
  late double zoomValue;
  bool validApiKey = false;

  Widget _buildMap(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final bool isLightTheme =
        themeData.colorScheme.brightness == Brightness.light;
    final Color surfaceColor = isLightTheme
        ? const Color.fromARGB(255, 82, 80, 80)
        : const Color.fromRGBO(242, 242, 242, 1);

    return SfMaps(
      layers: <MapLayer>[
        MapTileLayer(
          controller: _controller,
          zoomPanBehavior: _zoomPanBehavior,
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          tooltipSettings: MapTooltipSettings(color: surfaceColor),
          markerTooltipBuilder: (BuildContext context, int index) {
            final Color textColor = isLightTheme
                ? const Color.fromRGBO(255, 255, 255, 1)
                : const Color.fromRGBO(10, 10, 10, 1);
            return Container(
              width: 200,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 5,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_data[index].image != '')
                    Image.asset(_data[index].image)
                  else
                    const SizedBox.shrink(),
                  Text(
                    _data[index].name,
                    style: themeData.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text(
                    _data[index].details,
                    style: themeData.textTheme.bodySmall!.copyWith(
                      color: textColor,
                      fontSize: 10,
                    ),
                    maxLines: 5,
                  ),
                  if (_data[index].address != '')
                    Text(
                      '\u{1F4CD}' + _data[index].address,
                      style: themeData.textTheme.bodySmall!.copyWith(
                        color: textColor,
                        fontSize: 10,
                      ),
                      maxLines: 5,
                    ),
                ],
              ),
            );
          },
          markerBuilder: (BuildContext context, int index) {
            return MapMarker(
              latitude: _data[index].coordinates.latitude,
              longitude: _data[index].coordinates.longitude,
              child: const Icon(Icons.location_on, color: Colors.red, size: 40),
            );
          },
          initialMarkersCount: _data.length,
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: model.isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: model.isMobile
              ? EdgeInsets.only(top: 5, right: width * 0.1)
              : const EdgeInsets.only(left: 5.0),
          child: Row(
            mainAxisAlignment: model.isMobile
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              SizedBox(
                width: model.isMobile ? width * 0.8 : 250,
                height: 45,
                child: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty || validApiKey) {
                      return const Iterable<String>.empty();
                    }
                    final List<String> matches = _validSentences
                        .where(
                          (option) => option.toLowerCase().contains(
                            textEditingValue.text.toLowerCase(),
                          ),
                        )
                        .toList();
                    if (matches.isEmpty &&
                        (model.assistApiKey.isEmpty && !validApiKey)) {
                      return [_textFieldController.text];
                    } else {
                      return matches;
                    }
                  },
                  onSelected: (String selection) {
                    if (selection == 'No match found') {
                      return;
                    }
                    _textFieldController.text = selection;
                    _textFieldController.selection = TextSelection.fromPosition(
                      TextPosition(offset: selection.length),
                    );
                    _handleSearch(selection);
                  },
                  fieldViewBuilder:
                      (context, controller, focusNode, onEditingComplete) {
                        _textFieldController.addListener(() {
                          controller.text = _textFieldController.text;
                          _updateSuggestions();
                        });
                        return TextField(
                          controller: _textFieldController,
                          focusNode: focusNode,
                          onEditingComplete: onEditingComplete,
                          onSubmitted: (String value) {
                            _handleSearch(value);
                          },
                          decoration: InputDecoration(
                            hintText: model.assistApiKey != ''
                                ? 'Search location'
                                : 'Hospital in New York',
                            hintStyle: TextStyle(
                              color: model.themeData.colorScheme.secondary,
                            ),
                            filled: true,
                            fillColor:
                                model.themeData.colorScheme.primaryContainer,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 20,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: model.isMobile
                                  ? BorderRadius.circular(32)
                                  : BorderRadius.circular(0),
                              borderSide: BorderSide(
                                color: model.themeData.colorScheme.primary,
                                width: 0.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: model.isMobile
                                  ? BorderRadius.circular(32)
                                  : BorderRadius.circular(0),
                              borderSide: BorderSide(
                                color: model.themeData.colorScheme.primary,
                                width: 0.5,
                              ),
                            ),
                            suffixIcon: model.isMobile
                                ? AnimatedOpacity(
                                    opacity: _isButtonVisible ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 100),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.search,
                                        color:
                                            model.themeData.colorScheme.primary,
                                      ),
                                      onPressed: () => _isButtonVisible
                                          ? _handleSearch(
                                              _textFieldController.text,
                                            )
                                          : null,
                                    ),
                                  )
                                : null,
                          ),
                        );
                      },
                  optionsViewBuilder:
                      (
                        BuildContext context,
                        void Function(String) onSelected,
                        Iterable<String> options,
                      ) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            color: Colors.transparent,
                            child: SizeTransition(
                              sizeFactor: _sizeAnimation,
                              axisAlignment: -1.0,
                              child: Container(
                                width: model.isMobile ? width * 0.8 : 250,
                                decoration: BoxDecoration(
                                  color: model
                                      .themeData
                                      .colorScheme
                                      .secondaryContainer,
                                ),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxHeight: 200,
                                  ),
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: options.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      final String option = options.elementAt(
                                        index,
                                      );
                                      if (!_validSentences.contains(option)) {
                                        return ListTile(
                                          title: Text(
                                            'Offline search provides results for "Hospitals in New York" and "Hotels in Denver". To get more results, connect to the internet and gemini',
                                            style: TextStyle(
                                              color: model
                                                  .themeData
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                              fontSize: 12,
                                            ),
                                          ),
                                        );
                                      }
                                      return ListTile(
                                        title: Text(
                                          option,
                                          style: TextStyle(
                                            color: model
                                                .themeData
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                        onTap: () => onSelected(option),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                ),
              ),
              if (!model.isMobile)
                AnimatedOpacity(
                  opacity: _isButtonVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 100),
                  child: IgnorePointer(
                    ignoring: !_isButtonVisible,
                    child: Container(
                      height: 45,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: model.themeData.colorScheme.primaryContainer,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                        border: Border.all(
                          color: model.themeData.colorScheme.primary,
                          width: 0.5,
                        ),
                      ),
                      child: IconButton(
                        style: ButtonStyle(
                          overlayColor: WidgetStateProperty.all<Color?>(
                            Colors.transparent,
                          ),
                        ),
                        icon: Icon(
                          Icons.search,
                          color: model.themeData.colorScheme.secondary,
                        ),
                        onPressed: () => _isButtonVisible
                            ? _handleSearch(_textFieldController.text)
                            : null,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Visibility(
          visible: _noResultFound,
          child: Padding(
            padding: EdgeInsets.only(left: 5.0, right: width * 0.11, top: 2),
            child: Container(
              width: model.isMobile ? width * 0.8 : 295,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black, // Solid background
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                model.assistApiKey != ''
                    ? validApiKey
                          ? 'No results found on, try searching for something else or in a different area.'
                          : 'No results found on, given API key is invalid.'
                    : 'Offline search shows results for "Hospitals in New York" and "Hotels in Denver". For more results, connect to the internet and provide Google Generative AI\'s API key.',
                style: const TextStyle(
                  color: Colors.white, // White text for contrast
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _updateSuggestions() {
    SchedulerBinding.instance.addPersistentFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isButtonVisible = _textFieldController.text.isNotEmpty;
          if (errorPrompt != '') {
            errorPrompt == _textFieldController.text
                ? _noResultFound = true
                : _noResultFound = false;
          }
          if (_textFieldController.text.isEmpty ||
              (model.assistApiKey.isNotEmpty && validApiKey)) {
            _animationController.reverse();
          } else {
            _animationController.forward();
          }
        });
      }
    });
  }

  void _handleSearch(String value) {
    errorPrompt = '';
    _noResultFound = false;
    if (value.isEmpty) {
      return;
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      _generateResponse(value);
    });
  }

  Future<void> _generateResponse(String prompt) async {
    setState(() {
      _isLoading = prompt.isNotEmpty;
    });
    final GenerativeModel aiModel = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: model.assistApiKey,
    );
    try {
      final GenerateContentResponse response = await aiModel.generateContent([
        Content.text(
          'Given location name: $prompt'
          '\nSome conditions need to be followed:'
          '\n'
          '\n1. If the input **exactly matches a country, city, capital, or region** (e.g., "India", "London", "California"), return **only one entry** with these fields: '
          '- "Name": The location name '
          '- "Details": A brief description of the location '
          '- "Latitude": The exact geographic latitude of the location (use precise decimal coordinates) '
          '- "Longitude": The exact geographic longitude of the location (use precise decimal coordinates) '
          '- "Address": null (since it\'s a general place)'
          '\n'
          '\n2. If the input contains **place category keywords** like "hotels", "hospitals", "restaurants", or similar, retrieve **10 to 15 relevant places** with these fields: '
          '- "Name": Place name '
          '- "Details": Brief description '
          '- "Latitude": The exact latitude of the place '
          '- "Longitude": The exact longitude of the place '
          '- "Address": Full address'
          '\n'
          '\nThe response must be returned in **this JSON format**: '
          '[{'
          '"Name": "Location Name", '
          '"Details": "Location Details", '
          '"Latitude": Exact Latitude in double value (e.g., 40.712776), '
          '"Longitude": Exact Longitude in double value (e.g., -74.005974), '
          '"Address": "Location Address (null if not applicable)" '
          '}]'
          '\n'
          '\nEnsure that: '
          '- **```json and ``` are removed** if present in the response. '
          '- **Provide JSON format only, no explanations or additional text.** '
          '- Also include the zoom factor for proper visualization of all the location and the range must be between 4 to 18 in this format: **Zoom: [ZOOM_FACTOR]**',
        ),
      ]);

      // Define the regular expression pattern to match "Zoom: number"
      final RegExp regExp = RegExp(r'Zoom:\s*(\d+)');
      final Match? match = regExp.firstMatch(response.text!);
      if (match != null) {
        zoomValue = double.parse(match.group(1)!);
      }

      String formattedResponse = response.text!
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .replaceAll('markercollections', '');
      if (match != null) {
        formattedResponse = formattedResponse.replaceAll(
          match.group(0).toString(),
          '',
        );
      }
      final List<MapLocation> requested = parseJsonString(formattedResponse);
      _updateSuggestionZoom(requested);
      setState(() {
        _isLoading = false;
        if (requested.isEmpty) {
          _noResultFound = true;
          errorPrompt = prompt;
        }
      });
    } catch (err) {
      if (model.assistApiKey == '' || err.runtimeType == InvalidApiKey) {
        final String input = prompt.toLowerCase();
        zoomValue = 12;
        final List<MapLocation> offlineData = input == 'hospitals in new york'
            ? hospitalNewYork
            : input == 'hotels in denver'
            ? hotelsDenver
            : [];
        _updateSuggestionZoom(offlineData);
        setState(() {
          _isLoading = false;
          if (offlineData.isEmpty) {
            errorPrompt = prompt;
            _noResultFound = true;
          }
        });
      } else {
        setState(() {
          _isLoading = false;
          _noResultFound = true;
          errorPrompt = prompt;
        });
      }
    }
  }

  List<MapLocation> parseJsonString(String input) {
    final List<dynamic> jsonData = json.decode(input);

    return jsonData.map((location) {
      return MapLocation(
        name: location['Name'] as String,
        details: location['Details'] as String,
        address: (location['Address'] ?? '') as String,
        coordinates: MapLatLng(
          location['Latitude'] as double,
          location['Longitude'] as double,
        ),
        image: '',
      );
    }).toList();
  }

  void _updateSuggestionZoom(List<MapLocation> requestedData) {
    if (requestedData.isEmpty) {
      return;
    }

    _data.clear();
    _controller.clearMarkers();

    _data.addAll(requestedData);
    for (int i = 0; i <= _data.length - 1; i++) {
      _controller.insertMarker(i);
    }
    _zoomPanBehavior.focalLatLng = _findClosestToMost(_data);
    _zoomPanBehavior.zoomLevel = zoomValue;
  }

  MapLatLng _findClosestToMost(List<MapLocation> locations) {
    if (locations.isEmpty) {
      throw ArgumentError('Location list cannot be empty');
    }

    double totalDistance(MapLocation point) {
      return locations.fold(
        0,
        (sum, loc) => sum + _haversineDistance(point, loc),
      );
    }

    final MapLocation closest = locations.reduce(
      (a, b) => totalDistance(a) < totalDistance(b) ? a : b,
    );
    return MapLatLng(
      closest.coordinates.latitude,
      closest.coordinates.longitude,
    );
  }

  double _haversineDistance(MapLocation a, MapLocation b) {
    const double R = 6371;
    final double dLat = _toRadians(
      b.coordinates.latitude - a.coordinates.latitude,
    );
    final double dLng = _toRadians(
      b.coordinates.longitude - a.coordinates.longitude,
    );

    final double lat1 = _toRadians(a.coordinates.latitude);
    final double lat2 = _toRadians(b.coordinates.latitude);

    final double aHav =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLng / 2) * sin(dLng / 2);
    final double c = 2 * atan2(sqrt(aHav), sqrt(1 - aHav));

    return R * c;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  Widget _buildAIConfigurationSetting() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          width: 40,
          height: 40,
          child: IconButton(
            style: ButtonStyle(
              shadowColor: WidgetStateProperty.all<Color>(
                model.themeData.colorScheme.secondary,
              ),
              elevation: WidgetStateProperty.all<double>(5),
              backgroundColor: WidgetStateProperty.all<Color>(
                model.themeData.colorScheme.primaryContainer,
              ),
              foregroundColor: WidgetStateProperty.all<Color>(
                model.themeData.colorScheme.primary,
              ),
            ),
            tooltip: 'Configure AI',
            icon: const Icon(Icons.settings),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => WelcomeDialog(
                  primaryColor: model.primaryColor,
                  apiKey: model.assistApiKey,
                  onApiKeySaved: (newApiKey) {
                    setState(() {
                      model.assistApiKey = newApiKey;
                      checkApiKey();
                    });
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<bool> validateApiKey(String apiKey) async {
    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: apiKey,
      );
      final response = await model.generateContent([
        Content.text('Test request for API key validation'),
      ]);
      return response.text != null;
    } catch (e) {
      return false;
    }
  }

  Future<void> checkApiKey() async {
    validApiKey = await validateApiKey(model.assistApiKey);
  }

  @override
  void initState() {
    zoomValue = 4;
    _zoomPanBehavior = MapZoomPanBehavior(
      enableMouseWheelZooming: true,
      minZoomLevel: 4,
      focalLatLng: const MapLatLng(37.0902, -95.7129),
      zoomLevel: zoomValue,
      toolbarSettings: const MapToolbarSettings(
        position: MapToolbarPosition.bottomRight,
        direction: Axis.vertical,
      ),
    );
    _textFieldController.addListener(_updateSuggestions);
    _controller = MapTileLayerController();
    super.initState();
    _animationController = AnimationController(
      reverseDuration: const Duration(milliseconds: 300),
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _sizeAnimation = CurvedAnimation(
      parent: _animationController,
      reverseCurve: Curves.easeInOut,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'images/maps_grid.png',
            repeat: ImageRepeat.repeat,
          ),
        ),
        _buildMap(context),
        _buildSearchBar(context),
        _buildAIConfigurationSetting(),
        if (_isLoading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
