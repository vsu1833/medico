import 'package:flutter/material.dart';

class MyBanner extends StatelessWidget {
  final String bannerName;

  MyBanner(
    {super.key,
    required this.bannerName,
  }
  );
  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final Size screenSize = MediaQuery.of(context).size;

    // Calculate container dimensions as a percentage of screen size
    final double containerWidth = screenSize.width * 0.9; // 80% of screen width
    final double containerHeight =
        screenSize.height * 0.30; // 30% of screen height
    return Container(
      height: containerHeight,
      width: containerWidth,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 107, 170, 181),
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
            image: Image.asset('assets/$bannerName.jpg').image, fit: BoxFit.fill),
      ),
    );
  }
}
