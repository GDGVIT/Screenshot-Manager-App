import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screenshot_manager/widgets/project_widget.dart';
import '../models/project.dart';
import '../services/db_helper.dart';
import '../utils.dart';

class MyHomeScreen extends StatefulWidget {
  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  List<Project> myProjects;
  Future<List<Project>> storedProjects;
  DBHelper dbHelper;
  @override
  void initState() {
    myProjects = [];
    dbHelper = DBHelper();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: primaryColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );
    super.initState();
  }

  TextEditingController titlecontroller = TextEditingController();
  _onSubmit() async {
    final title = titlecontroller.text;
    if (title.isEmpty) {
      return;
    }
    Project p = Project(title: title);
    p = await dbHelper.saveProject(p);
    print("project saved with id = ${p.id}");
  }

  // refreshProjects() {
  //   dbHelper.getProjects().then((projectList) {
  //     setState(() {
  //       myProjects.clear();
  //       projectList.addAll(projectList);
  //     });
  //   });
  // }

  addProject() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, sheetSetState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Create New Project',
                        style: headingTextStyle.copyWith(fontSize: 18),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.65,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: TextField(
                                controller: titlecontroller,
                                onSubmitted: (string) => _onSubmit,
                                decoration: InputDecoration(
                                  hintText: 'Name',
                                  fillColor: Colors.grey[200],
                                  border: InputBorder.none,
                                  filled: true,
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            height: 45,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text('Done'),
                              color: primaryColor,
                              textColor: Colors.white,
                              onPressed: () {
                                _onSubmit();
                                Navigator.of(context).maybePop();
                                titlecontroller.clear();
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  projectView() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 3,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        children: myProjects.map((project) {
          return Text(project.title);
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: Theme.of(context).canvasColor,
        title: Text('Screenshot Manager'),
        actions: <Widget>[
          Tooltip(
            message: 'Add Project',
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(5),
            ),
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: addProject,
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05),
            padding: EdgeInsets.only(top: 20, bottom: 15),
            alignment: Alignment.centerLeft,
            child: Text(
              'My Projects',
              style: headingTextStyle,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: dbHelper.getProjects(),
              builder: (ctx, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                myProjects = snapshot.data;
                if (myProjects.length == 0) {
                  return Center(
                    child: Text(
                      'Tap \'+\' to add a new project',
                      style: TextStyle(color: accentColor),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: myProjects.length,
                    itemBuilder: (ctx, index) {
                      return Dismissible(
                        key: Key(myProjects[index].id.toString()),
                        background: Container(
                          margin: EdgeInsets.symmetric(vertical: 17),
                          padding: EdgeInsets.all(10),
                          color: Colors.red,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.delete),
                          ),
                        ),
                        secondaryBackground: Container(
                          margin: EdgeInsets.symmetric(vertical: 17),
                          padding: EdgeInsets.all(10),
                          color: Colors.red,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.delete),
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          dbHelper
                              .deleteProject(myProjects[index].id)
                              .then((_) {
                            myProjects.removeWhere((project) =>
                                project.id == myProjects[index].id);
                            if(myProjects.length == 0){
                              setState(() {
                                dbHelper.getProjects();
                              });
                            }
                          });
                        },
                        child: MyProjectWidget(
                          project: myProjects[index],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: myProjects.length,
          //     itemBuilder: (ctx, index) {
          //       return MyProjectWidget(project: myProjects[index]);
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
