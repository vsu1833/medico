// import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpcomingSchedule extends StatelessWidget {
  const UpcomingSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "About Doctor",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
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
                  const ListTile(
                    title: Text("Dr. Adarsh Nalayak",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Therapist"),
                    trailing: CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage("images/doctor1.jpg"),
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
                      const Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "10/11/2024",
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          )
                        ],
                      ),
                      const Row(
                        children: [
                          Icon(
                            Icons.access_time_filled,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "9:00 PM",
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(
                            width: 5
                          ),
                          const Text(
                            "Confirmed",
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          )
                        ],
                      ),

                    ],
                  ),
                  const SizedBox(
                    height: 15,
                    
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: (){

                        },
                       child: Container(
                        width: 150,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          
                          ),
                          child: const Center(
                            child: Text("Cancel",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight : FontWeight.w500 ,
                              color: Colors.black,
                            ),),
                          ),
                        ),
                       ), 
                       InkWell(
                        onTap: (){

                        },
                       child: Container(
                        width: 150,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(10),
                          
                          ),
                          child: const Center(
                            child: Text("Rescheduled",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight : FontWeight.w500 ,
                              color: Color.fromARGB(255, 252, 252, 252),
                            ),),
                          ),
                        ),
                       ), 
                    ],
                  ),
                  const SizedBox(height: 10,)

                ],
              ),
            ),
          ),
           const Text(
            "About Doctor",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
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
                  const ListTile(
                    title: Text("Dr. Adarsh Nalayak",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Therapist"),
                    trailing: CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage("images/doctor1.jpg"),
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
                      const Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "10/11/2024",
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          )
                        ],
                      ),
                      const Row(
                        children: [
                          Icon(
                            Icons.access_time_filled,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "9:00 PM",
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(
                            width: 5
                          ),
                          const Text(
                            "Confirmed",
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          )
                        ],
                      ),

                    ],
                  ),
                  const SizedBox(
                    height: 15,
                    
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: (){

                        },
                       child: Container(
                        width: 150,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          
                          ),
                          child: const Center(
                            child: Text("Cancel",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight : FontWeight.w500 ,
                              color: Colors.black,
                            ),),
                          ),
                        ),
                       ), 
                       InkWell(
                        onTap: (){

                        },
                       child: Container(
                        width: 150,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(10),
                          
                          ),
                          child: const Center(
                            child: Text("Rescheduled",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight : FontWeight.w500 ,
                              color: Color.fromARGB(255, 252, 252, 252),
                            ),),
                          ),
                        ),
                       ), 
                    ],
                  ),
                  const SizedBox(height: 10,)

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
