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
import 'package:netzoon/presentation/legal_advice/legal_advice_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../cart/blocs/cart_bloc/cart_bloc_bloc.dart';
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SettingsCategory(
            name: AppLocalizations.of(context).translate('legal_advices'),
            icon: Icons.gavel_rounded,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const LegalAdviceScreen();
                  },
                ),
              );
            },
          ),
          // SizedBox(
          //   height: 10.h,
          // ),
          // SettingsCategory(
          //   name: AppLocalizations.of(context).translate('vacancies'),
          //   icon: Icons.work,
          //   onTap: () {
          //     // Navigator.of(context).push(
          //     //   MaterialPageRoute(
          //     //     builder: (context) {
          //     //       return const MobileLoginScreen();
          //     //     },
          //     //   ),
          //     // );
          //   },
          // ),
          // SizedBox(
          //   height: 10.h,
          // ),
          // SettingsCategory(
          //   name: AppLocalizations.of(context).translate('country'),
          //   icon: Icons.location_city,
          //   onTap: () {
          //     // Navigator.of(context).push(
          //     //   MaterialPageRoute(
          //     //     builder: (context) {
          //     //       return const LanguagesScreen();
          //     //     },
          //     //   ),
          //     // );
          //   },
          // ),
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
        ],
      ),
    );
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
