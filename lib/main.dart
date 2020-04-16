import 'package:flutter/material.dart';
import 'package:screenshot_manager/models/project.dart';
import 'package:screenshot_manager/services/db_helper.dart';
import 'package:screenshot_manager/utils.dart';
import './widgets/project_widget.dart';

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
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
        }),
      ),
      home: MyHomeScreen(),
    );
  }
}

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      builder: (ctx) {
        Color color = Colors.green;
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
                      ClipRRect(
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
                      SizedBox(
                        height: 20,
                      ),
                      FlatButton(
                        child: Text('Done'),
                        textColor: color,
                        onPressed: () {
                          _onSubmit();
                          Navigator.of(context).maybePop();
                          titlecontroller.clear();
                        },
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
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: 10),
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
                return ListView.builder(
                  itemCount: myProjects.length,
                  itemBuilder: (ctx, index) {
                    return MyProjectWidget(
                      project: myProjects[index],
                    );
                  },
                );
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

// import 'dart:io';
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import './models/local_img.dart';
// import './services/db_helper.dart';
// import 'package:screenshot_manager/utils.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Screenshot Manager',
//       theme: ThemeData(
//         primaryColor: Color(0xFF34495E),
//         accentColor: Color(0xFF798EA5),
//       ),
//       home: MyHomeScreen(),
//     );
//   }
// }

// class MyHomeScreen extends StatefulWidget {
//   @override
//   _MyHomeScreenState createState() => _MyHomeScreenState();
// }

// class _MyHomeScreenState extends State<MyHomeScreen> {
//   Future<File> imageFile;
//   Image image;
//   DBHelper dbHelper;
//   List<Photo> photos;

//   @override
//   void initState() {
//     super.initState();
//     photos = [];
//     dbHelper = DBHelper();
//   }

//   pickImageFromGallery() {
//     ImagePicker.pickImage(source: ImageSource.gallery).then((file) {
//       String imgString = Utility.base64String(file.readAsBytesSync());
//       Photo photo = Photo(id: 0, title: imgString);
//       dbHelper.save(photo);
//       refreshPhotos();
//     });
//   }

//   refreshPhotos() {
//     dbHelper.getPhotos().then((imgArray) {
//       setState(() {
//         photos.clear();
//         photos.addAll(imgArray);
//       });
//     });
//   }

// photoView() {
//   return Padding(
//     padding: const EdgeInsets.all(12.0),
//     child: GridView.count(
//       crossAxisCount: 2,
//       childAspectRatio: 0.5,
//       mainAxisSpacing: 5,
//       crossAxisSpacing: 2,
//       children: photos.map((photo) {
//         return Utility.imageFromBase64String(photo.title);
//       }).toList(),
//     ),
//   );
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Picker'),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.add),
//             onPressed: pickImageFromGallery,
//           ),
//         ],
//       ),
//       body: Column(
//         children: <Widget>[
//           Flexible(
//             child: photoView(),
//           ),
//         ],
//       ),
//     );
//   }
// }
