import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/presentation/add_items/add_item_screen.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/home/pages/home_page.dart';

import '../auth/screens/login.dart';
import '../cart/blocs/cart_bloc/cart_bloc_bloc.dart';
import '../cart/cart_screen.dart';
import '../more/more_screen.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int _currentIndex = 0;
  String _currentPage = "page1";
  List<String> pageKeys = ["page1", "page2", "page3", "page4", "page5"];
  final Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    "page1": GlobalKey<NavigatorState>(),
    "page2": GlobalKey<NavigatorState>(),
    "page3": GlobalKey<NavigatorState>(),
    "page4": GlobalKey<NavigatorState>(),
    "page5": GlobalKey<NavigatorState>(),
  };

  void _selectTab(String tabItem, int index) {
    if (tabItem == _currentPage) {
      _navigatorKeys[tabItem]!.currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentPage = pageKeys[index];
        _currentIndex = index;
      });
    }
  }

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
    const AddItemScreen(),
    const LogInScreen(),
    const MoreScreen(),
  ];

  final GlobalKey<NavigatorState> firstTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> secondTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> thirdTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> fourthTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> fifthTabNavKey = GlobalKey<NavigatorState>();

  late CupertinoTabController tabController;

  // void getIsLoggedIn() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();

  //   setState(() {
  //     isLoggedIn = prefs.getBool('IsLoggedIn');
  //   });
  // }
  bool _isPressed = false;
  Timer? _timer;
  double _iconSize = 50.0;

  void _togglePressed() {
    setState(() {
      _isPressed = !_isPressed;
      if (_isPressed) {
        _iconSize = 60.0;
        _timer = Timer(const Duration(milliseconds: 200), () {
          setState(() {
            _iconSize = 50.0;
          });
        });
      }
    });

    if (_isPressed) {
      HapticFeedback.vibrate();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // getIsLoggedIn();
    tabController = CupertinoTabController(initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartBloc = context.read<CartBlocBloc>();
    final listOfKeys = [
      firstTabNavKey,
      secondTabNavKey,
      thirdTabNavKey,
      fourthTabNavKey,
      fifthTabNavKey,
    ];
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await listOfKeys[tabController.index].currentState!.maybePop();

        if (isFirstRouteInCurrentTab) {
          if (tabController.index != 0) {
            tabController.index = 0;
            _currentIndex = 0;
            return false;
          } else {
            return _onBackButtonPressed(context);
          }
        }
        return isFirstRouteInCurrentTab;
      },
      child: Container(
        color: AppColor.backgroundColor,
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ClipRRect(
              child: CupertinoTabScaffold(
                controller: tabController,
                tabBar: CupertinoTabBar(
                  backgroundColor: AppColor.backgroundColor,
                  activeColor: AppColor.white,
                  inactiveColor: AppColor.white.withOpacity(0.5),
                  height: 60,
                  items: [
                    const BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.home),
                      // label: 'Home',
                    ),
                    BottomNavigationBarItem(
                        icon: BlocBuilder<CartBlocBloc, CartBlocState>(
                      bloc: cartBloc,
                      builder: (context, state) {
                        return Stack(
                          children: [
                            const Icon(
                              CupertinoIcons.cart,
                            ),
                            Positioned(
                              top: -1,
                              right: -1,
                              child: Container(
                                padding: const EdgeInsets.all(2.0),
                                decoration: const BoxDecoration(
                                  color: AppColor.white,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16.0,
                                  minHeight: 16.0,
                                ),
                                child: state is CartLoaded
                                    ? Text(
                                        state.totalQuantity.toString(),
                                        style: const TextStyle(
                                          color: AppColor.backgroundColor,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      )
                                    : const Text(
                                        '0',
                                        style: TextStyle(
                                          color: AppColor.backgroundColor,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                              ),
                            ),
                          ],
                        );
                      },
                    )
                        // label: 'Cart',
                        ),
                    BottomNavigationBarItem(
                      icon: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor
                              .backgroundColor, // Set the outer circle color to blue
                          border: Border.all(
                            color: Colors
                                .white, // Set the outer circle border color to white
                            width: 2.0, // Set the outer circle border width
                          ),
                        ),
                        child: Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: _isPressed ? 40 : 30,
                            height: _isPressed ? 40 : 30,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColor
                                  .white, // Set the outer circle color to blue
                            ),
                            child: const Icon(
                              Icons.add,
                              color: AppColor.backgroundColor,
                            ),
                          ),
                        ),
                      ),
                      // label: 'Add',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.profile_circled),
                      // label: 'Profile',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.list_dash),
                      // label: 'More',
                    ),
                  ],
                ),
                tabBuilder: (context, index) {
                  return CupertinoTabView(
                    navigatorKey: listOfKeys[index],
                    builder: (context) =>
                        BackgroundWidget(widget: _children[index]),
                  );
                },
              ),
              // child: WillPopScope(
              //   onWillPop: () async {
              //     final isFirstRouteInCurrentTab =
              //         !await _navigatorKeys[_currentPage]!
              //             .currentState!
              //             .maybePop();
              //     if (isFirstRouteInCurrentTab) {
              //       if (_currentPage != "page1") {
              //         _selectTab("page1", 0);

              //         return false;
              //       } else if (_currentPage == "page1") {
              //         // ignore: use_build_context_synchronously
              //         return _onBackButtonPressed(context);
              //       }
              //     }
              //     // let system handle back button if we're on the first route

              //     return isFirstRouteInCurrentTab;
              //   },
              //   child: Scaffold(
              //     extendBody: true,
              //     body: Stack(
              //       children: [
              //         _buildOffstageNavigator('page1'),
              //         _buildOffstageNavigator('page2'),
              //         _buildOffstageNavigator('page3'),
              //         _buildOffstageNavigator('page4'),
              //         _buildOffstageNavigator('page5'),
              //       ],
              //     ),
              //     // body: BackgroundWidget(
              //     //   widget: _children[_currentIndex],
              //     // ),
              //     bottomNavigationBar: Theme(
              //       data: Theme.of(context).copyWith(
              //         iconTheme: const IconThemeData(
              //           color: AppColor.white,
              //         ),
              //       ),
              //       child: CurvedNavigationBar(
              //         items: _items,
              //         height: 60,
              //         index: _currentIndex,
              //         onTap: (int index) {
              //           _selectTab(pageKeys[index], index);
              //         },
              //         backgroundColor: Colors.transparent,
              //         color: AppColor.backgroundColor,
              //         buttonBackgroundColor: AppColor.backgroundColor,
              //         animationCurve: Curves.easeInOut,
              //         animationDuration: const Duration(milliseconds: 400),
              //       ),
              //     ),
              //   ),
              // ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildOffstageNavigator(String tabItem) {
  //   return Offstage(
  //     offstage: _currentPage != tabItem,
  //     child: TabNavigator(
  //       navigatorKey: _navigatorKeys[tabItem]!,
  //       tabItem: tabItem,
  //     ),
  //   );
  // }

  Future<bool> _onBackButtonPressed(BuildContext context) async {
    bool exitApp = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Really!!',
            style: TextStyle(
              color: AppColor.backgroundColor,
            ),
          ),
          content: const Text(
            'Do you want to close the app ?',
            style: TextStyle(
              color: AppColor.backgroundColor,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
    return exitApp;
  }
}
