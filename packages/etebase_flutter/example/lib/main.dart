// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import 'package:etebase_flutter/etebase_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('etebase flutter plugin'),
        ),
        body: Center(
          child: FutureBuilder(
              future: _validateClient(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text('etebase default server URL: ${snapshot.data}');
                } else if (snapshot.hasError) {
                  print('${snapshot.error}\n${snapshot.stackTrace}');
                  return Text('${snapshot.error}\n${snapshot.stackTrace}');
                } else {
                  return const CircularProgressIndicator();
                }
              }),
        ),
      ),
    );
  }

  Future<String> _validateClient() async {
    final client = await EtebaseClient.create('etebase_flutter_example');
    try {
      final serverUrl = await etebaseGetDefaultServerUrl();
      final serverIsOk = await client.checkEtebaseServer();
      if (serverIsOk) {
        return serverUrl.toString();
      } else {
        print('Server is invalid');
        return "Server is invalid";
      }
    } finally {
      await client.dispose();
    }
  }
}
