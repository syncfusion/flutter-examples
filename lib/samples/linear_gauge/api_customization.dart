// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../../../widgets/custom_button.dart';
import 'utils.dart';

/// Renders the linear gauge api customization sample.
class ApiCustomization extends SampleView {
  /// Creates the linear gauge api customization sample.
  const ApiCustomization(Key key) : super(key: key);

  @override
  _ApiCustomizationState createState() => _ApiCustomizationState();
}

/// State class of api customization sample.
class _ApiCustomizationState extends SampleViewState {
  LinearElementPosition _shapePosition = LinearElementPosition.outside;
  LinearElementPosition _barPosition = LinearElementPosition.outside;
  LinearElementPosition _rangePosition = LinearElementPosition.outside;
  final ScrollController _scrollController = ScrollController();

  String _shapePointerPosition = 'outside';
  String _barPointerPosition = 'outside';
  String _rangePointerPosition = 'outside';
  bool _isMirror = false;
  bool _isInverse = false;
  bool _isHorizontalOrientation = false;
  double _barOffset = 5;

  late List<String> _pointerPositions;

  @override
  void initState() {
    _pointerPositions = <String>['outside', 'cross', 'inside'];
    super.initState();
  }

  @override
  void dispose() {
    _pointerPositions.clear();
    super.dispose();
  }

  void shapePosition(String item) {
    _shapePointerPosition = item;
    if (_shapePointerPosition == 'inside') {
      _shapePosition = LinearElementPosition.inside;
    }
    if (_shapePointerPosition == 'outside') {
      _shapePosition = LinearElementPosition.outside;
    }
    if (_shapePointerPosition == 'cross') {
      _shapePosition = LinearElementPosition.cross;
    }
  }

  void barPosition(String item) {
    _barPointerPosition = item;
    if (_barPointerPosition == 'inside') {
      _barPosition = LinearElementPosition.inside;
    }
    if (_barPointerPosition == 'outside') {
      _barPosition = LinearElementPosition.outside;
    }
    if (_barPointerPosition == 'cross') {
      _barPosition = LinearElementPosition.cross;
    }
  }

  void rangePosition(String item) {
    _rangePointerPosition = item;
    if (_rangePointerPosition == 'inside') {
      _rangePosition = LinearElementPosition.inside;
    }
    if (_rangePointerPosition == 'outside') {
      _rangePosition = LinearElementPosition.outside;
    }
    if (_rangePointerPosition == 'cross') {
      _rangePosition = LinearElementPosition.cross;
    }
  }

