// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:login/pages/appointment_page.dart';
// import 'package:login/pages/doctor_screen_page.dart';
// import 'package:login/sidebar/doctor_detail.dart';

// class DoctorsPage extends StatefulWidget {
//   final String category;

//   const DoctorsPage({Key? key, required this.category}) : super(key: key);

//   @override
//   _DoctorsPageState createState() => _DoctorsPageState();
// }

// class _DoctorsPageState extends State<DoctorsPage> {
//   String searchQuery = "";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('${widget.category} Doctors'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               decoration: InputDecoration(
//                 labelText: 'Search Doctor',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//               onChanged: (query) {
//                 setState(() {
//                   searchQuery = query;
//                 });
//               },
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('doctors')
//                   .where('specialization', isEqualTo: widget.category)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 }

//                 var doctors = snapshot.data!.docs
//                     .map((doc) =>
//                         Doctor.fromMap(doc.data() as Map<String, dynamic>))
//                     .where((doctor) => doctor.name
//                         .toLowerCase()
//                         .contains(searchQuery.toLowerCase()))
//                     .toList();

//                 if (doctors.isEmpty) {
//                   return const Center(child: Text('No doctors found.'));
//                 }

//                 return ListView.builder(
//                   itemCount: doctors.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text(doctors[index].name),
//                       subtitle: Text(doctors[index].specialization),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => DoctorScreenPages(
//                               doctorName: doctors[index].name,
//                               doctorSpecialization:
//                                   doctors[index].specialization,
//                               doctorAddress: doctors[index].address,
//                               // phone: doctors[index].phone,
//                               // description: doctors[index].description,
//                               // doctorId: doctors[index].doctorId,
//                               doctorDescription: doctors[index].description,
//                               doctorLocation: '',
//                               doctorImage: "doctors[index]",
//                               consultationFee: '400',
//                               doctorImages: [],
//                               doctorPhoneNumber:
//                                   doctors[index].phone, doctorId: doctors[index].doctorId,
//                               // Placeholder
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Doctor {
//   final String doctorId;
//   final String name;
//   final String specialization;
//   final String address;
//   final String phone;
//   final String description;

//   Doctor({
//     required this.doctorId,
//     required this.name,
//     required this.specialization,
//     required this.address,
//     required this.phone,
//     required this.description,
//   });

//    factory Doctor.fromMap(Map<String, dynamic> data) {
//     // Debug statement
//     print('Fetching doctorId: ${data['doctor_id']}');

//     return Doctor(
//       doctorId: data['doctor_id'] ?? '', // Updated field name
//       name: '${data['first_name'] ?? ''} ${data['last_name'] ?? ''}',
//       specialization: data['specialization'] ?? '',
//       address: data['address'] ?? '',
//       phone: data['phone'] ?? '',
//       description: data['description'] ?? '',
//     );
//   }

// }
