import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PDFViewerScreen extends StatefulWidget {
  final String url; // URL of the PDF file

  const PDFViewerScreen({Key? key, required this.url}) : super(key: key);

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  String? _localFilePath;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print('PDF URL: ${widget.url}'); // Print the URL of the file
    _downloadPDF();
  }

  Future<void> _downloadPDF() async {
    try {
      print('Entered the function');
      // Get the temporary directory
      final Directory tempDir = await getTemporaryDirectory();
      print('Temporary directory obtained: ${tempDir.path}'); // Debug statement

      // Construct the local file path
      final String tempPath = tempDir.path;
      _localFilePath = '$tempPath/temp.pdf';
      print('Local file path set to: $_localFilePath'); // Debug statement

      print('Starting download from: ${widget.url}'); // Debug statement
      final Dio dio = Dio();

      // Download the PDF file
      await dio.download(widget.url, _localFilePath);
      print(
          'Download completed, file saved to: $_localFilePath'); // Debug statement

      setState(() {
        _isLoading = false; // Stop loading indicator
        print('Set loading to false'); // Debug statement
      });
    } catch (e) {
      print('Error downloading PDF: $e'); // Error handling debug statement
      setState(() {
        _isLoading = false; // Stop loading if there's an error
        _localFilePath = null; // Reset the file path on error
        print('Reset local file path due to error'); // Debug statement
      });

      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Text('PDF Viewer', style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: Colors.black87,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _localFilePath != null
              ? PDFView(
                  filePath: _localFilePath,
                  enableSwipe: true,
                  swipeHorizontal: true,
                  autoSpacing: true,
                  pageFling: true,
                  onError: (e) {
                    print('Error loading PDF: $e');
                  },
                  onPageChanged: (int? page, int? total) {
                    print('Page $page of $total');
                  },
                )
              : Center(child: Text('No PDF file found')),
    );
  }
}
