import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../models/project.dart';
import '../screens/project_screen.dart';

class MyProjectWidget extends StatelessWidget {
  final Project project;
  MyProjectWidget({this.project, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.02,
        horizontal: MediaQuery.of(context).size.width * 0.06,
      ),
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
        child: Material(
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProjectScreen(project),
              ),
            ),
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
                    padding: EdgeInsets.all(5),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        project.title,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
