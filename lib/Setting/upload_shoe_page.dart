import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'admin_page.dart';
import '../connectivity_checker.dart';

class UploadShoePage extends StatefulWidget {
  const UploadShoePage({super.key});

  @override
  _UploadShoePageState createState() => _UploadShoePageState();
}

class _UploadShoePageState extends State<UploadShoePage> {
  final _formKey = GlobalKey<FormState>();
  final _brandController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageURLController = TextEditingController();
  final _modelURLController = TextEditingController();
  final _shoeNameController = TextEditingController();
  final _typeController = TextEditingController();

  void _submitShoeInformation() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('pendingApprovalShoe').add({
          'brand': _brandController.text,
          'description': _descriptionController.text,
          'imageURL': _imageURLController.text,
          'modelURL': _modelURLController.text,
          'shoeName': _shoeNameController.text,
          'type': _typeController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });
        _showConfirmationDialog();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send shoe information: $e')),
        );
      }
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Your shoe is now pending for approval.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AdminPage()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _brandController.dispose();
    _descriptionController.dispose();
    _imageURLController.dispose();
    _modelURLController.dispose();
    _shoeNameController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityChecker(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Upload Shoe Information'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _brandController,
                    decoration: const InputDecoration(labelText: 'Brand'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a brand';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _imageURLController,
                    decoration: const InputDecoration(labelText: 'Image URL'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an image URL';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _modelURLController,
                    decoration: const InputDecoration(labelText: 'Model URL'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a model URL';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _shoeNameController,
                    decoration: const InputDecoration(labelText: 'Shoe Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a shoe name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _typeController,
                    decoration: const InputDecoration(labelText: 'Type'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a type';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: _submitShoeInformation,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
