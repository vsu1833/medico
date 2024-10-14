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
  final String doctorImage;
  final List<String> doctorImages;
  final String doctorId;
  final String userId;  // Only userId, no UserId
  final String consultationFee;
  final List<Map<String, dynamic>> reviews;

  const PopUpAppo({
    super.key,
    required this.doctorName,
    required this.doctorSpecialization,
    required this.doctorDescription,
    required this.doctorLocation,
    required this.doctorAddress,
    required this.doctorImage,
    required this.doctorImages,
    required this.consultationFee,
    required this.reviews,
    required this.doctorId,
    required this.userId, // Removed 'UserId' for consistency
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
          title: const Row(
            children: [
              Icon(Icons.info, color: Colors.blue),
              SizedBox(width: 10),
              Text('Appointment Fees'),
            ],
          ),
          content: const Text(
              'Rs. 400 should be paid at the medical center before the appointment.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorScreenPage(
                      doctorName: widget.doctorName,
                      doctorSpecialization: widget.doctorSpecialization,
                      doctorAddress: widget.doctorAddress,
                      doctorImage: widget.doctorImage,
                      consultationFee: widget.consultationFee,
                      doctorId: widget.doctorId,
                      userId: widget.userId,  // Passing userId
                      doctorDescription: widget.doctorDescription,
                      doctorLocation: widget.doctorLocation,
                      doctorImages: widget.doctorImages,
                    ),
                  ),
                );
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppointmentPage1(
                      doctorId: widget.doctorId,
                      doctorName: widget.doctorName,
                      doctorSpecialization: widget.doctorSpecialization,
                      doctorImage: widget.doctorImage,
                      phone: '', // Placeholder for actual phone number
                      description: widget.doctorDescription,
                      doctorAddress: widget.doctorAddress,
                      consultationFee: widget.consultationFee,
                      userId: widget.userId,  // Using consistent userId
                      reviews: widget.reviews,
                    ),
                  ),
                );
              },
              child: const Text('OK'),
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
        title: const Text('Appointment Reminder'),
      ),
      body: const Center(
        child: Text('Reminder: You need to pay appointment fees.'),
      ),
    );
  }
}
