import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/advertising/advertising.dart';
import 'package:netzoon/presentation/advertising/blocs/ads/ads_bloc_bloc.dart';
import 'package:netzoon/presentation/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:netzoon/presentation/categories/local_company/company_service_detail_screen.dart';
import 'package:netzoon/presentation/categories/local_company/local_company_bloc/local_company_bloc.dart';
import 'package:netzoon/presentation/categories/widgets/product_details.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/link.dart';

import '../../../data/core/constants/constants.dart';
import '../../../data/models/auth/user/user_model.dart';
import '../../chat/screens/chat_page_screen.dart';
import '../../core/blocs/country_bloc/country_bloc.dart';
import '../../core/helpers/get_currency_of_country.dart';
import '../../core/widgets/on_failure_widget.dart';
import '../../core/widgets/screen_loader.dart';
import '../../profile/blocs/get_user/get_user_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../profile/screens/followings_list_screen.dart';
import '../widgets/build_rating.dart';

class LocalCompanyProfileScreen extends StatefulWidget {
  // final LocalCompany localCompany;
  final UserInfo localCompany;
  const LocalCompanyProfileScreen({
    super.key,
    required this.localCompany,
  });

  @override
  State<LocalCompanyProfileScreen> createState() =>
      _LocalCompanyProfileScreenState();
}

