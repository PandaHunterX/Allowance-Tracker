import 'package:flutter/material.dart';
import 'package:productivity_app/views/users/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Financial Buddy',
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}


