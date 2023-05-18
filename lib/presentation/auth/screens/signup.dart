import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:netzoon/presentation/auth/blocs/sign_up/sign_up_bloc.dart';
import 'package:netzoon/presentation/auth/widgets/background_auth_widget.dart';
import 'package:netzoon/presentation/auth/widgets/text_form_signup_widget.dart';
import 'package:netzoon/presentation/auth/widgets/text_signup_widget.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:netzoon/injection_container.dart' as di;
import 'package:netzoon/presentation/home/test.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.accountTitle});
  final String accountTitle;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with ScreenLoader<SignUpPage> {
  final SignUpBloc bloc = di.sl<SignUpBloc>();
  final GlobalKey<FormState>? formKey = GlobalKey<FormState>();
  final TextEditingController emailSignup = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController passwordSignup = TextEditingController();
  final TextEditingController numberPhoneOne = TextEditingController();
  final TextEditingController numberPhoneTow = TextEditingController();
  final TextEditingController numberPhoneThree = TextEditingController();
  final TextEditingController subcategory = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController isFreeZoon = TextEditingController();
  final TextEditingController companyProductsNumber = TextEditingController();
  final TextEditingController sellType = TextEditingController();
  final TextEditingController toCountry = TextEditingController();

  final GlobalKey<FormFieldState> _emailFormFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> passwordFormFieldKey =
      GlobalKey<FormFieldState>();
  @override
  Widget screen(BuildContext context) {
    return BlocListener(
      bloc: bloc,
      listener: (context, state) {
        if (state is SignUpInProgress) {
          startLoading();
        } else if (state is SignUpFailure) {
          stopLoading();

          final failure = state.message;
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
        } else if (state is SignUpSuccess) {
          stopLoading();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
              'success',
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ));
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const TestScreen();
          }));
        }
      },
      child: SignUpWidget(
        formKey: formKey,
        accountTitle: widget.accountTitle,
        emailSignup: emailSignup,
        username: username,
        passwordSignup: passwordSignup,
        passwordFormFieldKey: passwordFormFieldKey,
        numberPhoneOne: numberPhoneOne,
        numberPhoneTow: numberPhoneTow,
        numberPhoneThree: numberPhoneThree,
        rememberMe: true,
        bloc: bloc,
        emailFormFieldKey: _emailFormFieldKey,
        address: address,
        subcategory: subcategory,
        companyProductsNumber: companyProductsNumber,
        sellType: sellType,
        toCountry: toCountry,
      ),
    );
  }
}

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({
    super.key,
    this.formKey,
    required this.accountTitle,
    required this.emailSignup,
    required this.username,
    required this.passwordSignup,
    required this.numberPhoneOne,
    required this.numberPhoneTow,
    required this.numberPhoneThree,
    required this.rememberMe,
    required this.bloc,
    required this.emailFormFieldKey,
    required this.passwordFormFieldKey,
    required this.subcategory,
    required this.address,
    required this.companyProductsNumber,
    required this.sellType,
    required this.toCountry,
  });
  final GlobalKey<FormState>? formKey;
  final GlobalKey<FormFieldState> emailFormFieldKey;
  final GlobalKey<FormFieldState> passwordFormFieldKey;
  final String accountTitle;
  final TextEditingController emailSignup;
  final TextEditingController username;
  final TextEditingController passwordSignup;
  final TextEditingController numberPhoneOne;
  final TextEditingController numberPhoneTow;
  final TextEditingController numberPhoneThree;
  final TextEditingController subcategory;
  final TextEditingController address;
  final TextEditingController companyProductsNumber;
  final TextEditingController sellType;
  final TextEditingController toCountry;

  final bool rememberMe;
  final SignUpBloc bloc;

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

bool showPass = false;

