import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// To handle the file object
// To pick image from gallery/camera
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/pages/main_screen.dart';
import 'package:path/path.dart' as path;

class ProfileUpdateApp extends StatelessWidget {

  //DO NOT TOUCH

  const ProfileUpdateApp({super.key});


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Patient Profile Updation',
      home: ProfileUpdatePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProfileUpdatePage extends StatefulWidget {
  const ProfileUpdatePage({super.key});

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
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _bloodGroup;

  final TextEditingController _nameController = TextEditingController();
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
    fetchPatientDetails();
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
        print('Chalo img toh select ho gaya');
        await _uploadImage();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No image selected.')),
        );
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No img selected for upload.')),
      );
      print('No image selected for upload.');
      return;
    }

    try {
      // Upload the file to Firebase Storage
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = _storage.ref().child('uploads/$fileName');
      UploadTask uploadTask = storageRef.putFile(_imageFile!);

      // Wait until the upload is complete
      TaskSnapshot snapshot = await uploadTask;

      // Get the image URL
      String imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        _imageUrl = imageUrl;
      });
      print('Image URL: $imageUrl');

      // Store the image URL in Firestore
      await _firestore.collection('images').add({
        'imageUrl': imageUrl,
        'uploadedAt': Timestamp.now(),
      });

      print('Image uploaded and URL stored in Firestore');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  /*Future<void> uploadImage() async {
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
  }*/

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

  Future<void> fetchPatientDetails() async {
    //DO NOT TOUCH
    // Get the current logged-in user from Firebase Authentication
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Extract UID and email
      setState(() {
        uid = currentUser.uid;
        email = currentUser.email;
      });
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('patients')
          .doc(uid)
          .get();
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        _nameController.text =
            '${data['first_name'] ?? ''} ${data['middle_name'] ?? ''} ${data['last_name'] ?? ''}';
        _lastNameController.text = data['last_name'] ?? '';
        _middleNameController.text = data['middle_name'] ?? '';
        _firstNameController.text = data['first_name'] ?? '';

        _houseNoController.text = data['house_no'] ?? '';
        _cityController.text = data['city'] ?? '';
        _pincodeController.text = data['pincode']?.toString() ?? '';
        _phoneController.text = data['phone'] ?? '';
        _gender = data['gender'] ?? 'Male';
        _heightController = data['height'] ?? '';
        _weightController = data['weight'] ?? '';
        _bloodGroup = data['bloodgrp'];
        _selectedDate = data['dob'];

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
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 50),
              SizedBox(height: 16),
              Text('Information has been Updated Successfully'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
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
        const SnackBar(content: Text('User is not logged in.')),
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
    if (_imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload an image first.')),
      );
      print('Img hi nahi hai tum kya karega bhaiya??');
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
        title: const Text('Patient Profile'),
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
                const SizedBox(height: 30),
                Center(

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: _pickImage, // Tap triggers image picking
                        child: Container(
                          width: 112, // 2 * 56 (Outer Radius)
                          height: 112,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color.fromARGB(
                                  255, 107, 170, 181), // Border Color
                              width: 6.0, // Border Width
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 50, // Inner Circle Radius
                            backgroundImage: _imageFile == null
                                ? AssetImage('assets/doc1.jpg') as ImageProvider
                                : FileImage(_imageFile!), // Profile Image Logic
                          ),
                        ),

                      ),
                    ],
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
                      color: Color.fromARGB(255, 107, 170, 181),
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 32),
                TextFormField(
                  initialValue: '$email', // Replace with the actual email.
                  readOnly: true,
                  decoration: const InputDecoration(
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
                        color: Color.fromARGB(255, 107, 170, 181)),
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                if (!_showNameFields)
                  TextFormField(
                    onTap: () {
                      setState(() {
                        _showNameFields = true;
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
                if (_showNameFields) ...[
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
                      prefixIcon: Icon(Icons.person,
                          color: Color.fromARGB(255, 107, 170, 181)),
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
                      prefixIcon: Icon(Icons.person_outline,
                          color: Color.fromARGB(255, 107, 170, 181)),
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
                      prefixIcon: Icon(Icons.person,
                          color: Color.fromARGB(255, 107, 170, 181)),
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
                const SizedBox(height: 20),
                TextFormField(
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 107, 170, 181),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 107, 170, 181),
                      ),
                    ),
                    prefixIcon: Icon(Icons.cake,
                        color: Color.fromARGB(255, 107, 170, 181)),
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Gender:',
                        style: TextStyle(
                          color: Color.fromARGB(255, 107, 170, 181),
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
                if (!_showAddressFields)
                  TextFormField(
                    onTap: () {
                      setState(() {
                        _showAddressFields = true;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Address',
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
                        return 'Address is required';
                      }
                      return null;
                    },
                  ),
                if (_showAddressFields) ...[
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _houseNoController,
                    decoration: const InputDecoration(
                      labelText: 'Line-1: House No., StreetName',
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 107, 170, 181),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 107, 170, 181),
                        ),
                      ),
                      prefixIcon: Icon(Icons.home_outlined,
                          color: Color.fromARGB(255, 107, 170, 181)),
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
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'Line-2: City/District, State',
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
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _pincodeController,
                    decoration: const InputDecoration(
                      labelText: 'Pincode',
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 107, 170, 181),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 107, 170, 181),
                        ),
                      ),
                      prefixIcon: Icon(Icons.location_on,
                          color: Color.fromARGB(255, 107, 170, 181)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pincode is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 107, 170, 181),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 107, 170, 181),
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Color.fromARGB(255, 107, 170, 181),
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          savePatientProfile();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 107, 170, 181),
                      ),
                      child: const Text('Save'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      child: const Text('Cancel'),
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
