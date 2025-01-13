import 'package:auto_size_text/auto_size_text.dart';
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
  int pageIndex = 0;

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
        toolbarHeight: 80,
        title: Row(
          children: [
            Image.asset(
              'assets/images/icon.png',
              width: 100,
            ),
            Expanded(
              child: AutoSizeText(
                'Pocket Wallet',
                maxLines: 1,
                style: TextStyle(
                  fontSize: 42,
                  fontFamily: 'Sriracha',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade300,
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.sizeOf(context).height * .12,
        decoration: BoxDecoration(
          color: Colors.transparent,
          // Matches the BottomNavigationBar background
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
              currentIndex: pageIndex,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.blue.shade50,
              iconSize: MediaQuery.of(context).size.width * 0.1,
              // Icon size responsive to screen width
              unselectedItemColor: Colors.blue.shade200,
              selectedItemColor: Colors.blue.shade700,
              selectedFontSize: MediaQuery.of(context).size.width * 0.045,
              // Font size responsive to screen width
              unselectedFontSize: MediaQuery.of(context).size.width * 0.04,
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width *
                    0.04, // Dynamic font size
              ),
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width *
                    0.045, // Dynamic font size
              ),
              showSelectedLabels: true,
              onTap: (value) {
                setState(() {
                  pageIndex = value;
                });
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.auto_graph), label: 'Stats'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search), label: 'Search'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'User'),
              ],
            )),
      ),
      body: _pages[pageIndex],
    );
  }
}
