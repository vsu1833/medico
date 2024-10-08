import 'package:firebase_storage/firebase_storage.dart';
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
import 'package:path/path.dart' as path;

class ProfileUpdateApp extends StatelessWidget {
  //DO NOT TOUCH
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
  //DO NOT TOUCH
  final _formKey = GlobalKey<FormState>();
  String? uid;
  String? email;
  File? _imageFile;
  String? _imageUrl;

  String? _bloodGroup;

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
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();

  DateTime? _selectedDate;
  String _gender = 'Male';
  bool _showNameFields = false;
  bool _showAddressFields = false;

  @override
  void initState() {
    super.initState();
    fetchUserDetails(); // Fetch UID and email when the page is initialized
  }


  Future<void> _pickImage() async {
    //DO NOT TOUCH
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }


  Future<void> uploadImage() async {
    if (_imageFile == null) {
      print('No image selected for upload.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image first.')),
      );
      return;
    }

    try {
      // Get the file extension (jpg, jpeg, png)
      String fileExtension =
          path.extension(_imageFile!.path); // Extracts the extension

      // Check if the selected file is in supported formats
      if (fileExtension != '.jpg' ||
          fileExtension != '.jpeg' ||
          fileExtension != '.png') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Unsupported file format. Please select a JPG, JPEG, or PNG image.')),
        );
        return;
      }

      // Create a unique file name using the current timestamp and the file extension
      String fileName =
          'profile_${DateTime.now().millisecondsSinceEpoch}$fileExtension';

      // Reference to Firebase Storage
      Reference storageRef =
          FirebaseStorage.instance.ref().child('profile_pictures/$fileName');

      // Upload the file
      UploadTask uploadTask = storageRef.putFile(_imageFile!);
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL after the upload completes
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Print the download URL for debugging
      print('Image uploaded successfully. Download URL: $downloadUrl');

      // Set the _imageUrl state with the retrieved URL
      setState(() {
        _imageUrl = downloadUrl; // Storing the download URL in _imageUrl
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image uploaded successfully!')),
      );
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image.')),
      );
    }
  }

  /*Future<void> _uploadImage(File imageFile) async {
    try {
      // Get the file name
      String fileName = path.basename(imageFile.path);

      // Reference to Firebase Storage
      Reference ref =
          FirebaseStorage.instance.ref().child('profile_pictures/$fileName');

      // Upload the file
      UploadTask uploadTask = ref.putFile(imageFile);

      // Get the download URL
      TaskSnapshot snapshot = await uploadTask;
      _imageUrl = await snapshot.ref.getDownloadURL(); // Consistent naming

      print('Image uploaded successfully: $_imageUrl');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }*/

  /*Future<void> _uploadImage() async {                                          //SOMETHING WORNG
    if (_imageFile == null) {
      print('No image selected for upload.');
      return;
    }

    try {
      // Use path.basename to get the file name
      String fileName = path.basename(_imageFile!.path);

      // Reference to Firebase Storage
      Reference ref =
          FirebaseStorage.instance.ref().child('profile_pictures/$fileName');

      // Upload the file to Firebase Storage
      await ref.putFile(_imageFile!);

      // Get the download URL and assign it to imageUrl
      _imageUrl = await ref.getDownloadURL();

      setState(() {
      _imageUrl = _imageUrl;  // Ensure _imageUrl is correctly updated
    });

      print('Image uploaded successfully. URL: $_imageUrl');

      await FirebaseFirestore.instance.collection('patients').doc(uid).update({
        'profilePicUrl': _imageUrl,
      });
      print('Image URL saved to Firestore.');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }*/

  // Function to upload the image to Firebase Storage and get the download URL
  /*Future<String?> _uploadImage(File imageFile) async {
    try {
      String fileName = Path.basename(_imageFile!.path);
      Reference storageRef =
          FirebaseStorage.instance.ref().child('profile_pics/$fileName');

      // Upload the image file
      await storageRef.putFile(imageFile);

      // Get the download URL
      String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }*/

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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User is not logged in.')),
      );
    }
  }

  

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
    //SOMETHING WRONG (POSSIBLY)
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

    // Check if the image URL has been set
    /*if (_imageUrl == null) {
    print('No image URL found. Make sure the image is uploaded.');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please upload an image first.')),
    );
    return;
  }*/

    /*if (_imageFile != null) {
      await _uploadImage(_imageFile!); // Uploads and sets _imageUrl
    }*/

    // Check if the image has been uploaded and the URL is available
    if (_imageUrl == null || _imageUrl!.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please upload an image first.')),
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
      'profile_image_url': _imageUrl,
      'bloodgrp': _bloodGroup,
      'height': _heightController.text,
      'weight': _weightController.text,
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to save patient profile.')),
    );
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 30),
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 56,
                        backgroundColor:
                            const Color.fromARGB(255, 107, 170, 181),
                        child: _imageFile == null
                            ? CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage('assets/doc1.jpg'),
                              )
                            : CircleAvatar(
                                radius: 50,
                                backgroundImage: FileImage(_imageFile!),
                              ),
                      ),
                    ),
                  ),
                  /*SizedBox(height: 20),
ElevatedButton(
  onPressed: _uploadImage,  // Trigger the upload function on press
  child: Text('Upload Image'),
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 107, 170, 181),
  ),
),*/
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
                    SizedBox(height: 20),
                    // Dropdown for Blood Group
                    DropdownButtonFormField<String>(
                      value:
                          _bloodGroup, // Initialize this variable in your state
                      decoration: InputDecoration(
                        labelText: 'Blood Group',
                        labelStyle: TextStyle(
                          color: const Color.fromARGB(255, 107, 170, 181),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 107, 170, 181),
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.bloodtype,
                          color: const Color.fromARGB(255, 107, 170, 181),
                        ),
                      ),
                      items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _bloodGroup = newValue!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Blood group is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

// Height field with validation
                    TextFormField(
                      controller: _heightController, // Initialize in your state
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Height (cm)',
                        labelStyle: TextStyle(
                          color: const Color.fromARGB(255, 107, 170, 181),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 107, 170, 181),
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.height,
                          color: const Color.fromARGB(255, 107, 170, 181),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Height is required';
                        }
                        final height = double.tryParse(value);
                        if (height == null || height < 50 || height > 250) {
                          return 'Please enter a valid height between 50 and 250 cm';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

// Weight field with validation
                    TextFormField(
                      controller: _weightController, // Initialize in your state
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Weight (kg)',
                        labelStyle: TextStyle(
                          color: const Color.fromARGB(255, 107, 170, 181),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 107, 170, 181),
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.fitness_center,
                          color: const Color.fromARGB(255, 107, 170, 181),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Weight is required';
                        }
                        final weight = double.tryParse(value);
                        if (weight == null || weight < 10 || weight > 300) {
                          return 'Please enter a valid weight between 10 and 300 kg';
                        }
                        return null;
                      },
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


