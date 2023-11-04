import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studentid/StudentModel.dart';
import 'package:studentid/Database.dart';
import 'package:studentid/SecondScreen.dart';

class Students extends StatefulWidget {
 const Students({Key? key}) : super(key: key);

  @override
  State<Students> createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final departmentController = TextEditingController();
  final phoneNoController = TextEditingController();
  final idController = TextEditingController();
  final parentsController = TextEditingController();
  File? selectedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        centerTitle: true,
        title: const Column(
          children: [
            Text(
              "Student Information",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Secondscreen()),
                );
              },
              icon:const Icon(Icons.person_search),
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding:const EdgeInsets.all(20.0),
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
                          selectedImage = pickedImage;
                        });
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: selectedImage != null
                                ? FileImage(selectedImage!)
                                : null,
                            child: selectedImage == null
                                ? Icon(
                                    Icons.add_a_photo,
                                    color: Colors.black,
                                    size: 25,
                                  )
                                : Icon(null),
                            radius: 70,
                            backgroundColor: Colors.purple,
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
                        return "Please enter your ID";
                      } else if (value.length < 3) {
                        return "Enter at least three characters";
                      } else {
                        return null;
                      }
                    },
                    controller: idController,
                    decoration:const InputDecoration(
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
                  padding: const EdgeInsets.only(top: 40),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your Parentname";
                      } else if (value.length < 3) {
                        return "Enter at least three characters";
                      } else {
                        return null;
                      }
                    },
                    controller: parentsController,
                    decoration:const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "parents",
                      hintText: "parents",
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
                    controller: nameController,
                    decoration:const InputDecoration(
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
              const  SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter the age";
                    } else if (value.length > 3) {
                      return "Enter a valid  age";
                    } else {
                      return null;
                    }
                  },
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration:const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Age",
                    hintText: "Age",
                    prefixIcon: Icon(
                      Icons.calendar_month,
                      color: Colors.black,
                    ),
                  ),
                ),
              const  SizedBox(
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
                  controller: departmentController,
                  decoration:const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Department",
                    hintText: "Department",
                    prefixIcon: Icon(
                      Icons.school,
                      color: Colors.black,
                    ),
                  ),
                ),
               const SizedBox(
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
                  controller: phoneNoController,
                  keyboardType: TextInputType.phone,
                  decoration:const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Phone Number",
                    hintText: "Phone Number",
                    prefixIcon: Icon(
                      Icons.phone_rounded,
                      color: Colors.black,
                    ),
                  ),
                ),
              const  SizedBox(
                  height: 100,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      if (selectedImage != null) {
                        final student = StudentModel(
                          id: int.parse(idController.text),
                          studentname: nameController.text,
                       age: int.parse(ageController.text),
                          deparment: departmentController.text,
                          phonenumber: phoneNoController.text,
                          imageurl: selectedImage!.path,
                        );
                        await addStudentToDB(student, context);
                        idController.clear();
                        nameController.clear();
                        ageController.clear();
                        departmentController.clear();
                        phoneNoController.clear();
                        setState(() {
                          selectedImage = null;
                        });
                      } else {
                        snackBarFunction(
                          context,
                          "Please Select your Image",
                         const Color.fromARGB(255, 200, 17, 4),
                        );
                      }
                    }
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.purple),
                    minimumSize: MaterialStateProperty.all(Size(370, 50)),
                  ),
                ),
              const  SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 370,
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side:const BorderSide(color: Colors.purple, width: 2),
                    ),
                    onPressed: () {
                      nameController.clear();
                      ageController.clear();
                      departmentController.clear();
                      phoneNoController.clear();
                      idController.clear();
                      (() {
                        selectedImage = null;
                      });
                    },
                    child: Text(
                      "Clear",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
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

Future<File?> selectImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    snackBarImage(e.toString(), context);
  }
  return image;
}

void snackBarImage(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

void snackBarFunction(BuildContext context, String content, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
    backgroundColor: color,
  ));
}