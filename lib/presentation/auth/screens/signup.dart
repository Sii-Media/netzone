import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/auth/widgets/background_auth_widget.dart';
import 'package:netzoon/presentation/auth/widgets/text_form_signup_widget.dart';
import 'package:netzoon/presentation/auth/widgets/text_signup_widget.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key, required this.accountTitle});
  final String accountTitle;
  @override
  Widget build(BuildContext context) {
    late TextEditingController emailSignup = TextEditingController();
    late TextEditingController username = TextEditingController();
    late TextEditingController passwordSignup = TextEditingController();
    late TextEditingController numberPhoneOne = TextEditingController();
    late TextEditingController numberPhoneTow = TextEditingController();
    late TextEditingController numberPhoneThree = TextEditingController();

    bool rememberMe = false;

    return BackgroundAuthWidget(
      topLogo: 0.2,
      onTap: () {
        Navigator.of(context).pop();
      },
      topBack: 150.h,
      topWidget: 160.h,
      topTitle: 110.h,
      n: 0.25.h,
      title: accountTitle,
      widget: Container(
        height: MediaQuery.of(context).size.height - 155.h,
        padding:
            const EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 10),
        color: Colors.grey.withOpacity(0.1),
        child: ListView(
          children: [
            const TextSignup(text: "البريد الإلكتروني"),
            TextFormSignupWidget(
              password: false,
              isNumber: false,
              valid: (val) {
                return null;

                // return validInput(val!, 5, 100, "email");
              },
              myController: emailSignup,
            ),
            const TextSignup(text: "اسم المستخدم"),
            TextFormSignupWidget(
              password: false,
              isNumber: false,
              valid: (val) {
                return null;

                // return validInput(val!, 5, 100, "username");
              },
              myController: username,
            ),
            const TextSignup(text: "كلمة المرور"),
            TextFormSignupWidget(
              password: false,
              isNumber: false,
              valid: (val) {
                return null;

                // return validInput(val!, 5, 100, "password");
              },
              myController: passwordSignup,
            ),
            const TextSignup(text: "أرقام التواصل"),
            Row(
              children: [
                Expanded(
                  child: TextFormSignupWidget(
                    password: false,
                    isNumber: false,
                    valid: (val) {
                      return null;

                      // return validInput(val!, 5, 100, "phone");
                    },
                    myController: numberPhoneOne,
                  ),
                ),
                Expanded(
                  child: TextFormSignupWidget(
                    password: false,
                    isNumber: false,
                    valid: (val) {
                      return null;

                      // return validInput(val!, 5, 100, "phone");
                    },
                    myController: numberPhoneTow,
                  ),
                ),
                Expanded(
                  child: TextFormSignupWidget(
                    password: false,
                    isNumber: false,
                    valid: (val) {
                      return null;

                      // return validInput(val!, 5, 100, "phone");
                    },
                    myController: numberPhoneThree,
                  ),
                )
              ],
            ),
            accountTitle == 'المستهلك'
                ? Container()
                : const TextSignup(text: "الفئة الفرعية"),
            accountTitle == 'المستهلك'
                ? Container()
                : TextFormSignupWidget(
                    password: false,
                    isNumber: false,
                    valid: (val) {
                      return null;

                      // return validInput(val!, 5, 100, "password");
                    },
                    myController: passwordSignup,
                  ),
            accountTitle == 'المستهلك'
                ? Container()
                : const TextSignup(text: "العنوان و الفروع الاخرى إن وجدت"),
            accountTitle == 'المستهلك'
                ? Container()
                : TextFormSignupWidget(
                    password: false,
                    isNumber: false,
                    valid: (val) {
                      return null;

                      // return validInput(val!, 5, 100, "password");
                    },
                    myController: passwordSignup,
                  ),
            accountTitle == 'المستهلك'
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                          child: TextSignup(text: "تابع لمنطقة حرة")),
                      SizedBox(
                        width: 20.w,
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (val) {
                            // print("object");
                            // controller.checkbox(val!);
                          },
                          value: rememberMe,
                        ),
                      )
                    ],
                  ),
            accountTitle == 'المستهلك'
                ? Container()
                : const TextSignup(text: "نسخة من رخصة تجارية"),
            accountTitle == 'المستهلك'
                ? Container()
                : Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        image: const DecorationImage(
                            image: AssetImage("assets/images/logo.png"),
                            fit: BoxFit.cover)),
                  ),
            accountTitle == 'المستهلك'
                ? Container()
                : const TextSignup(text: "عدد منتجات الشركة"),
            accountTitle == 'المستهلك'
                ? Container()
                : TextFormSignupWidget(
                    password: false,
                    isNumber: false,
                    valid: (val) {
                      return null;

                      // return validInput(val!, 5, 100, "password");
                    },
                    myController: passwordSignup,
                  ),
            accountTitle == 'المستهلك'
                ? Container()
                : const TextSignup(
                    text: "طريقة البيع (البيع بالتجزئة أو بالجملة)",
                  ),
            accountTitle == 'المستهلك'
                ? Container()
                : TextFormSignupWidget(
                    password: false,
                    isNumber: false,
                    valid: (val) {
                      return null;

                      // return validInput(val!, 5, 100, "password");
                    },
                    myController: passwordSignup,
                  ),
            accountTitle == 'المستهلك'
                ? Container()
                : const TextSignup(
                    text: "أين تبيع (لأي بلد)",
                  ),
            accountTitle == 'المستهلك'
                ? Container()
                : TextFormSignupWidget(
                    password: false,
                    isNumber: false,
                    valid: (val) {
                      return null;

                      // return validInput(val!, 5, 100, "password");
                    },
                    myController: passwordSignup,
                  ),
            const TextSignup(
              text: "الصورة الشخصية",
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  image: const DecorationImage(
                      image: AssetImage("assets/images/logo.png"),
                      fit: BoxFit.cover)),
            ),
            accountTitle == 'المستهلك'
                ? Container()
                : const TextSignup(
                    text: "صورة البانر",
                  ),
            accountTitle == 'المستهلك'
                ? Container()
                : Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        image: const DecorationImage(
                            image: AssetImage("assets/images/logo.png"),
                            fit: BoxFit.cover)),
                  ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              width: 100.w,
              // margin: EdgeInsets.symmetric(horizontal: 60, vertical: 10).r,
              margin: const EdgeInsets.only(left: 60, right: 60, bottom: 20).r,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(250.0).w,
                child: Container(
                  width: 100.w,
                  height: 50.0.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.greenAccent.withOpacity(0.9),
                        AppColor.backgroundColor
                      ],
                    ),
                  ),
                  child: RawMaterialButton(
                    onPressed: () {},
                    child: const Text(
                      "إنشاء حساب جديد",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }
}
