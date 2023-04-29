import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/auth/screens/login.dart';
import 'package:netzoon/presentation/home/pages/home_page.dart';
import 'package:netzoon/presentation/home/test.dart';
import 'package:netzoon/presentation/home/widgets/custom_appBar.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const HomePage(),
    const TestScreen(),
    const Center(
      child: Text(
        'add Item',
        style: TextStyle(color: Colors.black),
      ),
    ),
    const LogInScreen(),
    const Center(
      child: Text(
        'More',
        style: TextStyle(color: Colors.black),
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: customAppBar(context),
        body: _children[_currentIndex],
        bottomNavigationBar: GNav(
          onTabChange: _onItemTapped,
          backgroundColor: const Color(0xFF5776a5),
          iconSize: 20.sp,
          textSize: 10.sp,
          gap: 2,
          color: Colors.white,
          activeColor: Colors.white,
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.shopping_cart,
              text: 'Cart',
            ),
            GButton(
              icon: Icons.add,
              text: 'Add',
            ),
            GButton(
              icon: Icons.person,
              text: 'Profile',
            ),
            GButton(
              icon: Icons.more,
              text: 'More',
            )
          ],
        ),
      ),
    );
  }
}
