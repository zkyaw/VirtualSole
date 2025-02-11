import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../connectivity_checker.dart';
import 'tutorial_virtual.dart';
import 'tutorial_measure.dart';

class TutorialPage extends StatelessWidget {
  const TutorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectivityChecker(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Tutorial Page',
            style: TextStyle(fontSize: 18.sp),
          ),
        ),
        body: Center(
          // Center the entire content
          child: Padding(
            padding: EdgeInsets.all(16.0.w),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Make the column as small as its content
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TutorialVirtualPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Virtual Try-On Tutorial',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TutorialMeasurePage(),
                      ),
                    );
                  },
                  child: Text(
                    'Foot Measurement Tutorial',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
