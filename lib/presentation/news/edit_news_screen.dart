import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netzoon/presentation/news/blocs/news/news_bloc.dart';

import '../../domain/news/entities/news_info.dart';
import '../../injection_container.dart';
import '../core/constant/colors.dart';
import '../core/widgets/screen_loader.dart';
import '../utils/app_localizations.dart';

class EditNewsScreen extends StatefulWidget {
  final News news;
  const EditNewsScreen({super.key, required this.news});

  @override
  State<EditNewsScreen> createState() => _EditNewsScreenState();
}

class _EditNewsScreenState extends State<EditNewsScreen>
    with ScreenLoader<EditNewsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController titleController = TextEditingController();
  late TextEditingController descController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _updatedImage;

  final newsBloc = sl<NewsBloc>();

  @override
  void initState() {
    titleController.text = widget.news.title;
    descController.text = widget.news.description;
    super.initState();
  }

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit News',
        ),
        // leading: Icon(Icons.arrow_back_ios_new),
        backgroundColor: AppColor.backgroundColor,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocListener<NewsBloc, NewsState>(
            bloc: newsBloc,
            listener: (context, state) {
              if (state is EditNewsInProgress) {
                startLoading();
              } else if (state is EditNewsFailure) {
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
              } else if (state is EditNewsSuccess) {
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
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: _updatedImage != null
                              ? FileImage(_updatedImage!)
                              // ignore: unnecessary_null_comparison
                              : widget.news.imgUrl != null
                                  ? CachedNetworkImageProvider(
                                      widget.news.imgUrl)
                                  : Image.network(
                                          'https://static.vecteezy.com/system/resources/previews/005/544/718/original/profile-icon-design-free-vector.jpg')
                                      .image,
                          fit: BoxFit.contain),
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
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    maxLines: 2,
                    minLines: 1,
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
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    maxLines: 4,
                    minLines: 1,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'field_required_message';
                      }

                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;
                        newsBloc.add(
                          EditNewsEvent(
                            id: widget.news.id ?? '',
                            title: titleController.text,
                            description: descController.text,
                            image: _updatedImage,
                            creator: widget.news.creator.id,
                          ),
                        );
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
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('save_changes'),
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
