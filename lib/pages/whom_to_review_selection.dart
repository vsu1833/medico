import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    print('Current user UID: $uid'); // Add this line for debugging

    // Query Firestore for appointments with status="true" and reviewStatus="false"
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('patient_id', isEqualTo: uid)
        .where('status', isEqualTo: true)
        .where('review_status', isEqualTo: false)
        .get();
    print(
        'Number of appointments fetched: ${querySnapshot.docs.length}'); // Add this line
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
        title: const Text('Your Previous Appointments'),
        backgroundColor: const Color.fromARGB(255, 3, 131, 170),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading appointments'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No appointments to review'));
          } else {
            List<Map<String, dynamic>> appointments = snapshot.data!;
            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                final doctorName = appointment[
                    'doctor_name']; // Assuming 'doctorName' field exists
                final appointmentDate = appointment['date'];
                final docId = appointment[
                    'doctor_id']; // Assuming 'appointmentDate' field exists

                return SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: Card(
                    color: Colors.blue, // Background color for the card
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15.0), // Rounded corners
                    ),
                    elevation: 5, // Shadow around the card
                    child: Padding(
                      padding: const EdgeInsets.all(12.0), // Padding inside the card
                      child: ListTile(
                        title: Text(
                          'Doctor: $doctorName',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // White text for the title
                          ),
                        ),
                        subtitle: Text(
                          'Date: $appointmentDate',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white, // White text for the subtitle
                          ),
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black, // Button color
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20), // Rounded button corners
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RatingsAndReviews(
                                  drName: doctorName,
                                  appointmentDate: appointmentDate,
                                  docId: docId,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Review',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white, // White text for the button
                            ),
                          ),
                        ),
                      ),
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
