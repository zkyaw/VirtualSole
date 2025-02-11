import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TutorialVirtualPage extends StatelessWidget {
  const TutorialVirtualPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Virtual Try-On Tutorial',
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
                'Follow these steps to try shoes virtually!',
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
              'Step 1: Select a Shoe',
              'Click on a shoe from the recommendation or search results.',
              'assets/v1.jpg',
            ),
            _buildStep(
              context,
              'Step 2: Tap the Camera Icon',
              'Click on the camera icon at the bottom of the Shoe Details page.',
              'assets/v2.jpg',
            ),
            _buildStep(
              context,
              'Step 3: Point the Camera',
              'Point your camera at your feet to see how the shoes look on you!',
              'assets/v3.jpg',
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
    );
  }

  Widget _buildStep(BuildContext context, String title, String description,
      String imagePath) {
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
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                imagePath,
                height: 200.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
