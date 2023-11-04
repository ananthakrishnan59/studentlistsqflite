import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:studentid/FirstScreen.dart';
import 'package:studentid/StudentModel.dart';





late Database database;
Future<void> initializeDatabase() async {
  database = await openDatabase("student.db", version: 1,
      onCreate: (Database database, int version) async {
    await database.execute(
        'CREATE TABLE student (id INTEGER PRIMARY KEY ,name TEXT, age INTEGER , department TEXT, number REAL,imagesrc)');
  });
}

Future<void> addStudentToDB(StudentModel value, BuildContext context) async {
  final existingRecord =
      await database.query('student', where: 'id = ?', whereArgs: [value.id]);
  if (existingRecord.isEmpty) {
    await database.rawInsert(
        "INSERT INTO student(id,name, age, department,number,imagesrc) VALUES(?,?,?,?,?,?)",
        [
          value.id,
          value.studentname,
          value.age,
          value.deparment,
          value.phonenumber,
          value.imageurl
        ]);
    // ignore: use_build_context_synchronously
    snackBarFunction(
        context, "The Student Details are upload Successfully", Colors.green);
  } else {
    // ignore: use_build_context_synchronously
    snackBarFunction(
        context, "The Student id is also present in the database ", Colors.red);
  }
}

Future<List<Map<String, dynamic>>> getAllStudentDataFromDB() async {
  final value = await database.rawQuery("SELECT * FROM  student");
  return value;
}

Future<void> deleteStudentDetailsFromDB(int id) async {
  database.rawDelete('DELETE FROM student WHERE id = ?', [id]);
}

Future<void> updateStudentDetailsFromDB(StudentModel updatedStudent) async {
  // ignore: unused_local_variable
  final updatedData = await database.update(
      'student',
      {
        'id': updatedStudent.id,
        'name': updatedStudent.studentname,
        'age': updatedStudent.age,
        'department': updatedStudent.deparment,
        'number': updatedStudent.phonenumber,
        'imagesrc': updatedStudent.imageurl,
      },
      where: 'id = ?',
      whereArgs: [updatedStudent.id]);
}