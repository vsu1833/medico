import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CancelledSchedule extends StatefulWidget {
  final String userId;

  const CancelledSchedule({super.key, required this.userId});

  @override
  State<CancelledSchedule> createState() => _CancelledScheduleState();
}

class _CancelledScheduleState extends State<CancelledSchedule> {
  List<Map<String, dynamic>> cancelledAppointments = [];

  @override
  void initState() {
    super.initState();
    fetchCancelledAppointments();
  }

  Future<void> fetchCancelledAppointments() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('patient_id', isEqualTo: widget.userId)
          .where('cancelled', isEqualTo: true)
          .get();

      List<Map<String, dynamic>> fetchedCancelledAppointments = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        fetchedCancelledAppointments.add(data);
      }

      setState(() {
        cancelledAppointments = fetchedCancelledAppointments;
      });
    } catch (e) {
      print("Error fetching cancelled appointments: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Cancelled Appointments",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          cancelledAppointments.isEmpty
              ? const Text('No cancelled appointments.')
              : ListView.builder(
                  shrinkWrap: true, // Prevents infinite height
                  itemCount: cancelledAppointments.length,
                  itemBuilder: (context, index) {
                    var appointment = cancelledAppointments[index];

                    return Container(
                      margin: const EdgeInsets.only(
                          bottom: 20), // Increased spacing
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                appointment['doctor_name'] ?? 'Doctor',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                appointment['spacialization'] != null &&
                                        appointment['spacialization'].isNotEmpty
                                    ? appointment['spacialization']
                                    : 'Specialization not available',
                              ),
                              trailing: CircleAvatar(
                                radius: 25,
                                backgroundImage: appointment['doctorImage'] !=
                                        null
                                    ? NetworkImage(appointment['doctorImage']
                                        .toString()) // Fetch image from URL
                                    : const AssetImage(
                                            'assets/images/default_doctor.png')
                                        as ImageProvider, // Default image if the URL is missing
                                onBackgroundImageError: (error, stackTrace) {
                                  print("Error loading doctor's image: $error");
                                  print(
                                      "Doctor Image URL: ${appointment['doctorImage']}");
                                },
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Divider(
                                thickness: 1,
                                height: 20,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_month,
                                        color: Colors.black54),
                                    const SizedBox(width: 5),
                                    Text(
                                      appointment['date'] ?? '',
                                      style: const TextStyle(
                                          color: Colors.black54),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time_filled,
                                        color: Colors.black54),
                                    const SizedBox(width: 5),
                                    Text(
                                      appointment['time'] ?? '',
                                      style: const TextStyle(
                                          color: Colors.black54),
                                    ),
                                  ],
                                ),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(Icons.cancel,
                                        color: Colors.red, size: 18),
                                    SizedBox(width: 5),
                                    Text(
                                      "Cancelled",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
