import 'package:flutter/material.dart';
import './screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Screenshot Manager',
      theme: ThemeData(
        primaryColor: Color(0xFF34495E),
        accentColor: Color(0xFF798EA5),
        canvasColor: Color(0xFFfafcff),
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
        }),
      ),
      home: MyHomeScreen(),
    );
  }
}
