import 'package:flutter/material.dart';
import 'package:netzoon/presentation/add_items/add_product_screen.dart';
import 'package:netzoon/presentation/auth/screens/login.dart';
import 'package:netzoon/presentation/cart/cart_screen.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/home/pages/home_page.dart';
import 'package:netzoon/presentation/more/more_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int _currentIndex = 0;
  final _items = <Widget>[
    const Icon(
      Icons.home,
      size: 25,
    ),
    const Icon(
      Icons.shopping_cart,
      size: 25,
    ),
    const Icon(
      Icons.add,
      size: 25,
    ),
    // CircleAvatar(
    //   radius: 16,
    //   backgroundColor: Colors.grey.shade800,
    //   backgroundImage: const NetworkImage(
    //       'https://newprofilepic2.photo-cdn.net//assets/images/article/profile.jpg'),
    // ),
    const Icon(
      Icons.person,
      size: 25,
    ),
    const Icon(
      Icons.more_horiz,
      size: 25,
    ),
  ];
  // late bool? isLoggedIn = false;
  final List<Widget> _children = [
    const HomePage(),
    const CartScreen(),
    const AddProductScreen(),
    const LogInScreen(),
    const MoreScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // void getIsLoggedIn() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();

  //   setState(() {
  //     isLoggedIn = prefs.getBool('IsLoggedIn');
  //   });
  // }

  @override
  void initState() {
    // getIsLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.backgroundColor,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ClipRRect(
            child: Scaffold(
              extendBody: true,
              body: BackgroundWidget(
                widget: _children[_currentIndex],
              ),
              bottomNavigationBar: Theme(
                data: Theme.of(context).copyWith(
                  iconTheme: const IconThemeData(
                    color: AppColor.white,
                  ),
                ),
                child: CurvedNavigationBar(
                  items: _items,
                  height: 60,
                  index: _currentIndex,
                  onTap: _onItemTapped,
                  backgroundColor: Colors.transparent,
                  color: AppColor.backgroundColor,
                  buttonBackgroundColor: AppColor.backgroundColor,
                  animationCurve: Curves.easeInOut,
                  animationDuration: const Duration(milliseconds: 400),
                ),
              ),
              // bottomNavigationBar: SizedBox(
              //   height: 65.h,
              //   child: BottomNavigationBar(
              //     currentIndex: _currentIndex,
              //     type: BottomNavigationBarType.fixed,
              //     backgroundColor: AppColor.backgroundColor,
              //     selectedItemColor: AppColor.white,
              //     unselectedItemColor: AppColor.white.withOpacity(0.5),
              //     onTap: _onItemTapped,
              //     items: const [
              //       BottomNavigationBarItem(
              //         icon: Icon(Icons.home),
              //         label: 'الرئيسية',
              //       ),
              //       BottomNavigationBarItem(
              //         icon: Icon(Icons.shopping_cart),
              //         label: 'السلة',
              //       ),
              //       BottomNavigationBarItem(
              //         icon: Icon(Icons.add),
              //         label: 'إضافة',
              //       ),
              //       BottomNavigationBarItem(
              //         icon: Icon(Icons.person),
              //         label: 'حسابي',
              //       ),
              //       BottomNavigationBarItem(
              //         icon: Icon(Icons.more_horiz),
              //         label: 'المزيد',
              //       ),
              //     ],
              //   ),
              // ),
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
        ),
      ),
    );
  }
}
