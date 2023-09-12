import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/categories/real_estate/blocs/real_estate/real_estate_bloc.dart';
import 'package:netzoon/presentation/categories/real_estate/screens/real_estate_details_screen.dart';
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
import '../../../core/widgets/screen_loader.dart';
import '../../../home/widgets/auth_alert.dart';
import '../../../profile/blocs/get_user/get_user_bloc.dart';
import '../../../utils/app_localizations.dart';
import '../../widgets/build_rating.dart';

class RealEstateCompanyProfileScreen extends StatefulWidget {
  final UserInfo user;
  const RealEstateCompanyProfileScreen({super.key, required this.user});

  @override
  State<RealEstateCompanyProfileScreen> createState() =>
      _RealEstateCompanyProfileScreenState();
}

class _RealEstateCompanyProfileScreenState
    extends State<RealEstateCompanyProfileScreen>
    with
        TickerProviderStateMixin,
        ScreenLoader<RealEstateCompanyProfileScreen> {
  final userBloc = sl<GetUserBloc>();
  final rateBloc = sl<GetUserBloc>();

  final realEstatesBloc = sl<RealEstateBloc>();
  final authBloc = sl<AuthBloc>();
  final visitorBloc = sl<GetUserBloc>();

  bool isFollowing = false;
  late final CountryBloc countryBloc;
  @override
  void initState() {
    countryBloc = BlocProvider.of<CountryBloc>(context);
    countryBloc.add(GetCountryEvent());
    userBloc.add(GetUserByIdEvent(userId: widget.user.id));
    realEstatesBloc.add(GetCompanyRealEstatesEvent(id: widget.user.id));
    authBloc.add(AuthCheckRequested());
    visitorBloc.add(AddVisitorEvent(userId: widget.user.id));

    checkFollowStatus();
    super.initState();
  }

  void checkFollowStatus() async {
    bool followStatus = await isFollow(widget.user.id);
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

  @override
  Widget screen(BuildContext context) {
    final TabController tabController = TabController(length: 2, vsync: this);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.user.username ?? '',
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
          actions: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: .0),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.share,
                    color: AppColor.backgroundColor,
                  ),
                )),
          ],
        ),
        body: BlocListener<GetUserBloc, GetUserState>(
          bloc: rateBloc,
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
                  length: 2,
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
                                    height: 140.h,
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
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                                      widget.user.username ??
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
                                                                ? AppLocalizations.of(
                                                                        context)
                                                                    .translate(
                                                                        'unfollow')
                                                                : AppLocalizations.of(
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
                                                                            .user
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
                                            widget.user.slogn != null
                                                ? Text(
                                                    widget.user.slogn ?? '',
                                                    style: TextStyle(
                                                      color:
                                                          AppColor.secondGrey,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 13.sp,
                                                    ),
                                                  )
                                                : const SizedBox(),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${widget.user.averageRating?.toStringAsFixed(3)}',
                                                  style: const TextStyle(
                                                      color:
                                                          AppColor.secondGrey,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                GestureDetector(
                                                  onTap: () => showRating(
                                                      context,
                                                      rateBloc,
                                                      widget.user.id,
                                                      widget.user
                                                              .averageRating ??
                                                          0),
                                                  child: RatingBar.builder(
                                                    minRating: 1,
                                                    maxRating: 5,
                                                    initialRating: widget.user
                                                            .averageRating ??
                                                        0,
                                                    itemSize: 18,
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
                                                  '(${widget.user.totalRatings} ${AppLocalizations.of(context).translate('review')})',
                                                  style: const TextStyle(
                                                    color: AppColor.secondGrey,
                                                    fontSize: 14,
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
                                    height: 20.h,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      state.userInfo.bio ?? 'BIO',
                                      style: const TextStyle(
                                          color: AppColor.mainGrey),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Container(
                                          height: 50,
                                          width: 150,
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
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                      otherUserId: state
                                                              .userInfo
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
                                                height: 50,
                                                width: 150,
                                                decoration: const BoxDecoration(
                                                  color:
                                                      AppColor.backgroundColor,
                                                  // borderRadius: BorderRadius.circular(100),
                                                ),
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.chat,
                                                        color: Colors.white,
                                                        size: 14.sp,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 4.0),
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .translate(
                                                                  'customers service'),
                                                          style: TextStyle(
                                                            color:
                                                                AppColor.white,
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
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ];
                    },
                    body: Column(
                      children: [
                        TabBar(
                          controller: tabController,
                          tabs: [
                            Text(
                              AppLocalizations.of(context)
                                  .translate('real_estate'),
                              style: TextStyle(
                                color: AppColor.black,
                                fontSize: 10.sp,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate('about_us'),
                              style: TextStyle(
                                color: AppColor.black,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: tabController,
                            children: [
                              RefreshIndicator(
                                onRefresh: () async {
                                  realEstatesBloc.add(
                                      GetCompanyRealEstatesEvent(
                                          id: widget.user.id));
                                },
                                color: AppColor.white,
                                backgroundColor: AppColor.backgroundColor,
                                child: BlocBuilder<RealEstateBloc,
                                    RealEstateState>(
                                  bloc: realEstatesBloc,
                                  builder: (context, sstate) {
                                    if (sstate is GetRealEstateInProgress) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColor.backgroundColor,
                                        ),
                                      );
                                    } else if (sstate is GetRealEstateFailure) {
                                      final failure = sstate.message;
                                      return Center(
                                        child: Text(
                                          failure,
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      );
                                    } else if (sstate
                                        is GetCompanyRealEstatesSuccess) {
                                      return sstate.realEstates.isNotEmpty
                                          ? GridView.builder(
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 3,
                                                      childAspectRatio: 0.95,
                                                      crossAxisSpacing: 10.w,
                                                      mainAxisSpacing: 10.h),
                                              shrinkWrap: true,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemCount:
                                                  sstate.realEstates.length,
                                              itemBuilder: (context, index) {
                                                return ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(20)),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) {
                                                            return RealEstateDetailsScreen(
                                                              realEstate: sstate
                                                                      .realEstates[
                                                                  index],
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    child: Card(
                                                      elevation: 4.0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16.0),
                                                      ),
                                                      child: SizedBox(
                                                        height: 100.h,
                                                        width: 180.w,
                                                        child: Stack(
                                                          // fit: StackFit.expand,
                                                          alignment:
                                                              AlignmentDirectional
                                                                  .bottomCenter,
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16.0),
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: sstate
                                                                    .realEstates[
                                                                        index]
                                                                    .imageUrl,
                                                                height: 200.h,
                                                                width: double
                                                                    .maxFinite,
                                                                fit: BoxFit
                                                                    .cover,
                                                                progressIndicatorBuilder:
                                                                    (context,
                                                                            url,
                                                                            downloadProgress) =>
                                                                        Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          70.0,
                                                                      vertical:
                                                                          50),
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    value: downloadProgress
                                                                        .progress,
                                                                    color: AppColor
                                                                        .backgroundColor,

                                                                    // strokeWidth: 10,
                                                                  ),
                                                                ),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    const Icon(Icons
                                                                        .error),
                                                              ),
                                                            ),
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16.0),
                                                                gradient:
                                                                    LinearGradient(
                                                                  begin: Alignment
                                                                      .topCenter,
                                                                  end: Alignment
                                                                      .bottomCenter,
                                                                  colors: [
                                                                    Colors
                                                                        .transparent,
                                                                    AppColor
                                                                        .backgroundColor
                                                                        .withOpacity(
                                                                            0.6),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      6.0),
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                child: Text(
                                                                  sstate
                                                                      .realEstates[
                                                                          index]
                                                                      .title,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        10.0.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
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
                              ListView(
                                children: [
                                  Column(
                                    children: [
                                      titleAndInput(
                                          title: AppLocalizations.of(context)
                                              .translate('username'),
                                          input: state.userInfo.username ?? ''),
                                      titleAndInput(
                                          title: AppLocalizations.of(context)
                                              .translate('email'),
                                          input: state.userInfo.email ?? ''),
                                      titleAndInput(
                                          title: AppLocalizations.of(context)
                                              .translate('mobile'),
                                          input:
                                              state.userInfo.firstMobile ?? ''),
                                      state.userInfo.bio != null
                                          ? titleAndInput(
                                              title:
                                                  AppLocalizations.of(context)
                                                      .translate('Bio'),
                                              input: state.userInfo.bio ?? '')
                                          : const SizedBox(),
                                      // titleAndInput(
                                      //   title: AppLocalizations.of(context)
                                      //       .translate('Is there delivery'),
                                      //   input: state.userInfo.deliverable!
                                      //       ? AppLocalizations.of(context)
                                      //           .translate('Yes')
                                      //       : AppLocalizations.of(context)
                                      //           .translate('No'),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                width: 190,
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
}
