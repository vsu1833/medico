import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:login/pages/health_analytics.dart';
import 'package:login/pages/patient_profileview.dart';

import 'package:login/components/symptoms/dentaldoc.dart';

import 'package:login/pages/profile_updation.dart';
import 'package:login/sidebar/category.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:login/pages/doctor_screen_page.dart';
import 'package:login/pages/whom_to_review_selection.dart';
import 'package:login/pages/upload_reports.dart';

// Doctor model class
class Doctor {
  final String name;
  final String specialization;
  final String image;
  final double rating;

  Doctor({
    required this.name,
    required this.specialization,
    required this.image,
    required this.rating,
  });

  // Factory method to create a Doctor from a Firestore document with null checks
  factory Doctor.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Doctor(
      name: (data['first_name'] ?? 'Unknown') + ' ' + (data['last_name'] ?? ''), // Provide default values
      specialization: data['specialization'] ?? 'Unknown', // Default value for specialization
      image: data['image'] ?? 'https://default-image-url.com', // Provide a default image URL
      rating: (data['stars_count'] ?? 0.0).toDouble(), // Default rating if not available
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // List of categories and icons
  final List catNames = [
    'Physician', 'Cardiologist', 'Surgeon', 'Orthopaedician', 'Pediatrician',
    'Skin Specialist', 'Gynecologist', 'ENT', 'Neurologist', 'Psychiatrist', 'Dentist',
  ];

  List<Icon> catIcons = [
    Icon(MdiIcons.hospital, color: const Color.fromARGB(255, 37, 135, 159), size: 30),
    Icon(MdiIcons.heart, color: const Color.fromARGB(255, 48, 181, 218), size: 30),
    Icon(MdiIcons.knife, color: const Color.fromARGB(255, 82, 212, 255), size: 30),
    Icon(MdiIcons.bone, color: const Color.fromARGB(255, 54, 202, 205), size: 30),
    Icon(MdiIcons.baby, color: const Color.fromARGB(255, 43, 165, 196), size: 30),
    Icon(MdiIcons.ski, color: const Color.fromARGB(255, 37, 135, 159), size: 30),
    Icon(MdiIcons.faceWoman, color: const Color.fromARGB(255, 48, 181, 218), size: 30),
    Icon(MdiIcons.earHearing, color: const Color.fromARGB(255, 82, 212, 255), size: 30),
    Icon(MdiIcons.brain, color: const Color.fromARGB(255, 54, 202, 205), size: 30),
    Icon(MdiIcons.emoticonSad, color: const Color.fromARGB(255, 43, 165, 196), size: 30),
    Icon(MdiIcons.toothOutline, color: const Color.fromARGB(255, 37, 135, 159), size: 30),
  ];

  // Function to fetch doctors from Firestore with added logging
  Stream<List<Doctor>> fetchDoctors() {
    return FirebaseFirestore.instance.collection('doctors').snapshots().map((snapshot) {
      print('Fetched ${snapshot.docs.length} documents'); // Log number of documents fetched
      return snapshot.docs.map((doc) => Doctor.fromFirestore(doc)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 3, 131, 170),
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
                    "Hi, Rogi",
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileViewApp(),
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
                    builder: (context) => const ProfileUpdateApp(),
                  ),
                );
              },
            ),
            ListTile(

              leading:
                  const Icon(Icons.meeting_room_outlined, color: Colors.teal),
              title: const Text('Book Appointment'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.health_and_safety, color: Colors.teal),
              title: Text('Ratings and Reviews'),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(

                    builder: (context) => const WhomToReviewSelection(),
                  ),
                );
              },
            ),
            ListTile(

              

              leading: const Icon(Icons.health_and_safety, color: Colors.teal),
              title: const Text('Upload Your Reports'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploadReports(),

                  ),
                );
              },
            ),
            ListTile(
             leading:
                  const Icon(Icons.favorite, color: Colors.teal),
              title: const Text('Health Analytics'),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HealthAnalyticsPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined, color: Colors.teal),
              title: const Text('Logout'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Container(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Box
            Container(
              margin: const EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width,
              height: 55,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 3,
                    blurRadius: 6,
                  ),
                ],
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search here...",
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 25,
                  ),
                ),
              ),
            ),

            // Symptoms Section
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                "Symptoms",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 110,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: catNames.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Dentaldoc(),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            height: 60,
                            width: 60,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Center(child: catIcons[index]),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            catNames[index],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Best Doctors Section
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                "Our Best Doctors",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ),
            SizedBox(
              height: 370,
              child: StreamBuilder<List<Doctor>>(
                stream: fetchDoctors(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No doctors found.'));
                  }

                  final doctors = snapshot.data!;

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: doctors.length,
                    itemBuilder: (BuildContext context, int index) {
                      final doctor = doctors[index];
                      return Container(
                        margin: const EdgeInsets.all(15),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        width: 220,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    spreadRadius: 2,
                                  ),
                                ],
                                image: DecorationImage(
                                  image: NetworkImage(doctor.image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              doctor.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              doctor.specialization,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.star, color: Colors.amber),
                                Text(
                                  '${doctor.rating}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 35,
                              width: 130,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const DoctorScreenPage( doctorId: '',
                                  doctorName: '',
                                  doctorSpecialization: '',
                                  doctorAddress: '',
                                  userId: '', // Use fetched user ID
                                  
                                
                                  
                              
                                doctorDescription:'', doctorImage: '', doctorLocation: '', doctorImages: [], consultationFee: ''),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 0, 115, 150),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'View Profile',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
