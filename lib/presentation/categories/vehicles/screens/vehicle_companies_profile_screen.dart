import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/advertising/advertising.dart';
import 'package:netzoon/presentation/advertising/blocs/ads/ads_bloc_bloc.dart';
import 'package:netzoon/presentation/categories/vehicles/blocs/bloc/vehicle_bloc.dart';
import 'package:netzoon/presentation/categories/widgets/info_list_widget.dart';
import 'package:netzoon/presentation/core/helpers/share_image_function.dart';
import 'package:netzoon/presentation/core/widgets/on_failure_widget.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:netzoon/presentation/home/widgets/auth_alert.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/core/constants/constants.dart';
import '../../../../data/models/auth/user/user_model.dart';
import '../../../../domain/auth/entities/user_info.dart';
import '../../../../injection_container.dart';
import '../../../auth/blocs/auth_bloc/auth_bloc.dart';
import '../../../chat/screens/chat_page_screen.dart';
import '../../../core/blocs/country_bloc/country_bloc.dart';
import '../../../core/constant/colors.dart';
import '../../../core/widgets/phone_call_button.dart';
import '../../../profile/blocs/get_user/get_user_bloc.dart';
import '../../../utils/app_localizations.dart';
import '../../widgets/build_rating.dart';
import '../widgets/vehicle_widget.dart';

class VehicleCompaniesProfileScreen extends StatefulWidget {
  const VehicleCompaniesProfileScreen(
      {super.key, required this.id, required this.userType});
  final String id;
  final String userType;
  @override
  State<VehicleCompaniesProfileScreen> createState() =>
      _VehicleCompaniesProfileScreenState();
}

