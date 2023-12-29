import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String token;
  const ResetPasswordScreen({super.key, required this.token});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with ScreenLoader<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormFieldState> _passwordFormFieldKey =
      GlobalKey<FormFieldState>();

  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormFieldState> _confirmPasswordFormFieldKey =
      GlobalKey<FormFieldState>();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool showPass = true;
  bool showConfirmPass = true;

  final authBloc = sl<AuthBloc>();

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      body: Form(
          key: _formKey,
          child: BackgroundWidget(
            isHome: false,
            widget: Padding(
              padding: const EdgeInsets.all(8),
              child: BlocListener<AuthBloc, AuthState>(
                bloc: authBloc,
                listener: (context, state) {
                  if (state is ResetPasswordInProgress) {
                    startLoading();
                  } else if (state is ResetPasswordFailure) {
                    stopLoading();

                    const failure = 'Error , try again later';
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
                  } else if (state is ResetPasswordSuccess) {
                    stopLoading();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        AppLocalizations.of(context).translate('success'),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ));
                    while (context.canPop()) {
                      context.pop();
                    }
                    context.push('/home');
                  }
                },
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        AppLocalizations.of(context)
                            .translate('create_new_password'),
                        style: const TextStyle(
                          color: AppColor.backgroundColor,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextFormField(
                        key: _passwordFormFieldKey,
                        controller: _passwordController,
                        style: const TextStyle(color: AppColor.black),
                        decoration: InputDecoration(
                          hintText: 'New Password',
                          labelText: AppLocalizations.of(context)
                              .translate('password'),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                showPass = !showPass;
                              });
                            },
                            child: showPass
                                ? Icon(
                                    Icons.visibility_off,
                                    size: 15.sp,
                                  )
                                : Icon(Icons.visibility, size: 15.sp),
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
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
                          _passwordFormFieldKey.currentState!.validate();
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextFormField(
                        key: _confirmPasswordFormFieldKey,
                        controller: _confirmPasswordController,
                        style: const TextStyle(color: AppColor.black),
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          labelText: AppLocalizations.of(context)
                              .translate('confirm_password'),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                showConfirmPass = !showConfirmPass;
                              });
                            },
                            child: showConfirmPass
                                ? Icon(
                                    Icons.visibility_off,
                                    size: 15.sp,
                                  )
                                : Icon(Icons.visibility, size: 15.sp),
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: showConfirmPass,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return AppLocalizations.of(context)
                                .translate('password_dont_match');
                          }
                          return null;
                        },
                        onChanged: (text) {
                          _confirmPasswordFormFieldKey.currentState!.validate();
                        },
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
                              AppLocalizations.of(context).translate('submit')),
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            authBloc.add(ResetPasswordEvent(
                                password: _passwordController.text,
                                token: widget.token));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
