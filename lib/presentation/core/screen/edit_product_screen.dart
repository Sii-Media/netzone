import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:path_provider/path_provider.dart';

import '../../../domain/departments/entities/category_products/category_products.dart';
import '../../../injection_container.dart';
import '../../home/blocs/elec_devices/elec_devices_bloc.dart';
import '../../utils/app_localizations.dart';
import '../constant/colors.dart';

class EditProductScreen extends StatefulWidget {
  final CategoryProducts item;
  const EditProductScreen({super.key, required this.item});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen>
    with ScreenLoader<EditProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _madeInController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  late bool _isGuarantee;
  String videoName = '';
  File? _updatedImage;
  File? _updatedVedio;

  final productBloc = sl<ElecDevicesBloc>();
  @override
  void initState() {
    super.initState();
    _nameController.text = widget.item.name;
    _priceController.text = widget.item.price.toString();
    _descriptionController.text = widget.item.description;
    _addressController.text = widget.item.address ?? '';
    _madeInController.text = widget.item.madeIn ?? '';
    _isGuarantee = widget.item.guarantee ?? false;
  }

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Product',
        ),
        // leading: Icon(Icons.arrow_back_ios_new),
        backgroundColor: AppColor.backgroundColor,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocListener<ElecDevicesBloc, ElecDevicesState>(
            bloc: productBloc,
            listener: (context, state) {
              if (state is EditProductInProgress) {
                startLoading();
              } else if (state is EditProductFailure) {
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
              } else if (state is EditProductSuccess) {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 104 / 2),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: _updatedImage != null
                                ? FileImage(_updatedImage!)
                                // ignore: unnecessary_null_comparison
                                : widget.item.imageUrl != null
                                    ? CachedNetworkImageProvider(
                                        widget.item.imageUrl)
                                    : Image.network(
                                            'https://static.vecteezy.com/system/resources/previews/005/544/718/original/profile-icon-design-free-vector.jpg')
                                        .image,
                            fit: BoxFit.contain),
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
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'name',
                      label: Text('Name'),
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
                    controller: _priceController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'price',
                      label: Text('Price'),
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
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _descriptionController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'description',
                      label: Text('Description'),
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
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _madeInController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'madeIn',
                      label: Text('Made in'),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 25),
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
                            final result = await FilePicker.platform.pickFiles(
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
                              _updatedVedio = newFile;
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
                    height: 20.h,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;
                        productBloc.add(EditProductEvent(
                          productId: widget.item.id,
                          name: _nameController.text,
                          description: _descriptionController.text,
                          price: double.parse(_priceController.text),
                          image: _updatedImage,
                          address: _addressController.text,
                          guarantee: _isGuarantee,
                          madeIn: _madeInController.text,
                          video: _updatedVedio,
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
