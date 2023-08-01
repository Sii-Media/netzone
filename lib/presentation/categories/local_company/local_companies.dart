import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/categories/local_company/local_company_bloc/local_company_bloc.dart';
import 'package:netzoon/presentation/categories/local_company/local_company_profile.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../utils/app_localizations.dart';

class GovernmentalCompanies extends StatefulWidget {
  final String userType;
  const GovernmentalCompanies({super.key, required this.userType});

  @override
  State<GovernmentalCompanies> createState() => _GovernmentalCompaniesState();
}

class _GovernmentalCompaniesState extends State<GovernmentalCompanies> {
  final localCompanyBloc = sl<LocalCompanyBloc>();

  @override
  void initState() {
    // localCompanyBloc.add(GetAllLocalCompaniesEvent());
    localCompanyBloc.add(GetLocalCompaniesEvent(userType: widget.userType));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BackgroundWidget(
            isHome: false,
            widget: RefreshIndicator(
              onRefresh: () async {
                localCompanyBloc
                    .add(GetLocalCompaniesEvent(userType: widget.userType));
              },
              color: AppColor.white,
              backgroundColor: AppColor.backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 60.0),
                          child:
                              BlocBuilder<LocalCompanyBloc, LocalCompanyState>(
                            bloc: localCompanyBloc,
                            builder: (context, state) {
                              if (state is LocalCompanyInProgress) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColor.backgroundColor,
                                  ),
                                );
                              } else if (state is LocalCompanyFailure) {
                                final failure = state.message;
                                return Center(
                                  child: Text(
                                    failure,
                                    style: const TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                );
                              } else if (state is GetLocalCompaniesSuccess) {
                                return state.companies.isNotEmpty
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 40.0),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: state.companies.length,
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            return SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.40,
                                              child: InkWell(
                                                onTap: () {},
                                                child: Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                          return LocalCompanyProfileScreen(
                                                            localCompany:
                                                                state.companies[
                                                                    index],
                                                          );
                                                        }),
                                                      );
                                                    },
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25.0),
                                                        child: Card(
                                                          child: Stack(
                                                            children: [
                                                              Positioned(
                                                                left: 0,
                                                                bottom: 0,
                                                                top: 0,
                                                                right: 0,
                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl: state
                                                                          .companies[
                                                                              index]
                                                                          .profilePhoto ??
                                                                      'https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg',
                                                                  fit: BoxFit
                                                                      .contain,
                                                                ),
                                                              ),
                                                              Positioned(
                                                                bottom: 0,
                                                                left: 0,
                                                                right: 0,
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  height: 50.h,
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  color: AppColor
                                                                      .backgroundColor
                                                                      .withOpacity(
                                                                          0.8),
                                                                  child: Center(
                                                                    child: Text(
                                                                      state.companies[index]
                                                                              .username ??
                                                                          '',
                                                                      style: TextStyle(
                                                                          fontSize: 18
                                                                              .sp,
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate('no_items'),
                                          style: TextStyle(
                                            color: AppColor.backgroundColor,
                                            fontSize: 22.sp,
                                          ),
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
                ),
              ),
            )));
  }
}
