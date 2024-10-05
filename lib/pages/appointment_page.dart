import 'package:flutter/cupertino.dart'; 
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'doctor_screen_page.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  String selectedDate = ''; // Changed to an empty string initially
  List<String> bookedTimes = [];
  bool isBooking = false;
  String? selectedTime;

  @override
  void initState() {
    super.initState();
  }

  //here we are  Fetching  booked times from Firestore based on selected date
  Future<void> fetchBookedTimes() async {
    if (selectedDate.isEmpty) {
      setState(() {
        bookedTimes = []; // Clearing booked times if no date is selected
      });
      return; // Exit if no date is selected
    }

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('date', isEqualTo: selectedDate)
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

  // Book appointment
  Future<void> bookAppointment() async {
    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time!')),
      );
      return;
    }

    // here is the code for Preventing multiple appointments in a day
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('date', isEqualTo: selectedDate)
          .where('user_id', isEqualTo: 'user123') // Replace with actual user ID
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Appointment Limit'),
              content: const Text('You cannot select more than one appointment in a day.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }
    } catch (e) {
      print("Error checking appointments: $e");
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

      // Add appointment to Firestore
      await FirebaseFirestore.instance.collection('appointments').add({
        'date': selectedDate,
        'time': selectedTime,
        'user_id': 'user123', // Replace with actual user ID
        'doctor_id': 'doctor456', // Replace with actual doctor ID
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment booked for $selectedTime')),
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
            const SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  DoctorScreenPage(),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new_outlined,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsetsDirectional.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage("images/doctor1.jpg"),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Dr. Adarsh Nayak",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(239, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Surgeon",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    "Dr. Adarsh Nayak is a highly skilled and compassionate medical professional with over 10 years of experience in the field of surgery...",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Booking Date",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withOpacity(0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Date Selection - List of dates
                  Container(
                    height: 70,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 6, // Change this to the number of dates
                      itemBuilder: (context, index) {
                        String date = '2024-10-${index + 4}'; // Example dates
                        bool isSelected = selectedDate == date;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedDate = date;
                              selectedTime = null; // Reset selected time when date changes
                              fetchBookedTimes(); // Fetch booked times for the selected date
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 25),
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
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black.withOpacity(0.6)),
                                ),
                                const Text(
                                  "OCT",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    "Booking Time",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withOpacity(0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 70,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 5, // Changed to 5 for the time slots
                      itemBuilder: (context, index) {
                        String time = "${index + 8}:00 PM"; // Booking time slots from 8 PM to 12 AM
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
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 25),
                            decoration: BoxDecoration(
                              color: isBooked
                                  ? Colors.red
                                  : (isSelected ? Colors.green : Colors.white),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                time,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isBooked
                                      ? Colors.white
                                      : (isSelected ? Colors.white : Colors.black),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: isBooking ? null : bookAppointment,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15), backgroundColor: Colors.teal,
          ),
          child: const Text(
            'Book Now',
            style: TextStyle(fontSize: 20,
            color: Colors.black),
            
          ),
        ),
      ),
    );
  }
}
