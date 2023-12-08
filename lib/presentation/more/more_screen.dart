import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/data/core/constants/constants.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:netzoon/presentation/contact/screens/contact_us_screen.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:netzoon/presentation/language_screen/blocs/language_bloc/language_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../cart/blocs/cart_bloc/cart_bloc_bloc.dart';
import '../legal_advice/legal_advice_screen.dart';
import '../start_screen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> with ScreenLoader<MoreScreen> {
  final List<Map<String, String>> languages = [
    {'name': 'English', 'code': 'en'},
    {'name': 'Arabic', 'code': 'ar'},
  ];

  // Define the current language and its code
  String currentLanguage = 'Arabic';
  String currentCode = 'ar';

  void showLanguageDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              // margin: const EdgeInsets.only(bottom: 60),
              color: AppColor.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Loop through the languages and create radio buttons
                  for (var language in languages)
                    RadioListTile<String>(
                      activeColor: AppColor.backgroundColor,
                      title: Text(
                        AppLocalizations.of(context)
                            .translate(language['name']!),
                        style: const TextStyle(color: AppColor.backgroundColor),
                      ),
                      value: language['code'] ?? '',
                      groupValue: currentCode,
                      onChanged: (value) {
                        // Update the state when a radio button is selected
                        setState(() {
                          currentCode = value!;
                          currentLanguage = language['name']!;
                        });
                        BlocProvider.of<LanguageBloc>(context)
                            .add(ChooseOnetherLang(currentCode));
                        // Close the dialog after selection
                        Navigator.pop(context);
                      },
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  late String? isLoggedIn = '';

  void getIsLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getString(SharedPreferencesKeys.user);
    });
  }

  // void _shareLink(String platform) async {
  //   String link = '';
  //   if (platform == 'Android') {
  //     link =
  //         'https://play.google.com/store/apps/details?id=com.netzoon.netzoon_app';
  //   } else if (platform == 'iOS') {
  //     link = 'https://apps.apple.com/ae/app/netzoon/id6467718964';
  //   }

  //   await Share.share(
  //     'Download netzoon app: $link',
  //     subject: 'Share netzoon app link',
  //     sharePositionOrigin: Rect.fromPoints(
  //       const Offset(2, 2),
  //       const Offset(3, 3),
  //     ),
  //   );
  // }

  @override
  void initState() {
    getIsLoggedIn();
    final SharedPreferences preferences = sl<SharedPreferences>();
    currentCode = preferences.getString(SharedPreferencesKeys.language) ?? 'ar';
    currentLanguage = currentCode == 'en' ? 'English' : 'Arabic';
    super.initState();
  }

  final authBloc = sl<AuthBloc>();
  @override
  Widget screen(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: authBloc,
      listener: (context, deleteState) {
        if (deleteState is DeleteAccountInProgress) {
          startLoading();
        } else if (deleteState is DeleteAccountFailure) {
          stopLoading();

          final failure = deleteState.message;
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
        } else if (deleteState is DeleteAccountSuccess) {
          stopLoading();

          final cartBloc = context.read<CartBlocBloc>();
          cartBloc.add(ClearCart());

          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              CupertinoPageRoute(builder: (context) {
            return const StartScreen();
          }), (route) => false);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SettingsCategory(
              name: AppLocalizations.of(context).translate('privacy_policy'),
              icon: Icons.policy_outlined,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const LegalAdviceScreen();
                      // return const StripeTestScreen();
                    },
                  ),
                );
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            SettingsCategory(
              name: AppLocalizations.of(context).translate('language'),
              icon: Icons.language,
              onTap: () {
                showLanguageDialog(context);
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) {
                //       return const LanguagesScreen();
                //     },
                //   ),
                // );
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            SettingsCategory(
              name: AppLocalizations.of(context).translate('contact_us'),
              icon: Icons.email,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const ContactUsScreen();
                    },
                  ),
                );
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            Builder(builder: (context) {
              return SettingsCategory(
                name:
                    AppLocalizations.of(context).translate('share_netzoon_app'),
                icon: Icons.share,
                onTap: () async {
                  // Determine the current platform
                  String appStoreLink;
                  if (Platform.isIOS) {
                    appStoreLink =
                        'https://apps.apple.com/ae/app/netzoon/id6467718964';
                  } else if (Platform.isAndroid) {
                    appStoreLink =
                        'https://play.google.com/store/apps/details?id=com.netzoon.netzoon_app';
                  } else {
                    return;
                  }

                  await Share.share(
                    'Download netzoon app: $appStoreLink',
                    subject: 'Share netzoon app link',
                    sharePositionOrigin: Rect.fromPoints(
                      const Offset(2, 2),
                      const Offset(3, 3),
                    ),
                  );
                },
              );
            }),
            // Builder(builder: (context) {
            //   return SettingsCategory(
            //     name:
            //         AppLocalizations.of(context).translate('share_netzoon_app'),
            //     icon: Icons.share,
            //     onTap: () async {
            //       showModalBottomSheet(
            //         context: context,
            //         builder: (BuildContext context) {
            //           return Column(
            //             mainAxisSize: MainAxisSize.min,
            //             children: <Widget>[
            //               ListTile(
            //                 leading: const Icon(Icons.android),
            //                 title: Text(AppLocalizations.of(context)
            //                     .translate('play_store')),
            //                 onTap: () {
            //                   Navigator.pop(context);
            //                   _shareLink('Android');
            //                 },
            //               ),
            //               ListTile(
            //                 leading: const Icon(Icons.phone_iphone),
            //                 title: Text(AppLocalizations.of(context)
            //                     .translate('apple_store')),
            //                 onTap: () {
            //                   Navigator.pop(context);
            //                   _shareLink('iOS');
            //                 },
            //               ),
            //             ],
            //           );
            //         },
            //       );
            //     },
            //   );
            // }),
            SizedBox(
              height: 10.h,
            ),
            isLoggedIn != null && isLoggedIn != ''
                ? SettingsCategory(
                    name: AppLocalizations.of(context).translate('logout'),
                    icon: Icons.logout,
                    onTap: () {
                      final cartBloc = context.read<CartBlocBloc>();
                      cartBloc.add(ClearCart());
                      authBloc.add(AuthLogout());

                      Navigator.of(context, rootNavigator: true)
                          .pushAndRemoveUntil(
                              CupertinoPageRoute(builder: (context) {
                        return const StartScreen();
                      }), (route) => false);
                    },
                  )
                : const SizedBox(),
            SizedBox(
              height: 10.h,
            ),
            isLoggedIn != null && isLoggedIn != ''
                // ? SettingsCategory(
                //     name: AppLocalizations.of(context)
                //         .translate('delete_my_account'),
                //     icon: Icons.remove_circle,
                //     onTap: () {
                //       authBloc.add(DeleteMyAccountEvent());
                //     },
                //   )
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: InkWell(
                        onTap: () async {
                          bool isSubmit = await _showDeleteAccountDialog();
                          isSubmit == true
                              ? authBloc.add(DeleteMyAccountEvent())
                              : null;
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 60.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: AppColor.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: AppColor.red)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.remove_circle_rounded,
                                color: AppColor.red,
                                size: 20.sp,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                AppLocalizations.of(context)
                                    .translate('delete_my_account'),
                                style: TextStyle(
                                    fontSize: 15.sp, color: AppColor.red),
                              ),
                            ],
                          ),
                        )),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Future<bool> _showDeleteAccountDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                AppLocalizations.of(context).translate('delete_my_account'),
                style: const TextStyle(color: AppColor.backgroundColor),
              ),
              content: Text(
                AppLocalizations.of(context).translate(
                    'Are you sure you want to delete your account ?!'),
                style: const TextStyle(color: AppColor.black),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
              contentTextStyle: TextStyle(fontSize: 14.0.sp),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // User does not consent
                  },
                  child: Text(
                    AppLocalizations.of(context).translate('No'),
                    style: const TextStyle(color: AppColor.backgroundColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // User consents
                  },
                  child: Text(
                    AppLocalizations.of(context).translate('Yes'),
                    style: const TextStyle(color: AppColor.backgroundColor),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}

class SettingsCategory extends StatelessWidget {
  const SettingsCategory({
    super.key,
    required this.name,
    this.onTap,
    this.icon,
  });
  final String name;
  final void Function()? onTap;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: InkWell(
          onTap: onTap,
          child: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 60.h,
            width: double.infinity,
            color: AppColor.backgroundColor,
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppColor.white,
                  size: 20.sp,
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  name,
                  style: TextStyle(fontSize: 15.sp, color: AppColor.white),
                ),
              ],
            ),
          )),
    );
  }
}
