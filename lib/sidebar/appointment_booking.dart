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
        title: Text('${widget.category} Doctors',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blueAccent, // Modern color for the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Consistent padding
        child: Column(
          children: [
            // Search Bar with Improved Design
            TextField(
              decoration: InputDecoration(
                labelText: 'Search Doctor',
                labelStyle: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Colors.grey[100], // Subtle background for search field
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),
            const SizedBox(height: 16), // Spacing between search bar and list
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
                      .map((doc) => Doctor.fromMap(doc.data() as Map<String, dynamic>))
                      .where((doctor) => doctor.name
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()))
                      .toList();

                  if (doctors.isEmpty) {
                    return const Center(child: Text('No doctors found.',
                        style: TextStyle(fontSize: 18, color: Colors.grey)));
                  }

                  return ListView.builder(
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 2,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              radius: 30,
                              child: Text(
                                doctors[index].name[0],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              doctors[index].name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              doctors[index].specialization,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () async {
                              String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
                              if (userId.isNotEmpty) {
                                QuerySnapshot reviewSnapshot = await FirebaseFirestore.instance
                                    .collection('reviews')
                                    .where('docId', isEqualTo: doctors[index].doctorId)
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
                                      userId: userId,
                                      consultationFee: '',
                                      phone: doctors[index].phone,
                                      doctorDescription: doctors[index].description,
                                      doctorLocation: doctors[index].address,
                                      doctorImage: 'doctors[index].image',
                                      
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('User not logged in')),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
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

  static fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> doc) {}
}
