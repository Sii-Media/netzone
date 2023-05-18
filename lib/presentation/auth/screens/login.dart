import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/auth/screens/signin.dart';
import 'package:netzoon/presentation/auth/screens/user_type.dart';
import 'package:netzoon/presentation/auth/widgets/button_auth_widget.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  late TextEditingController emailController;
  late bool? isLoggedIn = false;

  @override
  void initState() {
    getIsLoggedIn();
    super.initState();
  }

  void getIsLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isLoggedIn = prefs.getBool('IsLoggedIn');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Color(0xFF5776a5),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/asd.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  Container(
                    height: 200.h,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/logo.png"),
                          fit: BoxFit.cover),
                    ),
                  ),
                  isLoggedIn == false
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 30.h,
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            ButtonAuthWidget(
                              color: AppColor.white,
                              colorText: AppColor.backgroundColor,
                              text: 'تسجيل الدخول',
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  // ignore: prefer_const_constructors
                                  return SignInScreen();
                                }));
                              },
                            ),
                            SizedBox(
                              height: 7.h,
                            ),
                            const Text(
                              "- أو -",
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              height: 7.h,
                            ),
                            ButtonAuthWidget(
                              color: AppColor.backgroundColor.withOpacity(0.5),
                              colorText: AppColor.white,
                              text: 'إنشاء حساب جديد',
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return const UserType();
                                }));
                                // controller.nextPage();
                              },
                            ),
                          ],
                        )
                      : ButtonAuthWidget(
                          color: AppColor.backgroundColor.withOpacity(0.5),
                          colorText: AppColor.white,
                          text: 'تسجيل الخروج',
                          onPressed: () async {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            // await prefs.remove('IsLoggedIn');
                            prefs.setBool('IsLoggedIn', false);
                            setState(() {
                              isLoggedIn = false;
                            });
                          },
                        ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
