import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HealthanalyticsUpdate extends StatefulWidget {
  final String patientId;

  const HealthanalyticsUpdate({super.key, required this.patientId});

  @override
  _HealthanalyticsUpdateState createState() => _HealthanalyticsUpdateState();
}

class _HealthanalyticsUpdateState extends State<HealthanalyticsUpdate> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the text fields
  final TextEditingController _bloodPressureController =
      TextEditingController();
  final TextEditingController _bloodSugarController = TextEditingController();
  final TextEditingController _pulseController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Current user's ID
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        iconTheme: IconThemeData(
          color: Colors.white, // Change the color of the icons here
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Text(
            'P A T I E N T   R E V I E W',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Patient ID: ${widget.patientId}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.green.shade300,
                ),
                height: screenHeight * 0.6,
                width: screenWidth * 0.9,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Update Health Analytics',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _bloodPressureController,
                          decoration: InputDecoration(
                            labelText: 'Blood Pressure',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter blood pressure';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _bloodSugarController,
                          decoration: InputDecoration(
                            labelText: 'Blood Sugar',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter blood sugar';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _pulseController,
                          decoration: InputDecoration(
                            labelText: 'Pulse',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter pulse';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _notesController,
                          decoration: InputDecoration(
                            labelText: 'Notes',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          maxLines: 4,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter notes';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black, // Black background
                            textStyle:
                                TextStyle(color: Colors.white), // White text
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // Get the values from the text fields
                              String bloodPressure =
                                  _bloodPressureController.text;
                              String bloodSugar = _bloodSugarController.text;
                              String pulse = _pulseController.text;
                              String notes = _notesController.text;

                              // Call the update function for health analytics
                              await updateHealthAnalytics(
                                widget.patientId,
                                bloodPressure,
                                bloodSugar,
                                pulse,
                                notes,
                              );

                              // Update the appointments status
                              await updateAppointmentStatus(
                                  widget.patientId, currentUserId);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Analytics updated!')),
                              );

                              // Optionally, you can navigate back or clear the fields
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Submit'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateHealthAnalytics(String patientId, String bloodPressure,
      String bloodSugar, String pulse, String notes) async {
    try {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('health_analytics')
          .doc(patientId);

      await docRef.update({
        'blood_pressure': bloodPressure,
        'blood_sugar': bloodSugar,
        'last_recorded_pulse': pulse,
        'note': notes,
      });

      print('Health analytics updated successfully');
    } catch (e) {
      print('Failed to update health analytics: $e');
    }
  }

  Future<void> updateAppointmentStatus(
      String patientId, String doctorId) async {
    try {
      // Fetch the appointment documents where patient_id, doctor_id, and status
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('patient_id', isEqualTo: patientId)
          .where('doctor_id', isEqualTo: doctorId)
          .where('status', isEqualTo: false)
          .get();

      // Update the status of each matching appointment
      for (var doc in querySnapshot.docs) {
        await doc.reference.update({'status': true});
      }

      print('Appointment status updated successfully');
    } catch (e) {
      print('Failed to update appointment status: $e');
    }
  }
}
