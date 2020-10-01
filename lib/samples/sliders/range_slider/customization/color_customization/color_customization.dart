///Package import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///Local import
import '../../../../../model/sample_view.dart';
import '../../../slider_utils.dart';
import 'gradient_track.dart';

///Renders range slider with customized color
class ColorCustomizedRangeSliderPage extends SampleView {
  ///Creates range slider with customized color
  const ColorCustomizedRangeSliderPage(Key key) : super(key: key);

  @override
  _ColorCustomizedRangeSliderPageState createState() =>
      _ColorCustomizedRangeSliderPageState();
}

class _ColorCustomizedRangeSliderPageState extends SampleViewState {
  _ColorCustomizedRangeSliderPageState();
  Widget rangeSlider;

  @override
  void initState() {
    super.initState();
    rangeSlider = _ColorCustomizedRangeSlider();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait ||
            model.isWeb
        ? rangeSlider
        : SingleChildScrollView(
            child: Container(
                height: 400,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                  child: Container(child: rangeSlider),
                )));
  }
}

class _ColorCustomizedRangeSlider extends StatefulWidget {
  @override
  _ColorCustomizedRangeSliderState createState() =>
      _ColorCustomizedRangeSliderState();
}

class _ColorCustomizedRangeSliderState
    extends State<_ColorCustomizedRangeSlider> {
  Widget _getWebLayout() {
    return Container(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width / 3,
        child: _getMobileLayout(),
      ),
    );
  }

  Widget _getMobileLayout() {
    final double padding = MediaQuery.of(context).size.width / 20.0;
    return Container(
        padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            title('Active and inactive track color'),
            const SizedBox(
              height: 10,
            ),
            GradientTrackRangeSlider()
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? _getWebLayout() : _getMobileLayout();
  }
}
