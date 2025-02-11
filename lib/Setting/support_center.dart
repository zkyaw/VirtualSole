import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../connectivity_checker.dart';

class SupportCenterPage extends StatelessWidget {
  const SupportCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectivityChecker(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Support Center",
            style: TextStyle(fontSize: 18.sp),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Need Help?',
                style: TextStyle(
                  fontFamily: 'Merriweather',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'If you encounter any issues or have any questions, feel free to contact us at:',
                style: TextStyle(
                  fontFamily: 'Merriweather',
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  const Icon(Icons.email, color: Colors.black),
                  SizedBox(width: 8.w),
                  Text(
                    'nexusscore23@gmail.com',
                    style: TextStyle(
                      fontFamily: 'Merriweather',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              Text(
                'We are here to assist you 24/7. Please provide detailed information about your issue so that we can assist you more effectively.',
                style: TextStyle(
                  fontFamily: 'Merriweather',
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 32.h),
              Expanded(
                child: Center(
                  child: Icon(Icons.support_agent_outlined,
                      size: 100.sp, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
