import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HealthAnalyticsPage extends StatefulWidget {
  @override
  _HealthAnalyticsPageState createState() => _HealthAnalyticsPageState();
}

class _HealthAnalyticsPageState extends State<HealthAnalyticsPage> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _bloodSugarController = TextEditingController();
  final _bloodPressureController = TextEditingController();
  String _bmiResult = '';
  String? uid;

  String bloodPressure = 'N/A';
  String bloodSugar = 'N/A';
  String lastRecordedPulse = 'N/A';
  String note = 'No notes available';
  String _healthAnalysis = '';

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _retrieveUserData();
  }

  void _retrieveUserData() async {
    // Get the current user
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Fetch user data from Firestore
      uid = currentUser.uid;

      try {
        // Fetch patient data
        DocumentSnapshot patientSnapshot =
            await _firestore.collection('patients').doc(uid).get();

        // Fetch health analytics data
        DocumentSnapshot analyticsSnapshot =
            await _firestore.collection('health_analytics').doc(uid).get();

        // Handle patient data
        if (patientSnapshot.exists) {
          setState(() {
            _heightController.text =
                (patientSnapshot['height'] ?? 'N/A').toString();
            _weightController.text =
                (patientSnapshot['weight'] ?? 'N/A').toString();
          });
        } else {
          print('Patient data not found.');
        }

        // Handle health analytics data
        if (analyticsSnapshot.exists) {
          setState(() {
            bloodPressure =
                (analyticsSnapshot['blood_pressure'] ?? 'N/A').toString();
            bloodSugar = (analyticsSnapshot['blood_sugar'] ?? 'N/A').toString();
            lastRecordedPulse =
                (analyticsSnapshot['last_recorded_pulse'] ?? 'N/A').toString();
            note = analyticsSnapshot['note'] ?? 'No notes available';
          });
        } else {
          print('Health analytics data not found.');
        }

        // Debugging: Print the entire snapshot to see what you have
        print('Patient Data: ${patientSnapshot.data()}');
        print('Health Analytics Data: ${analyticsSnapshot.data()}');
      } catch (e) {
        print('Error retrieving data: $e');
      }
    } else {
      print('No user is signed in.');
    }
  }

  /*void _retrieveUserData() async {
    // Get the current user
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Fetch user data from Firestore
      uid = currentUser.uid;

      try {
        // Fetch patient data
        DocumentSnapshot patientSnapshot =
            await _firestore.collection('patients').doc(uid).get();

        // Fetch health analytics data
        DocumentSnapshot analyticsSnapshot =
            await _firestore.collection('health_analytics').doc(uid).get();

        // Handle patient data
        if (patientSnapshot.exists) {
          setState(() {
            _heightController.text =
                (patientSnapshot['height'] ?? 'N/A').toString();
            _weightController.text =
                (patientSnapshot['weight'] ?? 'N/A').toString();
          });
        } else {
          print('Patient data not found.');
        }

        // Handle health analytics data
        if (analyticsSnapshot.exists) {
          setState(() {
            bloodPressure =
                (analyticsSnapshot['blood_pressure'] ?? 'N/A').toString();
            bloodSugar = (analyticsSnapshot['blood_sugar'] ?? 'N/A').toString();
            lastRecordedPulse =
                (analyticsSnapshot['last_recorded_pulse'] ?? 'N/A').toString();
            note = analyticsSnapshot['note'] ?? 'No notes available';
          });
        } else {
          print('Health analytics data not found.');
        }
      } catch (e) {
        print('Error retrieving data: $e');
      }
    } else {
      print('No user is signed in.');
    }
  }*/

  // Retrieve user's height and weight from Firestore
  /*void _retrieveUserData() async {
    // Get the current user
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Fetch user data from Firestore
      uid = currentUser.uid;

      DocumentSnapshot snapshot =
          await _firestore.collection('patients').doc(currentUser.uid).get();
      if (snapshot.exists) {
        setState(() {
          _heightController.text = snapshot['height'].toString();
          _weightController.text = snapshot['weight'].toString();
        });
        //_calculateBMI(); // Calculate BMI based on retrieved values
      }
    } else {
      // Handle case where there is no signed-in user
      print('No user is signed in.');
    }
  }*/

  void _calculateBMI() async {
    final double? height = double.tryParse(_heightController.text);
    final double? weight = double.tryParse(_weightController.text);

    if (height != null && weight != null && height > 0) {
      final bmi = (weight * 10000) / (height * height); // Height in cm

      setState(() {
        _bmiResult = bmi.toStringAsFixed(2);
      });

      try {
        // Ensure uid is initialized
        if (uid != null) {
          await _firestore.collection('health_analytics').doc(uid).set(
              {'BMI': _bmiResult}, SetOptions(merge: true)); // Merge updates
        } else {
          print('User ID is null. Cannot update BMI.');
        }
      } catch (e) {
        print('Failed to update BMI: $e');
      }
    } else {
      setState(() {
        _bmiResult = 'Invalid input';
      });
    }
  }

  /*String analyzeHealth(double bmi, String bp, int bloodSugar) {
    String healthInfo = '';

    // BMI analysis
    if (bmi < 18.5) {
      healthInfo += 'Underweight: Consider improving your nutrition.\n';
    } else if (bmi >= 18.5 && bmi < 25) {
      healthInfo += 'Normal BMI: Great! Maintain your healthy lifestyle.\n';
    } else if (bmi >= 25 && bmi < 30) {
      healthInfo += 'Overweight: Watch your diet and stay active.\n';
    } else {
      healthInfo += 'Obese: High risk of diabetes and heart disease.\n';
    }

    // Blood Pressure analysis
    List<String> bpValues = bp.split('/');
    if (bpValues.length == 2) {
      int systolic = int.tryParse(bpValues[0]) ?? 0;
      int diastolic = int.tryParse(bpValues[1]) ?? 0;

      if (systolic < 120 && diastolic < 80) {
        healthInfo += 'Normal BP: Keep up the good work!\n';
      } else if (systolic >= 120 && systolic < 130 && diastolic < 80) {
        healthInfo += 'Elevated BP: Monitor and consider lifestyle changes.\n';
      } else if (systolic >= 130 && systolic < 140 ||
          diastolic >= 80 && diastolic < 90) {
        healthInfo += 'Stage 1 Hypertension: Regular monitoring required.\n';
      } else {
        healthInfo += 'Stage 2 Hypertension: High risk of heart disease.\n';
      }
    } else {
      healthInfo += 'Invalid BP reading. Please recheck.\n';
    }

    // Blood Sugar analysis
    if (bloodSugar < 100) {
      healthInfo += 'Normal Blood Sugar: Great control!\n';
    } else if (bloodSugar >= 100 && bloodSugar < 126) {
      healthInfo += 'Prediabetes: Watch your sugar intake.\n';
    } else {
      healthInfo += 'Diabetes: High risk. Consult your doctor.\n';
    }

    return healthInfo;
  }*/

  // Store blood sugar and blood pressure in Firestore
  /*void _storeHealthData() {
    _firestore.collection('health_analytics').doc(uid).update({
      'blood_sugar': _bloodSugarController.text,
      'blood_pressure': _bloodPressureController.text,
    });
  }*/

  Future<void> analyzeHealth() async {
    //String _healthAnalysis = '';
    double? bmi = double.tryParse(_bmiResult);
    int? bp = int.tryParse(
        bloodPressure.split('/').first); // Assuming "120/80" format
    int? sugar = int.tryParse(bloodSugar);
    int? pulse = int.tryParse(lastRecordedPulse);

    List<String> risks = [];

    if (bmi != null) {
      if (bmi >= 30)
        risks.add('High risk of Obesity-related diseases');
      else if (bmi < 18.5) risks.add('Underweight, risk of malnutrition');
    }

    if (bp != null) {
      if (bp > 140)
        risks.add('Hypertension risk');
      else if (bp < 90) risks.add('Low Blood Pressure detected');
    }

    if (sugar != null) {
      if (sugar > 180)
        risks.add('High Blood Sugar, risk of Diabetes');
      else if (sugar < 70) risks.add('Low Blood Sugar, risk of Hypoglycemia');
    }

    if (pulse != null) {
      if (pulse > 100)
        risks.add('High Pulse Rate, potential Tachycardia');
      else if (pulse < 60) risks.add('Low Pulse Rate, possible Bradycardia');
    }

    // Generate result summary
    setState(() {
      _healthAnalysis = risks.isNotEmpty
          ? risks.join('\n')
          : 'No significant health risks detected.';
    });

    print(_healthAnalysis); // Debugging output

    try {
      if (uid != null) {
        await _firestore.collection('health_analytics').doc(uid).set(
          {'health_analysis': _healthAnalysis},
          SetOptions(merge: true), // Merges with existing data
        );
        print('Health analysis successfully saved.');
      } else {
        print('User ID is null. Cannot store health analysis.');
      }
    } catch (e) {
      print('Failed to save health analysis: $e');
    }
  }

  /*void _generateHealthAnalysis() {
    final double? height = double.tryParse(_heightController.text);
    final double? weight = double.tryParse(_weightController.text);
    final String bp = _bloodPressureController.text;
    final int? bloodSugar = int.tryParse(_bloodSugarController.text);

    if (height != null &&
        weight != null &&
        bp.isNotEmpty &&
        bloodSugar != null) {
      final bmi = (weight * 10000) / (height * height); // Height in cm
      setState(() {
        _bmiResult = bmi.toStringAsFixed(2);
        _healthAnalysis = analyzeHealth(bmi, bp, bloodSugar);
      });

      // Store the health analysis in Firestore
      _firestore.collection('health_analytics').doc(uid).set({
        'BMI': _bmiResult,
        'HealthAnalysis': _healthAnalysis,
      }, SetOptions(merge: true));
    } else {
      setState(() {
        _healthAnalysis = 'Invalid input. Please provide all values.';
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Healthcare Analytics'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 107, 170, 181),
        leading: Row(
          mainAxisSize: MainAxisSize.min, // Set the row size to minimum
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back), // Default back arrow
              onPressed: () {
                Navigator.pop(context); // Go back to the previous page
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        // Ensures padding around the screen to prevent overflow
        child: Container(
          color: Color.fromARGB(255, 7, 50, 69),
          child: Column(
            children: [
              Expanded(
                // Ensures the main content takes available space
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildExpandableBMISection(),
                        const SizedBox(height: 16),
                        _buildExpandableBloodSugarSection(),
                        const SizedBox(height: 16),
                        _buildExpandableBloodPressureSection(),
                        const SizedBox(height: 16),
                        _buildExpandablePulseSection(),
                        const SizedBox(height: 16), // To prevent overlap
                        _buildExpandableRiskAnalysisSection(),
                      ],
                    ),
                  ),
                ),
              ),
              // Placed outside Expanded
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataCard(String title, String value, Color color) {
    return Card(
      color: color.withOpacity(1), // Use the passed color
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            //Icon(icon, color: Colors.white, size: 40), // Correctly using the Icon widget
            SizedBox(width: 16), // Spacing between icon and text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  value.isEmpty ? '-N.A.-' : value,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /*Widget _buildDataCard(String label, String value) {
    return Card(
      color: const Color.fromARGB(255, 38, 187, 213), // Matches your theme
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: ListTile(
        title: Text(
          label,
          style: const TextStyle(
            color: Color.fromARGB(255, 9, 43, 101),
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Text(
          value,
          style: const TextStyle(
            color: Color.fromARGB(255, 9, 43, 101),
            fontSize: 16,
          ),
        ),
      ),
    );
  }*/

  Widget _buildBMICircleIndicator(String bmi) {
    return SizedBox(
      width: 120, // Adjust size to fit well
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer concentric circle
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(
                color: Color.fromARGB(
                    255, 38, 187, 213), // Border color (darker shade)
                width: 8.0, // Thickness of the border circle
              ),
            ),
          ),
          // Inner circle with lighter blue background
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 86, 131, 139), // Lighter blue shade
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Your BMI:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  bmi,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableBMISection() {
    return ExpansionTile(
      title: _buildAnalyticsTile(
        icon: Icons.fitness_center,
        title: 'Body-Mass Index (in kg/m*m)',
        value: _bmiResult.isEmpty ? '-N.A.-' : _bmiResult,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildBMICircleIndicator(_bmiResult),
              const SizedBox(height: 16),
              _buildDataCard('Height (in meters)', _heightController.text,
                  Color.fromARGB(255, 38, 187, 213)),
              const SizedBox(height: 16),
              _buildDataCard('Weight (in kg)', _weightController.text,
                  Color.fromARGB(255, 38, 187, 213)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _calculateBMI,
                child: const Text('Calculate BMI'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpandableBloodSugarSection() {
    return ExpansionTile(
      title: _buildAnalyticsTile2(
        icon: Icons.bloodtype,
        title: 'Blood Sugar (Last Recorded)',
        value: bloodSugar.isEmpty ? '-N.A.-' : '$bloodSugar mg/dL',
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildDataCard('Blood Sugar', '$bloodSugar mg/dl',
              Color.fromARGB(255, 218, 112, 188)
              //Icons.bloodtype,
              ),
        ),
      ],
    );
  }

  Widget _buildExpandableBloodPressureSection() {
    return ExpansionTile(
      title: _buildAnalyticsTile(
        icon: Icons.monitor_heart,
        title: 'Blood Pressure (Last Recorded)',
        value: bloodPressure.isEmpty ? '-N.A.-' : '$bloodPressure mmHg' ,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildDataCard(
              'Blood Pressure', '$bloodPressure mmHg', Color.fromARGB(255, 38, 187, 213)
              //Icons.monitor_heart,
              ),
        ),
      ],
    );
  }

  Widget _buildExpandablePulseSection() {
    return ExpansionTile(
      title: _buildAnalyticsTile2(
        icon: Icons.monitor_heart,
        title: 'Last Recorded Pulse',
        value: lastRecordedPulse.isEmpty ? '-N.A.-' : '$lastRecordedPulse bpm',
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildDataCard('Last Recorded Pulse', '$lastRecordedPulse bpm',
              Color.fromARGB(255, 218, 112, 188)
              //Icons.monitor_heart,
              ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 38, 187, 213),
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(icon, size: 40, color: const Color.fromARGB(255, 9, 43, 101)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: const Color.fromARGB(255, 9, 43, 101),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  //overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    color: const Color.fromARGB(255, 9, 43, 101),
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTile2({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 218, 112, 188),
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(icon, size: 40, color: Colors.white),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  //overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /*Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.white), // Set focused border color to white
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.white), // Set enabled border color to white
        ),
      ),
      readOnly: readOnly,
    );
  }*/

  Widget _buildExpandableRiskAnalysisSection() {
    return ExpansionTile(
      title: _buildAnalyticsTile(
        icon: Icons.health_and_safety,
        title: 'Risk Analysis',
        value: _healthAnalysis.isEmpty
            ? 'Tap to view details'
            : 'Analysis Complete!',
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  await analyzeHealth();
                },
                child: const Text('Analyse Risk'),
                style: ElevatedButton.styleFrom(
                    //backgroundColor: const Color.fromARGB(255, 86, 131, 139),
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                _healthAnalysis.isEmpty
                    ? 'Risk percentages and lifestyle suggestions will appear here.'
                    : _healthAnalysis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              /*const SizedBox(height: 16),
              ElevatedButton(
                onPressed: analyzeHealth,
                child: const Text('Analyze Risk'),
              ),*/
            ],
          ),
        ),
      ],
    );
  }

  /*Widget _buildRiskAnalysisSection() {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 38, 187, 213),
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Risk Analysis',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _healthAnalysis.isEmpty
                ? 'Risk percentages and lifestyle suggestions will appear here.'
                : _healthAnalysis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
    /*return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 218, 112, 188),
        //color: const Color.fromARGB(255, 9, 43, 101),
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Risk Analysis',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Risk percentages and lifestyle suggestions will appear here.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );*/
  }*/

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _bloodSugarController.dispose();
    _bloodPressureController.dispose();
    super.dispose();
  }
}
