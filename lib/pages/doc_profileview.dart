import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/pages/doc_profile.dart';
import 'package:login/pages/main_screen.dart';
import 'package:login/pages/profile_updation.dart';
import 'package:login/pages/doc_homepage.dart';

class DocProfileViewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor Profile View',
      home: DocProfileViewPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DocProfileViewPage extends StatefulWidget {
  @override
  _DocProfileViewPageState createState() => _DocProfileViewPageState();
}

class _DocProfileViewPageState extends State<DocProfileViewPage> {
  String? uid;
  String? email;
  String? firstName;
  String? middleName;
  String? lastName;
  String? address;
  String? phone;
  String? gender;
  String? description;
  String? specialization;
  DateTime? dob;
  String? profileImageUrl;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDetails(); // Fetch details when the page is initialized
  }

  Future<void> fetchUserDetails() async {
    // Get the current logged-in user from Firebase Authentication
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      setState(() {
        uid = currentUser.uid;
        email = currentUser.email;
      });

      // Fetch user details from Firestore
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(currentUser.uid)
          .get();

      if (docSnapshot.exists) {
        setState(() {
          firstName = docSnapshot['first_name'];
          middleName = docSnapshot['middle_name'];
          lastName = docSnapshot['last_name'];
          address = docSnapshot['address'];
          phone = docSnapshot['phone'];
          gender = docSnapshot['gender'];
          //dob = DateTime.parse(docSnapshot['dob']);
          specialization = docSnapshot['specialization'];
          description = docSnapshot['description'];
          profileImageUrl = docSnapshot['profile_image_url'];
          _isLoading = false; // Data is loaded
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user data found.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User is not logged in.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Doctor Profile'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 107, 170, 181),
        ),
        body: Center(child: CircularProgressIndicator()), // Loading indicator
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Profile'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 107, 170, 181),
        actions: [
          TextButton(
            onPressed: () {
              // Navigate to the Profile Update Page
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DoctorProfileUpdateApp()),
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: Color.fromARGB(
                  255, 9, 43, 101), // Change button color here // Text color
              padding: EdgeInsets.symmetric(
                  horizontal: 10, vertical: 6), // Padding for button
            ),
            child: Row(
              children: [
                Icon(
                  Icons.edit, // Edit icon
                  color: Colors.white, // Icon color
                ),
                SizedBox(width: 4), // Small space between icon and text
                Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: Colors.white, // Text color for the button
                    fontSize: 14, // Font size for the text
                  ),
                ),
              ],
            ),
          ),
          /*TextButton.icon(
            onPressed: () {
              // Navigate to the Profile Update Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileUpdatePage()),
              );
            },
            icon: Icon(
              Icons.edit, // Edit icon
              color: Colors.white, // Icon color
            ),
            label: Text(
              'Edit Profile',
              style: TextStyle(
                color: Colors.white, // Text color for the button
                fontSize: 16, // Font size for the text
              ),
            ),
          ),*/
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  radius: 56,
                  backgroundColor: const Color.fromARGB(255, 107, 170, 181),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: profileImageUrl != null
                        ? NetworkImage(profileImageUrl!)
                        : AssetImage('assets/doc1.jpg'), // Placeholder image
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Doctor ID: $uid', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('Email: $email', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('First Name: Dr. $firstName',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('Middle Name: $middleName', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('Last Name: $lastName', style: TextStyle(fontSize: 16)),
              /*SizedBox(height: 10),
              Text(
                  'Date of Birth: ${dob != null ? DateFormat('dd/MM/yyyy').format(dob!) : 'Not provided'}',
                  style: TextStyle(fontSize: 16)),*/
              SizedBox(height: 10),
              Text('Gender: $gender', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('Address: $address', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('Phone: $phone', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('Specialization: $specialization',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('Description: $description', style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DocHomeScreen(),
                      ),
                    );
                  },
                  child: Text('Back to Main Screen'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 107, 170, 181),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
