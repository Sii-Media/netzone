import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netzoon/domain/company_service/service_category.dart';
import 'package:netzoon/presentation/categories/local_company/local_company_bloc/local_company_bloc.dart';
import 'package:netzoon/presentation/core/widgets/on_failure_widget.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../injection_container.dart';
import '../core/constant/colors.dart';
import '../core/widgets/add_photo_button.dart';
import '../core/widgets/background_widget.dart';
import '../utils/app_localizations.dart';

class AddCompanyServiceScreen extends StatefulWidget {
  const AddCompanyServiceScreen({super.key});

  @override
  State<AddCompanyServiceScreen> createState() =>
      _AddCompanyServiceScreenState();
}

class _AddCompanyServiceScreenState extends State<AddCompanyServiceScreen>
    with ScreenLoader<AddCompanyServiceScreen> {
  late TextEditingController titleController = TextEditingController();
  late TextEditingController descController = TextEditingController();
  late TextEditingController priceController = TextEditingController();
  late TextEditingController whatsAppNumberController = TextEditingController();
  late TextEditingController bioController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final addBloc = sl<LocalCompanyBloc>();
  File? _image;
  List<XFile> imageFileList = [];
  File? _video;
  String videoName = '';
  Future getImage(ImageSource imageSource) async {
    final image = await ImagePicker().pickImage(source: imageSource);

    if (image == null) return;
    final imageTemporary = File(image.path);

    setState(() {
      _image = imageTemporary;
    });
  }

  final ImagePicker imagePicker = ImagePicker();
  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    setState(() {});
  }

  final servicesBloc = sl<LocalCompanyBloc>();
  ServiceCategory? selectCat;
  @override
  void initState() {
    servicesBloc.add(GetServicesCategoriesEvent());

    super.initState();
  }

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        isHome: false,
        widget: Padding(
          padding: const EdgeInsets.only(
            top: 4.0,
            bottom: 20,
            right: 8.0,
            left: 8.0,
          ),
          child: BlocListener<LocalCompanyBloc, LocalCompanyState>(
            bloc: addBloc,
            listener: (context, state) {
              if (state is LocalCompanyInProgress) {
                startLoading();
              } else if (state is LocalCompanyFailure) {
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
              } else if (state is AddCompanyServiceSuccess) {
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
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        AppLocalizations.of(context).translate('add_service'),
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
                    BlocBuilder<LocalCompanyBloc, LocalCompanyState>(
                      bloc: servicesBloc,
                      builder: (context, state) {
                        if (state is GetServicesCategoriesInProgress) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColor.backgroundColor,
                            ),
                          );
                        } else if (state is GetServicesCategoriesFailure) {
                          final failure = state.message;
                          return FailureWidget(
                            failure: failure,
                            onPressed: () {
                              servicesBloc.add(GetServicesCategoriesEvent());
                            },
                          );
                        } else if (state is GetServicesCategoriesSuccess) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context).translate('categ'),
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
                                  child: DropdownButton<ServiceCategory>(
                                    // Set the selected value
                                    value: selectCat,
                                    // // Handle the value change
                                    menuMaxHeight: 300.h,
                                    onChanged: (ServiceCategory? newValue) {
                                      setState(() {
                                        selectCat = newValue!;
                                      });
                                    },
                                    // onChanged: (String? newValue) => setState(
                                    //     () => selectedValue = newValue ?? ''),
                                    // Map each option to a widget
                                    items: state.servicesCategories
                                        .map<DropdownMenuItem<ServiceCategory>>(
                                            (ServiceCategory value) {
                                      return DropdownMenuItem<ServiceCategory>(
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
                        return Container(
                          child: const Text(
                            'asd',
                            style: TextStyle(color: AppColor.backgroundColor),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    addServiceFormFeild(
                      context: context,
                      controller: titleController,
                      title: 'service_name',
                      isNumber: false,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return AppLocalizations.of(context)
                              .translate('required');
                        }

                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    addServiceFormFeild(
                      context: context,
                      controller: descController,
                      title: 'description',
                      maxLines: 4,
                      isNumber: false,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return AppLocalizations.of(context)
                              .translate('required');
                        }

                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    addServiceFormFeild(
                      context: context,
                      controller: priceController,
                      title: 'price',
                      isNumber: true,
                      validator: (val) {
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    addServiceFormFeild(
                      context: context,
                      controller: whatsAppNumberController,
                      title: 'whatsapp_number',
                      isNumber: true,
                      validator: (val) {
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    addServiceFormFeild(
                      context: context,
                      controller: bioController,
                      title: 'Bio',
                      isNumber: true,
                      validator: (val) {
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate('add_service_image'),
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
                            text: 'add_from_camera',
                            onPressed: () {
                              getImage(ImageSource.camera);
                            },
                            context: context),
                        addPhotoButton(
                            text: 'add_from_gallery',
                            onPressed: () {
                              getImage(ImageSource.gallery);
                            },
                            context: context),
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
                              maxHeightDiskCache: 400,
                              maxWidthDiskCache: 400,
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
                                  .translate('add_service_images'),
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
                        text: 'add_service',
                        context: context,
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) return;
                          if (selectCat == null) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    AppLocalizations.of(context)
                                        .translate('please select category'),
                                    style: const TextStyle(color: AppColor.red),
                                  ),
                                  content: Text(
                                    AppLocalizations.of(context).translate(
                                        'please_select_category_befor_uploading'),
                                    style: const TextStyle(color: AppColor.red),
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
                          }
                          addBloc.add(
                            AddCompanyServiceEvent(
                              category: selectCat!.id,
                              title: titleController.text,
                              description: descController.text,
                              price: int.tryParse(priceController.text),
                              image: _image,
                              serviceImageList: imageFileList,
                              whatsAppNumber: whatsAppNumberController.text,
                              bio: bioController.text,
                              video: _video,
                            ),
                          );
                        },
                      ),
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
      ),
    );
  }

  Widget addServiceFormFeild(
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

  void openFile(PlatformFile file) {
    OpenFile.open(file.path);
  }

  Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');
    return File(file.path!).copy(newFile.path);
  }
}
