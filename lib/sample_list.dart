import 'package:flutter/foundation.dart';

import 'samples/barcodes/data_matrix.dart';
import 'samples/barcodes/one_dimensional.dart';
import 'samples/barcodes/qr_code.dart';
import 'samples/calendar/agenda_view.dart';
import 'samples/calendar/airfare.dart';
import 'samples/calendar/appointment_editor.dart';
import 'samples/calendar/calendar_loadmore.dart';
import 'samples/calendar/customization.dart';
import 'samples/calendar/getting_started.dart';
import 'samples/calendar/heatmap.dart';
import 'samples/calendar/recurrence.dart';
import 'samples/calendar/schedule_view.dart';
import 'samples/calendar/shift_scheduler.dart';
import 'samples/calendar/special_regions.dart';
import 'samples/calendar/timeline_views.dart';
import 'samples/chart/cartesian_charts/axis_features/axis_animation.dart';
import 'samples/chart/cartesian_charts/axis_features/axis_crossing.dart';
import 'samples/chart/cartesian_charts/axis_features/edge_label_placement.dart';
import 'samples/chart/cartesian_charts/axis_features/handling_label_collision.dart';
import 'samples/chart/cartesian_charts/axis_features/maximum_width_for_labels.dart';
import 'samples/chart/cartesian_charts/axis_features/multiple_axis_chart.dart';
import 'samples/chart/cartesian_charts/axis_features/opposed_axes.dart';
import 'samples/chart/cartesian_charts/axis_features/plot_band.dart';
import 'samples/chart/cartesian_charts/axis_features/plot_band_recurrence.dart';
import 'samples/chart/cartesian_charts/axis_features/positioning_axis_label.dart';
import 'samples/chart/cartesian_charts/axis_types/category/default_category_axis.dart';
import 'samples/chart/cartesian_charts/axis_types/category/indexed_category_axis.dart';
import 'samples/chart/cartesian_charts/axis_types/category/label_placement.dart';
import 'samples/chart/cartesian_charts/axis_types/date_time/date_time_axis_with_label_format.dart';
import 'samples/chart/cartesian_charts/axis_types/date_time/default_date_time_axis.dart';
import 'samples/chart/cartesian_charts/axis_types/date_time_category/date_time_category_with_label_format.dart';
import 'samples/chart/cartesian_charts/axis_types/date_time_category/default_date_time_category.dart';
import 'samples/chart/cartesian_charts/axis_types/logarithmic/default_logarithmic_axis.dart';
import 'samples/chart/cartesian_charts/axis_types/logarithmic/inversed_logarithmic_axis.dart';
import 'samples/chart/cartesian_charts/axis_types/numeric/default_numeric_axis.dart';
import 'samples/chart/cartesian_charts/axis_types/numeric/inversed_numeric_axis.dart';
import 'samples/chart/cartesian_charts/axis_types/numeric/numeric_axis_with_label_format.dart';
import 'samples/chart/cartesian_charts/chart_types/area/animation_area_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/area/area_with_axis_base.dart';
import 'samples/chart/cartesian_charts/chart_types/area/area_with_emptypoints.dart';
import 'samples/chart/cartesian_charts/chart_types/area/default_area_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/area/vertical_area_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/bar/animation_bar_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/bar/bar_width_and_spacing.dart';
import 'samples/chart/cartesian_charts/chart_types/bar/bar_with_rounded_corners.dart';
import 'samples/chart/cartesian_charts/chart_types/bar/bar_with_track.dart';
import 'samples/chart/cartesian_charts/chart_types/bar/customized_bar_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/bar/default_bar_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/box_whisker.dart';
import 'samples/chart/cartesian_charts/chart_types/bubble/animation_bubble_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/bubble/bubble_filled_with_gradient.dart';
import 'samples/chart/cartesian_charts/chart_types/bubble/bubble_with_multiple_series.dart';
import 'samples/chart/cartesian_charts/chart_types/bubble/bubble_with_various_colors.dart';
import 'samples/chart/cartesian_charts/chart_types/bubble/default_bubble_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/column/animation_column_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/column/back_to_back_column.dart';
import 'samples/chart/cartesian_charts/chart_types/column/column_width_and_spacing.dart';
import 'samples/chart/cartesian_charts/chart_types/column/column_with_axis_base.dart';
import 'samples/chart/cartesian_charts/chart_types/column/column_with_rounded_corners.dart';
import 'samples/chart/cartesian_charts/chart_types/column/column_with_track.dart';
import 'samples/chart/cartesian_charts/chart_types/column/customized_column_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/column/default_column_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/financial_charts/candle_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/financial_charts/hilo_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/financial_charts/hilo_open_close_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/histogram.dart';
import 'samples/chart/cartesian_charts/chart_types/line/animation_line_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/line/customized_line_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/line/default_line_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/line/line_with_dashes.dart';
import 'samples/chart/cartesian_charts/chart_types/line/multi_colored_line.dart';
import 'samples/chart/cartesian_charts/chart_types/range_area.dart';
import 'samples/chart/cartesian_charts/chart_types/range_column/animation_range_column_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/range_column/default_range_column_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/range_column/range_column_with_track.dart';
import 'samples/chart/cartesian_charts/chart_types/range_column/vertical_range_column_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/scatter/animation_scatter_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/scatter/default_scatter_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/scatter/scatter_with_various_shapes.dart';
import 'samples/chart/cartesian_charts/chart_types/spline/animation_spline_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/spline/customized_spline_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/spline/default_spline_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/spline/spline_types.dart';
import 'samples/chart/cartesian_charts/chart_types/spline/spline_with_dashes.dart';
import 'samples/chart/cartesian_charts/chart_types/spline/vertical_spline_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/spline_area.dart';
import 'samples/chart/cartesian_charts/chart_types/spline_range_area.dart';
import 'samples/chart/cartesian_charts/chart_types/stacked_100_charts/stacked_area_100_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/stacked_100_charts/stacked_bar_100_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/stacked_100_charts/stacked_column_100_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/stacked_100_charts/stacked_line_100_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/stacked_charts/stacked_area_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/stacked_charts/stacked_bar_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/stacked_charts/stacked_column_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/stacked_charts/stacked_line_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/step_area.dart';
import 'samples/chart/cartesian_charts/chart_types/step_line/animation_step_line_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/step_line/default_step_line_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/step_line/step_line_with_dashes.dart';
import 'samples/chart/cartesian_charts/chart_types/step_line/vertical_step_line_chart.dart';
import 'samples/chart/cartesian_charts/chart_types/waterfall/vertical_waterfall.dart';
import 'samples/chart/cartesian_charts/chart_types/waterfall/waterfall.dart';
import 'samples/chart/cartesian_charts/data_source/json.dart';
import 'samples/chart/cartesian_charts/data_source/list.dart';
import 'samples/chart/cartesian_charts/export.dart';
import 'samples/chart/cartesian_charts/legend/chart_with_customized_legend.dart';
import 'samples/chart/cartesian_charts/legend/legend_various_options.dart';
import 'samples/chart/cartesian_charts/on_demand_loading/infinite_scrolling.dart';
import 'samples/chart/cartesian_charts/real_time_charts/add_remove_data/add_remove_points.dart';
import 'samples/chart/cartesian_charts/real_time_charts/add_remove_data/add_remove_series.dart';
import 'samples/chart/cartesian_charts/real_time_charts/live_update/real_time_line_chart.dart';
import 'samples/chart/cartesian_charts/real_time_charts/live_update/real_time_spline_chart.dart';
import 'samples/chart/cartesian_charts/real_time_charts/live_update/vertical_live_chart.dart';
import 'samples/chart/cartesian_charts/real_time_charts/update_data_source.dart';
import 'samples/chart/cartesian_charts/series_features/animation/series_animation.dart';
import 'samples/chart/cartesian_charts/series_features/annotation/chart_with_annotation.dart';
import 'samples/chart/cartesian_charts/series_features/annotation/chart_with_watermark.dart';
import 'samples/chart/cartesian_charts/series_features/data_label/data_label_template.dart';
import 'samples/chart/cartesian_charts/series_features/data_label/default_data_labels.dart';
import 'samples/chart/cartesian_charts/series_features/empty_points.dart';
import 'samples/chart/cartesian_charts/series_features/gradients/horizantal_gradient.dart';
import 'samples/chart/cartesian_charts/series_features/gradients/vertical_gradient.dart';
import 'samples/chart/cartesian_charts/series_features/marker.dart';
import 'samples/chart/cartesian_charts/series_features/sorting.dart';
import 'samples/chart/cartesian_charts/technical_indicators/accumulation_distribution.dart';
import 'samples/chart/cartesian_charts/technical_indicators/atr_indicator.dart';
import 'samples/chart/cartesian_charts/technical_indicators/bollinger_indicator.dart';
import 'samples/chart/cartesian_charts/technical_indicators/ema_indicator.dart';
import 'samples/chart/cartesian_charts/technical_indicators/macd_indicator.dart';
import 'samples/chart/cartesian_charts/technical_indicators/momentum_indicator.dart';
import 'samples/chart/cartesian_charts/technical_indicators/rsi_indicator.dart';
import 'samples/chart/cartesian_charts/technical_indicators/sma_indicator.dart';
import 'samples/chart/cartesian_charts/technical_indicators/stochastic_indicator.dart';
import 'samples/chart/cartesian_charts/technical_indicators/tma_indicator.dart';
import 'samples/chart/cartesian_charts/trendline/default_trendline.dart';
import 'samples/chart/cartesian_charts/trendline/trendline_forecast.dart';
import 'samples/chart/cartesian_charts/user_interactions/add_point_on_click.dart';
import 'samples/chart/cartesian_charts/user_interactions/auto_scrolling.dart';
import 'samples/chart/cartesian_charts/user_interactions/crosshair.dart';
import 'samples/chart/cartesian_charts/user_interactions/events/events.dart';
import 'samples/chart/cartesian_charts/user_interactions/events/navigation_with_events.dart';
import 'samples/chart/cartesian_charts/user_interactions/pagination.dart';
import 'samples/chart/cartesian_charts/user_interactions/selection/dynamic_selection.dart';
import 'samples/chart/cartesian_charts/user_interactions/selection/selection_modes.dart';
import 'samples/chart/cartesian_charts/user_interactions/tooltip/default_tooltip.dart';
import 'samples/chart/cartesian_charts/user_interactions/tooltip/tooltip_position.dart';
import 'samples/chart/cartesian_charts/user_interactions/tooltip/tooltip_template.dart';
import 'samples/chart/cartesian_charts/user_interactions/trackball/chart_with_trackball.dart';
import 'samples/chart/cartesian_charts/user_interactions/trackball/customized_trackball.dart';
import 'samples/chart/cartesian_charts/user_interactions/zooming_and_panning/pinch_zooming.dart';
import 'samples/chart/cartesian_charts/user_interactions/zooming_and_panning/selection_zooming.dart';
import 'samples/chart/cartesian_charts/user_interactions/zooming_and_panning/zooming_with_custom_buttons.dart';
import 'samples/chart/circular_charts/chart_types/doughnut/default_doughnut_chart.dart';
import 'samples/chart/circular_charts/chart_types/doughnut/doughnut_with_center_elevation.dart';
import 'samples/chart/circular_charts/chart_types/doughnut/doughnut_with_color_mapping.dart';
import 'samples/chart/circular_charts/chart_types/doughnut/doughnut_with_gradient.dart';
import 'samples/chart/circular_charts/chart_types/doughnut/doughnut_with_rounded_corners.dart';
import 'samples/chart/circular_charts/chart_types/doughnut/semi_doughnut_chart.dart';
import 'samples/chart/circular_charts/chart_types/pie/default_pie_chart.dart';
import 'samples/chart/circular_charts/chart_types/pie/pie_with_gradient.dart';
import 'samples/chart/circular_charts/chart_types/pie/pie_with_grouping.dart';
import 'samples/chart/circular_charts/chart_types/pie/pie_with_image.dart';
import 'samples/chart/circular_charts/chart_types/pie/pie_with_smart_labels.dart';
import 'samples/chart/circular_charts/chart_types/pie/pie_with_various_radius.dart';
import 'samples/chart/circular_charts/chart_types/pie/point_render_mode.dart';
import 'samples/chart/circular_charts/chart_types/pie/semi_pie_chart.dart';
import 'samples/chart/circular_charts/chart_types/radial_bar/customized_radial_bar_chart.dart';
import 'samples/chart/circular_charts/chart_types/radial_bar/default_radial_bar_chart.dart';
import 'samples/chart/circular_charts/chart_types/radial_bar/radial_bar_with_gradient.dart';
import 'samples/chart/circular_charts/chart_types/radial_bar/radial_bar_with_legend.dart';
import 'samples/chart/circular_charts/export.dart';
import 'samples/chart/circular_charts/legend/chart_with_legend.dart';
import 'samples/chart/circular_charts/legend/legend_with_various_options.dart';
import 'samples/chart/circular_charts/user_interactions/dynamic_selection.dart';
import 'samples/chart/circular_charts/user_interactions/selection.dart';
import 'samples/chart/circular_charts/user_interactions/tooltip.dart';
import 'samples/chart/funnel_charts/default_funnel_chart.dart';
import 'samples/chart/funnel_charts/funnel_with_legend.dart';
import 'samples/chart/funnel_charts/funnel_with_smart_labels.dart';
import 'samples/chart/pyramid_charts/default_pyramid_chart.dart';
import 'samples/chart/pyramid_charts/pyramid_with_legend.dart';
import 'samples/chart/pyramid_charts/pyramid_with_smart_labels.dart';
import 'samples/datagrid/apperance/conditional_styling/datagrid_conditional_styling.dart';
import 'samples/datagrid/apperance/styling/datagrid_styling.dart';
import 'samples/datagrid/columns/datagrid_column_types.dart';
import 'samples/datagrid/columns/datagrid_custom_header.dart';
import 'samples/datagrid/columns/datagrid_stacked_header.dart';
import 'samples/datagrid/data_source/datagrid_json_data_source.dart';
import 'samples/datagrid/data_source/datagrid_list_data_source.dart';
import 'samples/datagrid/freeze_panes/datagrid_freeze_panes.dart';
import 'samples/datagrid/getting_started/datagrid_getting_started.dart';
import 'samples/datagrid/loadmore/datagrid_infinite_scrolling.dart';
import 'samples/datagrid/loadmore/datagrid_load_more.dart';
import 'samples/datagrid/paging/datagrid_paging.dart';
import 'samples/datagrid/pull_to_refresh/datagrid_pull_to_refresh.dart';
import 'samples/datagrid/real_time_update/datagrid_real_time_update.dart';
import 'samples/datagrid/row_height/datagrid_row_height.dart';
import 'samples/datagrid/selection/datagrid_selection.dart';
import 'samples/datagrid/sorting/datagrid_sorting.dart';
import 'samples/datagrid/swiping/datagrid_swiping.dart';
import 'samples/date_picker/blackout_date_picker.dart';
import 'samples/date_picker/customized_date_picker.dart';
import 'samples/date_picker/date_picker_getting_started.dart';
import 'samples/date_picker/hijri_calendar.dart';
import 'samples/date_picker/popup_picker.dart';
import 'samples/date_picker/vertical_calendar.dart';
import 'samples/gauge/animation/radial_bounce.dart';
import 'samples/gauge/animation/radial_ease_animation.dart';
import 'samples/gauge/animation/radial_ease_incric.dart';
import 'samples/gauge/animation/radial_ease_out.dart';
import 'samples/gauge/animation/radial_elastic_out.dart';
import 'samples/gauge/animation/radial_linear_animation.dart';
import 'samples/gauge/animation/radial_slow_middle.dart';
import 'samples/gauge/annotation/direct_compass.dart';
import 'samples/gauge/annotation/temparature_tracker.dart';
import 'samples/gauge/annotation/text_annotation.dart';
import 'samples/gauge/axis_feature/custom_labels.dart';
import 'samples/gauge/axis_feature/custom_scale.dart';
import 'samples/gauge/axis_feature/default_gauge_view.dart';
import 'samples/gauge/axis_feature/multiple_axis.dart';
import 'samples/gauge/axis_feature/radial_label_customization.dart';
import 'samples/gauge/axis_feature/range_colors.dart';
import 'samples/gauge/axis_feature/tick_customization.dart';
import 'samples/gauge/export/export.dart';
import 'samples/gauge/pointer_interaction/radial_range_slider.dart';
import 'samples/gauge/pointer_interaction/radial_slider.dart';
import 'samples/gauge/pointers/marker_pointer.dart';
import 'samples/gauge/pointers/multiple_needle.dart';
import 'samples/gauge/pointers/range_pointer.dart';
import 'samples/gauge/pointers/text_pointer.dart';
import 'samples/gauge/pointers/widget_pointer.dart';
import 'samples/gauge/ranges/multiple_ranges.dart';
import 'samples/gauge/ranges/range_datalabels.dart';
import 'samples/gauge/ranges/range_thickness.dart';
import 'samples/gauge/showcase/clock_sample.dart';
import 'samples/gauge/showcase/distance_tracker.dart';
import 'samples/gauge/showcase/gauge_compass.dart';
import 'samples/gauge/showcase/temperature_monitor.dart';
import 'samples/linear_gauge/api/api_customization.dart';
import 'samples/linear_gauge/axis/axis_track.dart';
import 'samples/linear_gauge/axis/label_customization.dart';
import 'samples/linear_gauge/axis/tick_customization.dart';
import 'samples/linear_gauge/pointers/bar_pointer.dart';
import 'samples/linear_gauge/pointers/shape_pointer.dart';
import 'samples/linear_gauge/pointers/widget_pointer.dart';
import 'samples/linear_gauge/ranges/range_customization.dart';
import 'samples/linear_gauge/showcase/battery_indicator.dart';
import 'samples/linear_gauge/showcase/heat_meter.dart';
import 'samples/linear_gauge/showcase/height_calculator.dart';
import 'samples/linear_gauge/showcase/progress_bar.dart';
import 'samples/linear_gauge/showcase/sleep_watch_score.dart';
import 'samples/linear_gauge/showcase/steps_counter.dart';
import 'samples/linear_gauge/showcase/task_tracker.dart';
import 'samples/linear_gauge/showcase/thermometer.dart';
import 'samples/linear_gauge/showcase/volume_settings.dart';
import 'samples/linear_gauge/showcase/water_indicator.dart';
import 'samples/maps/shape_layer/bubble/bubble.dart';
import 'samples/maps/shape_layer/equal_color_mapping/equal_color_mapping.dart';
import 'samples/maps/shape_layer/legend/legend.dart';
import 'samples/maps/shape_layer/marker/marker.dart';
import 'samples/maps/shape_layer/range_color_mapping/range_color_mapping.dart';
import 'samples/maps/shape_layer/selection/selection.dart';
import 'samples/maps/shape_layer/sublayer/sublayer.dart';
import 'samples/maps/shape_layer/tooltip/tooltip.dart';
import 'samples/maps/shape_layer/zooming/zooming.dart';
import 'samples/maps/tile_layer/bing_map/bing_map.dart';
import 'samples/maps/tile_layer/open_street_map/open_street_map.dart';
import 'samples/maps/tile_layer/vector_layer/arcs.dart';
import 'samples/maps/tile_layer/vector_layer/polygon.dart';
import 'samples/maps/tile_layer/vector_layer/polylines.dart';
import 'samples/pdf/annotations.dart';
import 'samples/pdf/certificate.dart';
import 'samples/pdf/conformance.dart';
import 'samples/pdf/digital_signature.dart';
import 'samples/pdf/encryption.dart';
import 'samples/pdf/find_text.dart';
import 'samples/pdf/form.dart';
import 'samples/pdf/header_and_footer.dart';
import 'samples/pdf/invoice.dart';
import 'samples/pdf/text_extraction.dart';
import 'samples/pdf_viewer/pdf_viewer_custom_toolbar.dart';
import 'samples/pdf_viewer/pdf_viewer_getting_started.dart';
import 'samples/progress_bar/angles.dart';
import 'samples/progress_bar/custom_labels.dart';
import 'samples/progress_bar/determinate_styles.dart';
import 'samples/progress_bar/segment_styles.dart';
import 'samples/progress_bar/track_with_marker.dart';
import 'samples/progress_bar/types.dart';
import 'samples/radial_range_slider/basic_features/angles.dart';
import 'samples/radial_range_slider/basic_features/labels_and_ticks.dart';
import 'samples/radial_range_slider/basic_features/state.dart';
import 'samples/radial_range_slider/customization/custom_text.dart';
import 'samples/radial_range_slider/customization/gradient.dart';
import 'samples/radial_range_slider/customization/styles.dart';
import 'samples/radial_range_slider/customization/thumb.dart';
import 'samples/radial_slider/basic_features/angles.dart';
import 'samples/radial_slider/basic_features/labels_and_ticks.dart';
import 'samples/radial_slider/basic_features/state.dart';
import 'samples/radial_slider/customization/custom_text.dart';
import 'samples/radial_slider/customization/gradient.dart';
import 'samples/radial_slider/customization/styles.dart';
import 'samples/radial_slider/customization/thumb.dart';
import 'samples/signature_pad/getting_started/signature_pad_getting_started.dart';
import 'samples/sliders/range_selector/range_selector_default_appearance.dart';
import 'samples/sliders/range_selector/range_selector_with_bar_chart.dart';
import 'samples/sliders/range_selector/range_selector_with_histogram_chart.dart';
import 'samples/sliders/range_selector/range_selector_with_selection.dart';
import 'samples/sliders/range_selector/range_selector_with_zooming.dart';
import 'samples/sliders/range_slider/customization/color_customization/color_customization.dart';
import 'samples/sliders/range_slider/customization/shape_customization/shape_customization.dart';
import 'samples/sliders/range_slider/customization/size_customization/size_customization.dart';
import 'samples/sliders/range_slider/customization/thumb_customization/range_slider_thumb_icon_customization.dart';
import 'samples/sliders/range_slider/default_appearance/range_slider_date_time_label.dart';
import 'samples/sliders/range_slider/default_appearance/range_slider_default_appearance.dart';
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
import 'samples/sliders/vertical_range_slider/customization/color_customization/vertical_range_slider_color_customization.dart';
import 'samples/sliders/vertical_range_slider/customization/shape_customization/vertical_range_slider_shape_customization.dart';
import 'samples/sliders/vertical_range_slider/customization/size_customization/vertical_range_slider_size_customization.dart';
import 'samples/sliders/vertical_range_slider/customization/thumb_customization/vertical_range_slider_thumb_icon_customization.dart';
import 'samples/sliders/vertical_range_slider/default_appearance/vertical_range_slider_date_time_label.dart';
import 'samples/sliders/vertical_range_slider/default_appearance/vertical_range_slider_default_appearance.dart';
import 'samples/sliders/vertical_range_slider/default_appearance/vertical_range_slider_divisor_label_tick.dart';
import 'samples/sliders/vertical_range_slider/default_appearance/vertical_range_slider_interval_selection.dart';
import 'samples/sliders/vertical_range_slider/default_appearance/vertical_range_slider_step.dart';
import 'samples/sliders/vertical_range_slider/default_appearance/vertical_range_slider_tooltip_position.dart';
import 'samples/sliders/vertical_slider/basic_features/default_vertical_slider.dart';
import 'samples/sliders/vertical_slider/basic_features/vertical_slider_date_interval.dart';
import 'samples/sliders/vertical_slider/basic_features/vertical_slider_divisor_label_tick.dart';
import 'samples/sliders/vertical_slider/basic_features/vertical_slider_step.dart';
import 'samples/sliders/vertical_slider/basic_features/vertical_slider_tooltip_position.dart';
import 'samples/sliders/vertical_slider/customization/color_customization/vertical_slider_color_customization.dart';
import 'samples/sliders/vertical_slider/customization/shape_customization/vertical_slider_shape_customization.dart';
import 'samples/sliders/vertical_slider/customization/size_customization/vertical_slider_size_customization.dart';
import 'samples/sliders/vertical_slider/customization/thumb_customization/vertical_slider_thumb_icon_customization.dart';
import 'samples/sparkline/axis_types.dart';
import 'samples/sparkline/chart_types.dart';
import 'samples/sparkline/customization.dart';
import 'samples/sparkline/live_update.dart';
import 'samples/sparkline/sparkline_in_grid.dart';
import 'samples/treemap/custom_background/custom_background.dart';
import 'samples/treemap/flat/flat.dart';
import 'samples/treemap/hierarchical/hierarchical.dart';
import 'samples/treemap/range_color_mapping/range_color_mapping.dart';
import 'samples/treemap/selection/selection.dart';
import 'samples/treemap/value_color_mapping/value_color_mapping.dart';
import 'samples/xlsio/attendance_tracker/attendance_tracker.dart';
import 'samples/xlsio/balance_sheet/balance_sheet.dart';
import 'samples/xlsio/expenses_report/expenses_report.dart';
import 'samples/xlsio/invoice/invoice.dart';
import 'samples/xlsio/yearly_sales/yearly_sales.dart';

