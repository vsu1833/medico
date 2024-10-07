// import 'package:appointmentpage/pages/doctor_screen_page.dart';

// import 'package:appointmentpage/pages/home_screen.dart';
import 'package:login/pages/scheduleScreen.dart';
import 'package:login/pages/home_screen.dart';
import 'package:flutter/material.dart';
// import '../components/scheduleScreen.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // These should be inside the state class
  int _selectedIndex = 0; 
  final List<Widget> _screens = [
    HomeScreen(),
   const ScheduleScreen(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex], // This will switch between your screens
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 30, 167, 198),
        unselectedItemColor: const Color.fromARGB(130, 0, 0, 0),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update selected index
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(CupertinoIcons.chat_bubble_text_fill),
          //   label: 'Messages',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Scheduled',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
