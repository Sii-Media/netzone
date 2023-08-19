import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:netzoon/presentation/auth/screens/signin.dart';
import 'package:netzoon/presentation/auth/screens/user_type.dart';
import 'package:netzoon/presentation/auth/widgets/button_auth_widget.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/profile/screens/my_news_profile_screen.dart';
import 'package:netzoon/presentation/profile/screens/my_realestate_company_profile_screen.dart';
import 'package:netzoon/presentation/profile/screens/my_vehicle_profile_screen.dart';
import 'package:netzoon/presentation/profile/screens/profile_screen.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../../profile/screens/local_company_profile_screen.dart';
import '../../profile/screens/my_delivery_company_profile_screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  late TextEditingController emailController;
  late bool? isLoggedIn = false;
  final authBloc = sl<AuthBloc>();
  @override
  void initState() {
    authBloc.add(AuthCheckRequested());
    super.initState();
  }

  // void getIsLoggedIn() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   print(prefs.getString(SharedPreferencesKeys.user));
  //   setState(() {
  //     // isLoggedIn = prefs.getBool('IsLoggedIn');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: authBloc,
      builder: (context, state) {
        if (state is AuthInProgress) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColor.backgroundColor,
            ),
          );
        } else if (state is Unauthenticated) {
          return Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                // decoration: const BoxDecoration(
                //   color: Color(0xFF5776a5),
                // ),
              ),
              // Container(
              //   height: MediaQuery.of(context).size.height,
              //   decoration: const BoxDecoration(
              //     image: DecorationImage(
              //       image: AssetImage("assets/images/asd.png"),
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
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
                                image: AssetImage(
                                    "assets/images/netzoon-logo.png"),
                                fit: BoxFit.cover),
                          ),
                        ),
                        // isLoggedIn == false?
                        Column(
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
                              text: AppLocalizations.of(context)
                                  .translate('login'),
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
                            Text(
                              "- ${AppLocalizations.of(context).translate('or')} -",
                              style: const TextStyle(
                                  color: AppColor.backgroundColor),
                            ),
                            SizedBox(
                              height: 7.h,
                            ),
                            ButtonAuthWidget(
                              color: AppColor.backgroundColor.withOpacity(0.5),
                              colorText: AppColor.white,
                              text: AppLocalizations.of(context)
                                  .translate('create_new_account'),
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
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (state is Authenticated) {
          if (state.user.userInfo.userType == 'user') {
            return UserProfileScreen(
              userId: state.user.userInfo.id,
            );
          } else if (state.user.userInfo.userType == 'local_company' ||
              state.user.userInfo.userType == 'trader' ||
              state.user.userInfo.userType == 'freezone' ||
              state.user.userInfo.userType == 'factory') {
            return MyLocalCompanyProfileScreen(
              userId: state.user.userInfo.id,
            );
          } else if (state.user.userInfo.userType == 'real_estate') {
            return MyRealEstateCompanyProfileScreen(
                userId: state.user.userInfo.id);
          } else if (state.user.userInfo.userType == 'car' ||
              state.user.userInfo.userType == 'planes') {
            return MyVehicleProfileScreen(
                userId: state.user.userInfo.id,
                type: state.user.userInfo.userType ?? '');
          } else if (state.user.userInfo.userType == 'news_agency') {
            return MyNewsProfileScreen(
              userId: state.user.userInfo.id,
            );
          } else if (state.user.userInfo.userType == 'delivery_company') {
            return MyDeliveryCompanyProfileScreen(
              userId: state.user.userInfo.id,
            );
          }
        }
        return Container();
      },
    );
  }
}
