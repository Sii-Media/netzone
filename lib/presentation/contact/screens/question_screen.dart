import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/contact/blocs/add_question/add_question_bloc.dart';
import 'package:netzoon/presentation/contact/widgets/questionformfield.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen>
    with ScreenLoader<QuestionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormFieldState> _textFormFieldKey =
      GlobalKey<FormFieldState>();
  final TextEditingController textController = TextEditingController();
  final questionBloc = sl<AddQuestionBloc>();
  @override
  Widget screen(BuildContext context) {
    return BackgroundWidget(
      isHome: false,
      widget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocListener<AddQuestionBloc, AddQuestionState>(
            bloc: questionBloc,
            listener: (context, state) {
              if (state is AddQuestionInProgress) {
                startLoading();
              } else if (state is AddQuestionFailure) {
                stopLoading();

                final message = state.message;
                final failure = state.failure;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      message,
                      style: const TextStyle(
                        color: AppColor.white,
                      ),
                    ),
                    backgroundColor: AppColor.red,
                  ),
                );
                if (failure is UnAuthorizedFailure) {
                  while (context.canPop()) {
                    context.pop();
                  }
                  context.push('/home');
                }
              } else if (state is AddQuestionSuccess) {
                stopLoading();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    AppLocalizations.of(context).translate('success'),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ));
              }
            },
            child: SingleChildScrollView(
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
                          AppLocalizations.of(context)
                              .translate('leave_your_question'),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)
                              .translate('what_is_your_question'),
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        QuestionFormField(
                          key: _textFormFieldKey,
                          textController: textController,
                          hintText: '',
                          maxLines: 10,
                          onChanged: (text) {
                            _textFormFieldKey.currentState?.validate();
                          },
                          validator: (val) {
                            if (val!.isEmpty) {
                              return AppLocalizations.of(context)
                                  .translate('required');
                            }

                            return null;
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: InkWell(
                          onTap: () {
                            if (!_formKey.currentState!.validate()) return;
                            questionBloc.add(
                                PostQuestionEvent(text: textController.text));
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: 40.h,
                            width: 200.w,
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
                      ),
                    ),
                    SizedBox(
                      height: 80.h,
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
