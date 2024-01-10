import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/presentation/core/widgets/add_photo_button.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';

import '../../../../injection_container.dart';
import '../../../core/constant/colors.dart';
import '../../../core/widgets/background_widget.dart';
import '../../../utils/app_localizations.dart';
import '../blocs/delivery_service/delivery_service_bloc.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen>
    with ScreenLoader<AddServiceScreen> {
  late TextEditingController titleController = TextEditingController();
  late TextEditingController descController = TextEditingController();
  late TextEditingController fromController = TextEditingController();
  late TextEditingController toController = TextEditingController();
  late TextEditingController priceController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final addBloc = sl<DeliveryServiceBloc>();
  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        isHome: false,
        widget: Padding(
          padding: const EdgeInsets.only(
            top: 4.0,
            bottom: 20,
            right: 8.0,
            left: 8.0,
          ),
          child: BlocListener<DeliveryServiceBloc, DeliveryServiceState>(
            bloc: addBloc,
            listener: (context, state) {
              if (state is DeliveryServiceInProgress) {
                startLoading();
              } else if (state is DeliveryServiceFailure) {
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
              } else if (state is AddDeliverServiceSuccess) {
                stopLoading();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    AppLocalizations.of(context).translate('success'),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ));
                Navigator.of(context).pop();
              }
            },
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        AppLocalizations.of(context).translate('add_service'),
                        style: TextStyle(
                          color: AppColor.backgroundColor,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Divider(
                      color: AppColor.secondGrey,
                      thickness: 0.2,
                      endIndent: 30,
                      indent: 30,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    addServiceFormFeild(
                      context: context,
                      controller: titleController,
                      title: 'service_name',
                      isNumber: false,
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
                    addServiceFormFeild(
                      context: context,
                      controller: descController,
                      title: 'description',
                      isNumber: false,
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
                    addServiceFormFeild(
                      context: context,
                      controller: fromController,
                      title: 'from',
                      isNumber: false,
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
                    addServiceFormFeild(
                      context: context,
                      controller: toController,
                      title: 'to',
                      isNumber: false,
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
                    addServiceFormFeild(
                      context: context,
                      controller: priceController,
                      title: 'price',
                      isNumber: true,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return AppLocalizations.of(context)
                              .translate('required');
                        }

                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Center(
                      child: addPhotoButton(
                        text: 'add_service',
                        context: context,
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) return;
                          addBloc.add(AddDeliveryServiceEvent(
                            title: titleController.text,
                            description: descController.text,
                            price: int.parse(priceController.text),
                            from: fromController.text,
                            to: toController.text,
                          ));
                        },
                      ),
                    ),
                    SizedBox(
                      height: 80.h,
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

  Widget addServiceFormFeild(
      {required BuildContext context,
      required String title,
      required bool isNumber,
      TextEditingController? controller,
      int? maxLines,
      String? Function(String?)? validator}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).translate(title),
          style: TextStyle(
            color: AppColor.backgroundColor,
            fontSize: 16.sp,
          ),
        ),
        TextFormField(
          controller: controller,
          style: const TextStyle(color: Colors.black),
          keyboardType: isNumber
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            //<-- SEE HERE
            fillColor: Colors.green.withOpacity(0.1),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 30).flipped,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
