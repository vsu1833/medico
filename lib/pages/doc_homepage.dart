import 'package:flutter/material.dart';
import 'package:login/components/drawer.dart';
import 'package:login/components/category_card.dart';
import 'package:login/components/doctor_card.dart';
import 'package:login/components/banner.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:login/pages/doc_profile.dart';

class DocHomepage extends StatefulWidget {
  DocHomepage({super.key});

  @override
  _DocHomepageState createState() => _DocHomepageState();
}

class _DocHomepageState extends State<DocHomepage> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final Size screenSize = MediaQuery.of(context).size;

    // Calculate container dimensions as a percentage of screen size
    final double containerWidth = screenSize.width * 0.9; // 80% of screen width
    final double containerHeight =
        screenSize.height * 0.30; // 30% of screen height

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 107, 170, 181),
        title: Center(
          child: Text(
            'M E D I C O',
            style: TextStyle(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu_rounded),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoctorProfileUpdateApp ()),
                );
              },
              icon: Icon(Icons.person))
        ],
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 30),

              // Banner section with PageView and Indicator
              Container(
                height: containerHeight,
                width: containerWidth,
                child: PageView(
                  controller: _pageController,
                  children: [
                    MyBanner(bannerName: 'banner1'),
                    MyBanner(bannerName: 'banner'),
                    MyBanner(bannerName: 'banner1'),
                  ],
                ),
              ),
              SizedBox(height: 16),
              SmoothPageIndicator(
                controller: _pageController,
                count: 3, // Number of banners
                effect: ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.blue,
                  dotColor: Colors.grey,
                ),
              ),

              SizedBox(height: 20),

              // Categories section
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Categories',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              SizedBox(height: 5),

              // Make the row scrollable to show categories
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      categoryCard(catName: 'Doctor'),
                      categoryCard(catName: 'test'),
                      categoryCard(catName: 'appointments'),
                      categoryCard(catName: 'Cardiology'),
                      categoryCard(catName: 'Skin Care'),
                    ],
                  ),
                ),
              ),

              // Top Doctors section
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Top Doctors',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              Column(
                children: [
                  doctorCard(
                      docName: 'Adarsh Naik', docRatings: '10', docId: '2'),
                  doctorCard(
                      docName: 'Narahari Hede', docRatings: '10', docId: '1'),
                  doctorCard(
                      docName: 'Natasha Upadhyay', docRatings: '10', docId: '3')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
