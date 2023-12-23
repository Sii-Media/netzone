import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/presentation/advertising/advertising.dart';
import 'package:netzoon/presentation/advertising/blocs/ads/ads_bloc_bloc.dart';
import 'package:netzoon/presentation/categories/widgets/product_details.dart';
import 'package:netzoon/presentation/core/helpers/share_image_function.dart';
import 'package:netzoon/presentation/core/widgets/on_failure_widget.dart';
import 'package:netzoon/presentation/deals/blocs/dealsItems/deals_items_bloc.dart';
import 'package:netzoon/presentation/deals/view_all_deals.dart';
import 'package:netzoon/presentation/ecommerce/widgets/listsubsectionswidget.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/core/constants/constants.dart';
import '../../../../data/models/auth/user/user_model.dart';
import '../../../../injection_container.dart';
import '../../../auth/blocs/auth_bloc/auth_bloc.dart';
import '../../../chat/screens/chat_page_screen.dart';
import '../../../core/blocs/country_bloc/country_bloc.dart';
import '../../../core/constant/colors.dart';
import '../../../core/helpers/get_currency_of_country.dart';
import '../../../core/screen/product_details_screen.dart';
import '../../../core/widgets/screen_loader.dart';
import '../../../home/widgets/auth_alert.dart';
import '../../../profile/blocs/get_user/get_user_bloc.dart';
import '../../../utils/app_localizations.dart';
import '../../widgets/build_rating.dart';
import '../../widgets/title_and_input.dart';

class UsersProfileScreen extends StatefulWidget {
  final String userId;
  const UsersProfileScreen({super.key, required this.userId});

  @override
  State<UsersProfileScreen> createState() => _UsersProfileScreenState();
}

