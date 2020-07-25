import 'package:flutter/material.dart';
import 'package:faremate/loading_screen.dart';

//last edited on video 5
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: LoadingScreen(),
    );
  }
}
