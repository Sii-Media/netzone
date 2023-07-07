import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constant/colors.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_rounded,
            color: AppColor.backgroundColor,
          ),
        ),
        title: const Text(
          'Orders',
          style: TextStyle(color: AppColor.backgroundColor),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_checkout,
              color: AppColor.backgroundColor.withOpacity(0.3),
              size: 70,
            ),
            Text(
              'You don\'t have any orders yet',
              style: TextStyle(
                color: AppColor.backgroundColor.withOpacity(0.5),
                fontSize: 23.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Start shopping!',
              style: TextStyle(
                color: AppColor.backgroundColor.withOpacity(0.3),
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
