import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/pages/doctor_screen_page.dart';

class DoctorsPage extends StatefulWidget {
  final String category;

  const DoctorsPage({super.key, required this.category});

  @override
  _DoctorsPageState createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Doctors'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Doctor',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('doctors')
                    .where('specialization', isEqualTo: widget.category)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  var doctors = snapshot.data!.docs
                      .map((doc) =>
                          Doctor.fromMap(doc.data() as Map<String, dynamic>))
                      .where((doctor) => doctor.name
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()))
                      .toList();

                  if (doctors.isEmpty) {
                    return const Center(child: Text('No doctors found.'));
                  }

                  return ListView.builder(
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(doctors[index].name),
                        subtitle: Text(doctors[index].specialization),
                        onTap: () async {
                          String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
                          if (userId.isNotEmpty) {
                            // Fetch reviews for the doctor
                            QuerySnapshot reviewSnapshot = await FirebaseFirestore.instance
                                .collection('reviews')
                                .where('docId', isEqualTo: doctors[index].doctorId) // Match doctorId with docId
                                .get();

                            List<Map<String, dynamic>> reviews = reviewSnapshot.docs
                                .map((doc) => doc.data() as Map<String, dynamic>)
                                .toList();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorScreenPage(
                                  doctorId: doctors[index].doctorId,
                                  doctorName: doctors[index].name,
                                  doctorSpecialization: doctors[index].specialization,
                                  doctorAddress: doctors[index].address,
                                  userId: userId, // Use fetched user ID
                                  consultationFee: '',
                                  doctorDescription: doctors[index].description,
                                  doctorLocation: doctors[index].address,
                                  doctorImage: '',
                                  doctorImages: const [],
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('User not logged in')),
                            );
                          }
                        },
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class Doctor {
  final String doctorId;
  final String name;
  final String specialization;
  final String address;
  final String phone;
  final String description;

  Doctor({
    required this.doctorId,
    required this.name,
    required this.specialization,
    required this.address,
    required this.phone,
    required this.description,
  });

  factory Doctor.fromMap(Map<String, dynamic> data) {
    return Doctor(
      doctorId: data['id'] ?? '',
      name: '${data['first_name'] ?? ''} ${data['last_name'] ?? ''}',
      specialization: data['specialization'] ?? '',
      address: data['address'] ?? '',
      phone: data['phone'] ?? '',
      description: data['description'] ?? '',
    );
  }
}
