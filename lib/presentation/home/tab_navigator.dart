// import 'package:flutter/material.dart';
// import 'package:netzoon/presentation/add_items/add_product_screen.dart';
// import 'package:netzoon/presentation/cart/cart_screen.dart';
// import 'package:netzoon/presentation/core/widgets/background_widget.dart';
// import 'package:netzoon/presentation/home/pages/home_page.dart';

// import '../auth/screens/login.dart';
// import '../more/more_screen.dart';

// class TabNavigator extends StatelessWidget {
//   final GlobalKey<NavigatorState> navigatorKey;
//   final String tabItem;
//   const TabNavigator(
//       {super.key, required this.navigatorKey, required this.tabItem});

//   @override
//   Widget build(BuildContext context) {
//     Widget child;
//     if (tabItem == 'page1') {
//       child = const HomePage();
//     } else if (tabItem == 'page2') {
//       child = const CartScreen();
//     } else if (tabItem == 'page3') {
//       child = const AddProductScreen();
//     } else if (tabItem == 'page4') {
//       child = const LogInScreen();
//     } else {
//       child = const MoreScreen();
//     }
//     return Navigator(
//         key: navigatorKey,
//         onGenerateRoute: (routeSettings) {
//           return MaterialPageRoute(builder: (context) {
//             return BackgroundWidget(
//               widget: child,
//             );
//           });
//         });
//     // return BackgroundWidget(
//     //   widget: child,
//     // );
//   }
// }
