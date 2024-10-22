import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login/pages/doctor_screen_page.dart';

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
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    fetchDoctorImage();
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

      print("Booked times for $selectedDate: $bookedTimes"); // Add this line
    } catch (e) {
      print("Error fetching booked times: $e");
    }
  }

  Future<void> fetchDoctorImage() async {
    try {
      DocumentSnapshot doctorDoc = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(widget.doctorId) // Use the doctorId to get the doctor's document
          .get();

      if (doctorDoc.exists) {
        setState(() {
          profileImageUrl = doctorDoc[
              'profile_image_url']; // Assuming 'profile_image_url' is the field name
        });
      }
    } catch (e) {
      print("Error fetching doctor's image: $e");
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

      // Ensure that the user doesn't already have an appointment on the same day with the doctor
      QuerySnapshot<Map<String, dynamic>> existingAppointmentSnapshot =
          await FirebaseFirestore.instance
              .collection('appointments')
              .where('patient_id', isEqualTo: widget.userId)
              .where('doctor_id', isEqualTo: widget.doctorId)
              .where('date', isEqualTo: selectedDate)
              .get();

      if (existingAppointmentSnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'You already have an appointment with this doctor on this date! You cannot have more than one appointment in one day')),
        );
        setState(() {
          isBooking = false;
        });
        return;
      }

      // Generate a document reference for the specific appointment (doctor + date + time)
      DocumentReference appointmentRef = FirebaseFirestore.instance
          .collection('appointments')
          .doc('${widget.doctorId}_$selectedDate$selectedTime');

      // Transaction to ensure atomic booking
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot docSnapshot = await transaction.get(appointmentRef);

        if (docSnapshot.exists) {
          throw Exception("Time slot already booked!");
        }

        // If the slot is available, book it
        transaction.set(appointmentRef, {
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
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Appointment booked for $selectedTime on $selectedDate')),
      );

      // Update booked times after the transaction
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorScreenPage(
                            doctorName: widget.doctorName,
                            phone: widget.phone,
                            doctorSpecialization: widget.doctorSpecialization,
                            doctorAddress: widget.doctorAddress,
                            doctorImage: widget.doctorImage,
                            consultationFee: widget.consultationFee,
                            doctorId: widget.doctorId,
                            userId: widget.userId,
                            doctorDescription: widget.description,
                            doctorLocation: widget.doctorAddress,

                            doctorImages: [widget.doctorImage],

                          ),
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
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(16, 255, 255, 255),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 80,
                          backgroundImage: profileImageUrl != null &&
                                  profileImageUrl!.isNotEmpty
                              ? NetworkImage(
                                  profileImageUrl!) // Display image from Firestore
                              : AssetImage(widget.doctorImage) as ImageProvider,
                          backgroundColor: Colors.teal.withOpacity(0.1),
                        ),
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
                            color: Color.fromARGB(141, 0, 0, 0),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.location_on, color: Colors.teal),
                            const SizedBox(width: 5),
                            Text(
                              widget.doctorAddress,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(127, 7, 1, 1),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.teal.withOpacity(0.2),
                                blurRadius: 6,
                                spreadRadius: 2,
                              ),
                            ],
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
                ],
              ),
            ),
            const SizedBox(height: 10),
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
                  SizedBox(
                    height: 70,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        DateTime currentDate = DateTime.now();
                        DateTime date = currentDate.add(Duration(days: index));
                        String formattedDate =
                            "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                        bool isSelected = selectedDate == formattedDate;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedDate = formattedDate;
                              selectedTime = null;
                              fetchBookedTimes();
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
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                formattedDate,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isSelected ? Colors.white : Colors.teal,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Select Time Slot",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        List<String> times = [
                          '08:00 AM',
                          '09:00 AM',
                          '10:00 AM',
                          '11:00 AM',
                          '12:00 PM',
                        ];

                        String time = times[index];
                        bool isBooked = bookedTimes.contains(time);
                        bool isSelected = selectedTime == time;

                        return InkWell(
                          onTap: isBooked
                              ? null // Disable onTap if the slot is booked
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
                                  ? const Color.fromARGB(
                                      255, 255, 5, 5) // Red for booked slots
                                  : isSelected
                                      ? Colors
                                          .teal // Highlight selected time slot
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
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
                                  fontWeight: FontWeight.bold,
                                  color: isBooked
                                      ? Colors
                                          .white // White text for booked slots
                                      : isSelected
                                          ? Colors.white
                                          : Colors.teal,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double
                        .infinity, // This will make the button take up the whole width
                    child: ElevatedButton(
                      onPressed: isBooking ? null : bookAppointment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(
                            vertical:
                                15), // Remove horizontal padding for full width
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: isBooking
                          ? const CircularProgressIndicator(
                              color: Color.fromARGB(255, 49, 200, 15),
                            )
                          : const Text(
                              "Book Now",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}