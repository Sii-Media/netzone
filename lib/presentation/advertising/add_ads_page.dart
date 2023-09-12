import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
import 'package:path_provider/path_provider.dart';

import '../data/cars.dart';
import '../notifications/blocs/notifications/notifications_bloc.dart';
import '../utils/app_localizations.dart';

class AddAdsPage extends StatefulWidget {
  const AddAdsPage({super.key});

  @override
  State<AddAdsPage> createState() => _AddAdsPageState();
}

class _AddAdsPageState extends State<AddAdsPage> with ScreenLoader<AddAdsPage> {
  late TextEditingController titleController = TextEditingController();
  late TextEditingController descController = TextEditingController();

  late TextEditingController locController = TextEditingController();
  late TextEditingController priceController = TextEditingController();
  late TextEditingController yearController = TextEditingController();
  late TextEditingController colorController = TextEditingController();
  late TextEditingController contactNumberController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedStartDate;
  String? _selectedEndDate;
  String? selectedCarType;
  String? selectedCategory;
  bool _isGuarantee = false;

  File? _image;
  final cars = carTypes;
  Future getImage(ImageSource imageSource) async {
    final image = await ImagePicker().pickImage(source: imageSource);

    if (image == null) return;
    final imageTemporary = File(image.path);

    setState(() {
      _image = imageTemporary;
    });
  }

  final items = [
    'company',
    'car',
    'planes',
    'real_estate',
    'product',
    'service'
  ];
  String selectedValue = 'company';
  File? _video;
  String videoName = '';

  List<XFile> imageFileList = [];

  final ImagePicker imagePicker = ImagePicker();
  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    setState(() {});
  }

  int _totalPrice = 0;

  void _calculateTotalPrice() {
    if (_selectedStartDate != null && _selectedEndDate != null) {
      DateTime startDate = DateTime.parse(_selectedStartDate!);
      DateTime endDate = DateTime.parse(_selectedEndDate!);
      Duration difference = endDate.difference(startDate);
      int totalPrice = difference.inDays * 5;
      setState(() {
        _totalPrice = totalPrice;
      });
    }
  }

  final addAdsbloc = sl<AddAdsBloc>();
  final notifiBloc = sl<NotificationsBloc>();
  bool _purchasable = false;
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
                  Navigator.of(context).pop();
                  FirebaseMessaging.instance.getToken().then((value) {
                    notifiBloc.add(SendNotificationEvent(
                        fcmtoken: value ?? '',
                        text: titleController.text,
                        category: 'advertiments',
                        itemId: state.msg));
                  });
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
                        title: 'title',
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
                            _calculateTotalPrice();
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
                            _calculateTotalPrice();
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
                      Text(
                        '${AppLocalizations.of(context).translate('total_amount')}: $_totalPrice AED',
                        style: TextStyle(
                          color: AppColor.colorOne,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      selectedValue == 'car'
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                  child: DropdownButton<String>(
                                    value: selectedCarType,
                                    hint: const Text('Select car type'),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedCarType = value;
                                        selectedCategory =
                                            null; // Reset the selected category when the car type changes
                                      });
                                    },
                                    items: carTypes.map((carType) {
                                      return DropdownMenuItem<String>(
                                        value: carType.name,
                                        child: Text(carType.name),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                if (selectedCarType != null)
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
                                    child: DropdownButton<String>(
                                      value: selectedCategory,
                                      hint: const Text('Select category'),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedCategory = value;
                                        });
                                      },
                                      items: carTypes
                                          .firstWhere((carType) =>
                                              carType.name == selectedCarType)
                                          .categories
                                          .map((category) {
                                        return DropdownMenuItem<String>(
                                          value: category,
                                          child: Text(category),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                              ],
                            )
                          : const SizedBox(),
                      SizedBox(
                        height: 10.h,
                      ),
                      selectedValue == 'car'
                          ? addAdsFormFeild(
                              context: context,
                              controller: colorController,
                              title: 'color',
                              isNumber: false,
                              validator: (val) {
                                return null;
                              },
                            )
                          : const SizedBox(),
                      SizedBox(
                        height: 10.h,
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
                        controller: contactNumberController,
                        title: 'contactNumber',
                        isNumber: true,
                        validator: (val) {
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
                      CheckboxListTile(
                        title: Text(
                          AppLocalizations.of(context)
                              .translate('is_purchasable'),
                          style: TextStyle(
                            color: AppColor.backgroundColor,
                            fontSize: 15.sp,
                          ),
                        ),
                        activeColor: AppColor.backgroundColor,
                        value: _purchasable,
                        onChanged: (bool? value) {
                          setState(() {
                            _purchasable = value ?? false;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      CheckboxListTile(
                        title: Text(
                          AppLocalizations.of(context)
                              .translate('is_guarantee'),
                          style: TextStyle(
                            color: AppColor.backgroundColor,
                            fontSize: 15.sp,
                          ),
                        ),
                        activeColor: AppColor.backgroundColor,
                        value: _isGuarantee,
                        onChanged: (bool? value) {
                          setState(() {
                            _isGuarantee = value ?? false;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20.h,
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
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .translate('add product images'),
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
                                  width:
                                      MediaQuery.of(context).size.width.w - 85,
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
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(250.0).w,
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
                                final result =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['mp4'],
                                );

                                if (result == null) return;
                                //Open Single File
                                final file = result.files.first;
                                // openFile(file);
                                setState(() {
                                  videoName = file.name;
                                });
                                final newFile = await saveFilePermanently(file);

                                setState(() {
                                  _video = newFile;
                                });
                              },
                              child: const Text(
                                'pick video',
                                style: TextStyle(color: AppColor.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            videoName,
                            style: const TextStyle(
                              color: AppColor.backgroundColor,
                            ),
                          ),
                        ],
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
                                      title: Text(
                                        AppLocalizations.of(context)
                                            .translate('no_image_selected'),
                                        style: const TextStyle(
                                            color: AppColor.red),
                                      ),
                                      content: Text(
                                        AppLocalizations.of(context).translate(
                                            'please_select_an_image_before_uploading'),
                                        style: const TextStyle(
                                            color: AppColor.red),
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
                                advertisingYear: yearController.text,
                                advertisingLocation: locController.text,
                                advertisingPrice:
                                    double.tryParse(priceController.text) ?? 0,
                                advertisingType: selectedValue,
                                advertisingImageList: imageFileList,
                                video: _video,
                                purchasable: _purchasable,
                                type: selectedCarType,
                                category: selectedCategory,
                                color: colorController.text,
                                contactNumber: contactNumberController.text,
                                guarantee: _isGuarantee,
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

  Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');
    return File(file.path!).copy(newFile.path);
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
