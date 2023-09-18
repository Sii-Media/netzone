import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';

import '../../home/test.dart';

class CongsScreen extends StatelessWidget {
  const CongsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Congratulations'),
        backgroundColor: AppColor.backgroundColor,
        leading: const SizedBox(),
        leadingWidth: 0.0,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/congs.png',
                width: 150.w,
              ),
              const SizedBox(height: 20),
              const Text(
                'Congratulations!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your order has been successfully placed.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                      CupertinoPageRoute(builder: (context) {
                    return const TestScreen();
                  }), (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.backgroundColor,
                ),
                child: const Text(
                  'Go to Home',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
