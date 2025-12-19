import 'package:flutter/material.dart';
import '../sample_browser.dart';
import 'model.dart';

class ShowcaseApplications extends StatelessWidget {
  const ShowcaseApplications({
    required this.model,
    this.isMaxXSize = false,
    this.sidePadding = 0.0,
    this.padding = 0.0,
    this.deviceWidth = 0.0,
    this.itemsPerPage = 0,
    this.showViewAll = false,
    required this.applications,
    required this.pageController,
    required this.applicationCardHeight,
    required this.applicationCurrentPage,
    required this.applicationCardWidth,
    required this.appBar,
  });
  final SampleModel model;
  final bool isMaxXSize;
  final double sidePadding;
  final double padding;
  final double deviceWidth;
  final int itemsPerPage;
  final bool showViewAll;
  final List<ShowCaseApplications> applications;
  final PageController pageController;
  final double applicationCardHeight;
  final double applicationCardWidth;
  final int applicationCurrentPage;
  final PreferredSize appBar;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: sidePadding / 2),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: sidePadding / 2),
            child: SizedBox(
              height: applicationCardHeight,
              child: PageView.builder(
                controller: pageController,
                itemCount: applications.length > itemsPerPage ? 2 : 1,
                itemBuilder: (context, pageIndex) {
                  final int startIndex = pageIndex * itemsPerPage;
                  final int endIndex =
                      applicationCurrentPage == 1 && pageIndex > 0
                      ? deviceWidth > 1060
                            ? applications.length > 6
                                  ? startIndex + 2
                                  : applications.length
                            : (deviceWidth >= 768
                                  ? applications.length > 4
                                        ? startIndex + 1
                                        : applications.length
                                  : applications.length > 2
                                  ? startIndex
                                  : applications.length)
                      : (startIndex + itemsPerPage > applications.length)
                      ? applications.length
                      : startIndex + itemsPerPage;
                  final List<ShowCaseApplications> visibleApps = applications
                      .sublist(startIndex, endIndex);
                  return Row(
                    children: [
                      ...visibleApps.map(
                        (app) => Padding(
                          padding: EdgeInsets.only(right: padding),
                          child: _buildApplicationWidget(
                            context,
                            app,
                            model,
                            deviceWidth,
                          ),
                        ),
                      ),
                      if (showViewAll && pageIndex > 0)
                        _buildViewAllOptions(
                          context,
                          model,
                          isMaxXSize,
                          sidePadding,
                          padding,
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          if (applicationCurrentPage == 1 && applications.length > itemsPerPage)
            _buildPreviousButton(context, model, sidePadding, padding),
          if (applicationCurrentPage == 0 && applications.length > itemsPerPage)
            _buildNextButton(context, model, sidePadding, padding),
        ],
      ),
    );
  }

  Widget _buildPreviousButton(
    BuildContext context,
    SampleModel model,
    double sidePadding,
    double padding,
  ) {
    return Positioned(
      top: applicationCardHeight / 3 + padding * 2,
      child: ElevatedButton(
        onPressed: () {
          pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(10),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back_ios,
            color: model.themeData.colorScheme.brightness == Brightness.dark
                ? const Color.fromRGBO(238, 238, 238, 1)
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  /// Builds the next page button in the applications page view.
  Widget _buildNextButton(
    BuildContext context,
    SampleModel model,
    double sidePadding,
    double padding,
  ) {
    return Positioned(
      right: sidePadding / 2,
      top: applicationCardHeight / 3 + padding * 2,
      child: ElevatedButton(
        onPressed: () {
          pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(10),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        child: Center(
          child: Icon(
            Icons.arrow_forward_ios,
            color: model.themeData.colorScheme.brightness == Brightness.dark
                ? const Color.fromRGBO(238, 238, 238, 1)
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildApplicationWidget(
    BuildContext context,
    ShowCaseApplications app,
    SampleModel model,
    double width,
  ) {
    final String imagePath = _imagePathBasedOnTheme(app.title);
    return Container(
      decoration: BoxDecoration(
        color: model.homeCardColor,
        border: Border.all(
          color: model.themeData.useMaterial3
              ? model.themeData.colorScheme.outlineVariant
              : const Color.fromRGBO(0, 0, 0, 0.12),
          width: 1.1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      width: model.isWebFullView ? 380.0 : applicationCardWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
            child: InkWell(
              onTap: () {
                if (model.isWeb) {
                  Navigator.pushNamed(context, app.routeName);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => app.application,
                    ),
                  );
                }
              },
              child: SizedBox(
                height: 185,
                width: 356,
                child: Image.asset(imagePath, fit: BoxFit.fill),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                color: model.themeData.useMaterial3
                    ? model.themeData.colorScheme.outlineVariant
                    : (model.themeData.colorScheme.brightness == Brightness.dark
                          ? const Color.fromRGBO(61, 61, 61, 1)
                          : const Color.fromRGBO(238, 238, 238, 1)),
                thickness: 1,
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  top: 16.0,
                  bottom: 16.0,
                ),
                child: Text(
                  app.title,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    letterSpacing: 0,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _imagePathBasedOnTheme(String showcaseSampleName) {
    final String name = showcaseSampleName == 'Expense Tracker'
        ? 'expense_tracker'
        : 'stock_analysis';
    return model.themeData.colorScheme.brightness == Brightness.dark
        ? 'images/${name}_thumbnail_dark.png'
        : 'images/${name}_thumbnail_light.png';
  }

  Widget _buildViewAllOptions(
    BuildContext context,
    SampleModel model,
    bool isMaxXSize,
    double sidePadding,
    double padding,
  ) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: model.homeCardColor,
        border: Border.all(
          color: model.themeData.useMaterial3
              ? model.themeData.colorScheme.outlineVariant
              : const Color.fromRGBO(0, 0, 0, 0.12),
          width: 1.1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      width: applicationCardWidth * 0.8,
      child: InkWell(
        onTap: () => _navigateToApplications(
          context,
          model,
          isMaxXSize,
          sidePadding,
          padding,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'View All',
              style: TextStyle(
                color: model.primaryColor,
                fontSize: 16,
                fontFamily: 'Roboto-Bold',
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToApplications(
    BuildContext context,
    SampleModel model,
    bool isMaxXSize,
    double sidePadding,
    double padding,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            appBar: appBar,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: sidePadding,
                    vertical: 16,
                  ),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          size: 24,
                          color: model.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Showcase Samples',
                          style: TextStyle(
                            color: model.primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Applications grid.
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: sidePadding),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final int itemsPerRow = constraints.maxWidth > 1060
                            ? 3
                            : (constraints.maxWidth > 768 ? 2 : 1);
                        final double appHeight =
                            MediaQuery.of(context).size.height * 0.4;
                        return GridView.builder(
                          padding: const EdgeInsets.only(
                            top: 10,
                            right: 20,
                            bottom: 10,
                            left: 10,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: itemsPerRow,
                                crossAxisSpacing: padding,
                                mainAxisSpacing: padding,
                                childAspectRatio:
                                    constraints.maxWidth /
                                    itemsPerRow /
                                    appHeight,
                              ),
                          itemCount: applications.length,
                          itemBuilder: (context, index) =>
                              _buildApplicationWidget(
                                context,
                                applications[index],
                                model,
                                constraints.maxWidth,
                              ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
