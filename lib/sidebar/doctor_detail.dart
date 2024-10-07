// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; // Import to access Clipboard
// import 'package:login/pages/appointment_page.dart';
// import 'package:login/sidebar/final_booking.dart';

// class DoctorScreenPages extends StatelessWidget {
//   final String doctorName;
//   final String doctorSpecialization;
//   final String doctorDescription;
//   final String doctorLocation;
//   final String doctorAddress;
//   final String doctorImage;
//   final List<String> doctorImages;
//   final String consultationFee;
//   final String doctorPhoneNumber;
//   final String doctorId;

//   const DoctorScreenPages({
//     super.key,
//     required this.doctorName,
//     required this.doctorSpecialization,
//     required this.doctorDescription,
//     required this.doctorLocation,
//     required this.doctorAddress,
//     required this.doctorImage,
//     required this.doctorImages,
//     required this.consultationFee,
//     required this.doctorPhoneNumber,
//     required this.doctorId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade200,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 30),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Stack(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           Navigator.pop(context);
//                         },
//                         child: const Icon(
//                           Icons.arrow_back,
//                           size: 25,
//                           color: Colors.black,
//                         ),
//                       )
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CircleAvatar(
//                           radius: 50,
//                           backgroundImage: AssetImage(doctorImage),
//                         ),
//                         const SizedBox(height: 15),
//                         Text(
//                           doctorName,
//                           style: const TextStyle(
//                             fontSize: 26,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           doctorSpecialization,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w400,
//                             color: Colors.black54,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 Clipboard.setData(ClipboardData(text: doctorPhoneNumber));
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text("Phone number copied: $doctorPhoneNumber"),
//                                   ),
//                                 );
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.all(12),
//                                 decoration: const BoxDecoration(
//                                   gradient: LinearGradient(
//                                     colors: [Colors.teal, Colors.blue],
//                                   ),
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: const Icon(
//                                   Icons.call,
//                                   color: Colors.white,
//                                   size: 30,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 25),
//                             Container(
//                               padding: const EdgeInsets.all(12),
//                               decoration: const BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: [Colors.teal, Colors.blue],
//                                 ),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: const Icon(
//                                 CupertinoIcons.chat_bubble_text_fill,
//                                 color: Colors.white,
//                                 size: 30,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Container(
//               height: MediaQuery.of(context).size.height / 1.5,
//               width: double.infinity,
//               padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(30),
//                   topRight: Radius.circular(30),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 6,
//                     spreadRadius: 3,
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     doctorName,
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     doctorDescription,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       color: Colors.black54,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       const Text(
//                         "Reviews",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       const Icon(Icons.star, color: Colors.amber),
//                       const Text(
//                         "4.9",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(width: 15),
//                       const Text(
//                         "(124)",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           color: Colors.teal,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const Spacer(),
//                       TextButton(
//                         onPressed: () {
//                           // Handle "See All" functionality
//                         },
//                         child: const Text(
//                           "See all",
//                           style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 16,
//                             color: Colors.teal,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     doctorLocation,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black54,
//                     ),
//                   ),
//                   ListTile(
//                     leading: const CircleAvatar(
//                       radius: 30,
//                       backgroundColor: Colors.tealAccent,
//                       child: Icon(
//                         Icons.location_on,
//                         color: Colors.teal,
//                         size: 30,
//                       ),
//                     ),
//                     title: Text(
//                       doctorLocation,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     subtitle: Text(
//                       doctorAddress,
//                       style: const TextStyle(
//                         color: Colors.black54,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.all(15),
//         height: 140,
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 4,
//               spreadRadius: 2,
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 const Text(
//                   "Consultation Fee",
//                   style: TextStyle(
//                     color: Colors.black54,
//                     fontSize: 20,
//                   ),
//                 ),
//                 const Spacer(),
//                 Text(
//                   "₹$consultationFee",
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 15),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => AppointmentPages(
//                         doctorId: doctorId, // Ensure the doctorId is passed correctly
//                         doctorName: doctorName,
//                         doctorImage: doctorImage,
//                         doctorSpecialization: doctorSpecialization,
//                         doctorAddress: doctorAddress,
//                         description: doctorDescription,
//                         phone: doctorPhoneNumber, consultationFee: '', doctor_id: '',
//                       ),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 10),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   backgroundColor: Colors.teal,
//                 ),
//                 child: const Text(
//                   "Book Appointment",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
