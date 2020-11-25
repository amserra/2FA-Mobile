import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:pbkdf2_dart/pbkdf2_dart.dart';
import 'package:crypto/crypto.dart';
import 'package:otp/otp.dart';

Timer timer;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2FA Autheticator',
      theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme:
              GoogleFonts.openSansTextTheme(Theme.of(context).textTheme)),
      home: MyHomePage(title: '2FA Autheticator'),
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
    double screen_width = MediaQuery.of(context).size.width;
    double screen_height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromRGBO(30, 30, 30, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(36, 36, 36, 1),
        title: Text(widget.title),
        elevation: 50.0,
      ),
      body: Stack(
        children: [
          Center(
            heightFactor: 0.85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'You code is:',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                SizedBox(height: 50),
                Text(
                  '$_counter',
                  // style: Theme.of(context).textTheme.headline4,
                  style: TextStyle(color: Colors.white, fontSize: 60),
                ),
                // Text(
                //   '$_cameraScanResult',
                //   style: TextStyle(color: Colors.white, fontSize: 30),
                // ),
              ],
            ),
          ),
          Positioned(
              left: screen_width - 100,
              top: screen_height - 500,
              child: CircularCountDownTimer(
                duration: 30,
                // Controller to control (i.e Pause, Resume, Restart) the Countdown
                // controller: _controller,
                width: 80,
                height: 80,
                color: Colors.white,
                fillColor: Color.fromRGBO(154, 205, 50, 0.8),
                backgroundColor: null,
                strokeWidth: 4.0,
                textStyle: TextStyle(
                    fontSize: 22.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                isReverse: true,
                isReverseAnimation: true,
                isTimerTextShown: true,
                // Function which will execute when the Countdown Ends
                onComplete: () {
                  // Here, do whatever you want
                  print('Countdown Ended');
                },
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _readQRcode,
        label: Text('Scan new QR code'),
        tooltip: 'Scan new QR code',
        icon: Icon(Icons.qr_code),
        backgroundColor: Color.fromRGBO(154, 205, 50, 0.8),
      ),
    );
  }
}
