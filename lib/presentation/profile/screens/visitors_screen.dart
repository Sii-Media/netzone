import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../injection_container.dart';
import '../../categories/delivery_company/screens/delivery_company_profile_screen.dart';
import '../../categories/local_company/local_company_profile.dart';
import '../../categories/real_estate/screens/real_estate_company_profile_screen.dart';
import '../../categories/users/screens/users_profile_screen.dart';
import '../../categories/vehicles/screens/vehicle_companies_profile_screen.dart';
import '../../core/constant/colors.dart';
import '../../utils/app_localizations.dart';
import '../blocs/get_user/get_user_bloc.dart';

class VisitorsScreen extends StatefulWidget {
  const VisitorsScreen({super.key});

  @override
  State<VisitorsScreen> createState() => _VisitorsScreenState();
}

class _VisitorsScreenState extends State<VisitorsScreen> {
  final visitorBloc = sl<GetUserBloc>();
  @override
  void initState() {
    visitorBloc.add(GetUserVisitorsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('visitors'),
          style: const TextStyle(
            color: AppColor.backgroundColor,
          ),
        ),
        backgroundColor: AppColor.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_rounded,
            color: AppColor.backgroundColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<GetUserBloc, GetUserState>(
          bloc: visitorBloc,
          builder: (context, state) {
            if (state is GetUserVisitorsInProgress) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColor.backgroundColor,
                ),
              );
            } else if (state is GetUserVisitorsFailure) {
              final failure = state.message;
              return Center(
                child: Text(
                  failure,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              );
            } else if (state is GetUserVisitorsSuccess) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListView.builder(
                      itemCount: state.visitors.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                if (state.visitors[index].userType ==
                                    'local_company') {
                                  return LocalCompanyProfileScreen(
                                      localCompany: state.visitors[index]);
                                } else if (state.visitors[index].userType ==
                                        'car' ||
                                    state.visitors[index].userType ==
                                        'planes') {
                                  return VehicleCompaniesProfileScreen(
                                      vehiclesCompany: state.visitors[index]);
                                } else if (state.visitors[index].userType ==
                                    'real_estate') {
                                  return RealEstateCompanyProfileScreen(
                                      user: state.visitors[index]);
                                } else if (state.visitors[index].userType ==
                                    'trader') {
                                  return LocalCompanyProfileScreen(
                                    localCompany: state.visitors[index],
                                  );
                                } else if (state.visitors[index].userType ==
                                    'delivery_company') {
                                  return DeliveryCompanyProfileScreen(
                                    deliveryCompany: state.visitors[index],
                                  );
                                } else {
                                  return UsersProfileScreen(
                                      user: state.visitors[index]);
                                }
                              }));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color:
                                              Colors.grey.withOpacity(0.2)))),
                              height: 65.h,
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(35),
                                    // child: Image.network(
                                    //   state.followings[index].profilePhoto ??
                                    //       'https://pbs.twimg.com/media/FjU2lkcWYAgNG6d.jpg',
                                    //   height: 50.h,
                                    //   width: 45.w,
                                    //   fit: BoxFit.cover,
                                    // ),
                                    child: CachedNetworkImage(
                                      imageUrl: state
                                              .visitors[index].profilePhoto ??
                                          'https://pbs.twimg.com/media/FjU2lkcWYAgNG6d.jpg',
                                      height: 50.h,
                                      width: 45.w,
                                      fit: BoxFit.cover,
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              Padding(
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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Text(
                                      state.visitors[index].username ?? '',
                                      style: TextStyle(
                                        color: AppColor.backgroundColor,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
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
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
