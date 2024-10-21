import 'package:flutter/material.dart';
import 'package:login/pages/doctor_screen_page.dart';
import 'package:login/pages/appointment_page.dart';
import 'package:login/sidebar/final_booking.dart';

class PopUpAppo extends StatefulWidget {
  final String doctorName;
  final String doctorSpecialization;
  final String doctorDescription;
  final String doctorLocation;
  final String doctorAddress;
  final String image;
  // final List<String> doctorImages;
  final String doctorId;
  final String userId; 
  final String consultationFee;
  final String phone ;
  final List<Map<String, dynamic>> reviews;

  const PopUpAppo({
    super.key,
    required this.doctorName,
    required this.doctorSpecialization,
    required this.doctorDescription,
    required this.doctorLocation,
    required this.doctorAddress,
    required this.image,
    // required this.doctorImages,
    required this.consultationFee,
    required this.reviews,
    required this.doctorId,
    required this.userId, 
    required this.phone, required String doctorImage, 
  });

  @override
  _PopUpAppoState createState() => _PopUpAppoState();
}

class _PopUpAppoState extends State<PopUpAppo> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => _showDialog());
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners for modern look
          ),
          title: Row(
            children: [
              const Icon(Icons.info, color: Colors.blue, size: 28), // Larger icon for better emphasis
              const SizedBox(width: 10),
              Text(
                'Appointment Fees',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800], // Modern, dark color for text
                ),
              ),
            ],
          ),
          content: Text(
            'Rs. 400 should be paid at the medical center before the appointment.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorScreenPage(
                      doctorName: widget.doctorName,
                      phone: widget.phone,
                      doctorSpecialization: widget.doctorSpecialization,
                      doctorAddress: widget.doctorAddress,
                      doctorImage: widget.image,
                      consultationFee: widget.consultationFee,
                      doctorId: widget.doctorId,
                      userId: widget.userId,
                      doctorDescription: widget.doctorDescription,
                      doctorLocation: widget.doctorLocation, 
                      
                      // doctorImages: widget.doctorImages,
                    ),
                  ),
                );
              },
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 16), // Consistent font size
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Consistent padding
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppointmentPage1(
                      doctorId: widget.doctorId,
                      doctorName: widget.doctorName,
                      doctorSpecialization: widget.doctorSpecialization,
                      doctorImage: widget.image,
                      phone: '',
                      description: widget.doctorDescription,
                      doctorAddress: widget.doctorAddress,
                      consultationFee: widget.consultationFee,
                      userId: widget.userId,
                      reviews: widget.reviews,
                    ),
                  ),
                );
              },
              child: const Text('OK', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Appointment Reminder',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent, // Modern color for app bar
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Consistent padding
          child: Text(
            'Reminder: You need to pay appointment fees.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[800], // Modern color for body text
            ),
          ),
        ),
      ),
    );
  }
}
