import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/auth/screens/signup.dart';
import 'package:netzoon/presentation/auth/widgets/text_form_signup_widget.dart';
import 'package:netzoon/presentation/auth/widgets/text_signup_widget.dart';
import 'package:netzoon/presentation/core/blocs/country_bloc/country_bloc.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/helpers/connect_send_bird.dart';
import 'package:netzoon/presentation/core/helpers/get_city_from_country.dart';
import 'package:netzoon/presentation/core/widgets/add_file_button.dart';
import 'package:netzoon/presentation/core/widgets/add_photo_button.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:netzoon/presentation/profile/blocs/edit_profile/edit_profile_bloc.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

class CompleteSignupScreen extends StatefulWidget {
  final String userId;
  final String name;
  final String email;
  final String profilePhoto;
  const CompleteSignupScreen(
      {super.key,
      required this.name,
      required this.email,
      required this.profilePhoto,
      required this.userId});

  @override
  State<CompleteSignupScreen> createState() => _CompleteSignupScreenState();
}

class _CompleteSignupScreenState extends State<CompleteSignupScreen>
    with ScreenLoader<CompleteSignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _firstMobileFormFieldKey =
      GlobalKey<FormFieldState>();
  final TextEditingController firstMobileController = TextEditingController();

  final GlobalKey<FormFieldState> _emailFormFieldKey =
      GlobalKey<FormFieldState>();
  final TextEditingController emailController = TextEditingController();

  final GlobalKey<FormFieldState> _addressDetailsFormFieldKey =
      GlobalKey<FormFieldState>();
  final TextEditingController addressDetailsController =
      TextEditingController();

  final GlobalKey<FormFieldState> _floorNumberFormFieldKey =
      GlobalKey<FormFieldState>();
  final TextEditingController floorNumberController = TextEditingController();

  final TextEditingController numberPhoneOneController =
      TextEditingController();
  final TextEditingController numberPhoneTwoController =
      TextEditingController();

  final TextEditingController numberPhoneThreeController =
      TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final TextEditingController slognController = TextEditingController();
  final TextEditingController freezoneCityController = TextEditingController();
  final TextEditingController deliveryCarsNumController =
      TextEditingController();
  final TextEditingController deliveryMotorsNumController =
      TextEditingController();
  final TextEditingController subcategoryController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController profitRatioController = TextEditingController();
  final TextEditingController contactNameController = TextEditingController();

  String? _selectedLocationType;
  final List<String> items = [
    'الشركات المحلية',
    'شركة عقارات',
    "تاجر",
    'السيارات',
    'الشركات البحرية',
    'المستهلك',
    'منطقة حرة',
    'المصانع',
    'جهة إخبارية',
    'شركة توصيل'
  ];
  String? selectedValue;
  String? selectedCity;
  final countryBloc = sl<CountryBloc>();
  final editBloc = sl<EditProfileBloc>();
  String? selectedTradeFileName;
  String? selectedFrontIdFileName;
  String? selectedBackIdFileName;
  File? tradeLicensePhoto;
  File? frontIdPhoto;

  File? backIdPhoto;
  File? deliveryPermitPhoto;

  bool _isService = false;
  bool _isThereWarehouse = false;
  bool _isThereFoodsDelivery = false;
  bool _isFreeZone = false;
  bool _isSelectable = false;
  String? deliveryType;
  void getFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = file.path.split('/').last; // Extract file name

      // Update the UI with the selected file name
      setState(() {
        selectedTradeFileName = fileName;
        tradeLicensePhoto = file;
      });
    } else {
      // User canceled the file picking
    }
  }

  Future getdeliveryPermitImage(ImageSource imageSource) async {
    final image = await ImagePicker().pickImage(source: imageSource);

    if (image == null) return;
    final imageTemporary = File(image.path);

    setState(() {
      deliveryPermitPhoto = imageTemporary;
    });
  }

  void getBackIdFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = file.path.split('/').last; // Extract file name

      // Update the UI with the selected file name
      setState(() {
        selectedBackIdFileName = fileName;
        backIdPhoto = file;
      });
    } else {
      // User canceled the file picking
    }
  }

  void getFrontIdFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = file.path.split('/').last; // Extract file name

      // Update the UI with the selected file name
      setState(() {
        selectedFrontIdFileName = fileName;
        frontIdPhoto = file;
      });
    } else {
      // User canceled the file picking
    }
  }

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.h,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_rounded,
            color: AppColor.white,
            size: 22.sp,
          ),
        ),
        title: const Text(
          'complete your sign up',
        ),
        // leading: const SizedBox(),
        // leadingWidth: 0,
        centerTitle: true,
        backgroundColor: AppColor.backgroundColor,
      ),
      body: BlocListener<EditProfileBloc, EditProfileState>(
        bloc: editBloc,
        listener: (context, state) {
          if (state is EditProfileInProgress) {
            startLoading();
          } else if (state is EditProfileFailure) {
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
          } else if (state is EditProfileSuccess) {
            stopLoading();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                AppLocalizations.of(context).translate('success'),
              ),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ));
            connectWithSendbird(username: widget.name);
            updateCurrentUserInfo(
              nickname: widget.name,
              profileFileInfo: widget.profilePhoto,
            );
            while (context.canPop()) {
              context.pop();
            }
            context.push('/home');
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    // width: MediaQuery.of(context).size.width,
                    child: DropdownButton2(
                      isExpanded: true,
                      hint: Row(
                        children: [
                          const SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: Text(
                              selectedValue ??
                                  AppLocalizations.of(context)
                                      .translate('choose_user_type'),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColor.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      items: items
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  AppLocalizations.of(context).translate(item),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      value: selectedValue,
                      style: TextStyle(fontSize: 10.sp),
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value as String;

                          // Navigator.of(context)
                          //     .push(MaterialPageRoute(builder: (context) {
                          //   return SignUpPage(
                          //     accountTitle: selectedValue ?? '',
                          //     withAdd: widget.withAdd,
                          //   );
                          // }));
                        });
                        // print(items);
                        // setState(() {
                        //   selectedValue = value as String;
                        // });
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 40.h,
                        width: MediaQuery.of(context).size.width - 30.w,
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(
                            color: Colors.black26,
                          ),
                          color: Colors.white,
                        ),
                        elevation: 2,
                      ),
                      iconStyleData: IconStyleData(
                        icon: const Icon(
                          color: AppColor.backgroundColor,
                          Icons.arrow_downward_rounded,
                        ),
                        iconSize: 14.sp,
                        iconEnabledColor: Colors.black,
                        iconDisabledColor: Colors.grey,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 200.h,
                        width: 200.w,
                        padding: null,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TextSignup(
                      text: AppLocalizations.of(context)
                          .translate('contact_name')),
                  TextFormField(
                    controller: contactNameController,
                    style: const TextStyle(color: Colors.black),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return AppLocalizations.of(context)
                            .translate('required');
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      //<-- SEE HERE
                      fillColor: Colors.green.withOpacity(0.1),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 30)
                          .flipped,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TextSignup(
                      text: AppLocalizations.of(context)
                          .translate('phone_number')),
                  TextFormSignupWidget(
                    password: false,
                    isNumber: true,
                    valid: (val) {
                      if (val!.isEmpty) {
                        return AppLocalizations.of(context)
                            .translate('required');
                      }

                      return null;
                    },
                    myController: numberPhoneOneController,
                  ),
                  // TextSignup(
                  //     text: AppLocalizations.of(context)
                  //         .translate('mobile_number')),
                  // TextFormSignupWidget(
                  //   password: false,
                  //   isNumber: true,
                  //   myController: numberPhoneTwoController,
                  // ),
                  // TextSignup(
                  //     text: AppLocalizations.of(context)
                  //         .translate('contact_numbers')),
                  // TextFormSignupWidget(
                  //   password: false,
                  //   isNumber: true,
                  //   myController: numberPhoneThreeController,
                  // ),
                  // Column(
                  //   children: [
                  //     TextFormSignupWidget(
                  //       password: false,
                  //       isNumber: true,
                  //       valid: (val) {
                  //         return null;

                  //         // return validInput(val!, 5, 100, "phone");
                  //       },
                  //       myController: widget.numberPhoneTow,
                  //     ),
                  //     TextFormSignupWidget(
                  //       password: false,
                  //       isNumber: true,
                  //       valid: (val) {
                  //         return null;

                  //         // return validInput(val!, 5, 100, "phone");
                  //       },
                  //       myController: widget.numberPhoneThree,
                  //     )
                  //   ],
                  // ),
                  // TextSignup(
                  //     text: AppLocalizations.of(context).translate('Bio')),
                  // TextFormField(
                  //   controller: bioController,
                  //   style: const TextStyle(color: AppColor.black),
                  //   decoration: InputDecoration(
                  //     filled: true,
                  //     //<-- SEE HERE
                  //     fillColor: Colors.green.withOpacity(0.1),
                  //     floatingLabelBehavior: FloatingLabelBehavior.always,
                  //     contentPadding: const EdgeInsets.symmetric(
                  //             vertical: 5, horizontal: 30)
                  //         .flipped,

                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(2),
                  //     ),
                  //   ),
                  //   keyboardType: TextInputType.multiline,
                  //   maxLength: 300,
                  //   maxLines: 4,
                  //   // textInputAction: widget.textInputAction ?? TextInputAction.done,

                  //   onChanged: (text) {
                  //     // widget.passwordFormFieldKey.currentState!.validate();
                  //   },
                  // ),
                  // SizedBox(
                  //   height: 10.h,
                  // ),
                  // TextSignup(
                  //     text: AppLocalizations.of(context).translate('desc')),
                  // TextFormField(
                  //   controller: descriptionController,
                  //   style: const TextStyle(color: AppColor.black),
                  //   decoration: InputDecoration(
                  //     filled: true,
                  //     //<-- SEE HERE
                  //     fillColor: Colors.green.withOpacity(0.1),
                  //     floatingLabelBehavior: FloatingLabelBehavior.always,
                  //     contentPadding: const EdgeInsets.symmetric(
                  //             vertical: 5, horizontal: 30)
                  //         .flipped,

                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(2),
                  //     ),
                  //   ),
                  //   keyboardType: TextInputType.multiline,
                  //   maxLines: 3,
                  //   // textInputAction: widget.textInputAction ?? TextInputAction.done,

                  //   onChanged: (text) {
                  //     // widget.passwordFormFieldKey.currentState!.validate();
                  //   },
                  // ),
                  // SizedBox(
                  //   height: 10.h,
                  // ),
                  // TextSignup(
                  //     text: AppLocalizations.of(context).translate('website')),
                  // TextFormField(
                  //   controller: websiteController,
                  //   style: const TextStyle(color: AppColor.black),
                  //   decoration: InputDecoration(
                  //     filled: true,
                  //     //<-- SEE HERE
                  //     fillColor: Colors.green.withOpacity(0.1),
                  //     floatingLabelBehavior: FloatingLabelBehavior.always,
                  //     contentPadding: const EdgeInsets.symmetric(
                  //             vertical: 5, horizontal: 30)
                  //         .flipped,

                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(2),
                  //     ),
                  //   ),
                  //   keyboardType: TextInputType.text,

                  //   // textInputAction: widget.textInputAction ?? TextInputAction.done,

                  //   onChanged: (text) {
                  //     // widget.passwordFormFieldKey.currentState!.validate();
                  //   },
                  // ),
                  // SizedBox(
                  //   height: 10.h,
                  // ),
                  // TextSignup(
                  //     text: AppLocalizations.of(context).translate('link')),
                  // TextFormField(
                  //   controller: linkController,
                  //   style: const TextStyle(color: AppColor.black),
                  //   decoration: InputDecoration(
                  //     filled: true,
                  //     //<-- SEE HERE
                  //     fillColor: Colors.green.withOpacity(0.1),
                  //     floatingLabelBehavior: FloatingLabelBehavior.always,
                  //     contentPadding: const EdgeInsets.symmetric(
                  //             vertical: 5, horizontal: 30)
                  //         .flipped,

                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(2),
                  //     ),
                  //   ),
                  //   keyboardType: TextInputType.text,

                  //   // textInputAction: widget.textInputAction ?? TextInputAction.done,

                  //   onChanged: (text) {
                  //     // widget.passwordFormFieldKey.currentState!.validate();
                  //   },
                  // ),
                  // SizedBox(
                  //   height: 10.h,
                  // ),
                  // TextSignup(
                  //     text: AppLocalizations.of(context).translate('slogn')),
                  // TextFormField(
                  //   controller: slognController,
                  //   style: const TextStyle(color: AppColor.black),
                  //   decoration: InputDecoration(
                  //     filled: true,
                  //     //<-- SEE HERE
                  //     fillColor: Colors.green.withOpacity(0.1),
                  //     floatingLabelBehavior: FloatingLabelBehavior.always,
                  //     contentPadding: const EdgeInsets.symmetric(
                  //             vertical: 5, horizontal: 30)
                  //         .flipped,

                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(2),
                  //     ),
                  //   ),
                  //   keyboardType: TextInputType.text,

                  //   // textInputAction: widget.textInputAction ?? TextInputAction.done,

                  //   onChanged: (text) {
                  //     // widget.passwordFormFieldKey.currentState!.validate();
                  //   },
                  // ),
                  // SizedBox(
                  //   height: 10.h,
                  // ),
                  // selectedValue == 'منطقة حرة'
                  //     ? Padding(
                  //         padding: const EdgeInsets.only(bottom: 10.0),
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             TextSignup(
                  //                 text: AppLocalizations.of(context)
                  //                     .translate('freezoneCity')),
                  //             TextFormSignupWidget(
                  //               password: false,
                  //               isNumber: false,
                  //               valid: (val) {
                  //                 return null;

                  //                 // return validInput(val!, 5, 100, "password");
                  //               },
                  //               myController: freezoneCityController,
                  //             ),
                  //           ],
                  //         ),
                  //       )
                  //     : const SizedBox(),
                  // widget.accountTitle == 'الشركات المحلية'
                  //     ? Padding(
                  //         padding: const EdgeInsets.only(bottom: 10.0),
                  //         child: CheckboxListTile(
                  //           title: Text(
                  //             AppLocalizations.of(context)
                  //                 .translate('Is there delivery'),
                  //             style: TextStyle(
                  //               color: AppColor.backgroundColor,
                  //               fontSize: 15.sp,
                  //             ),
                  //           ),
                  //           activeColor: AppColor.backgroundColor,
                  //           value: _isDeliverable,
                  //           onChanged: (bool? value) {
                  //             setState(() {
                  //               _isDeliverable = value ?? false;
                  //             });
                  //           },
                  //         ),
                  //       )
                  //     : const SizedBox(),
                  selectedValue == 'شركة توصيل'
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: CheckboxListTile(
                            title: Text(
                              AppLocalizations.of(context)
                                  .translate('is_there_warehouse'),
                              style: TextStyle(
                                color: AppColor.backgroundColor,
                                fontSize: 15.sp,
                              ),
                            ),
                            activeColor: AppColor.backgroundColor,
                            value: _isThereWarehouse,
                            onChanged: (bool? value) {
                              setState(() {
                                _isThereWarehouse = value ?? false;
                              });
                            },
                          ),
                        )
                      : const SizedBox(),
                  selectedValue == 'شركة توصيل'
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: CheckboxListTile(
                            title: Text(
                              AppLocalizations.of(context)
                                  .translate('is_there_food_delivery'),
                              style: TextStyle(
                                color: AppColor.backgroundColor,
                                fontSize: 15.sp,
                              ),
                            ),
                            activeColor: AppColor.backgroundColor,
                            value: _isThereFoodsDelivery,
                            onChanged: (bool? value) {
                              setState(() {
                                _isThereFoodsDelivery = value ?? false;
                              });
                            },
                          ),
                        )
                      : const SizedBox(),

                  selectedValue == 'شركة توصيل'
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .translate('delivery_type'),
                                style: TextStyle(
                                  color: AppColor.backgroundColor,
                                  fontSize: 15.sp,
                                ),
                              ),
                              Row(
                                children: [
                                  Radio(
                                    value: 'inside',
                                    groupValue: deliveryType,
                                    onChanged: (value) {
                                      setState(() {
                                        deliveryType = value ?? '';
                                      });
                                    },
                                    activeColor: AppColor.backgroundColor,
                                  ),
                                  Text(AppLocalizations.of(context)
                                      .translate('inside_country'))
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                    value: 'outside',
                                    groupValue: deliveryType,
                                    onChanged: (value) {
                                      setState(() {
                                        deliveryType = value ?? "";
                                      });
                                    },
                                    activeColor: AppColor.backgroundColor,
                                  ),
                                  Text(AppLocalizations.of(context)
                                      .translate('outside_country')),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                    value: 'inside_and_outside',
                                    groupValue: deliveryType,
                                    onChanged: (value) {
                                      setState(() {
                                        deliveryType = value ?? '';
                                      });
                                    },
                                    activeColor: AppColor.backgroundColor,
                                  ),
                                  Text(AppLocalizations.of(context)
                                      .translate('inside_and_outside_country'))
                                ],
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  selectedValue == 'شركة توصيل'
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextSignup(
                                  text: AppLocalizations.of(context)
                                      .translate('deliveryCarsNum')),
                              TextFormSignupWidget(
                                password: false,
                                isNumber: true,
                                valid: (val) {
                                  return null;

                                  // return validInput(val!, 5, 100, "password");
                                },
                                myController: deliveryCarsNumController,
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),

                  selectedValue == 'شركة توصيل'
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextSignup(
                                  text: AppLocalizations.of(context)
                                      .translate('deliveryMotorsNum')),
                              TextFormSignupWidget(
                                password: false,
                                isNumber: true,
                                valid: (val) {
                                  return null;

                                  // return validInput(val!, 5, 100, "password");
                                },
                                myController: deliveryMotorsNumController,
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  selectedValue == 'المستهلك' || selectedValue == 'جهة إخبارية'
                      ? Container()
                      : TextSignup(
                          text: AppLocalizations.of(context)
                              .translate('subcategory')),
                  selectedValue == 'المستهلك' || selectedValue == 'جهة إخبارية'
                      ? Container()
                      : TextFormSignupWidget(
                          password: false,
                          isNumber: false,
                          valid: (val) {
                            return null;

                            // return validInput(val!, 5, 100, "password");
                          },
                          myController: subcategoryController,
                        ),
                  selectedValue == 'المستهلك'
                      ? Container()
                      : TextSignup(
                          text: AppLocalizations.of(context)
                              .translate('address_and_other_branches')),
                  selectedValue == 'المستهلك'
                      ? Container()
                      : TextFormSignupWidget(
                          password: false,
                          isNumber: false,
                          valid: (val) {
                            if (val!.isEmpty) {
                              return AppLocalizations.of(context)
                                  .translate('required');
                            }

                            return null;
                          },
                          myController: addressController,
                        ),
                  selectedValue == 'المستهلك'
                      ? Container()
                      : CheckboxListTile(
                          title: Text(
                            AppLocalizations.of(context)
                                .translate('affiliated_to_a_free_zone'),
                            style: TextStyle(
                              color: AppColor.backgroundColor,
                              fontSize: 15.sp,
                            ),
                          ),
                          activeColor: AppColor.backgroundColor,
                          value: _isFreeZone,
                          onChanged: (bool? value) {
                            setState(() {
                              _isFreeZone = value ?? false;
                            });
                          },
                        ),
                  selectedValue != 'الشركات المحلية'
                      ? Container()
                      : CheckboxListTile(
                          title: Text(
                            AppLocalizations.of(context).translate(
                                'are_your_products_shareable_by_the_customer'),
                            style: TextStyle(
                              color: AppColor.backgroundColor,
                              fontSize: 15.sp,
                            ),
                          ),
                          activeColor: AppColor.backgroundColor,
                          value: _isSelectable,
                          onChanged: (bool? value) {
                            setState(() {
                              _isSelectable = value ?? false;
                            });
                          },
                        ),
                  _isSelectable == true
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextSignup(
                                  text: AppLocalizations.of(context)
                                      .translate('profitRatio')),
                              TextFormSignupWidget(
                                password: false,
                                isNumber: true,
                                valid: (val) {
                                  return null;

                                  // return validInput(val!, 5, 100, "password");
                                },
                                myController: profitRatioController,
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  SizedBox(
                    height: 10.h,
                  ),
                  selectedValue != 'الشركات المحلية' &&
                          selectedValue != 'المصانع'
                      ? Container()
                      : CheckboxListTile(
                          title: Text(
                            AppLocalizations.of(context).translate(
                                'Do you offer services rather than products'),
                            style: TextStyle(
                              color: AppColor.backgroundColor,
                              fontSize: 15.sp,
                            ),
                          ),
                          activeColor: AppColor.backgroundColor,
                          value: _isService,
                          onChanged: (bool? value) {
                            setState(() {
                              _isService = value ?? false;
                            });
                          },
                        ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TextSignup(
                    text: AppLocalizations.of(context).translate('city'),
                  ),
                  BlocBuilder<CountryBloc, CountryState>(
                    bloc: countryBloc,
                    builder: (context, countryState) {
                      List<String> selectedCountry = [];

                      if (countryState is CountryInitial) {
                        selectedCountry = getCitiesFromCountry(
                            country: countryState.selectedCountry);

                        return Container(
                          width: MediaQuery.of(context).size.width,
                          // height: 70,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 10),
                          // padding: const EdgeInsets.symmetric(
                          //     horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            // border: Border.all(
                            //   color: AppColor.black,
                            // ),
                          ),
                          child: DropdownSearch<String>(
                            popupProps: const PopupProps.modalBottomSheet(
                                showSearchBox: true,
                                constraints: BoxConstraints(
                                    // maxHeight: 300,
                                    )),

                            dropdownBuilder: (context, selectedItem) {
                              return ListTile(
                                title: Text(selectedItem ?? ''),
                                // selected: isSelected,
                              );
                            },
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                // constraints: BoxConstraints(maxHeight: 60),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            // mode: Mode.BOTTOM_SHEET,
                            // showSearchBox: true,
                            // searchBoxDecoration: const InputDecoration(
                            //   hintText: 'Search...',
                            // ),
                            // dropdownDecoratorProps: const InputDecoration(
                            //   border: OutlineInputBorder(),
                            // ),
                            items: selectedCountry,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCity = newValue ?? '';
                              });
                            },
                            selectedItem: selectedCity,
                            // label: 'Select a city',
                            // showClearButton: true,
                            // popupItemBuilder: (context, item, isSelected) {
                            //   return ListTile(
                            //     title: Text(item),
                            //     selected: isSelected,
                            //   );
                            // },
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  TextSignup(
                    text: AppLocalizations.of(context)
                        .translate('Address Details'),
                  ),
                  TextFormSignupWidget(
                    password: false,
                    isNumber: false,
                    valid: (val) {
                      if (val!.isEmpty) {
                        return AppLocalizations.of(context)
                            .translate('required');
                      }
                      return null;

                      // return validInput(val!, 5, 100, "password");
                    },
                    myController: addressDetailsController,
                  ),
                  TextSignup(
                    text:
                        AppLocalizations.of(context).translate('floor_number'),
                  ),
                  TextFormSignupWidget(
                    password: false,
                    isNumber: true,
                    valid: (val) {
                      if (val!.isEmpty) {
                        return AppLocalizations.of(context)
                            .translate('required');
                      }
                      return null;

                      // return validInput(val!, 5, 100, "password");
                    },
                    myController: floorNumberController,
                  ),
                  TextSignup(
                    text:
                        AppLocalizations.of(context).translate('location_type'),
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Radio(
                            value: 'work',
                            groupValue: _selectedLocationType,
                            onChanged: (value) {
                              setState(() {
                                _selectedLocationType = value ?? '';
                              });
                            },
                            activeColor: AppColor.backgroundColor,
                          ),
                          Row(
                            children: [
                              Icon(Icons.work_outline_outlined,
                                  color: AppColor.backgroundColor, size: 15.sp),
                              Text(AppLocalizations.of(context)
                                  .translate('work'))
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 'home',
                            groupValue: _selectedLocationType,
                            onChanged: (value) {
                              setState(() {
                                _selectedLocationType = value ?? "";
                              });
                            },
                            activeColor: AppColor.backgroundColor,
                          ),
                          Row(
                            children: [
                              Icon(Icons.home,
                                  color: AppColor.backgroundColor, size: 15.sp),
                              Text(AppLocalizations.of(context)
                                  .translate('home')),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  selectedValue == 'المستهلك'
                      ? Container()
                      : TextSignup(
                          text: AppLocalizations.of(context)
                              .translate('copy_of_trade_license')),
                  selectedValue == 'المستهلك'
                      ? Container()
                      : Column(
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: addFileButton(
                                    context: context,
                                    text: 'copy_of_trade_license',
                                    onPressed: () {
                                      getFile(context);
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  selectedTradeFileName ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColor.backgroundColor,
                                    fontSize: 10.0.sp,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  selectedValue == 'المستهلك' || selectedValue == 'جهة إخبارية'
                      ? Container()
                      : TextSignup(
                          text: AppLocalizations.of(context)
                              .translate('front_id_photo'),
                        ),
                  selectedValue == 'المستهلك' || selectedValue == 'جهة إخبارية'
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: addFileButton(
                                context: context,
                                text: 'front_id_photo',
                                onPressed: () {
                                  getFrontIdFile(context);
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              selectedFrontIdFileName ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColor.backgroundColor,
                                fontSize: 10.0.sp,
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  selectedValue == 'المستهلك' || selectedValue == 'جهة إخبارية'
                      ? Container()
                      : TextSignup(
                          text: AppLocalizations.of(context)
                              .translate('back_id_photo'),
                        ),
                  selectedValue == 'المستهلك' || selectedValue == 'جهة إخبارية'
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: addFileButton(
                                context: context,
                                text: 'back_id_photo',
                                onPressed: () {
                                  getBackIdFile(context);
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              selectedBackIdFileName ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColor.backgroundColor,
                                fontSize: 10.0.sp,
                              ),
                            ),
                          ],
                        ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  selectedValue == 'شركة توصيل'
                      ? Column(
                          children: [
                            const TextSignup(
                              text: 'delev',
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                addPhotoButton(
                                    context: context,
                                    text: 'add_from_camera',
                                    onPressed: () {
                                      getdeliveryPermitImage(
                                          ImageSource.camera);
                                    }),
                                addPhotoButton(
                                    context: context,
                                    text: 'add_from_gallery',
                                    onPressed: () {
                                      getdeliveryPermitImage(
                                          ImageSource.gallery);
                                    }),
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            deliveryPermitPhoto != null
                                ? Center(
                                    child: Image.file(
                                      deliveryPermitPhoto!,
                                      width: 250.w,
                                      height: 250.h,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Center(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.1),
                                          image: const DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/logo.png"),
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                          ],
                        )
                      : const SizedBox(),

                  SizedBox(
                    height: 25.h,
                  ),
                  Center(
                    child: Container(
                      width: 200.w,
                      // margin: EdgeInsets.symmetric(horizontal: 60, vertical: 10).r,
                      margin:
                          const EdgeInsets.only(left: 60, right: 60, bottom: 20)
                              .r,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(250.0).w,
                        child: Container(
                          width: 100.w,
                          height: 50.0.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Colors.greenAccent.withOpacity(0.9),
                                AppColor.backgroundColor
                              ],
                            ),
                          ),
                          child: RawMaterialButton(
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }

                              final String userType = getUserType();
                              if (userType == 'local_company') {
                                if (frontIdPhoto == null ||
                                    backIdPhoto == null) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          AppLocalizations.of(context)
                                              .translate('no_image_selected'),
                                          style: const TextStyle(
                                              color: AppColor.red),
                                        ),
                                        content: Text(
                                          AppLocalizations.of(context).translate(
                                              'please_select_an_front_and_back_Id_image_before_uploading'),
                                          style: const TextStyle(
                                              color: AppColor.red),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            child: Text(
                                                AppLocalizations.of(context)
                                                    .translate('ok')),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  return;
                                }
                              }
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              bool acc = await showDialog(
                                context: context,
                                builder: (context) {
                                  return const PriveryPolicyWidget();
                                },
                              );
                              if (acc == true) {
                                editBloc.add(
                                  OnEditProfileEvent(
                                    username: widget.name,
                                    email: widget.email,
                                    firstMobile: numberPhoneOneController.text,
                                    // secondeMobile:
                                    //     numberPhoneTwoController.text,
                                    // thirdMobile:
                                    //     numberPhoneThreeController.text,
                                    // bio: bioController.text,
                                    // description: descriptionController.text,
                                    // link: linkController.text,
                                    // slogn: slognController.text,
                                    // website: websiteController.text,
                                    address: addressController.text,
                                    contactName: contactNameController.text,
                                    addressDetails:
                                        addressDetailsController.text,
                                    backIdPhoto: backIdPhoto,
                                    city: selectedCity,
                                    deliveryPermitPhoto: deliveryPermitPhoto,
                                    frontIdPhoto: frontIdPhoto,
                                    tradeLicensePhoto: tradeLicensePhoto,
                                    userType: userType,
                                  ),
                                );
                              } else {
                                print('errrrr');
                              }
                            },
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('create_new_account'),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20.0),
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
        ),
      ),
    );
  }

  String getUserType() {
    switch (selectedValue) {
      case 'المستهلك':
        return 'user';
      case 'الشركات المحلية':
        return 'local_company';
      case 'السيارات':
        return 'car';
      case 'الشركات البحرية':
        return 'sea_companies';
      case 'منطقة حرة':
        return 'freezone';
      case 'المصانع':
        return 'factory';

      case 'جهة إخبارية':
        return 'news_agency';
      case 'شركة عقارات':
        return 'real_estate';
      case 'تاجر':
        return 'trader';
      case 'شركة توصيل':
        return 'delivery_company';
      default:
        return 'user';
    }
  }
}
