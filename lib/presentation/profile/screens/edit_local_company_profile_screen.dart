import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';

import '../../../domain/auth/entities/user_info.dart';
import '../../../injection_container.dart';
import '../../core/constant/colors.dart';
import '../../utils/app_localizations.dart';
import '../blocs/edit_profile/edit_profile_bloc.dart';
import 'change_password_screen.dart';

class EditLocalCompanyprofileScreen extends StatefulWidget {
  final UserInfo userInfo;
  const EditLocalCompanyprofileScreen({super.key, required this.userInfo});

  @override
  State<EditLocalCompanyprofileScreen> createState() =>
      _EditLocalCompanyprofileScreenState();
}

class _EditLocalCompanyprofileScreenState
    extends State<EditLocalCompanyprofileScreen>
    with ScreenLoader<EditLocalCompanyprofileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _contactNameController = TextEditingController();

  final TextEditingController _firstMobileController = TextEditingController();
  final TextEditingController _secondeMobileController =
      TextEditingController();
  final TextEditingController _thirdMobileController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subcategoryController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _sellTypeController = TextEditingController();
  final TextEditingController _toCountryController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  final TextEditingController _descController = TextEditingController();

  final TextEditingController _websiteController = TextEditingController();

  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _slognController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  File? _updatedImage;
  File? _updatedCoverPhoto;

  @override
  void initState() {
    _userNameController.text = widget.userInfo.username ?? '';
    _contactNameController.text = widget.userInfo.contactName ?? '';
    _firstMobileController.text = widget.userInfo.firstMobile ?? '';
    _secondeMobileController.text = widget.userInfo.secondeMobile ?? '';
    _thirdMobileController.text = widget.userInfo.thirdMobile ?? '';
    _emailController.text = widget.userInfo.email ?? '';
    _subcategoryController.text = widget.userInfo.subcategory ?? '';
    _addressController.text = widget.userInfo.address ?? '';
    _sellTypeController.text = widget.userInfo.sellType ?? '';
    _toCountryController.text = widget.userInfo.toCountry ?? '';
    _bioController.text = widget.userInfo.bio ?? '';
    _descController.text = widget.userInfo.description ?? '';
    _websiteController.text = widget.userInfo.website ?? '';
    _linkController.text = widget.userInfo.link ?? '';
    _slognController.text = widget.userInfo.slogn ?? '';
    super.initState();
  }

  final editBloc = sl<EditProfileBloc>();

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.h,
        title: Text(
          AppLocalizations.of(context).translate('edit_profile'),
        ),
        // leading: Icon(Icons.arrow_back_ios_new),
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
            UserInfo userInfo = UserInfo(
              username: _userNameController.text,
              email: _emailController.text,
              password: widget.userInfo.password,
              userType: widget.userInfo.userType,
              firstMobile: _firstMobileController.text,
              secondeMobile: _secondeMobileController.text,
              thirdMobile: _thirdMobileController.text,
              profilePhoto: _updatedImage?.path,
              isFreeZoon: widget.userInfo.isFreeZoon,
              id: widget.userInfo.id,
              contactName: widget.userInfo.contactName,
            );
            Navigator.of(context).pop(userInfo);
          }
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 104 / 2),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      decoration: BoxDecoration(
                        color: AppColor.backgroundColor,
                        image: DecorationImage(
                            image: _updatedCoverPhoto != null
                                ? FileImage(_updatedCoverPhoto!)
                                : widget.userInfo.coverPhoto != null
                                    ? CachedNetworkImageProvider(
                                        widget.userInfo.coverPhoto ?? '')
                                    : Image.network(
                                            'https://static.vecteezy.com/system/resources/previews/005/544/718/original/profile-icon-design-free-vector.jpg')
                                        .image,
                            fit: BoxFit.cover),
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          final coverImage = await _picker.pickImage(
                              source: ImageSource.gallery);
                          _updatedCoverPhoto =
                              coverImage == null ? null : File(coverImage.path);
                          setState(() {});
                        },
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            height: 35,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              // borderRadius: const BorderRadius.only(
                              //   bottomRight: Radius.circular(80),
                              //   bottomLeft: Radius.circular(80),
                              // ),
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: AppColor.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 78,
                        height: 78,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: _updatedImage != null
                                  ? FileImage(_updatedImage!)
                                  : widget.userInfo.profilePhoto != null
                                      ? CachedNetworkImageProvider(
                                          widget.userInfo.profilePhoto ?? '')
                                      : Image.network(
                                              'https://static.vecteezy.com/system/resources/previews/005/544/718/original/profile-icon-design-free-vector.jpg')
                                          .image,
                              fit: BoxFit.cover),
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            final image = await _picker.pickImage(
                                source: ImageSource.gallery);
                            _updatedImage =
                                image == null ? null : File(image.path);
                            setState(() {});
                          },
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 38,
                              width: 78,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(80),
                                  bottomLeft: Radius.circular(80),
                                ),
                              ),
                              child: SvgPicture.asset(
                                'assets/images/portrait_profile.svg',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Profile_Photo',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColor.backgroundColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () async {
                              final image = await _picker.pickImage(
                                  source: ImageSource.gallery);
                              _updatedImage =
                                  image == null ? null : File(image.path);
                              setState(() {});
                            },
                            child: const Text(
                              'change',
                              style: TextStyle(
                                color: AppColor.colorTwo,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'email',
                      prefixIcon: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.email_rounded)),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'field_required_message';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _userNameController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      label: Text('first_name'),
                      hintText: 'first_name',
                      prefixIcon: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.person)),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'field_required_message';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _contactNameController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      label: Text('contact_name'),
                      hintText: 'contact_name',
                      prefixIcon: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.person)),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'field_required_message';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _firstMobileController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      label: Text('first mobile number'),
                      hintText: 'first mobile number',
                      prefixIcon: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.phone_android)),
                    ),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'field_required_message';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _secondeMobileController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      label: Text('second mobile number'),
                      hintText: 'second mobile number',
                      prefixIcon: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.phone_android)),
                    ),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _thirdMobileController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      label: Text('third mobile number'),
                      hintText: 'third mobile number',
                      prefixIcon: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.phone_android)),
                    ),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _subcategoryController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      label: Text('sub category'),
                      hintText: 'sub category',
                      prefixIcon: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.person)),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _addressController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      label: Text('address'),
                      hintText: 'address',
                      prefixIcon: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.location_city)),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _toCountryController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      label: Text('To Country'),
                      hintText: 'To Country',
                      prefixIcon: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.person)),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _sellTypeController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      label: Text('Sell Type'),
                      hintText: 'Sell Type',
                      prefixIcon: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.person)),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _bioController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      label: Text('Bio'),
                      hintText: 'Bio',
                      prefixIcon: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.add_outlined)),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    enableIMEPersonalizedLearning: true,
                    minLines: 1,
                    textInputAction: TextInputAction.newline,
                    validator: (text) {
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _descController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      label: Text('Description'),
                      hintText: 'Description',
                      prefixIcon: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.add_outlined)),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    enableIMEPersonalizedLearning: true,
                    minLines: 1,
                    textInputAction: TextInputAction.newline,
                    validator: (text) {
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _websiteController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      label: Text('Website'),
                      hintText: 'Website',
                      prefixIcon: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.app_registration_sharp)),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: (text) {
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _linkController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      label: Text('Link'),
                      hintText: 'Link',
                      prefixIcon: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.link)),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: (text) {
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _slognController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      label: Text('Slogn'),
                      hintText: 'Slogn',
                      prefixIcon: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.add_outlined)),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    validator: (text) {
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const ChangePasswordScreen();
                      }));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).cardColor,
                      ),
                      overlayColor: MaterialStateProperty.all(
                          Theme.of(context).splashColor),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13.0),
                        ),
                      ),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.all(14.0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.password,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 15.sp,
                        ),
                        const SizedBox(width: 10.0),
                        Text(
                          AppLocalizations.of(context)
                              .translate('change_password'),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 16.sp,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16.0,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;
                        editBloc.add(
                          OnEditProfileEvent(
                              username: _userNameController.text,
                              email: _emailController.text,
                              firstMobile: _firstMobileController.text,
                              secondeMobile: _secondeMobileController.text,
                              thirdMobile: _thirdMobileController.text,
                              profilePhoto: _updatedImage,
                              coverPhoto: _updatedCoverPhoto,
                              bio: _bioController.text,
                              description: _descController.text,
                              link: _linkController.text,
                              slogn: _slognController.text,
                              website: _websiteController.text,
                              address: _addressController.text,
                              contactName: _contactNameController.text),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          AppColor.backgroundColor,
                        ),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                        fixedSize: const MaterialStatePropertyAll(
                          Size.fromWidth(200),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('save_changes'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
