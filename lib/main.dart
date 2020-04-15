import 'package:flutter/material.dart';
import 'package:screenshot_manager/utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Screenshot Manager',
      theme: ThemeData(
        primaryColor: Color(0xFF34495E),
        accentColor: Color(0xFF798EA5),
      ),
      home: MyHomeScreen(),
    );
  }
}

class MyHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: 10),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'My Projects',
                    style: headingTextStyle,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                MyProjectWidget(),
                MyProjectWidget(),
                MyProjectWidget(),
                MyProjectWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyProjectWidget extends StatelessWidget {
  const MyProjectWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 5,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                height: 100,
                color: Colors.white,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text('Comments'),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                height: 100,
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
