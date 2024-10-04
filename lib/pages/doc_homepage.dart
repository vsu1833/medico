import 'package:flutter/material.dart';
import 'package:login/components/symptoms/dentaldoc.dart';
import 'package:login/pages/profile_updation.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:login/pages/doctor_screen_page.dart';
import 'package:login/pages/doc_profile_update.dart';

class DocHomeScreen extends StatelessWidget {
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
              leading: Icon(Icons.update, color: Colors.teal),
              title: Text('Update Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorProfileUpdateApp(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.health_and_safety, color: Colors.teal),
              title: Text('See Appointments Scheduled'),
              onTap: () {
                // Add appointments navigation logic here
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.teal),
              title: Text('Logout'),
              onTap: () {
                // Add logout logic here
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Box
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15),
              width: MediaQuery.of(context).size.width,
              height: 55,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
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
                  prefixIcon: Icon(
                    Icons.search,
                    size: 25,
                  ),
                ),
              ),
            ),

            // Symptoms Section
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Symptoms",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: 110,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: catNames.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.0), // Increased horizontal gap
                    child: InkWell(
                      onTap: () {
                        // Show dialog here
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Notice'),
                            content: Text(
                                'Work is in progress on doc page. This is just a trial'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the dialog
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
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
                          SizedBox(height: 10),
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
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Our Best Doctors",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ),
            Container(
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
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
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
                                    borderRadius: BorderRadius.only(
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
                                    margin: EdgeInsets.all(8),
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                            spreadRadius: 2,
                                          ),
                                        ]),
                                    child: Center(
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
                            SizedBox(
                              height: 8,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
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
                                      fontSize: 15,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 20,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "4.9",
                                        style: TextStyle(
                                          fontSize: 14,
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