class _SignUpWidgetState extends State<SignUpWidget> {
  @override
  Widget build(BuildContext context) {
    return BackgroundAuthWidget(
      topLogo: 0.2,
      onTap: () {
        Navigator.of(context).pop();
      },
      topBack: 150.h,
      topWidget: 160.h,
      topTitle: 110.h,
      n: 0.25.h,
      title: widget.accountTitle,
      widget: Form(
        key: widget.formKey,
        child: Container(
          height: MediaQuery.of(context).size.height - 155.h,
          padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 10, vertical: 10),
          color: Colors.grey.withOpacity(0.1),
          child: ListView(
            children: [
              const TextSignup(text: "البريد الإلكتروني"),
              TextFormField(
                key: widget.emailFormFieldKey,
                controller: widget.emailSignup,
                style: const TextStyle(color: Colors.black),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'يجب إدخال الإيميل أو رقم الهاتف';
                  }

                  if (!EmailValidator(errorText: 'الرجاء ادخال ايميل صحيح')
                      .isValid(text.toLowerCase())) {
                    return 'الرجاء ادخال ايميل صحيح';
                  }

                  return null;
                },
                onChanged: (text) {
                  widget.emailFormFieldKey.currentState!.validate();
                },
                decoration: InputDecoration(
                  filled: true,
                  //<-- SEE HERE
                  fillColor: Colors.green.withOpacity(0.1),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 30)
                          .flipped,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const TextSignup(text: "اسم المستخدم"),
              TextFormField(
                controller: widget.username,
                style: const TextStyle(color: Colors.black),
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'اسم المستخدم مطلوب';
                  }
                  if (val.length < 5) {
                    return 'يجب أن يحتوي اسم المستخدم على 5 أحرف على الأقل';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  filled: true,
                  //<-- SEE HERE
                  fillColor: Colors.green.withOpacity(0.1),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 30)
                          .flipped,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const TextSignup(text: "كلمة المرور"),
              TextFormField(
                key: widget.passwordFormFieldKey,
                controller: widget.passwordSignup,
                style: const TextStyle(color: AppColor.black),
                decoration: InputDecoration(
                  filled: true,
                  //<-- SEE HERE
                  fillColor: Colors.green.withOpacity(0.1),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 30)
                          .flipped,
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        showPass = !showPass;
                      });
                    },
                    child: showPass
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: showPass,
                // textInputAction: widget.textInputAction ?? TextInputAction.done,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'يجب إدخال كلمة المرور'),
                  MinLengthValidator(8,
                      errorText:
                          'يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل'),
                ]),
                onChanged: (text) {
                  widget.passwordFormFieldKey.currentState!.validate();
                },
              ),
              const TextSignup(text: "أرقام التواصل"),
              Row(
                children: [
                  Expanded(
                    child: TextFormSignupWidget(
                      password: false,
                      isNumber: false,
                      valid: (val) {
                        if (val!.isEmpty) {
                          return 'مطلوب';
                        }

                        return null;
                      },
                      myController: widget.numberPhoneOne,
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
                      myController: widget.numberPhoneTow,
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
                      myController: widget.numberPhoneThree,
                    ),
                  )
                ],
              ),
              widget.accountTitle == 'المستهلك'
                  ? Container()
                  : const TextSignup(text: "الفئة الفرعية"),
              widget.accountTitle == 'المستهلك'
                  ? Container()
                  : TextFormSignupWidget(
                      password: false,
                      isNumber: false,
                      valid: (val) {
                        return null;

                        // return validInput(val!, 5, 100, "password");
                      },
                      myController: widget.subcategory,
                    ),
              widget.accountTitle == 'المستهلك'
                  ? Container()
                  : const TextSignup(text: "العنوان و الفروع الاخرى إن وجدت"),
              widget.accountTitle == 'المستهلك'
                  ? Container()
                  : TextFormSignupWidget(
                      password: false,
                      isNumber: false,
                      valid: (val) {
                        return null;

                        // return validInput(val!, 5, 100, "password");
                      },
                      myController: widget.address,
                    ),
              widget.accountTitle == 'المستهلك'
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
                            value: widget.rememberMe,
                          ),
                        )
                      ],
                    ),
              widget.accountTitle == 'المستهلك'
                  ? Container()
                  : const TextSignup(text: "نسخة من رخصة تجارية"),
              widget.accountTitle == 'المستهلك'
                  ? Container()
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          image: const DecorationImage(
                              image: AssetImage("assets/images/logo.png"),
                              fit: BoxFit.cover)),
                    ),
              widget.accountTitle == 'المستهلك'
                  ? Container()
                  : const TextSignup(text: "عدد منتجات الشركة"),
              widget.accountTitle == 'المستهلك'
                  ? Container()
                  : TextFormSignupWidget(
                      password: false,
                      isNumber: false,
                      valid: (val) {
                        return null;

                        // return validInput(val!, 5, 100, "password");
                      },
                      myController: widget.companyProductsNumber,
                    ),
              widget.accountTitle == 'المستهلك'
                  ? Container()
                  : const TextSignup(
                      text: "طريقة البيع (البيع بالتجزئة أو بالجملة)",
                    ),
              widget.accountTitle == 'المستهلك'
                  ? Container()
                  : TextFormSignupWidget(
                      password: false,
                      isNumber: false,
                      valid: (val) {
                        return null;

                        // return validInput(val!, 5, 100, "password");
                      },
                      myController: widget.sellType,
                    ),
              widget.accountTitle == 'المستهلك'
                  ? Container()
                  : const TextSignup(
                      text: "أين تبيع (لأي بلد)",
                    ),
              widget.accountTitle == 'المستهلك'
                  ? Container()
                  : TextFormSignupWidget(
                      password: false,
                      isNumber: false,
                      valid: (val) {
                        return null;

                        // return validInput(val!, 5, 100, "password");
                      },
                      myController: widget.toCountry,
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
              widget.accountTitle == 'المستهلك'
                  ? Container()
                  : const TextSignup(
                      text: "صورة البانر",
                    ),
              widget.accountTitle == 'المستهلك'
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
                margin:
                    const EdgeInsets.only(left: 60, right: 60, bottom: 20).r,
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
                      onPressed: () {
                        if (!widget.formKey!.currentState!.validate()) return;
                        widget.bloc.add(SignUpRequested(
                          username: widget.username.text,
                          email: widget.emailSignup.text,
                          password: widget.passwordSignup.text,
                          userType: 'user',
                          firstMobile: widget.numberPhoneOne.text,
                          isFreeZoon: true,
                        ));
                      },
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
      ),
    );
  }
}
