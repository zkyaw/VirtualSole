import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'profile.dart';
import 'foot_measurement_converter.dart';

class SizingRecommendationPage extends StatelessWidget {
  const SizingRecommendationPage({super.key});

  Future<Map<String, dynamic>> _fetchFootMeasurement() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot measurementSnapshot = await FirebaseFirestore.instance
          .collection('FootMeasurements')
          .where('userID', isEqualTo: user.uid)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();
      if (measurementSnapshot.docs.isNotEmpty) {
        return measurementSnapshot.docs.first.data() as Map<String, dynamic>;
      }
    }
    return {};
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userDoc.data() as Map<String, dynamic>;
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sizing Recommendation",
          style: TextStyle(fontSize: 18.sp),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfilePage(),
              ),
            );
          },
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: Future.wait([_fetchUserData(), _fetchFootMeasurement()]).then(
          (results) => {'user': results[0], 'measurement': results[1]},
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data!['measurement'].isEmpty) {
            return const Center(child: Text('No foot measurement data found.'));
          }

          final userData = snapshot.data!['user'];
          final footMeasurement = snapshot.data!['measurement'];
          final cm = footMeasurement['centimeter'] as double;
          final gender = userData['gender'] ?? 'other';

          final sizeRecommendation = getShoeSizeRecommendation(cm, gender);

          return Padding(
            padding: EdgeInsets.all(16.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gender: $gender',
                  style: TextStyle(
                    fontFamily: 'Merriweather',
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Initial Shoe Size:',
                  style: TextStyle(
                    fontFamily: 'Merriweather',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'US Size: ${sizeRecommendation['initialSize']['US']}',
                  style: TextStyle(fontSize: 18.sp),
                ),
                Text(
                  'UK Size: ${sizeRecommendation['initialSize']['UK']}',
                  style: TextStyle(fontSize: 18.sp),
                ),
                Text(
                  'EU Size: ${sizeRecommendation['initialSize']['EU']}',
                  style: TextStyle(fontSize: 18.sp),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Comfortable Shoe Size (0.5 cm allowance):',
                  style: TextStyle(
                    fontFamily: 'Merriweather',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'US Size: ${sizeRecommendation['comfortableSize05']['US']}',
                  style: TextStyle(fontSize: 18.sp),
                ),
                Text(
                  'UK Size: ${sizeRecommendation['comfortableSize05']['UK']}',
                  style: TextStyle(fontSize: 18.sp),
                ),
                Text(
                  'EU Size: ${sizeRecommendation['comfortableSize05']['EU']}',
                  style: TextStyle(fontSize: 18.sp),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Comfortable Shoe Size (1 cm allowance):',
                  style: TextStyle(
                    fontFamily: 'Merriweather',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'US Size: ${sizeRecommendation['comfortableSize1']['US']}',
                  style: TextStyle(fontSize: 18.sp),
                ),
                Text(
                  'UK Size: ${sizeRecommendation['comfortableSize1']['UK']}',
                  style: TextStyle(fontSize: 18.sp),
                ),
                Text(
                  'EU Size: ${sizeRecommendation['comfortableSize1']['EU']}',
                  style: TextStyle(fontSize: 18.sp),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
