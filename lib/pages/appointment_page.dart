import 'package:login/pages/doctor_screen_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentPage extends StatelessWidget {
  const AppointmentPage({super.key});

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
                            builder: (context) => DoctorScreenPage(),
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage("images/doctor1.jpg"),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Dr. Adarsh Nayak",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(239, 0, 0, 0),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Surgeon",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
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
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                spreadRadius: 2),
                          ],
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
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                spreadRadius: 2),
                          ],
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
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                                    const SizedBox(height: 5),

               Text(
                    "Dr. Adarsh Nayak is a highly skilled and compassionate medical professional with over 10 years of experience in the field of surgery. Specializing in general surgery.....",
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
                  Container(
                    height: 70,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {},
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 25),
                            decoration: BoxDecoration(
                              color: index == 1
                                  ? Colors.teal
                                  : Colors.white, // Use '==' for comparison
                              borderRadius: BorderRadius.circular(10),
                              boxShadow:const [
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
                                  "${index + 8}",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: index == 1
                                          ? Colors.white
                                          : Colors.black.withOpacity(0.6)),
                                ),
                                Text(
                                  "SEPT",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: index == 1
                                          ? Colors.white
                                          : Colors.black.withOpacity(0.6)),
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
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {},
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 25),
                            decoration: BoxDecoration(
                              color: index == 1
                                  ? Colors.teal
                                  : Colors.white, // Use '==' for comparison
                              borderRadius: BorderRadius.circular(10),
                              boxShadow:const [
                                 BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "${index + 8} : PM ",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: index == 1
                                        ? Colors.white
                                        : Colors.black.withOpacity(0.6)),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(15),
        height: 90,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              spreadRadius: 2,
            ),
          ],
        ),
        child: InkWell(
          onTap: () {},
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 20, 142, 140),
                borderRadius: BorderRadius.circular(10)),
            child: const Center(
              child: Text(
                "Book Now",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


