import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:login/firebase_options.dart';
import 'package:firebase_storage/firebase_storage.dart';


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
  String? uid;
  String? email;
  String? _imageUrl;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _clinicAddressController =
      TextEditingController();
  final TextEditingController _clinicPhoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _minConsultFeeController =
      TextEditingController();

  String _gender = 'Male';
  bool _isSpecializationSelected = false;
  String? _selectedSpecialization;
  File? _profileImage;
  bool _showNameFields = false;

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

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
    await _uploadImage();
  }

  Future<void> _uploadImage() async {
    if (_profileImage == null) return;

    try {
      // Get the current user's UID
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in.')),
        );
        return;
      }

      // Create a reference to the storage path for this user's profile image
      String imagePath = 'doctor_profiles/${currentUser.uid}/profile_image.jpg';
      Reference storageRef = _storage.ref().child(imagePath);

      // Upload the file to Firebase Storage
      await storageRef.putFile(_profileImage!);

      // Get the download URL of the uploaded image
      _imageUrl = await storageRef.getDownloadURL();
      print('Image uploaded successfully: $_imageUrl');
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image. Please try again.')),
      );
    }
  }

  Future<void> fetchUserDetails() async {
    //DO NOT TOUCH
    // Get the current logged-in user from Firebase Authentication
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Extract UID and email
      setState(() {
        uid = currentUser.uid;
        email = currentUser.email;
      });
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('doctors').doc(uid).get();
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        _nameController.text =
            '${data['first_name'] ?? ''} ${data['middle_name'] ?? ''} ${data['last_name'] ?? ''}';
        _lastNameController.text = data['last_name'] ?? '';
        _middleNameController.text = data['middle_name'] ?? '';
        _firstNameController.text = data['first_name'] ?? '';

        _clinicAddressController.text = data['address'] ?? '';
        _clinicPhoneController.text = data['phone'] ?? '';
        _minConsultFeeController.text =
            data['consultationfee']?.toString() ?? '';
        _descriptionController.text = data['description'] ?? '';
        _gender = data['gender'] ?? 'Male';
        _isSpecializationSelected = data['isSpecializationSelected'] ?? false;
        _selectedSpecialization = data['specialization'] ?? '';

        setState(() {});
      }
      print('ID fetched successfully $uid');
      print('email fteched successfully $email');
      print('img fetched successfully $_imageUrl');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User is not logged in.')),
      );
    }
  }

  void showSuccessDialog() {
    //FUNC RIGHT BUT NOT WORKING DUE TO DEPENDABILITY
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 50),
              SizedBox(height: 16),
              Text('Hey Doc! Your Information has been Updated Successfully'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> saveDoctorProfile() async {
    // Get the current user's ID
    print('Entered the func');
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print('Doctor not detected');

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(content: Text('Doctor is not logged in.')),

      );
      return;
      // Exit if no user is logged in
    }

    // Create a new document reference in Firestore using the user's UID
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('doctors').doc(currentUser.uid);
    print('Doc reference made');

    // Check if the image has been uploaded and the URL is available
    if (_imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload an image first.')),
      );
      print('Img hi nahi hai tum kya karega bhaiya??');
      return;
    }
    // Add or update the doctor's data in Firestore
    await docRef.set({
      'id': currentUser.uid, // Store the user ID
      'email': currentUser.email,
      'name': _firstNameController.text +
          ' ' +
          _middleNameController.text +
          ' ' +
          _lastNameController.text,
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
      'profile_image_url': _imageUrl,
      'consultationfee': _minConsultFeeController.text,
    });
    print('   Doctor Profile has been updated successfully');

    // Show a success message after saving the profile
    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(content: Text('Your profile has been updated successfully!')),

    );
    showSuccessDialog();

    /*ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to save doctor profile.')),
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Doctor Profile'),
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

                        : AssetImage('assets/doc1.jpg') as ImageProvider,
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(onTap: () {
                  setState(() {
                    _isSpecializationSelected = true;
                  });
                }),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'Patient ID: $uid',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 107, 170, 181),
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 32),
                TextFormField(
                  initialValue: '$email', // Replace with the actual email.
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Email',

                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 107, 170, 181),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 107, 170, 181),
                      ),
                    ),

                    prefixIcon: Icon(Icons.email,
                        color: const Color.fromARGB(255, 107, 170, 181)),

                  ),
                ),

                SizedBox(height: 20),
                if (!_showNameFields)
                  TextFormField(
                    onTap: () {
                      setState(() {
                        _showNameFields = true;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(
                        color: const Color.fromARGB(255, 107, 170, 181),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 107, 170, 181),
                        ),
                      ),
                      prefixIcon: Icon(Icons.person,
                          color: const Color.fromARGB(255, 107, 170, 181)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                if (_showNameFields) ...[
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      labelStyle: TextStyle(
                        color: const Color.fromARGB(255, 107, 170, 181),

                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 107, 170, 181),
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

                  SizedBox(height: 10),
                  TextFormField(
                    controller: _middleNameController,
                    decoration: InputDecoration(
                      labelText: 'Middle Name (Optional)',
                      labelStyle: TextStyle(
                        color: const Color.fromARGB(255, 107, 170, 181),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 107, 170, 181),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      labelStyle: TextStyle(
                        color: const Color.fromARGB(255, 107, 170, 181),

                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 107, 170, 181),
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

                ],
                SizedBox(height: 20),
                TextFormField(
                  controller: _clinicAddressController,
                  decoration: InputDecoration(
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
                        color: const Color.fromARGB(255, 107, 170, 181)),
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
                  decoration: InputDecoration(
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
                        color: const Color.fromARGB(255, 107, 170, 181)),

                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Clinic Phone is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _minConsultFeeController,
                  keyboardType: TextInputType.phone,

                  decoration: InputDecoration(
                    labelText:
                        'Consultation Fee: enter a minimum consultation fee',

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
                      return 'Kindly specify basic consultation fee';
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
  }
}
