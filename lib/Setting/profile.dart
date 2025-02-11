import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Menu/detail.dart';
import '../Menu/favourite.dart';
import '../connectivity_checker.dart';
import '../Setting/sizing_recommendation.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<Map<String, dynamic>> _fetchUserProfile() async {
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

  Future<List<Map<String, dynamic>>> _fetchRecentlyViewedShoes() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('recentlyViewed')
          .doc(user.uid)
          .collection('shoes')
          .orderBy('timestamp', descending: true)
          .limit(6)
          .get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return ConnectivityChecker(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: _fetchUserProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No profile data found.'));
            }

            final userProfile = snapshot.data!;
            return Padding(
              padding: EdgeInsets.all(16.0.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 50.r,
                      backgroundImage: const AssetImage('images/usericon.png'),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      userProfile['name'] ?? 'User',
                      style: TextStyle(
                        fontFamily: 'Merriweather',
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Gender: ${userProfile['gender'] ?? 'Not specified'}',
                      style: TextStyle(fontSize: 18.sp),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Date of Birth: ${userProfile['birthDate'] ?? 'Not specified'}',
                      style: TextStyle(fontSize: 18.sp),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FavouritePage(),
                          ),
                        );
                      },
                      child: const Text('Favourite Page'),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const SizingRecommendationPage(),
                          ),
                        );
                      },
                      child: const Text('Sizing Recommendation'),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Recently Viewed Shoes',
                      style: TextStyle(
                        fontFamily: 'Merriweather',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _fetchRecentlyViewedShoes(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No recently viewed shoes found.'));
                        }

                        final shoes = snapshot.data!;
                        return SizedBox(
                          height: 150.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: shoes.length,
                            itemBuilder: (context, index) {
                              final shoe = shoes[index];
                              return Padding(
                                padding: EdgeInsets.only(right: 8.0.w),
                                child: SizedBox(
                                  width: 100.w,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailPage(
                                            shoeID: shoe['shoeID'],
                                            shoeName: shoe['shoeName'],
                                            brand: shoe['brand'],
                                            type: shoe['type'],
                                            description: shoe['description'],
                                            imageURL: shoe['imageURL'],
                                            grpID: shoe['grpID'],
                                            objID: shoe['objID'],
                                            authKey: shoe['authKey'],
                                            camera: null,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0.r),
                                            child: Image.network(
                                              shoe['imageURL'],
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Container(
                                                color: Colors.grey,
                                                child: const Icon(
                                                  Icons.error,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        Text(
                                          shoe['shoeName'],
                                          style: TextStyle(
                                            fontFamily: 'Merriweather',
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
