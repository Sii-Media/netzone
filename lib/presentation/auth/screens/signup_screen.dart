import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netzoon/domain/categories/entities/factories/factories.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/auth/blocs/sign_up/sign_up_bloc.dart';
import 'package:netzoon/presentation/auth/widgets/background_auth_widget.dart';
import 'package:netzoon/presentation/auth/widgets/text_form_signup_widget.dart';
import 'package:netzoon/presentation/auth/widgets/text_signup_widget.dart';
import 'package:netzoon/presentation/categories/factories/blocs/factories_bloc/factories_bloc.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/add_photo_button.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:netzoon/injection_container.dart' as di;
import 'package:netzoon/presentation/data/cities.dart';
import 'package:netzoon/presentation/home/test.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

class SignUpScreen extends StatefulWidget {
  final String accountTitle;
  const SignUpScreen({super.key, required this.accountTitle});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with ScreenLoader<SignUpScreen> {
  final SignUpBloc bloc = di.sl<SignUpBloc>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailSignup = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController contactName = TextEditingController();

  final TextEditingController passwordSignup = TextEditingController();
  final TextEditingController aboutSignup = TextEditingController();

  final TextEditingController numberPhoneOne = TextEditingController();
  final TextEditingController numberPhoneTow = TextEditingController();
  final TextEditingController numberPhoneThree = TextEditingController();
  final TextEditingController subcategory = TextEditingController();
  final TextEditingController address = TextEditingController();
  // final TextEditingController isFreeZoon = TextEditingController();
  final TextEditingController companyProductsNumber = TextEditingController();
  final TextEditingController sellType = TextEditingController();
  final TextEditingController toCountry = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController slognController = TextEditingController();
  final TextEditingController linkController = TextEditingController();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController freezoneCityController = TextEditingController();
  final TextEditingController deliveryCarsNumController =
      TextEditingController();

  final TextEditingController deliveryMotorsNumController =
      TextEditingController();

  final TextEditingController profitRatioController = TextEditingController();
  final factoryBloc = sl<FactoriesBloc>();

  final TextEditingController cityController = TextEditingController();

  final TextEditingController addressDetailsController =
      TextEditingController();

  final TextEditingController floorNumController = TextEditingController();

  String? _selectedLocationType;

  File? profileImage;
  File? coverImage;
  final GlobalKey<FormFieldState> _emailFormFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> passwordFormFieldKey =
      GlobalKey<FormFieldState>();

  bool showPass = true;

  // File? profileImage;
  // File? coverImage;
  File? banerImage;
  File? frontIdPhoto;
  File? backIdPhoto;
  File? deliveryPermitPhoto;
  File? tradeLicensePhoto;
  final bool _isDeliverable = false;
  final bool _isThereWarehouse = false;
  final bool _isThereFoodsDelivery = false;
  final bool _isFreeZone = false;
  final bool _isSelectable = false;
  final bool _isService = false;
  String? deliveryType;
  String selectedCity = 'Abadilah';
  Future getProfileImage(ImageSource imageSource) async {
    final image = await ImagePicker().pickImage(source: imageSource);

    if (image == null) return;
    final imageTemporary = File(image.path);

    setState(() {
      profileImage = imageTemporary;
    });
  }

  Future getCoverImage(ImageSource imageSource) async {
    final image = await ImagePicker().pickImage(source: imageSource);

    if (image == null) return;
    final imageTemporary = File(image.path);

    setState(() {
      coverImage = imageTemporary;
    });
  }

  Future getBanerImage(ImageSource imageSource) async {
    final image = await ImagePicker().pickImage(source: imageSource);

    if (image == null) return;
    final imageTemporary = File(image.path);

    setState(() {
      banerImage = imageTemporary;
    });
  }

  Future getTradeImage(ImageSource imageSource) async {
    final image = await ImagePicker().pickImage(source: imageSource);

    if (image == null) return;
    final imageTemporary = File(image.path);

    setState(() {
      tradeLicensePhoto = imageTemporary;
    });
  }

  Future getdeliveryPermitImage(ImageSource imageSource) async {
    final image = await ImagePicker().pickImage(source: imageSource);

    if (image == null) return;
    final imageTemporary = File(image.path);

    setState(() {
      deliveryPermitPhoto = imageTemporary;
    });
  }

  Future getFrontIdImage(
    ImageSource imageSource,
  ) async {
    final image = await ImagePicker().pickImage(source: imageSource);

    if (image == null) return;
    final imageTemporary = File(image.path);

    setState(() {
      frontIdPhoto = imageTemporary;
    });
  }

  Future getBackIdImage(
    ImageSource imageSource,
  ) async {
    final image = await ImagePicker().pickImage(source: imageSource);

    if (image == null) return;
    final imageTemporary = File(image.path);

    setState(() {
      backIdPhoto = imageTemporary;
    });
  }

  Factories? selectCat;

  @override
  void initState() {
    if (widget.accountTitle == 'المصانع') {
      factoryBloc.add(GetAllFactoriesEvent());
    }
    super.initState();
  }

  @override
  Widget screen(BuildContext context) {
    return BackgroundAuthWidget(
      title: AppLocalizations.of(context).translate(widget.accountTitle),
      n: 0.25.h,
      topTitle: 110.h,
      topWidget: 160.h,
      topBack: 150.h,
      onTap: () {
        Navigator.of(context).pop();
      },
      topLogo: 0.2,
      widget: Form(
        key: formKey,
        child: BlocListener<SignUpBloc, SignUpState>(
          bloc: bloc,
          listener: (context, state) async {
            if (state is SignUpInProgress) {
              startLoading();
            } else if (state is SignUpFailure) {
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
            } else if (state is SignUpSuccess) {
              await SendbirdChat.connect(state.user.userInfo.username ?? '');
              await SendbirdChat.updateCurrentUserInfo(
                  nickname: state.user.userInfo.username,
                  profileFileInfo: FileInfo.fromFileUrl(
                      fileUrl: state.user.userInfo.profilePhoto));
              stopLoading();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  AppLocalizations.of(context).translate('success'),
                ),
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ));
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  CupertinoPageRoute(builder: (context) {
                return const TestScreen();
              }), (route) => false);
            }
          },
          child: Container(
            height: MediaQuery.of(context).size.height - 155.h,
            padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 10, vertical: 10),
            color: Colors.grey.withOpacity(0.1),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  widget.accountTitle == 'المصانع'
                      ? BlocBuilder<FactoriesBloc, FactoriesState>(
                          bloc: factoryBloc,
                          builder: (context, state) {
                            if (state is FactoriesInProgress) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppColor.backgroundColor,
                                ),
                              );
                            } else if (state is FactoriesFailure) {
                              final failure = state.message;
                              return Center(
                                child: Text(
                                  failure,
                                  style: const TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              );
                            } else if (state is FactoriesSuccess) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)
                                        .translate('categ'),
                                    style: TextStyle(
                                      color: AppColor.backgroundColor,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.symmetric(
                                              horizontal: 2, vertical: 10)
                                          .r,
                                      // Add some padding and a background color
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: AppColor.black,
                                          )),
                                      // Create the dropdown button
                                      child: DropdownButton<Factories>(
                                        // Set the selected value
                                        value: selectCat,
                                        // // Handle the value change
                                        menuMaxHeight: 300.h,
                                        onChanged: (Factories? newValue) {
                                          setState(() {
                                            selectCat = newValue!;
                                          });
                                        },
                                        // onChanged: (String? newValue) => setState(
                                        //     () => selectedValue = newValue ?? ''),
                                        // Map each option to a widget
                                        items: state.factories
                                            .map<DropdownMenuItem<Factories>>(
                                                (Factories value) {
                                          return DropdownMenuItem<Factories>(
                                            value: value,
                                            // Use a colored box to show the option
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .translate(value.title),
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          );
                                        }).toList(),
                                      )),
                                ],
                              );
                            }
                            return Container();
                          },
                        )
                      : const SizedBox(),
                  TextSignup(
                      text: AppLocalizations.of(context).translate('email')),
                  TextFormField(
                    key: _emailFormFieldKey,
                    controller: emailSignup,
                    style: const TextStyle(color: Colors.black),
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
                    onChanged: (text) {
                      _emailFormFieldKey.currentState!.validate();
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
                  TextSignup(
                      text: AppLocalizations.of(context).translate('username')),
                  TextFormField(
                    controller: username,
                    style: const TextStyle(color: Colors.black),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return AppLocalizations.of(context)
                            .translate('username_required');
                      }
                      if (val.length < 5) {
                        return AppLocalizations.of(context)
                            .translate('username_condition');
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
                  TextSignup(
                      text: AppLocalizations.of(context)
                          .translate('contact_name')),
                  TextFormField(
                    controller: contactName,
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
                  TextSignup(
                      text: AppLocalizations.of(context).translate('password')),
                  TextFormField(
                    key: passwordFormFieldKey,
                    controller: passwordSignup,
                    style: const TextStyle(color: AppColor.black),
                    decoration: InputDecoration(
                      filled: true,
                      //<-- SEE HERE
                      fillColor: Colors.green.withOpacity(0.1),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 30)
                          .flipped,
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            showPass = !showPass;
                          });
                        },
                        child: showPass
                            ? Icon(
                                Icons.visibility_off,
                                size: 15.sp,
                              )
                            : Icon(Icons.visibility, size: 15.sp),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: showPass,
                    // textInputAction: widget.textInputAction ?? TextInputAction.done,
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
                  TextSignup(
                      text: AppLocalizations.of(context)
                          .translate('contact_numbers')),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormSignupWidget(
                          password: false,
                          isNumber: true,
                          valid: (val) {
                            if (val!.isEmpty) {
                              return AppLocalizations.of(context)
                                  .translate('required');
                            }

                            return null;
                          },
                          myController: numberPhoneOne,
                        ),
                      ),
                      Expanded(
                        child: TextFormSignupWidget(
                          password: false,
                          isNumber: true,
                          valid: (val) {
                            return null;

                            // return validInput(val!, 5, 100, "phone");
                          },
                          myController: numberPhoneTow,
                        ),
                      ),
                      Expanded(
                        child: TextFormSignupWidget(
                          password: false,
                          isNumber: true,
                          valid: (val) {
                            return null;

                            // return validInput(val!, 5, 100, "phone");
                          },
                          myController: numberPhoneThree,
                        ),
                      )
                    ],
                  ),
                  TextSignup(
                      text: AppLocalizations.of(context).translate('Bio')),
                  // TextFormField(
                  //   controller: bioController,
                  //   style: const TextStyle(color: AppColor.black),
                  //   decoration: InputDecoration(
                  //     filled: true,
                  //     //<-- SEE HERE
                  //     fillColor: Colors.green.withOpacity(0.1),
                  //     floatingLabelBehavior: FloatingLabelBehavior.always,
                  //     contentPadding:
                  //         const EdgeInsets.symmetric(vertical: 5, horizontal: 30)
                  //             .flipped,

                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(2),
                  //     ),
                  //   ),
                  //   keyboardType: TextInputType.multiline,
                  //   maxLength: 300,
                  //   maxLines: 4,
                  //   // textInputAction: widget.textInputAction ?? TextInputAction.done,
                  // ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TextSignup(
                      text: AppLocalizations.of(context).translate('desc')),
                  TextFormField(
                    controller: descriptionController,
                    style: const TextStyle(color: AppColor.black),
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
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    // textInputAction: widget.textInputAction ?? TextInputAction.done,

                    onChanged: (text) {
                      // widget.passwordFormFieldKey.currentState!.validate();
                    },
                  ),
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
                  //     contentPadding:
                  //         const EdgeInsets.symmetric(vertical: 5, horizontal: 30)
                  //             .flipped,

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
                  //     contentPadding:
                  //         const EdgeInsets.symmetric(vertical: 5, horizontal: 30)
                  //             .flipped,

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
                  //     contentPadding:
                  //         const EdgeInsets.symmetric(vertical: 5, horizontal: 30)
                  //             .flipped,

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
                  // widget.accountTitle == 'منطقة حرة'
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
                  // widget.accountTitle == 'شركة توصيل'
                  //     ? Padding(
                  //         padding: const EdgeInsets.only(bottom: 10.0),
                  //         child: CheckboxListTile(
                  //           title: Text(
                  //             AppLocalizations.of(context)
                  //                 .translate('is_there_warehouse'),
                  //             style: TextStyle(
                  //               color: AppColor.backgroundColor,
                  //               fontSize: 15.sp,
                  //             ),
                  //           ),
                  //           activeColor: AppColor.backgroundColor,
                  //           value: _isThereWarehouse,
                  //           onChanged: (bool? value) {
                  //             setState(() {
                  //               _isThereWarehouse = value ?? false;
                  //             });
                  //           },
                  //         ),
                  //       )
                  //     : const SizedBox(),
                  // widget.accountTitle == 'شركة توصيل'
                  //     ? Padding(
                  //         padding: const EdgeInsets.only(bottom: 10.0),
                  //         child: CheckboxListTile(
                  //           title: Text(
                  //             AppLocalizations.of(context)
                  //                 .translate('is_there_food_delivery'),
                  //             style: TextStyle(
                  //               color: AppColor.backgroundColor,
                  //               fontSize: 15.sp,
                  //             ),
                  //           ),
                  //           activeColor: AppColor.backgroundColor,
                  //           value: _isThereFoodsDelivery,
                  //           onChanged: (bool? value) {
                  //             setState(() {
                  //               _isThereFoodsDelivery = value ?? false;
                  //             });
                  //           },
                  //         ),
                  //       )
                  //     : const SizedBox(),

                  // widget.accountTitle == 'شركة توصيل'
                  //     ? Padding(
                  //         padding: const EdgeInsets.only(bottom: 10.0),
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Text(
                  //               AppLocalizations.of(context)
                  //                   .translate('delivery_type'),
                  //               style: TextStyle(
                  //                 color: AppColor.backgroundColor,
                  //                 fontSize: 15.sp,
                  //               ),
                  //             ),
                  //             Row(
                  //               children: [
                  //                 Radio(
                  //                   value: 'inside',
                  //                   groupValue: deliveryType,
                  //                   onChanged: (value) {
                  //                     setState(() {
                  //                       deliveryType = value ?? '';
                  //                     });
                  //                   },
                  //                   activeColor: AppColor.backgroundColor,
                  //                 ),
                  //                 Text(AppLocalizations.of(context)
                  //                     .translate('inside_country'))
                  //               ],
                  //             ),
                  //             Row(
                  //               children: [
                  //                 Radio(
                  //                   value: 'outside',
                  //                   groupValue: deliveryType,
                  //                   onChanged: (value) {
                  //                     setState(() {
                  //                       deliveryType = value ?? "";
                  //                     });
                  //                   },
                  //                   activeColor: AppColor.backgroundColor,
                  //                 ),
                  //                 Text(AppLocalizations.of(context)
                  //                     .translate('outside_country')),
                  //               ],
                  //             ),
                  //             Row(
                  //               children: [
                  //                 Radio(
                  //                   value: 'inside_and_outside',
                  //                   groupValue: deliveryType,
                  //                   onChanged: (value) {
                  //                     setState(() {
                  //                       deliveryType = value ?? '';
                  //                     });
                  //                   },
                  //                   activeColor: AppColor.backgroundColor,
                  //                 ),
                  //                 Text(AppLocalizations.of(context)
                  //                     .translate('inside_and_outside_country'))
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //       )
                  //     : const SizedBox(),
                  // widget.accountTitle == 'شركة توصيل'
                  //     ? Padding(
                  //         padding: const EdgeInsets.only(bottom: 10.0),
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             TextSignup(
                  //                 text: AppLocalizations.of(context)
                  //                     .translate('deliveryCarsNum')),
                  //             TextFormSignupWidget(
                  //               password: false,
                  //               isNumber: true,
                  //               valid: (val) {
                  //                 return null;

                  //                 // return validInput(val!, 5, 100, "password");
                  //               },
                  //               myController: deliveryCarsNumController,
                  //             ),
                  //           ],
                  //         ),
                  //       )
                  //     : const SizedBox(),

                  // widget.accountTitle == 'شركة توصيل'
                  //     ? Padding(
                  //         padding: const EdgeInsets.only(bottom: 10.0),
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             TextSignup(
                  //                 text: AppLocalizations.of(context)
                  //                     .translate('deliveryMotorsNum')),
                  //             TextFormSignupWidget(
                  //               password: false,
                  //               isNumber: true,
                  //               valid: (val) {
                  //                 return null;

                  //                 // return validInput(val!, 5, 100, "password");
                  //               },
                  //               myController: deliveryMotorsNumController,
                  //             ),
                  //           ],
                  //         ),
                  //       )
                  //     : const SizedBox(),
                  // widget.accountTitle == 'المستهلك' ||
                  //         widget.accountTitle == 'جهة إخبارية'
                  //     ? Container()
                  //     : TextSignup(
                  //         text: AppLocalizations.of(context)
                  //             .translate('subcategory')),
                  // widget.accountTitle == 'المستهلك' ||
                  //         widget.accountTitle == 'جهة إخبارية'
                  //     ? Container()
                  //     : TextFormSignupWidget(
                  //         password: false,
                  //         isNumber: false,
                  //         valid: (val) {
                  //           return null;

                  //           // return validInput(val!, 5, 100, "password");
                  //         },
                  //         myController: subcategory,
                  //       ),
                  // widget.accountTitle == 'المستهلك'
                  //     ? Container()
                  //     : TextSignup(
                  //         text: AppLocalizations.of(context)
                  //             .translate('address_and_other_branches')),
                  // widget.accountTitle == 'المستهلك'
                  //     ? Container()
                  //     : TextFormSignupWidget(
                  //         password: false,
                  //         isNumber: false,
                  //         valid: (val) {
                  //           return AppLocalizations.of(context)
                  //               .translate('required');

                  //           // return validInput(val!, 5, 100, "password");
                  //         },
                  //         myController: address,
                  //       ),
                  // widget.accountTitle == 'المستهلك'
                  //     ? Container()
                  //     : CheckboxListTile(
                  //         title: Text(
                  //           AppLocalizations.of(context)
                  //               .translate('affiliated_to_a_free_zone'),
                  //           style: TextStyle(
                  //             color: AppColor.backgroundColor,
                  //             fontSize: 15.sp,
                  //           ),
                  //         ),
                  //         activeColor: AppColor.backgroundColor,
                  //         value: _isFreeZone,
                  //         onChanged: (bool? value) {
                  //           setState(() {
                  //             _isFreeZone = value ?? false;
                  //           });
                  //         },
                  //       ),
                  // widget.accountTitle != 'الشركات المحلية'
                  //     ? Container()
                  //     : CheckboxListTile(
                  //         title: Text(
                  //           AppLocalizations.of(context).translate(
                  //               'are_your_products_shareable_by_the_customer'),
                  //           style: TextStyle(
                  //             color: AppColor.backgroundColor,
                  //             fontSize: 15.sp,
                  //           ),
                  //         ),
                  //         activeColor: AppColor.backgroundColor,
                  //         value: _isSelectable,
                  //         onChanged: (bool? value) {
                  //           setState(() {
                  //             _isSelectable = value ?? false;
                  //           });
                  //         },
                  //       ),
                  // _isSelectable == true
                  //     ? Padding(
                  //         padding: const EdgeInsets.only(bottom: 10.0),
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             TextSignup(
                  //                 text: AppLocalizations.of(context)
                  //                     .translate('profitRatio')),
                  //             TextFormSignupWidget(
                  //               password: false,
                  //               isNumber: true,
                  //               valid: (val) {
                  //                 return null;

                  //                 // return validInput(val!, 5, 100, "password");
                  //               },
                  //               myController: profitRatioController,
                  //             ),
                  //           ],
                  //         ),
                  //       )
                  //     : const SizedBox(),

                  // widget.accountTitle != 'الشركات المحلية' &&
                  //         widget.accountTitle != 'المصانع'
                  //     ? Container()
                  //     : CheckboxListTile(
                  //         title: Text(
                  //           AppLocalizations.of(context).translate(
                  //               'Do you offer services rather than products'),
                  //           style: TextStyle(
                  //             color: AppColor.backgroundColor,
                  //             fontSize: 15.sp,
                  //           ),
                  //         ),
                  //         activeColor: AppColor.backgroundColor,
                  //         value: _isService,
                  //         onChanged: (bool? value) {
                  //           setState(() {
                  //             _isService = value ?? false;
                  //           });
                  //         },
                  //       ),
                  // // : Row(
                  // //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // //     children: [
                  // //       Expanded(
                  // //           child: TextSignup(
                  // //               text: AppLocalizations.of(context)
                  // //                   .translate('affiliated_to_a_free_zone'))),
                  // //       SizedBox(
                  // //         width: 20.w,
                  // //         child: CheckboxListTile(
                  // //           controlAffinity: ListTileControlAffinity.leading,
                  // //           onChanged: (val) {
                  // //             // print("object");
                  // //             // controller.checkbox(val!);
                  // //           },
                  // //           value: widget.rememberMe,
                  // //         ),
                  // //       )
                  // //     ],
                  // //   ),
                  // widget.accountTitle == 'المستهلك' ||
                  //         widget.accountTitle == 'جهة إخبارية' ||
                  //         widget.accountTitle == 'شركة توصيل'
                  //     ? Container()
                  //     : TextSignup(
                  //         text: AppLocalizations.of(context)
                  //             .translate('number_of_company_products')),
                  // widget.accountTitle == 'المستهلك' ||
                  //         widget.accountTitle == 'جهة إخبارية' ||
                  //         widget.accountTitle == 'شركة توصيل'
                  //     ? Container()
                  //     : TextFormSignupWidget(
                  //         password: false,
                  //         isNumber: true,
                  //         valid: (val) {
                  //           return null;

                  //           // return validInput(val!, 5, 100, "password");
                  //         },
                  //         myController: companyProductsNumber,
                  //       ),
                  // widget.accountTitle == 'المستهلك' ||
                  //         widget.accountTitle == 'جهة إخبارية' ||
                  //         widget.accountTitle == 'شركة توصيل'
                  //     ? Container()
                  //     : TextSignup(
                  //         text: AppLocalizations.of(context)
                  //             .translate('sell_method'),
                  //       ),
                  // widget.accountTitle == 'المستهلك' ||
                  //         widget.accountTitle == 'جهة إخبارية' ||
                  //         widget.accountTitle == 'شركة توصيل'
                  //     ? Container()
                  //     : TextFormSignupWidget(
                  //         password: false,
                  //         isNumber: false,
                  //         valid: (val) {
                  //           return null;

                  //           // return validInput(val!, 5, 100, "password");
                  //         },
                  //         myController: sellType,
                  //       ),
                  // widget.accountTitle == 'المستهلك' ||
                  //         widget.accountTitle == 'جهة إخبارية' ||
                  //         widget.accountTitle == 'شركة توصيل'
                  //     ? Container()
                  //     : TextSignup(
                  //         text: AppLocalizations.of(context)
                  //             .translate('where_to_sell'),
                  //       ),
                  // widget.accountTitle == 'المستهلك' ||
                  //         widget.accountTitle == 'جهة إخبارية' ||
                  //         widget.accountTitle == 'شركة توصيل'
                  //     ? Container()
                  //     : TextFormSignupWidget(
                  //         password: false,
                  //         isNumber: false,
                  //         valid: (val) {
                  //           return null;

                  //           // return validInput(val!, 5, 100, "password");
                  //         },
                  //         myController: toCountry,
                  //       ),
                  // const TextSignup(
                  //   text: 'Location Info :',
                  // ),
                  // const Divider(),
                  // const TextSignup(
                  //   text: 'City',
                  // ),
                  // // TextFormSignupWidget(
                  // //   password: false,
                  // //   isNumber: false,
                  // //   valid: (val) {
                  // //     if (val!.isEmpty) {
                  // //       return AppLocalizations.of(context).translate('required');
                  // //     }
                  // //     return null;

                  // //     // return validInput(val!, 5, 100, "password");
                  // //   },
                  // //   myController: widget.cityController,
                  // // ),
                  // Container(
                  //     width: MediaQuery.of(context).size.width,
                  //     margin:
                  //         const EdgeInsets.symmetric(horizontal: 2, vertical: 10)
                  //             .r,
                  //     // Add some padding and a background color
                  //     padding:
                  //         const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  //     decoration: BoxDecoration(
                  //         color: Colors.green.withOpacity(0.1),
                  //         borderRadius: BorderRadius.circular(10),
                  //         border: Border.all(
                  //           color: AppColor.black,
                  //         )),
                  //     // Create the dropdown button
                  //     child: DropdownButton<String>(
                  //       // Set the selected value
                  //       value: selectedCity,
                  //       menuMaxHeight: 200.h,
                  //       itemHeight: 50.h,
                  //       // Handle the value change
                  //       onChanged: (String? newValue) {
                  //         setState(() {
                  //           selectedCity = newValue ?? '';
                  //         });
                  //       },
                  //       // Map each option to a widget
                  //       items:
                  //           cities.map<DropdownMenuItem<String>>((String value) {
                  //         return DropdownMenuItem<String>(
                  //           value: value,
                  //           // Use a colored box to show the option
                  //           child: Text(
                  //             value,
                  //             style: const TextStyle(
                  //               color: Colors.black,
                  //             ),
                  //           ),
                  //         );
                  //       }).toList(),
                  //     )),
                  const TextSignup(
                    text: 'Address Details',
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
                  // const TextSignup(
                  //   text: 'Floor Number',
                  // ),
                  // TextFormSignupWidget(
                  //   password: false,
                  //   isNumber: true,
                  //   valid: (val) {
                  //     if (val!.isEmpty) {
                  //       return AppLocalizations.of(context).translate('required');
                  //     }
                  //     return null;

                  //     // return validInput(val!, 5, 100, "password");
                  //   },
                  //   myController: floorNumController,
                  // ),
                  // const TextSignup(
                  //   text: 'Location Type',
                  // ),
                  // Row(
                  //   children: [
                  //     Row(
                  //       children: [
                  //         Radio(
                  //           value: 'work',
                  //           groupValue: _selectedLocationType,
                  //           onChanged: (value) {
                  //             setState(() {
                  //               _selectedLocationType = value ?? '';
                  //             });
                  //           },
                  //           activeColor: AppColor.backgroundColor,
                  //         ),
                  //         Row(
                  //           children: [
                  //             Icon(Icons.work_outline_outlined,
                  //                 color: AppColor.backgroundColor, size: 15.sp),
                  //             const Text('Work')
                  //           ],
                  //         )
                  //       ],
                  //     ),
                  //     SizedBox(
                  //       width: 20.w,
                  //     ),
                  //     Row(
                  //       children: [
                  //         Radio(
                  //           value: 'home',
                  //           groupValue: _selectedLocationType,
                  //           onChanged: (value) {
                  //             setState(() {
                  //               _selectedLocationType = value ?? "";
                  //             });
                  //           },
                  //           activeColor: AppColor.backgroundColor,
                  //         ),
                  //         Row(
                  //           children: [
                  //             Icon(Icons.home,
                  //                 color: AppColor.backgroundColor, size: 15.sp),
                  //             const Text('Home'),
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  // widget.accountTitle == 'المستهلك'
                  //     ? Container()
                  //     : TextSignup(
                  //         text: AppLocalizations.of(context)
                  //             .translate('copy_of_trade_license')),
                  // widget.accountTitle == 'المستهلك'
                  //     ? Container()
                  //     : Column(
                  //         children: [
                  //           SizedBox(
                  //             height: 10.h,
                  //           ),
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //             children: [
                  //               addPhotoButton(
                  //                   context: context,
                  //                   text: 'add_from_camera',
                  //                   onPressed: () {
                  //                     getTradeImage(ImageSource.camera);
                  //                   }),
                  //               addPhotoButton(
                  //                   context: context,
                  //                   text: 'add_from_gallery',
                  //                   onPressed: () {
                  //                     getTradeImage(ImageSource.gallery);
                  //                   }),
                  //             ],
                  //           ),
                  //           SizedBox(
                  //             height: 10.h,
                  //           ),
                  //           tradeLicensePhoto != null
                  //               ? Center(
                  //                   child: Image.file(
                  //                     tradeLicensePhoto!,
                  //                     width: 250.w,
                  //                     height: 250.h,
                  //                     fit: BoxFit.cover,
                  //                   ),
                  //                 )
                  //               : Center(
                  //                   child: Container(
                  //                     height: MediaQuery.of(context).size.height *
                  //                         0.5,
                  //                     decoration: BoxDecoration(
                  //                         color: Colors.green.withOpacity(0.1),
                  //                         image: const DecorationImage(
                  //                             image: AssetImage(
                  //                                 "assets/images/logo.png"),
                  //                             fit: BoxFit.cover)),
                  //                   ),
                  //                 ),
                  //         ],
                  //       ),

                  // TextSignup(
                  //   text: AppLocalizations.of(context).translate('profile_photo'),
                  // ),
                  // SizedBox(
                  //   height: 10.h,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: [
                  //     addPhotoButton(
                  //         context: context,
                  //         text: 'add_from_camera',
                  //         onPressed: () {
                  //           getProfileImage(ImageSource.camera);
                  //         }),
                  //     addPhotoButton(
                  //         context: context,
                  //         text: 'add_from_gallery',
                  //         onPressed: () {
                  //           getProfileImage(ImageSource.gallery);
                  //         }),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 10.h,
                  // ),
                  // profileImage != null
                  //     ? Center(
                  //         child: Image.file(
                  //           profileImage!,
                  //           width: 250.w,
                  //           height: 250.h,
                  //           fit: BoxFit.cover,
                  //         ),
                  //       )
                  //     : Center(
                  //         child: Center(
                  //           child: Container(
                  //             height: MediaQuery.of(context).size.height * 0.5,
                  //             decoration: BoxDecoration(
                  //                 color: Colors.green.withOpacity(0.1),
                  //                 image: const DecorationImage(
                  //                     image: AssetImage("assets/images/logo.png"),
                  //                     fit: BoxFit.cover)),
                  //           ),
                  //         ),
                  //       ),
                  // SizedBox(
                  //   height: 10.h,
                  // ),
                  // TextSignup(
                  //   text: AppLocalizations.of(context).translate('cover_photo'),
                  // ),
                  // SizedBox(
                  //   height: 10.h,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: [
                  //     addPhotoButton(
                  //         context: context,
                  //         text: 'add_from_camera',
                  //         onPressed: () {
                  //           getCoverImage(ImageSource.camera);
                  //         }),
                  //     addPhotoButton(
                  //         context: context,
                  //         text: 'add_from_gallery',
                  //         onPressed: () {
                  //           getCoverImage(ImageSource.gallery);
                  //         }),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 10.h,
                  // ),
                  // coverImage != null
                  //     ? Center(
                  //         child: Image.file(
                  //           coverImage!,
                  //           width: 250.w,
                  //           height: 250.h,
                  //           fit: BoxFit.cover,
                  //         ),
                  //       )
                  //     : Center(
                  //         child: Center(
                  //           child: Container(
                  //             height: MediaQuery.of(context).size.height * 0.5,
                  //             decoration: BoxDecoration(
                  //                 color: Colors.green.withOpacity(0.1),
                  //                 image: const DecorationImage(
                  //                     image: AssetImage("assets/images/logo.png"),
                  //                     fit: BoxFit.cover)),
                  //           ),
                  //         ),
                  //       ),
                  // // widget.accountTitle == 'المستهلك' ||
                  // //         widget.accountTitle == 'جهة إخبارية'
                  // //     ? Container()
                  // //     : TextSignup(
                  // //         text: AppLocalizations.of(context)
                  // //             .translate('banner_photo'),
                  // //       ),
                  // // widget.accountTitle == 'المستهلك' ||
                  // //         widget.accountTitle == 'جهة إخبارية'
                  // //     ? Container()
                  // //     : Column(
                  // //         children: [
                  // //           SizedBox(
                  // //             height: 10.h,
                  // //           ),
                  // //           Row(
                  // //             mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // //             children: [
                  // //               addPhotoButton(
                  // //                   context: context,
                  // //                   text: 'add_from_camera',
                  // //                   onPressed: () {
                  // //                     getBanerImage(ImageSource.camera);
                  // //                   }),
                  // //               addPhotoButton(
                  // //                   context: context,
                  // //                   text: 'add_from_gallery',
                  // //                   onPressed: () {
                  // //                     getBanerImage(ImageSource.gallery);
                  // //                   }),
                  // //             ],
                  // //           ),
                  // //           SizedBox(
                  // //             height: 10.h,
                  // //           ),
                  // //           banerImage != null
                  // //               ? Center(
                  // //                   child: Image.file(
                  // //                     banerImage!,
                  // //                     width: 250.w,
                  // //                     height: 250.h,
                  // //                     fit: BoxFit.cover,
                  // //                   ),
                  // //                 )
                  // //               : Center(
                  // //                   child: Center(
                  // //                     child: Container(
                  // //                       height: MediaQuery.of(context).size.height *
                  // //                           0.5,
                  // //                       decoration: BoxDecoration(
                  // //                           color: Colors.green.withOpacity(0.1),
                  // //                           image: const DecorationImage(
                  // //                               image: AssetImage(
                  // //                                   "assets/images/logo.png"),
                  // //                               fit: BoxFit.cover)),
                  // //                     ),
                  // //                   ),
                  // //                 ),
                  // //         ],
                  // //       ),
                  // SizedBox(
                  //   height: 10.h,
                  // ),
                  // widget.accountTitle == 'المستهلك' ||
                  //         widget.accountTitle == 'جهة إخبارية'
                  //     ? Container()
                  //     : TextSignup(
                  //         text: AppLocalizations.of(context)
                  //             .translate('front_id_photo'),
                  //       ),
                  // widget.accountTitle == 'المستهلك' ||
                  //         widget.accountTitle == 'جهة إخبارية'
                  //     ? Container()
                  //     : Column(
                  //         children: [
                  //           SizedBox(
                  //             height: 10.h,
                  //           ),
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //             children: [
                  //               addPhotoButton(
                  //                   context: context,
                  //                   text: 'add_from_camera',
                  //                   onPressed: () {
                  //                     getFrontIdImage(
                  //                       ImageSource.camera,
                  //                     );
                  //                   }),
                  //               addPhotoButton(
                  //                   context: context,
                  //                   text: 'add_from_gallery',
                  //                   onPressed: () {
                  //                     getFrontIdImage(
                  //                       ImageSource.gallery,
                  //                     );
                  //                   }),
                  //             ],
                  //           ),
                  //           SizedBox(
                  //             height: 10.h,
                  //           ),
                  //           frontIdPhoto != null
                  //               ? Center(
                  //                   child: Image.file(
                  //                     frontIdPhoto!,
                  //                     width: 250.w,
                  //                     height: 250.h,
                  //                     fit: BoxFit.cover,
                  //                   ),
                  //                 )
                  //               : Center(
                  //                   child: Center(
                  //                     child: Container(
                  //                       height:
                  //                           MediaQuery.of(context).size.height *
                  //                               0.5,
                  //                       decoration: BoxDecoration(
                  //                           color: Colors.green.withOpacity(0.1),
                  //                           image: const DecorationImage(
                  //                               image: AssetImage(
                  //                                   "assets/images/logo.png"),
                  //                               fit: BoxFit.cover)),
                  //                     ),
                  //                   ),
                  //                 ),
                  //         ],
                  //       ),
                  // SizedBox(
                  //   height: 10.h,
                  // ),
                  // widget.accountTitle == 'المستهلك' ||
                  //         widget.accountTitle == 'جهة إخبارية'
                  //     ? Container()
                  //     : TextSignup(
                  //         text: AppLocalizations.of(context)
                  //             .translate('back_id_photo'),
                  //       ),
                  // widget.accountTitle == 'المستهلك' ||
                  //         widget.accountTitle == 'جهة إخبارية'
                  //     ? Container()
                  //     : Column(
                  //         children: [
                  //           SizedBox(
                  //             height: 10.h,
                  //           ),
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //             children: [
                  //               addPhotoButton(
                  //                   context: context,
                  //                   text: 'add_from_camera',
                  //                   onPressed: () {
                  //                     getBackIdImage(
                  //                       ImageSource.camera,
                  //                     );
                  //                   }),
                  //               addPhotoButton(
                  //                   context: context,
                  //                   text: 'add_from_gallery',
                  //                   onPressed: () {
                  //                     getBackIdImage(
                  //                       ImageSource.gallery,
                  //                     );
                  //                   }),
                  //             ],
                  //           ),
                  //           SizedBox(
                  //             height: 10.h,
                  //           ),
                  //           backIdPhoto != null
                  //               ? Center(
                  //                   child: Image.file(
                  //                     backIdPhoto!,
                  //                     width: 250.w,
                  //                     height: 250.h,
                  //                     fit: BoxFit.cover,
                  //                   ),
                  //                 )
                  //               : Center(
                  //                   child: Center(
                  //                     child: Container(
                  //                       height:
                  //                           MediaQuery.of(context).size.height *
                  //                               0.5,
                  //                       decoration: BoxDecoration(
                  //                           color: Colors.green.withOpacity(0.1),
                  //                           image: const DecorationImage(
                  //                               image: AssetImage(
                  //                                   "assets/images/logo.png"),
                  //                               fit: BoxFit.cover)),
                  //                     ),
                  //                   ),
                  //                 ),
                  //         ],
                  //       ),
                  // SizedBox(
                  //   height: 10.h,
                  // ),
                  // widget.accountTitle == 'شركة توصيل'
                  //     ? Column(
                  //         children: [
                  //           const TextSignup(
                  //             text: 'delev',
                  //           ),
                  //           SizedBox(
                  //             height: 10.h,
                  //           ),
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //             children: [
                  //               addPhotoButton(
                  //                   context: context,
                  //                   text: 'add_from_camera',
                  //                   onPressed: () {
                  //                     getdeliveryPermitImage(ImageSource.camera);
                  //                   }),
                  //               addPhotoButton(
                  //                   context: context,
                  //                   text: 'add_from_gallery',
                  //                   onPressed: () {
                  //                     getdeliveryPermitImage(ImageSource.gallery);
                  //                   }),
                  //             ],
                  //           ),
                  //           SizedBox(
                  //             height: 10.h,
                  //           ),
                  //           deliveryPermitPhoto != null
                  //               ? Center(
                  //                   child: Image.file(
                  //                     deliveryPermitPhoto!,
                  //                     width: 250.w,
                  //                     height: 250.h,
                  //                     fit: BoxFit.cover,
                  //                   ),
                  //                 )
                  //               : Center(
                  //                   child: Container(
                  //                     height: MediaQuery.of(context).size.height *
                  //                         0.5,
                  //                     decoration: BoxDecoration(
                  //                         color: Colors.green.withOpacity(0.1),
                  //                         image: const DecorationImage(
                  //                             image: AssetImage(
                  //                                 "assets/images/logo.png"),
                  //                             fit: BoxFit.cover)),
                  //                   ),
                  //                 ),
                  //         ],
                  //       )
                  //     : const SizedBox(),
                  // SizedBox(
                  //   height: 20.h,
                  // ),
                  Container(
                    width: 100.w,
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
                          onPressed: () {
                            if (!formKey.currentState!.validate()) return;
                            // if (profileImage == null || coverImage == null) {
                            //   showDialog(
                            //     context: context,
                            //     builder: (BuildContext context) {
                            //       return AlertDialog(
                            //         title: Text(
                            //           AppLocalizations.of(context)
                            //               .translate('no_image_selected'),
                            //           style: const TextStyle(color: AppColor.red),
                            //         ),
                            //         content: Text(
                            //           AppLocalizations.of(context).translate(
                            //               'please_select_an_image_before_uploading'),
                            //           style: const TextStyle(color: AppColor.red),
                            //         ),
                            //         actions: [
                            //           ElevatedButton(
                            //             child: Text(AppLocalizations.of(context)
                            //                 .translate('ok')),
                            //             onPressed: () {
                            //               Navigator.of(context).pop();
                            //             },
                            //           ),
                            //         ],
                            //       );
                            //     },
                            //   );
                            //   return;
                            // }
                            // final String userType = getUserType();
                            // if (userType == 'local_company') {
                            //   if (frontIdPhoto == null || backIdPhoto == null) {
                            //     showDialog(
                            //       context: context,
                            //       builder: (BuildContext context) {
                            //         return AlertDialog(
                            //           title: Text(
                            //             AppLocalizations.of(context)
                            //                 .translate('no_image_selected'),
                            //             style:
                            //                 const TextStyle(color: AppColor.red),
                            //           ),
                            //           content: Text(
                            //             AppLocalizations.of(context).translate(
                            //                 'please_select_an_front_and_back_Id_image_before_uploading'),
                            //             style:
                            //                 const TextStyle(color: AppColor.red),
                            //           ),
                            //           actions: [
                            //             ElevatedButton(
                            //               child: Text(AppLocalizations.of(context)
                            //                   .translate('ok')),
                            //               onPressed: () {
                            //                 Navigator.of(context).pop();
                            //               },
                            //             ),
                            //           ],
                            //         );
                            //       },
                            //     );
                            //     return;
                            //   }
                            // }

                            // bloc.add(
                            //   SignUpRequested(
                            //     username:  username.text,
                            //     email:  emailSignup.text,
                            //     password:  passwordSignup.text,
                            //     userType: userType,
                            //     firstMobile:  numberPhoneOne.text,
                            //     secondMobile:  numberPhoneTow.text,
                            //     thirdMobile:  numberPhoneThree.text,
                            //     address:  address.text,
                            //     companyProductsNumber: int.tryParse(
                            //          companyProductsNumber.text),
                            //     sellType:  sellType.text,
                            //     subcategory:  subcategory.text,
                            //     toCountry:  toCountry.text,
                            //     isFreeZoon: _isFreeZone,
                            //     isService: _isService,
                            //     isSelectable: _isSelectable,
                            //     freezoneCity:  freezoneCityController.text,
                            //     deliverable: _isDeliverable,
                            //     profilePhoto: profileImage,
                            //     coverPhoto: coverImage,
                            //     // banerPhoto: banerImage,
                            //     frontIdPhoto: frontIdPhoto,
                            //     backIdPhoto: backIdPhoto,
                            //     bio: bioController.text,
                            //     description:  descriptionController.text,
                            //     website:  websiteController.text,
                            //     link:  linkController.text,
                            //     slogn:  slognController.text,
                            //     title: selectCat?.title,
                            //     deliveryCarsNum: int.tryParse(
                            //          deliveryCarsNumController.text),
                            //     deliveryMotorsNum: int.tryParse(
                            //          deliveryMotorsNumController.text),
                            //     deliveryPermitPhoto: deliveryPermitPhoto,
                            //     deliveryType: deliveryType,
                            //     isThereFoodsDelivery: _isThereFoodsDelivery,
                            //     isThereWarehouse: _isThereWarehouse,
                            //     tradeLicensePhoto: tradeLicensePhoto,
                            //     profitRatio: double.tryParse(
                            //          profitRatioController.text),
                            //     city: selectedCity,
                            //     addressDetails:
                            //          addressDetailsController.text,
                            //     floorNum:
                            //         int.tryParse( floorNumController.text),
                            //     locationType: _selectedLocationType,
                            //     contactName:  contactName.text,
                            //   ),
                            // );
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
                  SizedBox(
                    height: 190.h,
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
    switch (widget.accountTitle) {
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