class _VehicleCompaniesProfileScreenState
    extends State<VehicleCompaniesProfileScreen>
    with ScreenLoader<VehicleCompaniesProfileScreen> {
  final bloc = sl<VehicleBloc>();
  final authBloc = sl<AuthBloc>();
  final visitorBloc = sl<GetUserBloc>();
  final adsBloc = sl<AdsBlocBloc>();
  final userBloc = sl<GetUserBloc>();
  late final CountryBloc countryBloc;
  bool isFollowing = false;

  @override
  void initState() {
    bloc.add(GetCompanyVehiclesEvent(type: widget.userType, id: widget.id));
    authBloc.add(AuthCheckRequested());
    checkFollowStatus();
    countryBloc = BlocProvider.of<CountryBloc>(context);
    countryBloc.add(GetCountryEvent());
    visitorBloc.add(AddVisitorEvent(userId: widget.id));
    userBloc.add(GetUserByIdEvent(userId: widget.id));
    adsBloc.add(GetUserAdsEvent(userId: widget.id));
    super.initState();
  }

  void checkFollowStatus() async {
    bool followStatus = await isFollow(widget.id);
    setState(() {
      isFollowing = followStatus;
    });
  }

  Future<bool> isFollow(element) async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(SharedPreferencesKeys.user)) {
      return false;
    }

    final user = UserModel.fromJson(
      json.decode(prefs.getString(SharedPreferencesKeys.user)!)
          as Map<String, dynamic>,
    );
    final isFollow = user.userInfo.followings?.contains(element);
    return isFollow ?? false;
  }

  Padding titleAndInput({required String title, required String input}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // height: 40.h,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.4),
              width: 1.0,
            ),
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: 15.sp,
                ),
              ),
              SizedBox(
                width: 190.w,
                child: Text(
                  input,
                  style: TextStyle(
                    color: AppColor.mainGrey,
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 45.h,
        title: BlocBuilder<GetUserBloc, GetUserState>(
          bloc: userBloc,
          builder: (context, state) {
            return Text(
              state is GetUserSuccess ? state.userInfo.username ?? '' : '',
              style: const TextStyle(color: AppColor.backgroundColor),
            );
          },
        ),
        backgroundColor: AppColor.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_rounded,
            color: AppColor.backgroundColor,
            size: 22.sp,
          ),
        ),
        actions: [
          BlocBuilder<GetUserBloc, GetUserState>(
            bloc: userBloc,
            builder: (context, state) {
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: IconButton(
                    onPressed: () async {
                      final type = widget.userType == 'planes'
                          ? 'civil_aircraft'
                          : widget.userType == 'cars'
                              ? 'cars'
                              : 'sea_companies';
                      state is GetUserSuccess
                          ? await shareImageWithDescription(
                              imageUrl: state.userInfo.profilePhoto ?? '',
                              description:
                                  'https://www.netzoon.com/home/catagories/$type/${state.userInfo.id}',
                              subject: state.userInfo.username,
                            )
                          : null;
                    },
                    icon: Icon(
                      Icons.share,
                      color: AppColor.backgroundColor,
                      size: 22.sp,
                    ),
                  ));
            },
          ),
        ],
      ),
      body: BlocListener<GetUserBloc, GetUserState>(
        bloc: userBloc,
        listener: (context, state) {
          if (state is RateUserInProgress) {
            startLoading();
          } else if (state is RateUserFailure) {
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
          } else if (state is RateUserSuccess) {
            stopLoading();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                AppLocalizations.of(context).translate('success'),
              ),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ));
          }
        },
        child: BlocBuilder<GetUserBloc, GetUserState>(
          bloc: userBloc,
          builder: (context, state) {
            if (state is GetUserInProgress) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColor.backgroundColor,
                ),
              );
            } else if (state is GetUserFailure) {
              final failure = state.message;
              return Center(
                child: Text(
                  failure,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              );
            } else if (state is GetUserSuccess) {
              return DefaultTabController(
                length: 3,
                child: NestedScrollView(
                  headerSliverBuilder: (context, _) {
                    return [
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 160.h,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: AppColor.secondGrey
                                            .withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: state.userInfo.coverPhoto ??
                                        'https://img.freepik.com/free-vector/hand-painted-watercolor-pastel-sky-background_23-2148902771.jpg?w=2000',
                                    fit: BoxFit.contain,
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
                                SizedBox(
                                  height: 15.h,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                state.userInfo.profilePhoto ??
                                                    '',
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.fill,
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 70.0,
                                                      vertical: 50),
                                              child: CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress,
                                                color: AppColor.backgroundColor,

                                                // strokeWidth: 10,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                133.w,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    state.userInfo.username ??
                                                        '',
                                                    style: TextStyle(
                                                      color: AppColor.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16.sp,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 15.w,
                                                ),
                                                BlocBuilder<AuthBloc,
                                                    AuthState>(
                                                  bloc: authBloc,
                                                  builder: (context, state) {
                                                    if (state
                                                        is AuthInProgress) {
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: AppColor
                                                              .backgroundColor,
                                                        ),
                                                      );
                                                    } else if (state
                                                        is Authenticated) {
                                                      // isFollowing = state.user
                                                      //         .userInfo.followings!
                                                      //         .contains(widget
                                                      //             .localCompany.id)
                                                      //     ? true
                                                      //     : false;
                                                      return ElevatedButton(
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(AppColor
                                                                      .backgroundColor),
                                                          shape: MaterialStateProperty
                                                              .all(
                                                                  RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18.0),
                                                          )),
                                                        ),
                                                        child: Text(
                                                          isFollowing
                                                              ? AppLocalizations
                                                                      .of(
                                                                          context)
                                                                  .translate(
                                                                      'unfollow')
                                                              : AppLocalizations
                                                                      .of(
                                                                          context)
                                                                  .translate(
                                                                      'follow'),
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            isFollowing =
                                                                !isFollowing;
                                                          });
                                                          userBloc.add(
                                                              ToggleFollowEvent(
                                                                  otherUserId:
                                                                      widget
                                                                          .id));
                                                        },
                                                      );
                                                    }
                                                    return Container();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          state.userInfo.slogn != null
                                              ? Text(
                                                  state.userInfo.slogn ?? '',
                                                  style: TextStyle(
                                                    color: AppColor.secondGrey,
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 13.sp,
                                                  ),
                                                )
                                              : const SizedBox(),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${state.userInfo.averageRating?.toStringAsFixed(3)}',
                                                style: TextStyle(
                                                    color: AppColor.secondGrey,
                                                    fontSize: 18.sp,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              GestureDetector(
                                                onTap: () => showRating(
                                                    context,
                                                    userBloc,
                                                    widget.id,
                                                    state.userInfo
                                                            .averageRating ??
                                                        0),
                                                child: RatingBar.builder(
                                                  minRating: 1,
                                                  maxRating: 5,
                                                  initialRating: state.userInfo
                                                          .averageRating ??
                                                      0,
                                                  itemSize: 18.sp,
                                                  ignoreGestures: true,
                                                  itemBuilder: (context, _) {
                                                    return const Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    );
                                                  },
                                                  allowHalfRating: true,
                                                  updateOnDrag: true,
                                                  onRatingUpdate: (rating) {},
                                                ),
                                              ),
                                              Text(
                                                '(${state.userInfo.totalRatings} ${AppLocalizations.of(context).translate('review')})',
                                                style: TextStyle(
                                                  color: AppColor.secondGrey,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 15.w,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 14.h,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    state.userInfo.bio ?? '',
                                    style: const TextStyle(
                                        color: AppColor.mainGrey),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Container(
                                        height: 50.h,
                                        width: 150.w,
                                        decoration: const BoxDecoration(
                                          color: AppColor.backgroundColor,
                                          // borderRadius: BorderRadius.circular(100),
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.monetization_on,
                                                color: Colors.white,
                                                size: 14.sp,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4.0),
                                                child: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Live Auction'),
                                                  style: TextStyle(
                                                    color: AppColor.white,
                                                    fontSize: 11.sp,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8.w,
                                    ),
                                    BlocBuilder<AuthBloc, AuthState>(
                                      bloc: authBloc,
                                      builder: (context, authState) {
                                        return InkWell(
                                          onTap: () async {
                                            if (authState is Authenticated) {
                                              await SendbirdChat.connect(
                                                  authState.user.userInfo
                                                          .username ??
                                                      '');
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                  return ChatPageScreen(
                                                    userId: authState
                                                            .user
                                                            .userInfo
                                                            .username ??
                                                        '',
                                                    otherUserId: state.userInfo
                                                            .username ??
                                                        '',
                                                    title: state.userInfo
                                                            .username ??
                                                        '',
                                                    image: state.userInfo
                                                            .profilePhoto ??
                                                        '',
                                                  );
                                                }),
                                              );
                                            } else {
                                              authAlert(context);
                                            }
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Container(
                                              height: 50.h,
                                              width: 150.w,
                                              decoration: const BoxDecoration(
                                                color: AppColor.backgroundColor,
                                                // borderRadius: BorderRadius.circular(100),
                                              ),
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.chat,
                                                      color: Colors.white,
                                                      size: 14.sp,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 4.0),
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                context)
                                                            .translate(
                                                                'customers service'),
                                                        style: TextStyle(
                                                          color: AppColor.white,
                                                          fontSize: 11.sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Material(
                          color: AppColor.white,
                          child: TabBar(
                            labelColor: AppColor.backgroundColor,
                            unselectedLabelColor:
                                AppColor.secondGrey.withOpacity(0.4),
                            indicatorWeight: 1,
                            indicatorColor: AppColor.backgroundColor,
                            tabs: [
                              Tab(
                                icon: Text(
                                  AppLocalizations.of(context)
                                      .translate(state.userInfo.userType ?? ''),
                                  style: TextStyle(fontSize: 10.sp),
                                ),
                              ),
                              Tab(
                                icon: Text(
                                  AppLocalizations.of(context)
                                      .translate('my_ads'),
                                  style: TextStyle(fontSize: 10.sp),
                                ),
                              ),
                              Tab(
                                icon: Text(
                                  AppLocalizations.of(context)
                                      .translate('about_us'),
                                  style: TextStyle(fontSize: 10.sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              RefreshIndicator(
                                onRefresh: () async {
                                  bloc.add(GetCompanyVehiclesEvent(
                                      type: state.userInfo.userType ?? '',
                                      id: widget.id));
                                },
                                color: AppColor.white,
                                backgroundColor: AppColor.backgroundColor,
                                child: BlocBuilder<VehicleBloc, VehicleState>(
                                  bloc: bloc,
                                  builder: (context, state) {
                                    if (state is VehicleInProgress) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColor.backgroundColor,
                                        ),
                                      );
                                    } else if (state is VehicleFailure) {
                                      final failure = state.message;
                                      return Center(
                                        child: Text(
                                          failure,
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      );
                                    } else if (state
                                        is GetCompanyVehiclesSuccess) {
                                      return state.companyVehicles.isNotEmpty
                                          ? BlocBuilder<CountryBloc,
                                              CountryState>(
                                              bloc: countryBloc,
                                              builder: (context, countryState) {
                                                if (countryState
                                                    is CountryInitial) {
                                                  return DynamicHeightGridView(
                                                      itemCount: state
                                                          .companyVehicles
                                                          .length,
                                                      crossAxisCount: 2,
                                                      crossAxisSpacing: 10,
                                                      mainAxisSpacing: 10,
                                                      builder: (ctx, index) {
                                                        return VehicleWidget(
                                                          vehicle: state
                                                                  .companyVehicles[
                                                              index],
                                                          countryState:
                                                              countryState,
                                                        );

                                                        /// return your widget here.
                                                      });
                                                }
                                                return Container();
                                              },
                                            )
                                          : Center(
                                              child: Text(
                                                  AppLocalizations.of(context)
                                                      .translate('no_items'),
                                                  style: const TextStyle(
                                                      color: AppColor
                                                          .backgroundColor)),
                                            );
                                    }
                                    return Container();
                                  },
                                ),
                              ),
                              RefreshIndicator(
                                onRefresh: () async {
                                  adsBloc
                                      .add(GetUserAdsEvent(userId: widget.id));
                                },
                                color: AppColor.white,
                                backgroundColor: AppColor.backgroundColor,
                                child: BlocBuilder<AdsBlocBloc, AdsBlocState>(
                                  bloc: adsBloc,
                                  builder: (context, state) {
                                    if (state is AdsBlocInProgress) {
                                      return SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height -
                                                120.h,
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            color: AppColor.backgroundColor,
                                          ),
                                        ),
                                      );
                                    } else if (state is AdsBlocFailure) {
                                      final failure = state.message;
                                      return FailureWidget(
                                          failure: failure,
                                          onPressed: () {
                                            adsBloc.add(GetUserAdsEvent(
                                                userId: widget.id));
                                          });
                                    } else if (state is AdsBlocSuccess) {
                                      return state.ads.isEmpty
                                          ? Text(
                                              AppLocalizations.of(context)
                                                  .translate('no_items'),
                                              style: TextStyle(
                                                color: AppColor.backgroundColor,
                                                fontSize: 22.sp,
                                              ),
                                            )
                                          : ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemCount: state.ads.length,
                                              scrollDirection: Axis.vertical,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 280.h,
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                                  20)
                                                              .w),
                                                  child: Advertising(
                                                      advertisment:
                                                          state.ads[index]),
                                                );
                                              },
                                            );
                                    }
                                    return Container();
                                  },
                                ),
                              ),
                              infoListWidget(
                                context: context,
                                username: state.userInfo.username,
                                firstMobile: state.userInfo.firstMobile ?? '',
                                email: state.userInfo.email ?? '',
                                address: state.userInfo.address,
                                bio: state.userInfo.bio,
                                deliverable: state.userInfo.deliverable,
                                description: state.userInfo.description,
                                link: state.userInfo.link,
                                website: state.userInfo.website,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
