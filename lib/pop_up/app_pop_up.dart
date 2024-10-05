import 'package:login/pages/appointment_page.dart';
import 'package:login/pages/doctor_screen_page.dart';
import 'package:flutter/material.dart';
import 'package:login/pages/appointment_page.dart';
// import 'package:login/pages/appointment_page.dart';
// void main() {
//   runApp(MyApp());
// }

// class pop_up_appo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Appointment Fees Reminder',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: pop_up_appo(),
//     );
//   }
// }

class PopUpAppo extends StatefulWidget {
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
          title:const Row(
            children: [
              Icon(Icons.info, color: Colors.blue), // Add an icon
              SizedBox(width: 10), // Space between icon and text
              Text('Appointment Fees'),
            ],
          ),
          content:const Text(
              'Rs. 400 should be paid at the medical center before Appointment'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorScreenPage(),
                  ),
                );
              },
              child:const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AppointmentPage(),
                  ),
                );
              },
              child:const Text('OK'),
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
