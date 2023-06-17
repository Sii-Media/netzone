import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/advertising/blocs/add_ads/add_ads_bloc.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/add_photo_button.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:date_time_picker/date_time_picker.dart';

import '../utils/app_localizations.dart';

class AddAdsPage extends StatefulWidget {
  const AddAdsPage({super.key});

  @override
  State<AddAdsPage> createState() => _AddAdsPageState();
}

class _AddAdsPageState extends State<AddAdsPage> with ScreenLoader<AddAdsPage> {
  late TextEditingController titleController = TextEditingController();
  late TextEditingController descController = TextEditingController();

  late TextEditingController alphaController = TextEditingController();
  late TextEditingController brandController = TextEditingController();
  late TextEditingController locController = TextEditingController();
  late TextEditingController priceController = TextEditingController();
  late TextEditingController yearController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedStartDate;
  String? _selectedEndDate;
  File? _image;
  Future getImage(ImageSource imageSource) async {
    final image = await ImagePicker().pickImage(source: imageSource);

    if (image == null) return;
    final imageTemporary = File(image.path);

    setState(() {
      _image = imageTemporary;
    });
  }

  final items = [
    'مناطق حرة',
    'سيارات',
    'عقارات',
    'زبائن',
    'شركات',
  ];
  String selectedValue = 'مناطق حرة';

  final addAdsbloc = sl<AddAdsBloc>();

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
            child: BlocListener<AddAdsBloc, AddAdsState>(
              bloc: addAdsbloc,
              listener: (context, state) {
                if (state is AddAdsInProgress) {
                  startLoading();
                } else if (state is AddAdsFailure) {
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
                } else if (state is AddAdsSuccess) {
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          AppLocalizations.of(context).translate('add_ads'),
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
                      Text(
                        '${AppLocalizations.of(context).translate('department')} :',
                        style: TextStyle(
                          color: AppColor.backgroundColor,
                          fontSize: 16.sp,
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
                          child: DropdownButton<String>(
                            // Set the selected value
                            value: selectedValue,
                            // Handle the value change
                            onChanged: (String? newValue) {
                              setState(() => selectedValue = newValue ?? '');
                            },
                            // Map each option to a widget
                            items: items
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                // Use a colored box to show the option
                                child: Text(
                                  AppLocalizations.of(context).translate(value),
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                          )),
                      SizedBox(
                        height: 10.h,
                      ),
                      addAdsFormFeild(
                        context: context,
                        controller: titleController,
                        title: 'address',
                        isNumber: false,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'هذا الحقل مطلوب';
                          }

                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      addAdsFormFeild(
                        context: context,
                        controller: descController,
                        title: 'description',
                        isNumber: false,
                        maxLines: 3,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'هذا الحقل مطلوب';
                          }

                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        '${AppLocalizations.of(context).translate('start_date')} :',
                        style: TextStyle(
                          color: AppColor.backgroundColor,
                          fontSize: 16.sp,
                        ),
                      ),
                      DateTimePicker(
                        initialValue: '',
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
                        type: DateTimePickerType.date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        dateLabelText: 'Date',
                        style: const TextStyle(
                          color: AppColor.black,
                        ),
                        onChanged: (selectedDate) {
                          setState(() {
                            _selectedStartDate = selectedDate;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a date';
                          }
                          return null;
                        },
                        // onSaved: (val) => print(val),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        '${AppLocalizations.of(context).translate('end_date')} :',
                        style: TextStyle(
                          color: AppColor.backgroundColor,
                          fontSize: 16.sp,
                        ),
                      ),
                      DateTimePicker(
                        initialValue: '',
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
                        type: DateTimePickerType.date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        dateLabelText: 'Date',
                        style: const TextStyle(
                          color: AppColor.black,
                        ),
                        onChanged: (selectedDate) {
                          setState(() {
                            _selectedEndDate = selectedDate;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a date';
                          }
                          return null;
                        },
                        // onSaved: (val) => print(val),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      addPhotoButton(
                        context: context,
                        text: 'add_from_gallery',
                        onPressed: () {
                          getImage(ImageSource.gallery);
                        },
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
                      addAdsFormFeild(
                        context: context,
                        controller: alphaController,
                        title: 'CountryAlphaCode',
                        isNumber: false,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'هذا الحقل مطلوب';
                          }

                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      addAdsFormFeild(
                        context: context,
                        controller: brandController,
                        title: 'Brand',
                        isNumber: false,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'هذا الحقل مطلوب';
                          }

                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      addAdsFormFeild(
                        context: context,
                        controller: locController,
                        title: 'الموقع',
                        isNumber: false,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'هذا الحقل مطلوب';
                          }

                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      addAdsFormFeild(
                        context: context,
                        controller: priceController,
                        title: 'price',
                        isNumber: true,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'هذا الحقل مطلوب';
                          }

                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      addAdsFormFeild(
                        context: context,
                        controller: yearController,
                        title: 'year',
                        isNumber: true,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'هذا الحقل مطلوب';
                          }

                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Center(
                        child: addPhotoButton(
                            context: context,
                            text: 'add_ads',
                            onPressed: () {
                              if (!_formKey.currentState!.validate()) return;
                              if (_image == null) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'No Image Selected',
                                        style: TextStyle(color: AppColor.red),
                                      ),
                                      content: const Text(
                                        'Please select an image before uploading.',
                                        style: TextStyle(color: AppColor.red),
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
                              addAdsbloc.add(AddAdsRequestedEvent(
                                advertisingTitle: titleController.text,
                                advertisingStartDate: _selectedStartDate ?? '',
                                advertisingEndDate: _selectedEndDate ?? '',
                                advertisingDescription: descController.text,
                                image: _image!,
                                advertisingCountryAlphaCode:
                                    alphaController.text,
                                advertisingBrand: brandController.text,
                                advertisingYear: yearController.text,
                                advertisingLocation: locController.text,
                                advertisingPrice:
                                    double.tryParse(priceController.text) ?? 0,
                                advertisingType: selectedValue,
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
            )),
      ),
    );
  }

  Column addAdsFormFeild(
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
