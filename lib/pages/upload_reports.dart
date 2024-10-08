import 'package:flutter/material.dart';
import 'package:login/components/black_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:login/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:login/pages/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healthcare App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UploadReports(),
    );
  }
}

class UploadReports extends StatefulWidget {
  const UploadReports({Key? key}) : super(key: key);

  @override
  _UploadReportsState createState() => _UploadReportsState();
}

class _UploadReportsState extends State<UploadReports> {
  final _formKey = GlobalKey<FormState>();
  String? selectedReportType;
  TextEditingController reportNameController = TextEditingController();
  DateTime? selectedDate;
  TextEditingController testResultController = TextEditingController();
  String? reportFilePath;

  Future<void> _pickAndUploadFile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in')),
      );
      return;
    }
    String uid = user.uid;

    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      String fileName = "${DateTime.now().millisecondsSinceEpoch}.pdf";
      Reference storageRef =
          FirebaseStorage.instance.ref().child('reports').child(fileName);

      // Metadata including content type and custom key-value pairs
      SettableMetadata metadata = SettableMetadata(
        contentType: 'application/pdf',
        customMetadata: {
          'uid': uid,
          'reportType': selectedReportType ?? "Other",
          'reportName': selectedReportType == "Any Other"
              ? reportNameController.text
              : selectedReportType!,
          'reportDate':
              selectedDate != null ? selectedDate!.toIso8601String() : '',
          'testResult': testResultController.text,
        },
      );

      try {
        if (kIsWeb) {
          Uint8List? fileBytes = result.files.single.bytes;
          if (fileBytes != null) {
            // Upload file with metadata
            await storageRef.putData(fileBytes, metadata);
          }
        } else {
          String? filePath = result.files.single.path;
          if (filePath != null) {
            File file = File(filePath);
            // Upload file with metadata
            await storageRef.putFile(file, metadata);
          }
        }

        // Obtain the download URL
        String downloadUrl = await storageRef.getDownloadURL();

        // Save to Firestore as before
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('reports')
            .add({
          'reportType': selectedReportType ?? "Other",
          'reportName': selectedReportType == "Any Other"
              ? reportNameController.text
              : selectedReportType!,
          'reportDate': selectedDate,
          'testResult': testResultController.text,
          'fileUrl': downloadUrl,
          'uploadedAt': Timestamp.now(),
        });

        setState(() {
          reportFilePath = downloadUrl;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('File uploaded and metadata added successfully!')),
        );
      } catch (e) {
        print("Error uploading file or saving details: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload file or save metadata')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No file selected')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Reports"),
        backgroundColor: Color.fromARGB(255, 3, 131, 170),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Select Report Type',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Report Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                value: selectedReportType,
                items: const [
                  DropdownMenuItem(
                    value: 'Blood Pressure',
                    child: Text('Blood Pressure'),
                  ),
                  DropdownMenuItem(
                    value: 'Blood Sugar',
                    child: Text('Blood Sugar'),
                  ),
                  DropdownMenuItem(
                    value: 'TSH',
                    child: Text('TSH'),
                  ),
                  DropdownMenuItem(
                    value: 'Hemoglobin',
                    child: Text('Hemoglobin'),
                  ),
                  DropdownMenuItem(
                    value: 'Any Other',
                    child: Text('Any Other'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedReportType = value;
                  });
                },
              ),
              const SizedBox(height: 40),
              if (selectedReportType == 'Any Other')
                Text(
                  'Enter Report Name ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (selectedReportType == 'Any Other') const SizedBox(height: 10),
              if (selectedReportType == 'Any Other')
                TextFormField(
                  controller: reportNameController,
                  decoration: InputDecoration(
                    labelText: 'Enter Report Name (if Any Other)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              if (selectedReportType == 'Any Other') const SizedBox(height: 40),
              Text(
                'Enter Report Date ',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Test Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                controller: TextEditingController(
                  text: selectedDate == null
                      ? ''
                      : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Enter Test Result ',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: testResultController,
                decoration: InputDecoration(
                  labelText: 'Test Result',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.upload_file,
                  color: Colors.white,
                ),
                label: const Text(
                  "Upload Report PDF",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _pickAndUploadFile,
              ),
              const SizedBox(height: 40),
              MyBlackButton(
                onTap: () {
                  // Show the AlertDialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Success'),
                        content: const Text('Report Uploaded Successfully'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomeScreen()), // Replace MyApp with your home widget if needed
                              );
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                buttonname: "Submit",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
