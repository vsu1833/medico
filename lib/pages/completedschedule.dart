import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CompletedSchedule extends StatefulWidget {
  final String userId;

  const CompletedSchedule({super.key, required this.userId});

  @override
  State<CompletedSchedule> createState() => _CompletedScheduleState();
}

class _CompletedScheduleState extends State<CompletedSchedule> {
  List<Map<String, dynamic>> completedAppointments = [];

  @override
  void initState() {
    super.initState();
    fetchCompletedAppointments();
  }

  Future<void> fetchCompletedAppointments() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('patient_id', isEqualTo: widget.userId)
          .where('status', isEqualTo: true) 
          .get();

      List<Map<String, dynamic>> fetchedAppointments = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        fetchedAppointments.add(data);
      }

      setState(() {
        completedAppointments = fetchedAppointments;
      });
    } catch (e) {
      print("Error fetching completed appointments: $e");
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
            "Completed Appointments",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          completedAppointments.isEmpty
              ? const Text('No completed appointments.')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: completedAppointments.length,
                  itemBuilder: (context, index) {
                    var appointment = completedAppointments[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 20), 
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
                              subtitle: Text(appointment['specialization'] ?? 
                                  'Specialization not available'),
                              trailing: const CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    AssetImage("images/doctor1.jpg"),
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
                                Icon(Icons.check_circle,
                                    color: Colors.green, size: 18),
                                SizedBox(width: 5),
                                Text(
                                  "Completed",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                              ],
                            ),
                            const SizedBox(height: 10),
                           
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
