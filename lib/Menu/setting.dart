import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Login Page/login_page.dart';
import '../Setting/feedback.dart';
import '../Setting/legalPolicy.dart';
import '../Setting/profile.dart';
import '../Setting/support_center.dart';
import '../Setting/admin_page.dart';
import '../Setting/tutorial_page.dart';
import '../connectivity_checker.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

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
    return ConnectivityChecker(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Settings',
            style: TextStyle(
              fontFamily: 'Merriweather',
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: _fetchUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No user data found.'));
            }

            final userData = snapshot.data!;
            final isAdmin = userData['role'] == 'admin';

            return Padding(
              padding: EdgeInsets.all(16.0.w),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    backgroundImage: const AssetImage('images/usericon.png'),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    userData['name'] ?? 'User',
                    style: TextStyle(
                      fontFamily: 'Merriweather',
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          leading: Icon(Icons.person_outline,
                              color: Colors.black, size: 24.sp),
                          title: Text(
                            'Profile',
                            style: TextStyle(
                              fontFamily: 'Merriweather',
                              fontSize: 18.sp,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfilePage(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.feedback_outlined,
                              color: Colors.black, size: 24.sp),
                          title: Text(
                            'Feedback',
                            style: TextStyle(
                              fontFamily: 'Merriweather',
                              fontSize: 18.sp,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FeedbackPage(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.support_agent_outlined,
                              color: Colors.black, size: 24.sp),
                          title: Text(
                            'Support Center',
                            style: TextStyle(
                              fontFamily: 'Merriweather',
                              fontSize: 18.sp,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SupportCenterPage(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.policy_outlined,
                              color: Colors.black, size: 24.sp),
                          title: Text(
                            'Legal Policy',
                            style: TextStyle(
                              fontFamily: 'Merriweather',
                              fontSize: 18.sp,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LegalPolicyPage(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.school,
                              color: Colors.black, size: 24.sp),
                          title: Text(
                            'Tutorial',
                            style: TextStyle(
                              fontFamily: 'Merriweather',
                              fontSize: 18.sp,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TutorialPage(),
                              ),
                            );
                          },
                        ),
                        if (isAdmin)
                          ListTile(
                            leading: Icon(Icons.admin_panel_settings,
                                color: Colors.black, size: 24.sp),
                            title: Text(
                              'Administrator Panel',
                              style: TextStyle(
                                fontFamily: 'Merriweather',
                                fontSize: 18.sp,
                                color: Colors.red,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AdminPage(),
                                ),
                              );
                            },
                          ),
                        SizedBox(height: 20.h),
                        Center(
                          child: TextButton(
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              if (context.mounted) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              'Log Out',
                              style: TextStyle(
                                fontFamily: 'Merriweather',
                                fontSize: 18.sp,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
