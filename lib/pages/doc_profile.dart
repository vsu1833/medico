/*import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorProfileUpdateApp extends StatelessWidget {
  const DoctorProfileUpdateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Doctor Profile Updation',
      home: DoctorProfileUpdatePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DoctorProfileUpdatePage extends StatefulWidget {
  const DoctorProfileUpdatePage({super.key});

  @override
  _DoctorProfileUpdatePageState createState() =>
      _DoctorProfileUpdatePageState();
}

class _DoctorProfileUpdatePageState extends State<DoctorProfileUpdatePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _clinicAddressController =
      TextEditingController();
  final TextEditingController _clinicPhoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _gender = 'Male';
  bool _isSpecializationSelected = false;
  String? _selectedSpecialization;
  File? _profileImage;

  final List<String> _mbbsSpecializations = ['General Practitioner'];
  final List<String> _postgraduateSpecializations = [
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

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  Future<void> saveDoctorProfile() async {
    // Get the current user's ID
    print('Entered the func');
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print('User not detected');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User is not logged in.')),
      );
      return;
      // Exit if no user is logged in
    }

    // Create a new document reference in Firestore using the user's UID
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('doctors').doc(currentUser.uid);
    print('Doc reference made');
    // Add or update the doctor's data in Firestore
    await docRef.set({
      'id': currentUser.uid, // Store the user ID
      'first_name': _firstNameController.text,
      'middle_name': _middleNameController.text,
      'last_name': _lastNameController.text,
      'address': _clinicAddressController.text,
      'phone': _clinicPhoneController.text,
      'gender': _gender,
      'specialization': _isSpecializationSelected
          ? _selectedSpecialization
          : _mbbsSpecializations[0],
      'description': _descriptionController.text,
    });
    print('Profile has been updated successfully');
    // Optionally, show a success message after saving the profile
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Doctor Profile'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 107, 170, 181),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : null,
                    child: _profileImage == null
                        ? const Icon(Icons.camera_alt, size: 50, color: Colors.grey)
                        : null,
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  onTap: () {
                    setState(() {
                      _isSpecializationSelected = true;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 107, 170, 181),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 107, 170, 181),
                      ),
                    ),
                    prefixIcon: Icon(Icons.person,
                        color: Color.fromARGB(255, 107, 170, 181)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 107, 170, 181),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 107, 170, 181),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'First Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _middleNameController,
                  decoration: const InputDecoration(
                    labelText: 'Middle Name (Optional)',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 107, 170, 181),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 107, 170, 181),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 107, 170, 181),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 107, 170, 181),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (_firstNameController.text.isEmpty) {
                      return 'Please enter First Name before Last Name';
                    }
                    if (value == null || value.isEmpty) {
                      return 'Last Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _clinicAddressController,
                  decoration: const InputDecoration(
                    labelText: 'Clinic Address',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 107, 170, 181),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 107, 170, 181),
                      ),
                    ),
                    prefixIcon: Icon(Icons.home,
                        color: Color.fromARGB(255, 107, 170, 181)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Clinic Address is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _clinicPhoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Clinic Phone',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 107, 170, 181),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 107, 170, 181),
                      ),
                    ),
                    prefixIcon: Icon(Icons.phone,
                        color: Color.fromARGB(255, 107, 170, 181)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Clinic Phone is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Gender:',
                      style: TextStyle(
                        color: Color.fromARGB(255, 107, 170, 181),
                      ),
                    ),
                    Radio(
                      value: 'Male',
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value.toString();
                        });
                      },
                    ),
                    const Text('Male',
                        style: TextStyle(
                          color: Color.fromARGB(255, 107, 170, 181),
                        )),
                    Radio(
                      value: 'Female',
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value.toString();
                        });
                      },
                    ),
                    const Text('Female',
                        style: TextStyle(
                          color: Color.fromARGB(255, 107, 170, 181),
                        )),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Qualification:',
                        style: TextStyle(
                          color: Color.fromARGB(255, 107, 170, 181),
                        )),
                    ToggleButtons(
                      isSelected: [
                        !_isSpecializationSelected,
                        _isSpecializationSelected
                      ],
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('MBBS'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Postgraduate/Specialization'),
                        ),
                      ],
                      onPressed: (int index) {
                        setState(() {
                          _isSpecializationSelected = index == 1;
                          _selectedSpecialization =
                              null; // Reset specialization selection
                        });
                      },
                    ),
                  ],
                ),
                if (_isSpecializationSelected) ...[
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 107, 170, 181),
                        ),
                      ),
                    ),
                    value: _selectedSpecialization,
                    items: _postgraduateSpecializations
                        .map((specialization) => DropdownMenuItem<String>(
                              value: specialization,
                              child: Text(specialization),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSpecialization = value;
                      });
                    },
                    hint: const Text(
                      'Select Specialization',
                      style: TextStyle(
                        color: Color.fromARGB(255, 107, 170, 181),
                      ),
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 107, 170, 181),
                        ),
                      ),
                    ),
                    value: _selectedSpecialization,
                    items: _mbbsSpecializations
                        .map((specialization) => DropdownMenuItem<String>(
                              value: specialization,
                              child: Text(specialization),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSpecialization = value;
                      });
                    },
                    hint: const Text(
                      'Select Specialization',
                      style: TextStyle(
                        color: Color.fromARGB(255, 107, 170, 181),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Short Description (Optional)',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 107, 170, 181),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 107, 170, 181),
                      ),
                    ),
                    prefixIcon: Icon(Icons.description,
                        color: Color.fromARGB(255, 107, 170, 181)),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Submit the form, perform profile update action
                      saveDoctorProfile();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 107, 170, 181),
                  ),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }*/
