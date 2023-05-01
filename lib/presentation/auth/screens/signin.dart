import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController userNameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Form(
        child: Scaffold(
          body: BackgroundWidget(
            widget: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50.h,
                    ),
                    const Icon(
                      Icons.lock,
                      size: 100,
                      color: AppColor.backgroundColor,
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Text(
                      'مرحبا بك مجدداً',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColor.mainGrey,
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    SignInTextField(
                      controller: userNameController,
                      hintText: 'الإيميل أو رقم الهاتف',
                      obsecure: false,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SignInTextField(
                      controller: passwordController,
                      hintText: 'كلمة المرور',
                      obsecure: true,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'هل نسيت كلمة المرور ؟!',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 13.sp,
                            color: AppColor.secondGrey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            AppColor.backgroundColor,
                          ),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )),
                        ),
                        child: const Text('تسجيل الدخول'),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: AppColor.backgroundColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                          ),
                          child: Text(
                            'or continue with',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppColor.secondGrey,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: AppColor.backgroundColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SocialIcon(
                          imagePath: 'assets/images/google_icon.png',
                        ),
                        SizedBox(
                          width: 7.w,
                        ),
                        const SocialIcon(
                          imagePath: 'assets/images/facebook_icon.png',
                        ),
                        SizedBox(
                          width: 7.w,
                        ),
                        const SocialIcon(
                            imagePath: 'assets/images/mac_icon.png')
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SocialIcon extends StatelessWidget {
  const SocialIcon({
    super.key,
    required this.imagePath,
  });
  final String imagePath;
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      height: 40,
      width: 40,
    );
  }
}

class SignInTextField extends StatelessWidget {
  const SignInTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obsecure,
  });

  final TextEditingController controller;
  final String hintText;
  final bool obsecure;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obsecure,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: AppColor.black),
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.mainGrey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.mainGrey),
        ),
        fillColor: Colors.grey.shade300,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 15.sp,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 30),
      ),
    );
  }
}
