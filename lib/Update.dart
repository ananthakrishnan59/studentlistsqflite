import 'dart:io';
import 'package:flutter/material.dart';
import 'package:studentid/Database.dart';
import 'package:studentid/FirstScreen.dart';
import 'package:studentid/SecondScreen.dart';
import 'package:studentid/StudentModel.dart';

class updateStudentDetails extends StatefulWidget {
  const updateStudentDetails(
      {super.key,
      required this.id,
      required this.name,
      required this.age,
      required this.department,
      required this.number,
      this.imagesrc});
  final int id;
  final String name;
  final int age;
  final String department;
  final double number;
  final dynamic imagesrc;
  @override
  State<updateStudentDetails> createState() => _updateStudentDetailsState();
}

final formKey = GlobalKey<FormState>();
File? selectImage;

class _updateStudentDetailsState extends State<updateStudentDetails> {
  late TextEditingController nameEditingController;
  late TextEditingController ageEditingController;
  late TextEditingController departmentEditingController;
  late TextEditingController phoneNoEditingController;
  late TextEditingController idEditingController;

  @override
  void initState() {
    int phone = widget.number.toInt();
    nameEditingController = TextEditingController(text: widget.name);
    ageEditingController = TextEditingController(text: widget.age.toString());
    departmentEditingController =
        TextEditingController(text: widget.department);
    phoneNoEditingController = TextEditingController(text: phone.toString());
    nameEditingController = TextEditingController(text: widget.name);
    idEditingController = TextEditingController(text: widget.id.toString());

    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "Update Students Details",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {
                        File? pickedImage =
                            await selectImageFromGallery(context);
                        setState(() {
                          selectImage = pickedImage;
                        });
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: selectImage != null
                                ? FileImage(selectImage!)
                                : FileImage(File(widget.imagesrc)),
                            radius: 70,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your Name";
                      } else if (value.length < 3) {
                        return "Enter at least three characters";
                      } else {
                        return null;
                      }
                    },
                    controller: idEditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Student ID",
                      hintText: "Student ID",
                      prefixIcon: Icon(
                        Icons.numbers,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your Name";
                      } else if (value.length < 3) {
                        return "Enter at least three characters";
                      } else {
                        return null;
                      }
                    },
                    controller: nameEditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Student Name",
                      hintText: "Student Name",
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter the Roll Number";
                    } else if (value.length > 3) {
                      return "Enter a valid Roll Number";
                    } else {
                      return null;
                    }
                  },
                  controller: ageEditingController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Age",
                    hintText: "Age",
                    prefixIcon: Icon(
                      Icons.calendar_month,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter department";
                    } else {
                      return null;
                    }
                  },
                  controller: departmentEditingController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Department",
                    hintText: "Department",
                    prefixIcon: Icon(
                      Icons.school,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter your phone number";
                    } else if (value.length != 10) {
                      return "Enter a valid phone number";
                    } else {
                      return null;
                    }
                  },
                  controller: phoneNoEditingController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Phone Number",
                    hintText: "Phone Number",
                    prefixIcon: Icon(
                      Icons.phone_rounded,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      if (selectImage != null || widget.imagesrc != null) {
                        final student = StudentModel(
                          id: int.parse(idEditingController.text),
                          studentname: nameEditingController.text,
                          age: int.parse(ageEditingController.text),
                          deparment: departmentEditingController.text,
                          phonenumber: phoneNoEditingController.text,
                          imageurl: selectImage == null
                              ? widget.imagesrc
                              : selectImage!.path,
                        );
                        await updateStudentDetailsFromDB(student);
                        idEditingController.clear();
                        nameEditingController.clear();
                        ageEditingController.clear();
                        departmentEditingController.clear();
                        phoneNoEditingController.clear();
                        setState(() {
                          selectImage = null;
                        });
                        snackBarFunction(
                          context,
                          "Upload Succrssfully",
                          Colors.green,
                        );
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Secondscreen(),
                        ));
                      } else {
                        snackBarFunction(
                          context,
                          "Please Select your Image",
                          Color.fromARGB(255, 200, 17, 4),
                        );
                      }
                    }
                  },
                  child: Text(
                    "Update",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.purple),
                    minimumSize: MaterialStateProperty.all(Size(370, 50)),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 370,
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}