import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/components/symptoms/dentaldoc.dart';
import 'package:login/pages/doc_profileview.dart';
import 'package:login/pages/profile_updation.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:login/pages/doctor_screen_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/pages/doc_profile_update.dart';
import 'package:login/pages/doctors_view_of_appointments.dart';
import 'package:login/pages/login_page.dart';

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
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  DocHomeScreen({super.key});

  // Fetching doctor's first name from Firestore
  Future<String?> getDoctorFirstName() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(currentUserId)
        .get();

    if (snapshot.exists) {
      return snapshot.data()?['first_name'] as String?;
    } else {
      print('No doctor found');
      return null;
    }
  }

  // Fetching profile image URL from Firestore
  Future<String?> getProfileImageUrl() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(currentUserId)
        .get();

    if (snapshot.exists) {
      return snapshot.data()?['profile_image_url'] as String?;
    } else {
      print('No profile image found for doctor');
      return null;
    }
  }

  Future<int> getTotalAppointments() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('doctor_id', isEqualTo: currentUserId)
        .get();

    return querySnapshot.size;
  }

  Future<double> getAverageRating() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('reviews')
        .where('docId', isEqualTo: currentUserId)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return 0.0; // No reviews found
    }

    double totalStars = 0.0;
    for (var doc in querySnapshot.docs) {
      totalStars += doc['stars_count'];
    }

    return totalStars / querySnapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black87,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 55),
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
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.teal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<String?>(
                    future: getProfileImageUrl(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError || !snapshot.hasData) {
                        return const CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage("assets/doc2.jpg"),
                        );
                      }
                      return CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(snapshot.data!),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Hi, Doctor",
                    style: TextStyle(color: Colors.white, fontSize: 20),
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DocProfileViewApp(),
                  ),
                );
              },
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
              leading:
                  const Icon(Icons.calendar_today_sharp, color: Colors.teal),
              title: const Text('See Appointments Scheduled'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorsViewOfAppointments(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.teal),
              title: const Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
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
            const SizedBox(height: 10),
            Center(
              child: Container(
                height: screenHeight * 0.33,
                width: screenWidth * 0.90,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.lightBlue],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FutureBuilder<String?>(
                        future: getDoctorFirstName(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.hasError || !snapshot.hasData) {
                            return const Text(
                              'Hello Doctor',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }
                          return Text(
                            'Hello ${snapshot.data}',
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 20),
                      FutureBuilder<String?>(
                        future: getProfileImageUrl(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.hasError || !snapshot.hasData) {
                            return const CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage("assets/doc2.jpg"),
                            );
                          }
                          return CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(snapshot.data!),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FutureBuilder<int>(
                  future: getTotalAppointments(),
                  builder: (context, snapshot) {
                    return Container(
                      height: screenHeight * 0.25,
                      width: screenWidth * 0.45,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.green, Colors.lightGreen],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Appointments',
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Text(
                                  snapshot.hasData ? '${snapshot.data}' : '...',
                                  style: const TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,

                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                FutureBuilder<double>(
                  future: getAverageRating(),
                  builder: (context, snapshot) {
                    return Container(
                      height: screenHeight * 0.25,
                      width: screenWidth * 0.45,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.green, Colors.lightGreen],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Ratings',
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  snapshot.hasData
                                      ? snapshot.data!.toStringAsFixed(1)
                                      : '...',
                                  style: const TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 30.0,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorsViewOfAppointments(),
                  ),
                );
              },
              child: Center(
                child: Container(
                  height: screenHeight * 0.15,
                  width: screenWidth * 0.90,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.grey.shade600, Colors.grey.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'See Appointments Scheduled',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
