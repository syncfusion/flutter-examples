import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_examples/model/sample_view.dart';

class MapBubble extends SampleView {
  const MapBubble(Key key) : super(key: key);

  @override
  _MapBubbleState createState() => _MapBubbleState();
}

class _MapBubbleState extends SampleViewState with TickerProviderStateMixin {
  _MapBubbleState();

  MapShapeLayerDelegate _mapDelegate;
  MapShapeLayerDelegate _facebookMapDelegate;
  MapShapeLayerDelegate _twitterMapDelegate;
  MapShapeLayerDelegate _tikTokMapDelegate;
  MapShapeLayerDelegate _instagramMapDelegate;
  MapShapeLayerDelegate _snapChatMapDelegate;

  bool _isLightTheme;

  Color _shapeColor;
  Color _shapeStrokeColor;
  Color _bubbleColor;
  Color _bubbleStrokeColor;
  Color _tooltipColor;
  Color _tooltipStrokeColor;
  Color _tooltipTextColor;

  BoxDecoration _facebookBoxDecoration;
  BoxDecoration _twitterBoxDecoration;
  BoxDecoration _instagramBoxDecoration;
  BoxDecoration _snapchatBoxDecoration;
  BoxDecoration _tiktokBoxDecoration;

  List<UsersModel> _facebookUsers;
  List<UsersModel> _twitterUsers;
  List<UsersModel> _tikTokUsers;
  List<UsersModel> _snapChatUsers;
  List<UsersModel> _instagramUsers;

  AnimationController _facebookController;
  AnimationController _twitterController;
  AnimationController _tiktokController;
  AnimationController _instagramController;
  AnimationController _snapchatController;

  Animation<double> _facebookAnimation;
  Animation<double> _twitterAnimation;
  Animation<double> _tiktokAnimation;
  Animation<double> _instagramAnimation;
  Animation<double> _snapchatAnimation;

  @override
  void initState() {
    super.initState();

    _isLightTheme = model.themeData.brightness == Brightness.light;

    _facebookController = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
        lowerBound: 0.6,
        upperBound: 1.0);
    _facebookAnimation =
        CurvedAnimation(parent: _facebookController, curve: Curves.easeInOut);

