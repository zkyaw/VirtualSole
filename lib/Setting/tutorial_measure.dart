import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../connectivity_checker.dart';

class TutorialMeasurePage extends StatelessWidget {
  const TutorialMeasurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectivityChecker(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Foot Measurement Tutorial',
            style: TextStyle(
              fontFamily: 'Merriweather',
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Follow these steps for accurate foot measurement!',
                  style: TextStyle(
                    fontFamily: 'Merriweather',
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24.h),
              _buildStep(
                context,
                'Step 1: Prepare for Measurement',
                '1. Click the Ruler Icon to open the measurement feature.\n'
                    '2. Place your foot at the edge of an A4 paper, ensuring all edges are visible. Use a dark background (preferably black) for optimal results.\n'
                    '3. Align the box to the edges of the A4 paper. Note: Minor misalignment is acceptable.',
                [
                  'assets/m1.jpg',
                  'assets/m1.1.jpg',
                  'assets/m1.2.jpg',
                  'assets/m1.3.jpg'
                ],
              ),
              _buildStep(
                context,
                'Step 2: Capture and Save',
                '1. Click the Camera Icon to take a photo of your foot on the paper.\n'
                    '2. Wait for the process to complete, then click "Done" to return to the home page.',
                ['assets/m2.jpg'],
              ),
              _buildStep(
                context,
                'Step 3: Check Your Profile',
                '1. Go to Settings and click on "Profile".\n'
                    '2. Access your profile to view your saved measurement details.',
                ['assets/m3.jpg'],
              ),
              _buildStep(
                context,
                'Step 4: View Your Sizing Recommendation',
                '1. In your profile, click on "Sizing Recommendation".\n'
                    '2. Review your US, UK, and EU shoe sizes based on the measurements.',
                ['assets/m4.jpg'],
              ),
              SizedBox(height: 20.h),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA58056),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 32.w),
                    child: Text(
                      'Got it!',
                      style: TextStyle(
                        fontFamily: 'Merriweather',
                        fontSize: 18.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, String title, String description,
      List<String> imagePaths) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Merriweather',
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.brown[700],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            description,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 12.h),
          Column(
            children: imagePaths.map((path) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      path,
                      height: 200.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
