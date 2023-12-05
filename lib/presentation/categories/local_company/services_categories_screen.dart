import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/categories/local_company/local_company_bloc/local_company_bloc.dart';
import 'package:netzoon/presentation/categories/local_company/services_by_category_screen.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/on_failure_widget.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class ServicesCategoriesScreen extends StatefulWidget {
  const ServicesCategoriesScreen({
    super.key,
  });

  @override
  State<ServicesCategoriesScreen> createState() =>
      _ServicesCategoriesScreenState();
}

class _ServicesCategoriesScreenState extends State<ServicesCategoriesScreen> {
  final servicesBloc = sl<LocalCompanyBloc>();

  @override
  void initState() {
    servicesBloc.add(GetServicesCategoriesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          servicesBloc.add(GetServicesCategoriesEvent());
        },
        color: AppColor.white,
        backgroundColor: AppColor.backgroundColor,
        child: BackgroundWidget(
          isHome: false,
          widget: BlocBuilder<LocalCompanyBloc, LocalCompanyState>(
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
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: state.servicesCategories.isEmpty
                            ? Center(
                                child: Text(
                                    AppLocalizations.of(context)
                                        .translate('no_items'),
                                    style: const TextStyle(
                                        color: AppColor.backgroundColor)),
                              )
                            : GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 2.r,
                                  crossAxisSpacing: 10.r,
                                ),
                                itemCount: state.servicesCategories.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ServicesByCategoryScreen(
                                              category: state
                                                  .servicesCategories[index].id,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Container(
                                      // padding: const EdgeInsets.all(3),
                                      margin: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: AppColor.white,
                                          border: Border.all(
                                            color: AppColor.backgroundColor,
                                          )),
                                      // child: ElevatedButton(
                                      //   onPressed: () {
                                      //     Navigator.of(context).push(
                                      //       MaterialPageRoute(
                                      //         builder: (context) {
                                      //           return ServicesByCategoryScreen(
                                      //             category: serviceState
                                      //                 .servicesCategories[index].id,
                                      //           );
                                      //         },
                                      //       ),
                                      //     );
                                      //   },
                                      //   style: ElevatedButton.styleFrom(
                                      //     backgroundColor: AppColor.white,
                                      //     // elevation: 3,

                                      //     shape: BeveledRectangleBorder(
                                      //       borderRadius: BorderRadius.circular(5),
                                      //       side: const BorderSide(
                                      //           color: AppColor.backgroundColor,
                                      //           width: 0.6),
                                      //     ),
                                      //   ),
                                      //   child: Text(
                                      //     AppLocalizations.of(context).translate(
                                      //         serviceState
                                      //             .servicesCategories[index].title),
                                      //     textAlign: TextAlign.center,
                                      //     style: TextStyle(
                                      //         color: AppColor.backgroundColor,
                                      //         fontSize: 11.sp,
                                      //         fontWeight: FontWeight.w700),
                                      //   ),
                                      // ),
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate(state
                                                  .servicesCategories[index]
                                                  .title),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColor.backgroundColor,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
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
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
