import 'package:flutter/material.dart';
import 'package:login/appointment_booking.dart';

class CategoryPage extends StatelessWidget {
  final List<String> categories = [
    'Bones', 'Teeth', 'Skin', 'Eyes', 'Heart' // Add more categories as needed
  ];

  Object getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'bones':
        return '🦴';
      case 'teeth':
        return '🦷';
      case 'skin':
        return '🧴';
      case 'eyes':
        return '👁️';
      case 'heart':
        return '❤️';
      default:
        return const Icon(Icons.health_and_safety); // Fallback icon if category is unknown
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.teal,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two categories per row
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1, // Square items
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          String category = categories[index];
          String icon = getCategoryIcon(category) as String; // Get icon based on category name
          return GestureDetector(
            onTap: () {
              // Navigate to the doctors page for the selected category
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorsPage(category: category),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.teal.shade50, // Light teal background for cards
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    icon,
                    style: const TextStyle(fontSize: 50), // Display the dynamic icon
                  ),
                  const SizedBox(height: 16),
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade900, // Dark teal text
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
