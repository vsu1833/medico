import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:login/pages/appointment_page.dart';
import 'package:login/pages/main_screen.dart';
import 'package:login/pop_up/app_pop_up.dart';


class DoctorScreenPage extends StatelessWidget {
  final String doctorName;
  final String doctorSpecialization;
  final String doctorDescription;
  final String doctorLocation;
  final String doctorAddress;
  final String doctorImage;
  final List<String> doctorImages;
  final String doctorId;
  final String userId;
  final String consultationFee;
  final String phone ;

  const DoctorScreenPage({
    super.key,
    required this.doctorName,
    required this.doctorSpecialization,
    required this.doctorDescription,
    required this.doctorLocation,
    required this.doctorAddress,
    required this.doctorImage,
    required this.doctorImages,
    required this.consultationFee,
    required this.doctorId,
    required this.phone,
    required this.userId,
  });

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
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(doctorImage),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          doctorName,
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 11, 0, 0),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          doctorSpecialization,
                          style: const TextStyle(
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
                  Text(
                    doctorDescription,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Reviews Section
                  const Text(
                    "Reviews",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 5),
                  ReviewSection(doctorId: doctorId, doctorImage: doctorImage, doctorName: doctorName), // Add the ReviewSection here
                  const SizedBox(height: 10),

                  const Text(
                    "Location",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  ListTile(
                    leading: const CircleAvatar(
                      radius: 30,
                      backgroundColor: Color.fromARGB(102, 147, 124, 124),
                      child: Icon(
                        Icons.location_on,
                        color: Color.fromARGB(255, 82, 246, 255),
                        size: 30,
                      ),
                    ),
                    title: Text(
                      doctorLocation,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    subtitle: Text(
                      doctorAddress,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
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
            Row(
              children: [
                const Text(
                  "Consultation Fee",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 20,
                  ),
                ),
                const Spacer(),
                Text(
                  consultationFee,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => PopUpAppo(
                      doctorName: doctorName,
                      phone:phone,
                      doctorSpecialization: doctorSpecialization,
                      doctorImage: doctorImage,
                      doctorDescription: doctorDescription,
                      doctorAddress: doctorAddress,
                      doctorId: doctorId,
                      doctorLocation: doctorAddress,
                      doctorImages: doctorImages,
                      consultationFee: consultationFee,
                      userId: userId,
                      reviews: const [], // Placeholder for now
                        // Placeholder for now
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Book Appointment",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}class ReviewSection extends StatelessWidget {
  final String doctorId;
  final String doctorImage;
  final String doctorName;

  const ReviewSection({
    super.key,
    required this.doctorId,
    required this.doctorImage,
    required this.doctorName,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('reviews')
          .where('docId', isEqualTo: doctorId)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text("No reviews available");
        }

        var reviews = snapshot.data!.docs;

        // Calculate the average rating and total reviews count
        double totalRating = 0;
        int totalReviews = reviews.length;

        for (var review in reviews) {
          totalRating += review['stars_count'];
        }

        double averageRating = totalRating / totalReviews;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                buildStarRating(averageRating), // Use the buildStarRating function for average rating
                const SizedBox(width: 5),
                Text(averageRating.toStringAsFixed(1)), // Display the average rating
                const SizedBox(width: 5),
                Text('($totalReviews)'), // Display the total number of reviews
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllReviewsScreen(doctorId: doctorId),
                      ),
                    );
                  },
                  child: const Text('See all'),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(reviews.length, (index) {
                  var review = reviews[index];
                  double starsCount = review['stars_count'].toDouble(); // Ensure it’s a double

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: SizedBox(
                      width: 250, // Set a width for the cards
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  doctorName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                buildStarRating(starsCount), // Use the updated star rating builder
                                Text(
                                  starsCount.toStringAsFixed(1), // Display decimal rating
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              review['review'],
                              style: const TextStyle(fontSize: 14),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper function to display fractional star ratings
  Widget buildStarRating(double rating) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      if (i <= rating) {
        stars.add(const Icon(Icons.star, color: Colors.amber, size: 16));
      } else if (i - rating < 1 && i - rating > 0) {
        stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 16));
      } else {
        stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 16));
      }
    }
    return Row(children: stars);
  }
}


class AllReviewsScreen extends StatelessWidget {
  final String doctorId;

  const AllReviewsScreen({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Reviews"),
        backgroundColor: Colors.teal, // Set a consistent app bar color
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reviews')
            .where('docId', isEqualTo: doctorId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No reviews available"));
          }

          var reviews = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              var review = reviews[index];
              double stars = review['stars_count'].toDouble();

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                elevation: 4, // Added elevation for a shadow effect
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              review['review_title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18, // Increased font size
                                color: Colors.teal, // Title color
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Row(
                            children: _buildStarRating(stars),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10), // Increased spacing
                      Text(
                        review['review'],
                        style: const TextStyle(fontSize: 16, color: Colors.black87), // Slightly darker text
                      ),
                      const SizedBox(height: 10),
                      Text(
                        review['review_date'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(224, 14, 0, 0),
                          fontStyle: FontStyle.italic, // Italicized date for distinction
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<Widget> _buildStarRating(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = rating - fullStars >= 0.5;

    // Add full stars
    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(
        Icons.star,
        color: Color.fromARGB(255, 255, 203, 46),
        size: 20, // Increased size for better visibility
      ));
    }

    // Add half star if applicable
    if (hasHalfStar) {
      stars.add(const Icon(
        Icons.star_half,
        color: Color.fromARGB(255, 255, 203, 46),
        size: 20,
      ));
    }

    // Fill remaining with empty stars (to make total 5 stars)
    while (stars.length < 5) {
      stars.add(const Icon(
        Icons.star_border,
        color: Color.fromARGB(255, 255, 203, 46),
        size: 20,
      ));
    }

    return stars;
  }
}
