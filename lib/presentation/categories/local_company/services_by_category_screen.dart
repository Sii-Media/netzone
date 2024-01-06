import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/categories/local_company/company_service_detail_screen.dart';
import 'package:netzoon/presentation/categories/local_company/local_company_bloc/local_company_bloc.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/on_failure_widget.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class ServicesByCategoryScreen extends StatefulWidget {
  final String category;
  const ServicesByCategoryScreen({super.key, required this.category});

  @override
  State<ServicesByCategoryScreen> createState() =>
      _ServicesByCategoryScreenState();
}

class _ServicesByCategoryScreenState extends State<ServicesByCategoryScreen> {
  final servicesBloc = sl<LocalCompanyBloc>();

  @override
  void initState() {
    servicesBloc.add(GetServicesByCategoryEvent(category: widget.category));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          servicesBloc
              .add(GetServicesByCategoryEvent(category: widget.category));
        },
        color: AppColor.white,
        backgroundColor: AppColor.backgroundColor,
        child: BackgroundWidget(
          isHome: false,
          widget: BlocBuilder<LocalCompanyBloc, LocalCompanyState>(
            bloc: servicesBloc,
            builder: (context, state) {
              if (state is GetServicesByCategoryInProgress) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.backgroundColor,
                  ),
                );
              } else if (state is GetServicesByCategoryFailure) {
                final failure = state.message;
                return FailureWidget(
                  failure: failure,
                  onPressed: () {
                    servicesBloc.add(
                        GetServicesByCategoryEvent(category: widget.category));
                  },
                );
              } else if (state is GetServicesByCategorySuccess) {
                return Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: state.servicesCategories.services!.isEmpty
                            ? Center(
                                child: Text(
                                    AppLocalizations.of(context)
                                        .translate('no_items'),
                                    style: const TextStyle(
                                        color: AppColor.backgroundColor)),
                              )
                            : DynamicHeightGridView(
                                // gridDelegate:
                                //     const SliverGridDelegateWithFixedCrossAxisCount(
                                //         crossAxisCount: 2,
                                //         childAspectRatio: 0.87,
                                //         mainAxisSpacing: 10,
                                //         crossAxisSpacing: 10),
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,

                                itemCount:
                                    state.servicesCategories.services?.length ??
                                        0,
                                builder: (context, index) {
                                  return Container(
                                    height: 190.h,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      color: AppColor.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColor.secondGrey
                                              .withOpacity(0.5),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return CompanyServiceDetailsScreen(
                                                  companyServiceId: state
                                                      .servicesCategories
                                                      .services![index]
                                                      .id,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: state
                                                      .servicesCategories
                                                      .services![index]
                                                      .imageUrl ??
                                                  '',
                                              height: 120.h,
                                              width: 200.w,
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 9.0,
                                                  left: 9.0,
                                                  bottom: 8.0),
                                              child: Text(
                                                state.servicesCategories
                                                    .services![index].title,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color:
                                                      AppColor.backgroundColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
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
