// ignore_for_file: unused_field, unused_element

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/add_items/add_item_screen.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:netzoon/presentation/home/pages/home_page.dart';
import 'package:netzoon/presentation/profile/blocs/add_account/add_account_bloc.dart';

import '../../injection_container.dart';
import '../auth/blocs/auth_bloc/auth_bloc.dart';
import '../auth/screens/login.dart';
import '../cart/blocs/cart_bloc/cart_bloc_bloc.dart';
import '../cart/cart_screen.dart';
import '../core/widgets/on_failure_widget.dart';
import '../more/more_screen.dart';
import '../profile/screens/add_account_screen.dart';
import '../utils/app_localizations.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> with ScreenLoader<TestScreen> {
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

  final getAccountsBloc = sl<AddAccountBloc>();

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

  final authBloc = sl<AuthBloc>();

  @override
  void initState() {
    authBloc.add(AuthCheckRequested());
    // getIsLoggedIn();
    tabController = CupertinoTabController(initialIndex: 0);
    super.initState();
  }

  @override
  Widget screen(BuildContext context) {
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
              // ignore: use_build_context_synchronously
              return _onBackButtonPressed(context);
            }
          }
          return isFirstRouteInCurrentTab;
        },
        child: BlocListener<AddAccountBloc, AddAccountState>(
          bloc: getAccountsBloc,
          listener: (context, changeAccountstate) {
            if (changeAccountstate is OnChangeAccountInProgress) {
              startLoading();
            } else if (changeAccountstate is OnChangeAccountFailure) {
              stopLoading();

              final failure = changeAccountstate.message;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    failure,
                    style: const TextStyle(
                      color: AppColor.white,
                    ),
                  ),
                  backgroundColor: AppColor.red,
                ),
              );
            } else if (changeAccountstate is OnChangeAccountSuccess) {
              stopLoading();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  AppLocalizations.of(context).translate('success'),
                ),
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ));
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  CupertinoPageRoute(builder: (context) {
                return const TestScreen();
              }), (route) => false);
            }
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
                      backgroundColor: AppColor.white,
                      activeColor: AppColor.backgroundColor,
                      inactiveColor: AppColor.backgroundColor.withOpacity(0.9),
                      height: 60,
                      border: Border(
                        top: BorderSide(
                          width: 1,
                          color: AppColor.mainGrey.withOpacity(0.1),
                        ),
                      ),
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
                                      color: AppColor.red,
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
                                              color: AppColor.white,
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
                                  .white, // Set the outer circle color to blue
                              border: Border.all(
                                color: AppColor
                                    .backgroundColor, // Set the outer circle border color to white
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
                                      .backgroundColor, // Set the outer circle color to blue
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: AppColor.white,
                                ),
                              ),
                            ),
                          ),
                          // label: 'Add',
                        ),
                        BottomNavigationBarItem(
                          icon: BlocBuilder<AuthBloc, AuthState>(
                            bloc: authBloc,
                            builder: (context, state) {
                              return GestureDetector(
                                onLongPress: state is Authenticated
                                    ? () {
                                        getAccountsBloc
                                            .add(GetUserAccountsEvent());
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor:
                                              AppColor.backgroundColor,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(30),
                                            ),
                                          ),
                                          builder: (context) {
                                            return SizedBox(
                                              height: 300.h,
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 24.0,
                                                      bottom: 4.0,
                                                    ),
                                                    child: Container(
                                                      width: 75,
                                                      height: 7,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color:
                                                            Color(0xFFC6E2DD),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(5),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 6.0,
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: BlocBuilder<
                                                          AddAccountBloc,
                                                          AddAccountState>(
                                                        bloc: getAccountsBloc,
                                                        builder: (context,
                                                            accountstate) {
                                                          if (accountstate
                                                              is GetUserAccountsInProgress) {
                                                            return const Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: AppColor
                                                                    .white,
                                                              ),
                                                            );
                                                          } else if (accountstate
                                                              is GetUserAccountsFailure) {
                                                            final failure =
                                                                accountstate
                                                                    .message;
                                                            return FailureWidget(
                                                              failure: failure,
                                                              onPressed: () {
                                                                getAccountsBloc.add(
                                                                    GetUserAccountsEvent());
                                                              },
                                                            );
                                                          } else if (accountstate
                                                              is GetUserAccountsSuccess) {
                                                            return SingleChildScrollView(
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            40,
                                                                        width:
                                                                            40,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              AppColor.backgroundColor,
                                                                          image:
                                                                              DecorationImage(
                                                                            image:
                                                                                CachedNetworkImageProvider(
                                                                              // ignore: unnecessary_type_check
                                                                              state is Authenticated ? state.user.userInfo.profilePhoto! : 'https://pbs.twimg.com/media/FjU2lkcWYAgNG6d.jpg',
                                                                            ),
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(100),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10.w,
                                                                      ),
                                                                      Text(
                                                                        state.user.userInfo.username ??
                                                                            '',
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              AppColor.white,
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                      const Spacer(),
                                                                      Radio<
                                                                          int>(
                                                                        value:
                                                                            0,
                                                                        groupValue:
                                                                            0,
                                                                        onChanged:
                                                                            (int?
                                                                                value) {
                                                                          // Handle radio button selection
                                                                        },
                                                                        activeColor:
                                                                            AppColor.white,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        20.h,
                                                                  ),
                                                                  ListView
                                                                      .builder(
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemCount:
                                                                        accountstate
                                                                            .users
                                                                            .length,
                                                                    physics:
                                                                        const NeverScrollableScrollPhysics(),
                                                                    scrollDirection:
                                                                        Axis.vertical,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(vertical: 4.0),
                                                                        child:
                                                                            accountWidget(
                                                                          accountstate:
                                                                              accountstate,
                                                                          index:
                                                                              index,
                                                                          onTap:
                                                                              () {
                                                                            final cartBloc =
                                                                                context.read<CartBlocBloc>();
                                                                            cartBloc.add(ClearCart());
                                                                            getAccountsBloc.add(
                                                                              OnChangeAccountEvent(
                                                                                email: accountstate.users[index].email!,
                                                                                password: accountstate.users[index].password!,
                                                                              ),
                                                                            );
                                                                          },
                                                                          onChanged:
                                                                              (int? val) {
                                                                            final cartBloc =
                                                                                context.read<CartBlocBloc>();
                                                                            cartBloc.add(ClearCart());
                                                                            getAccountsBloc.add(
                                                                              OnChangeAccountEvent(
                                                                                email: accountstate.users[index].email!,
                                                                                password: accountstate.users[index].password!,
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        20.h,
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .push(
                                                                        MaterialPageRoute(
                                                                          builder:
                                                                              (context) {
                                                                            return const AddAccountScreen();
                                                                          },
                                                                        ),
                                                                      );
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              40,
                                                                          width:
                                                                              40,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                AppColor.white,
                                                                            borderRadius:
                                                                                BorderRadius.circular(100),
                                                                          ),
                                                                          child:
                                                                              const Icon(
                                                                            Icons.add,
                                                                            color:
                                                                                AppColor.backgroundColor,
                                                                            size:
                                                                                30,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              10.w,
                                                                        ),
                                                                        Text(
                                                                          AppLocalizations.of(context)
                                                                              .translate('add_account'),
                                                                          style:
                                                                              const TextStyle(
                                                                            color:
                                                                                AppColor.white,
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          }
                                                          return Container();
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    : () {},
                                child: state is Authenticated
                                    ? Container(
                                        height: 32,
                                        width: 32,
                                        decoration: BoxDecoration(
                                          color: AppColor.backgroundColor,
                                          image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                              state.user.userInfo.profilePhoto!,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                      )
                                    : const Icon(
                                        CupertinoIcons.person_alt_circle,
                                      ),
                              );
                            },
                          ),
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
        ));
  }

  Widget accountWidget(
      {required GetUserAccountsSuccess accountstate,
      required int index,
      void Function()? onTap,
      required void Function(int?)? onChanged}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                color: AppColor.backgroundColor,
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      accountstate.users[index].profilePhoto ??
                          'https://pbs.twimg.com/media/FjU2lkcWYAgNG6d.jpg',
                    ),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(100)),
          ),
          SizedBox(
            width: 10.w,
          ),
          Text(
            accountstate.users[index].username ?? '',
            style: const TextStyle(
                color: AppColor.white,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Radio<int>(
            value: 1,
            groupValue: 0,
            onChanged: onChanged,
            activeColor: AppColor.white,
          ),
        ],
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
          title: Text(
            AppLocalizations.of(context).translate('Really!!'),
            style: const TextStyle(
              color: AppColor.backgroundColor,
            ),
          ),
          content: Text(
            AppLocalizations.of(context)
                .translate('Do you want to close the app ?'),
            style: const TextStyle(
              color: AppColor.backgroundColor,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(AppLocalizations.of(context).translate('No')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(AppLocalizations.of(context).translate('Yes')),
            ),
          ],
        );
      },
    );
    return exitApp;
  }
}
