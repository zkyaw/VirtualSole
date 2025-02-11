import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Login Page/login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 50.h),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {});
                },
                children: [
                  _buildPage(
                    imagePath: 'images/intro1.png',
                    title: 'Measure Feet Accurately With Our Intuitive App',
                  ),
                  _buildPage(
                    imagePath: 'images/intro2.png',
                    title: 'Try On Shoes Virtually For The Perfect Fit',
                  ),
                  _buildPage(
                    imagePath: 'images/intro3.png',
                    title: 'Browse Various Shoe Styles Effortlessly',
                    isLastPage: true,
                  ),
                ],
              ),
            ),
            SmoothPageIndicator(
              controller: _pageController,
              count: 3,
              effect: const WormEffect(
                activeDotColor: Color(0xFFA58056),
                dotColor: Color(0xFFAE9578),
                spacing: 8.0,
                radius: 12.0,
                dotWidth: 15.0,
                dotHeight: 15.0,
              ),
            ),
            SizedBox(height: 16.h),
            _buildBottomNavigation(),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    required String imagePath,
    required String title,
    bool isLastPage = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 200.r,
            backgroundImage: AssetImage(imagePath),
          ),
          SizedBox(height: 40.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Merriweather',
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    final currentPage =
        _pageController.hasClients ? _pageController.page?.round() : 0;
    if (currentPage == 2) {
      return Center(
        child: ElevatedButton(
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('hasSeenOnboarding', true);
            if (mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: 48.w,
              vertical: 16.h,
            ),
            backgroundColor: const Color(0xFFA58056),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
            ),
          ),
          child: const Text(
            'Get Started',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              _pageController.jumpToPage(2);
            },
            child: Text(
              'Skip',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18.sp,
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFA58056),
            ),
            margin: EdgeInsets.only(right: 16.w),
            child: IconButton(
              icon: Image.asset(
                'images/nextarroww.png',
                width: 30.w,
                height: 30.h,
              ),
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
        ],
      );
    }
  }
}
