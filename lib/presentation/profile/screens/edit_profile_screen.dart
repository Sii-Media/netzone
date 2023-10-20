import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../../../domain/auth/entities/user_info.dart';
import '../../../injection_container.dart';
import '../../core/widgets/screen_loader.dart';
import '../blocs/edit_profile/edit_profile_bloc.dart';
import 'change_password_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.userInfo});
  final UserInfo userInfo;
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with ScreenLoader<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _firstMobileController = TextEditingController();
  final TextEditingController _secondeMobileController =
      TextEditingController();
  final TextEditingController _thirdMobileController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _bioController = TextEditingController();

  final TextEditingController _descController = TextEditingController();

  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _slognController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  File? _updatedImage;

  @override
  void initState() {
    _userNameController.text = widget.userInfo.username ?? '';
    _firstMobileController.text = widget.userInfo.firstMobile ?? '';
    _secondeMobileController.text = widget.userInfo.secondeMobile ?? '';
    _thirdMobileController.text = widget.userInfo.thirdMobile ?? '';
    _emailController.text = widget.userInfo.email ?? '';
    _bioController.text = widget.userInfo.bio ?? '';
    _descController.text = widget.userInfo.description ?? '';
    _websiteController.text = widget.userInfo.website ?? '';
    _linkController.text = widget.userInfo.link ?? '';
    _slognController.text = widget.userInfo.slogn ?? '';
    _addressController.text = widget.userInfo.address ?? '';
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
            style: const TextStyle(
              color: AppColor.backgroundColor,
            ),
          ),
          // leading: Icon(Icons.arrow_back_ios_new),
          backgroundColor: AppColor.white,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_rounded,
              color: AppColor.backgroundColor,
              size: 15.sp,
            ),
          ),
        ),
        body: BlocListener<EditProfileBloc, EditProfileState>(
          bloc: editBloc,
          listener: (context, state) {
            if (state is EditProfileInProgress) {
              startLoading();
            } else if (state is EditProfileFailure) {
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
                  id: widget.userInfo.id);
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
                    Row(
                      children: [
                        Container(
                          width: 78.r,
                          height: 78.r,
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
                                height: 38.r,
                                width: 78.r,
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
                            Text(
                              'Profile_Photo',
                              style: TextStyle(
                                fontSize: 16.sp,
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
                              child: Text(
                                'change',
                                style: TextStyle(
                                  color: AppColor.colorTwo,
                                  fontSize: 14.sp,
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
                      decoration: InputDecoration(
                        hintText: 'email',
                        prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.email_rounded,
                              size: 15.sp,
                            )),
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
                      decoration: InputDecoration(
                        hintText: 'first_name',
                        prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.person,
                              size: 15.sp,
                            )),
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
                      decoration: InputDecoration(
                        hintText: 'first mobile number',
                        prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.phone_android,
                              size: 15.sp,
                            )),
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
                      decoration: InputDecoration(
                        hintText: 'second mobile number',
                        prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.phone_android,
                              size: 15.sp,
                            )),
                      ),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: _secondeMobileController,
                      style: const TextStyle(
                        color: AppColor.backgroundColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'third mobile number',
                        prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.phone_android,
                              size: 15.sp,
                            )),
                      ),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
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
                      controller: _bioController,
                      style: const TextStyle(
                        color: AppColor.backgroundColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Bio',
                        prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.add_outlined,
                              size: 15.sp,
                            )),
                      ),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (text) {
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: _bioController,
                      style: const TextStyle(
                        color: AppColor.backgroundColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Description',
                        prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.add_outlined,
                              size: 15.sp,
                            )),
                      ),
                      keyboardType: TextInputType.text,
                      maxLines: 3,
                      textInputAction: TextInputAction.next,
                      validator: (text) {
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: _bioController,
                      style: const TextStyle(
                        color: AppColor.backgroundColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Website',
                        prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.app_registration_sharp,
                              size: 15.sp,
                            )),
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
                      decoration: InputDecoration(
                        hintText: 'Link',
                        prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.link,
                              size: 15.sp,
                            )),
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
                      decoration: InputDecoration(
                        hintText: 'Slogn',
                        prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.add_outlined,
                              size: 15.sp,
                            )),
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
                            size: 16.0.sp,
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
                          editBloc.add(OnEditProfileEvent(
                            username: _userNameController.text,
                            email: _emailController.text,
                            firstMobile: _firstMobileController.text,
                            secondeMobile: _secondeMobileController.text,
                            thirdMobile: _thirdMobileController.text,
                            profilePhoto: _updatedImage,
                            bio: _bioController.text,
                            description: _descController.text,
                            link: _linkController.text,
                            slogn: _slognController.text,
                            website: _websiteController.text,
                            address: _addressController.text,
                          ));
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            AppColor.backgroundColor,
                          ),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
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
        ));
  }
}
