import 'package:flutter/material.dart';
import 'package:login/sidebar/appointment_booking.dart';
// 1s this
class CategoryPage extends StatelessWidget {
  final List<String> categories = [
    'Physician',
    'Cardiologist',
    'Surgeon',
    'Orthopaedician',
    'Pediatrician',
    'Skin Specialist',
    'Gynecologist',
    'ENT',
    'Neurologist',
    'Psychiatrist',
    'Dentist',
  ];

   CategoryPage({super.key});

  Widget getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'physician':
        return const Text('🩺', style: TextStyle(fontSize: 50)); // Stethoscope
      case 'cardiologist':
        return const Text('❤️', style: TextStyle(fontSize: 50)); // Heart
      case 'surgeon':
        return const Text('🔪', style: TextStyle(fontSize: 50)); // Knife
      case 'orthopaedician':
        return const Text('🦴', style: TextStyle(fontSize: 50)); // Bone
      case 'pediatrician':
        return const Text('👶', style: TextStyle(fontSize: 50)); // Baby
      case 'skin specialist':
        return const Text('🧴', style: TextStyle(fontSize: 50)); // Lotion
      case 'gynecologist':
        return const Text('🤰', style: TextStyle(fontSize: 50)); // Pregnant woman
      case 'ent':
        return const Text('👂', style: TextStyle(fontSize: 50)); // Ear
      case 'neurologist':
        return const Text('🧠', style: TextStyle(fontSize: 50)); // Brain
      case 'psychiatrist':
        return const Text('🧘', style: TextStyle(fontSize: 50)); // Meditation pose
      case 'dentist':
        return const Text('🦷', style: TextStyle(fontSize: 50)); // Tooth
      default:
        return const Icon(Icons.health_and_safety, size: 50); // Fallback icon
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: const Color.fromARGB(255, 0, 120, 150),
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
          Widget icon = getCategoryIcon(category); // Get icon widget based on category name
          return GestureDetector(
            onTap: () {
              // Navigate to the doctors page for the selected category
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorsPage(category: category), // Ensure this page exists
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
                  icon, // Display the dynamic icon (now a widget)
                  const SizedBox(height: 16),
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 2, 111, 138), // Dark teal text
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
