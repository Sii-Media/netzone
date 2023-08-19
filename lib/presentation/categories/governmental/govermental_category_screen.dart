import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/categories/governmental/govermental_bloc/govermental_bloc.dart';
import 'package:netzoon/presentation/categories/governmental/governmental.dart';

import '../../core/constant/colors.dart';
import '../../core/widgets/background_widget.dart';
import '../../utils/app_localizations.dart';

class GovermentalCategoryScreen extends StatefulWidget {
  const GovermentalCategoryScreen({super.key});

  @override
  State<GovermentalCategoryScreen> createState() =>
      _GovermentalCategoryScreenState();
}

class _GovermentalCategoryScreenState extends State<GovermentalCategoryScreen> {
  final goverBloc = sl<GovermentalBloc>();
  @override
  void initState() {
    goverBloc.add(GetAllGovermentalsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          goverBloc.add(GetAllGovermentalsEvent());
        },
        color: AppColor.white,
        backgroundColor: AppColor.backgroundColor,
        child: BackgroundWidget(
          widget: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: BlocBuilder<GovermentalBloc, GovermentalState>(
                bloc: goverBloc,
                builder: (context, state) {
                  if (state is GovermentalInProgress) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColor.backgroundColor,
                        ),
                      ),
                    );
                  } else if (state is GovermentalFailure) {
                    final failure = state.message;
                    return Center(
                      child: Text(
                        failure,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    );
                  } else if (state is GovermentalSuccess) {
                    return Column(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.govermentals.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.85,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemBuilder: (BuildContext context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return GovernmentInstitutionScreen(
                                      id: state.govermentals[index].id);
                                }));
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25.0),
                                    child: Card(
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 0,
                                            bottom: 0,
                                            top: 0,
                                            right: 0,
                                            child: CachedNetworkImage(
                                              imageUrl: state
                                                  .govermentals[index].imageUrl,
                                              fit: BoxFit.cover,
                                              progressIndicatorBuilder:
                                                  (context, url,
                                                          downloadProgress) =>
                                                      Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 70.0,
                                                        vertical: 50),
                                                child:
                                                    CircularProgressIndicator(
                                                  value:
                                                      downloadProgress.progress,
                                                  color:
                                                      AppColor.backgroundColor,

                                                  // strokeWidth: 10,
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                          Positioned(
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                height: 50.h,
                                                alignment: Alignment.center,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                color: AppColor.backgroundColor,
                                                child: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(state
                                                          .govermentals[index]
                                                          .name),
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      color: Colors.white),
                                                ),
                                              ))
                                        ],
                                      ),
                                    )),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 60.h,
                        )
                      ],
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
}
