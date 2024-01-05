import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/home/widgets/auth_alert.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/link.dart';

import '../../../data/core/constants/constants.dart';
import '../../../data/models/auth/user/user_model.dart';
import '../../../domain/auth/entities/user_info.dart';
import '../../../injection_container.dart';
import '../../advertising/advertising.dart';
import '../../advertising/blocs/ads/ads_bloc_bloc.dart';
import '../../auth/blocs/auth_bloc/auth_bloc.dart';
import '../../chat/screens/chat_page_screen.dart';
import '../../core/blocs/country_bloc/country_bloc.dart';
import '../../core/constant/colors.dart';
import '../../core/helpers/get_currency_of_country.dart';
import '../../core/widgets/on_failure_widget.dart';
import '../../core/widgets/screen_loader.dart';
import '../../profile/blocs/get_user/get_user_bloc.dart';
import '../../utils/app_localizations.dart';
import '../widgets/build_rating.dart';
import '../widgets/product_details.dart';
import '../widgets/title_and_input.dart';

class FreezoneCompanyProfileScreen extends StatefulWidget {
  final String id;

  const FreezoneCompanyProfileScreen({super.key, required this.id});

  @override
  State<FreezoneCompanyProfileScreen> createState() =>
      _FreezoneCompanyProfileScreenState();
}

class _FreezoneCompanyProfileScreenState
    extends State<FreezoneCompanyProfileScreen>
    with TickerProviderStateMixin, ScreenLoader<FreezoneCompanyProfileScreen> {
  final userBloc = sl<GetUserBloc>();
  final rateBloc = sl<GetUserBloc>();

  final productBloc = sl<GetUserBloc>();
  final adsBloc = sl<AdsBlocBloc>();
  final visitorBloc = sl<GetUserBloc>();

  final authBloc = sl<AuthBloc>();
  late final CountryBloc countryBloc;
  bool isFollowing = false;

  @override
  void initState() {
    userBloc.add(GetUserByIdEvent(userId: widget.id));
    productBloc.add(GetUserProductsByIdEvent(id: widget.id));
    authBloc.add(AuthCheckRequested());
    adsBloc.add(GetUserAdsEvent(userId: widget.id));
    countryBloc = BlocProvider.of<CountryBloc>(context);
    countryBloc.add(GetCountryEvent());
    visitorBloc.add(AddVisitorEvent(userId: widget.id));

    checkFollowStatus();
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
              return Text(
                state is GetUserSuccess ? state.userInfo.username ?? '' : '',
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
                                                  '(${state.userInfo.totalRatings} ${AppLocalizations.of(context).translate('review')})',
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
                                                          fontSize: 15.sp,
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
                        ),
                      ];
                    },
                    body: Column(
                      children: [
                        TabBar(
                          controller: tabController,
                          tabs: [
                            Text(
                              AppLocalizations.of(context)
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
                              RefreshIndicator(
                                onRefresh: () async {
                                  productBloc.add(GetUserProductsByIdEvent(
                                      id: state.userInfo.id));
                                },
                                color: AppColor.white,
                                backgroundColor: AppColor.backgroundColor,
                                child: BlocBuilder<GetUserBloc, GetUserState>(
                                  bloc: productBloc,
                                  builder: (context, state) {
                                    if (state is GetUserProductsInProgress) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColor.backgroundColor,
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
                                      return state.products.isEmpty
                                          ? Center(
                                              child: Text(
                                                  AppLocalizations.of(context)
                                                      .translate('no_items'),
                                                  style: const TextStyle(
                                                      color: AppColor
                                                          .backgroundColor)),
                                            )
                                          : BlocBuilder<CountryBloc,
                                              CountryState>(
                                              bloc: countryBloc,
                                              builder: (context, countryState) {
                                                if (countryState
                                                    is CountryInitial) {
                                                  return GridView.builder(
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 3,
                                                            childAspectRatio:
                                                                0.95,
                                                            crossAxisSpacing:
                                                                10.w,
                                                            mainAxisSpacing:
                                                                10.h),
                                                    shrinkWrap: true,
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    itemCount:
                                                        state.products.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    20)),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                                  return ProductDetailsScreen(
                                                                    products: state
                                                                        .products,
                                                                    index:
                                                                        index,
                                                                  );
                                                                },
                                                              ),
                                                            );
                                                          },
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              CachedNetworkImage(
                                                                imageUrl: state
                                                                    .products[
                                                                        index]
                                                                    .imageUrl,
                                                                height: 65.h,
                                                                width: 120.w,
                                                                fit: BoxFit
                                                                    .contain,
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
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Text(
                                                                    state
                                                                        .products[
                                                                            index]
                                                                        .name,
                                                                    style: const TextStyle(
                                                                        color: AppColor
                                                                            .backgroundColor,
                                                                        fontSize:
                                                                            10),
                                                                  ),
                                                                  // Text(
                                                                  //   '${state.products[index].price} \$',
                                                                  //   style: const TextStyle(
                                                                  //       color: AppColor
                                                                  //           .colorTwo,
                                                                  //       fontSize:
                                                                  //           10),
                                                                  // ),
                                                                  RichText(
                                                                    text: TextSpan(
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                10.sp,
                                                                            color: AppColor.backgroundColor),
                                                                        children: <TextSpan>[
                                                                          TextSpan(
                                                                            text:
                                                                                '${state.products[index].price}',
                                                                            style:
                                                                                const TextStyle(
                                                                              fontWeight: FontWeight.w700,
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                getCurrencyFromCountry(
                                                                              countryState.selectedCountry,
                                                                              context,
                                                                            ),
                                                                            style:
                                                                                TextStyle(color: AppColor.backgroundColor, fontSize: 10.sp),
                                                                          )
                                                                        ]),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                                return const SizedBox();
                                              },
                                            );
                                    }
                                    return const SizedBox();
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
                                          ? Center(
                                              child: Text(
                                                  AppLocalizations.of(context)
                                                      .translate('no_items'),
                                                  style: const TextStyle(
                                                      color: AppColor
                                                          .backgroundColor)),
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
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
