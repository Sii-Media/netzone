import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/contact/blocs/send_email/send_email_bloc.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';

import '../../../injection_container.dart';
import '../../core/constant/colors.dart';
import '../../utils/app_localizations.dart';
import '../widgets/questionformfield.dart';

class SendEmailScreen extends StatefulWidget {
  const SendEmailScreen({super.key});

  @override
  State<SendEmailScreen> createState() => _SendEmailScreenState();
}

class _SendEmailScreenState extends State<SendEmailScreen>
    with ScreenLoader<SendEmailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormFieldState> _nameFormFieldKey =
      GlobalKey<FormFieldState>();
  final TextEditingController nameController = TextEditingController();

  final GlobalKey<FormFieldState> _emailFormFieldKey =
      GlobalKey<FormFieldState>();
  final TextEditingController emailController = TextEditingController();

  final GlobalKey<FormFieldState> _subjectFormFieldKey =
      GlobalKey<FormFieldState>();
  final TextEditingController subjectController = TextEditingController();

  final GlobalKey<FormFieldState> _messageFormFieldKey =
      GlobalKey<FormFieldState>();
  final TextEditingController messageController = TextEditingController();

  final sendBloc = sl<SendEmailBloc>();
  @override
  Widget screen(BuildContext context) {
    return BackgroundWidget(
      isHome: false,
      widget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocListener<SendEmailBloc, SendEmailState>(
            bloc: sendBloc,
            listener: (context, state) {
              if (state is SendEmailInProgress) {
                startLoading();
              } else if (state is SendEmailFailure) {
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
              } else if (state is SendEmailSuccess) {
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 13.sp,
                        color: AppColor.backgroundColor,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        AppLocalizations.of(context).translate('send_email'),
                        style: TextStyle(
                          color: AppColor.backgroundColor,
                          fontSize: 20.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  QuestionFormField(
                    textController: nameController,
                    hintText:
                        AppLocalizations.of(context).translate('your name'),
                    // maxLines: 5,
                    onChanged: (text) {
                      _nameFormFieldKey.currentState?.validate();
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return AppLocalizations.of(context)
                            .translate('required');
                      }

                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  QuestionFormField(
                    textController: emailController,
                    hintText:
                        AppLocalizations.of(context).translate('your email'),
                    // maxLines: 5,
                    onChanged: (text) {
                      _emailFormFieldKey.currentState?.validate();
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return AppLocalizations.of(context)
                            .translate('required');
                      }

                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  QuestionFormField(
                    textController: subjectController,
                    hintText:
                        AppLocalizations.of(context).translate('your subject'),
                    // maxLines: 5,
                    onChanged: (text) {
                      _subjectFormFieldKey.currentState?.validate();
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return AppLocalizations.of(context)
                            .translate('required');
                      }

                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  QuestionFormField(
                    textController: messageController,
                    hintText:
                        AppLocalizations.of(context).translate('your message'),
                    maxLines: 5,
                    onChanged: (text) {
                      _messageFormFieldKey.currentState?.validate();
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return AppLocalizations.of(context)
                            .translate('required');
                      }

                      return null;
                    },
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: InkWell(
                      onTap: () {
                        if (!_formKey.currentState!.validate()) return;
                        sendBloc.add(
                          SendEmailRequestEvent(
                            name: nameController.text,
                            email: emailController.text,
                            subject: subjectController.text,
                            message: messageController.text,
                          ),
                        );
                        // final SendEmailRemoteDataSource
                        //     sendEmailRemoteDataSource =
                        //     SendEmailRemoteDataSourceImpl();
                        // sendEmailRemoteDataSource.sendEmail('test',
                        //     'ka.hwajiwisam@gmai.com', 'subject', 'message');
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
                            style: TextStyle(
                                fontSize: 15.sp, color: AppColor.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
