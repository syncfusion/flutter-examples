import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Generative ai import
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

/// Local import.
import '../../../../model/sample_view.dart';
import '../../../helper/ai_pop_up_api_key.dart';
import 'smart_chart_ai_generator.dart';

class SmartAIChart extends SampleView {
  const SmartAIChart(Key? key) : super(key: key);

  @override
  SampleViewState createState() => _SmartAIChartState();
}

class _SmartAIChartState extends SampleViewState {
  final TextEditingController _textController = TextEditingController();
  final Key _chartKey = UniqueKey();
  String _jsonChartConfig = '';
  final String _defaultPlaceHolderText =
      'Describe what kind of chart you would like to create.';
  late String _placeHolderText = _defaultPlaceHolderText;
  late TextStyle _placeHolderTextStyle;
  bool _isSmartChart = false;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  Uint8List? _selectedImageBytes;

  void _navigateToSmartAIChart() {
    setState(() {
      _isSmartChart = true;
      _placeHolderText = _defaultPlaceHolderText;
      _placeHolderTextStyle = TextStyle(color: getThemeTextColor());
    });
  }

  void _navigationToHome() {
    setState(() {
      _isSmartChart = false;
      _placeHolderText = _defaultPlaceHolderText;
      _placeHolderTextStyle = TextStyle(
        color: getThemeTextColor().withValues(alpha: 0.5),
      );
    });
  }

  void _clearImage() {
    setState(() {
      _selectedImageBytes = null;
      _placeHolderText = _defaultPlaceHolderText;
      _placeHolderTextStyle = TextStyle(color: getThemeTextColor());
    });
  }

  Color getThemeTextColor() {
    return model.themeData.brightness == Brightness.dark
        ? const Color(0xFFFFFBFE)
        : const Color(0xFF1C1B1F);
  }

