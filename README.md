
# Syncfusion Flutter Examples

This repository contains the demos of Syncfusion Flutter UI widgets. This is the best place to check our widgets to get more insight about the usage of APIs. You can also check our widgets by installing the [sample browser application](https://play.google.com/store/apps/details?id=com.syncfusion.flutter.examples&hl=en) from Google Play Store, in which you can browse the demos for all the available widgets and view the source code of each example within the app itself.

<img src="https://cdn.syncfusion.com/content/images/flutter-widgets-collage.png"/>


## Table of contents
- [Requirements to run the demo](#requirements-to-run-the-demo)
- [Repository structure](#repository-structure)
- [Widgets catalog](#widgets-catalog)
- [How to run this project](#how-to-run-this-project)
- [Get the demo application](#get-the-demo-application)
- [Useful links](#useful-links)
- [Support and feedback](#support-and-feedback)
- [About Syncfusion](#about-syncfusion)


## <a name="requirements-to-run-the-demo"></a>Requirements to run the demo ##

* [Flutter SDK](https://flutter.dev/docs/get-started/install)
* [Android studio](https://developer.android.com/studio/install) or [Visual studio code](https://code.visualstudio.com/download)
* Install Flutter extension in Android studio or in [VS code](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)

## <a name="repository-structure"></a>Repository structure ##

This repository contains sample browser project. Each widgets sample will be found inside the lib/samples folder. Run this project to see the demo samples of all the Flutter widgets in single application.

## <a name="widgets-catalog"></a>Widgets catalog ##

| Samples | Package | Description |
|---------|----------|-------------|
| <b>DATA VISUALIZATION</b> |
| [Cartesian Charts](https://github.com/syncfusion/flutter-examples/tree/master/lib/samples/chart/cartesian_charts) | [syncfusion_flutter_charts](https://pub.dev/packages/syncfusion_flutter_charts) | Plot over 30 chart types ranging from line charts to financial charts. |
| [Circular Charts](https://github.com/syncfusion/flutter-examples/tree/master/lib/samples/chart/circular_charts) | [syncfusion_flutter_charts](https://pub.dev/packages/syncfusion_flutter_charts) | Visualize the data using pie, doughnut, and radial bar charts. |
| [Pyramid Chart](https://github.com/syncfusion/flutter-examples/tree/master/lib/samples/chart/pyramid_charts) | [syncfusion_flutter_charts](https://pub.dev/packages/syncfusion_flutter_charts) | Visualize the organized data using pyramid chart. |
| [Funnel Chart](https://github.com/syncfusion/flutter-examples/tree/master/lib/samples/chart/funnel_charts) | [syncfusion_flutter_charts](https://pub.dev/packages/syncfusion_flutter_charts) | Visualize the sequential data using funnel chart. |
| [Radial Gauge](https://github.com/syncfusion/flutter-examples/tree/master/lib/samples/gauge) | [syncfusion_flutter_gauges](https://pub.dev/packages/syncfusion_flutter_gauges) | Visualize one or multiple measures on a circular scale with pointers and ranges. |
| [Barcodes](https://github.com/syncfusion/flutter-examples/tree/master/lib/samples/barcodes) | [syncfusion_flutter_barcodes](https://pub.dev/packages/syncfusion_flutter_barcodes) | Generate and display data in machine-readable 1D and 2D barcodes. |
| [Maps](https://github.com/syncfusion/flutter-examples/tree/master/lib/samples/maps) | [syncfusion_flutter_maps](https://pub.dev/packages/syncfusion_flutter_maps) | Easily visualize data over a geographical area. |
| [Circular ProgressBar](https://github.com/syncfusion/flutter-examples/tree/master/lib/samples/progress_bar) | [syncfusion_flutter_gauges](https://pub.dev/packages/syncfusion_flutter_gauges) | Designed using Radial Gauge widget. Indicates the progress of a task with customizable visuals. |
| <b>GRIDS</b> |
| [DataGrid](https://github.com/syncfusion/flutter-examples/tree/master/lib/samples/datagrid) | [syncfusion_flutter_datagrid](https://pub.dev/packages/syncfusion_flutter_datagrid) | Displays large amounts of data with different data types in a tabular view |
| <b>CALENDAR<b/> |
| [Event Calendar](https://github.com/syncfusion/flutter-examples/tree/master/lib/samples/calendar) | [syncfusion_flutter_calendar](https://pub.dev/packages/syncfusion_flutter_calendar) | Allows you to easily visualize and schedule appointments. |
| [Date Range Picker](https://github.com/syncfusion/flutter-examples/tree/master/lib/samples/date_picker) | [syncfusion_flutter_datepicker](https://pub.dev/packages/syncfusion_flutter_datepicker) | Allows to easily select dates or range of dates. |
| <b>VIEWER</b> |
| [PDF Viewer](https://github.com/syncfusion/flutter-examples/tree/master/lib/samples/pdf_viewer) | [syncfusion_flutter_pdfviewer](https://pub.dev/packages/syncfusion_flutter_pdfviewer) | View the PDF document seamlessly and efficiently |
| <b>FILE FORMATS</b> |
| [PDF](https://github.com/syncfusion/flutter-examples/tree/master/lib/samples/pdf) | [syncfusion_flutter_pdf](https://pub.dev/packages/syncfusion_flutter_pdf) | Create PDF document with text, images and tables. |
| [XlsIO](https://github.com/syncfusion/flutter-examples/tree/master/lib/samples/xlsio) | [syncfusion_flutter_xlsio](https://pub.dev/packages/syncfusion_flutter_xlsio) | Create Excel documents with text, numbers, cell formatting, formulas, charts, images, and more. |
| <b>SLIDERS</b> |
| [Slider](https://github.com/syncfusion/flutter-examples/tree/master/lib/samples/sliders/slider) | [syncfusion_flutter_sliders](https://pub.dev/packages/syncfusion_flutter_sliders) | Select a date or numeric value. |
| [Range Slider](https://github.com/syncfusion/flutter-examples/tree/master/lib/samples/sliders/range_slider) | [syncfusion_flutter_sliders](https://pub.dev/packages/syncfusion_flutter_sliders) | Select a date or numeric range. |
| [Range Selector](https://github.com/syncfusion/flutter-examples/tree/master/lib/samples/sliders/range_selector) | [syncfusion_flutter_sliders](https://pub.dev/packages/syncfusion_flutter_sliders) | Visualize data and select a date or numeric range. |
| <b>SIGNATURE PAD</b> |
| [Signature Pad](https://github.com/syncfusion/flutter-examples/tree/master/lib/samples/signature_pad) | [syncfusion_flutter_signaturepad](https://pub.dev/packages/syncfusion_flutter_signaturepad) | Captures the signature and save it as an image to sync across devices and documents. |

## <a name="how-to-run-this-project"></a>How to run this project ##

**Step 1**

Download or clone the [flutter-examples](https://github.com/syncfusion/flutter-examples) repository into your machine.

**Step 2**

Run the following command to get the required packages.

```dart
$ flutter pub get
```

**Step 3**

Run your application either using `F5` or `Run > Start Debugging`.

## <a name="get-the-demo-application"></a>Get the demo application ##

Explore the full capabilities of our Flutter widgets on your device by installing our sample browser applications from the below app stores, and view samples code in GitHub.

<p align="center">
  <a href="https://play.google.com/store/apps/details?id=com.syncfusion.flutter.examples"><img src="https://cdn.syncfusion.com/content/images/FTControl/google-play.png"/></a>
  <a href="https://apps.apple.com/us/app/syncfusion-flutter-ui-widgets/id1475231341"><img src="https://cdn.syncfusion.com/content/images/FTControl/apple-button.png"/></a>
  </p>
  <p align="center">
  <a href="https://flutter.syncfusion.com"><img src="https://cdn.syncfusion.com/content/images/FTControl/web_sample_browser.png"/></a>  
</p>

## <a name="useful-links"></a>Useful links ##
Take a look at the following to learn more about Syncfusion Flutter widgets:

* [Syncfusion Flutter product page](https://www.syncfusion.com/flutter-widgets)
* [User guide documentation](https://help.syncfusion.com/flutter/introduction/overview)
* [API reference](https://help.syncfusion.com/flutter/introduction/api-reference)
* [Source](https://github.com/syncfusion/flutter-widgets)
* [Knowledge base](https://www.syncfusion.com/kb/flutter)
* [Video tutorials](https://www.syncfusion.com/tutorial-videos/flutter)

## <a name="support-and-feedback"></a>Support and feedback ##

* For any other queries, reach our [Syncfusion support team](https://www.syncfusion.com/support/directtrac/incidents/newincident) or post the queries through the [Community forums](https://www.syncfusion.com/forums) and submit a feature request or a bug through our [Feedback portal](https://www.syncfusion.com/feedback/flutter).
* To renew the subscription, click [renew](https://www.syncfusion.com/sales/products) or contact our sales team at salessupport@syncfusion.com | Toll Free: 1-888-9 DOTNET.

## <a name="about-syncfusion"></a>About Syncfusion

Founded in 2001 and headquartered in Research Triangle Park, N.C., Syncfusion has more than 20,000 customers and more than 1 million users, including large financial institutions, Fortune 500 companies, and global IT consultancies.

Today we provide 1,000+ controls and frameworks for web ([ASP.NET Core](https://www.syncfusion.com/aspnet-core-ui-controls), [ASP.NET MVC](https://www.syncfusion.com/aspnet-mvc-ui-controls), [ASP.NET WebForms](https://www.syncfusion.com/jquery/aspnet-web-forms-ui-controls), [JavaScript](https://www.syncfusion.com/javascript-ui-controls), [Angular](https://www.syncfusion.com/angular-ui-components), [React](https://www.syncfusion.com/react-ui-components), [Vue](https://www.syncfusion.com/vue-ui-components), and [Blazor](https://www.syncfusion.com/blazor-components), mobile ([Xamarin](https://www.syncfusion.com/xamarin-ui-controls), [Flutter](https://www.syncfusion.com/flutter-widgets), [UWP](https://www.syncfusion.com/uwp-ui-controls), and [JavaScript](https://www.syncfusion.com/javascript-ui-controls)), and desktop development ([WinForms](https://www.syncfusion.com/winforms-ui-controls), [WPF](https://www.syncfusion.com/wpf-ui-controls), and [UWP](https://www.syncfusion.com/uwp-ui-controls)). We provide ready-to deploy enterprise software for dashboards, reports, data integration, and big data processing. Many customers have saved millions in licensing fees by deploying our software.