class _UsersProfileScreenState extends State<UsersProfileScreen>
    with TickerProviderStateMixin, ScreenLoader<UsersProfileScreen> {
  final userBloc = sl<GetUserBloc>();
  final rateBloc = sl<GetUserBloc>();
  final visitorBloc = sl<GetUserBloc>();
  final adsBloc = sl<AdsBlocBloc>();
  final dealsBloc = sl<DealsItemsBloc>();
  final productBloc = sl<GetUserBloc>();
  final myProductBloc = sl<GetUserBloc>();
  final authBloc = sl<AuthBloc>();
  late final CountryBloc countryBloc;
  bool isFollowing = false;
  @override
  void initState() {
    userBloc.add(GetUserByIdEvent(userId: widget.userId));
    productBloc.add(GetUserProductsByIdEvent(id: widget.userId));
    myProductBloc.add(GetSelectedProductsByUserIdEvent(userId: widget.userId));
    authBloc.add(AuthCheckRequested());
    countryBloc = BlocProvider.of<CountryBloc>(context);
    countryBloc.add(GetCountryEvent());
    visitorBloc.add(AddVisitorEvent(userId: widget.userId));
    adsBloc.add(GetUserAdsEvent(userId: widget.userId));
    dealsBloc.add(GetUserDealsEvent(userId: widget.userId));
    checkFollowStatus();
    super.initState();
  }

  void checkFollowStatus() async {
    bool followStatus = await isFollow(widget.userId);
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
    final TabController tabController = TabController(length: 3, vsync: this);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 45.h,
          title: BlocBuilder<GetUserBloc, GetUserState>(
            bloc: userBloc,
            builder: (context, userState) {
              return Text(
                userState is GetUserSuccess
                    ? userState.userInfo.username ?? ''
                    : '',
                style: const TextStyle(
                  color: AppColor.backgroundColor,
                ),
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
                        state is GetUserSuccess
                            ? await shareImageWithDescription(
                                imageUrl: state.userInfo.profilePhoto ?? '',
                                description:
                                    'https://netzoon.com/home/catagories/users/${state.userInfo.id}',
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
                                  // Container(
                                  //   width: double.infinity,
                                  //   height: 140.h,
                                  //   decoration: BoxDecoration(
                                  //     border: Border(
                                  //       bottom: BorderSide(
                                  //         color: AppColor.secondGrey
                                  //             .withOpacity(0.3),
                                  //         width: 1,
                                  //       ),
                                  //     ),
                                  //   ),
                                  //   child: CachedNetworkImage(
                                  //     imageUrl: state.userInfo.coverPhoto ??
                                  //         'https://img.freepik.com/free-vector/hand-painted-watercolor-pastel-sky-background_23-2148902771.jpg?w=2000',
                                  //     fit: BoxFit.cover,
                                  //     progressIndicatorBuilder:
                                  //         (context, url, downloadProgress) =>
                                  //             Padding(
                                  //       padding: const EdgeInsets.symmetric(
                                  //           horizontal: 70.0, vertical: 50),
                                  //       child: CircularProgressIndicator(
                                  //         value: downloadProgress.progress,
                                  //         color: AppColor.backgroundColor,

                                  //         // strokeWidth: 10,
                                  //       ),
                                  //     ),
                                  //     errorWidget: (context, url, error) =>
                                  //         const Icon(Icons.error),
                                  //   ),
                                  // ),
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
                                              width: 100.r,
                                              height: 100.r,
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
                                                                            .userId));
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
                                                      state.userInfo.id,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                                                  'chat'),
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
                    body: BlocBuilder<CountryBloc, CountryState>(
                      bloc: countryBloc,
                      builder: (context, countryState) {
                        if (countryState is CountryInitial) {
                          return Column(
                            children: [
                              TabBar(
                                controller: tabController,
                                tabs: [
                                  BlocBuilder<GetUserBloc, GetUserState>(
                                    bloc: myProductBloc,
                                    builder: (context, myProdState) {
                                      return Text(
                                        '${AppLocalizations.of(context).translate('companies_products')} (${myProdState is GetSelectedProductsSuccess ? myProdState.products.length : 0})',
                                        style: TextStyle(
                                          color: AppColor.black,
                                          fontSize: 9.sp,
                                        ),
                                      );
                                    },
                                  ),
                                  Text(
                                    AppLocalizations.of(context)
                                        .translate('my_ads'),
                                    style: TextStyle(
                                      color: AppColor.black,
                                      fontSize: 9.sp,
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)
                                        .translate('deals'),
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
                                    // RefreshIndicator(
                                    //   onRefresh: () async {
                                    //     productBloc.add(
                                    //         GetUserProductsByIdEvent(
                                    //             id: widget.user.id));
                                    //   },
                                    //   color: AppColor.white,
                                    //   backgroundColor: AppColor.backgroundColor,
                                    //   child: BlocBuilder<GetUserBloc,
                                    //       GetUserState>(
                                    //     bloc: productBloc,
                                    //     builder: (context, state) {
                                    //       if (state
                                    //           is GetUserProductsInProgress) {
                                    //         return const Center(
                                    //           child: CircularProgressIndicator(
                                    //             color: AppColor.backgroundColor,
                                    //           ),
                                    //         );
                                    //       } else if (state
                                    //           is GetUserProductsFailure) {
                                    //         final failure = state.message;
                                    //         return Center(
                                    //           child: Text(
                                    //             failure,
                                    //             style: const TextStyle(
                                    //               color: Colors.red,
                                    //             ),
                                    //           ),
                                    //         );
                                    //       } else if (state
                                    //           is GetUserProductsSuccess) {
                                    //         return state.products.isNotEmpty
                                    //             ? Padding(
                                    //                 padding:
                                    //                     const EdgeInsets.all(
                                    //                         8.0),
                                    //                 child: Column(
                                    //                   children: [
                                    //                     Expanded(
                                    //                       child:
                                    //                           GridView.builder(
                                    //                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    //                             crossAxisCount:
                                    //                                 3,
                                    //                             childAspectRatio:
                                    //                                 0.95,
                                    //                             crossAxisSpacing:
                                    //                                 10.w,
                                    //                             mainAxisSpacing:
                                    //                                 10.h),
                                    //                         shrinkWrap: true,
                                    //                         physics:
                                    //                             const BouncingScrollPhysics(),
                                    //                         itemCount: state
                                    //                             .products
                                    //                             .length,
                                    //                         itemBuilder:
                                    //                             (context,
                                    //                                 index) {
                                    //                           return Container(
                                    //                             margin: const EdgeInsets
                                    //                                 .symmetric(
                                    //                                 vertical:
                                    //                                     8),
                                    //                             decoration: BoxDecoration(
                                    //                                 color: AppColor
                                    //                                     .white,
                                    //                                 borderRadius:
                                    //                                     BorderRadius.circular(
                                    //                                         20),
                                    //                                 boxShadow: [
                                    //                                   BoxShadow(
                                    //                                     color: AppColor
                                    //                                         .secondGrey
                                    //                                         .withOpacity(0.5),
                                    //                                     blurRadius:
                                    //                                         10,
                                    //                                     spreadRadius:
                                    //                                         2,
                                    //                                     offset: const Offset(
                                    //                                         0,
                                    //                                         3),
                                    //                                   ),
                                    //                                 ]),
                                    //                             child:
                                    //                                 ClipRRect(
                                    //                               borderRadius:
                                    //                                   const BorderRadius
                                    //                                       .all(
                                    //                                       Radius.circular(
                                    //                                           20)),
                                    //                               child:
                                    //                                   GestureDetector(
                                    //                                 onTap: () {
                                    //                                   Navigator.of(
                                    //                                           context)
                                    //                                       .push(MaterialPageRoute(builder:
                                    //                                           (context) {
                                    //                                     return ProductDetailScreen(
                                    //                                         item:
                                    //                                             state.products[index].id);
                                    //                                   }));
                                    //                                 },
                                    //                                 child:
                                    //                                     Column(
                                    //                                   mainAxisAlignment:
                                    //                                       MainAxisAlignment
                                    //                                           .spaceBetween,
                                    //                                   crossAxisAlignment:
                                    //                                       CrossAxisAlignment
                                    //                                           .center,
                                    //                                   children: [
                                    //                                     CachedNetworkImage(
                                    //                                       imageUrl: state
                                    //                                           .products[index]
                                    //                                           .imageUrl,
                                    //                                       height:
                                    //                                           65.h,
                                    //                                       width:
                                    //                                           160.w,
                                    //                                       fit: BoxFit
                                    //                                           .contain,
                                    //                                       progressIndicatorBuilder: (context, url, downloadProgress) =>
                                    //                                           Padding(
                                    //                                         padding:
                                    //                                             const EdgeInsets.symmetric(horizontal: 70.0, vertical: 50),
                                    //                                         child:
                                    //                                             CircularProgressIndicator(
                                    //                                           value: downloadProgress.progress,
                                    //                                           color: AppColor.backgroundColor,

                                    //                                           // strokeWidth: 10,
                                    //                                         ),
                                    //                                       ),
                                    //                                       errorWidget: (context, url, error) =>
                                    //                                           const Icon(Icons.error),
                                    //                                     ),
                                    //                                     Padding(
                                    //                                       padding: const EdgeInsets
                                    //                                           .only(
                                    //                                           right: 9.0,
                                    //                                           left: 9.0,
                                    //                                           bottom: 8.0),
                                    //                                       child:
                                    //                                           Row(
                                    //                                         mainAxisAlignment:
                                    //                                             MainAxisAlignment.spaceBetween,
                                    //                                         children: [
                                    //                                           Text(
                                    //                                             state.products[index].name,
                                    //                                             style: TextStyle(
                                    //                                               color: AppColor.backgroundColor,
                                    //                                               fontSize: 11.sp,
                                    //                                             ),
                                    //                                           ),
                                    //                                           // Text(
                                    //                                           //   '${state.products[index].price} \$',
                                    //                                           //   style: TextStyle(
                                    //                                           //     color: AppColor.colorTwo,
                                    //                                           //     fontSize: 11.sp,
                                    //                                           //   ),
                                    //                                           // ),
                                    //                                           RichText(
                                    //                                             text: TextSpan(style: TextStyle(fontSize: 12.sp, color: AppColor.backgroundColor), children: <TextSpan>[
                                    //                                               TextSpan(
                                    //                                                 text: '${state.products[index].price}',
                                    //                                                 style: const TextStyle(
                                    //                                                   fontWeight: FontWeight.w700,
                                    //                                                 ),
                                    //                                               ),
                                    //                                               TextSpan(
                                    //                                                 text: getCurrencyFromCountry(
                                    //                                                   countryState.selectedCountry,
                                    //                                                   context,
                                    //                                                 ),
                                    //                                                 style: TextStyle(color: AppColor.backgroundColor, fontSize: 10.sp),
                                    //                                               )
                                    //                                             ]),
                                    //                                           ),
                                    //                                         ],
                                    //                                       ),
                                    //                                     ),
                                    //                                   ],
                                    //                                 ),
                                    //                               ),
                                    //                             ),
                                    //                           );
                                    //                         },
                                    //                       ),
                                    //                     ),
                                    //                   ],
                                    //                 ),
                                    //               )
                                    //             : Center(
                                    //                 child: Text(
                                    //                     AppLocalizations.of(
                                    //                             context)
                                    //                         .translate(
                                    //                             'no_items'),
                                    //                     style: const TextStyle(
                                    //                         color: AppColor
                                    //                             .backgroundColor)),
                                    //               );
                                    //       }
                                    //       return Container();
                                    //     },
                                    //   ),
                                    // ),
                                    RefreshIndicator(
                                      onRefresh: () async {
                                        myProductBloc.add(
                                            GetSelectedProductsByUserIdEvent(
                                                userId: widget.userId));
                                      },
                                      color: AppColor.white,
                                      backgroundColor: AppColor.backgroundColor,
                                      child: BlocBuilder<GetUserBloc,
                                          GetUserState>(
                                        bloc: myProductBloc,
                                        builder: (context, sstate) {
                                          if (sstate
                                              is GetSelectedProductsInProgress) {
                                            return const Center(
                                              child: CircularProgressIndicator(
                                                color: AppColor.backgroundColor,
                                              ),
                                            );
                                          } else if (sstate
                                              is GetSelectedProductsFailure) {
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
                                              is GetSelectedProductsSuccess) {
                                            return sstate.products.isNotEmpty
                                                ? DynamicHeightGridView(
                                                    itemCount:
                                                        sstate.products.length,
                                                    crossAxisCount: 2,
                                                    crossAxisSpacing: 10,
                                                    mainAxisSpacing: 10,
                                                    builder: (ctx, index) {
                                                      return ListSubSectionsWidget(
                                                        deviceList: sstate
                                                            .products[index],
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                                return ProductDetailsScreen(
                                                                    products: sstate
                                                                        .products,
                                                                    index:
                                                                        index);
                                                              },
                                                            ),
                                                          );
                                                        },
                                                      );

                                                      /// return your widget here.
                                                    })
                                                // ? Padding(
                                                //     padding:
                                                //         const EdgeInsets.all(
                                                //             8.0),
                                                //     child: Column(
                                                //       children: [
                                                //         Expanded(
                                                //           child:
                                                //               GridView.builder(
                                                //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                //                 crossAxisCount:
                                                //                     3,
                                                //                 childAspectRatio:
                                                //                     0.95,
                                                //                 crossAxisSpacing:
                                                //                     10.w,
                                                //                 mainAxisSpacing:
                                                //                     10.h),
                                                //             shrinkWrap: true,
                                                //             physics:
                                                //                 const BouncingScrollPhysics(),
                                                //             itemCount: sstate
                                                //                 .products
                                                //                 .length,
                                                //             itemBuilder:
                                                //                 (context,
                                                //                     index) {
                                                //               return Container(
                                                //                 margin: const EdgeInsets
                                                //                     .symmetric(
                                                //                     vertical:
                                                //                         8),
                                                //                 decoration: BoxDecoration(
                                                //                     color: AppColor
                                                //                         .white,
                                                //                     borderRadius:
                                                //                         BorderRadius.circular(
                                                //                             20),
                                                //                     boxShadow: [
                                                //                       BoxShadow(
                                                //                         color: AppColor
                                                //                             .secondGrey
                                                //                             .withOpacity(0.5),
                                                //                         blurRadius:
                                                //                             10,
                                                //                         spreadRadius:
                                                //                             2,
                                                //                         offset: const Offset(
                                                //                             0,
                                                //                             3),
                                                //                       ),
                                                //                     ]),
                                                //                 child:
                                                //                     ClipRRect(
                                                //                   borderRadius:
                                                //                       const BorderRadius
                                                //                           .all(
                                                //                           Radius.circular(
                                                //                               20)),
                                                //                   child:
                                                //                       GestureDetector(
                                                //                     onTap: () {
                                                //                       Navigator.of(
                                                //                               context)
                                                //                           .push(MaterialPageRoute(builder:
                                                //                               (context) {
                                                //                         return ProductDetailScreen(
                                                //                             item:
                                                //                                 sstate.products[index].id);
                                                //                       }));
                                                //                     },
                                                //                     child:
                                                //                         Column(
                                                //                       mainAxisAlignment:
                                                //                           MainAxisAlignment
                                                //                               .spaceBetween,
                                                //                       crossAxisAlignment:
                                                //                           CrossAxisAlignment
                                                //                               .center,
                                                //                       children: [
                                                //                         CachedNetworkImage(
                                                //                           imageUrl: sstate
                                                //                               .products[index]
                                                //                               .imageUrl,
                                                //                           height:
                                                //                               65.h,
                                                //                           width:
                                                //                               160.w,
                                                //                           fit: BoxFit
                                                //                               .contain,
                                                //                           progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                //                               Padding(
                                                //                             padding:
                                                //                                 const EdgeInsets.symmetric(horizontal: 70.0, vertical: 50),
                                                //                             child:
                                                //                                 CircularProgressIndicator(
                                                //                               value: downloadProgress.progress,
                                                //                               color: AppColor.backgroundColor,

                                                //                               // strokeWidth: 10,
                                                //                             ),
                                                //                           ),
                                                //                           errorWidget: (context, url, error) =>
                                                //                               const Icon(Icons.error),
                                                //                         ),
                                                //                         Padding(
                                                //                           padding: const EdgeInsets
                                                //                               .only(
                                                //                               right: 9.0,
                                                //                               left: 9.0,
                                                //                               bottom: 8.0),
                                                //                           child:
                                                //                               Row(
                                                //                             mainAxisAlignment:
                                                //                                 MainAxisAlignment.spaceBetween,
                                                //                             children: [
                                                //                               Text(
                                                //                                 sstate.products[index].name,
                                                //                                 style: TextStyle(
                                                //                                   color: AppColor.backgroundColor,
                                                //                                   fontSize: 11.sp,
                                                //                                 ),
                                                //                               ),
                                                //                               // Text(
                                                //                               //   '${sstate.products[index].price} \$',
                                                //                               //   style: TextStyle(
                                                //                               //     color: AppColor.colorTwo,
                                                //                               //     fontSize: 11.sp,
                                                //                               //   ),
                                                //                               // ),
                                                //                               RichText(
                                                //                                 text: TextSpan(style: TextStyle(fontSize: 12.sp, color: AppColor.backgroundColor), children: <TextSpan>[
                                                //                                   TextSpan(
                                                //                                     text: '${sstate.products[index].price}',
                                                //                                     style: const TextStyle(
                                                //                                       fontWeight: FontWeight.w700,
                                                //                                     ),
                                                //                                   ),
                                                //                                   TextSpan(
                                                //                                     text: getCurrencyFromCountry(
                                                //                                       countryState.selectedCountry,
                                                //                                       context,
                                                //                                     ),
                                                //                                     style: TextStyle(color: AppColor.backgroundColor, fontSize: 10.sp),
                                                //                                   )
                                                //                                 ]),
                                                //                               ),
                                                //                             ],
                                                //                           ),
                                                //                         ),
                                                //                       ],
                                                //                     ),
                                                //                   ),
                                                //                 ),
                                                //               );
                                                //             },
                                                //           ),
                                                //         ),
                                                //       ],
                                                //     ),
                                                //   )
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
                                          return Container(
                                            width: 100,
                                            height: 100,
                                            color: AppColor.red,
                                          );
                                        },
                                      ),
                                    ),
                                    BlocBuilder<AdsBlocBloc, AdsBlocState>(
                                      bloc: adsBloc,
                                      builder: (context, state) {
                                        if (state is AdsBlocInProgress) {
                                          return SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height -
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
                                                    userId: widget.userId));
                                              });
                                        } else if (state is AdsBlocSuccess) {
                                          return state.ads.isEmpty
                                              ? Text(
                                                  AppLocalizations.of(context)
                                                      .translate('no_items'),
                                                  style: TextStyle(
                                                    color: AppColor
                                                        .backgroundColor,
                                                    fontSize: 22.sp,
                                                  ),
                                                )
                                              : ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  itemCount: state.ads.length,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height: 240.h,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                      .circular(
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
                                    BlocBuilder<DealsItemsBloc,
                                        DealsItemsState>(
                                      bloc: dealsBloc,
                                      builder: (context, dealState) {
                                        if (dealState
                                            is GetUserDealsInProgress) {
                                          return SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                120.h,
                                            child: const Center(
                                              child: CircularProgressIndicator(
                                                color: AppColor.backgroundColor,
                                              ),
                                            ),
                                          );
                                        } else if (dealState
                                            is GetUserDealsFailure) {
                                          return FailureWidget(
                                              failure: dealState.message,
                                              onPressed: () {
                                                adsBloc.add(GetUserAdsEvent(
                                                    userId: widget.userId));
                                              });
                                        } else if (dealState
                                            is GetUserDealsSuccess) {
                                          return dealState.deals.isEmpty
                                              ? Text(
                                                  AppLocalizations.of(context)
                                                      .translate('no_items'),
                                                  style: TextStyle(
                                                    color: AppColor
                                                        .backgroundColor,
                                                    fontSize: 22.sp,
                                                  ),
                                                )
                                              : ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  itemCount:
                                                      dealState.deals.length,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      child: Deals(
                                                        dealsInfo: dealState
                                                            .deals[index],
                                                      ),
                                                    );
                                                  },
                                                );
                                        }
                                        return Container();
                                      },
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