  Widget _buildSmartHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 25,
        children: [
          const _GradientText(
            'AI Powered Chart Generator',
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            textAlign: TextAlign.center,
          ),
          const Text(
            'Create a visually striking charts with simple text prompts, transforming complex data into captivating visual stories',
            style: TextStyle(fontSize: 15.0, color: Colors.blueGrey),
            textAlign: TextAlign.center,
          ),
          GradientBorder(
            width: 2.0,
            borderRadius: const Radius.circular(15.0),
            gradient: const LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            child: _buildPlaceholder(),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20.0,
            runSpacing: 20.0,
            runAlignment: WrapAlignment.center,
            children: _buildChildren(),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (_selectedImageBytes != null)
          Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 15.0,
                  ),
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Image.memory(
                    _selectedImageBytes!,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: 60,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      iconSize: 18,
                      color: Colors.white,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: !_isLoading
                          ? () {
                              setState(() {
                                _clearImage();
                              });
                            }
                          : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        TextField(
          maxLines: 5,
          minLines: 1,
          controller: _textController,
          enabled: !_isLoading,
          decoration: InputDecoration(
            hintText: _placeHolderText,
            hintStyle: _placeHolderTextStyle,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.only(left: 15, top: 25, right: 15),
          ),
        ),
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: model.themeData.focusColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.image),
                  iconSize: 20,
                  onPressed: !_isLoading
                      ? () async {
                          await _pickImage();
                        }
                      : null,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton.filled(
                    icon: const Icon(Icons.arrow_upward_rounded),
                    onPressed:
                        (_textController.text.isEmpty &&
                            _selectedImageBytes == null)
                        ? null
                        : () {
                            _handleActionButtonPressed(
                              _textController.text,
                              image: _selectedImageBytes,
                            );
                            _placeHolderText = _textController.text;
                            _textController.clear();
                          },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final XFile? selectedImage = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (selectedImage != null) {
      final bytes = await selectedImage.readAsBytes();
      setState(() {
        _selectedImageBytes = bytes;
        _placeHolderText = 'Type here...';
        _placeHolderTextStyle = TextStyle(color: getThemeTextColor());
      });
    }
  }

  List<Widget> _buildChildren() {
    final Color textColor = _isLoading
        ? model.themeData.disabledColor
        : model.themeData.brightness == Brightness.dark
        ? const Color(0xFFFFFBFE)
        : const Color(0xFF1C1B1F);
    return [
      _buildGradientButton(
        textColor,
        'Regional Sales Performance Metrics',
        'Regional Sales Performance Metrics',
        Icons.bar_chart,
      ),
      _buildGradientButton(
        textColor,
        'Customer Engagement in Social media Platforms',
        'Customer Engagement via Social Platforms',
        Icons.people,
      ),
      _buildGradientButton(
        textColor,
        'Market Trend Forecast Insights',
        'Market Trend Forecast Insights',
        Icons.assignment,
      ),
      _buildGradientButton(
        textColor,
        'Project Milestone Analysis',
        'Project Milestone Analysis',
        Icons.timeline,
      ),
    ];
  }

  Widget _buildGradientButton(
    Color textColor,
    String text,
    String alignText,
    IconData iconData,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        elevation: 0.0,
        alignment: Alignment.center,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        minimumSize: const Size(44, 44),
        backgroundColor: model.themeData.colorScheme.surfaceContainer,
      ),
      onPressed: !_isLoading
          ? () {
              _handleActionButtonPressed(text);
              setState(() {
                _placeHolderText = alignText;
                _placeHolderTextStyle = TextStyle(color: getThemeTextColor());
              });
            }
          : null,
      child: Row(
        spacing: 10.0,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(iconData, color: textColor, size: 20.0),
          Text(alignText, style: TextStyle(color: textColor)),
        ],
      ),
    );
  }

  Future<void> _generateResponse(String prompt, {Uint8List? image}) async {
    final GenerativeModel aiModel = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: model.assistApiKey,
    );

    final List<String> supportedChartTypes = [
      'line',
      'column',
      'area',
      'bar',
      'scatter',
      'bubble',
      'spline',
      'pie',
      'doughnut',
      'radialBar',
    ];

    if (image != null) {
      final imageParts = [DataPart('image/jpeg', image)];
      try {
        final GenerateContentResponse response = await aiModel.generateContent([
          Content.multi(imageParts),
        ]);

        if (response.text != null && response.text!.isNotEmpty) {
          prompt += response.text!;
        }
      } catch (err) {
        // Handle error by assigning the localResponse as a fallback
      }
    }

    prompt = prompt.toLowerCase();
    final String validationPrompt =
        '''
    Is the following user input intended to generate a chart or data visualization?

    If the input mentions a specific chart or series type (e.g., bar chart, pie, line series), only respond "yes" if it is included in the supported list: ${supportedChartTypes.join(", ")}.

    If no chart or series type is mentioned, just decide if the input implies a chart or data visualization (e.g., data, metrics, trends, analysis, forecasts).

    Respond with "yes" or "no" only — no explanations, no formatting.

    User input: "$prompt"
    ''';
    try {
      final validationResponse = await aiModel.generateContent([
        Content.text(validationPrompt),
      ]);

      final result = validationResponse.text?.toLowerCase().trim();
      if (result != 'yes') {
        _jsonChartConfig = '';
        return;
      }
    } catch (_) {
      // On error, assume invalid to be safe
      return;
    }

    final String updatedPrompt =
        """
    As an AI service, your task is to convert user inputs describing chart specifications into JSON formatted strings. Each user input will describe a specific chart type and its configurations, including axes titles, legend visibility, series configurations, etc. You will structure the output in JSON format accordingly.

    Example user input: "Sales by region column chart."
    Expected JSON output:
    '''
    {
    "chartType": "cartesian",
    "title": "Revenue Distribution by Region",
    "xAxis": {
      "title": "Region",
      "type": "CategoryAxis"
    },
    "yAxis": {
      "title": "Revenue",
      "type": "NumericAxis"
    },
    "visibleTooltip": "true",
    "visibleLegend": "true",
    "legendPosition": "top",
    "series": [
      {
        "type": "line",
        "dataSource": [
          {"xvalue": "North", "yvalue": 150},
          {"xvalue": "South", "yvalue": 200},
          {"xvalue": "East", "yvalue": 175},
          {"xvalue": "West", "yvalue": 225}
        ],
        "name": "Revenue",
        "xValueMapper": "xvalue",
        "yValueMapper": "yvalue",
        "visibleDataLabel": "true",
        "visibleMarker": "true"
      }
    ]
    }
    '''

    When generating the JSON output, take into account the following:
    1. Chart Type: Determine the type of chart based on keywords in the user query; it should be only circular or cartesian.
    2. Chart Title: Craft an appropriate title using key elements of the query.
    3. Axis Information: Define the x-axis and y-axis with relevant titles and types. Use categories for discrete data and numerical for continuous data.
    4. visibleTooltip: Allow the AI to determine its value unless specified in the query.
    5. visibleLegend: Allow the AI to determine its value unless specified in the query.
    6. legendPosition: Allow the AI to decide its position unless specified in the query.
    7. Series Configuration: Include details about the series type and data points as mentioned in the query. ** It supports only Line, Column, Spline, Area, Pie, Doughnut, RadialBar **.
    8. Name in the Series: The name of the series should represent the category of the series differentiate from chart and axis titles.
    9. Data Source: Provide a sample data source for the series, it should be named as "dataSource" and include "xvalue" and "yvalue" with their values always as a string and int respectively.
    10. visibleDataLabel: Allow the AI to determine its value unless specified in the query.
    11. visibleMarker: Allow the AI to determine its value unless specified in the query.

    Generate appropriate configurations according to these guidelines, and return the result as a JSON formatted string for any query shared with you.
    User Request: $prompt
    """;

    try {
      final GenerateContentResponse response = await aiModel.generateContent([
        Content.text(updatedPrompt),
      ]);

      if (response.text != null && response.text!.isNotEmpty) {
        _jsonChartConfig = response.text!;
      }
    } catch (err) {
      // Handle error by assigning the localResponse as a fallback
    }
  }

  Future<void> _handleActionButtonPressed(
    String prompt, {
    Uint8List? image,
  }) async {
    setState(() {
      _isLoading = true;
      _placeHolderTextStyle = TextStyle(color: getThemeTextColor());
    });
    await Future.delayed(const Duration(milliseconds: 1000));
    final bool isApiKeyMissing = model.assistApiKey.isEmpty;
    if (isApiKeyMissing) {
      _jsonChartConfig = _generateJsonData(prompt);
    } else {
      await _generateResponse(prompt, image: image);
    }
    if (!mounted) {
      return;
    }
    if (_jsonChartConfig.isNotEmpty) {
      _navigateToSmartAIChart();
      _isLoading = false;
      _clearImage();
    } else {
      if (mounted) {
        setState(() {
          _placeHolderText = isApiKeyMissing
              ? 'API key is missing. Please provide a valid API key to generate a response.'
              : 'Please provide a chart-related image or text description to generate a chart, check info for supported series types and features.';
          if (!isApiKeyMissing) {
            _placeHolderTextStyle = const TextStyle(color: Colors.red);
          }
          _isLoading = false;
        });
      }
    }
  }

  String _generateJsonData(String prompt) {
    if (prompt.contains('Regional Sales Performance Metrics')) {
      prompt = 'column';
    } else if (prompt.contains(
      'Customer Engagement in Social media Platforms',
    )) {
      prompt = 'pie';
    } else if (prompt.contains('Project Milestone Analysis')) {
      prompt = 'doughnut';
    } else if (prompt.contains('Market Trend Forecast Insights')) {
      prompt = 'bar';
    }
    prompt = prompt.toLowerCase();

    if (prompt.contains('bar')) {
      return '''
        {
          "chartType": "cartesian",
          "title": "Market Trend Forecast Insights",
          "xAxis": {
            "title": "Quarter",
            "type": "CategoryAxis"
          },
          "yAxis": {
            "title": "Forecasted Value",
            "type": "NumericAxis"
          },
          "visibleTooltip": "true",
          "visibleLegend": "true",
          "legendPosition": "top",
          "series": [
            {
              "type": "bar",
              "dataSource": [
                {"xvalue": "Q1", "yvalue": 70},
                {"xvalue": "Q2", "yvalue": 130},
                {"xvalue": "Q3", "yvalue": 60},
                {"xvalue": "Q4", "yvalue": 90}
              ],
              "name": "Forecasted Value",
              "xValueMapper": "xvalue",
              "yValueMapper": "yvalue",
              "visibleDataLabel": "true",
              "visibleMarker": "false"
            }
          ]
        }''';
    } else if (prompt.contains('column')) {
      return '''
        {
          "chartType": "cartesian",
          "title": "Regional Sales Performance Metrics",
          "xAxis": {
            "title": "Region",
            "type": "CategoryAxis"
          },
          "yAxis": {
            "title": "Sales",
            "type": "NumericAxis"
          },
          "visibleTooltip": "true",
          "visibleLegend": "true",
          "legendPosition": "top",
          "series": [
            {
              "type": "column",
              "dataSource": [
                {"xvalue": "North", "yvalue": 120},
                {"xvalue": "South", "yvalue": 180},
                {"xvalue": "East", "yvalue": 160},
                {"xvalue": "West", "yvalue": 210}
              ],
              "name": "Regional Sales",
              "xValueMapper": "xvalue",
              "yValueMapper": "yvalue",
              "visibleDataLabel": "true",
              "visibleMarker": "false"
            }
          ]
        }''';
    } else if (prompt.contains('area')) {
      return '''
        {
          "chartType": "cartesian",
          "title": "Regional Sales Performance Metrics",
          "xAxis": {
            "title": "Region",
            "type": "CategoryAxis"
          },
          "yAxis": {
            "title": "Sales",
            "type": "NumericAxis"
          },
          "visibleTooltip": "true",
          "visibleLegend": "true",
          "legendPosition": "top",
          "series": [
            {
              "type": "area",
              "dataSource": [
                {"xvalue": "North", "yvalue": 120},
                {"xvalue": "South", "yvalue": 180},
                {"xvalue": "East", "yvalue": 160},
                {"xvalue": "West", "yvalue": 210}
              ],
              "name": "Regional Sales",
              "xValueMapper": "xvalue",
              "yValueMapper": "yvalue",
              "visibleDataLabel": "true",
              "visibleMarker": "false"
            }
          ]
        }''';
    } else if (prompt.contains('pie')) {
      return '''
        {
          "chartType": "circular",
          "title": "Customer Engagement via Social Platforms",
          "visibleTooltip": "true",
          "visibleLegend": "true",
          "legendPosition": "top",
          "series": [
            {
              "type": "pie",
              "dataSource": [
                {"xvalue": "Facebook", "yvalue": 35},
                {"xvalue": "Instagram", "yvalue": 25},
                {"xvalue": "Twitter", "yvalue": 15},
                {"xvalue": "LinkedIn", "yvalue": 20},
                {"xvalue": "Others", "yvalue": 5}
              ],
              "name": "Customer Engagement",
              "xValueMapper": "xvalue",
              "yValueMapper": "yvalue",
              "visibleDataLabel": "true"
            }
          ]
        }''';
    } else if (prompt.contains('doughnut')) {
      return '''
        {
          "chartType": "circular",
          "title": "Project Milestone Analysis",
          "visibleTooltip": "true",
          "visibleLegend": "true",
          "legendPosition": "top",
          "series": [
            {
              "type": "doughnut",
              "dataSource": [
                {"xvalue": "Planning", "yvalue": 20},
                {"xvalue": "Design", "yvalue": 25},
                {"xvalue": "Development", "yvalue": 30},
                {"xvalue": "Testing", "yvalue": 15},
                {"xvalue": "Deployment", "yvalue": 10}
              ],
              "name": "Project Milestone",
              "xValueMapper": "xvalue",
              "yValueMapper": "yvalue",
              "visibleDataLabel": "true"
            }
          ]
        }''';
    }
    return '';
  }

  Widget _buildAIConfigurationSettings() {
    return Positioned(
      top: 2,
      right: 2,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          height: 40,
          width: 40,
          child: IconButton(
            tooltip: 'Configure AI',
            icon: const Icon(Icons.settings),
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color>(
                model.themeData.colorScheme.primary,
              ),
            ),
            onPressed: () {
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
            },
          ),
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final double screenWidth = MediaQuery.of(context).size.width;
        final double dialogWidth = screenWidth > 700 ? 500.0 : 300.0;
        final Color textColor = getThemeTextColor();

        return AlertDialog(
          content: SizedBox(
            width: dialogWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),
                Text(
                  'AI-Powered Chart Creation',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: model.primaryColor,
                  ),
                ),
                const SizedBox(height: 6.0),
                Text(
                  'Effortlessly create charts by describing them in natural language or by uploading an image.',
                  style: TextStyle(fontSize: 14, color: textColor, height: 1.5),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 14, color: textColor),
                    children: [
                      const TextSpan(
                        text: 'For example: ',
                        style: TextStyle(fontSize: 14),
                      ),
                      TextSpan(
                        text:
                            '“Create a doughnut chart showing 2024 Q3 metal sales in the USA.”',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Without a Google generative API key',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: model.primaryColor,
                  ),
                ),
                const SizedBox(height: 6.0),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor,
                      height: 1.5,
                    ),
                    children: const [
                      TextSpan(
                        text: '• Supported charts: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: 'Column, bar, area, pie, doughnut'),
                      TextSpan(text: '\n'),
                      TextSpan(
                        text: '• Features: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: 'Data source updates and legends'),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'With a Google generative API key',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: model.primaryColor,
                  ),
                ),
                const SizedBox(height: 6.0),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor,
                      height: 1.5,
                    ),
                    children: const [
                      TextSpan(
                        text: '• Supported charts: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            'Area, bar, bubble, column, doughnut, line, pie, radial bar and scatter',
                      ),
                      TextSpan(text: '.\n'),
                      TextSpan(
                        text: '• Features: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            'Data labels, data source updates, legends, tooltips',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfo() {
    return Positioned(
      top: 2,
      right: 40,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          height: 40,
          width: 40,
          child: IconButton(
            tooltip: 'Info',
            icon: const Icon(Icons.info_outline),
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color>(
                model.themeData.colorScheme.primary,
              ),
            ),
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _placeHolderTextStyle = TextStyle(
      color: getThemeTextColor().withValues(alpha: 0.5),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (model.isFirstTimeChartInfo) {
        _showInfoDialog(context);
        model.isFirstTimeChartInfo = false;
      }
    });

    _textController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isSmartChart
        ? ChartFromJson(
            key: _chartKey,
            jsonChartConfig: _jsonChartConfig,
            onBackPressed: _navigationToHome,
          )
        : Stack(
            children: [
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double availableWidth = constraints.maxWidth;
                  const double maxExpectedWidth = 850;
                  final bool canCenter = availableWidth > maxExpectedWidth;
                  return Padding(
                    padding: canCenter
                        ? const EdgeInsets.symmetric(vertical: 10.0)
                        : const EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 10.0),
                    child: Center(
                      child: SizedBox(
                        width: canCenter ? maxExpectedWidth : availableWidth,
                        child: _buildSmartHome(),
                      ),
                    ),
                  );
                },
              ),
              if (_isLoading)
                Center(
                  child: SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        padding: EdgeInsets.all(8.0),
                      ),
                    ),
                  ),
                ),
              _buildAIConfigurationSettings(),
              _buildInfo(),
            ],
          );
  }

  @override
  void dispose() {
    _isLoading = false;
    _isSmartChart = false;
    _jsonChartConfig = '';
    _placeHolderText = _defaultPlaceHolderText;
    _placeHolderTextStyle = TextStyle(color: getThemeTextColor());
    _selectedImageBytes = null;
    _textController.dispose();
    super.dispose();
  }
}

