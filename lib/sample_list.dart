import 'package:flutter/foundation.dart';
import 'samples/barcodes/data_matrix/data_matrix.dart';
import 'samples/barcodes/one_dimensional/one_dimensional.dart';
import 'samples/barcodes/two_dimensional/qr_code.dart';
import 'samples/calendar/agenda_view/agenda_view.dart';
import 'samples/calendar/appointment_editor/appointment_editor.dart';
import 'samples/calendar/getting_started/getting_started.dart';
import 'samples/calendar/recurrence/recurrence.dart';
import 'samples/calendar/schedule_view/schedule_view.dart';
import 'samples/calendar/shift_scheduler/shift_scheduler.dart';
import 'samples/calendar/special_regions/special_regions.dart';
import 'samples/chart/axis_features/axis_animation/axis_animation.dart';
import 'samples/chart/axis_features/axis_crossing/axis_crossing.dart';
import 'samples/chart/axis_features/edge_label_placement/edgelabel_placement.dart';
import 'samples/chart/axis_features/handling_label_collision/handling_label_collision.dart';
import 'samples/chart/axis_features/multiple_axis_chart/multiple_axis_chart.dart';
import 'samples/chart/axis_features/opposed_axes/opposed_axes.dart';
import 'samples/chart/axis_features/plot_band/plot_band.dart';
import 'samples/chart/axis_features/plot_band/plot_band_recurrence.dart';
import 'samples/chart/axis_features/positioning_axis_label/positioning_axis_label.dart';
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
import 'samples/chart/cartesian_charts/area_series/animation_area_chart.dart';
import 'samples/chart/cartesian_charts/area_series/area_with_emptypoints.dart';
import 'samples/chart/cartesian_charts/area_series/default_area_chart.dart';
import 'samples/chart/cartesian_charts/area_series/vertical_area_chart.dart';
import 'samples/chart/cartesian_charts/bar_series/animation_bar_chart.dart';
import 'samples/chart/cartesian_charts/bar_series/bar_width_and_spacing.dart';
import 'samples/chart/cartesian_charts/bar_series/bar_with_rounded_corners.dart';
import 'samples/chart/cartesian_charts/bar_series/bar_with_track.dart';
import 'samples/chart/cartesian_charts/bar_series/customized_bar_chart.dart';
import 'samples/chart/cartesian_charts/bar_series/default_bar_chart.dart';
import 'samples/chart/cartesian_charts/bubble_series/animation_bubble_chart.dart';
import 'samples/chart/cartesian_charts/bubble_series/bubble_filled_with_gradient.dart';
import 'samples/chart/cartesian_charts/bubble_series/bubble_with_multiple_series.dart';
import 'samples/chart/cartesian_charts/bubble_series/bubble_with_various_colors.dart';
import 'samples/chart/cartesian_charts/bubble_series/default_bubble_chart.dart';
import 'samples/chart/cartesian_charts/column_series/animation_column_chart.dart';
import 'samples/chart/cartesian_charts/column_series/back_to_back_column.dart';
import 'samples/chart/cartesian_charts/column_series/column_width_and_spacing.dart';
import 'samples/chart/cartesian_charts/column_series/column_with_rounded_corners.dart';
import 'samples/chart/cartesian_charts/column_series/column_with_track.dart';
import 'samples/chart/cartesian_charts/column_series/customized_column_chart.dart';
import 'samples/chart/cartesian_charts/column_series/default_column_chart.dart';
import 'samples/chart/cartesian_charts/financial_series/candle_chart.dart';
import 'samples/chart/cartesian_charts/financial_series/hilo_chart.dart';
import 'samples/chart/cartesian_charts/financial_series/hilo_open_close_chart.dart';
import 'samples/chart/cartesian_charts/line_series/animation_line_chart.dart';
import 'samples/chart/cartesian_charts/line_series/customized_line_chart.dart';
import 'samples/chart/cartesian_charts/line_series/default_line_chart.dart';
import 'samples/chart/cartesian_charts/line_series/line_with_dashes.dart';
import 'samples/chart/cartesian_charts/line_series/multi_colored_line.dart';
import 'samples/chart/cartesian_charts/other_series/histogram_chart.dart';
import 'samples/chart/cartesian_charts/other_series/range_area.dart';
import 'samples/chart/cartesian_charts/other_series/spline_area.dart';
import 'samples/chart/cartesian_charts/other_series/spline_range_area.dart';
import 'samples/chart/cartesian_charts/other_series/step_area.dart';
import 'samples/chart/cartesian_charts/rangecolumn_series/animation_rangecolumn_chart.dart';
import 'samples/chart/cartesian_charts/rangecolumn_series/default_rangecolumn_chart.dart';
import 'samples/chart/cartesian_charts/rangecolumn_series/rangecolumn_with_track.dart';
import 'samples/chart/cartesian_charts/rangecolumn_series/vertical_rangecolumn_chart.dart';
import 'samples/chart/cartesian_charts/scatter_series/animation_scatter_chart.dart';
import 'samples/chart/cartesian_charts/scatter_series/default_scatter_chart.dart';
import 'samples/chart/cartesian_charts/scatter_series/scatter_with_various_shapes.dart';
import 'samples/chart/cartesian_charts/spline_series/animation_spline_chart.dart';
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
import 'samples/chart/cartesian_charts/stepLine_series/animation_stepline_chart.dart';
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
import 'samples/chart/series_features/animation/series_animation.dart';
import 'samples/chart/series_features/annotation/chart_with_annotation.dart';
import 'samples/chart/series_features/annotation/chart_with_watermark.dart';
import 'samples/chart/series_features/data_label/default_datalabels.dart';
import 'samples/chart/series_features/empty_point/chart_with_empty_points.dart';
import 'samples/chart/series_features/gradients/horizantal_gradient.dart';
import 'samples/chart/series_features/gradients/vertical_gradient.dart';
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
import 'samples/datagrid/column_types/datagrid_column_types.dart';
import 'samples/datagrid/conditional_styling/datagrid_conditional_styling.dart';
import 'samples/datagrid/getting_started/datagrid_getting_started.dart';
import 'samples/datagrid/real_time_update/datagrid_real_time_update.dart';
import 'samples/datagrid/selection/datagrid_selection.dart';
import 'samples/datagrid/styles/datagrid_styles.dart';
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
import 'samples/maps/bubble/bubble.dart';
import 'samples/maps/equal_color_mapping/equal_color_mapping.dart';
import 'samples/maps/marker/marker.dart';
import 'samples/maps/range_color_mapping/range_color_mapping.dart';
import 'samples/maps/selection/selection.dart';
import 'samples/pdf/certificate/certificate.dart';
import 'samples/pdf/header_and_footer/header_and_footer.dart';
import 'samples/pdf/invoice/invoice.dart';
import 'samples/sliders/range_selector/range_selector_default_appearance.dart';
import 'samples/sliders/range_selector/range_selector_with_selection.dart';
import 'samples/sliders/range_selector/range_selector_with_zooming.dart';
import 'samples/sliders/range_slider/customization/color_customization/color_customization.dart';
import 'samples/sliders/range_slider/customization/shape_customization/shape_customization.dart';
import 'samples/sliders/range_slider/customization/size_customization/size_customization.dart';
import 'samples/sliders/range_slider/customization/thumb_customization/range_slider_thumb_icon_customization.dart';
import 'samples/sliders/range_slider/default_appearance/range_slider_date_time_label.dart';
import 'samples/sliders/range_slider/default_appearance/range_slider_divisor_label_tick.dart';
import 'samples/sliders/range_slider/default_appearance/range_slider_interval_selection.dart';
import 'samples/sliders/range_slider/default_appearance/range_slider_step.dart';
import 'samples/sliders/range_slider/default_appearance/range_slider_tooltip_type.dart';
import 'samples/sliders/slider/basic_features/default_slider.dart';
import 'samples/sliders/slider/basic_features/slider_date_interval.dart';
import 'samples/sliders/slider/basic_features/slider_divisor_label_tick.dart';
import 'samples/sliders/slider/basic_features/slider_step.dart';
import 'samples/sliders/slider/basic_features/slider_tooltip_type.dart';
import 'samples/sliders/slider/customization/color_customization/slider_color_customization.dart';
import 'samples/sliders/slider/customization/shape_customization/slider_shape_customization.dart';
import 'samples/sliders/slider/customization/size_customization/slider_size_customization.dart';
import 'samples/sliders/slider/customization/thumb_customization/thumb_icon_customization.dart';

