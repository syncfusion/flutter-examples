import 'package:syncfusion_flutter_charts/charts.dart';
import '../../model/chart_settings.dart';

TooltipBehavior stockToolTipBehavior(ChartSettings chartSettings) {
  return TooltipBehavior(
    enable: chartSettings.tooltipEnabled,
    shared: chartSettings.tooltipEnabled,
  );
}

// Method to get TrackballBehavior
TrackballBehavior stockTrackballBehavior() {
  return TrackballBehavior(
    enable: true,
    activationMode: ActivationMode.singleTap,
    tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
  );
}

// Method to get CrosshairBehavior
CrosshairBehavior stockCrosshairBehavior() {
  return CrosshairBehavior(
    enable: true,
    activationMode: ActivationMode.singleTap,
    lineDashArray: const <double>[5, 5],
  );
}

ZoomPanBehavior stockZoomPanBehavior(ChartSettings chartSettings) {
  return ZoomPanBehavior(
    enablePanning: true,
    enablePinching: true,
    enableMouseWheelZooming: true,
  );
}
