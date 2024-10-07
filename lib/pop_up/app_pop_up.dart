import 'package:flutter/material.dart';
import 'package:login/pages/doctor_screen_page.dart';
import 'package:login/pages/appointment_page.dart';
import 'package:login/sidebar/updated_final_booking.dart';
import 'package:meta/meta.dart';

class PopUpAppo extends StatefulWidget {
   final String doctorName;
  final String doctorSpecialization;
  final String doctorDescription;
  final String doctorLocation;
  final String doctorAddress;
  final String doctorImage;
  final List<String> doctorImages;
  final String doctorId;
final String UserId;
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
     required String userId, required this.UserId, required List<Map<String, dynamic>> review_status, required String description,
  });

  @override
  _PopUpAppoState createState() => _PopUpAppoState();
}

class _PopUpAppoState extends State<PopUpAppo> {
  @override
  void initState() {
    super.initState();
    // Show the dialog after a short delay when the widget is first displayed
    Future.delayed(Duration.zero, () => _showDialog());
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.info, color: Colors.blue), // Add an icon
              SizedBox(width: 10), // Space between icon and text
              Text('Appointment Fees'),
            ],
          ),
          content: const Text(
              'Rs. 400 should be paid at the medical center before the appointment.'),
          actions: [
            TextButton(
              onPressed: () {
                // Navigate back to DoctorScreenPage with the relevant details
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorScreenPage(
                      doctorName: widget.doctorName,
                      doctorSpecialization: widget.doctorSpecialization,
                      // doctorDescription:widget.description, // Replace with dynamic data if available
                      // doctorLocation: '', // Replace with dynamic data if available
                      doctorAddress:
                          widget.doctorAddress, // Replace with dynamic data if available
                      doctorImage: widget.doctorImage,
                      // doctorImages: const [], // Pass an actual list of images if you have
                      consultationFee: widget.consultationFee, // Use a dynamic fee if applicable
                      doctorId:widget.doctorId, // Provide actual doctor ID if available
                      // phone: '', // Provide actual phone number if available
                      // description: widget.doctorDescription,
                      userId:widget.UserId,
                      reviews: widget.reviews, doctorDescription:widget.doctorDescription, doctorLocation: '', doctorImages: [], description: '', phone: '', // Provide actual description if available
                    ),
                  ),
                );
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to AppointmentPage with dynamic data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppointmentPage1(
                      doctorId:
                          widget.doctorId, // Replace with actual doctor ID if available
                      doctorName: widget.doctorName,
                      doctorSpecialization: widget.doctorSpecialization,
                      doctorImage: widget.doctorImage, // Use the passed image
                      phone:
                          '', // Replace with actual phone number if available
                      description: widget.doctorDescription, // Replace with dynamic description if available
                      doctorAddress: '',
                      consultationFee: '',
                      // Image: '',
                      // desc: '',
                      userId: widget.UserId, reviews: widget.reviews, // Replace with dynamic address if available
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
