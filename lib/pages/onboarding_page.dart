import 'package:flutter/material.dart';
import 'package:login/components/onboarding_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:login/pages/login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() {
    return _OnboardingPageState();
  }
}

class _OnboardingPageState extends State<OnboardingPage> {
  static final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    // Initialize the onboarding pages inside build method where context is available
    final List<Widget> onBoardingPages = [
      OnboardingCard(
        image: "assets/dcotor.jpeg",
        imageHeight: 400,
        imageWidth: 400,
        title: "Welcome to MediCo!",
        description:
            "Manage your health effortlessly and stay connected with your provider.",
        buttonText: 'Continue',
        onPressed: () {
          _pageController.animateToPage(1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear);
        },
      ),
      OnboardingCard(
        image: "assets/choose_doctor.png",
        title: "Choose Your Doctor",
        description:
            "At MediCo, we believe in personalized care. Choose from a curated selection of top-notch doctors who align with your needs and values.",
        buttonText: 'Continue',
        onPressed: () {
          _pageController.animateToPage(2,
              duration: const Duration(milliseconds: 300), curve: Curves.ease);
        },
      ),
      OnboardingCard(
        image: "assets/hii.png",
        title: "Get Appointments with Doctor",
        description:
            "Schedule and manage your appointments effortlessly, all at your fingertips. Welcome to a new era of convenience with MediCo - Your health, our priority.",
        buttonText: 'Continue',
        onPressed: () {
          _pageController.animateToPage(3,
              duration: const Duration(milliseconds: 300), curve: Curves.ease);
        },
      ),
      OnboardingCard(
        image: "assets/medical_his.png",
        title: "Your Health History at a Glance",
        description:
            "Effortlessly access and manage your medical records history to stay informed and connected with your healthcare provider.",
        buttonText: 'Get Started',
        onPressed: () {
          // Navigate to LoginPage on button press
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
      ),
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 107, 170, 181),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                children: onBoardingPages,
              ),
            ),
            SmoothPageIndicator(
              controller: _pageController,
              count: onBoardingPages.length,
              effect: const WormEffect(
                paintStyle: PaintingStyle.stroke,
                strokeWidth: 1.5,
                dotColor: Color.fromARGB(255, 13, 4, 4),
                activeDotColor: Color.fromARGB(255, 8, 10, 10),
              ),
              onDotClicked: (index) {
                _pageController.animateToPage(index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linear);
              },
            ),
            TextButton(
              onPressed: () {
                _pageController.jumpToPage(onBoardingPages.length - 1);
              },
              child: const Text(
                "Skip",
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
