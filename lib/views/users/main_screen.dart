import 'package:flutter/material.dart';
import 'package:productivity_app/views/screens/home_screen.dart';
import 'package:productivity_app/views/users/user_screen.dart';

import '../screens/stats_screen.dart';
import '../screens/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _page_index = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const GraphScreen(),
    const SearchScreen(),
    const UserScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text('Finance Buddy',style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87 , letterSpacing: 4),),
        backgroundColor: Colors.blue.shade300,
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.transparent, // Matches the BottomNavigationBar background
          border: Border.all(
            width: 5,
            color: Colors.blue.shade900,
            style: BorderStyle.solid,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(64),
            topRight: Radius.circular(64),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(64),
            topRight: Radius.circular(64),
          ),
          child: BottomNavigationBar(
            currentIndex: _page_index,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.blue.shade50, // Use transparent to show Container's background
            iconSize: 50,
            unselectedItemColor: Colors.blue.shade200,
            selectedItemColor: Colors.blue.shade700,
            selectedFontSize: 20,
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            showSelectedLabels: true,
            onTap: (value) {
              setState(() {
                _page_index = value;
              });
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.auto_graph), label: 'Stats'),
              BottomNavigationBarItem(icon: Icon(Icons.search),label: 'Search'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User'),
            ],
          ),
        ),
      ),
      body: _pages[_page_index],
    );
  }
}
