import 'package:flutter/material.dart';
import 'dart:async';

import 'package:desktop_window/desktop_window.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _windowSize = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  Future _getWindowSize() async {
    var size = await DesktopWindow.getWindowSize();
    setState(() {
      _windowSize = '${size.width} x ${size.height}';
    });
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('desktop_window example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$_windowSize\n'),
              ElevatedButton(
                child: Text("getWindowSize"),
                onPressed: _getWindowSize,
              ),
              ElevatedButton(
                child: Text("setMinWindowSize(300,400)"),
                onPressed: () async {
                  await DesktopWindow.setMinWindowSize(Size(300, 400));
                },
              ),
              ElevatedButton(
                child: Text("setMaxWindowSize(800,800)"),
                onPressed: () async {
                  await DesktopWindow.setMaxWindowSize(Size(800, 800));
                },
              ),
              Wrap(
                children: [
                  ElevatedButton(
                    child: Text("Smaller"),
                    onPressed: () async {
                      var size = await DesktopWindow.getWindowSize();
                      await DesktopWindow.setWindowSize(
                          Size(size.width - 50, size.height - 50));
                      await _getWindowSize();
                    },
                  ),
                  ElevatedButton(
                    child: Text("Larger"),
                    onPressed: () async {
                      var size = await DesktopWindow.getWindowSize();
                      await DesktopWindow.setWindowSize(
                          Size(size.width + 50, size.height + 50));
                      await _getWindowSize();
                    },
                  ),
                ],
              ),
              Wrap(
                children: [
                  ElevatedButton(
                    child: Text("toggleFullScreen"),
                    onPressed: () async {
                      await DesktopWindow.resetMaxWindowSize();
                      await DesktopWindow.toggleFullScreen();
                    },
                  ),
                  Builder(builder: (ctx) {
                    return ElevatedButton(
                      child: Text("getFullScreen"),
                      onPressed: () async {
                        final isFullScreen =
                            await DesktopWindow.getFullScreen();
                        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                            content: Text('getFullScreen = $isFullScreen'),
                            duration: Duration(seconds: 1)));
                      },
                    );
                  }),
                  ElevatedButton(
                    child: Text("setFullScreen(true)"),
                    onPressed: () async {
                      await DesktopWindow.setFullScreen(true);
                    },
                  ),
                  ElevatedButton(
                    child: Text("setFullScreen(false)"),
                    onPressed: () async {
                      await DesktopWindow.setFullScreen(false);
                    },
                  ),
                ],
              ),
              Wrap(
                children: [
                  ElevatedButton(
                    child: Text("toggleBorders"),
                    onPressed: () async {
                      await DesktopWindow.toggleBorders();
                    },
                  ),
                  Builder(builder: (ctx) {
                    return ElevatedButton(
                      child: Text("setBorders(true)"),
                      onPressed: () async {
                        await DesktopWindow.setBorders(true);
                      },
                    );
                  }),
                  ElevatedButton(
                    child: Text("setBorders(false)"),
                    onPressed: () async {
                      await DesktopWindow.setBorders(false);
                    },
                  ),
                  ElevatedButton(
                    child: Text("hasBorders"),
                    onPressed: () async {
                      print('hasBorders: ' +
                          (await DesktopWindow.hasBorders ? 'true' : 'false'));
                    },
                  ),
                ],
              ),
              Wrap(
                children: [
                  ElevatedButton(
                    child: Text("focus"),
                    onPressed: () {
                      Timer(Duration(seconds: 3), () async {
                        print('focus!!!');
                        await DesktopWindow.focus();
                      });
                    },
                  ),
                  ElevatedButton(
                    child: Text("stayOnTop(true)"),
                    onPressed: () async {
                      print('stayOnTop(true)');
                      await DesktopWindow.stayOnTop(true);
                    },
                  ),
                  ElevatedButton(
                    child: Text("stayOnTop(false)"),
                    onPressed: () async {
                      print('stayOnTop(false)');
                      await DesktopWindow.stayOnTop(false);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
