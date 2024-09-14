import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color.fromARGB(255, 107, 170, 181),
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 107, 170, 181),
              ),
              accountName: Text("User Name"),
              accountEmail: Text("user@example.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  "U",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.local_hospital_rounded,
                size: 30,
              ),
              title: const Text(
                'B O O K  A P P O I N T M E N T',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              onTap: () {
                print('Button tapped');
              },
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Icon(
                Icons.fitness_center_rounded,
                size: 30,
              ),
              title: const Text(
                'H E A L T H  A N A L Y T I C S',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              onTap: () {
                print('Button tapped');
              },
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Icon(
                Icons.search,
                size: 30,
              ),
              title: const Text(
                'F I N D  A  D O C T O R',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              onTap: () {
                print('Button tapped');
              },
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Icon(
                Icons.receipt_long_rounded,
                size: 30,
              ),
              title: const Text(
                'T E S T S  A N D  R E P O R T S',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              onTap: () {
                print('Button tapped');
              },
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Icon(
                Icons.rate_review,
                size: 30,
              ),
              title: const Text(
                'A D D  A  R E V I E W',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              onTap: () {
                print('Button tapped');
              },
            ),
          ],
        ),
      ),
    );
  }
}
