import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Treemap import.
import 'package:syncfusion_flutter_treemap/treemap.dart';

/// Local import.
import '../../../model/sample_view.dart';

/// The [SfTreemap]'s layout type.
enum LayoutType {
  /// slice layout.
  slice,

  /// dice layout.
  dice,

  /// squarified layout.
  squarified,
}

/// This sample demonstrates how to add a different layout in the treemap.
class TreemapLayoutSample extends SampleView {
  /// Creates [TreemapLayoutSample].
  const TreemapLayoutSample(Key key, this.layoutType) : super(key: key);

  /// Defines the layout type.
  final LayoutType layoutType;

  @override
  _TreemapLayoutSampleState createState() =>
      // ignore: no_logic_in_create_state
      _TreemapLayoutSampleState(layoutType);
}

class _TreemapLayoutSampleState extends SampleViewState {
  _TreemapLayoutSampleState(this.layoutType);
  final LayoutType layoutType;
  late List<_MovieDetails> _topTenMovies;
  late bool _isLightTheme;
  late bool _isDesktop;
  bool _sortAscending = false;

  @override
  void initState() {
    // Data source to the treemap.
    //
    // [boxOffice] is used to get each tile's weight.
    // [movie] is the flat level grouping key.
    _topTenMovies = <_MovieDetails>[
      const _MovieDetails(
        movie: 'Avengers: Endgame',
        director: 'Anthony and Joe Russo',
        boxOffice: 2.798,
        color: Color.fromRGBO(111, 194, 250, 1.0),
      ),
      const _MovieDetails(
        movie: 'Avatar',
        director: 'James Cameron',
        boxOffice: 2.834,
        color: Color.fromRGBO(71, 94, 209, 1.0),
      ),
      const _MovieDetails(
        movie: 'Titanic',
        director: 'James Cameron',
        boxOffice: 2.195,
        color: Color.fromRGBO(236, 105, 85, 1.0),
      ),
      const _MovieDetails(
        movie: 'Star Wars: The Force Awakens',
        director: 'J. J. Abrams',
        boxOffice: 2.068,
        color: Color.fromRGBO(112, 74, 211, 1.0),
      ),
      const _MovieDetails(
        movie: 'Avengers: Infinity War',
        director: 'Anthony and Joe Russo',
        boxOffice: 2.048,
        color: Color.fromRGBO(78, 198, 125, 1.0),
      ),
      const _MovieDetails(
        movie: 'Jurassic World',
        director: 'Colin Trevorrow',
        boxOffice: 1.670,
        color: Color.fromRGBO(118, 196, 79, 1.0),
      ),
      const _MovieDetails(
        movie: 'The Lion King',
        director: 'Jon Favreau',
        boxOffice: 1.657,
        color: Color.fromRGBO(240, 140, 86, 1.0),
      ),
      const _MovieDetails(
        movie: 'The Avengers',
        director: 'Joss Whedon',
        boxOffice: 1.519,
        color: Color.fromRGBO(84, 114, 246, 1.0),
      ),
      const _MovieDetails(
        movie: 'Furious 7',
        director: 'James Wan',
        boxOffice: 1.516,
        color: Color.fromRGBO(143, 86, 245, 1.0),
      ),
      const _MovieDetails(
        movie: 'Frozen II',
        director: 'Chris Buck',
        boxOffice: 1.450,
        color: Color.fromRGBO(255, 128, 170, 1.0),
      ),
    ];

    super.initState();
  }