class _GradientText extends StatelessWidget {
  const _GradientText(
    this.text, {
    required this.gradient,
    this.style = const TextStyle(),
    this.textAlign = TextAlign.start,
  });

  final String text;
  final TextStyle style;
  final Gradient gradient;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) => gradient.createShader(
        Rect.fromLTWH(0.0, 0.0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: style.copyWith(color: Colors.white),
        textAlign: textAlign,
      ),
    );
  }
}

class GradientBorder extends SingleChildRenderObjectWidget {
  const GradientBorder({
    required this.gradient,
    required this.width,
    required this.borderRadius,
    required super.child,
  });

  final Gradient gradient;
  final double width;
  final Radius borderRadius;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderGradientBorder(
      gradient: gradient,
      width: width,
      borderRadius: borderRadius,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderGradientBorder renderObject,
  ) {
    renderObject
      ..gradient = gradient
      ..width = width
      ..borderRadius = borderRadius;
  }
}

class RenderGradientBorder extends RenderProxyBox {
  RenderGradientBorder({
    required Gradient gradient,
    required double width,
    required Radius borderRadius,
  }) : _gradient = gradient,
       _width = width,
       _borderRadius = borderRadius;

  Gradient? get gradient => _gradient;
  Gradient? _gradient;
  set gradient(Gradient? value) {
    if (_gradient != value) {
      _gradient = value;
      markNeedsPaint();
    }
  }

  double get width => _width;
  double _width = 1.0;
  set width(double value) {
    if (_width != value) {
      _width = value;
      markNeedsPaint();
    }
  }

  Radius get borderRadius => _borderRadius;
  Radius _borderRadius = Radius.zero;
  set borderRadius(Radius value) {
    if (_borderRadius != value) {
      markNeedsPaint();
      _borderRadius = value;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      context.paintChild(child!, offset);

      final Rect rect = offset & size;
      final Paint paint = Paint()
        ..shader = gradient!.createShader(rect)
        ..strokeWidth = width
        ..style = PaintingStyle.stroke;
      final RRect rrect = RRect.fromRectAndRadius(rect, borderRadius);
      context.canvas.drawRRect(rrect, paint);
    }
  }
}
