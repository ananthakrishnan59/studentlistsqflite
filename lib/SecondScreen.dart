import 'dart:io';

import 'package:flutter/material.dart';
import 'package:studentid/Update.dart';
import 'package:studentid/Database.dart';
import 'package:studentid/FirstScreen.dart';

class Secondscreen extends StatefulWidget {
  const Secondscreen({super.key});

  @override
  State<Secondscreen> createState() => _SecondscreenState();
}

late List<Map<String, dynamic>> studentsData = [];

class _SecondscreenState extends State<Secondscreen> {
  final SearchController = TextEditingController();

  Future<void> fetchStudentData() async {
    List<Map<String, dynamic>> students = await getAllStudentDataFromDB();
    if (SearchController.text.isNotEmpty) {
      students = students
          .where((s) => s['name']
              .toString()
              .toLowerCase()
              .contains(SearchController.text.toLowerCase()))
          .toList();
    }
    setState(() {
      studentsData = students;
    });
  }

  void initState() {
    fetchStudentData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "Students List",
              style: TextStyle(color: Colors.black, fontSize: 21),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: SearchController,
              onChanged: (value) {
                fetchStudentData();
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 29,
                    color: Colors.black,
                  ),
                  labelText: "Search",
                  labelStyle: TextStyle(color: Colors.black, fontSize: 20)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          studentsData.isEmpty
              ? Text("Student Data is not available")
              : Expanded(
                  child: ListView.separated(
                  itemCount: studentsData.length,
                  itemBuilder: (context, index) {
                    
                    final student = studentsData[index];

                    final id = student['id'];
                    final imageurl = student['imagesrc'];
                    final name = student['name'];
                    return ListTile(
                      title: Text(name),
                      leading: CircleAvatar(
                        radius: 40,
                        backgroundImage: FileImage(File(imageurl)),
                      ),
                      subtitle: Text(id.toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.yellow,
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => updateStudentDetails(
                                    number: student['number'],
                                    id: id,
                                    age: student['age'],
                                    name: name,
                                    department: student['department'],
                                    imagesrc: imageurl,
                                  ),
                                ));
                              },
                              icon: Icon(Icons.edit),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.yellow,
                            child: IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                            "Delete the students information"),
                                        content: Text(
                                            "Are you sure you to delete ?"),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Cancel")),
                                          ElevatedButton(
                                              onPressed: () async {
                                                await deleteStudentDetailsFromDB(
                                                    id);
                                                fetchStudentData();
                                                Navigator.of(context).pop();
                                                snackBarFunction(
                                                    context,
                                                    "Delete Successfully",
                                                    Colors.green);
                                              },
                                              child: Text("OK"))
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.delete)),
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                ))
        ],
      ),
    );
  }
}