// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'doctor_screen_page.dart';

// class AppointmentPage extends StatefulWidget {
//    final String doctorId;
//   final String doctorName;
//   final String doctorSpecialization;
//   final String doctorAddress;
//   final String userId; // Accept userId here
//   final String Image;
//   final String desc ;

//   const AppointmentPage({
//     super.key,
//     required this.doctorId,
//     required this.doctorName,
//     required this.doctorSpecialization,
//     required this.doctorAddress,
//     // ignore: non_constant_identifier_names
//     required this.Image,
//     required this.userId, // Pass it when booking
//     required this.desc, required description, required String consultationFee, required String doctorImage, required String phone,
//   });

//   @override
//   _AppointmentPageState createState() => _AppointmentPageState();
// }

// class _AppointmentPageState extends State<AppointmentPage> {
//   String selectedDate = '';
//   List<String> bookedTimes = [];
//   bool isBooking = false;
//   String? selectedTime;

//   @override
//   void initState() {
//     super.initState();
//     // Any initialization goes here
//   }

//   Future<void> fetchBookedTimes() async {
//     if (selectedDate.isEmpty) {
//       setState(() {
//         bookedTimes = [];
//       });
//       return;
//     }

//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('appointments')
//           .where('date', isEqualTo: selectedDate)
//           .where('doctor_id', isEqualTo: widget.doctorId) // Filter by doctor ID
//           .get();

//       List<String> times = [];
//       for (var doc in querySnapshot.docs) {
//         times.add(doc['time']);
//       }

//       setState(() {
//         bookedTimes = times;
//       });
//     } catch (e) {
//       print("Error fetching booked times: $e");
//     }
//   }

//   Future<void> bookAppointment() async {
//     if (selectedTime == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a time!')),
//       );
//       return;
//     }

//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('appointments')
//           .where('date', isEqualTo: selectedDate)
//           .where('user_id', isEqualTo: 'user123') // Replace with actual user ID
//           .get();

//       if (querySnapshot.docs.isNotEmpty) {
//         showDialog(
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//               title: const Text('Appointment Limit'),
//               content: const Text(
//                   'You cannot select more than one appointment in a day.'),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//         return;
//       }
//     } catch (e) {
//       print("Error checking appointments: $e");
//     }

//     try {
//       setState(() {
//         isBooking = true;
//       });

//       if (bookedTimes.contains(selectedTime)) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Time slot already booked!')),
//         );
//         setState(() {
//           isBooking = false;
//         });
//         return;
//       }

//       await FirebaseFirestore.instance.collection('appointments').add({
//         'date': selectedDate,
//         'time': selectedTime,
//         'user_id': 'user123', // Replace with actual user ID
//         'doctor_id': widget.doctorId,
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Appointment booked for $selectedTime')),
//       );

//       await fetchBookedTimes();

//       setState(() {
//         selectedTime = null;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to book appointment: $e')),
//       );
//     } finally {
//       setState(() {
//         isBooking = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 35),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>   DoctorScreenPage(
//     doctorName: widget.doctorName,
//     doctorSpecialization: widget.doctorSpecialization,
//     doctorDescription: widget.desc,
//     doctorLocation: widget.doctorAddress,
//     doctorAddress: widget.doctorAddress,
//     doctorImage: widget.Image,
//     doctorImages: const [], // Pass an actual list of images if you have
//     consultationFee: "400", doctorId: widget.doctorId, description: '', phone: '',
//     userId : widget.userId, reviews: [],
//                         ),
//                         ),
//                       );
//                     },
//                     child: const Icon(
//                       Icons.arrow_back_ios_new_outlined,
//                       size: 25,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   CircleAvatar(
//                     radius: 80,
//                     backgroundImage: AssetImage(widget.Image), // Dynamic
//                   ),
//                   const SizedBox(height: 15),
//                   Text(
//                     widget.doctorName, // Dynamic
//                     style: const TextStyle(
//                       fontSize: 23,
//                       fontWeight: FontWeight.w500,
//                       color: Color.fromARGB(239, 0, 0, 0),
//                     ),
//                   ),
//                   const SizedBox(height: 5),
//                   Text(
//                     widget.doctorSpecialization, // Dynamic
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black54,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 10),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 5),
//                   Text(
//                     "Dr. ${widget.doctorName} is a highly skilled and compassionate medical professional...",
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black.withOpacity(0.9),
//                     ),
//                     textAlign: TextAlign.justify,
//                   ),
//                   const SizedBox(height: 30),
//                   Text(
//                     "Booking Date",
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.black.withOpacity(0.6),
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   SizedBox(
//                     height: 70,
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       scrollDirection: Axis.horizontal,
//                       itemCount: 10,
//                       itemBuilder: (context, index) {
//                         String date = '2024-10-${index + 4}'; // Example dates
//                         bool isSelected = selectedDate == date;

//                         return InkWell(
//                           onTap: () {
//                             setState(() {
//                               selectedDate = date;
//                               selectedTime = null;
//                               fetchBookedTimes();
//                             });
//                           },
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(
//                                 horizontal: 8, vertical: 5),
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 8, horizontal: 25),
//                             decoration: BoxDecoration(
//                               color: isSelected ? Colors.teal : Colors.white,
//                               borderRadius: BorderRadius.circular(10),
//                               boxShadow: const [
//                                 BoxShadow(
//                                   color: Colors.black12,
//                                   blurRadius: 4,
//                                   spreadRadius: 2,
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   "${index + 4}",
//                                   style: TextStyle(
//                                       fontSize: 15,
//                                       color: isSelected
//                                           ? Colors.white
//                                           : Colors.black.withOpacity(0.6)),
//                                 ),
//                                 const Text(
//                                   "OCT",
//                                   style: TextStyle(
//                                       fontSize: 15, color: Colors.black),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 25),
//                   Text(
//                     "Booking Time",
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.black.withOpacity(0.6),
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   SizedBox(
//                     height: 70,
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       scrollDirection: Axis.horizontal,
//                       itemCount: 5,
//                       itemBuilder: (context, index) {
//                         String time = "${index + 8}:00 PM";
//                         bool isBooked = bookedTimes.contains(time);
//                         bool isSelected = selectedTime == time;

//                         return InkWell(
//                           onTap: isBooked
//                               ? null
//                               : () {
//                                   setState(() {
//                                     selectedTime = time;
//                                   });
//                                 },
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(
//                                 horizontal: 8, vertical: 5),
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 8, horizontal: 25),
//                             decoration: BoxDecoration(
//                               color: isSelected
//                                   ? Colors.teal
//                                   : isBooked
//                                       ? Colors.red.withOpacity(0.3)
//                                       : Colors.white,
//                               borderRadius: BorderRadius.circular(10),
//                               boxShadow: const [
//                                 BoxShadow(
//                                   color: Colors.black12,
//                                   blurRadius: 4,
//                                   spreadRadius: 2,
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   time,
//                                   style: TextStyle(
//                                     fontSize: 15,
//                                     color: isSelected
//                                         ? Colors.white
//                                         : isBooked
//                                             ? Colors.red
//                                             : Colors.black.withOpacity(0.6),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   Center(
//                     child: ElevatedButton(
//                       onPressed: isBooking
//                           ? null
//                           : () {
//                               bookAppointment();
//                             },
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 10, horizontal: 50),
//                         backgroundColor: Colors.teal,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: isBooking
//                           ? const CircularProgressIndicator(
//                               color: Colors.white,
//                             )
//                           : const Text(
//                               "Book Now",
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
