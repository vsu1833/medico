import 'package:login/category.dart';

import 'package:login/components/symptoms/dentaldoc.dart';
import 'package:flutter/material.dart';
import 'package:login/pages/health_analytics.dart';
import 'package:login/pages/patient_profileview.dart';
import 'package:login/pages/profile_updation.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:login/pages/doctor_screen_page.dart';
import 'package:login/pages/ratings_and_reviews.dart';

class HomeScreen extends StatelessWidget {
  // List of categories and icons
  List catNames = ["Dental", "Health", "Eye", "Brain", "Ear", "Bone"];

  List<Icon> catIcons = [
    Icon(MdiIcons.toothOutline,
        color: const Color.fromARGB(255, 37, 135, 159), size: 30),
    Icon(MdiIcons.heartPlus,
        color: const Color.fromARGB(255, 48, 181, 218), size: 30),
    Icon(MdiIcons.eye,
        color: const Color.fromARGB(255, 82, 212, 255), size: 30),
    Icon(MdiIcons.brain,
        color: const Color.fromARGB(255, 54, 202, 205), size: 30),
    Icon(MdiIcons.earHearing,
        color: const Color.fromARGB(255, 43, 165, 196), size: 30),
    Icon(MdiIcons.bone,
        color: const Color.fromARGB(255, 37, 135, 159), size: 30),
  ];

  List imgs = [
    "images/doct1.jpg",
    "images/doct2.jpg",
    "images/doct3.jpeg",
    "images/doctor1.jpg",
    "images/doctor2.jpeg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with Drawer icon
      appBar: AppBar(),

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
                    builder: (context) => ProfileUpdateApp(),
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
                    builder: (context) => RatingsAndReviews(),
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
              leading:
                  const Icon(Icons.meeting_room_outlined, color: Colors.teal),
              title: const Text('logout'),
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
              margin: const EdgeInsets.only(
                  top: 20, bottom: 20, left: 15, right: 15),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0), // Increased horizontal gap
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
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: imgs.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        height: 300,
                        width: 200,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    // Navigate to DoctorScreenPage on tap
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DoctorScreenPage(),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                    child: Image.asset(
                                      imgs[index],
                                      height: 200,
                                      width: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    margin: const EdgeInsets.all(8),
                                    height: 45,
                                    width: 45,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                            spreadRadius: 2,
                                          ),
                                        ]),
                                    child: const Center(
                                      child: Icon(
                                        Icons.favorite_outline,
                                        color: Colors.teal,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Dr. Tanish Hede",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                  ),
                                  Text(
                                    "Surgeon",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        "4.9",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
