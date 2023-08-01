import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/categories/customs_screen/customs_bloc/customs_bloc.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import 'customs_companies_screen.dart';

class CustomsCategoryScreen extends StatefulWidget {
  const CustomsCategoryScreen({super.key});

  @override
  State<CustomsCategoryScreen> createState() => _CustomsCategoryScreenState();
}

class _CustomsCategoryScreenState extends State<CustomsCategoryScreen> {
  final customsBloc = sl<CustomsBloc>();

  @override
  void initState() {
    customsBloc.add(GetAllCustomsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          customsBloc.add(GetAllCustomsEvent());
        },
        color: AppColor.white,
        backgroundColor: AppColor.backgroundColor,
        child: BackgroundWidget(
          isHome: false,
          widget: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: BlocBuilder<CustomsBloc, CustomsState>(
                bloc: customsBloc,
                builder: (context, state) {
                  if (state is CustomsInProgress) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColor.backgroundColor,
                        ),
                      ),
                    );
                  } else if (state is CustomsFailure) {
                    final failure = state.message;
                    return Center(
                      child: Text(
                        failure,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    );
                  } else if (state is CustomsSuccess) {
                    return Column(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.customs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.85,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20),
                          itemBuilder: (BuildContext context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return CustomsCompaniesScreen(
                                    id: state.customs[index].id,
                                  );
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
                                              imageUrl:
                                                  state.customs[index].imageUrl,
                                              fit: BoxFit.cover,
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
                                                          .customs[index].name),
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
                        ),
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
