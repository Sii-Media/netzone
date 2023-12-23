import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netzoon/presentation/aramex/blocs/aramex_bloc/aramex_bloc.dart';
import 'package:netzoon/presentation/core/widgets/add_file_button.dart';
import 'package:netzoon/presentation/notifications/blocs/notifications/notifications_bloc.dart';
import 'package:readmore/readmore.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

import 'package:netzoon/domain/categories/entities/factories/factories.dart';
import 'package:netzoon/injection_container.dart' as di;
import 'package:netzoon/presentation/auth/blocs/sign_up/sign_up_bloc.dart';
import 'package:netzoon/presentation/auth/widgets/background_auth_widget.dart';
import 'package:netzoon/presentation/auth/widgets/text_form_signup_widget.dart';
import 'package:netzoon/presentation/auth/widgets/text_signup_widget.dart';
import 'package:netzoon/presentation/core/blocs/country_bloc/country_bloc.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/helpers/get_city_from_country.dart';
import 'package:netzoon/presentation/core/widgets/add_photo_button.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:netzoon/presentation/language_screen/blocs/language_bloc/language_bloc.dart';
import 'package:netzoon/presentation/legal_advice/blocs/legal_advice/legal_advice_bloc.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../../../injection_container.dart';
import '../../categories/factories/blocs/factories_bloc/factories_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    super.key,
    required this.accountTitle,
    this.withAdd = true,
  });
  final String accountTitle;
  final bool? withAdd;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with ScreenLoader<SignUpPage> {
  final SignUpBloc bloc = di.sl<SignUpBloc>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailSignup = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController contactName = TextEditingController();

  final TextEditingController passwordSignup = TextEditingController();
  final TextEditingController confirmPasswordSignup = TextEditingController();

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

  final GlobalKey<FormFieldState> confirmPasswordFormFieldKey =
      GlobalKey<FormFieldState>();
  final LegalAdviceBloc adviceBloc = sl<LegalAdviceBloc>();
  late final LanguageBloc langBloc;
  late final CountryBloc countryBloc;
  final aramexBloc = sl<AramexBloc>();
  final notifiBloc = sl<NotificationsBloc>();

  @override
  void initState() {
    langBloc = BlocProvider.of<LanguageBloc>(context);
    langBloc.add(GetLanguage());
    countryBloc = BlocProvider.of<CountryBloc>(context);
    countryBloc.add(GetCountryEvent());
    aramexBloc.add(const FetchCitiesEvent());
    if (widget.accountTitle == 'المصانع') {
      factoryBloc.add(GetAllFactoriesEvent());
    }
    super.initState();
  }

  @override
  Widget screen(BuildContext context) {
    return BlocListener(
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
          if (state.user.userInfo.userType == 'local_company' ||
              state.user.userInfo.userType == 'factory' ||
              state.user.userInfo.userType == 'trader') {
            FirebaseMessaging.instance.getToken().then((value) {
              notifiBloc.add(SendNotificationEvent(
                  fcmtoken: value ?? '',
                  text: state.user.userInfo.userType ?? '',
                  username: state.user.userInfo.username ?? '',
                  category: 'account',
                  itemId: state.user.userInfo.id,
                  body:
                      'created an account as ${state.user.userInfo.userType}'));
            });
          }
          // Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          //     CupertinoPageRoute(builder: (context) {
          //   return const TestScreen();
          // }), (route) => false);
          while (context.canPop()) {
            context.pop();
          }
          context.push('/home');
        }
      },
      child: SignUpWidget(
        formKey: formKey,
        adviceBloc: adviceBloc,
        langBloc: langBloc,
        accountTitle: widget.accountTitle,
        emailSignup: emailSignup,
        username: username,
        contactName: contactName,
        passwordSignup: passwordSignup,
        passwordFormFieldKey: passwordFormFieldKey,
        aboutSignup: aboutSignup,
        numberPhoneOne: numberPhoneOne,
        numberPhoneTow: numberPhoneTow,
        numberPhoneThree: numberPhoneThree,
        bloc: bloc,
        emailFormFieldKey: _emailFormFieldKey,
        address: address,
        subcategory: subcategory,
        companyProductsNumber: companyProductsNumber,
        sellType: sellType,
        toCountry: toCountry,
        bioController: bioController,
        descriptionController: descriptionController,
        websiteController: websiteController,
        slognController: slognController,
        linkController: linkController,
        titleController: titleController,
        freezoneCityController: freezoneCityController,
        factoriesBloc: factoryBloc,
        deliveryCarsNumController: deliveryCarsNumController,
        deliveryMotorsNumController: deliveryMotorsNumController,
        profitRatioController: profitRatioController,
        cityController: cityController,
        addressDetailsController: addressDetailsController,
        floorNumController: floorNumController,
        countryBloc: countryBloc,
        withAdd: widget.withAdd,
        confirmPasswordFormFieldKey: confirmPasswordFormFieldKey,
        confirmPasswordSignup: confirmPasswordSignup,
        aramexBloc: aramexBloc,
      ),
    );
  }
}

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({
    super.key,
    required this.formKey,
    required this.adviceBloc,
    required this.langBloc,
    required this.accountTitle,
    required this.emailSignup,
    required this.username,
    required this.contactName,
    required this.passwordSignup,
    required this.aboutSignup,
    required this.numberPhoneOne,
    required this.numberPhoneTow,
    required this.numberPhoneThree,
    required this.bloc,
    required this.emailFormFieldKey,
    required this.passwordFormFieldKey,
    required this.subcategory,
    required this.address,
    required this.companyProductsNumber,
    required this.sellType,
    required this.toCountry,
    required this.bioController,
    required this.descriptionController,
    required this.websiteController,
    required this.slognController,
    required this.linkController,
    required this.titleController,
    required this.freezoneCityController,
    required this.factoriesBloc,
    required this.deliveryCarsNumController,
    required this.deliveryMotorsNumController,
    required this.profitRatioController,
    required this.cityController,
    required this.addressDetailsController,
    required this.floorNumController,
    required this.countryBloc,
    this.withAdd,
    required this.confirmPasswordFormFieldKey,
    required this.confirmPasswordSignup,
    required this.aramexBloc,
  });
  final GlobalKey<FormState> formKey;
  final GlobalKey<FormFieldState> emailFormFieldKey;
  final GlobalKey<FormFieldState> passwordFormFieldKey;
  final GlobalKey<FormFieldState> confirmPasswordFormFieldKey;

  final String accountTitle;
  final TextEditingController emailSignup;
  final TextEditingController username;
  final TextEditingController contactName;
  final TextEditingController passwordSignup;
  final TextEditingController confirmPasswordSignup;

  final TextEditingController aboutSignup;
  final TextEditingController numberPhoneOne;
  final TextEditingController numberPhoneTow;
  final TextEditingController numberPhoneThree;
  final TextEditingController subcategory;
  final TextEditingController address;
  final TextEditingController companyProductsNumber;
  final TextEditingController sellType;
  final TextEditingController toCountry;
  final TextEditingController bioController;
  final TextEditingController descriptionController;
  final TextEditingController websiteController;
  final TextEditingController slognController;
  final TextEditingController linkController;
  final TextEditingController titleController;
  final TextEditingController freezoneCityController;
  final TextEditingController deliveryCarsNumController;
  final TextEditingController deliveryMotorsNumController;
  final TextEditingController profitRatioController;
  final TextEditingController cityController;
  final TextEditingController addressDetailsController;
  final TextEditingController floorNumController;
  final LegalAdviceBloc adviceBloc;
  final LanguageBloc langBloc;
  final SignUpBloc bloc;
  final FactoriesBloc factoriesBloc;
  final CountryBloc countryBloc;
  final bool? withAdd;
  final AramexBloc aramexBloc;
  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

