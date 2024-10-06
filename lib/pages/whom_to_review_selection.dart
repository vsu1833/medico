import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:login/components/black_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:login/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/pages/ratings_and_reviews.dart';

class WhomToReviewSelection extends StatefulWidget {
  const WhomToReviewSelection({super.key});

  @override
  State<WhomToReviewSelection> createState() => _WhomToReviewSelectionState();
}

class _WhomToReviewSelectionState extends State<WhomToReviewSelection> {
  Future<List<Map<String, dynamic>>> _fetchAppointments() async {
    // Get the current user's UID
    String uid = FirebaseAuth.instance.currentUser!.uid;

    // Query Firestore for appointments with status="true" and reviewStatus="false"
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('patientId', isEqualTo: uid)
        .where('status', isEqualTo: 'true')
        .where('reviewStatus', isEqualTo: 'false')
        .get();

    // Extract the list of appointment data
    List<Map<String, dynamic>> appointments = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    return appointments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Previous Appointments'),
        backgroundColor: const Color.fromARGB(255, 107, 170, 181),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading appointments'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No appointments to review'));
          } else {
            List<Map<String, dynamic>> appointments = snapshot.data!;
            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                final doctorName =
                    appointment['drName']; // Assuming 'doctorName' field exists
                final appointmentDate = appointment[
                    'date']; 
                final docId = appointment[
                    'docId'];// Assuming 'appointmentDate' field exists

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    title: Text('Doctor: $doctorName'),
                    subtitle: Text('Date: $appointmentDate'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        print(
                            '//////Navigation button has been pressed////////');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RatingsAndReviews(
                                drName: doctorName,
                                appointmentDate: appointmentDate,
                                docId: docId,),
                          ),
                        );
                      },
                      child: Text('Review'),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
