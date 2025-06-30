import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// ignore: directives_ordering
import 'package:google_generative_ai/google_generative_ai.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';
import '../../helper/ai_pop_up_api_key.dart';

///Renders default Line series Chart.
class DataPreProcessingSample extends SampleView {
  const DataPreProcessingSample(Key key) : super(key: key);

  @override
  _DataPreProcessingSampleState createState() =>
      _DataPreProcessingSampleState();
}

class _DataPreProcessingSampleState extends SampleViewState
    with SingleTickerProviderStateMixin {
  _DataPreProcessingSampleState();

  late ChatSession _chat;

  late AnimationController _controller;
  late Animation<double> _animation;

  bool _isPressed = false;
  bool _isLoading = false;
  List<_ChartData>? _demoData;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true); // Repeats the animation back and forth

    // Define the animation
    _animation = Tween<double>(
      begin: 0.8,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _demoData = <_ChartData>[
      _ChartData(DateTime(2024, 07), 150),
      _ChartData(DateTime(2024, 07, 01, 01), 160),
      _ChartData(DateTime(2024, 07, 01, 02), 155),
      _ChartData(DateTime(2024, 07, 01, 03), null),
      _ChartData(DateTime(2024, 07, 01, 04), 170),
      _ChartData(DateTime(2024, 07, 01, 05), 175),
      _ChartData(DateTime(2024, 07, 01, 06), 145),
      _ChartData(DateTime(2024, 07, 01, 07), 180),
      _ChartData(DateTime(2024, 07, 01, 08), null),
      _ChartData(DateTime(2024, 07, 01, 09), 185),
      _ChartData(DateTime(2024, 07, 01, 10), 200),
      _ChartData(DateTime(2024, 07, 01, 11), null),
      _ChartData(DateTime(2024, 07, 01, 12), 220),
      _ChartData(DateTime(2024, 07, 01, 13), 230),
      _ChartData(DateTime(2024, 07, 01, 14), null),
      _ChartData(DateTime(2024, 07, 01, 15), 250),
      _ChartData(DateTime(2024, 07, 01, 16), 260),
      _ChartData(DateTime(2024, 07, 01, 17), 270),
      _ChartData(DateTime(2024, 07, 01, 18), null),
      _ChartData(DateTime(2024, 07, 01, 19), 280),
      _ChartData(DateTime(2024, 07, 01, 20), 250),
      _ChartData(DateTime(2024, 07, 01, 21), 290),
      _ChartData(DateTime(2024, 07, 01, 22), 300),
      _ChartData(DateTime(2024, 07, 01, 23), null),
    ];

    // Show the dialog when the app starts.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (model.isFirstTime) {
        showDialog(
          context: context,
          builder: (context) => WelcomeDialog(
            primaryColor: model.primaryColor,
            apiKey: model.assistApiKey,
            onApiKeySaved: (newApiKey) {
              setState(() {
                model.assistApiKey = newApiKey;
              });
            },
          ),
        );
        model.isFirstTime = false;
      }
    });
  }

  Future<void> _loadNewData() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) {
      return;
    }
    if (model.assistApiKey.isNotEmpty) {
      final String prompt = _generatePrompt();
      _sendChatMessage(prompt, model.assistApiKey);
    } else {
      _demoData = <_ChartData>[
        _ChartData(DateTime(2024, 07), 150),
        _ChartData(DateTime(2024, 07, 01, 01), 160),
        _ChartData(DateTime(2024, 07, 01, 02), 155, const Color(0xFFD84227)),
        _ChartData(DateTime(2024, 07, 01, 03), 162, const Color(0xFFD84227)),
        _ChartData(DateTime(2024, 07, 01, 04), 170),
        _ChartData(DateTime(2024, 07, 01, 05), 175),
        _ChartData(DateTime(2024, 07, 01, 06), 145),
        _ChartData(DateTime(2024, 07, 01, 07), 180, const Color(0xFFD84227)),
        _ChartData(DateTime(2024, 07, 01, 08), 182, const Color(0xFFD84227)),
        _ChartData(DateTime(2024, 07, 01, 09), 185),
        _ChartData(DateTime(2024, 07, 01, 10), 200, const Color(0xFFD84227)),
        _ChartData(DateTime(2024, 07, 01, 11), 207, const Color(0xFFD84227)),
        _ChartData(DateTime(2024, 07, 01, 12), 220),
        _ChartData(DateTime(2024, 07, 01, 13), 230, const Color(0xFFD84227)),
        _ChartData(DateTime(2024, 07, 01, 14), 237, const Color(0xFFD84227)),
        _ChartData(DateTime(2024, 07, 01, 15), 250),
        _ChartData(DateTime(2024, 07, 01, 16), 260),
        _ChartData(DateTime(2024, 07, 01, 17), 270, const Color(0xFFD84227)),
        _ChartData(DateTime(2024, 07, 01, 18), 277, const Color(0xFFD84227)),
        _ChartData(DateTime(2024, 07, 01, 19), 280),
        _ChartData(DateTime(2024, 07, 01, 20), 250),
        _ChartData(DateTime(2024, 07, 01, 21), 290),
        _ChartData(DateTime(2024, 07, 01, 22), 300, const Color(0xFFD84227)),
        _ChartData(DateTime(2024, 07, 01, 23), 307, const Color(0xFFD84227)),
      ];
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if the device is mobile or web (based on screen width).
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    // If it's a mobile device, execute the mobile-specific layout.
    if (isMobile) {
      return _buildMobileLayout();
    } else {
      // If it's a web device (or larger screen), execute the web-specific layout.
      return _buildWebLayout();
    }
  }

  Widget _buildMobileLayout() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Stack(
        children: [
          Column(
            children: [
              // Two Text widgets in the center.
              _buildTitleWidget(),
              // Expanded widget for the chart and loading indicator.
              Expanded(
                child: Stack(
                  children: [
                    _buildCartesianChart(),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator()),
                    // Floating Action Button at the top.
                    _buildAIButton(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWebLayout() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Stack(
        children: [
          // Floating Action Button at the top
          _buildAIButton(),
          Column(
            children: [
              // Two Text widgets in the center
              _buildTitleWidget(),
              // Expanded widget for the chart and loading indicator
              Expanded(
                child: Stack(
                  children: [
                    _buildCartesianChart(),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Align _buildAIButton() {
    return Align(
      alignment: Alignment.topRight,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (BuildContext context, Widget? child) {
          return Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
            child: Transform.scale(
              scale: _isPressed ? 1 : _animation.value,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: model.primaryColor,
                onPressed: () {
                  _isPressed = true;
                  _loadNewData();
                },
                child: Image.asset(
                  'images/ai_assist_view.png',
                  height: 30,
                  width: 40,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitleWidget() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'E-Commerce Website Traffic Data',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8), // Spacing between the text widgets
        Text(
          'AI powered data cleaning and preprocessing every hour, tracking hourly website visitors',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Return the Cartesian Chart with Line series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      legend: const Legend(isVisible: true, position: LegendPosition.top),
      primaryXAxis: DateTimeAxis(
        minimum: DateTime(2024, 07),
        maximum: DateTime(2024, 07, 01, 23),
        dateFormat: DateFormat('h a'),
        majorGridLines: const MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: const NumericAxis(minimum: 140, maximum: 320, interval: 30),
      series: _buildLineSeries(),
    );
  }

  /// Returns the list of Cartesian Line series.
  List<LineSeries<_ChartData, DateTime>> _buildLineSeries() {
    return <LineSeries<_ChartData, DateTime>>[
      LineSeries<_ChartData, DateTime>(
        dataSource: _demoData,
        xValueMapper: (_ChartData data, int index) => data.date,
        yValueMapper: (_ChartData data, int index) => data.visitors,
        pointColorMapper: (_ChartData data, int index) => data.color,
        animationDuration: 0,
        legendItemText: 'Visitors',
      ),
    ];
  }

  String _generatePrompt() {
    final String prompt =
        'Clean the following e-commerce website traffic data, resolve outliers and fill missing values:\n' +
        _demoData!
            .map(
              (d) =>
                  "${DateFormat('yyyy-MM-dd-HH-m-ss').format(d.date)}: ${d.visitors}",
            )
            .join('\n') +
        ' and the output cleaned data should be in the yyyy-MM-dd-HH-m-ss:Value format, no other explanation required\n';
    return prompt;
  }

  List<_ChartData> _convertAIResponseToChartData(String? data) {
    if (data == null || data.isEmpty) {
      return [];
    }
    var count = 0;
    Color? color;

    final List<_ChartData> aiData = [];
    for (final line in data.split('\n')) {
      final parts = line.split(':');
      if (parts.length == 2) {
        try {
          final date = DateFormat('yyyy-MM-dd-HH-m-ss').parse(parts[0].trim());
          final visitors = double.tryParse(parts[1].trim());
          if (visitors != null) {
            final bool isCurrDataNull = _demoData![count].visitors == null;
            final bool isNextDataNull =
                count + 1 < _demoData!.length &&
                _demoData![count + 1].visitors == null;
            color = isCurrDataNull || isNextDataNull
                ? const Color(0xFFD84227)
                : Colors.blue;
            aiData.add(_ChartData(date, visitors, color));
            count = count + 1;
          }
        } catch (e) {
          // Handle catch
        }
      }
    }

    return aiData;
  }

  Future<void> _sendChatMessage(String message, String apiKey) async {
    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash-8b',
        apiKey: apiKey,
      );
      _chat = model.startChat();
      final GenerateContentResponse response = await _chat.sendMessage(
        Content.text(message),
      );

      setState(() {
        _isLoading = false;

        _demoData = _convertAIResponseToChartData(response.text);
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    } finally {
      // Handle finally
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _demoData?.clear();
    _isPressed = false;
    _isLoading = false;
    super.dispose();
  }
}

class _ChartData {
  _ChartData(this.date, this.visitors, [this.color]);
  final DateTime date;
  final double? visitors;
  Color? color;
}
