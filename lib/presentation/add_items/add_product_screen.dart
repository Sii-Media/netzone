import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netzoon/domain/departments/entities/departments_categories/departments_categories.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/add_items/blocs/bloc/add_product_bloc.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:netzoon/presentation/home/blocs/elec_devices/elec_devices_bloc.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen>
    with ScreenLoader<AddProductScreen> {
  final items = [
    'الكترونيات',
    'أجهزة المنزل والمكتب',
    "موضة رجالية",
    "موضة نسائية",
    "منتجات غذائية",
    "عطور",
    'ساعات',
  ];
  String selectedValue = 'الكترونيات';

  DepartmentsCategories? selectCat;
  File? _image;
  File? _gif;
  File? _video;
  String videoName = '';

  String department = '';

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

  final AddProductBloc addBloc = sl<AddProductBloc>();
  final catBloc = sl<ElecDevicesBloc>();
  List<String> item2 = [""];
  bool _isGuarantee = false;
  @override
  void initState() {
    catBloc.add(const GetElcDevicesEvent(department: 'الكترونيات'));
    // selectCat = DepartmentsCategories(
    //     name: 'جوالات', department: '', imageUrl: '', products: []);
    super.initState();
  }

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          catBloc.add(const GetElcDevicesEvent(department: 'الكترونيات'));
        },
        color: AppColor.white,
        backgroundColor: AppColor.backgroundColor,
        child: BackgroundWidget(
          widget: Padding(
            padding: const EdgeInsets.only(
                top: 4.0, bottom: 20, right: 8.0, left: 8.0),
            child: BlocListener<AddProductBloc, AddProductState>(
              bloc: addBloc,
              listener: (context, state) {
                if (state is AddProductInProgress) {
                  startLoading();
                } else if (state is AddProductFailure) {
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
                } else if (state is AddProductSuccess) {
                  stopLoading();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      AppLocalizations.of(context).translate('success'),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ));
                }
              },
              child: BlocBuilder<ElecDevicesBloc, ElecDevicesState>(
                bloc: catBloc,
                builder: (context, state) {
                  if (state is ElecDevicesInProgress) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.backgroundColor,
                      ),
                    );
                  } else if (state is ElecDevicesFailure) {
                    final failure = state.message;
                    return Center(
                      child: Text(
                        failure,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    );
                  } else if (state is ElecDevicesSuccess) {
                    for (var item in state.elecDevices) {
                      item2.add(item.name);
                    }
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('add_product'),
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
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .translate('department'),
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
                                  child: DropdownButton<String>(
                                    // Set the selected value
                                    value: selectedValue,
                                    // Handle the value change
                                    onChanged: (String? newValue) {
                                      setState(
                                          () => selectedValue = newValue ?? '');
                                      catBloc.add(GetElcDevicesEvent(
                                          department: selectedValue));
                                    },
                                    // Map each option to a widget
                                    items: items.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        // Use a colored box to show the option
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate(value),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      );
                                    }).toList(),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          Column(
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
                                  child: DropdownButton<DepartmentsCategories>(
                                    // Set the selected value
                                    value: selectCat,
                                    // // Handle the value change
                                    onChanged:
                                        (DepartmentsCategories? newValue) {
                                      setState(() {
                                        selectCat = newValue!;
                                      });
                                    },
                                    // onChanged: (String? newValue) => setState(
                                    //     () => selectedValue = newValue ?? ''),
                                    // Map each option to a widget
                                    items: state.elecDevices.map<
                                            DropdownMenuItem<
                                                DepartmentsCategories>>(
                                        (DepartmentsCategories value) {
                                      return DropdownMenuItem<
                                          DepartmentsCategories>(
                                        value: value,
                                        // Use a colored box to show the option
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate(value.name),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      );
                                    }).toList(),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          addProductTextField(
                            context: context,
                            controller: productName,
                            title:
                                '${AppLocalizations.of(context).translate('product_name')} :',
                            isNumber: false,
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          addProductTextField(
                            context: context,
                            controller: productDesc,
                            title:
                                '${AppLocalizations.of(context).translate('description')} :',
                            isNumber: false,
                            maxLine: 3,
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          addProductTextField(
                            context: context,
                            controller: productPrice,
                            title:
                                '${AppLocalizations.of(context).translate('price')} :',
                            isNumber: true,
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          addProductTextField(
                            context: context,
                            title:
                                '${AppLocalizations.of(context).translate('address')} :',
                            controller: productAddress,
                            isNumber: false,
                          ),
                          // addProductTextField(
                          //   context: context,
                          //   title:
                          //       '${AppLocalizations.of(context).translate('phone')} :',
                          //   controller: mobileController,
                          //   isNumber: false,
                          // ),
                          // SizedBox(
                          //   height: 7.h,
                          // ),
                          // addProductTextField(
                          //   context: context,
                          //   title:
                          //       '${AppLocalizations.of(context).translate('props')} :',
                          //   controller: productProps,
                          //   isNumber: false,
                          //   maxLine: 2,
                          // ),
                          SizedBox(
                            height: 7.h,
                          ),
                          addProductTextField(
                            context: context,
                            title:
                                '${AppLocalizations.of(context).translate('made_in')} :',
                            controller: madeInController,
                            isNumber: false,
                          ),
                          SizedBox(
                            height: 7.h,
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
                            height: 7.h,
                          ),
                          Text(
                            AppLocalizations.of(context)
                                .translate('add_product_photo'),
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
                                  text: AppLocalizations.of(context)
                                      .translate('add_from_camera'),
                                  onPressed: () {
                                    getImage(ImageSource.camera);
                                  }),
                              addPhotoButton(
                                  text: AppLocalizations.of(context)
                                      .translate('add_from_gallery'),
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
                              text: AppLocalizations.of(context)
                                  .translate('add_gif'),
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
                                    final newFile =
                                        await saveFilePermanently(file);

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
                                text: AppLocalizations.of(context)
                                    .translate('add_the_product'),
                                onPressed: () {
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
                                  addBloc.add(AddProductRequestedEvent(
                                    departmentName: selectedValue,
                                    categoryName: selectCat?.name ?? '',
                                    name: productName.text,
                                    description: productDesc.text,
                                    price: int.parse(productPrice.text),
                                    guarantee: _isGuarantee,
                                    // images: [],
                                    madeIn: madeInController.text,
                                    address: productAddress.text,
                                    video: _video,
                                    image: _image!,
                                  ));
                                }),
                          ),
                          SizedBox(
                            height: 80.h,
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
        ),
      ),
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
