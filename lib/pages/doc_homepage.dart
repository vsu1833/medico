import 'package:flutter/material.dart';
import 'package:login/components/symptoms/dentaldoc.dart';
import 'package:login/pages/profile_updation.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:login/pages/doctor_screen_page.dart';
import 'package:login/pages/doc_profile_update.dart';
import 'package:login/pages/doctors_view_of_appointments.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor Home Screen',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: DocHomeScreen(),
    );
  }
}

class DocHomeScreen extends StatelessWidget {
  DocHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 120),
          child: Text(
            'M E D I C O',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage("images/patient1.jpeg"),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Hi, Doctor",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.teal),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.teal),
              title: const Text('Profile'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.update, color: Colors.teal),
              title: const Text('Update Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DoctorProfileUpdateApp(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.health_and_safety, color: Colors.teal),
              title: const Text('See Appointments Scheduled'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.teal),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),

            // Centered Container with Greeting Tile
            Center(
              child: Container(
                height: screenHeight * 0.35, // 30% of screen height
                width: screenWidth * 0.90, // 85% of screen width
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.lightBlue],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey
                          .withOpacity(0.3), // Reduced shadow color opacity
                      spreadRadius: 3, // Reduced spread radius
                      blurRadius: 8, // Reduced blur radius
                      offset: Offset(0, 4), // Reduced offset
                    ),
                  ],
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hello Doctor',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 20),
                        CircleAvatar(
                          radius: 50, // Increased size of the avatar
                          backgroundImage: AssetImage(
                            "assets/doc2.jpg", // Path to doctor's profile picture
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Space between greeting container and green containers
            SizedBox(height: 30),

            // Row for the green containers
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, // Space between the containers
              children: [
                // First Green Container
                Container(
                  height: screenHeight * 0.25, // 25% of screen height
                  width: screenWidth * 0.37, // 35% of screen width
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green, Colors.lightGreen],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey
                            .withOpacity(0.3), // Reduced shadow color opacity
                        spreadRadius: 3, // Reduced spread radius
                        blurRadius: 8, // Reduced blur radius
                        offset: Offset(0, 4), // Reduced offset
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Center vertically
                      mainAxisSize:
                          MainAxisSize.min, // Size to fit the children
                      children: [
                        Text(
                          'Ratings',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '4.8',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ), // Insert the actual rating here
                      ],
                    ),
                  ),
                ),

                // Second Green Container (exact copy of the first)
                Container(
                  height: screenHeight * 0.25, // 25% of screen height
                  width: screenWidth * 0.37, // 35% of screen width
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green, Colors.lightGreen],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey
                            .withOpacity(0.3), // Reduced shadow color opacity
                        spreadRadius: 3, // Reduced spread radius
                        blurRadius: 8, // Reduced blur radius
                        offset: Offset(0, 4), // Reduced offset
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Center vertically
                      mainAxisSize:
                          MainAxisSize.min, // Size to fit the children
                      children: [
                        Text(
                          'Appointments',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '450',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ), // Insert the actual rating here
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Space between green containers and review appointments container
            SizedBox(height: 30),

            // Review Appointments Container wrapped with GestureDetector
            GestureDetector(
              onTap: () {
                // Add your desired action here
                // For example, navigate to a new screen
                print("Review Appointments tapped");

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorsViewOfAppointments(),
                  ),
                ); // You can uncomment the following line to navigate to another page
                // Navigator.push(context, MaterialPageRoute(builder: (context) => YourNewScreen()));
              },
              child: Center(
                child: Container(
                  height: screenHeight * 0.15, // 20% of screen height
                  width: screenWidth * 0.90, // 90% of screen width
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.grey.shade600, Colors.grey.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey
                            .withOpacity(0.3), // Reduced shadow color opacity
                        spreadRadius: 3, // Reduced spread radius
                        blurRadius: 8, // Reduced blur radius
                        offset: Offset(0, 4), // Reduced offset
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Review Appointments',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
