import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:netzoon/presentation/profile/blocs/add_account/add_account_bloc.dart';

import '../../../injection_container.dart';
import '../../core/constant/colors.dart';
import '../../utils/app_localizations.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen>
    with ScreenLoader<AddAccountScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormFieldState> usernameFormFieldKey =
      GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> passwordFormFieldKey =
      GlobalKey<FormFieldState>();

  bool showPass = true;

  final addAccountBloc = sl<AddAccountBloc>();

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        widget: Padding(
            padding: const EdgeInsets.all(
              8.0,
            ),
            child: BlocListener<AddAccountBloc, AddAccountState>(
              bloc: addAccountBloc,
              listener: (context, state) {
                if (state is AddAccountInProgress) {
                  startLoading();
                } else if (state is AddAccountFailure) {
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
                } else if (state is AddAccountSuccess) {
                  stopLoading();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      AppLocalizations.of(context).translate('success'),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ));
                }
              },
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        AppLocalizations.of(context)
                            .translate('add_account_text'),
                        style: TextStyle(
                            color: AppColor.secondGrey, fontSize: 12.sp),
                      ),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('username'),
                      style: TextStyle(color: AppColor.backgroundColor),
                    ),
                    TextFormField(
                      key: usernameFormFieldKey,
                      controller: _usernameController,
                      style: const TextStyle(
                        color: AppColor.backgroundColor,
                      ),
                      decoration: InputDecoration(
                        // hintText: 'Current Password',
                        //<-- SEE HERE
                        // fillColor: Colors.green.withOpacity(0.1),
                        // floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 8)
                            .flipped,

                        // suffixIcon: InkWell(
                        //   onTap: () {
                        //     setState(() {
                        //       showPass = !showPass;
                        //     });
                        //   },
                        //   child: showPass
                        //       ? const Icon(Icons.visibility_off)
                        //       : const Icon(Icons.visibility),
                        // ),

                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(2),
                        // ),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'field_required_message';
                        }

                        return null;
                      },
                      // obscureText: showPass,
                      // textInputAction: widget.textInputAction ?? TextInputAction.done,

                      onChanged: (text) {
                        usernameFormFieldKey.currentState!.validate();
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('password'),
                      style: TextStyle(color: AppColor.backgroundColor),
                    ),
                    TextFormField(
                      key: passwordFormFieldKey,
                      controller: _passwordController,
                      style: const TextStyle(
                        color: AppColor.backgroundColor,
                      ),
                      decoration: InputDecoration(
                        // hintText: 'New Password',
                        contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 8)
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
                        passwordFormFieldKey.currentState!.validate();
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

                          addAccountBloc.add(
                            AddAccountRequestedEvent(
                              username: _usernameController.text,
                              password: _passwordController.text,
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            AppColor.backgroundColor,
                          ),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                          fixedSize: const MaterialStatePropertyAll(
                            Size.fromWidth(200),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('add account'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