bool showPass = true;
bool showConfirmPass = true;

class _SignUpWidgetState extends State<SignUpWidget> {
  File? profileImage;
  File? coverImage;
  File? banerImage;
  File? frontIdPhoto;
  File? backIdPhoto;
  File? deliveryPermitPhoto;
  File? tradeLicensePhoto;
  final bool _isDeliverable = false;
  bool _isThereWarehouse = false;
  bool _isThereFoodsDelivery = false;
  final bool _isFreeZone = false;
  bool _isSelectable = false;
  bool _isService = false;
  String? deliveryType;
  String? selectedCity;
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

  String? selectedTradeFileName;
  String? selectedFrontIdFileName;
  String? selectedBackIdFileName;

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

  Factories? selectCat;
  String? _selectedLocationType;
  @override
  Widget build(BuildContext context) {
    return BackgroundAuthWidget(
      topLogo: 0.2,
      onTap: () {
        Navigator.of(context).pop();
      },
      topBack: 150.h,
      topWidget: 160.h,
      topTitle: 110.h,
      n: 0.25.h,
      title: AppLocalizations.of(context).translate(widget.accountTitle),
      widget: Form(
        key: widget.formKey,
        child: Container(
          height: MediaQuery.of(context).size.height - 155.h,
          padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 10, vertical: 10),
          color: Colors.grey.withOpacity(0.1),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.accountTitle == 'المصانع'
                    ? BlocBuilder<FactoriesBloc, FactoriesState>(
                        bloc: widget.factoriesBloc,
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
                                        borderRadius: BorderRadius.circular(10),
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
                    text: widget.accountTitle == 'المستهلك'
                        ? AppLocalizations.of(context).translate('username')
                        : AppLocalizations.of(context)
                            .translate('business_name')),
                TextFormField(
                  controller: widget.username,
                  style: const TextStyle(color: Colors.black),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return AppLocalizations.of(context)
                          .translate('username_required');
                    }
                    if (val.length < 2) {
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
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 30)
                            .flipped,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                TextSignup(
                    text: AppLocalizations.of(context).translate('email')),
                TextFormField(
                  key: widget.emailFormFieldKey,
                  controller: widget.emailSignup,
                  style: const TextStyle(color: Colors.black),
                  validator: (text) {
                    if (text!.isEmpty) {
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
                    widget.emailFormFieldKey.currentState!.validate();
                  },
                  decoration: InputDecoration(
                    filled: true,
                    //<-- SEE HERE
                    fillColor: Colors.green.withOpacity(0.1),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 30)
                            .flipped,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                TextSignup(
                    text:
                        AppLocalizations.of(context).translate('contact_name')),
                TextFormField(
                  controller: widget.contactName,
                  style: const TextStyle(color: Colors.black),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return AppLocalizations.of(context).translate('required');
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    //<-- SEE HERE
                    fillColor: Colors.green.withOpacity(0.1),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 30)
                            .flipped,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                TextSignup(
                    text:
                        AppLocalizations.of(context).translate('phone_number')),
                TextFormSignupWidget(
                  password: false,
                  isNumber: true,
                  valid: (val) {
                    if (val!.isEmpty) {
                      return AppLocalizations.of(context).translate('required');
                    }

                    return null;
                  },
                  myController: widget.numberPhoneOne,
                ),
                TextSignup(
                    text: AppLocalizations.of(context).translate('password')),
                TextFormField(
                  key: widget.passwordFormFieldKey,
                  controller: widget.passwordSignup,
                  style: const TextStyle(color: AppColor.black),
                  decoration: InputDecoration(
                    filled: true,
                    //<-- SEE HERE
                    fillColor: Colors.green.withOpacity(0.1),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 30)
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
                    widget.passwordFormFieldKey.currentState!.validate();
                  },
                ),
                TextSignup(
                  text: AppLocalizations.of(context)
                      .translate('confirm_password'),
                ),
                TextFormField(
                  key: widget.confirmPasswordFormFieldKey,
                  controller: widget.confirmPasswordSignup,
                  style: const TextStyle(color: AppColor.black),
                  decoration: InputDecoration(
                    filled: true,
                    //<-- SEE HERE
                    fillColor: Colors.green.withOpacity(0.1),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 30)
                            .flipped,
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          showConfirmPass = !showConfirmPass;
                        });
                      },
                      child: showConfirmPass
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
                  obscureText: showConfirmPass,
                  validator: (value) {
                    if (value != widget.passwordSignup.text) {
                      return AppLocalizations.of(context)
                          .translate('password_dont_match');
                    }
                    return null;
                  },
                  onChanged: (text) {
                    widget.confirmPasswordFormFieldKey.currentState!.validate();
                  },
                ),

                // TextSignup(
                //     text: AppLocalizations.of(context)
                //         .translate('mobile_number')),
                // TextFormSignupWidget(
                //   password: false,
                //   isNumber: true,
                //   myController: widget.numberPhoneTow,
                // ),
                // TextSignup(
                //     text: AppLocalizations.of(context)
                //         .translate('contact_numbers')),
                // TextFormSignupWidget(
                //   password: false,
                //   isNumber: true,
                //   myController: widget.numberPhoneThree,
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
                // TextSignup(text: AppLocalizations.of(context).translate('Bio')),
                // TextFormField(
                //   controller: widget.bioController,
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
                //   controller: widget.descriptionController,
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
                //   controller: widget.websiteController,
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
                //   controller: widget.linkController,
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
                //   controller: widget.slognController,
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
                //               myController: widget.freezoneCityController,
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
                widget.accountTitle == 'شركة توصيل'
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
                widget.accountTitle == 'شركة توصيل'
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

                widget.accountTitle == 'شركة توصيل'
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
                widget.accountTitle == 'شركة توصيل'
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
                              myController: widget.deliveryCarsNumController,
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),

