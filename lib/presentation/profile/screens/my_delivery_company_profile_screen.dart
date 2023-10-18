import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/profile/screens/visitors_screen.dart';

import '../../../injection_container.dart';
import '../../categories/delivery_company/blocs/delivery_service/delivery_service_bloc.dart';
import '../../chat/screens/chat_home_screen.dart';
import '../../core/blocs/country_bloc/country_bloc.dart';
import '../../core/constant/colors.dart';
import '../../core/helpers/get_currency_of_country.dart';
import '../../core/widgets/screen_loader.dart';
import '../../home/test.dart';
import '../../utils/app_localizations.dart';
import '../blocs/add_account/add_account_bloc.dart';
import '../blocs/get_user/get_user_bloc.dart';
import '../methods/show_change_account_bottom_sheet.dart';
import '../widgets/rounded_icon_text.dart';
import 'credits_screen.dart';
import 'edit_profile_screen.dart';
import 'followings_list_screen.dart';

class MyDeliveryCompanyProfileScreen extends StatefulWidget {
  final String userId;
  const MyDeliveryCompanyProfileScreen({super.key, required this.userId});

  @override
  State<MyDeliveryCompanyProfileScreen> createState() =>
      _MyDeliveryCompanyProfileScreenState();
}

class _MyDeliveryCompanyProfileScreenState
    extends State<MyDeliveryCompanyProfileScreen>
    with
        TickerProviderStateMixin,
        ScreenLoader<MyDeliveryCompanyProfileScreen> {
  final double coverHeight = 240.h;
  final double profileHeight = 104.h;
  final userBloc = sl<GetUserBloc>();
  final getAccountsBloc = sl<AddAccountBloc>();
  final deliveryBloc = sl<DeliveryServiceBloc>();
  late final CountryBloc countryBloc;

  @override
  void initState() {
    userBloc.add(GetUserByIdEvent(userId: widget.userId));
    deliveryBloc.add(GetDeliveryCompanyServicesEvent(id: widget.userId));
    countryBloc = BlocProvider.of<CountryBloc>(context);
    countryBloc.add(GetCountryEvent());
    super.initState();
  }

  Stack buildTop(double top, String coverUrl, String profileUrl) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: profileHeight / 2),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              // color: AppColor.backgroundColor,
              image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    coverUrl,
                  ),
                  fit: BoxFit.fitWidth),
            ),
          ),
        ),
        Positioned(
          top: top,
          child: CircleAvatar(
            radius: profileHeight / 2,
            backgroundColor: Colors.grey.shade800,
            backgroundImage: CachedNetworkImageProvider(profileUrl),
          ),
        ),
      ],
    );
  }

  Widget accountWidget(
      {required GetUserAccountsSuccess accountstate,
      required int index,
      void Function()? onTap,
      required void Function(int?)? onChanged}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                color: AppColor.backgroundColor,
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      accountstate.users[index].profilePhoto ??
                          'https://pbs.twimg.com/media/FjU2lkcWYAgNG6d.jpg',
                    ),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(100)),
          ),
          SizedBox(
            width: 10.w,
          ),
          Text(
            accountstate.users[index].username ?? '',
            style: const TextStyle(
                color: AppColor.white,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Radio<int>(
            value: 1,
            groupValue: 0,
            onChanged: onChanged,
            activeColor: AppColor.white,
          ),
        ],
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
    final TabController tabController = TabController(length: 2, vsync: this);
    final top = 80.h;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          userBloc.add(GetUserByIdEvent(userId: widget.userId));
        },
        color: AppColor.white,
        backgroundColor: AppColor.backgroundColor,
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
              return BlocListener<AddAccountBloc, AddAccountState>(
                bloc: getAccountsBloc,
                listener: (context, changeAccountstate) {
                  if (changeAccountstate is OnChangeAccountInProgress) {
                    startLoading();
                  } else if (changeAccountstate is OnChangeAccountFailure) {
                    stopLoading();

                    final failure = changeAccountstate.message;
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
                  } else if (changeAccountstate is OnChangeAccountSuccess) {
                    stopLoading();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        AppLocalizations.of(context).translate('success'),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ));
                    Navigator.of(context, rootNavigator: true)
                        .pushAndRemoveUntil(
                            CupertinoPageRoute(builder: (context) {
                      return const TestScreen();
                    }), (route) => false);
                  }
                },
                child: DefaultTabController(
                  length: 2,
                  child: NestedScrollView(
                    headerSliverBuilder: (context, _) {
                      return [
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Column(
                                children: [
                                  buildTop(top, state.userInfo.coverPhoto ?? '',
                                      state.userInfo.profilePhoto ?? ''),
                                  changeAccountText(
                                      context: context,
                                      state: state,
                                      getAccountsBloc: getAccountsBloc),
                                  const Divider(),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            roundedIconText(
                                              context: context,
                                              text: 'current requests',
                                              icon: Icons.request_page,
                                            ),
                                            roundedIconText(
                                              context: context,
                                              text: 'recovered_requests',
                                              icon: Icons.reset_tv_rounded,
                                            ),
                                            roundedIconText(
                                              context: context,
                                              text: 'done',
                                              icon: Icons.done_all,
                                            ),
                                            roundedIconText(
                                              context: context,
                                              text: 'tracking',
                                              icon: Icons.track_changes,
                                            ),
                                            // roundedIconText(
                                            //     context: context,
                                            //     text: 'chat',
                                            //     icon: Icons.chat,
                                            //     onTap: () {
                                            //       Navigator.of(context).push(
                                            //           MaterialPageRoute(
                                            //               builder: (context) {
                                            //         return const ChatHomeScreen();
                                            //       }));
                                            //     }),
                                            // roundedIconText(
                                            //     context: context,
                                            //     text: 'edit_profile',
                                            //     icon: Icons.edit,
                                            //     onTap: () {
                                            //       // Navigator.of(context).push(
                                            //       //     MaterialPageRoute(
                                            //       //         builder: (context) {
                                            //       //   return EditLocalCompanyprofileScreen(
                                            //       //       userInfo: state.userInfo);
                                            //       // }));
                                            //     }),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            roundedIconText(
                                                context: context,
                                                text: 'chat',
                                                icon: Icons.chat,
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return const ChatHomeScreen();
                                                  }));
                                                }),
                                            roundedIconText(
                                                context: context,
                                                text: 'NetZoon Credits',
                                                icon: Icons.wallet_outlined,
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return const CreditScreen();
                                                  }));
                                                }),
                                            roundedIconText(
                                                context: context,
                                                text: 'edit_profile',
                                                icon: Icons.edit,
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return EditProfileScreen(
                                                        userInfo:
                                                            state.userInfo);
                                                  }));
                                                }),
                                          ],
                                        ),
                                      ],
                                    ),
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
                                              return const FollowingsListScreen(
                                                type: 'followings',
                                                who: 'me',
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
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                AppLocalizations.of(context)
                                                    .translate('Followings'),
                                                style: TextStyle(
                                                    color: AppColor.secondGrey,
                                                    fontSize: 15.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return const FollowingsListScreen(
                                                type: 'followers',
                                                who: 'me',
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
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                AppLocalizations.of(context)
                                                    .translate('Followers'),
                                                style: TextStyle(
                                                    color: AppColor.secondGrey,
                                                    fontSize: 15.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return const VisitorsScreen();
                                            }));
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${state.userInfo.profileViews ?? 0}',
                                                style: TextStyle(
                                                  color: AppColor.mainGrey,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                AppLocalizations.of(context)
                                                    .translate('visitors'),
                                                style: TextStyle(
                                                    color: AppColor.secondGrey,
                                                    fontSize: 15.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    color: AppColor.secondGrey,
                                    thickness: 0.2,
                                    indent: 30,
                                    endIndent: 30,
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
                          labelColor: AppColor.backgroundColor,
                          unselectedLabelColor: AppColor.secondGrey,
                          // isScrollable: true,

                          tabs: [
                            Tab(
                              text: AppLocalizations.of(context)
                                  .translate('about_us'),
                            ),
                            Tab(
                              text: AppLocalizations.of(context)
                                  .translate('services'),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: tabController,
                            children: [
                              RefreshIndicator(
                                onRefresh: () async {
                                  userBloc.add(
                                      GetUserByIdEvent(userId: widget.userId));
                                },
                                color: AppColor.white,
                                backgroundColor: AppColor.backgroundColor,
                                child: ListView(
                                  children: [
                                    Column(
                                      children: [
                                        titleAndInput(
                                            title: AppLocalizations.of(context)
                                                .translate('company_name'),
                                            input:
                                                state.userInfo.username ?? ''),
                                        titleAndInput(
                                            title: AppLocalizations.of(context)
                                                .translate('email'),
                                            input: state.userInfo.email ?? ''),
                                        titleAndInput(
                                            title: AppLocalizations.of(context)
                                                .translate('mobile'),
                                            input: state.userInfo.firstMobile ??
                                                ''),
                                        state.userInfo.bio != null &&
                                                state.userInfo.bio != ''
                                            ? titleAndInput(
                                                title:
                                                    AppLocalizations.of(context)
                                                        .translate('Bio'),
                                                input: state.userInfo.bio ?? '')
                                            : const SizedBox(),
                                        state.userInfo.description != null &&
                                                state.userInfo.description != ''
                                            ? titleAndInput(
                                                title:
                                                    AppLocalizations.of(context)
                                                        .translate('desc'),
                                                input: state
                                                        .userInfo.description ??
                                                    '')
                                            : const SizedBox(),
                                        state.userInfo.address != null &&
                                                state.userInfo.address != ''
                                            ? titleAndInput(
                                                title:
                                                    AppLocalizations.of(context)
                                                        .translate('address'),
                                                input: state.userInfo.address ??
                                                    '')
                                            : const SizedBox(),
                                        state.userInfo.website != null &&
                                                state.userInfo.website != ''
                                            ? titleAndInput(
                                                title:
                                                    AppLocalizations.of(context)
                                                        .translate('website'),
                                                input: state.userInfo.website ??
                                                    '')
                                            : const SizedBox(),
                                        titleAndInput(
                                            title: AppLocalizations.of(context)
                                                .translate('delivery_type'),
                                            input:
                                                state.userInfo.deliveryType ??
                                                    ''),
                                        titleAndInput(
                                            title: AppLocalizations.of(context)
                                                .translate('deliveryCarsNum'),
                                            input: state
                                                .userInfo.deliveryCarsNum
                                                .toString()),
                                        titleAndInput(
                                            title: AppLocalizations.of(context)
                                                .translate('deliveryMotorsNum'),
                                            input: state
                                                .userInfo.deliveryMotorsNum
                                                .toString()),
                                        titleAndInput(
                                            title: AppLocalizations.of(context)
                                                .translate(
                                                    'is_there_food_delivery'),
                                            input: state.userInfo
                                                        .isThereFoodsDelivery ==
                                                    true
                                                ? 'yes'
                                                : 'no'),
                                        titleAndInput(
                                            title: AppLocalizations.of(context)
                                                .translate(
                                                    'is_there_warehouse'),
                                            input: state.userInfo
                                                        .isThereWarehouse ==
                                                    true
                                                ? 'yes'
                                                : 'no'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              RefreshIndicator(
                                onRefresh: () async {
                                  deliveryBloc.add(
                                      GetDeliveryCompanyServicesEvent(
                                          id: widget.userId));
                                },
                                color: AppColor.white,
                                backgroundColor: AppColor.backgroundColor,
                                child: BlocBuilder<DeliveryServiceBloc,
                                    DeliveryServiceState>(
                                  bloc: deliveryBloc,
                                  builder: (context, sstate) {
                                    if (sstate is DeliveryServiceInProgress) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColor.backgroundColor,
                                        ),
                                      );
                                    } else if (sstate
                                        is DeliveryServiceFailure) {
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
                                        is GetDeliveryCompanyServicesSuccess) {
                                      return BlocBuilder<CountryBloc,
                                          CountryState>(
                                        bloc: countryBloc,
                                        builder: (context, countryState) {
                                          if (countryState is CountryInitial) {
                                            return ListView.builder(
                                              itemCount: sstate.services.length,
                                              shrinkWrap: true,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return Card(
                                                  elevation: 3,
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          sstate.services[index]
                                                              .title,
                                                          style: TextStyle(
                                                              fontSize: 18.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppColor
                                                                  .backgroundColor),
                                                        ),
                                                        SizedBox(height: 8.h),
                                                        Text(
                                                          sstate.services[index]
                                                              .description,
                                                          style: TextStyle(
                                                              fontSize: 16.sp,
                                                              color: AppColor
                                                                  .secondGrey),
                                                        ),
                                                        SizedBox(height: 8.h),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'From: ${sstate.services[index].from}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.sp,
                                                                  color: AppColor
                                                                      .colorOne),
                                                            ),
                                                            Text(
                                                              'To: ${sstate.services[index].to}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.sp,
                                                                  color: AppColor
                                                                      .colorOne),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 8.h),
                                                        RichText(
                                                          text: TextSpan(
                                                              style: const TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: AppColor
                                                                      .black),
                                                              children: <TextSpan>[
                                                                TextSpan(
                                                                  text:
                                                                      '${sstate.services[index].price}',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      getCurrencyFromCountry(
                                                                    countryState
                                                                        .selectedCountry,
                                                                    context,
                                                                  ),
                                                                  style: const TextStyle(
                                                                      color: AppColor
                                                                          .backgroundColor,
                                                                      fontSize:
                                                                          10),
                                                                )
                                                              ]),
                                                        ),
                                                      ],
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
            return Container();
          },
        ),
      ),
    );
  }
}
