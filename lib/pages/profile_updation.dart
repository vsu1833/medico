import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io'; // To handle the file object
import 'package:image_picker/image_picker.dart'; // To pick image from gallery/camera
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:login/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/pages/main_screen.dart';
class ProfileUpdateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient Profile Updation',
      home: ProfileUpdatePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProfileUpdatePage extends StatefulWidget {
  @override
  _ProfileUpdatePageState createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _houseNoController = TextEditingController();
  final TextEditingController _streetNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  DateTime? _selectedDate;
  String _gender = 'Male';
  bool _showNameFields = false;
  bool _showAddressFields = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 50),
              SizedBox(height: 16),
              Text('Information has been Updated Successfully'),
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

  Future<void> savePatientProfile() async {
    // Get the current user's ID
    print('Entered the  patient function');
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      print('patient not detected');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User is not logged in.')),
      );
      return;
    }

    // Create a new document reference in Firestore using the user's UID
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('patients').doc(currentUser.uid);
    print('Doc reference made');

    // Add or update the patient's data in Firestore
    await docRef.set({
      'id': currentUser.uid, // Store the user ID
      'first_name': _firstNameController.text,
      'middle_name': _middleNameController.text,
      'last_name': _lastNameController.text,
      'address': {
        'house_no': _houseNoController.text,
        'street': _streetNameController.text,
        'city': _cityController.text,
        'district': _districtController.text,
        'state': _stateController.text,
        'pincode': _pincodeController.text,
      },
      'phone': _phoneController.text,
      'gender': _gender,
      'dob': _selectedDate != null
          ? _selectedDate!.toIso8601String()
          : null, // Store DOB if selected
    });

    print(' Patient Profile has been updated successfully');

    // Show a success message after saving the profile
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile updated successfully!')),
    );
    showSuccessDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Patient Profile'),
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
                SizedBox(height: 30),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Handle view/change profile picture
                    },
                    child: CircleAvatar(
                      radius: 56,
                      backgroundColor: const Color.fromARGB(255, 107, 170, 181),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/doc1.jpg'),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'Patient ID: name@xyz',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 107, 170, 181),
                      fontSize: 16,
                    ),
                  ),
                ),
                TextFormField(
                  initialValue:
                      'user@example.com', // Replace with the actual email.
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: const Color.fromARGB(255, 107, 170, 181),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 107, 170, 181),
                      ),
                    ),
                    prefixIcon: Icon(Icons.email,
                        color: const Color.fromARGB(255, 107, 170, 181)),
                  ),
                ),
                SizedBox(height: 20),
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
                      prefixIcon: Icon(Icons.person,
                          color: const Color.fromARGB(255, 107, 170, 181)),
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
                      prefixIcon: Icon(Icons.person_outline,
                          color: const Color.fromARGB(255, 107, 170, 181)),
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
                      prefixIcon: Icon(Icons.person,
                          color: const Color.fromARGB(255, 107, 170, 181)),
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
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    labelStyle: TextStyle(
                      color: const Color.fromARGB(255, 107, 170, 181),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 107, 170, 181),
                      ),
                    ),
                    prefixIcon: Icon(Icons.cake,
                        color: const Color.fromARGB(255, 107, 170, 181)),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text: _selectedDate == null
                        ? ''
                        : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Date of Birth is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Gender:',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 107, 170, 181),
                        )),
                    Radio(
                      value: 'Male',
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value.toString();
                        });
                      },
                    ),
                    Text('Male',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 107, 170, 181),
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
                    Text('Female',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 107, 170, 181),
                        )),
                  ],
                ),
                SizedBox(height: 20),
                if (!_showAddressFields)
                  TextFormField(
                    onTap: () {
                      setState(() {
                        _showAddressFields = true;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Address',
                      labelStyle: TextStyle(
                        color: const Color.fromARGB(255, 107, 170, 181),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 107, 170, 181),
                        ),
                      ),
                      prefixIcon: Icon(Icons.home,
                          color: const Color.fromARGB(255, 107, 170, 181)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Address is required';
                      }
                      return null;
                    },
                  ),
                if (_showAddressFields) ...[
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _houseNoController,
                    decoration: InputDecoration(
                      labelText: 'Line-1: House No., StreetName',
                      labelStyle: TextStyle(
                        color: const Color.fromARGB(255, 107, 170, 181),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 107, 170, 181),
                        ),
                      ),
                      prefixIcon: Icon(Icons.home_outlined,
                          color: const Color.fromARGB(255, 107, 170, 181)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Line-1 is required';
                      }
                      return null;
                    },
                  ),
                  /*SizedBox(height: 10),
                  TextFormField(
                    controller: _streetNameController,
                    decoration: InputDecoration(
                      labelText: 'Street Name',
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
                        return 'Street Name is required';
                      }
                      return null;
                    },
                  ),*/
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      labelText: 'Line-2: City/District, State',
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
                        return 'Line-2 is required';
                      }
                      return null;
                    },
                  ),
                  /*SizedBox(height: 10),
                  TextFormField(
                    controller: _districtController,
                    decoration: InputDecoration(
                      labelText: 'District',
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
                        return 'District is required';
                      }
                      return null;
                    },
                  ),*/
                  /*SizedBox(height: 10),
                  TextFormField(
                    controller: _stateController,
                    decoration: InputDecoration(
                      labelText: 'State',
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
                        return 'State is required';
                      }
                      return null;
                    },
                  ),*/
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _pincodeController,
                    decoration: InputDecoration(
                      labelText: 'Pincode',
                      labelStyle: TextStyle(
                        color: const Color.fromARGB(255, 107, 170, 181),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 107, 170, 181),
                        ),
                      ),
                      prefixIcon: Icon(Icons.location_on,
                          color: const Color.fromARGB(255, 107, 170, 181)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pincode is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      labelStyle: TextStyle(
                        color: const Color.fromARGB(255, 107, 170, 181),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 107, 170, 181),
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.phone,
                        color: const Color.fromARGB(255, 107, 170, 181),
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          savePatientProfile();
                        }
                      },
                      child: Text('Save'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 107, 170, 181),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ),
                        );
                        
                      },
                      child: Text('Cancel'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
