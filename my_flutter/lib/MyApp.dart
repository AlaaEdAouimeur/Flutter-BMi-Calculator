import 'package:flutter/material.dart';
import 'package:my_flutter/inputpage/InputPage.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          fontFamily: 'Schyler'
        ),
      debugShowCheckedModeBanner: true,
      home: InputPage(),
    );
  }
}