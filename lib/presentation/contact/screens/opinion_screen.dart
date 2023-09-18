import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/contact/blocs/add_openion/add_openion_bloc.dart';
import 'package:netzoon/presentation/contact/widgets/questionformfield.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class OpinionScreen extends StatefulWidget {
  const OpinionScreen({super.key});

  @override
  State<OpinionScreen> createState() => _OpinionScreenState();
}

class _OpinionScreenState extends State<OpinionScreen>
    with ScreenLoader<OpinionScreen> {
  final openionBloc = sl<AddOpenionBloc>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormFieldState> _textFormFieldKey =
      GlobalKey<FormFieldState>();
  final TextEditingController textController = TextEditingController();
  @override
  Widget screen(BuildContext context) {
    return BackgroundWidget(
      isHome: false,
      widget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocListener<AddOpenionBloc, AddOpenionState>(
            bloc: openionBloc,
            listener: (context, state) {
              if (state is AddOpenionInProgress) {
                startLoading();
              } else if (state is AddOpenionFailure) {
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
              } else if (state is AddOpenionSuccess) {
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
                        AppLocalizations.of(context).translate('opinions'),
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
                    textController: textController,
                    hintText: AppLocalizations.of(context)
                        .translate('tell_us_your_opinion'),
                    maxLines: 5,
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
                  SizedBox(
                    height: 10.h,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: InkWell(
                      onTap: () {
                        if (!_formKey.currentState!.validate()) return;
                        openionBloc
                            .add(PostOpenionEvent(text: textController.text));
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
