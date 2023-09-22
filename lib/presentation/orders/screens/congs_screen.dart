import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../../home/test.dart';

class CongsScreen extends StatelessWidget {
  const CongsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('Congratulations')),
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
              Text(
                '${AppLocalizations.of(context).translate('Congratulations')}!',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)
                    .translate('your_order_has_been_successfully_placed'),
                style: const TextStyle(fontSize: 16),
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
                child: Text(
                  AppLocalizations.of(context).translate('go_to_home'),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