  @override
  void dispose() {
    _topTenMovies.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    _isDesktop =
        kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.linux ||
        themeData.platform == TargetPlatform.windows;
    _isLightTheme = themeData.colorScheme.brightness == Brightness.light;
    final Widget current = Center(
      child: Padding(
        padding:
            MediaQuery.of(context).orientation == Orientation.portrait ||
                _isDesktop
            ? const EdgeInsets.all(12.5)
            : const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Text(
              'Top 10 Highest-Grossing Movies Worldwide',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12.5),
                child: _buildTreemap(themeData),
              ),
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      body: Stack(
        children: <Widget>[
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return (layoutType == LayoutType.slice &&
                          constraints.maxHeight > 300) ||
                      layoutType != LayoutType.slice ||
                      MediaQuery.of(context).orientation ==
                          Orientation.portrait ||
                      _isDesktop
                  ? current
                  : SingleChildScrollView(
                      child: SizedBox(height: 400, child: current),
                    );
            },
          ),
          if (layoutType != LayoutType.squarified)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding:
                    MediaQuery.of(context).orientation ==
                            Orientation.portrait ||
                        _isDesktop
                    ? const EdgeInsets.only(right: 16.5, bottom: 16.5)
                    : const EdgeInsets.only(right: 14.0, bottom: 14.0),
                child: SizedBox(
                  height: 45.0,
                  width: 45.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          spreadRadius: 2.0,
                          blurRadius: 2.0,
                          offset: Offset(0.0, 2.0),
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(45 / 2),
                    ),
                    child: TextButton(
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(45 / 2),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.all(
                          themeData.colorScheme.surface,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _sortAscending = !_sortAscending;
                        });
                      },
                      child: Padding(
                        padding: _isDesktop
                            ? const EdgeInsets.all(2.0)
                            : const EdgeInsets.all(1.0),
                        child: _buildIcon(layoutType),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildIcon(LayoutType layoutType) {
    if (_isLightTheme) {
      return _sortAscending
          ? Tooltip(
              message: 'Sort in descending order',
              child: Image.asset('images/treemap_descending_light.png'),
            )
          : Tooltip(
              message: 'Sort in ascending order',
              child: Image.asset('images/treemap_ascending_light.png'),
            );
    } else {
      return _sortAscending
          ? Tooltip(
              message: 'Sort in descending order',
              child: Image.asset('images/treemap_descending_dark.png'),
            )
          : Tooltip(
              message: 'Sort in ascending order',
              child: Image.asset('images/treemap_ascending_dark.png'),
            );
    }
  }

  Widget _buildTreemap(ThemeData themeData) {
    if (layoutType == LayoutType.slice) {
      return SfTreemap.slice(
        // The number of data in your data source collection.
        //
        // The callback for the [weightValueMapper] and
        // [TreemapLevel.groupMapper] will be called
        // the number of times equal to the [dataCount].
        dataCount: _topTenMovies.length,
        // The value returned in the callback will specify the
        // weight of each tile.
        weightValueMapper: (int index) {
          return _topTenMovies[index].boxOffice;
        },
        sortAscending: _sortAscending,
        tooltipSettings: TreemapTooltipSettings(
          color: _isLightTheme
              ? const Color.fromRGBO(45, 45, 45, 1)
              : const Color.fromRGBO(242, 242, 242, 1),
        ),
        levels: _getTreemapLevels(themeData),
      );
    } else if (layoutType == LayoutType.dice) {
      return SfTreemap.dice(
        dataCount: _topTenMovies.length,
        weightValueMapper: (int index) {
          return _topTenMovies[index].boxOffice;
        },
        sortAscending: _sortAscending,
        tooltipSettings: TreemapTooltipSettings(
          color: _isLightTheme
              ? const Color.fromRGBO(45, 45, 45, 1)
              : const Color.fromRGBO(242, 242, 242, 1),
        ),
        levels: _getTreemapLevels(themeData),
      );
    } else {
      return SfTreemap(
        dataCount: _topTenMovies.length,
        weightValueMapper: (int index) {
          return _topTenMovies[index].boxOffice;
        },
        tooltipSettings: TreemapTooltipSettings(
          color: _isLightTheme
              ? const Color.fromRGBO(45, 45, 45, 1)
              : const Color.fromRGBO(242, 242, 242, 1),
        ),
        levels: _getTreemapLevels(themeData),
      );
    }
  }

  List<TreemapLevel> _getTreemapLevels(ThemeData themeData) {
    return <TreemapLevel>[
      TreemapLevel(
        color: Colors.red,
        // Used for grouping the tiles based on the value returned from
        // this callback.
        //
        // Once grouped, we will get [labelBuilder], [tooltipBuilder], and
        // [itemBuilder] callbacks respectively.
        groupMapper: (int index) => _topTenMovies[index].movie,
        // Padding around the tile.
        padding: const EdgeInsets.all(1.0),
        // Border around the tile.
        border: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2.0)),
        ),
        // Returns a widget for each tile's data label.
        labelBuilder: (BuildContext context, TreemapTile tile) {
          return _buildLabelBuilder(tile);
        },
        // Returns a widget for each tile's content.
        itemBuilder: (BuildContext context, TreemapTile tile) {
          if (layoutType == LayoutType.dice) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const <double>[0, 1.0],
                  colors: <Color>[
                    if (_isLightTheme)
                      const Color.fromRGBO(76, 187, 220, 1.0)
                    else
                      const Color.fromRGBO(76, 187, 220, 1.0),
                    const Color.fromRGBO(50, 128, 214, 1.0),
                  ],
                ),
              ),
            );
          } else if (layoutType == LayoutType.slice) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  stops: const <double>[0, 1.0],
                  colors: <Color>[
                    const Color.fromRGBO(50, 128, 214, 1.0),
                    if (_isLightTheme)
                      const Color.fromRGBO(76, 187, 220, 1.0)
                    else
                      const Color.fromRGBO(76, 187, 220, 1.0),
                  ],
                ),
              ),
            );
          } else {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const <double>[0.0, 1.0],
                  colors: <Color>[
                    const Color.fromRGBO(50, 128, 214, 1.0),
                    if (_isLightTheme)
                      const Color.fromRGBO(76, 187, 220, 1.0)
                    else
                      const Color.fromRGBO(76, 187, 220, 1.0),
                  ],
                ),
              ),
            );
          }
        },
        // Returns a widget for each tile's tooltip.
        tooltipBuilder: (BuildContext context, TreemapTile tile) {
          return _buildTooltipBuilder(tile, themeData);
        },
      ),
    ];
  }

  Widget _buildLabelBuilder(TreemapTile tile) {
    if (layoutType == LayoutType.slice) {
      return Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            tile.group,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    } else if (layoutType == LayoutType.dice) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: _isDesktop
              ? const EdgeInsets.only(bottom: 10.0)
              : const EdgeInsets.only(bottom: 6.0),
          child: RotatedBox(
            quarterTurns: 3,
            child: Text(
              tile.group,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    } else {
      return Align(
        child: Text(
          tile.group,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
  }

  Widget _buildTooltipBuilder(TreemapTile tile, ThemeData themeData) {
    final _MovieDetails movieDetails = _topTenMovies[tile.indices[0]];
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 8.5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            child: RichText(
              text: TextSpan(
                text: 'Director',
                style: themeData.textTheme.bodySmall!.copyWith(
                  height: 1.5,
                  color: _isLightTheme
                      ? const Color.fromRGBO(255, 255, 255, 0.75)
                      : const Color.fromRGBO(10, 10, 10, 0.75),
                ),
                children: const <TextSpan>[TextSpan(text: '\nBox office')],
              ),
            ),
          ),
          const SizedBox(width: 15.0),
          SizedBox(
            child: RichText(
              text: TextSpan(
                text: movieDetails.director,
                style: themeData.textTheme.bodySmall!.copyWith(
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                  color: _isLightTheme
                      ? const Color.fromRGBO(255, 255, 255, 1)
                      : const Color.fromRGBO(10, 10, 10, 1),
                ),
                children: <TextSpan>[
                  TextSpan(text: '\n\$${movieDetails.boxOffice}B'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieDetails {
  const _MovieDetails({
    required this.boxOffice,
    this.movie,
    this.director,
    this.color,
  });

  final String? movie;
  final String? director;
  final double boxOffice;
  final Color? color;
}
