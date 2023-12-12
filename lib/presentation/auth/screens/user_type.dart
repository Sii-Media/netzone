import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/auth/screens/signup.dart';
import 'package:netzoon/presentation/auth/widgets/background_auth_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class UserType extends StatefulWidget {
  const UserType({super.key, this.withAdd});
  final bool? withAdd;
  @override
  State<UserType> createState() => _UserTypeState();
}

class _UserTypeState extends State<UserType> {
  @override
  Widget build(BuildContext context) {
    final List<String> items = [
      'الشركات المحلية',
      'شركة عقارات',
      "تاجر",
      'السيارات',
      'الشركات البحرية',
      'المستهلك',
      'منطقة حرة',
      'المصانع',
      'جهة إخبارية',
      'شركة توصيل'
    ];
    String? selectedValue;

    return BackgroundAuthWidget(
      topLogo: 0.35,
      onTap: () {
        Navigator.of(context).pop();
      },
      topBack: 210,
      topWidget: 240,
      topTitle: 170,
      n: 0.35,
      title: AppLocalizations.of(context).translate('create_new_account'),
      widget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).translate('who_are_you'),
              style: TextStyle(fontSize: 25.sp, color: Colors.black),
            ),
            SizedBox(
              // width: MediaQuery.of(context).size.width,
              child: DropdownButton2(
                isExpanded: true,
                hint: Row(
                  children: [
                    const SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: Text(
                        selectedValue ??
                            AppLocalizations.of(context)
                                .translate('choose_user_type'),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColor.black,
                        ),
                      ),
                    ),
                  ],
                ),
                items: items
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            AppLocalizations.of(context).translate(item),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                value: selectedValue,
                style: TextStyle(fontSize: 10.sp),
                onChanged: (value) {
                  setState(() {
                    selectedValue = value as String;

                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return SignUpPage(
                        accountTitle: selectedValue ?? '',
                        withAdd: widget.withAdd,
                      );
                    }));
                  });
                  // print(items);
                  // setState(() {
                  //   selectedValue = value as String;
                  // });
                },
                buttonStyleData: ButtonStyleData(
                  height: 40.h,
                  width: MediaQuery.of(context).size.width - 30.w,
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                      color: Colors.black26,
                    ),
                    color: Colors.white,
                  ),
                  elevation: 2,
                ),
                iconStyleData: IconStyleData(
                  icon: const Icon(
                    color: AppColor.backgroundColor,
                    Icons.arrow_downward_rounded,
                  ),
                  iconSize: 14.sp,
                  iconEnabledColor: Colors.black,
                  iconDisabledColor: Colors.grey,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200.h,
                  width: 200.w,
                  padding: null,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
