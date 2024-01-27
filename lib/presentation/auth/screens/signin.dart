import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:netzoon/presentation/auth/blocs/sign_in/sign_in_bloc.dart';
import 'package:netzoon/presentation/auth/screens/complete_signup_screen.dart';
import 'package:netzoon/presentation/auth/screens/forget_password_screen.dart';
import 'package:netzoon/presentation/auth/screens/user_type.dart';
import 'package:netzoon/presentation/auth/widgets/password_control.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with ScreenLoader<SignInScreen> {
  _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');

    if (savedEmail != null && savedPassword != null) {
      _emailController.text = savedEmail;
      _passwordController.text = savedPassword;
    }
  }

  _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', _emailController.text);
    prefs.setString('password', _passwordController.text);
  }

  final signInBloc = sl<SignInBloc>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormFieldState> _emailFormFieldKey =
      GlobalKey<FormFieldState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final authBloc = sl<AuthBloc>();

  @override
  void initState() {
    _loadSavedCredentials();
    super.initState();
  }

  @override
  Widget screen(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      bloc: signInBloc,
      listener: (context, state) async {
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
          await SendbirdChat.connect(state.user.userInfo.username ?? '');
          await SendbirdChat.updateCurrentUserInfo(
              nickname: state.user.userInfo.username,
              profileFileInfo: FileInfo.fromFileUrl(
                  fileUrl: state.user.userInfo.profilePhoto));
          stopLoading();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              AppLocalizations.of(context).translate('success'),
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ));
          // Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          //     CupertinoPageRoute(builder: (context) {
          //   return const TestScreen();
          // }), (route) => false);
          while (context.canPop()) {
            context.pop();
          }
          context.push('/home');
        }
      },
      child: BlocListener<AuthBloc, AuthState>(
        bloc: authBloc,
        listener: (context, state) async {
          if (state is SigninWithFacebookInProgress) {
            startLoading();
          } else if (state is SigninWithFacebookFailure) {
            stopLoading();

            const failure = 'error';
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  failure,
                  style: TextStyle(
                    color: AppColor.white,
                  ),
                ),
                backgroundColor: AppColor.red,
              ),
            );
          } else if (state is SigninWithFacebookSuccess) {
            await SendbirdChat.connect(state.userData["name"]);
            await SendbirdChat.updateCurrentUserInfo(
                nickname: state.userData["name"],
                profileFileInfo: FileInfo.fromFileUrl(
                    fileUrl: state.userData["picture"]["data"]["url"]));
            stopLoading();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                AppLocalizations.of(context).translate('success'),
              ),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ));
            authBloc.add(OAuthSignEvent(
                email: state.userData["email"],
                username: state.userData["name"],
                profilePhoto: state.userData["picture"]["data"]["url"]));
          }
        },
        child: BlocListener<AuthBloc, AuthState>(
          bloc: authBloc,
          listener: (context, state2) {
            if (state2 is OAuthSignInProgress) {
              startLoading();
            } else if (state2 is OAuthSignFailure) {
              stopLoading();

              const failure = 'error';
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    failure,
                    style: TextStyle(
                      color: AppColor.white,
                    ),
                  ),
                  backgroundColor: AppColor.red,
                ),
              );
            } else if (state2 is OAuthSignSuccess) {
              stopLoading();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  AppLocalizations.of(context).translate('success'),
                ),
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ));
              if (state2.user.message == 'User created') {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return CompleteSignupScreen(
                        userId: state2.user.userInfo.id,
                        name: state2.user.userInfo.username ?? '',
                        email: state2.user.userInfo.email ?? '',
                        profilePhoto: state2.user.userInfo.profilePhoto ?? '');
                  },
                ));
              } else {
                while (context.canPop()) {
                  context.pop();
                }
                context.push('/home');
              }
            }
          },
          child: BlocListener<AuthBloc, AuthState>(
            bloc: authBloc,
            listener: (context, googleState) async {
              if (googleState is SigninWithGoogleInProgress) {
                startLoading();
              } else if (googleState is SigninWithGoogleFailure) {
                stopLoading();

                const failure = 'error';
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      failure,
                      style: TextStyle(
                        color: AppColor.white,
                      ),
                    ),
                    backgroundColor: AppColor.red,
                  ),
                );
              } else if (googleState is SigninWithGoogleSuccess) {
                await SendbirdChat.connect(googleState.username);
                await SendbirdChat.updateCurrentUserInfo(
                    nickname: googleState.username,
                    profileFileInfo:
                        FileInfo.fromFileUrl(fileUrl: googleState.profile));
                stopLoading();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    AppLocalizations.of(context).translate('success'),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ));
                authBloc.add(OAuthSignEvent(
                    email: googleState.email,
                    username: googleState.username,
                    profilePhoto: googleState.profile));
              }
            },
            child: BlocListener<AuthBloc, AuthState>(
              bloc: authBloc,
              listener: (context, appleState) async {
                if (appleState is SigninWithAppleInProgress) {
                  startLoading();
                } else if (appleState is SigninWithAppleFailure) {
                  stopLoading();

                  const failure = 'error';
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        failure,
                        style: TextStyle(
                          color: AppColor.white,
                        ),
                      ),
                      backgroundColor: AppColor.red,
                    ),
                  );
                } else if (appleState is SigninWithAppleSuccess) {
                  await SendbirdChat.connect(appleState.username);
                  await SendbirdChat.updateCurrentUserInfo(
                    nickname: appleState.username,
                  );
                  stopLoading();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      AppLocalizations.of(context).translate('success'),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ));
                  authBloc.add(OAuthSignEvent(
                      email: appleState.email,
                      username: appleState.username,
                      profilePhoto: 'https://i.imgur.com/hnIl9uM.jpg'));
                }
              },
              child: Scaffold(
                body: Form(
                  key: _formKey,
                  child: AutofillGroup(
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
                                  AppLocalizations.of(context)
                                      .translate('welcome'),
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
                                  autofillHints: const [AutofillHints.email],
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
                                            errorText: AppLocalizations.of(
                                                    context)
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
                                  labelText: AppLocalizations.of(context)
                                      .translate('password'),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return const ForgetPasswordScreen();
                                            },
                                          ),
                                        );
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate('password_forget'),
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontSize: 13.sp,
                                          color: AppColor.secondGrey,
                                        ),
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
                                  height: 10.h,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        AppColor.backgroundColor,
                                      ),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      )),
                                    ),
                                    child: Text(AppLocalizations.of(context)
                                        .translate('login')),
                                    onPressed: () async {
                                      if (!_formKey.currentState!.validate()) {
                                        return;
                                      }
                                      _saveCredentials();
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
                                    SocialIcon(
                                      imagePath:
                                          'assets/images/google_icon.png',
                                      onTap: () {
                                        authBloc.add(SigninWithGoogleEvent());
                                      },
                                    ),
                                    SizedBox(
                                      width: 7.w,
                                    ),
                                    SocialIcon(
                                      imagePath:
                                          'assets/images/facebook_icon.png',
                                      onTap: () {
                                        authBloc.add(SigninWithFacebookEvent());
                                      },
                                    ),
                                    SizedBox(
                                      width: 7.w,
                                    ),
                                    SocialIcon(
                                      imagePath: 'assets/images/mac_icon.png',
                                      onTap: () {
                                        authBloc.add(SigninWithAppleEvent());
                                      },
                                    ),
                                  ],
                                ),
                                // SignInWithAppleButton(
                                //   onPressed: () async {
                                //     final credential = await SignInWithApple
                                //         .getAppleIDCredential(
                                //       scopes: [
                                //         AppleIDAuthorizationScopes.email,
                                //         AppleIDAuthorizationScopes.fullName,
                                //       ],
                                //     );

                                //     print(credential);

                                //     // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                                //     // after they have been validated with Apple (see `Integration` section for more information on how to do this)
                                //   },
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }
}

class SocialIcon extends StatelessWidget {
  const SocialIcon({
    super.key,
    required this.imagePath,
    this.onTap,
  });
  final String imagePath;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        imagePath,
        height: 40.h,
        width: 40.w,
        fit: BoxFit.contain,
      ),
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
