import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/auth/screens/login.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/home/pages/home_page.dart';
import 'package:netzoon/presentation/more/more_screen.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const HomePage(),
    const Center(
      child: Text(
        'السلة',
        style: TextStyle(color: Colors.black),
      ),
    ),
    const Center(
      child: Text(
        'إضافة منتج',
        style: TextStyle(color: Colors.black),
      ),
    ),
    const LogInScreen(),
    const MoreScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
          body: BackgroundWidget(
            widget: _children[_currentIndex],
          ),
          bottomNavigationBar: SizedBox(
            height: 65.h,
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppColor.backgroundColor,
              selectedItemColor: AppColor.white,
              unselectedItemColor: AppColor.white.withOpacity(0.5),
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'الرئيسية',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  label: 'السلة',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  label: 'إضافة',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'حسابي',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.more_horiz),
                  label: 'المزيد',
                ),
              ],
            ),
          ),
          // bottomNavigationBar: SizedBox(
          //   height: 65.h,
          //   width: MediaQuery.of(context).size.width,
          //   child: GNav(
          //     style: GnavStyle.google,
          //     onTabChange: _onItemTapped,
          //     backgroundColor: AppColor.backgroundColor,
          //     iconSize: 22.sp,
          //     textSize: 10.sp,
          //     gap: 2,
          //     color: Colors.white,
          //     activeColor: Colors.white,
          //     tabs: const [
          //       GButton(
          //         icon: Icons.home,
          //         text: 'الرئيسية',
          //       ),
          //       GButton(
          //         icon: Icons.shopping_cart,
          //         text: 'السلة',
          //       ),
          //       GButton(
          //         icon: Icons.add,
          //         text: 'إضافة',
          //       ),
          //       GButton(
          //         icon: Icons.person,
          //         text: 'حسابي',
          //       ),
          //       GButton(
          //         icon: Icons.list_rounded,
          //         text: 'المزيد',
          //       )
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }
}
