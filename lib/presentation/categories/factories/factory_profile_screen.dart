import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_flags/country_flags.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/presentation/core/helpers/share_image_function.dart';
import 'package:netzoon/presentation/home/widgets/auth_alert.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

import '../../../injection_container.dart';
import '../../advertising/blocs/ads/ads_bloc_bloc.dart';
import '../../auth/blocs/auth_bloc/auth_bloc.dart';
import '../../chat/screens/chat_page_screen.dart';
import '../../core/blocs/country_bloc/country_bloc.dart';
import '../../core/constant/colors.dart';
import '../../core/screen/product_details_screen.dart';
import '../../core/widgets/screen_loader.dart';
import '../../ecommerce/widgets/listsubsectionswidget.dart';
import '../../profile/blocs/get_user/get_user_bloc.dart';
import '../../profile/screens/followings_list_screen.dart';
import '../../utils/app_localizations.dart';
import '../local_company/company_service_detail_screen.dart';
import '../local_company/local_company_bloc/local_company_bloc.dart';
import '../widgets/build_rating.dart';
import '../widgets/info_list_widget.dart';

class FactoryProfileScreen extends StatefulWidget {
  final String id;

  const FactoryProfileScreen({
    super.key,
    required this.id,
  });

  @override
  State<FactoryProfileScreen> createState() => _FactoryProfileScreenState();
}

