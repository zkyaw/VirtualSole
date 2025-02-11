import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../connectivity_checker.dart';

class LegalPolicyPage extends StatelessWidget {
  const LegalPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectivityChecker(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Legal Policy",
            style: TextStyle(fontSize: 18.sp),
          ),
        ),
        body: Center(
          child: Text(
            "This is the Legal Policy page for now it's just a placeholder.",
            style: TextStyle(fontSize: 16.sp),
          ),
        ),
      ),
    );
  }
}
