import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/categories/local_company/local_company_bloc/local_company_bloc.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';

import '../../injection_container.dart';
import '../core/constant/colors.dart';
import '../core/widgets/add_photo_button.dart';
import '../core/widgets/background_widget.dart';
import '../utils/app_localizations.dart';

class AddCompanyServiceScreen extends StatefulWidget {
  const AddCompanyServiceScreen({super.key});

  @override
  State<AddCompanyServiceScreen> createState() =>
      _AddCompanyServiceScreenState();
}

class _AddCompanyServiceScreenState extends State<AddCompanyServiceScreen>
    with ScreenLoader<AddCompanyServiceScreen> {
  late TextEditingController titleController = TextEditingController();
  late TextEditingController descController = TextEditingController();
  late TextEditingController priceController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final addBloc = sl<LocalCompanyBloc>();
  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        widget: Padding(
          padding: const EdgeInsets.only(
            top: 4.0,
            bottom: 20,
            right: 8.0,
            left: 8.0,
          ),
          child: BlocListener<LocalCompanyBloc, LocalCompanyState>(
            bloc: addBloc,
            listener: (context, state) {
              if (state is LocalCompanyInProgress) {
                startLoading();
              } else if (state is LocalCompanyFailure) {
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
              } else if (state is AddCompanyServiceSuccess) {
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
                      maxLines: 4,
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
                      height: 10.h,
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

                          addBloc.add(
                            AddCompanyServiceEvent(
                              title: titleController.text,
                              description: descController.text,
                              price: int.parse(priceController.text),
                            ),
                          );
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
