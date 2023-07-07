import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constant/colors.dart';
import '../../core/widgets/screen_loader.dart';
import '../../utils/app_localizations.dart';

class RefundScreen extends StatefulWidget {
  const RefundScreen({super.key});

  @override
  State<RefundScreen> createState() => _RefundScreenState();
}

class _RefundScreenState extends State<RefundScreen>
    with ScreenLoader<RefundScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController nameController = TextEditingController();
  late TextEditingController accountNameController = TextEditingController();
  late TextEditingController bankNameController = TextEditingController();
  late TextEditingController ibanController = TextEditingController();
  late TextEditingController phoneController = TextEditingController();

  final GlobalKey<FormFieldState> _nameFormFieldKey =
      GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _accountNameFormFieldKey =
      GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _bankNameFormFieldKey =
      GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _ibanFormFieldKey =
      GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _phoneFormFieldKey =
      GlobalKey<FormFieldState>();

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_rounded,
            color: AppColor.backgroundColor,
          ),
        ),
        title: Text(
          AppLocalizations.of(context).translate('refund_request'),
          style: const TextStyle(
            color: AppColor.backgroundColor,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    AppLocalizations.of(context)
                        .translate('please_fill_in_the_following_information'),
                    style: TextStyle(
                      color: AppColor.backgroundColor,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                TextFormField(
                  style: const TextStyle(color: Colors.black),
                  controller: nameController,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(color: AppColor.backgroundColor),
                    hintText:
                        AppLocalizations.of(context).translate('full_name'),
                    border: const OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10)
                            .flipped,
                  ),
                  onChanged: (text) {
                    _nameFormFieldKey.currentState?.validate();
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return AppLocalizations.of(context).translate('required');
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                TextFormField(
                  style: const TextStyle(color: Colors.black),
                  controller: accountNameController,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(color: AppColor.backgroundColor),
                    hintText:
                        AppLocalizations.of(context).translate('account_name'),
                    border: const OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10)
                            .flipped,
                  ),
                  onChanged: (text) {
                    _accountNameFormFieldKey.currentState?.validate();
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return AppLocalizations.of(context).translate('required');
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                TextFormField(
                  style: const TextStyle(color: Colors.black),
                  controller: bankNameController,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(color: AppColor.backgroundColor),
                    hintText:
                        AppLocalizations.of(context).translate('bank_name'),
                    border: const OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10)
                            .flipped,
                  ),
                  onChanged: (text) {
                    _bankNameFormFieldKey.currentState?.validate();
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return AppLocalizations.of(context).translate('required');
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                TextFormField(
                  style: const TextStyle(color: Colors.black),
                  controller: ibanController,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(color: AppColor.backgroundColor),
                    hintText: AppLocalizations.of(context).translate('IBAN'),
                    border: const OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10)
                            .flipped,
                  ),
                  onChanged: (text) {
                    _ibanFormFieldKey.currentState?.validate();
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return AppLocalizations.of(context).translate('required');
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                TextFormField(
                  style: const TextStyle(color: Colors.black),
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(color: AppColor.backgroundColor),
                    hintText:
                        AppLocalizations.of(context).translate('phone_number'),
                    border: const OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10)
                            .flipped,
                  ),
                  onChanged: (text) {
                    _phoneFormFieldKey.currentState?.validate();
                  },
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.phone,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return AppLocalizations.of(context).translate('required');
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: InkWell(
                    onTap: () {
                      if (!_formKey.currentState!.validate()) return;
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 40.h,
                      width: double.infinity,
                      color: AppColor.backgroundColor,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).translate('send'),
                          style:
                              TextStyle(fontSize: 15.sp, color: AppColor.white),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
