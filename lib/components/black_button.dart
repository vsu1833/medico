import 'package:flutter/material.dart';

class MyBlackButton extends StatelessWidget {
  final Function()? onTap;
  final String buttonname;
  const MyBlackButton({super.key, required this.onTap, required this.buttonname});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            buttonname,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
