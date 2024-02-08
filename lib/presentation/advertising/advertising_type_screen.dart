import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/advertising/add_ads_page.dart';
import 'package:netzoon/presentation/advertising/user_items_screen.dart';
import 'package:netzoon/presentation/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';

import '../core/constant/colors.dart';
import '../utils/app_localizations.dart';

class AdvertisingTypeScreen extends StatefulWidget {
  const AdvertisingTypeScreen({super.key});

  @override
  State<AdvertisingTypeScreen> createState() => _AdvertisingTypeScreenState();
}

class _AdvertisingTypeScreenState extends State<AdvertisingTypeScreen> {
  final items = [
    'car',
    'planes',
    'sea_companies',
    'real_estate',
    'product',
    'service',
    "delivery_service",
    "user",
  ];
  String selectedValue = 'product';

  final authBloc = sl<AuthBloc>();
  @override
  void initState() {
    authBloc.add(AuthCheckRequested());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BackgroundWidget(
      isHome: false,
      widget: Padding(
        padding: const EdgeInsets.only(
          top: 4.0,
          bottom: 20,
          right: 8.0,
          left: 8.0,
        ),
        child: SingleChildScrollView(
          child: BlocBuilder<AuthBloc, AuthState>(
            bloc: authBloc,
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      AppLocalizations.of(context).translate('add_ads'),
                      style: TextStyle(
                        color: AppColor.backgroundColor,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('add_ads_head'),
                    style: TextStyle(
                      color: AppColor.colorOne,
                      fontSize: 11.sp,
                    ),
                  ),
                  const Divider(
                    color: AppColor.secondGrey,
                    thickness: 0.2,
                    endIndent: 30,
                    indent: 30,
                  ),
                  Text(
                    '${AppLocalizations.of(context).translate('department')} :',
                    style: TextStyle(
                      color: AppColor.backgroundColor,
                      fontSize: 16.sp,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 10)
                            .r,
                    // Add some padding and a background color
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColor.backgroundColor,
                        )),
                    // Create the dropdown button
                    child: DropdownButton<String>(
                      itemHeight: 45.h,
                      // Set the selected value
                      value: selectedValue,
                      // Handle the value change
                      onChanged: (String? newValue) {
                        setState(() => selectedValue = newValue ?? '');
                      },
                      // Map each option to a widget

                      items:
                          items.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          // Use a colored box to show the option
                          child: Text(
                            AppLocalizations.of(context).translate(value),
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return UserItemsScreen(
                            category: selectedValue,
                            userId: state is Authenticated
                                ? state.user.userInfo.id
                                : null,
                          );
                        },
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.white,
                      foregroundColor: AppColor.backgroundColor,
                      side: const BorderSide(
                        color: AppColor.backgroundColor,
                        width: 1,
                      ),
                      fixedSize: Size(double.maxFinite, 40.h),
                    ),
                    child: Text(AppLocalizations.of(context)
                        .translate('select_from_my_profile')),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  const Center(
                    child: Text(
                      'or',
                      style: TextStyle(),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return AddAdsPage(
                            department: selectedValue,
                          );
                        },
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.white,
                      foregroundColor: AppColor.backgroundColor,
                      side: const BorderSide(
                        color: AppColor.backgroundColor,
                        width: 1,
                      ),
                      fixedSize: Size(double.maxFinite, 40.h),
                    ),
                    child: Text(AppLocalizations.of(context)
                        .translate('add_something_new')),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    ));
  }
}
