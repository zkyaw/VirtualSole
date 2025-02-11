import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Terms and Conditions",
          style: TextStyle(fontSize: 18.sp),
        ),
      ),
      body: Center(
        child: Text(
          "This will be the Terms and Conditions module page for now it's just a placeholder.",
          style: TextStyle(fontSize: 16.sp),
        ),
      ),
    );
  }
}
