// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnboardingCard extends StatelessWidget {
  final String image, title, description, buttonText;
  final Function onPressed;
  final double imageWidth;
  final double imageHeight;

  const OnboardingCard({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onPressed,
    this.imageWidth = 200.0, // Default width
    this.imageHeight = 200.0,
    // required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.80,
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(
              50.0,
            ),
            child: Image.asset(
              image,
              fit: BoxFit.contain,
            ),
          ),
          Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontSize: 30,
                    fontWeight: FontWeight.w900),
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Text(
                  description,
                  textWidthBasis: TextWidthBasis.parent,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 52, 46, 46),
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          SizedBox(
            width: 300,
            height: 30,
            child: MaterialButton(
              // hoverColor:
              // ,
              onPressed: () => onPressed(),
              minWidth: 300,
              color: Colors.black,
              child: Text(
                buttonText,
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
