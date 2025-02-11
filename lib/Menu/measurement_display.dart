import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home_page.dart';
import '../Utils/loading.dart';
import '../connectivity_checker.dart';

class MeasurementDisplayPage extends StatefulWidget {
  final double cm;

  const MeasurementDisplayPage({
    Key? key,
    required this.cm,
  }) : super(key: key);

  @override
  _MeasurementDisplayPageState createState() => _MeasurementDisplayPageState();
}

class _MeasurementDisplayPageState extends State<MeasurementDisplayPage> {
  @override
  void initState() {
    super.initState();
    _saveMeasurement();
  }

  Future<void> _saveMeasurement() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoadingScreen(
          onComplete: () async {
            try {
              final userId = FirebaseAuth.instance.currentUser?.uid;
              if (userId != null) {
                CollectionReference measurements =
                    FirebaseFirestore.instance.collection('FootMeasurements');

                await measurements.add({
                  'userID': userId,
                  'centimeter': widget.cm,
                  'timestamp': FieldValue.serverTimestamp(),
                });

                if (mounted) {
                  Navigator.pop(context);
                  setState(() {});
                }
              } else {
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No user is logged in.')),
                  );
                }
              }
            } catch (e) {
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error saving measurement: $e')),
                );
              }
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityChecker(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Foot Measurement",
            style: TextStyle(fontSize: 18.sp),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Center(
                child: Text(
                  'Your foot measurement has been saved successfully.\n'
                  'Please go to your profile to see your sizing recommendation.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Merriweather',
                    fontSize: 18.sp,
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
