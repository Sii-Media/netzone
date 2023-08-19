import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/categories/local_company/local_company_profile.dart';
import 'package:netzoon/presentation/categories/real_estate/screens/real_estate_company_profile_screen.dart';
import 'package:netzoon/presentation/categories/users/screens/users_profile_screen.dart';
import 'package:netzoon/presentation/categories/vehicles/screens/vehicle_companies_profile_screen.dart';
import 'package:netzoon/presentation/profile/blocs/get_user/get_user_bloc.dart';

import '../../../injection_container.dart';
import '../../categories/delivery_company/screens/delivery_company_profile_screen.dart';
import '../../core/constant/colors.dart';
import '../../utils/app_localizations.dart';

class FollowingsListScreen extends StatefulWidget {
  final String type;
  final String who;
  final String? id;
  const FollowingsListScreen(
      {super.key, required this.type, required this.who, this.id});

  @override
  State<FollowingsListScreen> createState() => _FollowingsListScreenState();
}

class _FollowingsListScreenState extends State<FollowingsListScreen> {
  final followBloc = sl<GetUserBloc>();

  @override
  void initState() {
    if (widget.type == 'followings') {
      if (widget.who == 'me') {
        followBloc.add(GetUserFollowingsEvent());
      } else {
        followBloc.add(GetUserFollowingsByIdEvent(id: widget.id ?? ''));
      }
    } else {
      if (widget.who == 'me') {
        followBloc.add(GetUserFollowersEvent());
      } else {
        followBloc.add(GetUserFollowersByIdEvent(id: widget.id ?? ''));
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.type == 'followings'
              ? AppLocalizations.of(context).translate('Followings')
              : AppLocalizations.of(context).translate('Followers'),
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
      body: RefreshIndicator(
        onRefresh: () async {
          if (widget.type == 'followings') {
            if (widget.who == 'me') {
              followBloc.add(GetUserFollowingsEvent());
            } else {
              followBloc.add(GetUserFollowingsByIdEvent(id: widget.id ?? ''));
            }
          } else {
            if (widget.who == 'me') {
              followBloc.add(GetUserFollowersEvent());
            } else {
              followBloc.add(GetUserFollowersByIdEvent(id: widget.id ?? ''));
            }
          }
        },
        color: AppColor.white,
        backgroundColor: AppColor.backgroundColor,
        child: SingleChildScrollView(
          child: BlocBuilder<GetUserBloc, GetUserState>(
            bloc: followBloc,
            builder: (context, state) {
              if (state is GetUserFollowsInProgress) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height - 80.h,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.backgroundColor,
                    ),
                  ),
                );
              } else if (state is GetUserFollowsFailure) {
                final failure = state.message;
                return Center(
                  child: Text(
                    failure,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                );
              } else if (state is GetUserFollowsSuccess) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListView.builder(
                        itemCount: state.follows.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  if (state.follows[index].userType ==
                                      'local_company') {
                                    return LocalCompanyProfileScreen(
                                        localCompany: state.follows[index]);
                                  } else if (state.follows[index].userType ==
                                          'car' ||
                                      state.follows[index].userType ==
                                          'planes') {
                                    return VehicleCompaniesProfileScreen(
                                        vehiclesCompany: state.follows[index]);
                                  } else if (state.follows[index].userType ==
                                      'real_estate') {
                                    return RealEstateCompanyProfileScreen(
                                        user: state.follows[index]);
                                  } else if (state.follows[index].userType ==
                                      'trader') {
                                    return LocalCompanyProfileScreen(
                                      localCompany: state.follows[index],
                                    );
                                  } else if (state.follows[index].userType ==
                                      'delivery_company') {
                                    return DeliveryCompanyProfileScreen(
                                      deliveryCompany: state.follows[index],
                                    );
                                  } else {
                                    return UsersProfileScreen(
                                        user: state.follows[index]);
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
                                                .follows[index].profilePhoto ??
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
                                        state.follows[index].username ?? '',
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
      ),
    );
  }
}
