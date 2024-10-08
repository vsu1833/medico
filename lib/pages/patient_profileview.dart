import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/pages/main_screen.dart';
import 'package:login/pages/profile_updation.dart';

class ProfileViewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient Profile View',
      home: ProfileViewPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProfileViewPage extends StatefulWidget {
  @override
  _ProfileViewPageState createState() => _ProfileViewPageState();
}

class _ProfileViewPageState extends State<ProfileViewPage> {
  String? uid;
  String? email;
  String? firstName;
  String? middleName;
  String? lastName;
  String? houseNo;
  String? city;
  String? pincode;
  String? phone;
  String? gender;
  DateTime? dob;

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
          .collection('patients')
          .doc(currentUser.uid)
          .get();

      if (docSnapshot.exists) {
        setState(() {
          firstName = docSnapshot['first_name'];
          middleName = docSnapshot['middle_name'];
          lastName = docSnapshot['last_name'];
          houseNo = docSnapshot['address']['house_no'];
          city = docSnapshot['address']['city'];
          pincode = docSnapshot['address']['pincode'];
          phone = docSnapshot['phone'];
          gender = docSnapshot['gender'];
          dob = DateTime.parse(docSnapshot['dob']);
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
          title: Text('Patient Profile'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 107, 170, 181),
        ),
        body: Center(child: CircularProgressIndicator()), // Loading indicator
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Profile'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 107, 170, 181),
         actions: [
          TextButton(
            onPressed: () {
              // Navigate to the Profile Update Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileUpdatePage()),
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 9, 43, 101), // Change button color here // Text color
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Padding for button
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
                    fontSize: 16, // Font size for the text
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
                    backgroundImage: AssetImage('assets/doc1.jpg'), // Placeholder image
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Patient ID: $uid', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('Email: $email', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('First Name: $firstName', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('Middle Name: $middleName', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('Last Name: $lastName', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('Date of Birth: ${dob != null ? DateFormat('dd/MM/yyyy').format(dob!) : 'Not provided'}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('Gender: $gender', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('Address: $houseNo, $city, Pincode: $pincode', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('Phone: $phone', style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainScreen(),
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
