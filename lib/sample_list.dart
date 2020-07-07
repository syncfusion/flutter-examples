import 'package:flutter/foundation.dart';
import 'samples/barcodes/data_matrix/data_matrix.dart';
import 'samples/barcodes/one_dimensional/one_dimensional.dart';
import 'samples/barcodes/two_dimensional/qr_code.dart';
import 'samples/calendar/agenda_view/agenda_view.dart';
import 'samples/calendar/appointment_editor/appointment_editor.dart';
import 'samples/calendar/getting_started/getting_started.dart';
import 'samples/calendar/recurrence/recurrence.dart';
import 'samples/chart/axis_features/axis_crossing/axis_crossing.dart';
import 'samples/chart/axis_features/edge_label_placement/edgelabel_placement.dart';
import 'samples/chart/axis_features/handling_label_collision/handling_label_collision.dart';
import 'samples/chart/axis_features/multiple_axis_chart/multiple_axis_chart.dart';
import 'samples/chart/axis_features/opposed_axes/opposed_axes.dart';
import 'samples/chart/axis_features/plot_band/plot_band.dart';
import 'samples/chart/axis_features/plot_band/plot_band_recurrence.dart';
import 'samples/chart/axis_types/category_types/default_category_axis.dart';
import 'samples/chart/axis_types/category_types/indexed_category_axis.dart';
import 'samples/chart/axis_types/category_types/label_placement.dart';
import 'samples/chart/axis_types/date_time_types/date_time_axis_with_label_format.dart';
import 'samples/chart/axis_types/date_time_types/default_date_time_axis.dart';
import 'samples/chart/axis_types/logarithmic_types/default_logarithmic_axis.dart';
import 'samples/chart/axis_types/logarithmic_types/inversed_logarithmic_axis.dart';
import 'samples/chart/axis_types/numeric_types/default_numeric_axis.dart';
import 'samples/chart/axis_types/numeric_types/inversed_numeric_axis.dart';
import 'samples/chart/axis_types/numeric_types/numeric_axis_with_label_format.dart';
import 'samples/chart/cartesian_charts/area_series/area_with_emptypoints.dart';
import 'samples/chart/cartesian_charts/area_series/area_with_gradient.dart';
import 'samples/chart/cartesian_charts/area_series/default_area_chart.dart';
import 'samples/chart/cartesian_charts/area_series/range_area.dart';
import 'samples/chart/cartesian_charts/area_series/spline_area.dart';
import 'samples/chart/cartesian_charts/area_series/step_area.dart';
import 'samples/chart/cartesian_charts/area_series/vertical_area_chart.dart';
import 'samples/chart/cartesian_charts/bar_series/bar_width_and_spacing.dart';
import 'samples/chart/cartesian_charts/bar_series/bar_with_rounded_corners.dart';
import 'samples/chart/cartesian_charts/bar_series/bar_with_track.dart';
import 'samples/chart/cartesian_charts/bar_series/customized_bar_chart.dart';
import 'samples/chart/cartesian_charts/bar_series/default_bar_chart.dart';
import 'samples/chart/cartesian_charts/bubble_series/bubble_filled_with_gradient.dart';
import 'samples/chart/cartesian_charts/bubble_series/bubble_with_multiple_series.dart';
import 'samples/chart/cartesian_charts/bubble_series/bubble_with_various_colors.dart';
import 'samples/chart/cartesian_charts/bubble_series/default_bubble_chart.dart';
import 'samples/chart/cartesian_charts/column_series/back_to_back_column.dart';
import 'samples/chart/cartesian_charts/column_series/column_width_and_spacing.dart';
import 'samples/chart/cartesian_charts/column_series/column_with_rounded_corners.dart';
import 'samples/chart/cartesian_charts/column_series/column_with_track.dart';
import 'samples/chart/cartesian_charts/column_series/customized_column_chart.dart';
import 'samples/chart/cartesian_charts/column_series/default_column_chart.dart';
import 'samples/chart/cartesian_charts/financial_series/candle_chart.dart';
import 'samples/chart/cartesian_charts/financial_series/hilo_chart.dart';
import 'samples/chart/cartesian_charts/financial_series/hilo_open_close_chart.dart';
import 'samples/chart/cartesian_charts/line_series/customized_line_chart.dart';
import 'samples/chart/cartesian_charts/line_series/default_line_chart.dart';
import 'samples/chart/cartesian_charts/line_series/line_with_dashes.dart';
import 'samples/chart/cartesian_charts/line_series/multi_colored_line.dart';
import 'samples/chart/cartesian_charts/rangecolumn_series/default_rangecolumn_chart.dart';
import 'samples/chart/cartesian_charts/rangecolumn_series/rangecolumn_with_track.dart';
import 'samples/chart/cartesian_charts/rangecolumn_series/vertical_rangecolumn_chart.dart';
import 'samples/chart/cartesian_charts/scatter_series/default_scatter_chart.dart';
import 'samples/chart/cartesian_charts/scatter_series/scatter_with_various_shapes.dart';
import 'samples/chart/cartesian_charts/spline_series/customized_spline_chart.dart';
import 'samples/chart/cartesian_charts/spline_series/default_spline_chart.dart';
import 'samples/chart/cartesian_charts/spline_series/spline_types.dart';
import 'samples/chart/cartesian_charts/spline_series/spline_with_dashes.dart';
import 'samples/chart/cartesian_charts/spline_series/vertical_spline_chart.dart';
import 'samples/chart/cartesian_charts/stacked_series/stacked_area_chart.dart';
import 'samples/chart/cartesian_charts/stacked_series/stacked_bar_chart.dart';
import 'samples/chart/cartesian_charts/stacked_series/stacked_column_chart.dart';
import 'samples/chart/cartesian_charts/stacked_series/stacked_line_chart.dart';
import 'samples/chart/cartesian_charts/stacked_series_100/stacked_area_100_chart.dart';
import 'samples/chart/cartesian_charts/stacked_series_100/stacked_bar_100_chart.dart';
import 'samples/chart/cartesian_charts/stacked_series_100/stacked_column_100_chart.dart';
import 'samples/chart/cartesian_charts/stacked_series_100/stacked_line_100_chart.dart';
import 'samples/chart/cartesian_charts/stepLine_series/default_stepline_chart.dart';
import 'samples/chart/cartesian_charts/stepLine_series/stepline_with_dashes.dart';
import 'samples/chart/cartesian_charts/stepLine_series/vertical_stepline_chart.dart';
import 'samples/chart/circular_charts/doughnut_series/default_doughnut_chart.dart';
import 'samples/chart/circular_charts/doughnut_series/doughnut_with_center_elevation.dart';
import 'samples/chart/circular_charts/doughnut_series/doughnut_with_color_mapping.dart';
import 'samples/chart/circular_charts/doughnut_series/doughnut_with_rounded_corners.dart';
import 'samples/chart/circular_charts/doughnut_series/semi_doughnut_chart.dart';
import 'samples/chart/circular_charts/pie_series/default_pie_chart.dart';
import 'samples/chart/circular_charts/pie_series/pie_with_grouping.dart';
import 'samples/chart/circular_charts/pie_series/pie_with_smart_labels.dart';
import 'samples/chart/circular_charts/pie_series/pie_with_various_radius.dart';
import 'samples/chart/circular_charts/pie_series/semi_pie_chart.dart';
import 'samples/chart/circular_charts/radialbar_series/customized_radialbar_chart.dart';
import 'samples/chart/circular_charts/radialbar_series/default_radialbar_chart.dart';
import 'samples/chart/circular_charts/radialbar_series/radialbar_with_legend.dart';
import 'samples/chart/circular_charts/user_interactions/selection/circular_selection.dart';
import 'samples/chart/circular_charts/user_interactions/tooltip/pie_tooltip_position.dart';
import 'samples/chart/dynamic_updates/add_remove_data/add_remove_points.dart';
import 'samples/chart/dynamic_updates/add_remove_data/add_remove_series.dart';
import 'samples/chart/dynamic_updates/live_update/real_time_line_chart.dart';
import 'samples/chart/dynamic_updates/live_update/real_time_spline_chart.dart';
import 'samples/chart/dynamic_updates/live_update/vertical_live_chart.dart';
import 'samples/chart/dynamic_updates/update_data_source/update_data_source.dart';
import 'samples/chart/funnel_charts/default_funnel_chart.dart';
import 'samples/chart/funnel_charts/funnel_with_legend.dart';
import 'samples/chart/funnel_charts/funnel_with_smart_labels.dart';
import 'samples/chart/legend/cartesian_legend_various_options.dart';
import 'samples/chart/legend/chart_with_customized_legend.dart';
import 'samples/chart/legend/chart_with_legend.dart';
import 'samples/chart/legend/legend_with_various_options.dart';
import 'samples/chart/pyramid_charts/default_pyramid_chart.dart';
import 'samples/chart/pyramid_charts/pyramid_with_legend.dart';
import 'samples/chart/pyramid_charts/pyramid_with_smart_labels.dart';
import 'samples/chart/series_features/animation/dynamic_animation.dart';
import 'samples/chart/series_features/animation/series_animation.dart';
import 'samples/chart/series_features/annotation/chart_with_annotation.dart';
import 'samples/chart/series_features/annotation/chart_with_watermark.dart';
import 'samples/chart/series_features/data_label/default_datalabels.dart';
import 'samples/chart/series_features/empty_point/chart_with_empty_points.dart';
import 'samples/chart/series_features/marker/various_marker_shapes.dart';
import 'samples/chart/series_features/sorting/sorting_options.dart';
import 'samples/chart/technical_indicators/ad_indicator.dart';
import 'samples/chart/technical_indicators/atr_indicator.dart';
import 'samples/chart/technical_indicators/bollinger_indicator.dart';
import 'samples/chart/technical_indicators/ema_indicator.dart';
import 'samples/chart/technical_indicators/macd_indicator.dart';
import 'samples/chart/technical_indicators/momentum_indicator.dart';
import 'samples/chart/technical_indicators/rsi_indicator.dart';
import 'samples/chart/technical_indicators/sma_indicator.dart';
import 'samples/chart/technical_indicators/stochastic_indicator.dart';
import 'samples/chart/technical_indicators/tma_indicator.dart';
import 'samples/chart/trendline/default_trendline.dart';
import 'samples/chart/trendline/trendline_forecast_options.dart';
import 'samples/chart/user_interactions/crosshair/chart_with_crosshair.dart';
import 'samples/chart/user_interactions/selection/selection_modes.dart';
import 'samples/chart/user_interactions/tooltip/default_tooltip.dart';
import 'samples/chart/user_interactions/tooltip/tooltip_position.dart';
import 'samples/chart/user_interactions/trackball/chart_with_trackball.dart';
import 'samples/chart/user_interactions/zooming_panning/pinch_zooming/pinch_zooming.dart';
import 'samples/chart/user_interactions/zooming_panning/selection_zooming/selection_zooming.dart';
import 'samples/chart/user_interactions/zooming_panning/zooming_with_custom_button/zooming_with_custom_buttons.dart';
import 'samples/date_picker/blackout_dates/blackout_date_picker.dart';
import 'samples/date_picker/customization_picker/customized_date_picker.dart';
import 'samples/date_picker/getting_started/datePicker_getting_started.dart';
import 'samples/date_picker/popup_picker/popup_picker.dart';
import 'samples/gauge/animation/radial_bounce.dart';
import 'samples/gauge/animation/radial_easeanimation.dart';
import 'samples/gauge/animation/radial_easeincric.dart';
import 'samples/gauge/animation/radial_easeout.dart';
import 'samples/gauge/animation/radial_elasticout.dart';
import 'samples/gauge/animation/radial_linearanimation.dart';
import 'samples/gauge/animation/radial_slowmiddle.dart';
import 'samples/gauge/annotation/direct_compass.dart';
import 'samples/gauge/annotation/image_annotation.dart';
import 'samples/gauge/annotation/text_annotation.dart';
import 'samples/gauge/axis_feature/custom_labels.dart';
import 'samples/gauge/axis_feature/default_gauge_view.dart';
import 'samples/gauge/axis_feature/multiple_axis.dart';
import 'samples/gauge/axis_feature/non_linearable.dart';
import 'samples/gauge/axis_feature/radiallabel_customization.dart';
import 'samples/gauge/axis_feature/range_colors.dart';
import 'samples/gauge/axis_feature/tick_customization.dart';
import 'samples/gauge/pointer_interaction/radial_pointerdragging.dart';
import 'samples/gauge/pointer_interaction/radial_slider.dart';
import 'samples/gauge/pointers/multiple_needle.dart';
import 'samples/gauge/pointers/multiple_ranges.dart';
import 'samples/gauge/pointers/radial_marker.dart';
import 'samples/gauge/pointers/text_pointer.dart';
import 'samples/gauge/ranges/multiple_ranges.dart';
import 'samples/gauge/ranges/range_datalabels.dart';
import 'samples/gauge/ranges/range_thickness.dart';
import 'samples/gauge/showcase/clock_sample.dart';
import 'samples/gauge/showcase/distance_tracker.dart';
import 'samples/gauge/showcase/gauge_compass.dart';
import 'samples/gauge/showcase/gauge_overview.dart';
import 'samples/pdf/certificate/certificate.dart';
import 'samples/pdf/header_and_footer/header_and_footer.dart';
import 'samples/pdf/invoice/invoice.dart';
import 'samples/slider/range_selector/range_selector_default_appearance.dart';
import 'samples/slider/range_selector/range_selector_with_selection.dart';
import 'samples/slider/range_selector/range_selector_with_zooming.dart';
import 'samples/slider/range_slider/customization/color_customization/color_customization.dart';
import 'samples/slider/range_slider/customization/shape_customization/shape_customization.dart';
import 'samples/slider/range_slider/default_appearance/default_range_slider.dart';
import 'samples/slider/range_slider/default_appearance/range_slider_date_time_label.dart';
import 'samples/slider/range_slider/default_appearance/range_slider_divisor_label_tick.dart';

