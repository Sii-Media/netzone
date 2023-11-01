import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/presentation/profile/screens/refund_screen.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../../core/constant/colors.dart';

class CreditScreen extends StatefulWidget {
  final UserInfo user;
  const CreditScreen({super.key, required this.user});

  @override
  State<CreditScreen> createState() => _CreditScreenState();
}

class _CreditScreenState extends State<CreditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.h,
        backgroundColor: AppColor.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_rounded,
            color: AppColor.backgroundColor,
            size: 22.sp,
          ),
        ),
        title: Text(
          AppLocalizations.of(context).translate('NetZoon Credits'),
          style: const TextStyle(color: AppColor.backgroundColor),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 100.h,
                decoration: BoxDecoration(
                    color: AppColor.backgroundColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)
                          .translate('available_balance'),
                      style: TextStyle(
                        color: AppColor.mainGrey,
                        fontSize: 15.sp,
                      ),
                    ),
                    Text(
                      '${widget.user.netzoonBalance} ${AppLocalizations.of(context).translate('AED')}',
                      style: TextStyle(
                        color: AppColor.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 5),
                      color: AppColor.backgroundColor.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    AppLocalizations.of(context).translate('balance_request'),
                    style: TextStyle(
                        color: AppColor.backgroundColor,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context)
                        .translate('submit_a_refund_request'),
                    style: TextStyle(
                      color: AppColor.backgroundColor,
                      fontSize: 17.sp,
                    ),
                  ),
                  leading: Icon(
                    Icons.credit_card,
                    size: 34.sp,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15.sp,
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const RefundScreen();
                    }));
                  },
                ),
              )
            ],
          )),
    );
  }
}
