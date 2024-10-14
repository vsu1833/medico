import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentPage1 extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  final String doctorSpecialization;
  final String doctorImage;
  final String doctorAddress;
  final String description;
  final String phone;
  final String consultationFee;
  final String userId;
  final List<Map<String, dynamic>> reviews;

  const AppointmentPage1({
    super.key,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialization,
    required this.doctorImage,
    required this.doctorAddress,
    required this.description,
    required this.phone,
    required this.consultationFee,
    required this.userId,
    required this.reviews,
  });

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage1> {
  String selectedDate = '';
  List<String> bookedTimes = [];
  bool isBooking = false;
  String? selectedTime;

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchBookedTimes() async {
    if (selectedDate.isEmpty) {
      setState(() {
        bookedTimes = [];
      });
      return;
    }

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('date', isEqualTo: selectedDate)
          .where('doctor_id', isEqualTo: widget.doctorId)
          .get();

      List<String> times = [];
      for (var doc in querySnapshot.docs) {
        times.add(doc['time']);
      }

      setState(() {
        bookedTimes = times;
      });
    } catch (e) {
      print("Error fetching booked times: $e");
    }
  }

  Future<void> bookAppointment() async {
    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time!')),
      );
      return;
    }

    try {
      setState(() {
        isBooking = true;
      });

      if (bookedTimes.contains(selectedTime)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Time slot already booked!')),
        );
        setState(() {
          isBooking = false;
        });
        return;
      }

      if (widget.userId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User ID is missing!')),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('appointments').add({
        'date': selectedDate,
        'time': selectedTime,
        'patient_id': widget.userId,
        'doctor_id': widget.doctorId,
        'doctor_name': widget.doctorName,
        'review_status': false,
        'status': false,
        'cancelled': false,
        'doctorImage': widget.doctorImage,
        'spacialization': widget.doctorSpecialization,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment booked for $selectedTime on $selectedDate')),
      );

      await fetchBookedTimes();

      setState(() {
        selectedTime = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book appointment: $e')),
      );
    } finally {
      setState(() {
        isBooking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new_outlined,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage(widget.doctorImage),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.doctorName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.doctorSpecialization,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      widget.description,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Booking Date",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 70,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        String date = '2024-10-${index + 4}';
                        bool isSelected = selectedDate == date;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedDate = date;
                              selectedTime = null;
                              fetchBookedTimes();
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.teal : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${index + 4}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: isSelected ? Colors.white : Colors.black.withOpacity(0.6),
                                  ),
                                ),
                                const Text(
                                  "OCT",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Booking Time",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 70,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        String time = "${index + 8}:00 PM";
                        bool isBooked = bookedTimes.contains(time);
                        bool isSelected = selectedTime == time;

                        return InkWell(
                          onTap: isBooked
                              ? null
                              : () {
                                  setState(() {
                                    selectedTime = time;
                                  });
                                },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.teal : isBooked ? Colors.red.withOpacity(0.3) : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  time,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: isSelected ? Colors.white : isBooked ? Colors.red : Colors.black.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: isBooking
                          ? null
                          : () {
                              bookAppointment();
                            },
                      style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isBooking
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Book Appointment",
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                  
                  ),
                  const SizedBox(height: 20,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
