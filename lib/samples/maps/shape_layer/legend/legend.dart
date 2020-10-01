///Flutter package imports
import 'package:flutter/material.dart';

///Map import
import 'package:syncfusion_flutter_maps/maps.dart';

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Local import
import '../../../../model/sample_view.dart';
import '../../../../widgets/checkbox.dart';

class MapLegendPage extends SampleView {
  const MapLegendPage(Key key) : super(key: key);
  @override
  _MapLegendPageState createState() => _MapLegendPageState();
}

class _MapLegendPageState extends SampleViewState {
  _MapLegendPageState();

  MapShapeLayerDelegate _mapBubbleDelegate;
  MapShapeLayerDelegate _mapShapeDelegate;

  List<InternetDataModel> _internetData;
  List<MapColorMapper> _colorMappers;

  bool _showBubbleData = false;

  @override
  void initState() {
    super.initState();

    _internetData = <InternetDataModel>[
      InternetDataModel('Algeria', price: 5.15),
      InternetDataModel('Angola', price: 7.95),
      InternetDataModel('Benin', price: 20.99),
      InternetDataModel('Botswana', price: 14.12),
      InternetDataModel('Burkina Faso', price: 4.69),
      InternetDataModel('Burundi', price: 2),
      InternetDataModel('Cameroon', price: 1.71),
      InternetDataModel('Cape Verde', price: 4.25),
      InternetDataModel('Central African Rep.',
          price: 6.03, countryName: 'Central African Republic'),
      InternetDataModel('Chad', price: 23.33),
      InternetDataModel('Comoros', price: 12.57),
      InternetDataModel('Congo', price: 5.63),
      InternetDataModel('C�te d\'Ivoire',
          price: 4.1, countryName: 'Ivory Coast'),
      InternetDataModel('Dem. Rep. Congo',
          price: 0.88, countryName: 'Democratic Republic of the Congo'),
      InternetDataModel('Djibouti', price: 37.92),
      InternetDataModel('Egypt', price: 1.49),
      InternetDataModel('Eq. Guinea',
          price: 65.83, countryName: 'Equatorial Guinea'),
      InternetDataModel('Eritrea'),
      InternetDataModel('Ethiopia', price: 2.91),
      InternetDataModel('Gabon', price: 5.84),
      InternetDataModel('Gambia', price: 5.33),
      InternetDataModel('Ghana', price: 1.56),
      InternetDataModel('Guinea', price: 1.97),
      InternetDataModel('Guinea-Bissau', price: 4.96),
      InternetDataModel('Kenya', price: 2.73),
      InternetDataModel('Lesotho', price: 2.43),
      InternetDataModel('Liberia', price: 3.75),
      InternetDataModel('Libya', price: 4.87),
      InternetDataModel('Madagascar', price: 3.39),
      InternetDataModel('Malawi', price: 3.59),
      InternetDataModel('Mali', price: 9.22),
      InternetDataModel('Mauritania', price: 3.12),
      InternetDataModel('Mauritius', price: 3.71),
      InternetDataModel('Mayotte', price: 10.18),
      InternetDataModel('Morocco', price: 1.6),
      InternetDataModel('Mozambique', price: 15.82),
      InternetDataModel('Namibia', price: 11.02),
      InternetDataModel('Niger', price: 2.98),
      InternetDataModel('Nigeria', price: 2.22),
      InternetDataModel('Rwanda', price: 0.56),
      InternetDataModel('Sao Tome and Principe', price: 5.33),
      InternetDataModel('Saint Helena', price: 55.47),
      InternetDataModel('Senegal', price: 3.28),
      InternetDataModel('Seychelles', price: 19.55),
      InternetDataModel('Sierra Leone', price: 5.79),
      InternetDataModel('Somalia', price: 6.19),
      InternetDataModel('Somaliland'),
      InternetDataModel('South Africa', price: 7.19),
      InternetDataModel('S. Sudan', countryName: 'South Sudan'),
      InternetDataModel('Sudan', price: 0.68),
      InternetDataModel('Swaziland', price: 12.14),
      InternetDataModel('Tanzania', price: 5.93),
      InternetDataModel('Togo', price: 11.76),
      InternetDataModel('Tunisia', price: 2.87),
      InternetDataModel('Uganda', price: 4.69),
      InternetDataModel('W. Sahara',
          price: 1.66, countryName: 'Western Sahara'),
      InternetDataModel('Zambia', price: 2.25),
      InternetDataModel('Zimbabwe', price: 75.2),
    ];

    _colorMappers = [
      MapColorMapper(
          from: 0,
          to: 0.99,
          color: Color.fromRGBO(3, 192, 150, 1),
          text: 'Less than \$1'),
      MapColorMapper(
          from: 1.0,
          to: 4.99,
          color: Color.fromRGBO(3, 192, 150, 0.6),
          text: '\$1 - \$4.99'),
      MapColorMapper(
          from: 5,
          to: 9.99,
          color: Color.fromRGBO(3, 192, 150, 0.35),
          text: '\$5 - \$9.99'),
      MapColorMapper(
          from: 10,
          to: 29.99,
          color: Color.fromRGBO(255, 175, 33, 1.0),
          text: '\$10 - \$29.99'),
      MapColorMapper(
          from: 30,
          to: 49.99,
          color: Color.fromRGBO(255, 175, 33, 0.70),
          text: '\$30 - \$49.99'),
      MapColorMapper(
          from: 50,
          to: 100,
          color: Color.fromRGBO(255, 175, 33, 0.40),
          text: '\$50 and More'),
    ];

    _mapBubbleDelegate = MapShapeLayerDelegate(
      shapeFile: 'assets/africa.json',
      shapeDataField: 'name',
      dataCount: _internetData.length,
      primaryValueMapper: (int index) => _internetData[index].actualCountryName,
      bubbleTooltipTextMapper: (int index) {
        return 'State : ' +
            (_internetData[index].countryName ??
                _internetData[index].actualCountryName) +
            '\nPrice : \$' +
            _internetData[index].price.toString();
      },
      bubbleSizeMapper: (int index) => _internetData[index].price,
      bubbleColorValueMapper: (int index) => _internetData[index].price,
      bubbleColorMappers: _colorMappers,
    );

    _mapShapeDelegate = MapShapeLayerDelegate(
      shapeFile: 'assets/africa.json',
      shapeDataField: 'name',
      dataCount: _internetData.length,
      primaryValueMapper: (int index) => _internetData[index].actualCountryName,
      shapeTooltipTextMapper: (int index) {
        if (_internetData[index].price == null) {
          return null;
        }
        return 'State : ' +
            (_internetData[index].countryName ??
                _internetData[index].actualCountryName) +
            '\nPrice : \$' +
            _internetData[index].price.toString();
      },
      shapeColorValueMapper: (int index) => _internetData[index].price,
      shapeColorMappers: _colorMappers,
    );
  }

