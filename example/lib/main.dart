import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_addtoapp_bridge/flutter_addtoapp_bridge.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'UNKNOWN';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('FLUTTER ADDTOAPP BRIDGE EXAMPLE')),
        body: Center(
          child: GestureDetector(
            onTap: () => onTap(),
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.all(30.0),
              padding: EdgeInsets.all(30.0),
              child: Text(
                'PLATFORM_VERSION: \n$_platformVersion\n\n(click to show toast and version)',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              color: Colors.blueGrey,
            ),
          ),
        ),
      ),
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> onTap() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    /*try {
      platformVersion = await FlutterAddtoappBridge.getPlatformVersion() ?? 'UNKNOWN';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }*/

    FlutterAddtoappBridge.showToast("HI, I AM FROM FLUTTER!");

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) return;

    // setState(() {
    //   _platformVersion = platformVersion;
    // });
  }
}
