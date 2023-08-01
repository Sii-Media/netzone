import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/auth/blocs/sign_in/sign_in_bloc.dart';
import 'package:netzoon/presentation/auth/screens/user_type.dart';
import 'package:netzoon/presentation/auth/widgets/password_control.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:netzoon/presentation/home/test.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with ScreenLoader<SignInScreen> {
  final signInBloc = sl<SignInBloc>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormFieldState> _emailFormFieldKey =
      GlobalKey<FormFieldState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget screen(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      bloc: signInBloc,
      listener: (context, state) {
        if (state is SignInInProgress) {
          startLoading();
        } else if (state is SignInFailure) {
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
        } else if (state is SignInSuccess) {
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
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: BackgroundWidget(
            isHome: false,
            widget: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.h,
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
                        AppLocalizations.of(context).translate('welcome'),
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColor.mainGrey,
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      TextFormField(
                        key: _emailFormFieldKey,
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'example@example.example',
                          labelText: AppLocalizations.of(context)
                              .translate('email_or_phone'),
                        ),
                        style: const TextStyle(color: AppColor.black),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onChanged: (text) {
                          _emailFormFieldKey.currentState!.validate();
                        },
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return AppLocalizations.of(context)
                                .translate('email_condition');
                          }

                          if (!EmailValidator(
                                  errorText: AppLocalizations.of(context)
                                      .translate('email_not_valid'))
                              .isValid(text.toLowerCase())) {
                            return AppLocalizations.of(context)
                                .translate('input_valid_email');
                          }

                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      PasswordControl(
                        hintText: '* * * * * * * *',
                        labelText:
                            AppLocalizations.of(context).translate('password'),
                        controller: _passwordController,
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: AppLocalizations.of(context)
                                  .translate('password_required')),
                          MinLengthValidator(8,
                              errorText: AppLocalizations.of(context)
                                  .translate('password_condition')),
                        ]),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            AppLocalizations.of(context)
                                .translate('password_forget'),
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 13.sp,
                              color: AppColor.secondGrey,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const UserType();
                                  },
                                ),
                              );
                            },
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('create_new_account'),
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 13.sp,
                                color: AppColor.backgroundColor,
                              ),
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
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            )),
                          ),
                          child: Text(
                              AppLocalizations.of(context).translate('login')),
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) return;
                            signInBloc.add(SignInRequestEvent(
                                email: _emailController.text,
                                password: _passwordController.text));
                            // final SharedPreferences sharedPreferences =
                            //     await SharedPreferences.getInstance();
                            // sharedPreferences.setString(
                            //     'email', _emailController.text);
                          },
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
                              AppLocalizations.of(context)
                                  .translate('or_continue_with'),
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
    required this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final bool obsecure;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obsecure,
      validator: validator,
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
