/// Package import
import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// WIdget to be rendered.
Widget? renderWidget;

/// Render the default pie series.
class PieImageShader extends SampleView {
  /// Creates the default pie series.
  const PieImageShader(Key key) : super(key: key);

  @override
  _PieImageShaderState createState() => _PieImageShaderState();
}

/// State class of pie series.
class _PieImageShaderState extends SampleViewState {
  _PieImageShaderState();

  ui.Image? image1;
  ui.Image? image2;
  ui.Image? image3;
  ui.Image? image4;

  // ignore: avoid_void_async
  void getImage() async {
    final Completer<ImageInfo> completer = Completer<ImageInfo>();
    const ImageProvider imageProvider = AssetImage('images/apple.png');
    imageProvider
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) async {
      completer.complete(info);
      final ImageInfo imageInfo = await completer.future;

      image1 = imageInfo.image;
    }));

    final Completer<ImageInfo> completer1 = Completer<ImageInfo>();
    const ImageProvider imageProvider1 = AssetImage('images/orange.png');
    imageProvider1
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) async {
      completer1.complete(info);
      final ImageInfo imageInfo1 = await completer1.future;
      image2 = imageInfo1.image;
    }));

    final Completer<ImageInfo> completer2 = Completer<ImageInfo>();
    const ImageProvider imageProvider2 = AssetImage('images/pears.png');
    imageProvider2
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) async {
      completer2.complete(info);
      final ImageInfo imageInfo2 = await completer2.future;

      image3 = imageInfo2.image;
    }));

    final Completer<ImageInfo> completer3 = Completer<ImageInfo>();
    const ImageProvider imageProvider3 = AssetImage('images/other_fruits.png');
    imageProvider3
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) async {
      completer3.complete(info);
      final ImageInfo imageInfo4 = await completer3.future;
      image4 = imageInfo4.image;
      if (mounted) {
        setState(() {});
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    getImage();
    if (image1 != null && image2 != null && image3 != null && image4 != null) {
      renderWidget = SfCircularChart(
        title: ChartTitle(
            text: isCardView ? '' : 'Sales comparison of fruits in a shop'),
        legend: Legend(isVisible: isCardView ? false : true),
        series: <PieSeries<_ChartShaderData, String>>[
          PieSeries<_ChartShaderData, String>(
            dataSource: <_ChartShaderData>[
              _ChartShaderData(
                'Apple',
                25,
                '25%',
                ui.ImageShader(
                  image1!,
                  TileMode.repeated,
                  TileMode.repeated,
                  Matrix4.identity().scaled(0.5).storage,
                ),
              ),
              _ChartShaderData(
                'Orange',
                35,
                '35%',
                ui.ImageShader(
                  image2!,
                  TileMode.repeated,
                  TileMode.repeated,
                  Matrix4.identity().scaled(0.6).storage,
                ),
              ),
              _ChartShaderData(
                'Pears',
                22,
                '22%',
                ui.ImageShader(
                  image3!,
                  TileMode.repeated,
                  TileMode.repeated,
                  Matrix4.identity().scaled(0.6).storage,
                ),
              ),
              _ChartShaderData(
                'Others',
                18,
                '18%',
                ui.ImageShader(
                  image4!,
                  TileMode.repeated,
                  TileMode.repeated,
                  Matrix4.identity().scaled(0.5).storage,
                ),
              ),
            ],
            xValueMapper: (_ChartShaderData data, _) => data.x,
            strokeColor: model.currentThemeData?.brightness == Brightness.light
                ? Colors.black.withOpacity(0.5)
                : Colors.transparent,
            strokeWidth: 1.5,
            explodeAll: true,
            explodeOffset: '3%',
            explode: true,
            yValueMapper: (_ChartShaderData data, _) => data.y,
            dataLabelMapper: (_ChartShaderData data, _) => data.text,
            pointShaderMapper:
                (_ChartShaderData data, _, Color color, Rect rect) =>
                    data.shader,
            dataLabelSettings: DataLabelSettings(
                isVisible: true,
                labelPosition: ChartDataLabelPosition.outside,
                connectorLineSettings: ConnectorLineSettings(
                  color: model.currentThemeData?.brightness == Brightness.light
                      ? Colors.black.withOpacity(0.5)
                      : Colors.white,
                  width: 1.5,
                  length: isCardView ? '10%' : '15%',
                  type: ConnectorType.curve,
                )),
            radius: isCardView ? '85%' : '63%',
          ),
        ],
      );
    } else {
      getImage();
      renderWidget = const Center(child: CircularProgressIndicator());
    }
    return renderWidget!;
  }
}

class _ChartShaderData {
  _ChartShaderData(this.x, this.y, this.text, this.shader);

  final String x;

  final num y;

  final String text;

  final Shader shader;
}
