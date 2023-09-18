import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';

import '../../../../injection_container.dart';
import '../../../core/constant/colors.dart';
import '../../../core/widgets/add_photo_button.dart';
import '../../../core/widgets/background_widget.dart';
import '../../../utils/app_localizations.dart';
import '../blocs/real_estate/real_estate_bloc.dart';

class AddRealEstateScreen extends StatefulWidget {
  const AddRealEstateScreen({super.key});

  @override
  State<AddRealEstateScreen> createState() => _AddRealEstateScreenState();
}

class _AddRealEstateScreenState extends State<AddRealEstateScreen>
    with ScreenLoader<AddRealEstateScreen> {
  File? _image;

  Future getImage(ImageSource imageSource) async {
    final image = await ImagePicker().pickImage(source: imageSource);

    if (image == null) return;
    final imageTemporary = File(image.path);

    setState(() {
      _image = imageTemporary;
    });
  }

  final ImagePicker imagePicker = ImagePicker();

  List<XFile> imageFileList = [];

  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    setState(() {});
  }

  late TextEditingController titleController = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();
  late TextEditingController priceController = TextEditingController();
  late TextEditingController areaController = TextEditingController();
  late TextEditingController locationController = TextEditingController();
  late TextEditingController bedroomsController = TextEditingController();
  late TextEditingController bathroomsController = TextEditingController();

  final realEstateBloc = sl<RealEstateBloc>();

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        isHome: false,
        widget: Padding(
            padding: const EdgeInsets.only(
                top: 4.0, bottom: 20, right: 8.0, left: 8.0),
            child: BlocListener<RealEstateBloc, RealEstateState>(
              bloc: realEstateBloc,
              listener: (context, state) {
                if (state is AddRealEstateInProgress) {
                  startLoading();
                } else if (state is AddRealEstateFailure) {
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
                } else if (state is AddRealEstateSuccess) {
                  stopLoading();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      AppLocalizations.of(context).translate('success'),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ));
                  Navigator.of(context).pop();
                  // FirebaseMessaging.instance.getToken().then((value) {
                  //   notifiBloc.add(SendNotificationEvent(
                  //       fcmtoken: value ?? '',
                  //       text: productName.text,
                  //       category: 'products',
                  //       itemId: state.product));
                  // });
                }
              },
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        AppLocalizations.of(context)
                            .translate('add_real_estate'),
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
                      height: 7.h,
                    ),
                    addTextField(
                      context: context,
                      controller: titleController,
                      title:
                          '${AppLocalizations.of(context).translate('real_estate_name')} :',
                      isNumber: false,
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    addTextField(
                      context: context,
                      controller: descriptionController,
                      title:
                          '${AppLocalizations.of(context).translate('desc')} :',
                      isNumber: false,
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    addTextField(
                      context: context,
                      controller: priceController,
                      title:
                          '${AppLocalizations.of(context).translate('price')} :',
                      isNumber: true,
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    addTextField(
                      context: context,
                      controller: areaController,
                      title:
                          '${AppLocalizations.of(context).translate('area')} :',
                      isNumber: true,
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    addTextField(
                      context: context,
                      controller: locationController,
                      title:
                          '${AppLocalizations.of(context).translate('address')} :',
                      isNumber: false,
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    addTextField(
                      context: context,
                      controller: bedroomsController,
                      title:
                          '${AppLocalizations.of(context).translate('Bedrooms')} :',
                      isNumber: true,
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    addTextField(
                      context: context,
                      controller: bathroomsController,
                      title:
                          '${AppLocalizations.of(context).translate('Bathrooms')} :',
                      isNumber: true,
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        addPhotoButton(
                            context: context,
                            text: 'add_from_camera',
                            onPressed: () {
                              getImage(ImageSource.camera);
                            }),
                        addPhotoButton(
                            context: context,
                            text: 'add_from_gallery',
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
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 70.0, vertical: 50),
                                child: CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                  color: AppColor.backgroundColor,

                                  // strokeWidth: 10,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)
                                  .translate('add_real_estate_images'),
                              style: TextStyle(
                                color: AppColor.backgroundColor,
                                fontSize: 15.sp,
                              ),
                            ),
                            Text(
                              '${AppLocalizations.of(context).translate('maximum images')} : 6',
                              style: TextStyle(
                                color: AppColor.secondGrey,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                        addPhotoButton(
                            context: context,
                            text: 'Selecte Images',
                            onPressed: () {
                              selectImages();
                            }),
                      ],
                    ),
                    SizedBox(
                      height: imageFileList.isNotEmpty ? 200.h : 10.h,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: imageFileList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Card(
                              child: SizedBox(
                                height: 200.h,
                                width: MediaQuery.of(context).size.width.w - 85,
                                child: Image.file(
                                  File(imageFileList[index].path),
                                  fit: BoxFit.contain,
                                  // height: 100,
                                  // width: 100,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Center(
                      child: addPhotoButton(
                          context: context,
                          text: 'add_real_estate',
                          onPressed: () {
                            if (_image == null) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      AppLocalizations.of(context)
                                          .translate('no_image_selected'),
                                      style:
                                          const TextStyle(color: AppColor.red),
                                    ),
                                    content: Text(
                                      AppLocalizations.of(context).translate(
                                          'please_select_an_image_before_uploading'),
                                      style:
                                          const TextStyle(color: AppColor.red),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate('ok'),
                                        ),
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
                            realEstateBloc.add(AddRealEstateEvent(
                              title: titleController.text,
                              image: _image!,
                              description: descriptionController.text,
                              price: int.parse(priceController.text),
                              area: int.parse(areaController.text),
                              location: locationController.text,
                              bedrooms: int.parse(bedroomsController.text),
                              bathrooms: int.parse(bathroomsController.text),
                            ));
                          }),
                    ),
                    SizedBox(
                      height: 80.h,
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Widget addTextField({
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