/// Contains the output widget of sample
/// appropriate key and output widget mapped
Map<String, Function> getSampleWidget() {
  return <String, Function>{
    // cartesian charts
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
    'column_axis_crossing': (Key key) => ColumnAxisCrossingBaseValue(key),
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
    'area_axis_crossing': (Key key) => AreaAxisCrossingBaseValue(key),
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
    'default_datetime_category_axis': (Key key) => DateTimeCategoryDefault(key),
    'default_datetime_category_axis_label': (Key key) =>
        DateTimeCategoryLabel(key),
    'default_logarithmic_axis': (Key key) => LogarithmicAxisDefault(key),
    'inversed_logarithmic_axis': (Key key) => LogarithmicAxisInversed(key),
    'hilo_chart': (Key key) => HiloChart(key),
    'hilo_open_close_chart': (Key key) => HiloOpenCloseChart(key),
    'candle_chart': (Key key) => CandleChart(key),
    'axis_crossing': (Key key) => AxisCrossing(key),
    'positioning_axis_labels': (Key key) => LabelCustomization(key),
    'axis_animation': (Key key) => AxisAnimationDefault(key),
    'edgelabel_placement': (Key key) => EdgeLabel(key),
    'chart_maximum_label_width': (Key key) => ChartMaximumLabelWidth(key),
    'handling_label_collision': (Key key) => LabelAction(key),
    'multiple_axis_chart': (Key key) => MultipleAxis(key),
    'opposed_axes': (Key key) => NumericOpposed(key),
    'plot_band_recurrence': (Key key) => PlotBandRecurrence(key),
    'plot_band': (Key key) => PlotBandDefault(key),
    'box_whisker': (Key key) => BoxWhisker(key),
    'water_fall': (Key key) => WaterFall(key),
    'vertical_water_fall': (Key key) => VerticalWaterFall(key),

    //Series Features
    'series_animation': (Key key) => AnimationDefault(key),
    'chart_with_annotation': (Key key) => AnnotationWatermark(key),
    'chart_with_watermark': (Key key) => AnnotationDefault(key),
    'default_datalabels': (Key key) => DataLabelDefault(key),
    'datalabel_template': (Key key) => DataLabelTemplate(key),
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
    'selection_index': (Key key) => SelectionIndex(key),
    'default_tooltip': (Key key) => DefaultTooltip(key),
    'chart_with_trackball': (Key key) => DefaultTrackball(key),
    'chart_with_trackball_template': (Key key) => TrackballTemplate(key),
    'pinch_zooming': (Key key) => DefaultPanning(key),
    'selection_zooming': (Key key) => DefaultZooming(key),
    'zooming_with_custom_buttons': (Key key) => ButtonZooming(key),
    'tooltip_position': (Key key) => CartesianTooltipPosition(key),
    'tooltip_template': (Key key) => TooltipTemplate(key),
    'circular_selection': (Key key) => CircularSelection(key),
    'circular_dynamic_selection': (Key key) => DynamicCircularSelection(key),
    'pie_tooltip_position': (Key key) => PieTooltipPosition(key),
    'events': (Key key) => Events(key),
    'navigate_with_events': (Key key) => NavigationWithEvents(key),
    'chart_interactivity': (Key key) => InteractiveChart(key),
    'pagination': (Key key) => Pagination(key),
    'auto_scrolling': (Key key) => AutoScrollingChart(key),

    //Dynamic updates
    'add_remove_points': (Key key) => AddDataPoints(key),
    'add_remove_series': (Key key) => AddSeries(key),
    'real_time_spline_chart': (Key key) => LiveUpdate(key),
    'vertical_live_chart': (Key key) => VerticalLineLiveUpdate(key),
    'update_data_source': (Key key) => UpdateDataSource(key),
    'real_time_line_chart': (Key key) => LiveLineChart(key),

    //Exporting
    'exporting_chart': (Key key) => Export(key),
    'export_circular_chart': (Key key) => ExportCircular(key),
    'export_gauge': (Key key) => ExportGauge(key),

    //Data binding
    'local_list_data': (Key key) => LocalData(key),
    'local_json_data': (Key key) => JsonData(key),

    //On demand loading
    'infinite_scrolling': (Key key) => InfiniteScrolling(key),
    //Pie
    'default_pie_chart': (Key key) => PieDefault(key),
    'pie_with_grouping': (Key key) => PieGrouping(key),
    'pie_with_smart_labels': (Key key) => PieSmartLabels(key),
    'pie_with_various_radius': (Key key) => PieRadius(key),
    'semi_pie_chart': (Key key) => SemiPieChart(key),
    'pie_with_gradient': (Key key) => PieGradient(key),
    'pie_with_imageShader': (Key key) => PieImageShader(key),
    'pie_point_render_mode': (Key key) => PiePointRenderMode(key),
    //Doughnut
    'default_doughnut_chart': (Key key) => DoughnutDefault(key),
    'doughnut_with_center_elevation': (Key key) => DoughnutElevation(key),
    'doughnut_with_color_mapping': (Key key) => DoughnutCustomization(key),
    'doughnut_with_rounded_corners': (Key key) => DoughnutRounded(key),
    'semi_doughnut_chart': (Key key) => SemiDoughnutChart(key),
    'doughnut_with_gradient': (Key key) => DoughnutGradient(key),

    //Radialbar
    'customized_radialbar_chart': (Key key) => RadialBarCustomized(key),
    'default_radialbar_chart': (Key key) => RadialBarDefault(key),
    'radialbar_with_legend': (Key key) => RadialBarAngle(key),
    'radialbar_with_gradient': (Key key) => RadialBarGradient(key),

    //Funnel
    'default_funnel_chart': (Key key) => FunnelDefault(key),
    'funnel_with_legend': (Key key) => FunnelLegend(key),
    'funnel_with_smart_labels': (Key key) => FunnelSmartLabels(key),

    //Pyramid
    'default_pyramid_chart': (Key key) => PyramidDefault(key),
    'pyramid_with_legend': (Key key) => PyramidLegend(key),
    'pyramid_with_smart_labels': (Key key) => PyramidSmartLabels(key),

    //Sparkline
    'sparkline_series': (Key key) => SparklineSeriesTypes(key),
    'sparkline_axis': (Key key) => SparklineAxesTypes(key),
    'sparkline_customization': (Key key) => SparklineCustomization(key),
    'sparkline_grid': (Key key) => SparkLineGrid(key),
    'sparkline_live_update': (Key key) => SparklineLiveUpdate(key),

    // Calendar Samples
    'getting_started_calendar': (Key key) => GettingStartedCalendar(key),
    'recurrence_calendar': (Key key) => RecurrenceCalendar(key),
    'agenda_view_calendar': (Key key) => AgendaViewCalendar(key),
    'appointment_editor_calendar': (Key key) => CalendarAppointmentEditor(key),
    'customization_calendar': (Key key) => CustomizationCalendar(key),
    'special_regions_calendar': (Key key) => SpecialRegionsCalendar(key),
    'schedule_view_calendar': (Key key) => ScheduleViewCalendar(key),
    'shift_scheduler': (Key key) => ShiftScheduler(key),
    'timeline_views_calendar': (Key key) => TimelineViewsCalendar(key),
    'heat_map_calendar': (Key key) => HeatMapCalendar(key),
    'air_fare_calendar': (Key key) => AirFareCalendar(key),
    'loadmore_calendar': (Key key) => LoadMoreCalendar(key),

    // Date picker Samples
    'getting_started_date_picker': (Key key) => GettingStartedDatePicker(key),
    'hijri_calendar_date_picker': (Key key) => HijriDatePicker(key),
    'blackout_picker': (Key key) => BlackoutDatePicker(key),
    'customized_picker': (Key key) => CustomizedDatePicker(key),
    'popup_picker': (Key key) => PopUpDatePicker(key),
    'vertical_calendar': (Key key) => VerticalCalendar(key),

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
    'radial_pointerdragging': (Key key) => RadialSliderExample(key),
    'radial_slider': (Key key) => RadialRangeSliderExample(key),
    'multiple_needle': (Key key) => MultipleNeedleExample(key),
    'range_pointer': (Key key) => RangePointerExample(key),
    'radial_marker': (Key key) => MarkerPointerExample(key),
    'text_pointer': (Key key) => RadialTextPointer(key),
    'radial_widget_pointer': (Key key) => WidgetPointerExample(key),
    'multiple_ranges': (Key key) => MultipleRangesExample(key),
    'range_datalabels': (Key key) => RangeDataLabelExample(key),
    'range_thickness': (Key key) => RangeThicknessExample(key),
    'clock_sample': (Key key) => ClockExample(key),

    'distance_tracker': (Key key) => DistanceTrackerExample(key),
    'gauge_overview': (Key key) => GaugeTemperatureMonitorExample(key),
    'gauge_compass': (Key key) => GaugeCompassExample(key),

    // Linear gauge
    'axis_track': (Key key) => AxisTrack(key),
    'ticks_customization': (Key key) => TickCustomization(key),
    'label_customization': (Key key) => GaugeLabelCustomization(key),
    'shape_pointer': (Key key) => ShapePointer(key),
    'bar_pointer': (Key key) => BarPointer(key),
    'widget_pointer': (Key key) => WidgetPointer(key),
    'custom_range': (Key key) => RangeCustomization(key),
    'battery_indicator': (Key key) => BatteryIndicator(key),
    'progress_bar': (Key key) => ProgressBar(key),
    'volume_settings': (Key key) => VolumeSettings(key),
    'sleep_watch': (Key key) => SleepWatch(key),
    'task_tracker': (Key key) => TaskTracking(key),
    'steps_counter': (Key key) => StepsCounter(key),
    'height_calculator': (Key key) => HeightCalculator(key),
    'water_indicator': (Key key) => WaterLevelIndicator(key),
    'thermometer': (Key key) => Thermometer(key),
    'heat_meter': (Key key) => HeatMeter(key),
    'api_gauge': (Key key) => ApiCustomization(key),

    // PDF samples
    'invoice': (Key key) => InvoicePdf(key),
    'certificate': (Key key) => CourseCompletionCertificatePdf(key),
    'header_and_footer': (Key key) => HeaderAndFooterPdf(key),
    'annotations': (Key key) => AnnotationsPdf(key),
    'text_extraction': (Key key) => TextExtractionPdf(key),
    'find_text': (Key key) => FindTextPdf(key),
    'encryption': (Key key) => EncryptPdf(key),
    'conformance': (Key key) => ConformancePdf(key),
    'form': (Key key) => FormFillingPdf(key),
    'digital_signature': (Key key) => SignPdf(key),

    // PDF Viewer samples
    'pdf_viewer_getting_started': (Key key) => GettingStartedPdfViewer(key),
    'pdf_viewer_custom_toolbar': (Key key) => CustomToolbarPdfViewer(key),

    // XlsIO samples
    'expenses_report': (Key key) => ExpensesReportXlsIO(key),
    'invoice_excel': (Key key) => InvoiceXlsIO(key),
    'yearly_sales': (Key key) => YearlySalesXlsIO(key),
    'balance_sheet': (Key key) => BalanceSheetXlsIO(key),
    'attendance_tracker': (Key key) => AttendanceTrackerXlsIO(key),

    // Barcode samples
    'one_dimensional_types': (Key key) => OneDimensionalBarcodes(key: key),

    'qr_code_generator': (Key key) => QRCodeGenerator(key),

    'data_matrix_generator': (Key key) => DataMatrixGenerator(key),

    // Slider Samples
    'default_slider': (Key key) => DefaultSliderPage(key),

    'slider_date_interval': (Key key) => DateIntervalSliderPage(key),

    'slider_tooltip_type': (Key key) => SliderTooltipTypeSliderPage(key),

    'slider_step': (Key key) => StepSliderPage(key),

    'thumb_icon_customization': (Key key) => ThumbCustomizationSliderPage(key),

    'slider_size_customization': (Key key) => SliderSizeCustomizationPage(key),

    'slider_divisor_label_tick': (Key key) => SliderLabelCustomizationPage(key),

    'slider_color_customization': (Key key) =>
        SliderColorCustomizationPage(key),

    'slider_shape_customization': (Key key) => ShapeCustomizedSliderPage(key),

    // Range Slider Samples
    'range_slider_default_appearance': (Key key) => DefaultRangeSliderPage(key),

    'range_slider_divisor_label_tick': (Key key) => ScaleRangeSliderPage(key),

    'range_slider_date_time_label': (Key key) => DateRangeSliderPage(key),

    'color_customization': (Key key) => ColorCustomizedRangeSliderPage(key),

    'shape_customization': (Key key) => ShapeCustomizedRangeSliderPage(key),

    'range_slider_thumb_icon_customization': (Key key) =>
        ThumbCustomizationRangeSliderPage(key),

    'range_slider_tooltip_type': (Key key) => TooltipRangeSliderPage(key),

    'range_slider_step': (Key key) => SliderStepDurationPage(key),

    'range_slider_interval_selection': (Key key) =>
        RangeSliderIntervalSelectionPage(key),

    'size_customization': (Key key) => SfRangeSliderSizeCustomizationPage(key),

    //Vertical Slider samples
    'default_vertical_slider': (Key key) => DefaultVerticalSliderPage(key),

    'vertical_slider_date_interval': (Key key) =>
        VerticalDateIntervalSliderPage(key),

    'vertical_slider_divisor_label_tick': (Key key) =>
        VerticalSliderLabelCustomizationPage(key),

    'vertical_slider_step': (Key key) => VerticalStepSliderPage(key),

    'vertical_slider_tooltip_position': (Key key) =>
        VerticalSliderTooltipTypeSliderPage(key),

    'vertical_slider_color_customization': (Key key) =>
        VerticalSliderColorCustomizationPage(key),

    'vertical_slider_size_customization': (Key key) =>
        VerticalSliderSizeCustomizationPage(key),

    'vertical_thumb_icon_customization': (Key key) =>
        VerticalThumbCustomizationSliderPage(key),

    'vertical_slider_shape_customization': (Key key) =>
        VerticalShapeCustomizedSliderPage(key),

    //Vertical Range Slider Samples

    'vertical_range_slider_default_appearance': (Key key) =>
        VerticalDefaultRangeSliderPage(key),

    'vertical_range_slider_divisor_label_tick': (Key key) =>
        VerticalScaleRangeSliderPage(key),

    'vertical_range_slider_date_time_label': (Key key) =>
        VerticalDateRangeSliderPage(key),

    'vertical_range_slider_step': (Key key) =>
        VerticalSliderStepDurationPage(key),

    'vertical_range_slider_interval_selection': (Key key) =>
        VerticalRangeSliderIntervalSelectionPage(key),

    'vertical_range_slider_tooltip_position': (Key key) =>
        VerticalTooltipRangeSliderPage(key),

    'vertical_range_slider_thumb_icon_customization': (Key key) =>
        VerticalThumbCustomizationRangeSliderPage(key),

    'vertical_range_slider_color_customization': (Key key) =>
        VerticalColorCustomizedRangeSliderPage(key),

    'vertical_range_slider_shape_customization': (Key key) =>
        VerticalShapeCustomizedRangeSliderPage(key),

    'vertical_range_slider_size_customization': (Key key) =>
        VerticalSfRangeSliderSizeCustomizationPage(key),

    // Range Selector Samples
    'range_selector_default_appearance': (Key key) =>
        DefaultRangeSelectorPage(key),

    'range_selector_with_selection': (Key key) =>
        RangeSelectorSelectionPage(key),

    'range_selector_with_zooming': (Key key) => RangeSelectorZoomingPage(key),

    'range_selector_with_histogram_chart': (Key key) =>
        RangeSelectorHistogramChartPage(key),

    'range_selector_with_bar_chart': (Key key) =>
        RangeSelectorBarChartPage(key),

    //dataGridSample
    'getting_started_datagrid': (Key key) => GettingStartedDataGrid(key: key),

    'column_types_datagrid': (Key key) => ColumnTypeDataGrid(key: key),

    'custom_header_datagrid': (Key key) => CustomHeaderDataGrid(key: key),

    'selection_datagrid': (Key key) => SelectionDataGrid(key: key),

    'styling_datagrid': (Key key) => StylingDataGrid(key: key),

    'row_height_datagrid': (Key key) => RowHeightDataGrid(key: key),

    'conditional_styling_datagrid': (Key key) =>
        ConditionalStylingDataGrid(key: key),

    'paging_datagrid': (Key key) => PagingDataGrid(key: key),

    'real_time_update_datagrid': (Key key) => RealTimeUpdateDataGrid(key: key),

    'json_data_source_datagrid': (Key key) => JsonDataSourceDataGrid(key: key),

    'list_data_source_datagrid': (Key key) => ListDataSourceDataGrid(key: key),

    'freeze_panes_datagrid': (Key key) => FreezePanesDataGrid(key: key),

    'sorting_datagrid': (Key key) => SortingDataGrid(key: key),

    'stacked_header_datagrid': (Key key) => StackedHeaderDataGrid(key: key),

    'load_more_infinite_scrolling_datagrid': (Key key) =>
        LoadMoreInfiniteScrollingDataGrid(key: key),

    'load_more_datagrid': (Key key) => LoadMoreDataGrid(key: key),

    'pull_to_refresh_datagrid': (Key key) => PullToRefreshDataGrid(key: key),

    'swiping_datagrid': (Key key) => SwipingDataGrid(key: key),

    // Maps: Shape Layer Samples
    'range_color_mapping': (Key key) => MapRangeColorMappingPage(key),

    'equal_color_mapping': (Key key) => MapEqualColorMappingPage(key),

    'bubble': (Key key) => MapBubblePage(key),

    'selection': (Key key) => MapSelectionPage(key),

    'marker': (Key key) => MapMarkerPage(key),

    'legend': (Key key) => MapLegendPage(key),

    'tooltip': (Key key) => MapTooltipPage(key),

    'zooming': (Key key) => MapZoomingPage(key),

    'sublayer': (Key key) => MapSublayerPage(key),

    // Maps: Tile Layer Samples
    'open_street_map': (Key key) => MapOSMPage(key),

    'bing_map': (Key key) => MapBingPage(key),

    'arcs': (Key key) => MapArcsPage(key),

    'polylines': (Key key) => MapPolylinesPage(key),

    'polygon': (Key key) => MapPolygonPage(key),

    // SignaturePad
    'signature_pad_getting_started': (Key key) =>
        GettingStartedSignaturePad(key),

    // Circular progress bar
    'progress_bar_types': (Key key) => ProgressBarTypes(key),
    'progress_bar_determinate_styles': (Key key) =>
        ProgressBarDeterminateStyle(key),
    'progress_bar_segment_styles': (Key key) => ProgressBarSegmentStyle(key),
    'progress_bar_track_with_markers': (Key key) =>
        ProgressBarTrackWithMarker(key),
    'progress_bar_custom_labels': (Key key) => ProgressBarCustomLabels(key),
    'progress_bar_angles': (Key key) => ProgressBarAngles(key),

    //Radial Slider
    'radial_slider_angles': (Key key) => RadialSliderAngles(key),
    'radial_slider_ticks_and_labels': (Key key) => RadialSliderLabelsTicks(key),
    'radial_slider_state': (Key key) => RadialSliderStateTypes(key),
    'radial_slider_custom_text': (Key key) => RadialSliderCustomText(key),
    'radial_slider_gradient': (Key key) => RadialSliderGradient(key),
    'radial_slider_styles': (Key key) => RadialSliderStyles(key),
    'radial_slider_thumb': (Key key) => RadialSliderThumb(key),

    //Radial Range Slider
    'radial_range_slider_angles': (Key key) => RadialRangeSliderAngles(key),
    'radial_range_slider_ticks_and_labels': (Key key) =>
        RadialRangeSliderLabelsTicks(key),
    'radial_range_slider_state': (Key key) => RadialRangeSliderStateTypes(key),
    'radial_range_slider_custom_text': (Key key) =>
        RadialRangeSliderCustomText(key),
    'radial_range_slider_gradient': (Key key) => RadialRangeSliderGradient(key),
    'radial_range_slider_styles': (Key key) => RadialRangeSliderStyles(key),
    'radial_range_slider_thumb': (Key key) => RadialRangeSliderThumb(key),

    //Treemap
    'squarified_treemap_flat': (Key key) =>
        TreemapLayoutSample(key, LayoutType.squarified),
    'slice_treemap_flat': (Key key) =>
        TreemapLayoutSample(key, LayoutType.slice),
    'dice_treemap_flat': (Key key) => TreemapLayoutSample(key, LayoutType.dice),
    'squarified_treemap_hierarchical': (Key key) =>
        HierarchicalTreemapSample(key),
    'squarified_range_color_mapping': (Key key) =>
        TreemapRangeColorMappingSample(key),
    'squarified_value_color_mapping': (Key key) =>
        TreemapValueColorMappingSample(key),
    'squarified_treemap_custom_background': (Key key) =>
        TreemapCustomBackgroundSample(key),
    'squarified_treemap_selection': (Key key) => TreemapSelectionSample(key),
  };
}
