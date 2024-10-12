import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/pages/doc_appointment_review.dart';

class DoctorsViewOfAppointments extends StatefulWidget {
  @override
  _DoctorsViewOfAppointmentsState createState() =>
      _DoctorsViewOfAppointmentsState();
}

class _DoctorsViewOfAppointmentsState extends State<DoctorsViewOfAppointments> {
  // Instance of Firestore and FirebaseAuth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // List to hold appointments
  List<DocumentSnapshot> _appointments = [];

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  // Fetch appointments from Firestore
  Future<void> _fetchAppointments() async {
    String currentUserId = _auth.currentUser!.uid; // Get current user ID

    // Query Firestore for appointments where doctorId matches currentUserId
    QuerySnapshot querySnapshot = await _firestore
        .collection('appointments')
        .where('doctor_id', isEqualTo: currentUserId)
        .where('status', isEqualTo: false)
        .get();

    setState(() {
      _appointments = querySnapshot.docs; // Store the fetched appointments
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Change the color of the icons here
        ),
        backgroundColor: Colors.black87,
        title: Center(
          child: Text(
            'A P P O I N T M E N T S', // Title with spacing
            style:
                TextStyle(letterSpacing: 2, fontSize: 24, color: Colors.white),
          ),
        ),
      ),
      body: _appointments.isEmpty
          ? Center(
              child:
                  CircularProgressIndicator(), // Show a loading indicator while fetching
            )
          : ListView.builder(
              itemCount: _appointments.length,
              itemBuilder: (context, index) {
                var appointment = _appointments[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DocAppointmentReview(
                                patientId: appointment['patient_id'])));
                  },
                  child: Card(
                    margin: EdgeInsets.all(10),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Patient Id: ${appointment['patient_id']}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Date: ${appointment['date']}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Time: ${appointment['time']}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Status: ${appointment['status']}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
