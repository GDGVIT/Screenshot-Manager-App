import 'package:flutter/material.dart';
import 'package:screenshot_manager/utils.dart';
import '../models/project.dart';
import '../screens/project_screen.dart';

class MyProjectWidget extends StatelessWidget {
  final Project project;
  MyProjectWidget({this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.02,
        horizontal: MediaQuery.of(context).size.width * 0.06,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(0x25aaa9a9),
            blurRadius: 10,
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
                  flex: 3,
                  child: Container(
                    // height: 100,
                    padding: EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        project.title,
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    // height: 100,
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        child: Icon(Icons.navigate_next),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
