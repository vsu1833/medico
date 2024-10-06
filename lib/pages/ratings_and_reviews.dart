import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:login/components/black_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:login/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Fetching the current date and time
DateTime currentDate = DateTime.now();

// Formatting it to show only the date (without time)
String formattedDate =
    "${currentDate.day}-${currentDate.month}-${currentDate.year}";

/*
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ratings and Reviews',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RatingsAndReviews(),
      debugShowCheckedModeBanner: false, // Set this to false to remove the debug banner
    );
  }
}
*/
class RatingsAndReviews extends StatefulWidget {
  final dynamic drName;
  final dynamic appointmentDate;
  final dynamic docId;
  const RatingsAndReviews({
    required this.drName,
    required this.appointmentDate,
    required this.docId,
    super.key,
  });

  @override
  State<RatingsAndReviews> createState() => _RatingsAndReviewsState();
}

class _RatingsAndReviewsState extends State<RatingsAndReviews> {
  double _currentRating = 3.0; // Variable to store the current rating
  final TextEditingController _reviewTitleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _review;
  String currentOption = 'Yes'; // Store the current radio option

  void _saveRating(double rating) {
    setState(() {
      _currentRating = rating; // Update the current rating
    });
    print('Rating saved: $_currentRating'); // Log the current rating
  }

  Future<void> saveReview() async {
    // Get the current user's ID
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User is not logged in.')),
      );
      return;
    }

    // Save the review in the 'reviews' collection
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('reviews')
        .doc(currentUser.uid + widget.docId);

    await docRef.set({
      'docId': widget.docId,
      'patientId': currentUser.uid,
      'appointment_date': widget.appointmentDate,
      'review_date': formattedDate,
      'stars_count': _currentRating,
      'review_title': _reviewTitleController.text,
      'will_recommend': currentOption,
      'review': _review
    });
    print('////////REVIEW UPDATED ///////');
    // Update the `reviewStatus` in the `appointments` collection
    QuerySnapshot appointmentSnapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('patientId', isEqualTo: currentUser.uid)
        .where('docId', isEqualTo: widget.docId) // Assuming docId is doctorId
        .where('date', isEqualTo: widget.appointmentDate)
        .limit(1)
        .get();

    if (appointmentSnapshot.docs.isNotEmpty) {
      // Assuming only one document is retrieved
      DocumentReference appointmentRef =
          appointmentSnapshot.docs.first.reference;

      await appointmentRef.update({
        'reviewStatus': 'true',
      });
    }
    print('/////////REVIEWED FLAG TRUE ///////');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Review submitted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ratings And Reviews'),
        backgroundColor: const Color.fromARGB(255, 107, 170, 181),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey, // Associate the form key here
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Text(
                  'Overall Rating',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                RatingBar(
                  minRating: 1,
                  maxRating: 5,
                  initialRating: _currentRating,
                  allowHalfRating: true,
                  onRatingUpdate: (rating) {
                    _saveRating(rating);
                  },
                  ratingWidget: RatingWidget(
                    full: Icon(Icons.star, color: Colors.amber),
                    half: Icon(Icons.star_half, color: Colors.amber),
                    empty: Icon(Icons.star, color: Colors.grey),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Click to rate',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 10),
                Text(
                  'Review Title',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: TextFormField(
                    controller: _reviewTitleController,
                    decoration: InputDecoration(
                      hintText: 'Enter review title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black87),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a review title';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    'Are you likely to recommend the services of this doctor to your friends and family?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: Text("Yes"),
                        leading: Radio(
                          activeColor: Colors.black87,
                          value: 'Yes',
                          groupValue: currentOption,
                          onChanged: (value) {
                            setState(() {
                              currentOption = value.toString();
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text("No"),
                        leading: Radio(
                          activeColor: Colors.black87,
                          value: 'No',
                          groupValue: currentOption,
                          onChanged: (value) {
                            setState(() {
                              currentOption = value.toString();
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: const Text(
                    'Detailed Review',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 4),
                TextFormField(
                  maxLines: 6, // Allows multiple lines
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black87),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey)),
                    hintText: 'Write your review here ',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please write a review';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _review = value;
                  },
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Dr Name- ${widget.drName}', // Access drName using widget
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 100),
                    Text(
                      'Date of Appointment- ${widget.appointmentDate}', // Access appointmentDate using widget
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                MyBlackButton(
                    onTap: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState
                            ?.save(); // Call save on the form state
                        saveReview();
                        print('Review was saved');
                      }
                    },
                    buttonname: "Submit"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
