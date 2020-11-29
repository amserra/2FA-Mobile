import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mainScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const title = 'SecureAuth';
    return MaterialApp(
      title: title,
      theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme:
              GoogleFonts.openSansTextTheme(Theme.of(context).textTheme)),
      home: MainScreen(title: title),
    );
  }
}
