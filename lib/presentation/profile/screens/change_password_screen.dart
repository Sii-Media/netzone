import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';

import '../../../injection_container.dart';
import '../../auth/blocs/change_password/change_password_bloc.dart';
import '../../core/constant/colors.dart';
import '../../utils/app_localizations.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    with ScreenLoader<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  final GlobalKey<FormFieldState> currentPasswordFormFieldKey =
      GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> newPasswordFormFieldKey =
      GlobalKey<FormFieldState>();

  bool showPass = true;

  final passwordBloc = sl<ChangePasswordBloc>();

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
          title: const Text(
            'Change Password',
            style: TextStyle(
              color: AppColor.backgroundColor,
            ),
          ),
        ),
        body: BlocListener<ChangePasswordBloc, ChangePasswordState>(
          bloc: passwordBloc,
          listener: (context, state) {
            if (state is ChangePasswordInProgress) {
              startLoading();
            } else if (state is ChangePasswordFailure) {
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
            } else if (state is ChangePasswordSuccess) {
              stopLoading();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  AppLocalizations.of(context).translate('success'),
                ),
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Password',
                    style: TextStyle(color: AppColor.backgroundColor),
                  ),
                  TextFormField(
                    key: currentPasswordFormFieldKey,
                    controller: _currentPasswordController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: InputDecoration(
                      // hintText: 'Current Password',
                      //<-- SEE HERE
                      // fillColor: Colors.green.withOpacity(0.1),
                      // floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 5, horizontal: 8)
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

                      // border: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(2),
                      // ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,

                    obscureText: showPass,
                    // textInputAction: widget.textInputAction ?? TextInputAction.done,
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: AppLocalizations.of(context)
                              .translate('password_required')),
                      MinLengthValidator(8,
                          errorText: AppLocalizations.of(context)
                              .translate('password_condition')),
                    ]),
                    onChanged: (text) {
                      currentPasswordFormFieldKey.currentState!.validate();
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  const Text(
                    'New Password',
                    style: TextStyle(color: AppColor.backgroundColor),
                  ),
                  TextFormField(
                    key: newPasswordFormFieldKey,
                    controller: _newPasswordController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: InputDecoration(
                      // hintText: 'New Password',
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 5, horizontal: 8)
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
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    obscureText: showPass,
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: AppLocalizations.of(context)
                              .translate('password_required')),
                      MinLengthValidator(8,
                          errorText: AppLocalizations.of(context)
                              .translate('password_condition')),
                    ]),
                    onChanged: (text) {
                      newPasswordFormFieldKey.currentState!.validate();
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;

                        passwordBloc.add(ChangePasswordRequestedEvent(
                            currentPassword: _currentPasswordController.text,
                            newPassword: _newPasswordController.text));
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          AppColor.backgroundColor,
                        ),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                        fixedSize: const MaterialStatePropertyAll(
                          Size.fromWidth(200),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'save_changes',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
