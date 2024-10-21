import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpcomingSchedule extends StatefulWidget {
  final String userId; // Pass the user ID to fetch appointments

  const UpcomingSchedule({super.key, required this.userId});

  @override
  State<UpcomingSchedule> createState() => _UpcomingScheduleState();
}

class _UpcomingScheduleState extends State<UpcomingSchedule> {
  List<Map<String, dynamic>> appointments = [];

  @override
  void initState() {
    super.initState();
    fetchScheduledAppointments();
  }

  Future<void> fetchScheduledAppointments() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('patient_id', isEqualTo: widget.userId)
          .where('cancelled', isEqualTo: false) // Only show active appointments
          .where('status', isEqualTo: false) // Only show upcoming appointments
          .get();

      List<Map<String, dynamic>> fetchedAppointments = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add document ID for further operations
        fetchedAppointments.add(data);
      }

      setState(() {
        appointments = fetchedAppointments;
      });
    } catch (e) {
      print("Error fetching appointments: $e");
    }
  }

  Future<void> cancelAppointment(String appointmentId) async {
    bool? confirmCancel = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Cancellation"),
          content:
              const Text("Are you sure you want to cancel this appointment?"),
          actions: [
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmCancel == true) {
      try {
        await FirebaseFirestore.instance
            .collection('appointments')
            .doc(appointmentId)
            .update({'cancelled': true});

        fetchScheduledAppointments();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Success"),
              content: const Text("Appointment has been cancelled successfully."),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        print("Error cancelling appointment: $e");
      }
    }
  }

  Future<void> rescheduleAppointment(String appointmentId) async {
    try {
      DateTime currentDate = DateTime.now();
      DateTime lastAvailableDate = currentDate.add(const Duration(days: 7));

      DateTime? newDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: currentDate,
        lastDate: lastAvailableDate,
      );

      if (newDate == null) return;

      TimeOfDay? newTime = await showDialog<TimeOfDay>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text("Select Time"),
            children: List<Widget>.generate(5, (int index) {
              int hour = 8 + index;
              return SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, TimeOfDay(hour: hour, minute: 0));
                },
                child: Text('$hour:00 AM'),
              );
            }),
          );
        },
      );

      if (newTime == null) return;

      bool isSlotTaken = await checkIfSlotIsTaken(newDate, newTime);
      if (isSlotTaken) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Slot Unavailable"),
              content: const Text(
                  "This time slot is already taken. Please select another time."),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }

      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .update({
        'date': '${newDate.year}-${newDate.month}-${newDate.day}',
        'time': newTime.format(context),
      });

      fetchScheduledAppointments();

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Success"),
            content:
                const Text("Appointment has been rescheduled successfully."),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Error rescheduling appointment: $e");
    }
  }

  Future<bool> checkIfSlotIsTaken(DateTime date, TimeOfDay time) async {
    try {
      String formattedDate = '${date.year}-${date.month}-${date.day}';
      String formattedTime = time.format(context);

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('date', isEqualTo: formattedDate)
          .where('time', isEqualTo: formattedTime)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking if slot is taken: $e");
      return false;
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
            "Upcoming Appointments",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 15),
          appointments.isEmpty
              ? const Text('No scheduled appointments.')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    var appointment = appointments[index];

                    return Container(
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
                              subtitle: Text(appointment['doctor_specialization'] ?? 'Specialization'),
                              trailing: const CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    AssetImage("images/doctor1.jpg"),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Divider(thickness: 1, height: 20),
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
                                // Upcoming indicator (Blue dot with 'Upcoming' text)
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.upcoming,
                                      color: Colors.blue,
                                      size: 16,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Upcoming',
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () =>
                                      cancelAppointment(appointment['id']),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 201, 60, 60),
                                    minimumSize: const Size(160, 40),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(7),
                                    ),
                                  ),
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(color: Color.fromARGB(255, 250, 247, 247)),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      rescheduleAppointment(appointment['id']),
                                  style: ElevatedButton.styleFrom(
                                                                        backgroundColor:
                                        const Color.fromARGB(255, 36, 164, 166),
                                    minimumSize: const Size(160, 40),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(7),
                                    ),
                                  ),
                                  child: const Text(
                                    "Reschedule",
                                    style: TextStyle(color: Color.fromARGB(255, 1, 0, 0)),
                                  ),
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

/*import 'package:cloud_firestore/cloud_firestore.dart';
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
                      margin: const EdgeInsets.only(bottom: 20), // Increased spacing
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
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                appointment['spacialization'] != null && appointment['spacialization'].isNotEmpty
                                    ? appointment['spacialization']
                                    : 'Specialization not available',  // 
                              ),
                              trailing: CircleAvatar(
                                radius: 25,
                                backgroundImage: appointment['doctorImage'] != null && appointment['doctorImage'].isNotEmpty
                                    ? NetworkImage(appointment['doctorImage'])
                                    : const AssetImage('assets/images/default_doctor.png') as ImageProvider,  // Default image
                                onBackgroundImageError: (error, stackTrace) {
                                  print("Error loading doctor's image: $error");
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
                                    const Icon(Icons.calendar_month, color: Colors.black54),
                                    const SizedBox(width: 5),
                                    Text(
                                      appointment['date'] ?? '',
                                      style: const TextStyle(color: Colors.black54),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time_filled, color: Colors.black54),
                                    const SizedBox(width: 5),
                                    Text(
                                      appointment['time'] ?? '',
                                      style: const TextStyle(color: Colors.black54),
                                    ),
                                  ],
                                ),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(Icons.cancel, color: Colors.red, size: 18),
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
}*/
