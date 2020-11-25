import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:pbkdf2_dart/pbkdf2_dart.dart';
import 'package:crypto/crypto.dart';
import 'package:otp/otp.dart';

Timer timer;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2FA Autheticator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: '2FA Autheticator Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _cameraScanResult = "no result";

  @override
  void initState() {
    super.initState();
    timer =
        Timer.periodic(Duration(seconds: 5), (Timer t) => _incrementCounter());
  }

  void _incrementCounter() {
    setState(() {
      _counter = _counter + 2;
    });
  }

  void _readQRcode() {
    setState(() async {
      String qrCodeScan = await scanner.scan();

      // Create PBKDF2 instance using the SHA256 hash. The default is to use SHA1
      var gen = new PBKDF2(hash: sha256.newInstance());

      // Generate a 32 byte key using the given password and salt, with 1000 iterations
      var key = gen.generateKey(qrCodeScan, "salt", 1000, 32);

      var converter = new Base64Encoder();
      _cameraScanResult = converter.convert(key);

      //TODO - Save key to memory
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '$_cameraScanResult',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _readQRcode,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