Map<String, List<dynamic>> getSampleWidget() {
  const bool isTileView = !kIsWeb;
  return <String, List<dynamic>>{
    //cartesian charts
    'default_line_chart': <dynamic>[
      getDefaultLineChart(isTileView),
      LineDefault()
    ],
    'line_with_dashes': <dynamic>[getDashedLineChart(isTileView), LineDashed()],
    'multi_colored_line': <dynamic>[
      getMultiColorLineChart(isTileView),
      LineMultiColor()
    ],
    'customized_line_chart': <dynamic>[
      getCustomizedLineChart(isTileView),
      CustomizedLine()
    ],
    'default_column_chart': <dynamic>[
      getDefaultColumnChart(isTileView),
      ColumnDefault()
    ],
    'column_with_rounded_corners': <dynamic>[
      getRoundedColumnChart(isTileView),
      ColumnRounded()
    ],
    'back_to_back_column': <dynamic>[
      getBackColumnChart(isTileView),
      ColumnBack()
    ],
    'column_with_track': <dynamic>[
      getTrackerColumnChart(isTileView),
      ColumnTracker()
    ],
    'column_width_and_spacing': <dynamic>[
      getSpacingColumnChart(isTileView),
      ColumnSpacing(),
      ColumnSettingsFrontPanel()
    ],
    'customized_column_chart': <dynamic>[
      getCustomizedColumnChart(isTileView),
      ColumnVertical()
    ],
    'default_spline_chart': <dynamic>[
      getDefaultSplineChart(isTileView),
      SplineDefault()
    ],
    'spline_with_dashes': <dynamic>[
      getDashedSplineChart(isTileView),
      SplineDashed()
    ],
    'spline_types': <dynamic>[
      getTypesSplineChart(isTileView),
      SplineTypes(),
      SplineTypesFrontPanel()
    ],
    'vertical_spline_chart': <dynamic>[
      getVerticalSplineChart(isTileView),
      SplineVertical()
    ],
    'customized_spline_chart': <dynamic>[
      getCustomizedSplineChart(isTileView),
      SplineCustomization()
    ],
    'default_area_chart': <dynamic>[
      getDefaultAreaChart(isTileView),
      AreaDefault()
    ],
    'area_with_gradient': <dynamic>[
      getGradientAreaChart(isTileView),
      AreaGradient()
    ],
    'area_with_emptypoints': <dynamic>[
      getEmptyPointAreaChart(isTileView),
      AreaEmpty()
    ],
    'vertical_area_chart': <dynamic>[
      getVerticalAreaChart(isTileView),
      AreaVertical()
    ],
    'range_area': <dynamic>[getRangeAreaChart(isTileView), RangeArea()],
    'step_area': <dynamic>[getStepAreaChart(isTileView), StepArea()],
    'spline_area': <dynamic>[getSplineAreaChart(isTileView), SplineArea()],
    'default_bar_chart': <dynamic>[
      getDefaultBarChart(isTileView),
      BarDefault()
    ],
    'bar_with_rounded_corners': <dynamic>[
      getRoundedBarChart(isTileView),
      BarRounded()
    ],
    'bar_width_and_spacing': <dynamic>[
      getSpacingBarChart(isTileView),
      BarSpacing(),
      BarSettingsFrontPanel()
    ],
    'bar_with_track': <dynamic>[getTrackerBarChart(isTileView), BarTracker()],
    'customized_bar_chart': <dynamic>[
      getCustomizedBarChart(isTileView),
      BarCustomization()
    ],
    'default_bubble_chart': <dynamic>[
      getDefaultBubbleChart(isTileView),
      BubbleDefault()
    ],
    'bubble_with_various_colors': <dynamic>[
      getPointColorBubbleChart(isTileView),
      BubblePointColor()
    ],
    'bubble_filled_with_gradient': <dynamic>[
      getGradientBubbleChart(isTileView),
      BubbleGradient()
    ],
    'bubble_with_multiple_series': <dynamic>[
      getMultipleSeriesBubbleChart(isTileView),
      BubbleMultiSeries()
    ],
    'default_scatter_chart': <dynamic>[
      getDefaultScatterChart(isTileView),
      ScatterDefault()
    ],
    'scatter_with_various_shapes': <dynamic>[
      getShapesScatterChart(isTileView),
      ScatterShapes()
    ],
    'default_stepline_chart': <dynamic>[
      getDefaultStepLineChart(isTileView),
      StepLineDefault()
    ],
    'stepline_with_dashes': <dynamic>[
      getDashedStepLineChart(isTileView),
      StepLineDashed()
    ],
    'vertical_stepline_chart': <dynamic>[
      getVerticalStepLineChart(isTileView),
      StepLineVertical()
    ],
    'default_rangecolumn_chart': <dynamic>[
      getDefaultRangeColumnChart(isTileView),
      RangeColumnDefault()
    ],
    'vertical_rangecolumn_chart': <dynamic>[
      getRangeBarChart(isTileView),
      RangeBarChart()
    ],
    'rangecolumn_with_track': <dynamic>[
      getRangeColumnwithTrack(isTileView),
      RangeColumnWithTrack()
    ],
    'stacked_line_chart': <dynamic>[
      getStackedLineChart(isTileView),
      StackedLineChart()
    ],
    'stacked_area_chart': <dynamic>[
      getStackedAreaChart(isTileView),
      StackedAreaChart()
    ],
    'stacked_column_chart': <dynamic>[
      getStackedColumnChart(isTileView),
      StackedColumnChart()
    ],
    'stacked_bar_chart': <dynamic>[
      getStackedBarChart(isTileView),
      StackedBarChart()
    ],
    'stacked_area_100_chart': <dynamic>[
      getStackedArea100Chart(isTileView),
      StackedArea100Chart()
    ],
    'stacked_bar_100_chart': <dynamic>[
      getStackedBar100Chart(isTileView),
      StackedBar100Chart()
    ],
    'stacked_column_100_chart': <dynamic>[
      getStackedColumn100Chart(isTileView),
      StackedColumn100Chart()
    ],
    'stacked_line_100_chart': <dynamic>[
      getStackedLine100Chart(isTileView),
      StackedLine100Chart()
    ],
    'default_numeric_axis': <dynamic>[
      getDefaultNumericAxisChart(isTileView),
      NumericDefault()
    ],
    'numeric_axis_with_label_format': <dynamic>[
      getLabelNumericAxisChart(isTileView),
      NumericLabel()
    ],
    'inversed_numeric_axis': <dynamic>[
      getInversedNumericAxisChart(isTileView),
      NumericInverse(),
      InversedNumericFrontPanel()
    ],
    'default_category_axis': <dynamic>[
      getDefaultCategoryAxisChart(isTileView),
      CategoryDefault()
    ],
    'category_arranged_by_index': <dynamic>[
      getIndexedCategoryAxisChart(isTileView),
      CategoryIndexed(),
      IndexedFrontPanel(),
    ],
    'category_label_placement': <dynamic>[
      getTicksCategoryAxisChart(isTileView),
      CategoryTicks(),
      LabelPlacementFrontPanel(),
    ],
    'default_datetime_axis': <dynamic>[
      getDefaultDateTimeAxisChart(isTileView),
      DateTimeDefault()
    ],
    'datetime_axis_with_label_format': <dynamic>[
      getLabelDateTimeAxisChart(isTileView),
      DateTimeLabel()
    ],
    'default_logarithmic_axis': <dynamic>[
      getDefaultLogarithmicAxisChart(isTileView),
      LogarithmicAxisDefault()
    ],
    'inversed_logarithmic_axis': <dynamic>[
      getInversedLogarithmicAxisChart(isTileView),
      LogarithmicAxisInversed()
    ],
    'hilo_chart': <dynamic>[getHilo(isTileView), HiloChart()],
    'hilo_open_close_chart': <dynamic>[
      getHiloOpenClose(isTileView),
      HiloOpenCloseChart()
    ],
    'candle_chart': <dynamic>[
      getCandle(isTileView),
      CandleChart(),
      CandleFrontPanel()
    ],
    //Axis Features
    'axis_crossing': <dynamic>[
      getAxisCrossingSample(isTileView),
      AxisCrossing(),
      AxisCrossingFrontPanel()
    ],
    'edgelabel_placement': <dynamic>[
      getEdgeLabelPlacementChart(isTileView),
      EdgeLabel(),
      EdgeLabelPlaceFrontPanel()
    ],
    'handling_label_collision': <dynamic>[
      getLabelIntersectActionChart(isTileView),
      LabelAction(),
      LabelCollisionFrontPanel()
    ],
    'multiple_axis_chart': <dynamic>[
      getMultipleAxisLineChart(isTileView),
      MultipleAxis()
    ],
    'opposed_axes': <dynamic>[
      getOpposedNumericAxisChart(isTileView),
      NumericOpposed()
    ],
    'plot_band_recurrence': <dynamic>[
      getPlotBandRecurrenceChart(isTileView),
      PlotBandRecurrence(),
      PlotBandRecurrenceFrontPanel()
    ],
    'plot_band': <dynamic>[
      getPlotBandChart(isTileView),
      PlotBandDefault(),
      PlotBandFrontPanel()
    ],

    //Series Features
    'dynamic_animation': <dynamic>[
      getDynamicAnimationChart(isTileView),
      CartesianDynamicAnimation(),
      DynamicFrontPanel()
    ],
    'series_animation': <dynamic>[
      getDefaultAnimationChart(isTileView),
      AnimationDefault()
    ],
    'chart_with_annotation': <dynamic>[
      getWatermarkAnnotationChart(isTileView),
      AnnotationWatermark()
    ],
    'chart_with_watermark': <dynamic>[
      getDefaultAnnotationChart(isTileView),
      AnnotationDefault()
    ],
    'default_datalabels': <dynamic>[
      getDataLabelDefaultChart(isTileView),
      DataLabelDefault()
    ],
    'chart_with_empty_points': <dynamic>[
      getEmptyPointChart(isTileView),
      EmptyPoints(),
      EmptyPointsFrontPanel()
    ],
    'various_marker_shapes': <dynamic>[
      getMarkerDefaultChart(isTileView),
      MarkerDefault()
    ],
    'sorting_options': <dynamic>[
      getDefaultSortingChart(isTileView),
      SortingDefault(),
      SortingFrontPanel()
    ],
    'default_trendlines_with_options': <dynamic>[
      getTrendLineDefaultChart(isTileView),
      TrendLineDefault(),
      TrendLineDefaultWithOptionsFrontPanel()
    ],
    'trendline_forecast_with_options': <dynamic>[
      getTrendLineForecastChart(isTileView),
      TrendLineForecast(),
      TrendLineForecastWithOptionsFrontPanel()
    ],

    //Legend
    'chart_with_customized_legend': <dynamic>[
      getLegendCustomizedChart(isTileView),
      LegendCustomized()
    ],
    'chart_with_legend': <dynamic>[
      getLegendDefaultChart(isTileView),
      LegendDefault()
    ],
    'legend_with_various_options': <dynamic>[
      getLegendOptionsChart(isTileView),
      LegendOptions(),
      LegendWithOptionsFrontPanel()
    ],
    'cartesian_legend_various_options': <dynamic>[
      getCartesianLegendOptionsChart(isTileView),
      CartesianLegendOptions(),
      CartesianLegendWithOptionsFrontPanel()
    ],

    //Technical Indicators
    'accumulation_distribution': <dynamic>[
      getDefaultAdIndicator(isTileView),
      AdIndicator()
    ],
    'atr_indicator': <dynamic>[
      getDefaultATRIndicator(isTileView),
      ATRIndicator(),
      AtrIndicatorFrontPanel()
    ],
    'bollinger_indicator': <dynamic>[
      getDefaulBollingerIndicator(isTileView),
      BollingerIndicator(),
      BollingerIndicatorFrontPanel()
    ],
    'ema_indicator': <dynamic>[
      getDefaulEMAIndicator(isTileView),
      EMAIndicator(),
      EmaIndicatorFrontPanel()
    ],
    'momentum_indicator': <dynamic>[
      getDefaulMomentumIndicator(isTileView),
      MomentummIndicator(),
      MomentummIndicatorFrontPanel()
    ],
    'rsi_indicator': <dynamic>[
      getDefaultRSIIndicator(isTileView),
      RSIIndicator(),
      RSIIndicatorFrontPanel()
    ],
    'sma_indicator': <dynamic>[
      getDefaulSMAIndicator(isTileView),
      SMAIndicator(),
      SmaIndicatorFrontPanel()
    ],
    'stochastic_indicator': <dynamic>[
      getDefaultStochasticIndicator(isTileView),
      StochasticcIndicator(),
      StochasticcIndicatorFrontPanel()
    ],
    'tma_indicator': <dynamic>[
      getDefaulTMAIndicator(isTileView),
      TMAIndicator(),
      TmaIndicatorFrontPanel()
    ],
    'macd_indicator': <dynamic>[
      getDefaultMACDIndicator(isTileView),
      MACDIndicator(),
      MacdIndicatorFrontPanel()
    ],

    //User Interaction
    'chart_with_crosshair': <dynamic>[
      getDefaultCrossHairChart(isTileView),
      DefaultCrossHair(),
      CrosshairFrontPanel()
    ],
    'selection_modes': <dynamic>[
      getDefaultSelectionChart(isTileView),
      DefaultSelection(),
      CartesianSelectionFrontPanel()
    ],
    'default_tooltip': <dynamic>[
      getDefaultTooltipChart(isTileView),
      DefaultTooltip()
    ],
    'chart_with_trackball': <dynamic>[
      getDefaultTrackballChart(isTileView),
      DefaultTrackball(),
      TrackballFrontPanel()
    ],
    'pinch_zooming': <dynamic>[
      getDefaultPanningChart(isTileView),
      DefaultPanning(),
      PinchZoomingFrontPanel()
    ],
    'selection_zooming': <dynamic>[
      getDefaultZoomingChart(isTileView),
      DefaultZooming(),
      SelectionZoomingFrontPanel()
    ],
    'zooming_with_custom_buttons': <dynamic>[
      getButtonZoomingChart(isTileView),
      ButtonZooming(),
      ZoomingWithButtonFrontPanel()
    ],
    'tooltip_position': <dynamic>[
      getCartesianTooltipPositionChart(isTileView),
      CartesianTooltipPosition(),
      ChartTooltipPositioningPanel()
    ],
    'circular_selection': <dynamic>[
      getCircularSelectionChart(isTileView),
      CircularSelection(),
      SelectionFrontPanel()
    ],
    'pie_tooltip_position': <dynamic>[
      getPieTooltipPositionChart(isTileView),
      PieTooltipPosition(),
      TooltipPositioningPanel()
    ],

    //Dynamic updates
    'add_remove_points': <dynamic>[
      getAddRemovePointsChart(isTileView),
      AddDataPoints(),
      DynamicPointFrontPanel()
    ],
    'add_remove_series': <dynamic>[
      getAddRemoveSeriesChart(isTileView),
      AddSeries(),
      DynamicSeriesFrontPanel()
    ],
    'real_time_spline_chart': !kIsWeb
        ? <dynamic>[
            getLiveUpdateChart(isTileView),
            LiveUpdate(),
          ]
        : <dynamic>[LiveHorizontalFrontPanel()],
    'vertical_live_chart': !kIsWeb
        ? <dynamic>[
            getVerticalLineUpdateChart(isTileView),
            VerticalLineLiveUpdate(),
          ]
        : <dynamic>[VerticalLiveDataFrontPanel()],
    'update_data_source': <dynamic>[
      getUpdateDataSourceChart(isTileView),
      UpdateDataSource(),
      UpdateDataFrontPanel()
    ],
    'real_time_line_chart': !kIsWeb
        ? <dynamic>[
            getLiveLineChart(isTileView),
            LiveLineChart(),
          ]
        : <dynamic>[RealTimeLineFrontPanel()],

    //Pie
    'default_pie_chart': <dynamic>[
      getDefaultPieChart(isTileView),
      PieDefault()
    ],
    'pie_with_grouping': <dynamic>[
      getGroupingPieChart(isTileView),
      PieGrouping()
    ],
    'pie_with_smart_labels': <dynamic>[
      getSmartLabelPieChart(isTileView),
      PieSmartLabels()
    ],
    'pie_with_various_radius': <dynamic>[
      getRadiusPieChart(isTileView),
      PieRadius()
    ],
    'semi_pie_chart': <dynamic>[
      getSemiPieChart(isTileView),
      PieSemi(),
      SemiPieFrontPanel()
    ],
    //Doughnut
    'default_doughnut_chart': <dynamic>[
      getDefaultDoughnutChart(isTileView),
      DoughnutDefault()
    ],
    'doughnut_with_center_elevation': <dynamic>[
      getElevationDoughnutChart(isTileView),
      DoughnutElevation()
    ],
    'doughnut_with_color_mapping': <dynamic>[
      getDoughnutCustomizationChart(isTileView),
      DoughnutCustomization()
    ],
    'doughnut_with_rounded_corners': <dynamic>[
      getRoundedDoughnutChart(isTileView),
      DoughnutRounded()
    ],
    'semi_doughnut_chart': <dynamic>[
      getSemiDoughnutChart(isTileView),
      DoughnutSemi(),
      SemiDoughnutFrontPanel()
    ],

    //Radialbar
    'customized_radialbar_chart': <dynamic>[
      getCustomizedRadialBarChart(isTileView),
      RadialBarCustomized()
    ],
    'default_radialbar_chart': <dynamic>[
      getDefaultRadialBarChart(isTileView),
      RadialBarDefault()
    ],
    'radialbar_with_legend': <dynamic>[
      getAngleRadialBarChart(isTileView),
      RadialBarAngle()
    ],

    //Funnel
    'default_funnel_chart': <dynamic>[
      getDefaultFunnelChart(isTileView),
      FunnelDefault(),
      DefaultFunnelFrontPanel()
    ],
    'funnel_with_legend': <dynamic>[
      getLegendFunnelChart(isTileView),
      FunnelLegend()
    ],
    'funnel_with_smart_labels': <dynamic>[
      getFunnelSmartLabelChart(isTileView),
      FunnelSmartLabels(),
      FunnelSmartLabelFrontPanel()
    ],

    //Pyramid
    'default_pyramid_chart': <dynamic>[
      getDefaultPyramidChart(isTileView),
      PyramidDefault(),
      DefaultPyramidFrontPanel()
    ],
    'pyramid_with_legend': <dynamic>[
      getLegendPyramidChart(isTileView),
      PyramidLegend()
    ],
    'pyramid_with_smart_labels': <dynamic>[
      getPyramidSmartLabelChart(isTileView),
      PyramidSmartLabels(),
      PyramidSmartLabelsFrontPanel()
    ],

    // Calendar Samples
    'getting_started_calendar': <dynamic>[
      kIsWeb ? GettingStartedCalendar() : getGettingStartedCalendar(),
      GettingStartedCalendar(),
      GettingStartedCalendar(),
    ],
    'recurrence_calendar': <dynamic>[
      kIsWeb ? RecurrenceCalendar() : getRecurrenceCalendar(),
      RecurrenceCalendar(),
      RecurrenceCalendar()
    ],
    'agenda_view_calendar': <dynamic>[
      kIsWeb ? AgendaViewCalendar() : getAgendaViewCalendar(),
      AgendaViewCalendar()
    ],
    'appointment_editor_calendar': <dynamic>[
      kIsWeb ? CalendarAppointmentEditor() : getAppointmentEditorCalendar(),
      CalendarAppointmentEditor(),
      CalendarAppointmentEditor()
    ],

    // Date picker Samples
    'getting_started_date_picker': <dynamic>[
      kIsWeb ? GettingStartedDatePicker() : getGettingStartedDatePicker(),
      GettingStartedDatePicker(),
      GettingStartedDatePicker()
    ],
    'blackout_picker': <dynamic>[
      kIsWeb ? BlackoutDatePicker() : getBlackoutDatePicker(),
      BlackoutDatePicker(),
    ],
    'customized_picker': <dynamic>[
      kIsWeb ? CustomizedDatePicker() : getCustomizedDatePicker(),
      CustomizedDatePicker(),
    ],
    'popup_picker': <dynamic>[
      kIsWeb ? PopUpDatePicker() : getPopUpDatePicker(),
      PopUpDatePicker(),
    ],

    //Gauge
    'radial_bounce': <dynamic>[
      getRadialBounceOutExample(isTileView),
      RadialBounceOutExample()
    ],
    'radial_easeanimation': <dynamic>[
      getRadialEaseExample(isTileView),
      RadialEaseExample()
    ],
    'radial_easeincric': <dynamic>[
      getRadialEaseInCircExample(isTileView),
      RadialEaseInCircExample()
    ],
    'radial_easeout': <dynamic>[
      getRadialEaseOutAnimation(isTileView),
      RadialEaseOutAnimation()
    ],
    'radial_elasticout': <dynamic>[
      getRadialElasticOutAnimation(isTileView),
      RadialElasticOutAnimation()
    ],
    'radial_linearanimation': <dynamic>[
      getRadialLinearAnimation(isTileView),
      RadialLinearAnimation()
    ],
    'radial_slowmiddle': <dynamic>[
      getRadialSlowMiddleAnimation(isTileView),
      RadialSlowMiddleAnimation()
    ],
    'direct_compass': <dynamic>[getRadialCompass(isTileView), RadialCompass()],
    'image_annotation': <dynamic>[
      getRadialImageAnnotation(isTileView),
      RadialImageAnnotation()
    ],
    'text_annotation': <dynamic>[
      getRadialTextAnnotation(isTileView),
      RadialTextAnnotation()
    ],
    'custom_labels': <dynamic>[
      getGaugeCustomLabels(isTileView),
      GaugeCustomLabels()
    ],
    'default_gauge_view': <dynamic>[
      getDefaultRadialGauge(isTileView),
      RadialGaugeDefault()
    ],
    'multiple_axis': <dynamic>[
      getMultipleAxisGauge(isTileView, kIsWeb ? false : true),
      MultipleAxisExample()
    ],
    'non_linearable': <dynamic>[
      getRadialNonLinearLabel(isTileView),
      RadialNonLinearLabel()
    ],
    'radiallabel_customization': <dynamic>[
      getRadialLabelCustomization(isTileView),
      RadialLabelCustomization()
    ],
    'range_colors': <dynamic>[
      getRangeColorForLabels(isTileView),
      RangeColorForLabels()
    ],
    'tick_customization': <dynamic>[
      getRadialTickCustomization(isTileView),
      RadialTickCustomization()
    ],
    'radial_pointerdragging': !kIsWeb
        ? <dynamic>[
            getRadialPointerDragging(isTileView),
            RadialPointerDragging()
          ]
        : <dynamic>[PointerDraggingFrontPanel()],
    'radial_slider': !kIsWeb
        ? <dynamic>[getRadialSlider(isTileView), RadialSlider()]
        : <dynamic>[RadialSliderFrontPanel()],
    'multiple_needle': <dynamic>[
      getMultipleNeedleExample(isTileView),
      MultipleNeedleExample()
    ],
    'range_pointer': <dynamic>[
      getMultipleRangePointerExampleGauge(isTileView),
      MultipleRangePointerExample()
    ],
    'radial_marker': <dynamic>[
      getRadialMarkerExample(isTileView),
      RadialMarkerExample()
    ],
    'text_pointer': <dynamic>[
      getRadialTextPointer(isTileView),
      RadialTextPointer()
    ],
    'multiple_ranges': <dynamic>[
      getMultipleRangesExampleGauge(isTileView),
      MultipleRangesExample()
    ],
    'range_datalabels': <dynamic>[
      getRangeDataLabelExample(isTileView),
      RangeDataLabelExample()
    ],
    'range_thickness': <dynamic>[
      getRangeThicknessExampleGauge(isTileView),
      RangeThicknessExample()
    ],
    'clock_sample': !kIsWeb
        ? <dynamic>[
            getClockExample(isTileView),
            ClockExample(),
          ]
        : <dynamic>[ClockExampleFrontPanel()],
    'distance_tracker': <dynamic>[
      getDistanceTrackerExample(isTileView),
      DistanceTrackerExample()
    ],
    'gauge_overview': <dynamic>[
      getGaugeOverviewExample(isTileView),
      GaugeOverviewExample()
    ],
    'gauge_compass': <dynamic>[
      getGaugeCompassExample(isTileView),
      GaugeCompassExample()
    ],

    // PDF samples
    'invoice': <dynamic>[null, InvoicePdf(), InvoicePdf()],
    'certificate': <dynamic>[
      null,
      CourseCompletionCertificatePdf(),
      CourseCompletionCertificatePdf()
    ],
    'header_and_footer': <dynamic>[
      null,
      HeaderAndFooterPdf(),
      HeaderAndFooterPdf()
    ],

    // Barcode samples
    'one_dimensional_types': <dynamic>[
      kIsWeb ? OneDimensionalBarcodes() : getOneDimensionalBarcodes,
      OneDimensionalBarcodes(),
    ],
    'qr_code_generator': <dynamic>[
      getQRCodeGenerator(),
      QRCodeGenerator(),
      QRCodeGenerator()
    ],
    'data_matrix_generator': <dynamic>[
      getDataMatrixGenerator(),
      DataMatrixGenerator(),
      DataMatrixGenerator()
    ],

    // range slider
    'default_range_slider': <dynamic>[
      null,
      DefaultRangeSliderPage(),
      DefaultRangeSliderPage(),
    ],
    'range_slider_divisor_label_tick': <dynamic>[
      null,
      ScaleRangeSliderPage(),
      ScaleRangeSliderPage(),
    ],
    'range_slider_date_time_label': <dynamic>[
      null,
      DateRangeSliderPage(),
      DateRangeSliderPage(),
    ],
    'color_customization': <dynamic>[
      null,
      ColorCustomizedRangeSliderPage(),
      ColorCustomizedRangeSliderPage(),
    ],
    'shape_customization': <dynamic>[
      null,
      ShapeCustomizedRangeSliderPage(),
      ShapeCustomizedRangeSliderPage(),
    ],
    'range_selector_default_appearance': <dynamic>[
      null,
      DefaultRangeSelectorPage(),
      DefaultRangeSelectorPage()
    ],
    'range_selector_with_selection': <dynamic>[
      null,
      RangeSelectorSelectionPage(),
      RangeSelectorSelectionPage()
    ],
    'range_selector_with_zooming': <dynamic>[
      null,
      RangeSelectorZoomingPage(),
      RangeSelectorZoomingPage()
    ],
  };
}
