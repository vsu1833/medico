import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:login/pages/healthanalytics_update.dart';
import 'package:login/pages/PDF_view_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class DocAppointmentReview extends StatefulWidget {
  final String patientId;

  const DocAppointmentReview({Key? key, required this.patientId})
      : super(key: key);

  @override
  _DocAppointmentReviewState createState() => _DocAppointmentReviewState();
}

class _DocAppointmentReviewState extends State<DocAppointmentReview> {
  DocumentSnapshot? _patientDetails;
  DocumentSnapshot? _healthAnalytics;
  DocumentSnapshot? _latestReport;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPatientDetails();
    _fetchLatestReport();
  }

  Future<void> _cancelAppointment() async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!
          .uid; // Get the current doctor's ID from your auth state or context
      print('////////////UserId ' + currentUserId + '////////////');
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctor_id', isEqualTo: currentUserId)
          .where('patient_id',
              isEqualTo: widget.patientId) // Add this condition
          .where('status',
              isEqualTo:
                  false) // Assuming you only want to cancel active appointments
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Iterate through the documents and update the cancelled field
        for (var doc in querySnapshot.docs) {
          await doc.reference
              .update({'cancelled': true}); // Set the cancelled field to true
        }

        // Show confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Appointment cancelled successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No active appointment found to cancel.')),
        );
      }
    } catch (e) {
      print('Error cancelling appointment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cancelling appointment: $e')),
      );
    }
  }

  Future<void> _fetchPatientDetails() async {
    try {
      DocumentSnapshot patientSnapshot = await FirebaseFirestore.instance
          .collection('patients')
          .doc(widget.patientId)
          .get();

      DocumentSnapshot healthAnalyticsSnapshot = await FirebaseFirestore
          .instance
          .collection('health_analytics')
          .doc(widget.patientId)
          .get();

      if (patientSnapshot.exists) {
        setState(() {
          _patientDetails = patientSnapshot;
          _healthAnalytics = healthAnalyticsSnapshot;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('No patient found for ID: ${widget.patientId}')),
        );
      }
    } catch (e) {
      print('Error fetching patient details: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchLatestReport() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.patientId)
          .get();

      if (!userSnapshot.exists) {
        print('No users document found for patient ID: ${widget.patientId}');
        return; // Exit if user document doesn't exist
      }

      QuerySnapshot reportSnapshot = await userSnapshot.reference
          .collection('reports')
          .orderBy('uploadedAt', descending: true)
          .limit(1)
          .get();

      print(
          'Report snapshot count: ${reportSnapshot.docs.length}'); // Debugging line

      if (reportSnapshot.docs.isNotEmpty) {
        setState(() {
          _latestReport = reportSnapshot.docs.first;
        });
        print('Latest report: ${_latestReport!.data()}'); // Debugging line
      } else {
        print(
            'No reports found for patient ID: ${widget.patientId}'); // Debugging line
      }
    } catch (e) {
      print('Error fetching latest report: $e');
    }
  }

  int calculateAge(String dobString) {
    DateTime dob = DateTime.parse(dobString);
    DateTime now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Change the color of the icons here
        ),
        title: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Text(
            'P A T I E N T     R E V I E W',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _patientDetails != null
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name: ${_patientDetails!['first_name'] ?? 'N/A'} ${_patientDetails!['last_name'] ?? 'N/A'}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Patient ID: ${_patientDetails!['id'] ?? 'N/A'}',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Age: ${calculateAge(_patientDetails!['dob'] ?? '1970-01-01')}',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Gender: ${_patientDetails!['gender'] ?? 'N/A'}',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Height: ${_patientDetails!['height'] ?? 'N/A'}',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Weight: ${_patientDetails!['weight'] ?? 'N/A'}',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        Divider(color: Colors.white60, thickness: 1),
                        SizedBox(height: 10),
                        Text(
                          'Health Analytics Details',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        _healthAnalytics != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Blood Pressure: ${_healthAnalytics!['blood_pressure'] ?? 'N/A'}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Blood Sugar: ${_healthAnalytics!['blood_sugar'] ?? 'N/A'}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Last Recorded Pulse: ${_healthAnalytics!['last_recorded_pulse'] ?? 'N/A'}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Note: ${_healthAnalytics!['note'] ?? 'N/A'}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ],
                              )
                            : Text(
                                'No health analytics available',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                        SizedBox(height: 20),
                        Divider(color: Colors.white60, thickness: 1),
                        SizedBox(height: 5),
                        // Latest Reports Section
                        ExpansionTile(
                          title: Text(
                            'Latest Reports',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          children: [
                            _latestReport != null &&
                                    _latestReport!['fileUrl'] != null
                                ? ElevatedButton(
                                    onPressed: () async {
                                      final url = _latestReport!['fileUrl'];
                                      print(
                                          'URL to launch: $url'); // Debugging line
                                      try {
                                        final Uri uri = Uri.parse(
                                            url); // Parse the URL once

                                        if (await canLaunchUrl(uri)) {
                                          //remove the ! in the if condition if there are any errors while displaying
                                          await launchUrl(uri,
                                              mode: LaunchMode
                                                  .externalApplication);
                                        } else {
                                          print(
                                              'Could not launch $url'); // Better error message
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Could not launch $url')),
                                          );
                                        }
                                      } catch (e) {
                                        print('Error launching URL: $e');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Error launching URL: $e')),
                                        );
                                      }
                                    },
                                    child: Text('View Report'),
                                  )
                                : Text(
                                    'No latest report available',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                            SizedBox(height: 4),
                          ],
                        ),
                        SizedBox(height: 5),
                        ExpansionTile(
                          title: Text(
                            'More Options',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.red, // Background color
                                      foregroundColor:
                                          Colors.white, // Text color
                                    ),
                                    onPressed: () {
                                      print(
                                          'Cancel appointment button was pressed');
                                      _cancelAppointment();
                                    },
                                    child: Text('Cancel Appointment'))
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        SlideAction(
                          text: 'Mark as Done',
                          outerColor: Colors.green,
                          onSubmit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HealthanalyticsUpdate(
                                  patientId: widget.patientId,
                                ),
                              ),
                            );
                            print('Patient Diagnosed');
                            // set appointment as done change status as true
                            // update health analytics
                          },
                        ),
                      ],
                    ),
                  )
                : Center(child: Text('No patient details found')),
      ),
    );
  }
}
