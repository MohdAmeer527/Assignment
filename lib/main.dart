import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task/views/home_screen.dart';

void main() async {
  // Initialize Hive for Flutter to handle local storage.
  await Hive.initFlutter();
// Open a Hive box to store user images locally.
  await Hive.openBox('userImages');
  runApp(const MyApp());
}

// The root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.light,
      title: 'Task',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
