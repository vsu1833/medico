import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:login/components/category_card.dart';

import 'package:login/pages/health_analytics.dart';
import 'package:login/pages/login_page.dart';
import 'package:login/pages/patient_profileview.dart';

import 'package:login/components/symptoms/dentaldoc.dart';

import 'package:login/pages/profile_updation.dart';
import 'package:login/sidebar/category.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:login/pages/doctor_screen_page.dart';
import 'package:login/pages/profile_updation.dart';
import 'package:login/pages/whom_to_review_selection.dart';
import 'package:login/pages/upload_reports.dart';
import 'package:login/sidebar/category.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:login/sidebar/appointment_booking.dart';
import 'package:login/pages/login_page.dart';

class Doctor {
  final String name;
  final String specialization;
  final String image;
  final String address;
  final String description;
  final String phone;
  final String id;
  final String gender;
  final String consultationfee;

  Doctor({
    required this.name,
    required this.specialization,
    required this.image,
    required this.address,
    required this.description,
    required this.phone,
    required this.id,
    required this.gender,
    required this.consultationfee,
  });

  factory Doctor.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Doctor(
      name: (data['first_name'] ?? 'Unknown') + ' ' + (data['last_name'] ?? ''),
      specialization: data['specialization'] ?? 'Unknown',
      consultationfee: data['consultationfee'] ?? '400 ₹',
      image: data['profile_image_url'] ?? 'https://default-image-url.com',
      address: data['address'] ?? 'Unknown Address',
      description: data['description'] ?? 'No description available',
      phone: data['phone'] ?? 'No phone available',
      id: doc.id,
      gender: data['gender'] ?? 'Unknown',
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> catNames = [
    'Physician',
    'Cardiologist',
    'Surgeon',
    'Orthopaedician',
    'Pediatrician',
    'Skin Specialist',
    'Gynecologist',
    'ENT',
    'Neurologist',
    'Psychiatrist',
    'Dentist',
  ];

  final List<Icon> catIcons = [
    Icon(MdiIcons.hospital, size: 30),
    Icon(MdiIcons.heart, size: 30),
    Icon(MdiIcons.knife, size: 30),
    Icon(MdiIcons.bone, size: 30),
    Icon(MdiIcons.baby, size: 30),
    Icon(MdiIcons.ski, size: 30),
    Icon(MdiIcons.faceWoman, size: 30),
    Icon(MdiIcons.earHearing, size: 30),
    Icon(MdiIcons.brain, size: 30),
    Icon(MdiIcons.emoticonSad, size: 30),
    Icon(MdiIcons.toothOutline, size: 30),
  ];

  String searchQuery = '';

  Stream<List<Doctor>> fetchDoctors() {
    return FirebaseFirestore.instance
        .collection('doctors')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Doctor.fromFirestore(doc)).toList();
    });
  }

  Future<String> fetchUserId(String patientPhone) async {
    QuerySnapshot patientSnapshot = await FirebaseFirestore.instance
        .collection('patients')
        .where('phone', isEqualTo: patientPhone)
        .get();

    if (patientSnapshot.docs.isEmpty) {
      return ''; // No patient found
    }

    return patientSnapshot.docs.first.id; // Returning the patient ID (userId)
  }

  Future<double> fetchDoctorRating(String doctorId) async {
    QuerySnapshot reviewsSnapshot = await FirebaseFirestore.instance
        .collection('reviews')
        .where('docId', isEqualTo: doctorId)
        .get();

    if (reviewsSnapshot.docs.isEmpty) {
      return 0.0; // No reviews available
    }

    double totalStars = 0;
    int reviewCount = reviewsSnapshot.docs.length;

    reviewsSnapshot.docs.forEach((reviewDoc) {
      double stars = reviewDoc['stars_count'] ?? 0.0;
      totalStars += stars;
    });

    return totalStars / reviewCount; // Average rating
  }

