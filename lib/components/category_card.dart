import 'package:flutter/material.dart';

class categoryCard extends StatelessWidget {
  final String catName;

  categoryCard({
    super.key,
    required this.catName,
  });

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final Size screenSize = MediaQuery.of(context).size;

    // Calculate container dimensions as a percentage of screen size
    final double containerWidth =
        screenSize.width * 0.33; // 80% of screen width
    final double containerHeight =
        screenSize.height * 0.075; // 30% of screen height

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: Container(
        height: containerHeight,
        width: containerWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color.fromARGB(255, 136, 214, 228),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(catName),
        ),
      ),
    );
  }
}
