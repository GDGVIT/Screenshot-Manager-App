import 'package:flutter/material.dart';
import 'package:screenshot_manager/models/project.dart';

class ProjectScreen extends StatelessWidget {
  final Project project;
  ProjectScreen(this.project);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.file_upload),
        tooltip: 'Upload screenshot',
        onPressed: () {},
      ),
      appBar: AppBar(
        title: Text(project.title),
      ),
      body: Center(
        child: Text(project.id.toString()),
      ),
    );
  }
}
