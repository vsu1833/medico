import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorsPage extends StatefulWidget {
  final String category;

  DoctorsPage({required this.category});

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
                prefixIcon: Icon(Icons.search),
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
                  .where('category', isEqualTo: widget.category)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var doctors = snapshot.data!.docs
                    .map((doc) => Doctor.fromMap(doc.data() as Map<String, dynamic>))
                    .where((doctor) =>
                        doctor.name.toLowerCase().contains(searchQuery.toLowerCase()))
                    .toList();

                return ListView.builder(
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(doctors[index].name),
                      subtitle: Text(doctors[index].category),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Doctor {
  final String name;
  final String category;

  Doctor({required this.name, required this.category});

  factory Doctor.fromMap(Map<String, dynamic> data) {
    return Doctor(
      name: data['name'],
      category: data['category'],
    );
  }
}
