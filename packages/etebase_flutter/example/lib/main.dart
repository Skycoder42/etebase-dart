import 'package:flutter/material.dart';
import 'dart:async';

import 'package:etebase_flutter/etebase_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _etebaseServerUrlResult = 'loading...';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    Object result;
    try {
      result = await etebaseGetDefaultServerUrl();
    } catch (e, s) {
      result = '$e\n$s';
      // ignore: avoid_print
      print(result);
    }

    if (!mounted) return;

    setState(() {
      _etebaseServerUrlResult = result.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text(
            'etebaseGetDefaultServerUrl result: $_etebaseServerUrlResult\n',
          ),
        ),
      ),
    );
  }
}
