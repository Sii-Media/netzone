import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:netzoon/presentation/auth/screens/reset_password_screen.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen>
    with ScreenLoader<ForgetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormFieldState> _emailFormFieldKey =
      GlobalKey<FormFieldState>();

  final TextEditingController _emailController = TextEditingController();

  final authBloc = sl<AuthBloc>();

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: BackgroundWidget(
          isHome: false,
          widget: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocListener<AuthBloc, AuthState>(
              bloc: authBloc,
              listener: (context, state) {
                if (state is ForgetPasswordInProgress) {
                  startLoading();
                } else if (state is ForgetPasswordFailure) {
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
                } else if (state is ForgetPasswordSuccess) {
                  stopLoading();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text(
                      'success, Check your email',
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ));
                  // while (context.canPop()) {
                  //   context.pop();
                  // }
                  // context.push('/home');
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
                    const Text(
                      'Forget Password',
                      style: TextStyle(
                        color: AppColor.backgroundColor,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'Write Your Email to send you a message',
                      style: TextStyle(
                        color: AppColor.secondGrey,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    TextFormField(
                      key: _emailFormFieldKey,
                      controller: _emailController,
                      autofillHints: const [AutofillHints.email],
                      decoration: InputDecoration(
                        hintText: 'example@example.example',
                        labelText:
                            AppLocalizations.of(context).translate('email'),
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
                                errorText: AppLocalizations.of(context)
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
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            AppColor.backgroundColor,
                          ),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )),
                        ),
                        child: Text(
                            AppLocalizations.of(context).translate('submit')),
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          authBloc.add(ForgetPasswordEvent(
                              email: _emailController.text));
                          // Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (context) {
                          //     return const ResetPasswordScreen();
                          //   },
                          // ));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
