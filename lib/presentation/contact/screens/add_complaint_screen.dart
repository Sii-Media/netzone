import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/contact/blocs/add_request/add_request_bloc.dart';
import 'package:netzoon/presentation/contact/widgets/questionformfield.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class AddComplaintScreen extends StatefulWidget {
  const AddComplaintScreen({super.key});

  @override
  State<AddComplaintScreen> createState() => _AddComplaintScreenState();
}

class _AddComplaintScreenState extends State<AddComplaintScreen>
    with ScreenLoader<AddComplaintScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormFieldState> _addressFormFieldKey =
      GlobalKey<FormFieldState>();
  final TextEditingController addressController = TextEditingController();

  final GlobalKey<FormFieldState> _textFormFieldKey =
      GlobalKey<FormFieldState>();
  final TextEditingController textController = TextEditingController();

  final reqBloc = sl<AddRequestBloc>();
  @override
  Widget screen(BuildContext context) {
    return BackgroundWidget(
      isHome: false,
      widget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocListener<AddRequestBloc, AddRequestState>(
            bloc: reqBloc,
            listener: (context, state) {
              if (state is AddRequestInProgress) {
                startLoading();
              } else if (state is AddRequestFailure) {
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
              } else if (state is AddRequestSuccess) {
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
              child: SingleChildScrollView(
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
                              .translate('private_requests'),
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
                          AppLocalizations.of(context).translate('address'),
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        QuestionFormField(
                          textController: addressController,
                          hintText: '',
                          onChanged: (text) {
                            _addressFormFieldKey.currentState?.validate();
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
                      height: 20.h,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)
                              .translate('private_request'),
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        QuestionFormField(
                          textController: textController,
                          hintText: '',
                          maxLines: 7,
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: InkWell(
                        onTap: () {
                          if (!_formKey.currentState!.validate()) return;
                          reqBloc.add(PostRequestEvent(
                            address: addressController.text,
                            text: textController.text,
                          ));
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
