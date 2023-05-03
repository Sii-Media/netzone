import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:image_picker/image_picker.dart';

class AddNewScreen extends StatefulWidget {
  const AddNewScreen({super.key});

  @override
  State<AddNewScreen> createState() => _AddNewScreenState();
}

class _AddNewScreenState extends State<AddNewScreen> {
  late TextEditingController titleController = TextEditingController();
  late TextEditingController descController = TextEditingController();
  File? _image;

  @override
  Widget build(BuildContext context) {
    Future getImage(ImageSource imageSource) async {
      final image = await ImagePicker().pickImage(source: imageSource);

      if (image == null) return;
      final imageTemporary = File(image.path);

      setState(() {
        _image = imageTemporary;
      });
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: BackgroundWidget(
          widget: Padding(
            padding: const EdgeInsets.only(
              top: 4.0,
              bottom: 20,
              right: 8.0,
              left: 8.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'إضافة خبر',
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
                    title: 'العنوان',
                    isNumber: false,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  addNewsTextField(
                    context: context,
                    controller: descController,
                    title: 'موضوع الخبر',
                    isNumber: false,
                    maxLines: 5,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  addPhotoButton(
                      text: 'إضافة صورة من المعرض',
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
                    child:
                        addPhotoButton(text: 'إضافة الخبر', onPressed: () {}),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  // TextFormField(
                  //   style: const TextStyle(color: Colors.black),
                  //   controller: descController,
                  //   maxLines: 5,
                  //   decoration: InputDecoration(
                  //     hintStyle:
                  //         const TextStyle(color: AppColor.backgroundColor),
                  //     hintText: 'موضوع الخبر',
                  //     border: const OutlineInputBorder(),
                  //     floatingLabelBehavior: FloatingLabelBehavior.always,
                  //     contentPadding: const EdgeInsets.symmetric(
                  //             vertical: 5, horizontal: 10)
                  //         .flipped,
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ClipRRect addPhotoButton(
      {required String text, required void Function()? onPressed}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(250.0).w,
      child: Container(
        width: 150.w,
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
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.0.sp,
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
          title,
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