class _FactoryProfileScreenState extends State<FactoryProfileScreen>
    with TickerProviderStateMixin, ScreenLoader<FactoryProfileScreen> {
  final authBloc = sl<AuthBloc>();
  final userBloc = sl<GetUserBloc>();
  final rateBloc = sl<GetUserBloc>();
  final productBloc = sl<GetUserBloc>();
  final serviceBloc = sl<LocalCompanyBloc>();

  final adsBloc = sl<AdsBlocBloc>();
  final visitorBloc = sl<GetUserBloc>();

  late final CountryBloc countryBloc;
  bool isFollowing = false;

  @override
  void initState() {
    userBloc.add(GetUserByIdEvent(userId: widget.id));
    productBloc.add(GetUserProductsByIdEvent(id: widget.id));
    authBloc.add(AuthCheckRequested());
    countryBloc = BlocProvider.of<CountryBloc>(context);
    countryBloc.add(GetCountryEvent());
    adsBloc.add(GetUserAdsEvent(userId: widget.id));
    visitorBloc.add(AddVisitorEvent(userId: widget.id));

    super.initState();
  }

  // bool isFollowing = false;

  // void checkFollowStatus() async {
  //   bool followStatus = await isFollow(widget.localCompany.id);
  //   setState(() {
  //     isFollowing = followStatus;
  //   });
  // }

  // Future<bool> isFollow(element) async {
  //   final prefs = await SharedPreferences.getInstance();

  //   if (!prefs.containsKey(SharedPreferencesKeys.user)) {
  //     return false;
  //   }

  //   final user = UserModel.fromJson(
  //     json.decode(prefs.getString(SharedPreferencesKeys.user)!)
  //         as Map<String, dynamic>,
  //   );
  //   final isFollow = user.userInfo.followings?.contains(element);
  //   return isFollow ?? false;
  // }

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

  @override
  Widget screen(BuildContext context) {
    final TabController tabController = TabController(length: 3, vsync: this);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<GetUserBloc, GetUserState>(
            bloc: userBloc,
            builder: (context, state) {
              return Row(
                children: [
                  CountryFlag.fromCountryCode(
                    state is GetUserSuccess
                        ? state.userInfo.country ?? 'AE'
                        : 'AE',
                    height: 22.h,
                    width: 22.w,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Expanded(
                    child: Text(
                      state is GetUserSuccess
                          ? state.userInfo.username ?? ''
                          : '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColor.backgroundColor,
                      ),
                    ),
                  ),
                ],
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
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: IconButton(
                      onPressed: () async {
                        state is GetUserSuccess
                            ? await shareImageWithDescription(
                                imageUrl: state.userInfo.profilePhoto ?? '',
                                description:
                                    'https://www.netzoon.com/home/catagories/factories/${state.userInfo.id}',
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
                if (state.userInfo.isService == true) {
                  serviceBloc
                      .add(GetCompanyServicesByIdEvent(id: state.userInfo.id));
                } else {
                  productBloc.add(GetUserProductsByIdEvent(id: widget.id));
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    userBloc.add(GetUserByIdEvent(userId: widget.id));
                    productBloc.add(GetUserProductsByIdEvent(id: widget.id));
                    authBloc.add(AuthCheckRequested());
                    adsBloc.add(GetUserAdsEvent(userId: widget.id));
                    visitorBloc.add(AddVisitorEvent(userId: widget.id));
                  },
                  child: DefaultTabController(
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
                                                imageUrl: state.userInfo
                                                        .profilePhoto ??
                                                    '',
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.fill,
                                                progressIndicatorBuilder:
                                                    (context, url,
                                                            downloadProgress) =>
                                                        Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 70.0,
                                                      vertical: 50),
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: downloadProgress
                                                        .progress,
                                                    color: AppColor
                                                        .backgroundColor,

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
                                                        state.userInfo
                                                                .username ??
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
                                                      builder:
                                                          (context, state) {
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
                                                      state.userInfo.slogn ??
                                                          '',
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
                                                    '${state.userInfo.averageRating?.toStringAsFixed(3)}',
                                                    style: TextStyle(
                                                        color:
                                                            AppColor.secondGrey,
                                                        fontSize: 18.sp,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () => showRating(
                                                        context,
                                                        rateBloc,
                                                        widget.id,
                                                        state.userInfo
                                                                .averageRating ??
                                                            0),
                                                    child: RatingBar.builder(
                                                      minRating: 1,
                                                      maxRating: 5,
                                                      initialRating: state
                                                              .userInfo
                                                              .averageRating ??
                                                          0,
                                                      itemSize: 18.sp,
                                                      ignoreGestures: true,
                                                      itemBuilder:
                                                          (context, _) {
                                                        return const Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        );
                                                      },
                                                      allowHalfRating: true,
                                                      updateOnDrag: true,
                                                      onRatingUpdate:
                                                          (rating) {},
                                                    ),
                                                  ),
                                                  Text(
                                                    '(${state.userInfo.totalRatings} ${AppLocalizations.of(context).translate('review')})',
                                                    style: TextStyle(
                                                      color:
                                                          AppColor.secondGrey,
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
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return FollowingsListScreen(
                                                  type: 'followings',
                                                  who: 'other',
                                                  id: widget.id,
                                                );
                                              }));
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${state.userInfo.followings?.length}',
                                                  style: TextStyle(
                                                    color: AppColor.mainGrey,
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  AppLocalizations.of(context)
                                                      .translate('Followings'),
                                                  style: TextStyle(
                                                      color:
                                                          AppColor.secondGrey,
                                                      fontSize: 10.sp),
                                                ),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return FollowingsListScreen(
                                                  type: 'followers',
                                                  who: 'other',
                                                  id: widget.id,
                                                );
                                              }));
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${state.userInfo.followers?.length}',
                                                  style: TextStyle(
                                                    color: AppColor.mainGrey,
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  AppLocalizations.of(context)
                                                      .translate('Followers'),
                                                  style: TextStyle(
                                                      color:
                                                          AppColor.secondGrey,
                                                      fontSize: 10.sp),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${state.userInfo.profileViews ?? 0}',
                                                style: TextStyle(
                                                  color: AppColor.mainGrey,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                AppLocalizations.of(context)
                                                    .translate('visitors'),
                                                style: TextStyle(
                                                    color: AppColor.secondGrey,
                                                    fontSize: 10.sp),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ClipRRect(
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
                                                    Icons.monetization_on,
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
                                                if (authState
                                                    is Authenticated) {
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
                                                // Navigator.of(context).push(
                                                //   MaterialPageRoute(
                                                //       builder: (context) {
                                                //     return const ChatPageScreen();
                                                //   }),
                                                // );
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Container(
                                                  height: 50.h,
                                                  width: 150.w,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: AppColor
                                                        .backgroundColor,
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
                                                                    'chat'),
                                                            style: TextStyle(
                                                              color: AppColor
                                                                  .white,
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
                          ),
                        ];
                      },
                      body: BlocBuilder<CountryBloc, CountryState>(
                        bloc: countryBloc,
                        builder: (context, countryState) {
                          if (countryState is CountryInitial) {
                            return Column(
                              children: [
                                TabBar(
                                  controller: tabController,
                                  tabs: [
                                    // state.userInfo.isService == false ||
                                    //         state.userInfo.isService == null
                                    //     ?
                                    BlocBuilder<GetUserBloc, GetUserState>(
                                      bloc: productBloc,
                                      builder: (context, productstate) {
                                        return Text(
                                          '${AppLocalizations.of(context).translate('Products')} ${productstate is GetUserProductsSuccess ? '(${productstate.products.length})' : '(0)'}',
                                          style: TextStyle(
                                            color: AppColor.black,
                                            fontSize: 11.sp,
                                          ),
                                        );
                                      },
                                    ),
                                    BlocBuilder<LocalCompanyBloc,
                                        LocalCompanyState>(
                                      bloc: serviceBloc,
                                      builder: (context, serviceState) {
                                        return Text(
                                          '${AppLocalizations.of(context).translate('production services')} ${serviceState is GetCompanyServiceSuccess ? '(${serviceState.services.length})' : '(0)'}',
                                          style: TextStyle(
                                            color: AppColor.black,
                                            fontSize: 11.sp,
                                          ),
                                        );
                                      },
                                    ),
                                    // Text(
                                    //   AppLocalizations.of(context)
                                    //       .translate('my_ads'),
                                    //   style: TextStyle(
                                    //     color: AppColor.black,
                                    //     fontSize: 10.sp,
                                    //   ),
                                    // ),
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
                                // SizedBox(
                                //   height: 20.h,
                                // ),
                                Expanded(
                                  child: TabBarView(
                                    controller: tabController,
                                    children: [
                                      // state.userInfo.isService == false ||
                                      //         state.userInfo.isService == null?
                                      RefreshIndicator(
                                        onRefresh: () async {
                                          productBloc.add(
                                              GetUserProductsByIdEvent(
                                                  id: widget.id));
                                        },
                                        color: AppColor.white,
                                        backgroundColor:
                                            AppColor.backgroundColor,
                                        child: BlocBuilder<GetUserBloc,
                                            GetUserState>(
                                          bloc: productBloc,
                                          builder: (context, state) {
                                            if (state
                                                is GetUserProductsInProgress) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color:
                                                      AppColor.backgroundColor,
                                                ),
                                              );
                                            } else if (state
                                                is GetUserProductsFailure) {
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
                                                is GetUserProductsSuccess) {
                                              return state.products.isNotEmpty
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                              child:
                                                                  DynamicHeightGridView(
                                                                      itemCount: state
                                                                          .products
                                                                          .length,
                                                                      crossAxisCount:
                                                                          2,
                                                                      crossAxisSpacing:
                                                                          10,
                                                                      mainAxisSpacing:
                                                                          10,
                                                                      builder: (ctx,
                                                                          index) {
                                                                        return ListSubSectionsWidget(
                                                                          deviceList:
                                                                              state.products[index],
                                                                          onTap:
                                                                              () {
                                                                            Navigator.of(context).push(
                                                                              MaterialPageRoute(
                                                                                builder: (context) {
                                                                                  return ProductDetailScreen(item: state.products[index].id);
                                                                                },
                                                                              ),
                                                                            );
                                                                          },
                                                                        );

                                                                        /// return your widget here.
                                                                      })),
                                                        ],
                                                      ),
                                                    )
                                                  : Center(
                                                      child: Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .translate(
                                                                  'no_items'),
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
                                          serviceBloc.add(
                                              GetCompanyServicesByIdEvent(
                                                  id: state.userInfo.id));
                                        },
                                        color: AppColor.white,
                                        backgroundColor:
                                            AppColor.backgroundColor,
                                        child: BlocBuilder<LocalCompanyBloc,
                                            LocalCompanyState>(
                                          bloc: serviceBloc,
                                          builder: (context, serviceState) {
                                            if (serviceState
                                                is LocalCompanyInProgress) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color:
                                                      AppColor.backgroundColor,
                                                ),
                                              );
                                            } else if (serviceState
                                                is LocalCompanyFailure) {
                                              final failure =
                                                  serviceState.message;
                                              return Center(
                                                child: Text(
                                                  failure,
                                                  style: const TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              );
                                            } else if (serviceState
                                                is GetCompanyServiceSuccess) {
                                              return BlocBuilder<CountryBloc,
                                                  CountryState>(
                                                bloc: countryBloc,
                                                builder:
                                                    (context, countryState) {
                                                  if (countryState
                                                      is CountryInitial) {
                                                    return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child:
                                                            DynamicHeightGridView(
                                                                itemCount:
                                                                    serviceState
                                                                        .services
                                                                        .length,
                                                                crossAxisCount:
                                                                    2,
                                                                crossAxisSpacing:
                                                                    10,
                                                                mainAxisSpacing:
                                                                    10,
                                                                builder: (ctx,
                                                                    index) {
                                                                  return Container(
                                                                    height:
                                                                        240.h,
                                                                    margin: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            8),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: AppColor
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: AppColor
                                                                              .secondGrey
                                                                              .withOpacity(0.5),
                                                                          blurRadius:
                                                                              10,
                                                                          spreadRadius:
                                                                              2,
                                                                          offset: const Offset(
                                                                              0,
                                                                              3),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius: const BorderRadius
                                                                          .all(
                                                                          Radius.circular(
                                                                              20)),
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .push(
                                                                            MaterialPageRoute(
                                                                              builder: (context) {
                                                                                return CompanyServiceDetailsScreen(
                                                                                  companyServiceId: serviceState.services[index].id,
                                                                                  callNumber: state.userInfo.firstMobile,
                                                                                );
                                                                              },
                                                                            ),
                                                                          );
                                                                        },
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            CachedNetworkImage(
                                                                              imageUrl: serviceState.services[index].imageUrl ?? '',
                                                                              height: 180.h,
                                                                              width: 200.w,
                                                                              fit: BoxFit.contain,
                                                                              progressIndicatorBuilder: (context, url, downloadProgress) => Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 50),
                                                                                child: CircularProgressIndicator(
                                                                                  value: downloadProgress.progress,
                                                                                  color: AppColor.backgroundColor,

                                                                                  // strokeWidth: 10,
                                                                                ),
                                                                              ),
                                                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(right: 9.0, left: 9.0, bottom: 8.0),
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  Text(
                                                                                    serviceState.services[index].title,
                                                                                    maxLines: 2,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    textAlign: TextAlign.center,
                                                                                    style: const TextStyle(
                                                                                      color: AppColor.backgroundColor,
                                                                                    ),
                                                                                  ),
                                                                                  serviceState.services[index].bio != null
                                                                                      ? Text(
                                                                                          serviceState.services[index].bio ?? '',
                                                                                          maxLines: 2,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          textAlign: TextAlign.center,
                                                                                          style: TextStyle(color: AppColor.secondGrey, fontSize: 10.sp),
                                                                                        )
                                                                                      : const SizedBox(),
                                                                                  // Text(
                                                                                  //   '${state.companyVehicles[index].price} \$',
                                                                                  //   style:
                                                                                  //       const TextStyle(
                                                                                  //     color: AppColor
                                                                                  //         .colorTwo,
                                                                                  //   ),
                                                                                  // ),
                                                                                  // RichText(
                                                                                  //   text: TextSpan(style: TextStyle(fontSize: 13.sp, color: AppColor.backgroundColor), children: <TextSpan>[
                                                                                  //     TextSpan(
                                                                                  //       text: '${serviceState.services[index].price}',
                                                                                  //       style: const TextStyle(
                                                                                  //         fontWeight: FontWeight.w700,
                                                                                  //       ),
                                                                                  //     ),
                                                                                  //     TextSpan(
                                                                                  //       text: getCurrencyFromCountry(
                                                                                  //         countryState.selectedCountry,
                                                                                  //         context,
                                                                                  //       ),
                                                                                  //       style: const TextStyle(color: AppColor.backgroundColor, fontSize: 10),
                                                                                  //     )
                                                                                  //   ]),
                                                                                  // ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                }));
                                                  }
                                                  return Container();
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
                                        firstMobile:
                                            state.userInfo.firstMobile ?? '',
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
                            );
                          }
                          return Container();
                        },
                      ),
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
}
