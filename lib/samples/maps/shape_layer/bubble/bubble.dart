///Flutter package imports
import 'package:flutter/material.dart';

///Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

///Map import
import 'package:syncfusion_flutter_maps/maps.dart';

///Local import
import '../../../../model/sample_view.dart';

/// Renders the map widget with bubbles
class MapBubblePage extends SampleView {
  /// Creates the map widget for a statistics
  const MapBubblePage(Key key) : super(key: key);

  @override
  _MapBubblePageState createState() => _MapBubblePageState();
}

class _MapBubblePageState extends SampleViewState
    with TickerProviderStateMixin {
  _MapBubblePageState();

  late MapShapeSource _mapSource;
  late MapShapeSource _facebookMapSource;
  late MapShapeSource _twitterMapSource;
  late MapShapeSource _tikTokMapSorce;
  late MapShapeSource _instagramMapSource;
  late MapShapeSource _snapChatMapSource;

  late bool _isLightTheme;

  late Color _shapeColor;
  late Color _shapeStrokeColor;
  late Color _bubbleColor;
  late Color _bubbleStrokeColor;
  late Color _tooltipColor;
  late Color _tooltipStrokeColor;
  late Color _tooltipTextColor;

  late String _currentDelegate;

  BoxDecoration? _facebookBoxDecoration;
  BoxDecoration? _twitterBoxDecoration;
  BoxDecoration? _instagramBoxDecoration;
  BoxDecoration? _snapchatBoxDecoration;
  BoxDecoration? _tiktokBoxDecoration;

  late List<_UserDetails> _facebookUsers;
  late List<_UserDetails> _twitterUsers;
  late List<_UserDetails> _tikTokUsers;
  late List<_UserDetails> _snapChatUsers;
  late List<_UserDetails> _instagramUsers;

  late AnimationController _facebookController;
  late AnimationController _twitterController;
  late AnimationController _tiktokController;
  late AnimationController _instagramController;
  late AnimationController _snapchatController;

  late Animation<double> _facebookAnimation;
  late Animation<double> _twitterAnimation;
  late Animation<double> _tiktokAnimation;
  late Animation<double> _instagramAnimation;
  late Animation<double> _snapchatAnimation;

  @override
  void initState() {
    super.initState();

    _isLightTheme = model.themeData.colorScheme.brightness == Brightness.light;

    _facebookController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
      lowerBound: 0.6,
    );
    _facebookAnimation = CurvedAnimation(
      parent: _facebookController,
      curve: Curves.easeInOut,
    );

    _twitterController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
      lowerBound: 0.6,
    );
    _twitterAnimation = CurvedAnimation(
      parent: _twitterController,
      curve: Curves.easeInOut,
    );

    _instagramController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
      lowerBound: 0.6,
    );
    _instagramAnimation = CurvedAnimation(
      parent: _instagramController,
      curve: Curves.easeInOut,
    );

    _tiktokController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
      lowerBound: 0.6,
    );
    _tiktokAnimation = CurvedAnimation(
      parent: _tiktokController,
      curve: Curves.easeInOut,
    );

    _snapchatController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
      lowerBound: 0.6,
    );
    _snapchatAnimation = CurvedAnimation(
      parent: _snapchatController,
      curve: Curves.easeInOut,
    );

    _facebookController.forward();

    // Data source to the map.
    //
    // [country]: Field name in the .json file to identify the shape.
    // This is the name to be mapped with shapes in .json file.
    // This should be exactly same as the value of the [shapeDataField]
    // in the .json file
    //
    // [usersCount]: On the basis of this value, color mapping color has been
    // applied to the shape.
    _facebookUsers = <_UserDetails>[
      _UserDetails('India', 280),
      _UserDetails('United States of America', 190),
      _UserDetails('Indonesia', 130),
      _UserDetails('Brazil', 120),
      _UserDetails('Mexico', 86),
      _UserDetails('Philippines', 72),
      _UserDetails('Vietnam', 63),
      _UserDetails('Thailand', 48),
      _UserDetails('Egypt', 41),
      _UserDetails('Bangladesh', 37),
      _UserDetails('Pakistan', 37),
      _UserDetails('Turkey', 37),
      _UserDetails('United Kingdom', 37),
      _UserDetails('Colombia', 33),
      _UserDetails('France', 32),
    ];

    _twitterUsers = <_UserDetails>[
      _UserDetails('United States of America', 64),
      _UserDetails('Japan', 48),
      _UserDetails('Russia', 23),
      _UserDetails('United Kingdom', 17),
      _UserDetails('Saudi Arabia', 15),
      _UserDetails('Brazil', 14),
      _UserDetails('Turkey', 13),
      _UserDetails('India', 13),
      _UserDetails('Indonesia', 11),
      _UserDetails('Mexico', 10),
      _UserDetails('France', 8),
      _UserDetails('Spain', 8),
      _UserDetails('Canada', 8),
      _UserDetails('Thailand', 7),
      _UserDetails('Philippines', 7),
      _UserDetails('South Africa', 6),
    ];

    _tikTokUsers = <_UserDetails>[
      _UserDetails('United States of America', 39),
      _UserDetails('Turkey', 28),
      _UserDetails('Russia', 24),
      _UserDetails('Mexico', 19),
      _UserDetails('Brazil', 18),
      _UserDetails('Pakistan', 11),
      _UserDetails('Saudi Arabia', 9),
      _UserDetails('France', 9),
      _UserDetails('Germany', 8),
      _UserDetails('Egypt', 8),
      _UserDetails('Italy', 7),
      _UserDetails('United Kingdom', 6),
      _UserDetails('Spain', 6),
      _UserDetails('Poland', 5),
    ];

    _instagramUsers = <_UserDetails>[
      _UserDetails('United States of America', 120),
      _UserDetails('India', 88),
      _UserDetails('Brazil', 82),
      _UserDetails('Indonesia', 64),
      _UserDetails('Russia', 46),
      _UserDetails('Turkey', 39),
      _UserDetails('Japan', 31),
      _UserDetails('Mexico', 26),
      _UserDetails('United Kingdom', 25),
      _UserDetails('Germany', 22),
      _UserDetails('Italy', 21),
      _UserDetails('France', 19),
      _UserDetails('Argentina', 18),
      _UserDetails('Spain', 17),
      _UserDetails('Canada', 13),
      _UserDetails('South Korea', 13),
    ];

    _snapChatUsers = <_UserDetails>[
      _UserDetails('United States of America', 102),
      _UserDetails('India', 28),
      _UserDetails('France', 21),
      _UserDetails('United Kingdom', 18),
      _UserDetails('Saudi Arabia', 16),
      _UserDetails('Mexico', 16),
      _UserDetails('Japan', 31),
      _UserDetails('Mexico', 26),
      _UserDetails('Brazil', 13),
      _UserDetails('Germany', 11),
      _UserDetails('Canada', 9),
      _UserDetails('Turkey', 8),
      _UserDetails('Russia', 8),
      _UserDetails('Philippines', 8),
      _UserDetails('Iraq', 7),
      _UserDetails('Egypt', 7),
    ];

    _facebookMapSource = MapShapeSource.asset(
      // Path of the GeoJSON file.
      'assets/world_map.json',
      // Field or group name in the .json file to identify the shapes.
      //
      // Which is used to map the respective shape to data source.
      shapeDataField: 'name',
      // The number of data in your data source collection.
      //
      // The callback for the [primaryValueMapper] will be called
      // the number of times equal to the [dataCount].
      // The value returned in the [primaryValueMapper] should be
      // exactly matched with the value of the [shapeDataField]
      // in the .json file. This is how the mapping between the
      // data source and the shapes in the .json file is done.
      dataCount: _facebookUsers.length,
      primaryValueMapper: (int index) => _facebookUsers[index].country,
      // The value returned from this callback will be used as a factor to
      // calculate the radius of the bubble between the
      // [MapBubbleSettings.minRadius] and [MapBubbleSettings.maxRadius].
      bubbleSizeMapper: (int index) => _facebookUsers[index].usersCount,
    );

    _twitterMapSource = MapShapeSource.asset(
      'assets/world_map.json',
      shapeDataField: 'name',
      dataCount: _twitterUsers.length,
      primaryValueMapper: (int index) => _twitterUsers[index].country,
      bubbleSizeMapper: (int index) => _twitterUsers[index].usersCount,
    );

    _tikTokMapSorce = MapShapeSource.asset(
      'assets/world_map.json',
      shapeDataField: 'name',
      dataCount: _tikTokUsers.length,
      primaryValueMapper: (int index) => _tikTokUsers[index].country,
      bubbleSizeMapper: (int index) => _tikTokUsers[index].usersCount,
    );

    _instagramMapSource = MapShapeSource.asset(
      'assets/world_map.json',
      shapeDataField: 'name',
      dataCount: _instagramUsers.length,
      primaryValueMapper: (int index) => _instagramUsers[index].country,
      bubbleSizeMapper: (int index) => _instagramUsers[index].usersCount,
    );

    _snapChatMapSource = MapShapeSource.asset(
      'assets/world_map.json',
      shapeDataField: 'name',
      dataCount: _snapChatUsers.length,
      primaryValueMapper: (int index) => _snapChatUsers[index].country,
      bubbleSizeMapper: (int index) => _snapChatUsers[index].usersCount,
    );

    _mapSource = _facebookMapSource;
    _currentDelegate = 'FaceBook';
    _shapeColor = _isLightTheme
        ? const Color.fromRGBO(57, 110, 218, 0.35)
        : const Color.fromRGBO(72, 132, 255, 0.35);
    _shapeStrokeColor = const Color.fromARGB(
      255,
      52,
      85,
      176,
    ).withValues(alpha: 0);
    _bubbleColor = _isLightTheme
        ? const Color.fromRGBO(15, 59, 177, 0.5)
        : const Color.fromRGBO(135, 167, 255, 0.6);
    _bubbleStrokeColor = Colors.white;
    _tooltipColor = _isLightTheme
        ? const Color.fromRGBO(35, 65, 148, 1)
        : const Color.fromRGBO(52, 85, 176, 1);
    _tooltipStrokeColor = Colors.white;
    _tooltipTextColor = Colors.white;
    _facebookBoxDecoration = _getBoxDecoration(
      const Color.fromARGB(
        255,
        52,
        85,
        176,
      ).withValues(alpha: _isLightTheme ? 0.1 : 0.3),
    );
  }

  @override
  void dispose() {
    _facebookUsers.clear();
    _twitterUsers.clear();
    _tikTokUsers.clear();
    _instagramUsers.clear();
    _tikTokUsers.clear();

    _facebookController.dispose();
    _twitterController.dispose();
    _tiktokController.dispose();
    _instagramController.dispose();
    _snapchatController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool scrollEnabled = constraints.maxHeight > 400;
        double height = scrollEnabled ? constraints.maxHeight : 400;
        if (model.isWebFullView ||
            (model.isMobile &&
                MediaQuery.of(context).orientation == Orientation.landscape)) {
          final double refHeight = height * 0.6;
          height = height > 500 ? (refHeight < 500 ? 500 : refHeight) : height;
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
      },
    );
  }

  Widget _buildMapsWidget(bool scrollEnabled) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: scrollEnabled
              ? EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05,
                  bottom: MediaQuery.of(context).size.height * 0.15,
                  right: 10,
                )
              : const EdgeInsets.only(bottom: 75.0, right: 10),
          child: SfMapsTheme(
            data: SfMapsThemeData(
              shapeHoverColor: Colors.transparent,
              shapeHoverStrokeColor: Colors.transparent,
              bubbleHoverColor: _shapeColor,
              bubbleHoverStrokeColor: _bubbleColor,
              bubbleHoverStrokeWidth: 1.5,
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 30),
                  child: Align(
                    child: Text(
                      'Social Media Users Statistics',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                Expanded(
                  child: SfMaps(
                    layers: <MapLayer>[
                      MapShapeLayer(
                        loadingBuilder: (BuildContext context) {
                          return const SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(strokeWidth: 3),
                          );
                        },
                        source: _mapSource,
                        color: _shapeColor,
                        strokeWidth: 1,
                        strokeColor: _shapeStrokeColor,
                        // Returns the custom tooltip for each bubble.
                        bubbleTooltipBuilder:
                            (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _getCustomizedString(index),
                                  style: Theme.of(context).textTheme.bodySmall!
                                      .copyWith(color: _tooltipTextColor),
                                ),
                              );
                            },
                        bubbleSettings: MapBubbleSettings(
                          strokeColor: _bubbleStrokeColor,
                          strokeWidth: 0.5,
                          color: _bubbleColor,
                          maxRadius: 40,
                        ),
                        tooltipSettings: MapTooltipSettings(
                          color: _tooltipColor,
                          strokeColor: _tooltipStrokeColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: _facebookBoxDecoration,
                  child: ScaleTransition(
                    scale: _facebookAnimation,
                    child: IconButton(
                      style: const ButtonStyle(
                        maximumSize: WidgetStatePropertyAll(Size(70, 70)),
                      ),
                      icon: Image.asset('images/maps_facebook.png'),
                      iconSize: 50,
                      onPressed: () {
                        setState(() {
                          _mapSource = _facebookMapSource;
                          _currentDelegate = 'FaceBook';
                          _shapeColor = _isLightTheme
                              ? const Color.fromRGBO(57, 110, 218, 0.35)
                              : const Color.fromRGBO(72, 132, 255, 0.35);
                          _shapeStrokeColor = const Color.fromARGB(
                            255,
                            52,
                            85,
                            176,
                          ).withValues(alpha: 0);
                          _bubbleColor = _isLightTheme
                              ? const Color.fromRGBO(15, 59, 177, 0.5)
                              : const Color.fromRGBO(135, 167, 255, 0.6);
                          _tooltipColor = _isLightTheme
                              ? const Color.fromRGBO(35, 65, 148, 1)
                              : const Color.fromRGBO(52, 85, 176, 1);
                          _bubbleStrokeColor = Colors.white;
                          _tooltipStrokeColor = Colors.white;
                          _tooltipTextColor = Colors.white;

                          _facebookController.forward();

                          _tiktokController.reverse();
                          _twitterController.reverse();
                          _snapchatController.reverse();
                          _instagramController.reverse();

                          _twitterBoxDecoration = null;
                          _instagramBoxDecoration = null;
                          _snapchatBoxDecoration = null;
                          _tiktokBoxDecoration = null;

                          _facebookBoxDecoration = _getBoxDecoration(
                            const Color.fromARGB(
                              255,
                              52,
                              85,
                              176,
                            ).withValues(alpha: _isLightTheme ? 0.1 : 0.3),
                          );
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  decoration: _twitterBoxDecoration,
                  child: ScaleTransition(
                    scale: _twitterAnimation,
                    child: IconButton(
                      style: const ButtonStyle(
                        maximumSize: WidgetStatePropertyAll(Size(70, 70)),
                      ),
                      icon: Image.asset('images/maps_twitter.png'),
                      iconSize: 50,
                      onPressed: () {
                        setState(() {
                          _mapSource = _twitterMapSource;
                          _currentDelegate = 'Twitter';
                          _shapeColor = _isLightTheme
                              ? const Color.fromRGBO(86, 170, 235, 0.35)
                              : const Color.fromRGBO(32, 154, 255, 0.35);
                          _shapeStrokeColor = const Color.fromARGB(
                            255,
                            0,
                            122,
                            202,
                          ).withValues(alpha: 0);
                          _bubbleColor = _isLightTheme
                              ? const Color.fromRGBO(17, 124, 179, 0.5)
                              : const Color.fromRGBO(56, 184, 251, 0.5);
                          _tooltipColor = _isLightTheme
                              ? const Color.fromRGBO(27, 129, 188, 1)
                              : const Color.fromRGBO(65, 154, 207, 1);
                          _bubbleStrokeColor = Colors.white;
                          _tooltipStrokeColor = Colors.white;
                          _tooltipTextColor = Colors.white;

                          _twitterController.forward();

                          _facebookController.reverse();
                          _tiktokController.reverse();
                          _snapchatController.reverse();
                          _instagramController.reverse();

                          _facebookBoxDecoration = null;
                          _instagramBoxDecoration = null;
                          _snapchatBoxDecoration = null;
                          _tiktokBoxDecoration = null;

                          _twitterBoxDecoration = _getBoxDecoration(
                            const Color.fromARGB(
                              255,
                              0,
                              122,
                              202,
                            ).withValues(alpha: _isLightTheme ? 0.1 : 0.3),
                          );
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  decoration: _instagramBoxDecoration,
                  child: ScaleTransition(
                    scale: _instagramAnimation,
                    child: IconButton(
                      style: const ButtonStyle(
                        maximumSize: WidgetStatePropertyAll(Size(70, 70)),
                      ),
                      icon: Image.asset('images/maps_instagram.png'),
                      iconSize: 50,
                      onPressed: () {
                        setState(() {
                          _mapSource = _instagramMapSource;
                          _currentDelegate = 'Instagram';
                          _shapeColor = _isLightTheme
                              ? const Color.fromRGBO(159, 119, 213, 0.35)
                              : const Color.fromRGBO(166, 104, 246, 0.35);
                          _shapeStrokeColor = const Color.fromARGB(
                            255,
                            238,
                            46,
                            73,
                          ).withValues(alpha: 0);
                          _bubbleColor = _isLightTheme
                              ? const Color.fromRGBO(249, 99, 20, 0.5)
                              : const Color.fromRGBO(253, 173, 38, 0.5);
                          _tooltipColor = _isLightTheme
                              ? const Color.fromRGBO(175, 90, 66, 1)
                              : const Color.fromRGBO(202, 130, 8, 1);
                          _bubbleStrokeColor = Colors.white;
                          _tooltipStrokeColor = Colors.white;
                          _tooltipTextColor = Colors.white;

                          _instagramController.forward();

                          _facebookController.reverse();
                          _tiktokController.reverse();
                          _twitterController.reverse();
                          _snapchatController.reverse();

                          _facebookBoxDecoration = null;
                          _twitterBoxDecoration = null;
                          _snapchatBoxDecoration = null;
                          _tiktokBoxDecoration = null;

                          _instagramBoxDecoration = _getBoxDecoration(
                            const Color.fromARGB(
                              255,
                              238,
                              46,
                              73,
                            ).withValues(alpha: _isLightTheme ? 0.1 : 0.3),
                          );
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  decoration: _snapchatBoxDecoration,
                  child: ScaleTransition(
                    scale: _snapchatAnimation,
                    child: IconButton(
                      style: const ButtonStyle(
                        maximumSize: WidgetStatePropertyAll(Size(70, 70)),
                      ),
                      icon: Image.asset('images/maps_snapchat.png'),
                      iconSize: 50,
                      onPressed: () {
                        setState(() {
                          _mapSource = _snapChatMapSource;
                          _currentDelegate = 'SnapChat';
                          _shapeColor = _isLightTheme
                              ? const Color.fromRGBO(212, 185, 48, 0.35)
                              : const Color.fromRGBO(227, 226, 73, 0.35);
                          _shapeStrokeColor = const Color.fromARGB(
                            255,
                            255,
                            126,
                            0,
                          ).withValues(alpha: 0);
                          _bubbleColor = _isLightTheme
                              ? const Color.fromRGBO(182, 150, 2, 0.5)
                              : const Color.fromRGBO(254, 253, 2, 0.458);
                          _tooltipColor = _isLightTheme
                              ? const Color.fromRGBO(173, 144, 12, 1)
                              : const Color.fromRGBO(225, 225, 30, 1);
                          _bubbleStrokeColor = _isLightTheme
                              ? Colors.black
                              : Colors.white;
                          _tooltipStrokeColor = _isLightTheme
                              ? Colors.black
                              : Colors.white;
                          _tooltipTextColor = _isLightTheme
                              ? Colors.white
                              : Colors.black;

                          _snapchatController.forward();

                          _facebookController.reverse();
                          _tiktokController.reverse();
                          _twitterController.reverse();
                          _instagramController.reverse();

                          _facebookBoxDecoration = null;
                          _twitterBoxDecoration = null;
                          _instagramBoxDecoration = null;
                          _tiktokBoxDecoration = null;

                          _snapchatBoxDecoration = _getBoxDecoration(
                            const Color.fromARGB(
                              255,
                              255,
                              221,
                              0,
                            ).withValues(alpha: _isLightTheme ? 0.2 : 0.3),
                          );
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  decoration: _tiktokBoxDecoration,
                  child: ScaleTransition(
                    scale: _tiktokAnimation,
                    child: IconButton(
                      style: const ButtonStyle(
                        maximumSize: WidgetStatePropertyAll(Size(70, 70)),
                      ),
                      icon: Image.asset('images/maps_tiktok.png'),
                      iconSize: 50,
                      onPressed: () {
                        setState(() {
                          _mapSource = _tikTokMapSorce;
                          _currentDelegate = 'Tiktok';
                          _shapeColor = _isLightTheme
                              ? const Color.fromRGBO(72, 193, 188, 0.35)
                              : const Color.fromRGBO(50, 216, 210, 0.35);
                          _shapeStrokeColor = Colors.black54.withValues(
                            alpha: 0,
                          );
                          _bubbleColor = _isLightTheme
                              ? const Color.fromRGBO(250, 60, 114, 0.5)
                              : const Color.fromRGBO(218, 11, 69, 0.5);
                          _tooltipColor = _isLightTheme
                              ? const Color.fromRGBO(186, 57, 108, 1)
                              : const Color.fromRGBO(189, 74, 119, 1);
                          _bubbleStrokeColor = Colors.white;
                          _tooltipStrokeColor = Colors.white;
                          _tooltipTextColor = Colors.white;

                          _tiktokController.forward();

                          _facebookController.reverse();
                          _twitterController.reverse();
                          _snapchatController.reverse();
                          _instagramController.reverse();

                          _facebookBoxDecoration = null;
                          _twitterBoxDecoration = null;
                          _instagramBoxDecoration = null;
                          _snapchatBoxDecoration = null;

                          _tiktokBoxDecoration = _getBoxDecoration(
                            Colors.black.withValues(
                              alpha: _isLightTheme ? 0.1 : 0.3,
                            ),
                          );
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getCustomizedString(int index) {
    switch (_currentDelegate) {
      case 'FaceBook':
        return _facebookUsers[index].country +
            ' : ' +
            _facebookUsers[index].usersCount.toStringAsFixed(0) +
            'M users';
      case 'Twitter':
        return _twitterUsers[index].country +
            ' : ' +
            _twitterUsers[index].usersCount.toStringAsFixed(0) +
            'M users';
      case 'Instagram':
        return _instagramUsers[index].country +
            ' : ' +
            _instagramUsers[index].usersCount.toStringAsFixed(0) +
            'M users';

      case 'SnapChat':
        return _snapChatUsers[index].country +
            ' : ' +
            _snapChatUsers[index].usersCount.toStringAsFixed(0) +
            'M users';
      case 'Tiktok':
        return _tikTokUsers[index].country +
            ' : ' +
            _tikTokUsers[index].usersCount.toStringAsFixed(0) +
            'M users';
      default:
        return '';
    }
  }

  BoxDecoration _getBoxDecoration(Color color) {
    return BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: <BoxShadow>[BoxShadow(color: color)],
    );
  }
}

class _UserDetails {
  _UserDetails(this.country, this.usersCount);

  final String country;
  final double usersCount;
}
