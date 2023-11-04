import 'package:flutter/material.dart';
import 'package:studentid/FirstScreen.dart';
import 'package:studentid/Database.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home:Students(),
      debugShowCheckedModeBanner: false,

    );}
}