    _twitterController = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
        lowerBound: 0.6,
        upperBound: 1.0);
    _twitterAnimation =
        CurvedAnimation(parent: _twitterController, curve: Curves.easeInOut);

    _instagramController = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
        lowerBound: 0.6,
        upperBound: 1.0);
    _instagramAnimation =
        CurvedAnimation(parent: _instagramController, curve: Curves.easeInOut);

    _tiktokController = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
        lowerBound: 0.6,
        upperBound: 1.0);
    _tiktokAnimation =
        CurvedAnimation(parent: _tiktokController, curve: Curves.easeInOut);

    _snapchatController = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
        lowerBound: 0.6,
        upperBound: 1.0);
    _snapchatAnimation =
        CurvedAnimation(parent: _snapchatController, curve: Curves.easeInOut);

    _facebookController.forward();

    // Data source to the map.
    //
    // [country]: Field name in the .json file to identify the shape.
    // This is the name to be mapped with shapes in .json file.
    // This should be exactly same as the value of the [shapeDataField] in the .json file
    //
    // [usersCount]: On the basis of this value, color mapping color has been
    // applied to the shape.
    _facebookUsers = <UsersModel>[
      UsersModel('India', 280),
      UsersModel('United States of America', 190),
      UsersModel('Indonesia', 130),
      UsersModel('Brazil', 120),
      UsersModel('Mexico', 86),
      UsersModel('Philippines', 72),
      UsersModel('Vietnam', 63),
      UsersModel('Thailand', 48),
      UsersModel('Egypt', 41),
      UsersModel('Bangladesh', 37),
      UsersModel('Pakistan', 37),
      UsersModel('Turkey', 37),
      UsersModel('United Kingdom', 37),
      UsersModel('Colombia', 33),
      UsersModel('France', 32),
    ];

    _twitterUsers = <UsersModel>[
      UsersModel('United States of America', 64),
      UsersModel('Japan', 48),
      UsersModel('Russia', 23),
      UsersModel('United Kingdom', 17),
      UsersModel('Saudi Arabia', 15),
      UsersModel('Brazil', 14),
      UsersModel('Turkey', 13),
      UsersModel('India', 13),
      UsersModel('Indonesia', 11),
      UsersModel('Mexico', 10),
      UsersModel('France', 8),
      UsersModel('Spain', 8),
      UsersModel('Canada', 8),
      UsersModel('Thailand', 7),
      UsersModel('Philippines', 7),
      UsersModel('South Africa', 6),
    ];

    _tikTokUsers = <UsersModel>[
      UsersModel('India', 119),
      UsersModel('United States of America', 39),
      UsersModel('Turkey', 28),
      UsersModel('Russia', 24),
      UsersModel('Mexico', 19),
      UsersModel('Brazil', 18),
      UsersModel('Pakistan', 11),
      UsersModel('Saudi Arabia', 9),
      UsersModel('France', 9),
      UsersModel('Germany', 8),
      UsersModel('Egypt', 8),
      UsersModel('Italy', 7),
      UsersModel('United Kingdom', 6),
      UsersModel('Spain', 6),
      UsersModel('Poland', 5),
    ];

    _instagramUsers = <UsersModel>[
      UsersModel('United States of America', 120),
      UsersModel('India', 88),
      UsersModel('Brazil', 82),
      UsersModel('Indonesia', 64),
      UsersModel('Russia', 46),
      UsersModel('Turkey', 39),
      UsersModel('Japan', 31),
      UsersModel('Mexico', 26),
      UsersModel('United Kingdom', 25),
      UsersModel('Germany', 22),
      UsersModel('Italy', 21),
      UsersModel('France', 19),
      UsersModel('Argentina', 18),
      UsersModel('Spain', 17),
      UsersModel('Canada', 13),
      UsersModel('South Korea', 13),
    ];

    _snapChatUsers = <UsersModel>[
      UsersModel('United States of America', 102),
      UsersModel('India', 28),
      UsersModel('France', 21),
      UsersModel('United Kingdom', 18),
      UsersModel('Saudi Arabia', 16),
      UsersModel('Mexico', 16),
      UsersModel('Japan', 31),
      UsersModel('Mexico', 26),
      UsersModel('Brazil', 13),
      UsersModel('Germany', 11),
      UsersModel('Canada', 9),
      UsersModel('Turkey', 8),
      UsersModel('Russia', 8),
      UsersModel('Philippines', 8),
      UsersModel('Iraq', 7),
      UsersModel('Egypt', 7),
    ];

    _facebookMapDelegate = MapShapeLayerDelegate(
        // Path of the GeoJSON file.
        shapeFile: 'assets/world_map.json',
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
        // Returns the custom tooltip text for each bubble.
        //
        // By default, the value returned in the [primaryValueMapper]
        // will be used for tooltip text.
        bubbleTooltipTextMapper: (int index) =>
            _facebookUsers[index].country +
            ' : ' +
            _facebookUsers[index].usersCount.toStringAsFixed(0) +
            'M users');

    _twitterMapDelegate = MapShapeLayerDelegate(
        shapeFile: 'assets/world_map.json',
        shapeDataField: 'name',
        dataCount: _twitterUsers.length,
        primaryValueMapper: (int index) => _twitterUsers[index].country,
        bubbleSizeMapper: (int index) => _twitterUsers[index].usersCount,
        bubbleTooltipTextMapper: (int index) =>
            _twitterUsers[index].country +
            ' : ' +
            _twitterUsers[index].usersCount.toStringAsFixed(0) +
            'M users');

    _tikTokMapDelegate = MapShapeLayerDelegate(
        shapeFile: 'assets/world_map.json',
        shapeDataField: 'name',
        dataCount: _tikTokUsers.length,
        primaryValueMapper: (int index) => _tikTokUsers[index].country,
        bubbleSizeMapper: (int index) => _tikTokUsers[index].usersCount,
        bubbleTooltipTextMapper: (int index) =>
            _tikTokUsers[index].country +
            ' : ' +
            _tikTokUsers[index].usersCount.toStringAsFixed(0) +
            'M users');

    _instagramMapDelegate = MapShapeLayerDelegate(
        shapeFile: 'assets/world_map.json',
        shapeDataField: 'name',
        dataCount: _instagramUsers.length,
        primaryValueMapper: (int index) => _instagramUsers[index].country,
        bubbleSizeMapper: (int index) => _instagramUsers[index].usersCount,
        bubbleTooltipTextMapper: (int index) =>
            _instagramUsers[index].country +
            ' : ' +
            _instagramUsers[index].usersCount.toStringAsFixed(0) +
            'M users');

    _snapChatMapDelegate = MapShapeLayerDelegate(
        shapeFile: 'assets/world_map.json',
        shapeDataField: 'name',
        dataCount: _snapChatUsers.length,
        primaryValueMapper: (int index) => _snapChatUsers[index].country,
        bubbleSizeMapper: (int index) => _snapChatUsers[index].usersCount,
        bubbleTooltipTextMapper: (int index) =>
            _snapChatUsers[index].country +
            ' : ' +
            _snapChatUsers[index].usersCount.toStringAsFixed(0) +
            'M users');

    _mapDelegate = _facebookMapDelegate;
    _shapeColor = _isLightTheme
        ? const Color.fromRGBO(57, 110, 218, 0.35)
        : const Color.fromRGBO(72, 132, 255, 0.35);
    _shapeStrokeColor = const Color.fromARGB(255, 52, 85, 176).withOpacity(0);
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
        const Color.fromARGB(255, 52, 85, 176)
            .withOpacity(_isLightTheme ? 0.1 : 0.3));
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
    return MediaQuery.of(context).orientation == Orientation.portrait ||
            model.isWeb
        ? _getMapsWidget()
        : SingleChildScrollView(
            child: Container(height: 400, child: _getMapsWidget()));
  }

  Widget _getMapsWidget() {
    return FutureBuilder<dynamic>(
      future: Future<dynamic>.delayed(
          const Duration(milliseconds: kIsWeb ? 0 : 500), () => 'Loaded'),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Stack(
            children: <Widget>[
              Padding(
                padding: MediaQuery.of(context).orientation ==
                            Orientation.portrait ||
                        model.isWeb
                    ? EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.05,
                        bottom: MediaQuery.of(context).size.height * 0.15,
                        right: 10)
                    : const EdgeInsets.only(bottom: 75.0, right: 10),
                child: SfMaps(
                  title: const MapTitle(
                    text: 'Social Media Users Statistics',
                    padding: EdgeInsets.only(top: 15, bottom: 30),
                  ),
                  layers: <MapLayer>[
                    MapShapeLayer(
                      delegate: _mapDelegate,
                      enableBubbleTooltip: true,
                      showBubbles: true,
                      color: _shapeColor,
                      strokeWidth: 1,
                      strokeColor: _shapeStrokeColor,
                      bubbleSettings: MapBubbleSettings(
                          strokeColor: _bubbleStrokeColor,
                          strokeWidth: 0.5,
                          color: _bubbleColor,
                          minRadius: 10,
                          maxRadius: 40),
                      tooltipSettings: MapTooltipSettings(
                          textStyle: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: _tooltipTextColor),
                          color: _tooltipColor,
                          strokeColor: _tooltipStrokeColor),
                    ),
                  ],
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
                            icon: Image.asset('images/maps_facebook.png'),
                            iconSize: 50,
                            onPressed: () {
                              setState(() {
                                _mapDelegate = _facebookMapDelegate;
                                _shapeColor = _isLightTheme
                                    ? const Color.fromRGBO(57, 110, 218, 0.35)
                                    : const Color.fromRGBO(72, 132, 255, 0.35);
                                _shapeStrokeColor =
                                    const Color.fromARGB(255, 52, 85, 176)
                                        .withOpacity(0);
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
                                    const Color.fromARGB(255, 52, 85, 176)
                                        .withOpacity(
                                            _isLightTheme ? 0.1 : 0.3));
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
                            icon: Image.asset('images/maps_twitter.png'),
                            iconSize: 50,
                            onPressed: () {
                              setState(() {
                                _mapDelegate = _twitterMapDelegate;
                                _shapeColor = _isLightTheme
                                    ? const Color.fromRGBO(86, 170, 235, 0.35)
                                    : const Color.fromRGBO(32, 154, 255, 0.35);
                                _shapeStrokeColor =
                                    const Color.fromARGB(255, 0, 122, 202)
                                        .withOpacity(0);
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
                                    const Color.fromARGB(255, 0, 122, 202)
                                        .withOpacity(
                                            _isLightTheme ? 0.1 : 0.3));
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
                            icon: Image.asset('images/maps_instagram.png'),
                            iconSize: 50,
                            onPressed: () {
                              setState(() {
                                _mapDelegate = _instagramMapDelegate;
                                _shapeColor = _isLightTheme
                                    ? const Color.fromRGBO(159, 119, 213, 0.35)
                                    : const Color.fromRGBO(166, 104, 246, 0.35);
                                _shapeStrokeColor =
                                    const Color.fromARGB(255, 238, 46, 73)
                                        .withOpacity(0);
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
                                    const Color.fromARGB(255, 238, 46, 73)
                                        .withOpacity(
                                            _isLightTheme ? 0.1 : 0.3));
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
                            icon: Image.asset('images/maps_snapchat.png'),
                            iconSize: 50,
                            onPressed: () {
                              setState(() {
                                _mapDelegate = _snapChatMapDelegate;
                                _shapeColor = _isLightTheme
                                    ? const Color.fromRGBO(212, 185, 48, 0.35)
                                    : const Color.fromRGBO(227, 226, 73, 0.35);
                                _shapeStrokeColor =
                                    const Color.fromARGB(255, 255, 126, 0)
                                        .withOpacity(0);
                                _bubbleColor = _isLightTheme
                                    ? const Color.fromRGBO(182, 150, 2, 0.5)
                                    : const Color.fromRGBO(254, 253, 2, 0.458);
                                _tooltipColor = _isLightTheme
                                    ? const Color.fromRGBO(173, 144, 12, 1)
                                    : const Color.fromRGBO(225, 225, 30, 1);
                                _bubbleStrokeColor =
                                    _isLightTheme ? Colors.black : Colors.white;
                                _tooltipStrokeColor =
                                    _isLightTheme ? Colors.black : Colors.white;
                                _tooltipTextColor =
                                    _isLightTheme ? Colors.white : Colors.black;

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
                                    const Color.fromARGB(255, 255, 221, 0)
                                        .withOpacity(
                                            _isLightTheme ? 0.2 : 0.3));
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
                            icon: Image.asset('images/maps_tiktok.png'),
                            iconSize: 50,
                            onPressed: () {
                              setState(() {
                                _mapDelegate = _tikTokMapDelegate;
                                _shapeColor = _isLightTheme
                                    ? const Color.fromRGBO(72, 193, 188, 0.35)
                                    : const Color.fromRGBO(50, 216, 210, 0.35);
                                _shapeStrokeColor =
                                    Colors.black54.withOpacity(0);
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

                                _tiktokBoxDecoration = _getBoxDecoration(Colors
                                    .black
                                    .withOpacity(_isLightTheme ? 0.1 : 0.3));
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
        } else {
          return Center(
            child: Container(
              height: 25,
              width: 25,
              child: const CircularProgressIndicator(
                strokeWidth: 3,
              ),
            ),
          );
        }
      },
    );
  }

  BoxDecoration _getBoxDecoration(Color color) {
    return BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: color,
        )
      ],
    );
  }
}

class UsersModel {
  UsersModel(this.country, this.usersCount);
  final String country;
  final double usersCount;
}
