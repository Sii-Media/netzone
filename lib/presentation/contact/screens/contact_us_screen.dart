import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:netzoon/presentation/chat/screens/chat_page_screen.dart';
import 'package:netzoon/presentation/contact/screens/add_complaint_screen.dart';
import 'package:netzoon/presentation/contact/screens/complaints_screen.dart';
import 'package:netzoon/presentation/contact/screens/opinion_screen.dart';
import 'package:netzoon/presentation/contact/screens/question_screen.dart';
import 'package:netzoon/presentation/contact/screens/send_email_screen.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/home/widgets/auth_alert.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final authBloc = sl<AuthBloc>();

  @override
  void initState() {
    authBloc.add(AuthCheckRequested());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      isHome: false,
      widget: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).translate('contact_us'),
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              ContactCategory(
                title: AppLocalizations.of(context).translate('opinions'),
                icon: Icons.people,
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const OpinionScreen();
                  }));
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              ContactCategory(
                title: AppLocalizations.of(context).translate('complaints'),
                icon: Icons.note_alt_outlined,
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const ComplaintsScreen();
                  }));
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              ContactCategory(
                title: AppLocalizations.of(context)
                    .translate('leave_your_question'),
                icon: Icons.question_mark_sharp,
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const QuestionScreen();
                  }));
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              ContactCategory(
                title:
                    AppLocalizations.of(context).translate('private_request'),
                icon: Icons.note_add_sharp,
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const AddComplaintScreen();
                  }));
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              ContactCategory(
                title: AppLocalizations.of(context)
                    .translate('send email to Info@netzoon.com'),
                icon: Icons.email_rounded,
                onTap: () async {
                  String? encodeQueryParameters(Map<String, String> params) {
                    return params.entries
                        .map((e) =>
                            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                        .join('&');
                  }

                  final Uri emailUri = Uri(
                      scheme: 'mailto',
                      path: 'info@netzoon.com',
                      query: encodeQueryParameters(<String, String>{
                        'subject': 'Give Us a Like',
                        'body': 'D\'ont forget to give us your support',
                      }));
                  if (await canLaunchUrl(emailUri)) {
                    launchUrl(emailUri);
                  } else {
                    print('');
                  }
                },
              ),
              SizedBox(
                height: 30.h,
              ),
              BlocBuilder<AuthBloc, AuthState>(
                bloc: authBloc,
                builder: (context, authState) {
                  return Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: InkWell(
                        onTap: () async {
                          if (authState is Authenticated) {
                            await SendbirdChat.connect(
                                authState.user.userInfo.username ?? '');
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return ChatPageScreen(
                                  userId:
                                      authState.user.userInfo.username ?? '',
                                  otherUserId: 'Netzoon',
                                  title: 'Netzoon',
                                  image:
                                      'https://www.netzoonback.siidevelopment.com/images/1701985456596.jpg',
                                );
                              }),
                            );
                          } else {
                            authAlert(context);
                          }
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 60.h,
                          width: 200.w,
                          color: AppColor.backgroundColor,
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('chat_with_netzoon'),
                              style: TextStyle(
                                  fontSize: 15.sp, color: AppColor.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const SendEmailScreen();
                      }));
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 60.h,
                      width: 200.w,
                      color: AppColor.backgroundColor,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).translate('send_email'),
                          style:
                              TextStyle(fontSize: 15.sp, color: AppColor.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 80.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactCategory extends StatelessWidget {
  const ContactCategory({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });
  final IconData icon;
  final String title;
  final void Function()? onTap;
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
              ),
              SizedBox(
                width: 7.w,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 15.sp, color: AppColor.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