Map<String, dynamic> getSampleWidget() {
  return <String, dynamic>{
    //cartesian charts
    'default_line_chart': (Key key) => LineDefault(key),
    'line_with_dashes': (Key key) => LineDashed(key),
    'multi_colored_line': (Key key) => LineMultiColor(key),
    'customized_line_chart': (Key key) => CustomizedLine(key),
    'animation_line_chart': (Key key) => AnimationLineDefault(key),
    'histogram_chart': (Key key) => HistogramDefault(key),
    'spline_range_area': (Key key) => SplineRangeArea(key),
    'default_column_chart': (Key key) => ColumnDefault(key),
    'column_with_rounded_corners': (Key key) => ColumnRounded(key),
    'back_to_back_column': (Key key) => ColumnBack(key),
    'column_with_track': (Key key) => ColumnTracker(key),
    'column_width_and_spacing': (Key key) => ColumnSpacing(key),
    'customized_column_chart': (Key key) => ColumnVertical(key),
    'animation_column_chart': (Key key) => AnimationColumnDefault(key),
    'default_spline_chart': (Key key) => SplineDefault(key),
    'spline_with_dashes': (Key key) => SplineDashed(key),
    'spline_types': (Key key) => SplineTypes(key),
    'vertical_spline_chart': (Key key) => SplineVertical(key),
    'customized_spline_chart': (Key key) => SplineCustomization(key),
    'animation_spline_chart': (Key key) => AnimationSplineDefault(key),
    'default_area_chart': (Key key) => AreaDefault(key),
    'area_with_emptypoints': (Key key) => AreaEmpty(key),
    'vertical_area_chart': (Key key) => AreaVertical(key),
    'animation_area_chart': (Key key) => AnimationAreaDefault(key),
    'range_area': (Key key) => RangeArea(key),
    'step_area': (Key key) => StepArea(key),
    'spline_area': (Key key) => SplineArea(key),
    'default_bar_chart': (Key key) => BarDefault(key),
    'bar_with_rounded_corners': (Key key) => BarRounded(key),
    'bar_width_and_spacing': (Key key) => BarSpacing(key),
    'bar_with_track': (Key key) => BarTracker(key),
    'customized_bar_chart': (Key key) => BarCustomization(key),
    'animation_bar_chart': (Key key) => AnimationBarDefault(key),
    'default_bubble_chart': (Key key) => BubbleDefault(key),
    'bubble_with_various_colors': (Key key) => BubblePointColor(key),
    'bubble_filled_with_gradient': (Key key) => BubbleGradient(key),
    'bubble_with_multiple_series': (Key key) => BubbleMultiSeries(key),
    'animation_bubble_chart': (Key key) => AnimationBubbleDefault(key),
    'default_scatter_chart': (Key key) => ScatterDefault(key),
    'scatter_with_various_shapes': (Key key) => ScatterShapes(key),
    'animation_scatter_chart': (Key key) => AnimationScatterDefault(key),
    'default_stepline_chart': (Key key) => StepLineDefault(key),
    'stepline_with_dashes': (Key key) => StepLineDashed(key),
    'vertical_stepline_chart': (Key key) => StepLineVertical(key),
    'animation_stepline_chart': (Key key) => AnimationStepLineDefault(key),
    'default_rangecolumn_chart': (Key key) => RangeColumnDefault(key),
    'vertical_rangecolumn_chart': (Key key) => RangeBarChart(key),
    'rangecolumn_with_track': (Key key) => RangeColumnWithTrack(key),
    'animation_rangecolumn_chart': (Key key) =>
        AnimationRangeColumnDefault(key),
    'stacked_line_chart': (Key key) => StackedLineChart(key),
    'stacked_area_chart': (Key key) => StackedAreaChart(key),
    'stacked_column_chart': (Key key) => StackedColumnChart(key),
    'stacked_bar_chart': (Key key) => StackedBarChart(key),
    'stacked_area_100_chart': (Key key) => StackedArea100Chart(key),
    'stacked_bar_100_chart': (Key key) => StackedBar100Chart(key),
    'stacked_column_100_chart': (Key key) => StackedColumn100Chart(key),
    'stacked_line_100_chart': (Key key) => StackedLine100Chart(key),
    'default_numeric_axis': (Key key) => NumericDefault(key),
    'numeric_axis_with_label_format': (Key key) => NumericLabel(key),
    'inversed_numeric_axis': (Key key) => NumericInverse(key),
    'default_category_axis': (Key key) => CategoryDefault(key),
    'category_arranged_by_index': (Key key) => CategoryIndexed(key),
    'category_label_placement': (Key key) => CategoryTicks(key),
    'default_datetime_axis': (Key key) => DateTimeDefault(key),
    'datetime_axis_with_label_format': (Key key) => DateTimeLabel(key),
    'default_logarithmic_axis': (Key key) => LogarithmicAxisDefault(key),
    'inversed_logarithmic_axis': (Key key) => LogarithmicAxisInversed(key),
    'hilo_chart': (Key key) => HiloChart(key),
    'hilo_open_close_chart': (Key key) => HiloOpenCloseChart(key),
    'candle_chart': (Key key) => CandleChart(key),
    'axis_crossing': (Key key) => AxisCrossing(key),
    'positioning_axis_labels': (Key key) => LabelCustomization(key),
    'axis_animation': (Key key) => AxisAnimationDefault(key),
    'edgelabel_placement': (Key key) => EdgeLabel(key),
    'handling_label_collision': (Key key) => LabelAction(key),
    'multiple_axis_chart': (Key key) => MultipleAxis(key),
    'opposed_axes': (Key key) => NumericOpposed(key),
    'plot_band_recurrence': (Key key) => PlotBandRecurrence(key),
    'plot_band': (Key key) => PlotBandDefault(key),

    //Series Features
    'series_animation': (Key key) => AnimationDefault(key),
    'chart_with_annotation': (Key key) => AnnotationWatermark(key),
    'chart_with_watermark': (Key key) => AnnotationDefault(key),
    'default_datalabels': (Key key) => DataLabelDefault(key),
    'chart_with_empty_points': (Key key) => EmptyPoints(key),
    'horizantal_gradient': (Key key) => HorizantalGradient(key),
    'vertical_gradient': (Key key) => VerticalGradient(key),
    'various_marker_shapes': (Key key) => MarkerDefault(key),
    'sorting_options': (Key key) => SortingDefault(key),
    'default_trendlines_with_options': (Key key) => TrendLineDefault(key),
    'trendline_forecast_with_options': (Key key) => TrendLineForecast(key),

    //Legend
    'chart_with_customized_legend': (Key key) => LegendCustomized(key),
    'chart_with_legend': (Key key) => LegendDefault(key),
    'legend_with_various_options': (Key key) => LegendOptions(key),
    'cartesian_legend_various_options': (Key key) =>
        CartesianLegendOptions(key),

    //Technical Indicators
    'accumulation_distribution': (Key key) => AdIndicator(key),
    'atr_indicator': (Key key) => ATRIndicator(key),
    'bollinger_indicator': (Key key) => BollingerIndicator(key),
    'ema_indicator': (Key key) => EMAIndicator(key),
    'momentum_indicator': (Key key) => MomentummIndicator(key),
    'rsi_indicator': (Key key) => RSIIndicator(key),
    'sma_indicator': (Key key) => SMAIndicator(key),
    'stochastic_indicator': (Key key) => StochasticcIndicator(key),
    'tma_indicator': (Key key) => TMAIndicator(key),
    'macd_indicator': (Key key) => MACDIndicator(key),

    //User Interaction
    'chart_with_crosshair': (Key key) => DefaultCrossHair(key),
    'selection_modes': (Key key) => DefaultSelection(key),
    'default_tooltip': (Key key) => DefaultTooltip(key),
    'chart_with_trackball': (Key key) => DefaultTrackball(key),
    'pinch_zooming': (Key key) => DefaultPanning(key),
    'selection_zooming': (Key key) => DefaultZooming(key),
    'zooming_with_custom_buttons': (Key key) => ButtonZooming(key),
    'tooltip_position': (Key key) => CartesianTooltipPosition(key),
    'circular_selection':
        // getCircularSelectionChart(isTileView),
        (Key key) => CircularSelection(key),
    'pie_tooltip_position':
        // getPieTooltipPositionChart(isTileView),
        (Key key) => PieTooltipPosition(key),

    //Dynamic updates
    'add_remove_points': (Key key) => AddDataPoints(key),
    'add_remove_series': (Key key) => AddSeries(key),
    'real_time_spline_chart': (Key key) => LiveUpdate(key),
    'vertical_live_chart': (Key key) => VerticalLineLiveUpdate(key),
    'update_data_source': (Key key) => UpdateDataSource(key),
    'real_time_line_chart': (Key key) => LiveLineChart(key),

    //Pie
    'default_pie_chart':
        (Key key) => PieDefault(key),
    'pie_with_grouping':
        (Key key) => PieGrouping(key),
    'pie_with_smart_labels':
        (Key key) => PieSmartLabels(key),
    'pie_with_various_radius':
        (Key key) => PieRadius(key),
    'semi_pie_chart':
        (Key key) => PieSemi(key),
    //Doughnut
    'default_doughnut_chart':
        (Key key) => DoughnutDefault(key),
    'doughnut_with_center_elevation':
        (Key key) => DoughnutElevation(key),
    'doughnut_with_color_mapping':
        // getDoughnutCustomizationChart(isTileView),
        (Key key) => DoughnutCustomization(key),
    'doughnut_with_rounded_corners':
        // getRoundedDoughnutChart(isTileView),
        (Key key) => DoughnutRounded(key),
    'semi_doughnut_chart':
        // getSemiDoughnutChart(isTileView),
        (Key key) => DoughnutSemi(key),
    // SemiDoughnutFrontPanel()

    //Radialbar
    'customized_radialbar_chart':
        // getCustomizedRadialBarChart(isTileView),
        (Key key) => RadialBarCustomized(key),
    'default_radialbar_chart':
        // getDefaultRadialBarChart(isTileView),
        (Key key) => RadialBarDefault(key),
    'radialbar_with_legend':
        // getAngleRadialBarChart(isTileView),
        (Key key) => RadialBarAngle(key),

    //Funnel
    'default_funnel_chart':
        // getDefaultFunnelChart(isTileView),
        (Key key) => FunnelDefault(key),
    'funnel_with_legend':
        // getLegendFunnelChart(isTileView),
        (Key key) => FunnelLegend(key),
    'funnel_with_smart_labels': (Key key) => FunnelSmartLabels(key),

    //Pyramid
    'default_pyramid_chart': (Key key) => PyramidDefault(key),
    'pyramid_with_legend': (Key key) => PyramidLegend(key),
    'pyramid_with_smart_labels': (Key key) => PyramidSmartLabels(key),

    // Calendar Samples
    'getting_started_calendar': (Key key) => GettingStartedCalendar(key),
    'recurrence_calendar': (Key key) => RecurrenceCalendar(key),
    'agenda_view_calendar': (Key key) => AgendaViewCalendar(key),
    'appointment_editor_calendar': (Key key) => CalendarAppointmentEditor(key),
    'special_regions_calendar': (Key key) => SpecialRegionsCalendar(key),
    'schedule_view_calendar': (Key key) => ScheduleViewCalendar(key),
    'shift_scheduler': (Key key) => ShiftScheduler(key),

    // Date picker Samples
    'getting_started_date_picker': (Key key) => GettingStartedDatePicker(key),
    'blackout_picker': (Key key) => BlackoutDatePicker(key),
    'customized_picker': (Key key) => CustomizedDatePicker(key),
    'popup_picker': (Key key) => PopUpDatePicker(key),

    //Gauge
    'radial_bounce': (Key key) => RadialBounceOutExample(key),
    'radial_easeanimation': (Key key) => RadialEaseExample(key),
    'radial_easeincric': (Key key) => RadialEaseInCircExample(key),
    'radial_easeout': (Key key) => RadialEaseOutAnimation(key),
    'radial_elasticout': (Key key) => RadialElasticOutAnimation(key),
    'radial_linearanimation': (Key key) => RadialLinearAnimation(key),
    'radial_slowmiddle': (Key key) => RadialSlowMiddleAnimation(key),
    'direct_compass': (Key key) => RadialCompass(key),
    'image_annotation': (Key key) => RadialImageAnnotation(key),
    'text_annotation': (Key key) => RadialTextAnnotation(key),
    'custom_labels': (Key key) => GaugeCustomLabels(key),
    'default_gauge_view': (Key key) => RadialGaugeDefault(key),
    'multiple_axis': (Key key) => MultipleAxisExample(key),
    'non_linearable': (Key key) => RadialNonLinearLabel(key),
    'radiallabel_customization': (Key key) => RadialLabelCustomization(key),
    'range_colors': (Key key) => RangeColorForLabels(key),
    'tick_customization': (Key key) => RadialTickCustomization(key),
    'radial_pointerdragging': (Key key) => RadialPointerDragging(key),
    'radial_slider': (Key key) => RadialSlider(key),
    'multiple_needle': (Key key) => MultipleNeedleExample(key),
    'range_pointer': (Key key) => MultipleRangePointerExample(key),
    'radial_marker': (Key key) => RadialMarkerExample(key),
    'text_pointer': (Key key) => RadialTextPointer(key),
    'multiple_ranges': (Key key) => MultipleRangesExample(key),
    'range_datalabels': (Key key) => RangeDataLabelExample(key),
    'range_thickness': (Key key) => RangeThicknessExample(key),
    'clock_sample': (Key key) => ClockExample(key),

    'distance_tracker': (Key key) => DistanceTrackerExample(key),
    'gauge_overview': (Key key) => GaugeOverviewExample(key),
    'gauge_compass': (Key key) => GaugeCompassExample(key),

    // PDF samples
    'invoice': (Key key) => InvoicePdf(key),
    'certificate': (Key key) => CourseCompletionCertificatePdf(key),
    'header_and_footer': (Key key) => HeaderAndFooterPdf(key),

    // Barcode samples
    'one_dimensional_types': (Key key) => OneDimensionalBarcodes(key: key),

    'qr_code_generator': (Key key) => QRCodeGenerator(key),

    'data_matrix_generator':
        // getDataMatrixGenerator(),
        // DataMatrixGenerator(),
        (Key key) => DataMatrixGenerator(key),
    'range_slider_divisor_label_tick': (Key key) => ScaleRangeSliderPage(key),

    'range_slider_date_time_label': (Key key) => DateRangeSliderPage(key),

    'color_customization': (Key key) => ColorCustomizedRangeSliderPage(key),

    'shape_customization': (Key key) => ShapeCustomizedRangeSliderPage(key),

    'range_slider_thumb_icon_customization': (Key key) =>
        ThumbCustomizationRangeSliderPage(key),

    'range_selector_default_appearance': (Key key) =>
        DefaultRangeSelectorPage(key),
    'range_selector_with_selection': (Key key) =>
        RangeSelectorSelectionPage(key),
    'range_selector_with_zooming': (Key key) => RangeSelectorZoomingPage(key),
    'range_slider_tooltip_type': (Key key) => TooltipRangeSliderPage(key),
    'range_slider_step': (Key key) => SliderStepDurationPage(key),
    'range_slider_interval_selection': (Key key) =>
        RangeSliderIntervalSelectionPage(key),
    'size_customization': (Key key) => SfRangeSliderSizeCustomizationPage(key),

    'default_slider': (Key key) => DefaultSliderPage(key),

    'slider_date_interval': (Key key) => DateIntervalSliderPage(key),

    'slider_tooltip_type': (Key key) => SliderTooltipTypeSliderPage(key),

    'slider_step': (Key key) => StepSliderPage(key),

    'thumb_icon_customization': (Key key) => ThumbCustomizationSliderPage(key),

    'slider_size_customization': (Key key) => SliderSizeCustomizationPage(key),

    'slider_divisor_label_tick': (Key key) => SliderLabelCustomizationPage(key),

    'slider_color_customization': (Key key) =>
        SliderColorCustomizationPage(key),

    'slider_shape_customization': (Key key) =>
        ShapeCustomizedSliderPage(key),
        
    //dataGridSample
    'getting_started_datagrid': (Key key) => GettingStartedDataGrid(key: key),

    'column_types_datagrid': (Key key) => ColumnTypeDataGrid(key: key),

    'selection_datagrid': (Key key) => SelectionDataGrid(key: key),

    'styles_datagrid': (Key key) => StylesDataGrid(key: key),

    'conditional_styling_datagrid': (Key key) =>
        ConditionalStylingDataGrid(key: key),

    'real_time_update_datagrid': (Key key) => RealTimeUpdateDataGrid(key: key),

    //Maps
    'selection': (Key key) => MapSelection(key),
    'range_color_mapping': (Key key) => MapRangeColorMapping(key),
    'bubble': (Key key) => MapBubble(key),
    'marker': (Key key) => MapMarkerSample(key),
    'equal_color_mapping': (Key key) => MapEqualColorMapping(key),
  };
}
