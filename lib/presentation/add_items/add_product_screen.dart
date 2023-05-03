import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  File? _image;
  File? _gif;

  Future getImage(ImageSource imageSource) async {
    final image = await ImagePicker().pickImage(source: imageSource);

    if (image == null) return;
    final imageTemporary = File(image.path);

    setState(() {
      _image = imageTemporary;
    });
  }

  Future getGif(ImageSource imageSource) async {
    final image = await ImagePicker().pickImage(source: imageSource);

    if (image == null) return;
    final gifTemporary = File(image.path);

    setState(() {
      _gif = gifTemporary;
    });
  }

  late TextEditingController categoryName = TextEditingController();
  late TextEditingController productName = TextEditingController();
  late TextEditingController productImage = TextEditingController();
  late TextEditingController productPrice = TextEditingController();
  late TextEditingController productDesc = TextEditingController();
  late TextEditingController productAddress = TextEditingController();
  late TextEditingController mobileController = TextEditingController();
  late TextEditingController madeInController = TextEditingController();

  late TextEditingController productProps = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(
              top: 4.0, bottom: 20, right: 8.0, left: 8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'إضافة منتج',
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
                addProductTextField(
                  context: context,
                  controller: categoryName,
                  title: 'الفئة :',
                  isNumber: false,
                ),
                SizedBox(
                  height: 7.h,
                ),
                addProductTextField(
                  context: context,
                  controller: productName,
                  title: 'اسم المنتج :',
                  isNumber: false,
                ),
                SizedBox(
                  height: 7.h,
                ),
                addProductTextField(
                  context: context,
                  controller: productDesc,
                  title: 'الوصف :',
                  isNumber: false,
                  maxLine: 3,
                ),
                SizedBox(
                  height: 7.h,
                ),
                addProductTextField(
                  context: context,
                  controller: productPrice,
                  title: 'السعر :',
                  isNumber: true,
                ),
                SizedBox(
                  height: 7.h,
                ),
                addProductTextField(
                  context: context,
                  title: 'العنوان :',
                  controller: productAddress,
                  isNumber: false,
                ),
                SizedBox(
                  height: 7.h,
                ),
                addProductTextField(
                  context: context,
                  title: 'رقم الهاتف :',
                  controller: mobileController,
                  isNumber: false,
                ),
                SizedBox(
                  height: 7.h,
                ),
                addProductTextField(
                  context: context,
                  title: 'الخصائص :',
                  controller: productProps,
                  isNumber: false,
                  maxLine: 2,
                ),
                SizedBox(
                  height: 7.h,
                ),
                addProductTextField(
                  context: context,
                  title: 'بلد الصنع :',
                  controller: madeInController,
                  isNumber: false,
                ),
                SizedBox(
                  height: 7.h,
                ),
                Text(
                  'إضافة صورة للمنتح',
                  style: TextStyle(
                    color: AppColor.backgroundColor,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(
                  height: 7.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    addPhotoButton(
                        text: 'إضافة صورة من الكاميرا',
                        onPressed: () {
                          getImage(ImageSource.camera);
                        }),
                    addPhotoButton(
                        text: 'إضافة صورة من المعرض',
                        onPressed: () {
                          getImage(ImageSource.gallery);
                        }),
                  ],
                ),
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
                addPhotoButton(
                    text: 'إضافة GIF للمنتج',
                    onPressed: () {
                      getGif(ImageSource.gallery);
                    }),
                SizedBox(
                  height: 10.h,
                ),
                _gif != null
                    ? Center(
                        child: Image.file(
                          _gif!,
                          width: 250.w,
                          height: 250.h,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://www.shutterstock.com/image-vector/gif-circle-icon-vector-260nw-1169098342.jpg',
                          width: 250.w,
                          height: 250.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                SizedBox(
                  height: 15.h,
                ),
              ],
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
              fontSize: 11.0.sp,
            ),
          ),
        ),
      ),
    );
  }

  Column addProductTextField({
    required BuildContext context,
    required String title,
    required bool isNumber,
    TextEditingController? controller,
    int? maxLine,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColor.backgroundColor,
            fontSize: 15.sp,
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
            maxLines: maxLine,
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
