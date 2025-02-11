import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';
import 'setting.dart';
import 'measurement.dart';
import 'detail.dart';
import 'search_result.dart';
import '../connectivity_checker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late CameraDescription firstCamera;
  String userName = "User";
  static late List<Widget> _pages;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    availableCameras().then((cameras) {
      setState(() {
        firstCamera = cameras.first;
        _pages = [
          HomePageContent(
              camera: firstCamera, searchController: _searchController),
          MeasurementPage(camera: firstCamera),
          const SettingPage(),
        ];
      });
    });
  }

  void _fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        userName = userDoc['name'];
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
        body: _pages.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : _pages[_selectedIndex],
        bottomNavigationBar: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
          child: GNav(
            rippleColor: Colors.grey[800]!,
            hoverColor: Colors.grey[700]!,
            haptic: true,
            tabBorderRadius: 15.r,
            tabActiveBorder: Border.all(color: Colors.black, width: 1.w),
            tabBorder: Border.all(color: Colors.grey, width: 1.w),
            tabShadow: [
              BoxShadow(
                color:
                    const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                blurRadius: 8.r,
              )
            ],
            curve: Curves.easeOutExpo,
            duration: const Duration(milliseconds: 900),
            gap: 8.w,
            color: Colors.grey[800]!,
            activeColor: const Color(0xFFA58056),
            iconSize: 24.sp,
            tabBackgroundColor: const Color(0xFFA58056).withOpacity(0.1),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
            tabs: const [
              GButton(
                icon: LineIcons.home,
                text: 'Home',
              ),
              GButton(
                icon: LineIcons.ruler,
                text: 'Measure',
              ),
              GButton(
                icon: LineIcons.cog,
                text: 'Settings',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: _onItemTapped,
          ),
        ),
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  final CameraDescription camera;
  final TextEditingController searchController;

  const HomePageContent(
      {super.key, required this.camera, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.0.w),
          child: const CircleAvatar(
            backgroundImage: AssetImage('images/usericon.png'),
          ),
        ),
        title: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text(
                'Loading...',
                style: TextStyle(
                  fontFamily: 'Merriweather',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              );
            } else if (snapshot.hasError) {
              return Text(
                'Error',
                style: TextStyle(
                  fontFamily: 'Merriweather',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              String userName = snapshot.data!['name'];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome,',
                    style: TextStyle(
                      fontFamily: 'Merriweather',
                      fontSize: 14.sp,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    userName,
                    style: TextStyle(
                      fontFamily: 'Merriweather',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              );
            } else {
              return Text(
                'No Data',
                style: TextStyle(
                  fontFamily: 'Merriweather',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              );
            }
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search Shoe',
                prefixIcon: Icon(Icons.search, size: 24.sp),
                suffixIcon: IconButton(
                  icon: Icon(Icons.arrow_forward, size: 24.sp),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchResultPage(
                          query: searchController.text,
                        ),
                      ),
                    );
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0.r),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 20.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recommendation',
                style: TextStyle(
                  fontFamily: 'Merriweather',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('shoes').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No shoes found.'));
                  }

                  final allShoes = snapshot.data!.docs;
                  final random = Random();
                  final randomShoes =
                      (allShoes.toList()..shuffle(random)).take(6).toList();

                  return GridView.builder(
                    itemCount: randomShoes.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 4,
                      crossAxisSpacing: 10.w,
                      mainAxisSpacing: 10.h,
                    ),
                    itemBuilder: (context, index) {
                      final shoe = randomShoes[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0.r),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(
                                  shoeID: shoe.id,
                                  shoeName: shoe['shoeName'],
                                  brand: shoe['brand'],
                                  type: shoe['type'],
                                  description: shoe['description'],
                                  imageURL: shoe['imageURL'],
                                  grpID: shoe['grpID'],
                                  objID: shoe['objID'],
                                  authKey: shoe['authKey'],
                                  camera: camera,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0.r),
                                    topRight: Radius.circular(15.0.r),
                                  ),
                                  child: Image.network(
                                    shoe['imageURL'],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
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
                              Padding(
                                padding: EdgeInsets.all(8.0.w),
                                child: Text(
                                  shoe['shoeName'],
                                  style: TextStyle(
                                    fontFamily: 'Merriweather',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
