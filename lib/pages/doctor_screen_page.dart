// import 'package:login/pages/appointment_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:login/pages/appointment_page.dart';
import 'package:login/pages/home_screen.dart';
import 'package:login/pop_up/app_pop_up.dart';
import 'package:login/pages/doctor_screen_page.dart';
import 'package:login/pages/main_screen.dart';
import 'package:login/pop_up/app_pop_up.dart';
class DoctorScreenPage extends StatelessWidget {
  DoctorScreenPage({super.key});

  // Define the images list here
  final List<String> imgs = [
    'assets/images/doctor1.jpg',
    'assets/images/doctor2.jpeg',
    'assets/images/doct3.jpeg',
    'assets/images/doct4.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 138, 154).withOpacity(0.8),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                           
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ),
                        );
                      
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          size: 25,
                          color: Color.fromARGB(255, 7, 0, 0),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage("assets/images/doct1.jpg"),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Dr. Adarsh Nayak",
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 2, 0, 0),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Surgeon",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w200,
                            color: Color.fromARGB(255, 5, 0, 0),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.call,
                                color: Colors.teal,
                                size: 25,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                CupertinoIcons.chat_bubble_text_fill,
                                color: Colors.teal,
                                size: 25,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: MediaQuery.of(context).size.height / 1.5,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 20, left: 15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text(
                    "About Doctor",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Dr. Adarsh Nayak is a highly skilled and compassionate medical professional with over 10 years of experience in the field of surgery. Specializing in general surgery.....",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(231, 0, 0, 0),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                   const Row(
                        children: [
                           Text(
                            "Reviews",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                           SizedBox(width: 10),
                           Icon(Icons.star, color: Colors.amber),
                           Text(
                            "4.9",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                           SizedBox(
                            width: 15,
                          ),
                           Text(
                            "(124)",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 29, 171, 219),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            "See all",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.teal,
                            ),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: imgs.length, // Use the length of the imgs list
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                )
                              ]),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.4,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: AssetImage(
                                      imgs[index], // Correctly use imgs list here
                                    ),
                                  ),
                                  title: const Text(
                                    "Dr. Adarsh Nayak",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: const Text("1 day ago"),
                                  trailing:const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:  [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      Text(
                                        "4.9",
                                        style: TextStyle(
                                          color: Colors.black54,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    "Many thanks to Dr. Nayak, he is a great and professional doctor.",
                                    style: TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Location",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  const ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Color.fromARGB(23, 11, 0, 0),
                      child: Icon(
                        Icons.location_on,
                        color: Color.fromARGB(255, 82, 246, 255),
                        size: 30,
                      ),
                    ),
                    title: Text(
                      "New Delhi, Medical Center",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      
                    ),
subtitle: Text(
    "1234 Health St, Block C, Sector 9, New Delhi, Delhi 110001, India",
    style: TextStyle(
      color: Color.fromARGB(255, 0, 0, 0),
    ),
  ),                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(15),
        height: 140,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
          const  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text(
                  "Consultation fee",
                  style: TextStyle(
                    color: Color.fromARGB(221, 0, 0, 0),
                  ),
                ),
                Spacer(),
                 Text(
                  "₹400",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            InkWell(
              onTap: () {
                // Navigate to appointment popup page
                Navigator.push(context, MaterialPageRoute(builder: (context) => PopUpAppo()));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "Book Appointment",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
