import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/presentation/advertising/advertising.dart';

import '../../../injection_container.dart';
import '../../advertising/blocs/ads/ads_bloc_bloc.dart';
import '../../auth/blocs/auth_bloc/auth_bloc.dart';
import '../../chat/screens/chat_page_screen.dart';
import '../../core/blocs/country_bloc/country_bloc.dart';
import '../../core/constant/colors.dart';
import '../../core/helpers/get_currency_of_country.dart';
import '../../core/screen/product_details_screen.dart';
import '../../core/widgets/on_failure_widget.dart';
import '../../profile/blocs/get_user/get_user_bloc.dart';
import '../../utils/app_localizations.dart';
import '../widgets/build_rating.dart';

class FactoryProfileScreen extends StatefulWidget {
  final UserInfo user;
  const FactoryProfileScreen({super.key, required this.user});

  @override
  State<FactoryProfileScreen> createState() => _FactoryProfileScreenState();
}

class _FactoryProfileScreenState extends State<FactoryProfileScreen>
    with TickerProviderStateMixin {
  final authBloc = sl<AuthBloc>();
  final userBloc = sl<GetUserBloc>();
  final productBloc = sl<GetUserBloc>();
  final adsBloc = sl<AdsBlocBloc>();

  late final CountryBloc countryBloc;
  bool isFollowing = false;
  @override
  void initState() {
    userBloc.add(GetUserByIdEvent(userId: widget.user.id));
    productBloc.add(GetUserProductsByIdEvent(id: widget.user.id));
    authBloc.add(AuthCheckRequested());
    countryBloc = BlocProvider.of<CountryBloc>(context);
    countryBloc.add(GetCountryEvent());
    adsBloc.add(GetUserAdsEvent(userId: widget.user.id));

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

  @override
  Widget build(BuildContext context) {
    final TabController tabController = TabController(length: 3, vsync: this);

    return DefaultTabController(
      length: 3,
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
        ),
        body: BlocBuilder<GetUserBloc, GetUserState>(
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
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          GestureDetector(
                                            onTap: () => showRating(context),
                                            child: RatingBar.builder(
                                              minRating: 1,
                                              maxRating: 5,
                                              initialRating: 3,
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
                                            height: 10.h,
                                          ),
                                          BlocBuilder<AuthBloc, AuthState>(
                                            bloc: authBloc,
                                            builder: (context, state) {
                                              if (state is AuthInProgress) {
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
                                                          BorderRadius.circular(
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
                                                            FontWeight.bold),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      isFollowing =
                                                          !isFollowing;
                                                    });
                                                    userBloc.add(
                                                        ToggleFollowEvent(
                                                            otherUserId: widget
                                                                .user.id));
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
                                                    AppLocalizations.of(context)
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
                                                          .translate('chat'),
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
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('my_products'),
                                  style: TextStyle(
                                    color: AppColor.black,
                                    fontSize: 10.sp,
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('companies_products'),
                                  style: TextStyle(
                                    color: AppColor.black,
                                    fontSize: 10.sp,
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('my_info'),
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
                                  RefreshIndicator(
                                    onRefresh: () async {
                                      productBloc.add(GetUserProductsByIdEvent(
                                          id: widget.user.id));
                                    },
                                    color: AppColor.white,
                                    backgroundColor: AppColor.backgroundColor,
                                    child:
                                        BlocBuilder<GetUserBloc, GetUserState>(
                                      bloc: productBloc,
                                      builder: (context, state) {
                                        if (state
                                            is GetUserProductsInProgress) {
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
                                          return state.products.isNotEmpty
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: GridView.builder(
                                                          gridDelegate:
                                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                                  crossAxisCount:
                                                                      3,
                                                                  childAspectRatio:
                                                                      0.95,
                                                                  crossAxisSpacing:
                                                                      10.w,
                                                                  mainAxisSpacing:
                                                                      10.h),
                                                          shrinkWrap: true,
                                                          physics:
                                                              const BouncingScrollPhysics(),
                                                          itemCount: state
                                                              .products.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Container(
                                                              margin: const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 8),
                                                              decoration: BoxDecoration(
                                                                  color: AppColor
                                                                      .white,
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
                                                                      blurRadius:
                                                                          10,
                                                                      spreadRadius:
                                                                          2,
                                                                      offset:
                                                                          const Offset(
                                                                              0,
                                                                              3),
                                                                    ),
                                                                  ]),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            20)),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .push(MaterialPageRoute(builder:
                                                                            (context) {
                                                                      return ProductDetailScreen(
                                                                          item: state
                                                                              .products[index]
                                                                              .id);
                                                                    }));
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
                                                                        imageUrl: state
                                                                            .products[index]
                                                                            .imageUrl,
                                                                        height:
                                                                            65.h,
                                                                        width:
                                                                            160.w,
                                                                        fit: BoxFit
                                                                            .contain,
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            right:
                                                                                9.0,
                                                                            left:
                                                                                9.0,
                                                                            bottom:
                                                                                8.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              state.products[index].name,
                                                                              style: TextStyle(
                                                                                color: AppColor.backgroundColor,
                                                                                fontSize: 11.sp,
                                                                              ),
                                                                            ),
                                                                            // Text(
                                                                            //   '${state.products[index].price} \$',
                                                                            //   style: TextStyle(
                                                                            //     color: AppColor.colorTwo,
                                                                            //     fontSize: 11.sp,
                                                                            //   ),
                                                                            // ),
                                                                            RichText(
                                                                              text: TextSpan(style: TextStyle(fontSize: 12.sp, color: AppColor.backgroundColor), children: <TextSpan>[
                                                                                TextSpan(
                                                                                  text: '${state.products[index].price}',
                                                                                  style: const TextStyle(
                                                                                    fontWeight: FontWeight.w700,
                                                                                  ),
                                                                                ),
                                                                                TextSpan(
                                                                                  text: getCurrencyFromCountry(
                                                                                    countryState.selectedCountry,
                                                                                    context,
                                                                                  ),
                                                                                  style: TextStyle(color: AppColor.backgroundColor, fontSize: 10.sp),
                                                                                )
                                                                              ]),
                                                                            ),
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
                                                      ),
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
                                                  userId: widget.user.id));
                                            });
                                      } else if (state is AdsBlocSuccess) {
                                        return state.ads.isEmpty
                                            ? Text(
                                                AppLocalizations.of(context)
                                                    .translate('no_items'),
                                                style: TextStyle(
                                                  color:
                                                      AppColor.backgroundColor,
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
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 220.h,
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
                                  ListView(
                                    children: [
                                      Column(
                                        children: [
                                          titleAndInput(
                                              title:
                                                  AppLocalizations.of(context)
                                                      .translate('username'),
                                              input: state.userInfo.username ??
                                                  ''),
                                          titleAndInput(
                                              title:
                                                  AppLocalizations.of(context)
                                                      .translate('email'),
                                              input:
                                                  state.userInfo.email ?? ''),
                                          titleAndInput(
                                              title:
                                                  AppLocalizations.of(context)
                                                      .translate('mobile'),
                                              input:
                                                  state.userInfo.firstMobile ??
                                                      ''),
                                          state.userInfo.bio != null
                                              ? titleAndInput(
                                                  title: AppLocalizations.of(
                                                          context)
                                                      .translate('Bio'),
                                                  input:
                                                      state.userInfo.bio ?? '')
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
