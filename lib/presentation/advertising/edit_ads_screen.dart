import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/advertisements/entities/advertisement.dart';
import '../../injection_container.dart';
import '../core/constant/colors.dart';
import '../utils/app_localizations.dart';
import 'blocs/ads/ads_bloc_bloc.dart';

class EditAdsScreen extends StatefulWidget {
  final Advertisement ads;

  const EditAdsScreen({super.key, required this.ads});

  @override
  State<EditAdsScreen> createState() => _EditAdsScreenState();
}

class _EditAdsScreenState extends State<EditAdsScreen>
    with ScreenLoader<EditAdsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController titleController = TextEditingController();
  late TextEditingController descController = TextEditingController();
  late TextEditingController locController = TextEditingController();
  late TextEditingController priceController = TextEditingController();
  late TextEditingController yearController = TextEditingController();
  late TextEditingController colorController = TextEditingController();
  late TextEditingController contactNumberController = TextEditingController();
  late String _selectedStartDate;
  late String _selectedEndDate;
  late bool _isGuarantee;
  late bool _purchasable;
  File? _video;
  String videoName = '';
  final ImagePicker _picker = ImagePicker();
  File? _updatedImage;

  final editBloc = sl<AdsBlocBloc>();
  List<XFile> selectedImagess = [];
  late List<String>? images;
  final ImagePicker imagePicker = ImagePicker();
  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      selectedImagess.addAll(selectedImages);
    }
    setState(() {});
  }

  @override
  void initState() {
    titleController.text = widget.ads.name;
    descController.text = widget.ads.advertisingDescription;
    locController.text = widget.ads.advertisingLocation;
    priceController.text = widget.ads.advertisingPrice;
    yearController.text = widget.ads.advertisingYear;
    colorController.text = widget.ads.color ?? '';
    contactNumberController.text = widget.ads.contactNumber ?? '';
    _selectedStartDate = widget.ads.advertisingStartDate;
    _selectedEndDate = widget.ads.advertisingEndDate;
    _isGuarantee = widget.ads.guarantee ?? false;
    _purchasable = widget.ads.purchasable;
    videoName = widget.ads.advertisingVedio ?? '';
    images = widget.ads.advertisingImageList;
    super.initState();
  }

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Ads',
        ),
        // leading: Icon(Icons.arrow_back_ios_new),
        backgroundColor: AppColor.backgroundColor,
      ),
      body: BlocListener<AdsBlocBloc, AdsBlocState>(
        bloc: editBloc,
        listener: (context, state) {
          if (state is EditAdsInProgress) {
            startLoading();
          } else if (state is EditAdsFailure) {
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
          } else if (state is EditAdsSuccess) {
            stopLoading();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                AppLocalizations.of(context).translate('success'),
              ),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ));
            Navigator.of(context).pop();
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
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: _updatedImage != null
                            ? FileImage(_updatedImage!)
                            // ignore: unnecessary_null_comparison
                            : widget.ads.advertisingImage != null
                                ? CachedNetworkImageProvider(
                                    widget.ads.advertisingImage,
                                  )
                                : Image.network(
                                        'https://static.vecteezy.com/system/resources/previews/005/544/718/original/profile-icon-design-free-vector.jpg')
                                    .image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        final image = await _picker.pickImage(
                            source: ImageSource.gallery);
                        _updatedImage = image == null ? null : File(image.path);
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
                  SizedBox(height: 25.h),
                  TextFormField(
                    controller: titleController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'name',
                      label: Text('name'),
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
                  SizedBox(height: 25.h),
                  TextFormField(
                    controller: descController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'description',
                      label: Text('description'),
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
                  SizedBox(height: 25.h),
                  DateTimePicker(
                    initialValue: widget.ads.advertisingStartDate,
                    decoration: const InputDecoration(
                      hintText: 'start_date',
                      label: Text('start_date'),
                    ),
                    type: DateTimePickerType.dateTime,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Date And Time',
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
                        return 'Please select a date and time';
                      }
                      return null;
                    },
                    // onSaved: (val) => print(val),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  DateTimePicker(
                    initialValue: widget.ads.advertisingEndDate,
                    decoration: const InputDecoration(
                      hintText: 'end_date',
                      label: Text('end_date'),
                    ),
                    type: DateTimePickerType.dateTime,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Date And Time',
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
                        return 'Please select a date and time';
                      }
                      return null;
                    },
                    // onSaved: (val) => print(val),
                  ),
                  SizedBox(height: 25.h),
                  TextFormField(
                    controller: colorController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'color',
                      label: Text('color'),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: (text) {
                      return null;
                    },
                  ),
                  SizedBox(height: 25.h),
                  TextFormField(
                    controller: locController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'location',
                      label: Text('location'),
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
                  SizedBox(height: 25.h),
                  TextFormField(
                    controller: priceController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'price',
                      label: Text('price'),
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'field_required_message';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 25.h),
                  TextFormField(
                    controller: contactNumberController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'contactNumber',
                      label: Text('contactNumber'),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: (text) {
                      return null;
                    },
                  ),
                  SizedBox(height: 25.h),
                  TextFormField(
                    controller: yearController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'year',
                      label: Text('year'),
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
                  SizedBox(
                    height: 10.h,
                  ),
                  CheckboxListTile(
                    title: Text(
                      AppLocalizations.of(context).translate('is_purchasable'),
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
                      AppLocalizations.of(context).translate('is_guarantee'),
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

                  // SizedBox(
                  //   height: 10.h,
                  // ),
                  // Row(
                  //   children: [
                  //     Container(
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(250.0).w,
                  //         gradient: LinearGradient(
                  //           begin: Alignment.topCenter,
                  //           end: Alignment.bottomCenter,
                  //           colors: <Color>[
                  //             Colors.greenAccent.withOpacity(0.9),
                  //             AppColor.backgroundColor
                  //           ],
                  //         ),
                  //       ),
                  //       child: RawMaterialButton(
                  //         onPressed: () async {
                  //           final result = await FilePicker.platform.pickFiles(
                  //             type: FileType.custom,
                  //             allowedExtensions: ['mp4'],
                  //           );

                  //           if (result == null) return;
                  //           //Open Single File
                  //           final file = result.files.first;
                  //           // openFile(file);
                  //           setState(() {
                  //             videoName = file.name;
                  //           });
                  //           final newFile = await saveFilePermanently(file);

                  //           setState(() {
                  //             _video = newFile;
                  //           });
                  //         },
                  //         child: const Text(
                  //           'pick video',
                  //           style: TextStyle(color: AppColor.white),
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(
                  //       width: 10,
                  //     ),
                  //     Text(
                  //       videoName,
                  //       style: const TextStyle(
                  //         color: AppColor.backgroundColor,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    height: 20.h,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;
                        editBloc.add(EditAdsEvent(
                          id: widget.ads.id,
                          advertisingTitle: titleController.text,
                          advertisingStartDate: _selectedStartDate,
                          advertisingEndDate: _selectedEndDate,
                          advertisingDescription: descController.text,
                          advertisingYear: yearController.text,
                          advertisingLocation: locController.text,
                          advertisingPrice: double.parse(priceController.text),
                          advertisingType: widget.ads.advertisingType,
                          purchasable: _purchasable,
                          category: widget.ads.category,
                          color: colorController.text,
                          contactNumber: contactNumberController.text,
                          guarantee: _isGuarantee,
                          image: _updatedImage,
                          type: widget.ads.type,
                          video: _video,
                        ));
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
                      child: const Center(
                        child: Text(
                          'save_changes',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');
    return File(file.path!).copy(newFile.path);
  }
}
