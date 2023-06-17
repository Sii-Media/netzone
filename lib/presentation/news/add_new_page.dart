import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/add_photo_button.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:netzoon/presentation/news/blocs/add_news/add_news_bloc.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class AddNewScreen extends StatefulWidget {
  const AddNewScreen({super.key});

  @override
  State<AddNewScreen> createState() => _AddNewScreenState();
}

class _AddNewScreenState extends State<AddNewScreen>
    with ScreenLoader<AddNewScreen> {
  late TextEditingController titleController = TextEditingController();
  late TextEditingController descController = TextEditingController();
  File? _image;

  final newsBloc = sl<AddNewsBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget screen(BuildContext context) {
    Future getImage(ImageSource imageSource) async {
      final image = await ImagePicker().pickImage(source: imageSource);

      if (image == null) return;
      final imageTemporary = File(image.path);

      setState(() {
        _image = imageTemporary;
      });
    }

    return Scaffold(
      body: BackgroundWidget(
        widget: Padding(
          padding: const EdgeInsets.only(
            top: 4.0,
            bottom: 20,
            right: 8.0,
            left: 8.0,
          ),
          child: BlocListener<AddNewsBloc, AddNewsState>(
            bloc: newsBloc,
            listener: (context, state) {
              if (state is AddNewsInProgress) {
                startLoading();
              } else if (state is AddNewsFailure) {
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
              } else if (state is AddNewsSuccess) {
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      AppLocalizations.of(context).translate('add_news'),
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
                  addNewsTextField(
                    context: context,
                    controller: titleController,
                    title: 'address',
                    isNumber: false,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  addNewsTextField(
                    context: context,
                    controller: descController,
                    title: 'news_subject',
                    isNumber: false,
                    maxLines: 5,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  addPhotoButton(
                      context: context,
                      text: 'add_from_gallery',
                      onPressed: () {
                        getImage(ImageSource.gallery);
                      }),
                  SizedBox(
                    height: 10.h,
                  ),
                  _image != null
                      ? Center(
                          child: Image.file(
                            _image!,
                            width: 250.w,
                            height: 250.h,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://lh3.googleusercontent.com/EbXw8rOdYxOGdXEFjgNP8lh-YAuUxwhOAe2jhrz3sgqvPeMac6a6tHvT35V6YMbyNvkZL4R_a2hcYBrtfUhLvhf-N2X3OB9cvH4uMw=w1064-v0',
                            width: 250.w,
                            height: 250.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Center(
                    child: addPhotoButton(
                        context: context,
                        text: 'add_the_news',
                        onPressed: () {
                          if (_image == null) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    AppLocalizations.of(context)
                                        .translate('no_image_selected'),
                                    style: const TextStyle(color: AppColor.red),
                                  ),
                                  content: Text(
                                    AppLocalizations.of(context).translate(
                                        'please_select_an_image_before_uploading'),
                                    style: const TextStyle(color: AppColor.red),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      child: const Text('OK'),
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
                          newsBloc.add(AddNewsRequested(
                            title: titleController.text,
                            description: descController.text,
                            image: _image!,
                            ownerName: 'ownerName',
                            ownerImage:
                                'https://is3-ssl.mzstatic.com/image/thumb/Purple112/v4/31/17/79/311779d6-bfe8-d8d5-4782-81bd4c5f01ea/AppIcon-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/1200x630wa.png',
                          ));
                        }),
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

  Column addNewsTextField({
    required BuildContext context,
    required String title,
    required bool isNumber,
    TextEditingController? controller,
    int? maxLines,
  }) {
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
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 10).r,
          child: TextFormField(
            style: const TextStyle(color: Colors.black),
            keyboardType: isNumber
                ? const TextInputType.numberWithOptions(decimal: true)
                : TextInputType.text,
            // validator: (){},
            controller: controller,
            maxLines: maxLines,
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
        ),
      ],
    );
  }
}