  Widget _buildLinearGauge(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: model.isWebFullView
              ? MediaQuery.of(context).size.height / 2
              : MediaQuery.of(context).size.height /
                    (MediaQuery.of(context).orientation == Orientation.portrait
                        ? 2
                        : 3),
          child: SfLinearGauge(
            maximum: 50,
            isMirrored: _isMirror,
            isAxisInversed: _isInverse,
            interval: 10,
            orientation: _isHorizontalOrientation
                ? LinearGaugeOrientation.horizontal
                : LinearGaugeOrientation.vertical,
            barPointers: <LinearBarPointer>[
              LinearBarPointer(
                value: 30,
                position: _barPosition,
                offset: _barOffset,
                edgeStyle: LinearEdgeStyle.endCurve,
              ),
            ],
            markerPointers: <LinearMarkerPointer>[
              LinearShapePointer(value: 40, position: _shapePosition),
            ],
            ranges: <LinearGaugeRange>[
              LinearGaugeRange(
                endValue: 20,
                color: Colors.red,
                position: _rangePosition,
              ),
              LinearGaugeRange(
                startValue: 20,
                endValue: 35,
                color: Colors.orange,
                position: _rangePosition,
              ),
              LinearGaugeRange(
                startValue: 35,
                endValue: 50,
                color: Colors.green,
                position: _rangePosition,
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: _barPosition == LinearElementPosition.cross,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.lightbulb_outline, color: Colors.orange, size: 24.0),
              SizedBox(width: 5),
              Flexible(
                child: Text(
                  'Offset positioning is not possible for cross aligned elements.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPropertiesPanel(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility:
          model.isMobile || MediaQuery.of(context).size.width <= 550,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Properties : ',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isInverse = !_isInverse;
                });
              },
              child: Container(
                height: 40,
                color: Colors.transparent,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 30,
                      child: Checkbox(
                        value: _isInverse,
                        splashRadius: 15,
                        activeColor: model.primaryColor,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value != null) {
                              _isInverse = value;
                            }
                          });
                        },
                      ),
                    ),
                    const Text('Inverse axis', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isMirror = !_isMirror;
                });
              },
              child: Container(
                height: 40,
                color: Colors.transparent,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 30,
                      child: Checkbox(
                        splashRadius: 15,
                        value: _isMirror,
                        activeColor: model.primaryColor,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value != null) {
                              _isMirror = value;
                            }
                          });
                        },
                      ),
                    ),
                    const Text('Mirror', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isHorizontalOrientation = !_isHorizontalOrientation;
                });
              },
              child: Container(
                height: 40,
                color: Colors.transparent,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 30,
                      child: Checkbox(
                        value: _isHorizontalOrientation,
                        splashRadius: 15,
                        activeColor: model.primaryColor,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value != null) {
                              _isHorizontalOrientation = value;
                            }
                          });
                        },
                      ),
                    ),
                    const Text(
                      'Horizontal orientation',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 150,
                  margin: const EdgeInsets.only(left: 5),
                  child: const Text(
                    'Shape pointer position',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                const Text(':'),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<String>(
                      dropdownColor: model.drawerBackgroundColor,
                      value: _shapePointerPosition,
                      items: _pointerPositions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: (value != null) ? value : 'outside',
                          child: Text(
                            value,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          if (value != null) {
                            shapePosition(value);
                          }
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 150,
                  margin: const EdgeInsets.only(left: 5),
                  child: const Text(
                    'Bar pointer position',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                const Text(':'),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<String>(
                      dropdownColor: model.drawerBackgroundColor,
                      value: _barPointerPosition,
                      items: _pointerPositions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: (value != null) ? value : 'outside',
                          child: Text(
                            value,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          if (value != null) {
                            barPosition(value);
                          }
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 150,
                  margin: const EdgeInsets.only(left: 5),
                  child: const Text(
                    'Range position',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                const Text(':'),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<String>(
                      dropdownColor: model.drawerBackgroundColor,
                      value: _rangePointerPosition,
                      items: _pointerPositions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: (value != null) ? value : 'outside',
                          child: Text(
                            value,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (dynamic value) {
                        setState(() {
                          rangePosition(value.toString());
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: !(_barPosition == LinearElementPosition.cross),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 150,
                    margin: const EdgeInsets.only(left: 5),
                    child: const Text(
                      'Bar offset',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  const Text(':'),
                  Container(
                    transform: Matrix4.translationValues(-8, 0, 0),
                    child: CustomDirectionalButtons(
                      maxValue: 20,
                      initialValue: _barOffset,
                      onChanged: (double value) {
                        setState(() {
                          _barOffset = value;
                        });
                      },
                      iconColor: model.textColor,
                      style: TextStyle(fontSize: 16.0, color: model.textColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    return (isWebOrDesktop && MediaQuery.of(context).size.width >= 550)
        ? Row(
            children: <Widget>[
              const Spacer(),
              Wrap(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 3,
                    child: _buildLinearGauge(context),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                height: MediaQuery.of(context).size.height,
                width: 1,
                color: brightness == Brightness.dark
                    ? const Color(0xff3D3D3D)
                    : const Color(0xffe2e2e2),
              ),
              Container(
                color: brightness == Brightness.dark
                    ? const Color(0xff2a2a2a)
                    : model.backgroundColor,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.all(10),
                child: _buildPropertiesPanel(context),
              ),
            ],
          )
        : Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _buildLinearGauge(context),
                    const SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 4,
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                      color: brightness == Brightness.dark
                          ? const Color(0xff2a2a2a)
                          : model.backgroundColor,
                      child: _buildPropertiesPanel(context),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