                widget.accountTitle == 'شركة توصيل'
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
                              myController: widget.deliveryMotorsNumController,
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
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
                //         myController: widget.subcategory,
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
                //           if (val!.isEmpty) {
                //             return AppLocalizations.of(context)
                //                 .translate('required');
                //           }

                //           return null;
                //         },
                //         myController: widget.address,
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
                widget.accountTitle != 'الشركات المحلية'
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
                              myController: widget.profitRatioController,
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),

                widget.accountTitle != 'الشركات المحلية' &&
                        widget.accountTitle != 'المصانع'
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
                // : Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Expanded(
                //           child: TextSignup(
                //               text: AppLocalizations.of(context)
                //                   .translate('affiliated_to_a_free_zone'))),
                //       SizedBox(
                //         width: 20.w,
                //         child: CheckboxListTile(
                //           controlAffinity: ListTileControlAffinity.leading,
                //           onChanged: (val) {
                //             // print("object");
                //             // controller.checkbox(val!);
                //           },
                //           value: widget.rememberMe,
                //         ),
                //       )
                //     ],
                //   ),
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
                //         myController: widget.companyProductsNumber,
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
                //         myController: widget.sellType,
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
                //         myController: widget.toCountry,
                //       ),
                TextSignup(
                  text:
                      '${AppLocalizations.of(context).translate('Location Info')} :',
                ),
                const Divider(),
                TextSignup(
                  text: AppLocalizations.of(context).translate('city'),
                ),
                // TextFormSignupWidget(
                //   password: false,
                //   isNumber: false,
                //   valid: (val) {
                //     if (val!.isEmpty) {
                //       return AppLocalizations.of(context).translate('required');
                //     }
                //     return null;

                //     // return validInput(val!, 5, 100, "password");
                //   },
                //   myController: widget.cityController,
                // ),
                // BlocBuilder<CountryBloc, CountryState>(
                //   bloc: widget.countryBloc,
                //   builder: (context, countryState) {
                //     late List<String> selectedCountry = [];

                //     if (countryState is CountryInitial) {
                //       selectedCountry = getCitiesFromCountry(
                //           country: countryState.selectedCountry);

                //       return Container(
                //           width: MediaQuery.of(context).size.width,
                //           margin: const EdgeInsets.symmetric(
                //                   horizontal: 2, vertical: 10)
                //               .r,
                //           // Add some padding and a background color
                //           padding: const EdgeInsets.symmetric(
                //               horizontal: 10, vertical: 5),
                //           decoration: BoxDecoration(
                //               color: Colors.green.withOpacity(0.1),
                //               borderRadius: BorderRadius.circular(10),
                //               border: Border.all(
                //                 color: AppColor.black,
                //               )),
                //           // Create the dropdown button
                //           child: DropdownButton<String>(
                //             // Set the selected value
                //             value: selectedCity,
                //             menuMaxHeight: 200.h,
                //             itemHeight: 50.h,
                //             // Handle the value change
                //             onChanged: (String? newValue) {
                //               setState(() {
                //                 selectedCity = newValue ?? '';
                //               });
                //             },
                //             // Map each option to a widget
                //             items: selectedCountry
                //                 .map<DropdownMenuItem<String>>((String value) {
                //               return DropdownMenuItem<String>(
                //                 value: value,
                //                 // Use a colored box to show the option
                //                 child: Text(
                //                   value,
                //                   style: const TextStyle(
                //                     color: Colors.black,
                //                   ),
                //                 ),
                //               );
                //             }).toList(),
                //           ));
                //     }
                //     return const SizedBox();
                //   },
                // ),
                BlocBuilder<CountryBloc, CountryState>(
                  bloc: widget.countryBloc,
                  builder: (context, countryState) {
                    if (countryState is CountryInitial) {
                      return BlocBuilder<AramexBloc, AramexState>(
                        bloc: widget.aramexBloc,
                        builder: (context, armState) {
                          if (armState is FetchCitiesInProgress) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppColor.backgroundColor,
                              ),
                            );
                          } else if (armState is FetchCitiesFailure) {
                            return const Center(
                              child: Text(
                                'error',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            );
                          } else if (armState is FetchCitiesSuccess) {
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
                                ),

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
                                validator: (value) {
                                  if (value == null) {
                                    return AppLocalizations.of(context)
                                        .translate('required');
                                  }

                                  return null;
                                },

                                items: armState.cities,
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
                      );
                    }
                    return const SizedBox();
                  },
                ),

                TextSignup(
                  text:
                      AppLocalizations.of(context).translate('Address Details'),
                ),
                TextFormSignupWidget(
                  password: false,
                  isNumber: false,
                  valid: (val) {
                    if (val!.isEmpty) {
                      return AppLocalizations.of(context).translate('required');
                    }
                    return null;

                    // return validInput(val!, 5, 100, "password");
                  },
                  myController: widget.addressDetailsController,
                ),
                TextSignup(
                  text: AppLocalizations.of(context).translate('floor_number'),
                ),
                TextFormSignupWidget(
                  password: false,
                  isNumber: true,
                  valid: (val) {
                    if (val!.isEmpty) {
                      return AppLocalizations.of(context).translate('required');
                    }
                    return null;

                    // return validInput(val!, 5, 100, "password");
                  },
                  myController: widget.floorNumController,
                ),
                TextSignup(
                  text: AppLocalizations.of(context).translate('location_type'),
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
                            Text(AppLocalizations.of(context).translate('work'))
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
                            Text(
                                AppLocalizations.of(context).translate('home')),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                widget.accountTitle == 'المستهلك'
                    ? Container()
                    : TextSignup(
                        text: AppLocalizations.of(context)
                            .translate('copy_of_trade_license')),
                widget.accountTitle == 'المستهلك'
                    ? Container()
                    : Column(
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //   children: [
                          //     addPhotoButton(
                          //         context: context,
                          //         text: 'add_from_camera',
                          //         onPressed: () {
                          //           getTradeImage(ImageSource.camera);
                          //         }),
                          //     addPhotoButton(
                          //         context: context,
                          //         text: 'add_from_gallery',
                          //         onPressed: () {
                          //           getTradeImage(ImageSource.gallery);
                          //         }),
                          //   ],
                          // ),
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
                          ),
                          // SizedBox(
                          //   height: 10.h,
                          // ),
                          // tradeLicensePhoto != null
                          //     ? Center(
                          //         child: Image.file(
                          //           tradeLicensePhoto!,
                          //           width: 250.w,
                          //           height: 250.h,
                          //           fit: BoxFit.cover,
                          //         ),
                          //       )
                          //     : Center(
                          //         child: Container(
                          //           height: MediaQuery.of(context).size.height *
                          //               0.5,
                          //           decoration: BoxDecoration(
                          //               color: Colors.green.withOpacity(0.1),
                          //               image: const DecorationImage(
                          //                   image: AssetImage(
                          //                       "assets/images/logo.png"),
                          //                   fit: BoxFit.cover)),
                          //         ),
                          //       ),
                        ],
                      ),
                SizedBox(
                  height: 10.h,
                ),
                TextSignup(
                  text: AppLocalizations.of(context).translate('profile_photo'),
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
                          getProfileImage(ImageSource.camera);
                        }),
                    addPhotoButton(
                        context: context,
                        text: 'add_from_gallery',
                        onPressed: () {
                          getProfileImage(ImageSource.gallery);
                        }),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                profileImage != null
                    ? Center(
                        child: Image.file(
                          profileImage!,
                          width: 250.w,
                          height: 250.h,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                image: const DecorationImage(
                                    image: AssetImage("assets/images/logo.png"),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                      ),
                SizedBox(
                  height: 10.h,
                ),
                TextSignup(
                  text: AppLocalizations.of(context).translate('cover_photo'),
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
                          getCoverImage(ImageSource.camera);
                        }),
                    addPhotoButton(
                        context: context,
                        text: 'add_from_gallery',
                        onPressed: () {
                          getCoverImage(ImageSource.gallery);
                        }),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                coverImage != null
                    ? Center(
                        child: Image.file(
                          coverImage!,
                          width: 250.w,
                          height: 250.h,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                image: const DecorationImage(
                                    image: AssetImage("assets/images/logo.png"),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                      ),
                // widget.accountTitle == 'المستهلك' ||
                //         widget.accountTitle == 'جهة إخبارية'
                //     ? Container()
                //     : TextSignup(
                //         text: AppLocalizations.of(context)
                //             .translate('banner_photo'),
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
                //                     getBanerImage(ImageSource.camera);
                //                   }),
                //               addPhotoButton(
                //                   context: context,
                //                   text: 'add_from_gallery',
                //                   onPressed: () {
                //                     getBanerImage(ImageSource.gallery);
                //                   }),
                //             ],
                //           ),
                //           SizedBox(
                //             height: 10.h,
                //           ),
                //           banerImage != null
                //               ? Center(
                //                   child: Image.file(
                //                     banerImage!,
                //                     width: 250.w,
                //                     height: 250.h,
                //                     fit: BoxFit.cover,
                //                   ),
                //                 )
                //               : Center(
                //                   child: Center(
                //                     child: Container(
                //                       height: MediaQuery.of(context).size.height *
                //                           0.5,
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
                SizedBox(
                  height: 10.h,
                ),
                widget.accountTitle == 'المستهلك' ||
                        widget.accountTitle == 'جهة إخبارية'
                    ? Container()
                    : TextSignup(
                        text: AppLocalizations.of(context)
                            .translate('front_id_photo'),
                      ),
                widget.accountTitle == 'المستهلك' ||
                        widget.accountTitle == 'جهة إخبارية'
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
                // : Column(
                //     children: [
                //       SizedBox(
                //         height: 10.h,
                //       ),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                //         children: [
                //           addPhotoButton(
                //               context: context,
                //               text: 'add_from_camera',
                //               onPressed: () {
                //                 getFrontIdImage(
                //                   ImageSource.camera,
                //                 );
                //               }),
                //           addPhotoButton(
                //               context: context,
                //               text: 'add_from_gallery',
                //               onPressed: () {
                //                 getFrontIdImage(
                //                   ImageSource.gallery,
                //                 );
                //               }),
                //         ],
                //       ),
                //       SizedBox(
                //         height: 10.h,
                //       ),
                //       frontIdPhoto != null
                //           ? Center(
                //               child: Image.file(
                //                 frontIdPhoto!,
                //                 width: 250.w,
                //                 height: 250.h,
                //                 fit: BoxFit.cover,
                //               ),
                //             )
                //           : Center(
                //               child: Center(
                //                 child: Container(
                //                   height:
                //                       MediaQuery.of(context).size.height *
                //                           0.5,
                //                   decoration: BoxDecoration(
                //                       color: Colors.green.withOpacity(0.1),
                //                       image: const DecorationImage(
                //                           image: AssetImage(
                //                               "assets/images/logo.png"),
                //                           fit: BoxFit.cover)),
                //                 ),
                //               ),
                //             ),
                //     ],
                //   ),
                SizedBox(
                  height: 10.h,
                ),
                widget.accountTitle == 'المستهلك' ||
                        widget.accountTitle == 'جهة إخبارية'
                    ? Container()
                    : TextSignup(
                        text: AppLocalizations.of(context)
                            .translate('back_id_photo'),
                      ),
                widget.accountTitle == 'المستهلك' ||
                        widget.accountTitle == 'جهة إخبارية'
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
                // : Column(
                //     children: [
                //       SizedBox(
                //         height: 10.h,
                //       ),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                //         children: [
                //           addPhotoButton(
                //               context: context,
                //               text: 'add_from_camera',
                //               onPressed: () {
                //                 getBackIdImage(
                //                   ImageSource.camera,
                //                 );
                //               }),
                //           addPhotoButton(
                //               context: context,
                //               text: 'add_from_gallery',
                //               onPressed: () {
                //                 getBackIdImage(
                //                   ImageSource.gallery,
                //                 );
                //               }),
                //         ],
                //       ),
                //       SizedBox(
                //         height: 10.h,
                //       ),
                //       backIdPhoto != null
                //           ? Center(
                //               child: Image.file(
                //                 backIdPhoto!,
                //                 width: 250.w,
                //                 height: 250.h,
                //                 fit: BoxFit.cover,
                //               ),
                //             )
                //           : Center(
                //               child: Center(
                //                 child: Container(
                //                   height:
                //                       MediaQuery.of(context).size.height *
                //                           0.5,
                //                   decoration: BoxDecoration(
                //                       color: Colors.green.withOpacity(0.1),
                //                       image: const DecorationImage(
                //                           image: AssetImage(
                //                               "assets/images/logo.png"),
                //                           fit: BoxFit.cover)),
                //                 ),
                //               ),
                //             ),
                //     ],
                //   ),
                SizedBox(
                  height: 10.h,
                ),
                widget.accountTitle == 'شركة توصيل'
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
                                    getdeliveryPermitImage(ImageSource.camera);
                                  }),
                              addPhotoButton(
                                  context: context,
                                  text: 'add_from_gallery',
                                  onPressed: () {
                                    getdeliveryPermitImage(ImageSource.gallery);
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
                                    height: MediaQuery.of(context).size.height *
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
                            if (!widget.formKey.currentState!.validate()) {
                              return;
                            }
                            // if (profileImage == null || coverImage == null) {
                            //   showDialog(
                            //     context: context,
                            //     builder: (BuildContext context) {
                            //       return AlertDialog(
                            //         title: Text(
                            //           AppLocalizations.of(context)
                            //               .translate('no_image_selected'),
                            //           style:
                            //               const TextStyle(color: AppColor.red),
                            //         ),
                            //         content: Text(
                            //           AppLocalizations.of(context).translate(
                            //               'please_select_an_image_before_uploading'),
                            //           style:
                            //               const TextStyle(color: AppColor.red),
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
                            final String userType = getUserType();
                            if (userType == 'local_company') {
                              if (frontIdPhoto == null || backIdPhoto == null) {
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
                            if (!widget.formKey.currentState!.validate()) {
                              return;
                            }
                            bool acc = await showDialog(
                              context: context,
                              builder: (context) {
                                return const PriveryPolicyWidget();
                              },
                            );
                            if (acc == true) {
                              widget.bloc.add(
                                SignUpRequested(
                                  username: widget.username.text,
                                  email: widget.emailSignup.text,
                                  password: widget.passwordSignup.text,
                                  userType: userType,
                                  firstMobile: widget.numberPhoneOne.text,
                                  // secondMobile: widget.numberPhoneTow.text,
                                  // thirdMobile: widget.numberPhoneThree.text,
                                  address: widget.address.text,
                                  // companyProductsNumber: int.tryParse(
                                  //     widget.companyProductsNumber.text),
                                  // sellType: widget.sellType.text,
                                  // subcategory: widget.subcategory.text,
                                  // toCountry: widget.toCountry.text,
                                  isFreeZoon: _isFreeZone,
                                  isService: _isService,
                                  isSelectable: _isSelectable,
                                  // freezoneCity:
                                  //     widget.freezoneCityController.text,
                                  // deliverable: _isDeliverable,
                                  profilePhoto: profileImage,
                                  coverPhoto: coverImage,
                                  // banerPhoto: banerImage,
                                  frontIdPhoto: frontIdPhoto,
                                  backIdPhoto: backIdPhoto,
                                  // bio: widget.bioController.text,
                                  // description:
                                  //     widget.descriptionController.text,
                                  // website: widget.websiteController.text,
                                  // link: widget.linkController.text,
                                  // slogn: widget.slognController.text,
                                  title: selectCat?.title,
                                  deliveryCarsNum: int.tryParse(
                                      widget.deliveryCarsNumController.text),
                                  deliveryMotorsNum: int.tryParse(
                                      widget.deliveryMotorsNumController.text),
                                  deliveryPermitPhoto: deliveryPermitPhoto,
                                  deliveryType: deliveryType,
                                  isThereFoodsDelivery: _isThereFoodsDelivery,
                                  isThereWarehouse: _isThereWarehouse,
                                  tradeLicensePhoto: tradeLicensePhoto,
                                  profitRatio: double.tryParse(
                                      widget.profitRatioController.text),
                                  city: selectedCity,
                                  addressDetails:
                                      widget.addressDetailsController.text,
                                  floorNum: int.tryParse(
                                      widget.floorNumController.text),
                                  locationType: _selectedLocationType,
                                  contactName: widget.contactName.text,
                                  withAdd: widget.withAdd,
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
                  height: 190.h,
                ),
              ],
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

class PriveryPolicyWidget extends StatefulWidget {
  const PriveryPolicyWidget({super.key});

  @override
  State<PriveryPolicyWidget> createState() => _PriveryPolicyWidgetState();
}

class _PriveryPolicyWidgetState extends State<PriveryPolicyWidget> {
  final LegalAdviceBloc adviceBloc = sl<LegalAdviceBloc>();
  late final LanguageBloc langBloc;
  @override
  void initState() {
    adviceBloc.add(GetLegalAdviceEvent());
    langBloc = BlocProvider.of<LanguageBloc>(context);
    langBloc.add(GetLanguage());
    super.initState();
  }

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      bloc: langBloc,
      builder: (context, langState) {
        return BlocBuilder<LegalAdviceBloc, LegalAdviceState>(
          bloc: adviceBloc,
          builder: (context, state) {
            if (state is LegalAdviceProgress) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColor.backgroundColor,
                ),
              );
            } else if (state is LegalAdviceFailure) {
              final failure = state.message;
              return Center(
                child: Text(
                  failure,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              );
            } else if (state is LegalAdviceSuccess) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)
                                  .translate('privacy_policy'),
                              style: TextStyle(
                                color: AppColor.backgroundColor,
                                fontSize: 16.sp,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 80.0),
                              child: Column(
                                children: [
                                  ReadMoreText(
                                    langState is EnglishState
                                        ? state.legalAdvices.first.textEn
                                        : state.legalAdvices.first.text,
                                    trimLines: 2,
                                    colorClickableText: Colors.pink,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: 'Show more',
                                    trimExpandedText: 'Show less',
                                    lessStyle:
                                        const TextStyle(color: AppColor.red),
                                    moreStyle: TextStyle(
                                        color: AppColor.colorThree,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: isChecked,
                                        onChanged: (value) {
                                          setState(() {
                                            isChecked = value ?? false;
                                          });
                                        },
                                      ),
                                      Text(AppLocalizations.of(context).translate(
                                          'I agree to the terms and conditions')),
                                    ],
                                  ),
                                  isChecked == true
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            const SizedBox(width: 10),
                                            ElevatedButton(
                                              onPressed: () {
                                                isChecked == true
                                                    ? Navigator.of(context)
                                                        .pop(isChecked)
                                                    : null;
                                              },
                                              child: const Text('Ok'),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                            // const ReadMoreText(
                            //   state.,
                            //   trimLines: 2,
                            //   colorClickableText: Colors.pink,
                            //   trimMode: TrimMode.Line,
                            //   trimCollapsedText: 'Show more',
                            //   trimExpandedText: 'Show less',
                            //   moreStyle: TextStyle(
                            //       fontSize: 14, fontWeight: FontWeight.bold),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        );
      },
    );
  }
}