class _LocalCompanyProfileScreenState extends State<LocalCompanyProfileScreen>
    with TickerProviderStateMixin, ScreenLoader<LocalCompanyProfileScreen> {
  final productsBloc = sl<LocalCompanyBloc>();
  final userBloc = sl<GetUserBloc>();
  final rateBloc = sl<GetUserBloc>();
  final prodBloc = sl<LocalCompanyBloc>();
  final adsBloc = sl<AdsBlocBloc>();
  final authBloc = sl<AuthBloc>();
  final serviceBloc = sl<LocalCompanyBloc>();
  bool isFollowing = false;
  late final CountryBloc countryBloc;
  @override
  void initState() {
    countryBloc = BlocProvider.of<CountryBloc>(context);
    countryBloc.add(GetCountryEvent());
    // productsBloc.add(GetLocalCompanyProductsEvent(id: widget.localCompany.id));

    userBloc.add(GetUserByIdEvent(userId: widget.localCompany.id));
    prodBloc.add(GetLocalProductsEvent(username: widget.localCompany.id));
    adsBloc.add(GetUserAdsEvent(userId: widget.localCompany.id));
    authBloc.add(AuthCheckRequested());

    checkFollowStatus();
    super.initState();
  }

  void checkFollowStatus() async {
    bool followStatus = await isFollow(widget.localCompany.id);
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
    // final TextEditingController search = TextEditingController();
    final TabController tabController = TabController(length: 3, vsync: this);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.localCompany.username ?? '',
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
                  prodBloc.add(
                      GetLocalProductsEvent(username: widget.localCompany.id));
                }
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
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.fill,
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
                                            Text(
                                              state.userInfo.username ?? '',
                                              style: TextStyle(
                                                color: AppColor.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                            state.userInfo.slogn != null
                                                ? Text(
                                                    state.userInfo.slogn ?? '',
                                                    style: TextStyle(
                                                      color:
                                                          AppColor.secondGrey,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 13.sp,
                                                    ),
                                                  )
                                                : const SizedBox(),
                                            // SizedBox(
                                            //   height: 10.h,
                                            // ),
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () => showRating(
                                                      context,
                                                      rateBloc,
                                                      widget.localCompany.id,
                                                      widget.localCompany
                                                              .averageRating ??
                                                          0),
                                                  child: RatingBar.builder(
                                                    minRating: 1,
                                                    maxRating: 5,
                                                    initialRating: widget
                                                            .localCompany
                                                            .averageRating ??
                                                        0,
                                                    itemSize: 25,
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
                                                                          .localCompany
                                                                          .id));
                                                        },
                                                      );
                                                    }
                                                    return Container();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      state.userInfo.bio ?? 'BIO',
                                      style: TextStyle(
                                        color: AppColor.mainGrey,
                                        fontSize: 11.3.sp,
                                      ),
                                    ),
                                  ),
                                  state.userInfo.link != null
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Link(
                                            uri: Uri.parse(
                                              state.userInfo.link ?? '',
                                            ),
                                            builder: ((context, followLink) =>
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.link,
                                                      color:
                                                          AppColor.secondGrey,
                                                      size: 20,
                                                    ),
                                                    GestureDetector(
                                                      onTap: followLink,
                                                      child: Text(
                                                        state.userInfo.link ??
                                                            '',
                                                        style: TextStyle(
                                                          color: AppColor
                                                              .backgroundColor,
                                                          fontSize: 11.sp,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        )
                                      : const SizedBox(),
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
                                                id: widget.localCompany.id,
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
                                                    color: AppColor.secondGrey,
                                                    fontSize: 12.sp),
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
                                                id: widget.localCompany.id,
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
                                                    color: AppColor.secondGrey,
                                                    fontSize: 12.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    // height: 50.h,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: Container(
                                            height: 50,
                                            width: 180,
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
                                                    size: 18.sp,
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
                                                        fontSize: 13.sp,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                return const ChatPageScreen();
                                              }),
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Container(
                                              height: 50,
                                              width: 180,
                                              decoration: const BoxDecoration(
                                                color: AppColor.backgroundColor,
                                                // borderRadius: BorderRadius.circular(100),
                                              ),
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.chat,
                                                      color: Colors.white,
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
                                                          fontSize: 13.sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
                              state.userInfo.isService == true
                                  ? AppLocalizations.of(context)
                                      .translate('services')
                                  : AppLocalizations.of(context)
                                      .translate('Products'),
                              style: TextStyle(
                                color: AppColor.black,
                                fontSize: 11.sp,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context).translate('my_ads'),
                              style: TextStyle(
                                color: AppColor.black,
                                fontSize: 11.sp,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate('about_us'),
                              style: TextStyle(
                                color: AppColor.black,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: tabController,
                            children: [
                              state.userInfo.isService == false ||
                                      state.userInfo.isService == null
                                  ? ProductListWidget(
                                      prodBloc: prodBloc,
                                      widget: widget,
                                      countryBloc: countryBloc)
                                  : RefreshIndicator(
                                      onRefresh: () async {
                                        serviceBloc.add(
                                            GetCompanyServicesByIdEvent(
                                                id: state.userInfo.id));
                                      },
                                      color: AppColor.white,
                                      backgroundColor: AppColor.backgroundColor,
                                      child: BlocBuilder<LocalCompanyBloc,
                                          LocalCompanyState>(
                                        bloc: serviceBloc,
                                        builder: (context, serviceState) {
                                          if (serviceState
                                              is LocalCompanyInProgress) {
                                            return const Center(
                                              child: CircularProgressIndicator(
                                                color: AppColor.backgroundColor,
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
                                              builder: (context, countryState) {
                                                if (countryState
                                                    is CountryInitial) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: GridView.builder(
                                                      gridDelegate:
                                                          SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: 2,
                                                              childAspectRatio:
                                                                  0.95,
                                                              crossAxisSpacing:
                                                                  10.w,
                                                              mainAxisSpacing:
                                                                  10.h),
                                                      shrinkWrap: true,
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      itemCount: serviceState
                                                          .services.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 8),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                AppColor.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: AppColor
                                                                    .secondGrey
                                                                    .withOpacity(
                                                                        0.5),
                                                                blurRadius: 10,
                                                                spreadRadius: 2,
                                                                offset:
                                                                    const Offset(
                                                                        0, 3),
                                                              ),
                                                            ],
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .all(
                                                                    Radius
                                                                        .circular(
                                                                            20)),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) {
                                                                      return CompanyServiceDetailsScreen(
                                                                          companyService:
                                                                              serviceState.services[index]);
                                                                    },
                                                                  ),
                                                                );
                                                              },
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  CachedNetworkImage(
                                                                    imageUrl: serviceState
                                                                            .services[index]
                                                                            .imageUrl ??
                                                                        '',
                                                                    height:
                                                                        120.h,
                                                                    width:
                                                                        200.w,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            9.0,
                                                                        left:
                                                                            9.0,
                                                                        bottom:
                                                                            8.0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          serviceState
                                                                              .services[index]
                                                                              .title,
                                                                          style:
                                                                              const TextStyle(
                                                                            color:
                                                                                AppColor.backgroundColor,
                                                                          ),
                                                                        ),
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
                                                      },
                                                    ),
                                                  );
                                                }
                                                return Container();
                                              },
                                            );
                                          }
                                          return Container();
                                        },
                                      ),
                                    ),
                              BlocBuilder<AdsBlocBloc, AdsBlocState>(
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
                                              userId: widget.localCompany.id));
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
                                                height: 220.h,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
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
                              // Container(
                              //   padding: const EdgeInsets.only(top: 30),
                              //   child: Text(
                              //     AppLocalizations.of(context)
                              //         .translate('There are no documents'),
                              //     textAlign: TextAlign.center,
                              //     style: const TextStyle(
                              //       color: AppColor.black,
                              //     ),
                              //   ),
                              // ),
                              ListView(
                                children: [
                                  Column(
                                    children: [
                                      titleAndInput(
                                          title: AppLocalizations.of(context)
                                              .translate('company_name'),
                                          input: widget.localCompany.username ??
                                              ''),
                                      widget.localCompany.description != null
                                          ? titleAndInput(
                                              title:
                                                  AppLocalizations.of(context)
                                                      .translate('desc'),
                                              input: widget.localCompany
                                                      .description ??
                                                  '')
                                          : const SizedBox(),

                                      titleAndInput(
                                          title: AppLocalizations.of(context)
                                              .translate('mobile'),
                                          input:
                                              widget.localCompany.firstMobile ??
                                                  ';'),
                                      titleAndInput(
                                          title: AppLocalizations.of(context)
                                              .translate('email'),
                                          input:
                                              widget.localCompany.email ?? ''),
                                      // widget.localCompany.website != null
                                      //     ? titleAndInput(
                                      //         title: AppLocalizations.of(context)
                                      //             .translate('website'),
                                      //         input:
                                      //             widget.localCompany.website ??
                                      //                 '')
                                      //     : const SizedBox(),
                                      state.userInfo.bio != null &&
                                              state.userInfo.bio != ''
                                          ? titleAndInput(
                                              title:
                                                  AppLocalizations.of(context)
                                                      .translate('Bio'),
                                              input: state.userInfo.bio ?? '')
                                          : const SizedBox(),

                                      state.userInfo.address != null &&
                                              state.userInfo.address != ''
                                          ? titleAndInput(
                                              title:
                                                  AppLocalizations.of(context)
                                                      .translate('address'),
                                              input:
                                                  state.userInfo.address ?? '')
                                          : const SizedBox(),
                                      state.userInfo.website != null &&
                                              state.userInfo.website != ''
                                          ? titleAndInput(
                                              title:
                                                  AppLocalizations.of(context)
                                                      .translate('website'),
                                              input:
                                                  state.userInfo.website ?? '')
                                          : const SizedBox(),
                                      state.userInfo.link != null &&
                                              state.userInfo.link != ''
                                          ? titleAndInput(
                                              title:
                                                  AppLocalizations.of(context)
                                                      .translate('link'),
                                              input: state.userInfo.link ?? '')
                                          : const SizedBox(),
                                      widget.localCompany.deliverable != null
                                          ? titleAndInput(
                                              title:
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Is there delivery'),
                                              input: state.userInfo.deliverable!
                                                  ? AppLocalizations.of(context)
                                                      .translate('Yes')
                                                  : AppLocalizations.of(context)
                                                      .translate('No'),
                                            )
                                          : const SizedBox(),
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

class ProductListWidget extends StatelessWidget {
  const ProductListWidget({
    super.key,
    required this.prodBloc,
    required this.widget,
    required this.countryBloc,
  });

  final LocalCompanyBloc prodBloc;
  final LocalCompanyProfileScreen widget;
  final CountryBloc countryBloc;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        prodBloc.add(GetLocalProductsEvent(username: widget.localCompany.id));
      },
      color: AppColor.white,
      backgroundColor: AppColor.backgroundColor,
      child: BlocBuilder<LocalCompanyBloc, LocalCompanyState>(
        bloc: prodBloc,
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
          } else if (state is LocalCompanyProductsSuccess) {
            return state.products.isEmpty
                ? Text(
                    AppLocalizations.of(context).translate('no_items'),
                    style: TextStyle(
                      color: AppColor.backgroundColor,
                      fontSize: 22.sp,
                    ),
                  )
                : BlocBuilder<CountryBloc, CountryState>(
                    bloc: countryBloc,
                    builder: (context, countryState) {
                      if (countryState is CountryInitial) {
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 0.80,
                                  crossAxisSpacing: 10.w,
                                  mainAxisSpacing: 10.h),
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.products.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                  color: AppColor.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          AppColor.secondGrey.withOpacity(0.5),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]),
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ProductDetailsScreen(
                                            products: state.products,
                                            index: index,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl:
                                            state.products[index].imageUrl,
                                        height: 65.h,
                                        width: 160.w,
                                        fit: BoxFit.contain,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 9.0, left: 9.0, bottom: 2.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  state.products[index].name,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: AppColor
                                                        .backgroundColor,
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '${state.products[index].price} \$',
                                        style: const TextStyle(
                                          color: AppColor.colorTwo,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return Container();
                    },
                  );
          }
          return Container();
        },
      ),
    );
  }
}
