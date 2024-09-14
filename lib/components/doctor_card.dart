import 'package:flutter/material.dart';

class doctorCard extends StatelessWidget {
  final String docName;
  final String docRatings;
  final String docId;

  doctorCard({
    super.key,
    required this.docName,
    required this.docRatings,
    required this.docId,
  });

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final Size screenSize = MediaQuery.of(context).size;

    // Calculate container dimensions as a percentage of screen size
    final double containerWidth = screenSize.width * 0.9; // 80% of screen width
    final double containerHeight =
        screenSize.height * 0.1; // 30% of screen height

    return Padding(
      padding: EdgeInsets.all(
        8,
      ),
      child: Container(
        height: containerHeight,
        width: containerWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color.fromARGB(255, 136, 214, 228),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 6,
            ),
            CircleAvatar(
              radius: 30,
              backgroundImage: Image.asset('assets/doc$docId.jpg').image,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Dr.' + docName),
                SizedBox(
                  height: ((containerHeight) / 2) - 5 ,
                ),
                Text('Ratings : ' + docRatings)
              ],
            )
          ],
        ),
      ),
    );
  }
}
