import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netzoon/domain/company_service/company_service.dart';
import 'package:netzoon/presentation/categories/local_company/local_company_bloc/local_company_bloc.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';

import '../../../injection_container.dart';
import '../../core/constant/colors.dart';
import '../../utils/app_localizations.dart';
import '../widgets/image_free_zone_widget.dart';

class EditCompanyServiceScreen extends StatefulWidget {
  final CompanyService companyService;
  const EditCompanyServiceScreen({super.key, required this.companyService});

  @override
  State<EditCompanyServiceScreen> createState() =>
      _EditCompanyServiceScreenState();
}

class _EditCompanyServiceScreenState extends State<EditCompanyServiceScreen>
    with ScreenLoader<EditCompanyServiceScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController titleController = TextEditingController();
  late TextEditingController descController = TextEditingController();
  late TextEditingController priceController = TextEditingController();
  late TextEditingController whatsAppNumberController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _updatedImage;
  late List<String> serviceImages;
  final editBloc = sl<LocalCompanyBloc>();

  late List<File?> updatedServiceImages;

  @override
  void initState() {
    titleController.text = widget.companyService.title;
    descController.text = widget.companyService.description;
    priceController.text = widget.companyService.price.toString();
    whatsAppNumberController.text = widget.companyService.whatsAppNumber ?? '';
    serviceImages = widget.companyService.serviceImageList ?? [];

    updatedServiceImages = List.generate(
      serviceImages.length,
      (index) => null,
    );
    super.initState();
  }

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Service',
        ),
        // leading: Icon(Icons.arrow_back_ios_new),
        backgroundColor: AppColor.backgroundColor,
      ),
      body: BlocListener<LocalCompanyBloc, LocalCompanyState>(
        bloc: editBloc,
        listener: (context, state) {
          if (state is EditCompanyServiceInProgress) {
            startLoading();
          } else if (state is EditCompanyServiceFailure) {
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
          } else if (state is EditCompanyServiceSuccess) {
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
                              : widget.companyService.imageUrl != null
                                  ? CachedNetworkImageProvider(
                                      widget.companyService.imageUrl ?? '')
                                  : Image.network(
                                          'https://static.vecteezy.com/system/resources/previews/005/544/718/original/profile-icon-design-free-vector.jpg')
                                      .image,
                          fit: BoxFit.cover),
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
                      hintText: 'title',
                      label: Text('title'),
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
                      return null;
                    },
                  ),
                  SizedBox(height: 25.h),
                  TextFormField(
                    controller: whatsAppNumberController,
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'whatsappNumber',
                      label: Text('whatsappNumber'),
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (text) {
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  serviceImages.isNotEmpty
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              serviceImages.length, // Use serviceImages length
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, childAspectRatio: 0.94),
                          itemBuilder: (BuildContext context, index) {
                            // Get the image URL from serviceImages list
                            final imageUrl = serviceImages[index];

                            return Container(
                              height: 100,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: updatedServiceImages[index] != null
                                      ? FileImage(updatedServiceImages[index]!)
                                      : imageUrl != null
                                          ? CachedNetworkImageProvider(imageUrl)
                                          : Image.network(
                                                  'https://static.vecteezy.com/system/resources/previews/005/544/718/original/profile-icon-design-free-vector.jpg')
                                              .image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  // Allow users to edit the image for this specific index
                                  final image = await _picker.pickImage(
                                    source: ImageSource.gallery,
                                  );
                                  updatedServiceImages[index] =
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
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      color: AppColor.white,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : const SizedBox(),
                  SizedBox(
                    height: 20.h,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;
                        editBloc.add(EditCompanyServiceEvent(
                            id: widget.companyService.id,
                            title: titleController.text,
                            description: descController.text,
                            price: int.tryParse(priceController.text),
                            whatsAppNumber: whatsAppNumberController.text,
                            image: _updatedImage,
                            serviceImageList: updatedServiceImages));
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
}