  @override
  void dispose() {
    _internetData?.clear();
    _colorMappers?.clear();
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
    bool _isLightTheme = model?.themeData?.brightness == Brightness.light;
    return FutureBuilder<dynamic>(
      future: Future<dynamic>.delayed(
          Duration(milliseconds: model.isWeb ? 0 : 500), () => 'Loaded'),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding:
                MediaQuery.of(context).orientation == Orientation.portrait ||
                        model.isWeb
                    ? EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.05,
                        right: 10,
                        left: 5)
                    : const EdgeInsets.only(left: 5, right: 10),
            child: SfMapsTheme(
              data: SfMapsThemeData(
                brightness: model?.themeData?.brightness,
                shapeHoverColor: _showBubbleData
                    ? Colors.transparent
                    : (_isLightTheme
                        ? const Color.fromRGBO(204, 204, 204, 0.8)
                        : const Color.fromRGBO(77, 77, 77, 0.8)),
                shapeHoverStrokeColor: _showBubbleData
                    ? Colors.transparent
                    : (_isLightTheme
                        ? const Color.fromRGBO(158, 158, 158, 1)
                        : const Color.fromRGBO(255, 255, 255, 1)),
                bubbleHoverColor: _showBubbleData
                    ? (_isLightTheme
                        ? const Color.fromRGBO(204, 204, 204, 0.8)
                        : const Color.fromRGBO(115, 115, 115, 0.8))
                    : Colors.transparent,
                bubbleHoverStrokeColor: _showBubbleData
                    ? const Color.fromRGBO(158, 158, 158, 1)
                    : Colors.transparent,
                toggledItemColor: Colors.transparent,
                toggledItemStrokeColor:
                    _showBubbleData ? Colors.transparent : null,
              ),
              child: SfMaps(
                title: const MapTitle(
                  text: 'Average Internet Prices in Africa',
                  padding: EdgeInsets.only(top: 15, bottom: 30),
                ),
                layers: <MapShapeLayer>[
                  MapShapeLayer(
                    /// Changing the data based on whether data will be
                    /// visualized using the shape colors or bubbles.
                    delegate: _showBubbleData
                        ? _mapBubbleDelegate
                        : _mapShapeDelegate,

                    /// You can show legend for the shapes or bubbles. By
                    /// default, the legend will not be shown.
                    legendSource:
                        _showBubbleData ? MapElement.bubble : MapElement.shape,
                    showBubbles: _showBubbleData,
                    enableBubbleTooltip: _showBubbleData,
                    enableShapeTooltip: !_showBubbleData,
                    color: _showBubbleData
                        ? (_isLightTheme
                            ? Color.fromRGBO(238, 238, 238, 1)
                            : Color.fromRGBO(238, 238, 238, 0.1))
                        : null,
                    strokeColor: _showBubbleData
                        ? (_isLightTheme
                            ? Color.fromRGBO(158, 158, 158, 1)
                            : Color.fromRGBO(158, 158, 158, 0.1))
                        : Color.fromRGBO(255, 255, 255, 1),
                    bubbleSettings: MapBubbleSettings(
                      minRadius: 15,
                      maxRadius: 45,
                    ),
                    legendSettings: MapLegendSettings(
                      position: MapLegendPosition.left,
                      offset: Offset(
                          MediaQuery.of(context).size.width *
                              (model.isWeb ? 0.25 : 0.12),
                          50),
                      iconType: MapIconType.square,
                      enableToggleInteraction: true,
                    ),
                    tooltipSettings: MapTooltipSettings(
                      color: _isLightTheme
                          ? Color.fromRGBO(45, 45, 45, 1)
                          : Color.fromRGBO(242, 242, 242, 1),
                      textStyle: Theme.of(context).textTheme.caption.copyWith(
                            color: _isLightTheme
                                ? Color.fromRGBO(255, 255, 255, 1)
                                : Color.fromRGBO(10, 10, 10, 1),
                          ),
                    ),
                  ),
                ],
              ),
            ),
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

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Enable bubble legend  ',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomCheckBox(
                  activeColor: model.backgroundColor,
                  switchValue: _showBubbleData,
                  valueChanged: (dynamic value) {
                    setState(() {
                      _showBubbleData = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class InternetDataModel {
  const InternetDataModel(
    this.actualCountryName, {
    this.price,
    this.countryName,
  });

  final String actualCountryName;
  final double price;
  final String countryName;
}