// Function to fetch the current user's ID (patient ID) and username (patient name) from Firebase
  Future<Map<String, String>> fetchUserInfo() async {
    String? phone = FirebaseAuth.instance.currentUser
        ?.phoneNumber; // Getting the phone of the logged-in user
    if (phone == null)
      return {}; // Return empty if user is not logged in or phone is not available

    QuerySnapshot patientSnapshot = await FirebaseFirestore.instance
        .collection('patients')
        .where('phone', isEqualTo: phone)
        .get();

    if (patientSnapshot.docs.isEmpty) {
      return {}; // No patient found
    }

    // Fetch patient ID and name (username)
    DocumentSnapshot patientDoc = patientSnapshot.docs.first;
    String userId = patientDoc.id;
    String userName = patientDoc['first_name'] ?? 'Unknown Name';

    return {
      'userId': userId,
      'userName': userName,
    };
  }

  String username = 'Loading...';

  @override
  void initState() {
    super.initState();
    fetchAndSetUserInfo();
  }

  void fetchAndSetUserInfo() async {
    Map<String, String> userInfo = await fetchUserInfo();
    setState(() {
      username = userInfo['userName'] ?? 'Unknown Name';
    });
  }

  final List<String> bannerImages = [
    'assets/images/appIcon.jpeg',
  ];

  // Banner carousel widget
  Widget buildBannerCarousel() {
    return SizedBox(
      height: 150, // Adjust height to fill the space
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: bannerImages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                bannerImages[index],
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * 0.9,
              ),
            ),
          );
        },
      ),
    );
  }

// Inside your ListTile onPressed, modify it to fetch and send the username

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
                color: Color.fromARGB(255, 3, 165, 170),
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
                    "Hi , Patient",
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
                    builder: (context) => const ProfileUpdatePage(),
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
              leading: const Icon(Icons.favorite, color: Colors.teal),
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
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add the banner carousel here
            buildBannerCarousel(),
            const SizedBox(height: 20),
            // Search Box
            Container(
              margin: const EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width,
              height: 75, // Increased height for a bigger search box
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                    255, 189, 198, 203), // New color for the search box
                borderRadius: BorderRadius.circular(12),
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
                  hintText: "Search for doctors or specializations...",
                  hintStyle: TextStyle(
                    color:
                        const Color.fromARGB(255, 23, 12, 12).withOpacity(0.8),
                    fontSize: 16,
                  ),
                  prefixIcon:
                      const Icon(Icons.search, size: 30, color: Colors.white),
                ),
                onChanged: (query) {
                  setState(() {
                    searchQuery = query;
                  });
                },
              ),
            ),

            // Symptoms Section
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                "Categories",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(
                      187, 0, 0, 0), // Changed color for better visibility
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
                            builder: (context) =>
                                DoctorsPage(category: catNames[index]),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            height: 70, // Increased size of the category icons
                            width: 70,
                            decoration: BoxDecoration(
                              color: Colors.teal
                                  .shade500, // Updated color for category circles
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
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
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromARGB(
                                  182, 1, 27, 24), // Updated text color
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Doctors Section
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                "Doctors",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(
                      187, 0, 0, 0), // Changed color for better visibility
                ),
              ),
            ),
            const SizedBox(height: 10),

            // List of Doctors (StreamBuilder)
            StreamBuilder<List<Doctor>>(
              stream: fetchDoctors(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final List<Doctor> filteredDoctors =
                    snapshot.data!.where((doctor) {
                  return doctor.name
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()) ||
                      doctor.specialization
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase());
                }).toList();

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredDoctors.length,
                  itemBuilder: (context, index) {
                    final doctor = filteredDoctors[index];

                    return FutureBuilder<double>(
                      future: fetchDoctorRating(doctor.id),
                      builder: (context, ratingSnapshot) {
                        double rating = ratingSnapshot.data ?? 0.0;

                        // String userId = userIdSnapshot.data ?? '';

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(doctor.image),
                              onBackgroundImageError: (exception, stackTrace) {
                                // Handle the error, maybe set a default image or log it
                                print('Error loading image: $exception');
                              },
                            ),
                            title: Text(
                              doctor.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(181, 0, 0, 0),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doctor.specialization,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      rating.toStringAsFixed(1),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.arrow_forward_ios,
                                  color: Colors.teal.shade800),
                              onPressed: () async {
                                String userId =
                                    FirebaseAuth.instance.currentUser?.uid ??
                                        '';

                                if (userId.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DoctorScreenPage(
                                        userId:
                                            userId, // Pass the fetched user ID (patient ID)
                                        doctorId: doctor
                                            .id, // Pass doctor details as needed
                                        doctorName: doctor.name,
                                        doctorSpecialization:
                                            doctor.specialization,
                                        consultationFee: doctor.consultationfee,
                                        phone: doctor.phone,
                                        doctorDescription: doctor.description,
                                        doctorLocation: doctor.address,
                                        doctorAddress: doctor.address,
                                        doctorImage: doctor.image,
                                        doctorImages: [],
                                      ),
                                    ),
                                  );
                                } else {
                                  // Show an error message if the user is not logged in
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('User not logged in')),
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
