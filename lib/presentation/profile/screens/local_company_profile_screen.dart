import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/categories/local_company/local_company_bloc/local_company_bloc.dart';
import 'package:netzoon/presentation/chat/screens/chat_home_screen.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/screen/product_details_screen.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:netzoon/presentation/orders/screens/manage_order_screen.dart';
import 'package:netzoon/presentation/profile/screens/visitors_screen.dart';

import '../../../injection_container.dart';
import '../../categories/local_company/company_service_detail_screen.dart';
import '../../core/blocs/country_bloc/country_bloc.dart';
import '../../core/helpers/get_currency_of_country.dart';
import '../../core/widgets/on_failure_widget.dart';
import '../../home/test.dart';
import '../../orders/screens/order_screen.dart';
import '../../utils/app_localizations.dart';
import '../blocs/add_account/add_account_bloc.dart';
import '../blocs/get_user/get_user_bloc.dart';
import '../methods/show_change_account_bottom_sheet.dart';
import '../widgets/rounded_icon_text.dart';
import 'credits_screen.dart';
import 'edit_local_company_profile_screen.dart';
import 'followings_list_screen.dart';

class MyLocalCompanyProfileScreen extends StatefulWidget {
  final String userId;
  const MyLocalCompanyProfileScreen({super.key, required this.userId});

  @override
  State<MyLocalCompanyProfileScreen> createState() =>
      _MyLocalCompanyProfileScreenState();
}

class _MyLocalCompanyProfileScreenState
    extends State<MyLocalCompanyProfileScreen>
    with TickerProviderStateMixin, ScreenLoader<MyLocalCompanyProfileScreen> {
  final double coverHeight = 240.h;
  final double profileHeight = 104.h;
  final userBloc = sl<GetUserBloc>();
  final productBloc = sl<GetUserBloc>();
  final getAccountsBloc = sl<AddAccountBloc>();
  final serviceBloc = sl<LocalCompanyBloc>();

  late final CountryBloc countryBloc;
  @override
  void initState() {
    userBloc.add(GetUserByIdEvent(userId: widget.userId));
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
            height: 40.r,
            width: 40.r,
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
            style: TextStyle(
                color: AppColor.white,
                fontSize: 16.sp,
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
            // productBloc.add(GetUserProductsEvent());
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
                // return Center(
                //   child: Text(
                //     failure,
                //     style: const TextStyle(
                //       color: Colors.red,
                //     ),
                //   ),
                // );
                return FailureWidget(
                  failure: failure,
                  onPressed: () {
                    userBloc.add(GetUserByIdEvent(userId: widget.userId));
                  },
                );
              } else if (state is GetUserSuccess) {
                if (state.userInfo.isService == true) {
                  serviceBloc.add(GetCompanyServicesEvent());
                } else {
                  productBloc.add(GetUserProductsEvent());
                }
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
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
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
                                    buildTop(
                                        top,
                                        state.userInfo.coverPhoto ?? '',
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
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              state.userInfo.isService ==
                                                          false ||
                                                      state.userInfo.isService ==
                                                          null
                                                  ? roundedIconText(
                                                      context: context,
                                                      text: state.userInfo
                                                                      .isService ==
                                                                  false ||
                                                              state.userInfo
                                                                      .isService ==
                                                                  null
                                                          ? 'manage_orders'
                                                          : 'my_services',
                                                      icon: Icons
                                                          .production_quantity_limits,
                                                      onTap: () {
                                                        if (state.userInfo
                                                                    .isService ==
                                                                false ||
                                                            state.userInfo
                                                                    .isService ==
                                                                null) {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                            return const ManageOrdersScreen();
                                                          }));
                                                        }
                                                      })
                                                  : const SizedBox(),
                                              roundedIconText(
                                                context: context,
                                                text: state.userInfo
                                                                .isService ==
                                                            false ||
                                                        state.userInfo
                                                                .isService ==
                                                            null
                                                    ? 'Recovered products'
                                                    : 'popular',
                                                icon: Icons.reset_tv_rounded,
                                              ),
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
                                                  text: 'Orders',
                                                  icon: Icons
                                                      .wallet_giftcard_outlined,
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return const OrdersScreen();
                                                    }));
                                                  }),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              roundedIconText(
                                                  context: context,
                                                  text: 'edit_profile',
                                                  icon: Icons.edit,
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return EditLocalCompanyprofileScreen(
                                                          userInfo:
                                                              state.userInfo);
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
                                                      return CreditScreen(
                                                        user: state.userInfo,
                                                      );
                                                    }));
                                                  }),
                                            ],
                                          )
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
                                                      color:
                                                          AppColor.secondGrey,
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
                                                      color:
                                                          AppColor.secondGrey,
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
                                                      color:
                                                          AppColor.secondGrey,
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
                                text: state.userInfo.isService == false ||
                                        state.userInfo.isService == null
                                    ? AppLocalizations.of(context)
                                        .translate('Products')
                                    : AppLocalizations.of(context)
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
                                    userBloc.add(GetUserByIdEvent(
                                        userId: widget.userId));
                                    // productBloc.add(GetUserProductsEvent());
                                  },
                                  color: AppColor.white,
                                  backgroundColor: AppColor.backgroundColor,
                                  child: ListView(
                                    children: [
                                      Column(
                                        children: [
                                          titleAndInput(
                                              title: AppLocalizations.of(
                                                      context)
                                                  .translate('company_name'),
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
                                          state.userInfo.bio != null &&
                                                  state.userInfo.bio != ''
                                              ? titleAndInput(
                                                  title: AppLocalizations.of(
                                                          context)
                                                      .translate('Bio'),
                                                  input:
                                                      state.userInfo.bio ?? '')
                                              : const SizedBox(),
                                          state.userInfo.description != null &&
                                                  state.userInfo.description !=
                                                      ''
                                              ? titleAndInput(
                                                  title: AppLocalizations.of(
                                                          context)
                                                      .translate('desc'),
                                                  input: state.userInfo
                                                          .description ??
                                                      '')
                                              : const SizedBox(),
                                          state.userInfo.address != null &&
                                                  state.userInfo.address != ''
                                              ? titleAndInput(
                                                  title: AppLocalizations.of(
                                                          context)
                                                      .translate('address'),
                                                  input:
                                                      state.userInfo.address ??
                                                          '')
                                              : const SizedBox(),
                                          state.userInfo.website != null &&
                                                  state.userInfo.website != ''
                                              ? titleAndInput(
                                                  title: AppLocalizations.of(
                                                          context)
                                                      .translate('website'),
                                                  input:
                                                      state.userInfo.website ??
                                                          '')
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
                                          SizedBox(
                                            height: 80.h,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                state.userInfo.isService == false ||
                                        state.userInfo.isService == null
                                    ? BlocBuilder<CountryBloc, CountryState>(
                                        bloc: countryBloc,
                                        builder: (context, countryState) {
                                          return ProductsListWidget(
                                            productBloc: productBloc,
                                            selectedCountry:
                                                countryState.selectedCountry,
                                          );
                                        },
                                      )
                                    : RefreshIndicator(
                                        onRefresh: () async {
                                          serviceBloc
                                              .add(GetCompanyServicesEvent());
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
                                                    return Column(
                                                      children: [
                                                        Expanded(
                                                          // child:
                                                          //     ListView.builder(
                                                          //   shrinkWrap: true,
                                                          //   physics:
                                                          //       const BouncingScrollPhysics(),
                                                          //   itemCount:
                                                          //       serviceState
                                                          //           .services
                                                          //           .length,
                                                          //   itemBuilder:
                                                          //       (context,
                                                          //           index) {
                                                          //     String
                                                          //         fullDescription =
                                                          //         serviceState
                                                          //             .services[
                                                          //                 index]
                                                          //             .description;
                                                          //     String first =
                                                          //         fullDescription
                                                          //             .substring(
                                                          //                 0,
                                                          //                 100);
                                                          //     String seconde =
                                                          //         fullDescription
                                                          //             .substring(
                                                          //                 100);
                                                          //     return Card(
                                                          //       elevation: 3,
                                                          //       margin: const EdgeInsets
                                                          //               .symmetric(
                                                          //           horizontal:
                                                          //               16,
                                                          //           vertical:
                                                          //               8),
                                                          //       shape:
                                                          //           RoundedRectangleBorder(
                                                          //         borderRadius:
                                                          //             BorderRadius
                                                          //                 .circular(
                                                          //                     12),
                                                          //       ),
                                                          //       child: Padding(
                                                          //         padding:
                                                          //             const EdgeInsets
                                                          //                 .all(16),
                                                          //         child: Column(
                                                          //           crossAxisAlignment:
                                                          //               CrossAxisAlignment
                                                          //                   .start,
                                                          //           children: [
                                                          //             Text(
                                                          //               serviceState
                                                          //                   .services[index]
                                                          //                   .title,
                                                          //               style: TextStyle(
                                                          //                   fontSize:
                                                          //                       18.sp,
                                                          //                   fontWeight: FontWeight.bold,
                                                          //                   color: AppColor.backgroundColor),
                                                          //             ),
                                                          //             SizedBox(
                                                          //                 height:
                                                          //                     8.h),
                                                          //             ExpansionTile(
                                                          //               title:
                                                          //                   Text(
                                                          //                 first,
                                                          //                 maxLines:
                                                          //                     3,
                                                          //                 // overflow:
                                                          //                 //     TextOverflow.ellipsis,
                                                          //                 style: TextStyle(
                                                          //                     fontSize: 16.sp,
                                                          //                     color: AppColor.secondGrey),
                                                          //               ),
                                                          //               children: <
                                                          //                   Widget>[
                                                          //                 // The widget displayed when the tile expands
                                                          //                 Text(
                                                          //                   seconde,
                                                          //                   style:
                                                          //                       TextStyle(
                                                          //                     fontSize: 16.sp,
                                                          //                     color: AppColor.secondGrey,
                                                          //                   ),
                                                          //                 ),
                                                          //               ],
                                                          //             ),
                                                          //             SizedBox(
                                                          //                 height:
                                                          //                     8.h),
                                                          //             RichText(
                                                          //               text: TextSpan(
                                                          //                   style: const TextStyle(
                                                          //                       fontSize: 16,
                                                          //                       fontWeight: FontWeight.bold,
                                                          //                       color: AppColor.black),
                                                          //                   children: <TextSpan>[
                                                          //                     TextSpan(
                                                          //                       text: '${serviceState.services[index].price}',
                                                          //                       style: const TextStyle(
                                                          //                         fontWeight: FontWeight.w700,
                                                          //                       ),
                                                          //                     ),
                                                          //                     TextSpan(
                                                          //                       text: getCurrencyFromCountry(
                                                          //                         countryState.selectedCountry,
                                                          //                         context,
                                                          //                       ),
                                                          //                       style: const TextStyle(color: AppColor.backgroundColor, fontSize: 10),
                                                          //                     )
                                                          //                   ]),
                                                          //             ),
                                                          //           ],
                                                          //         ),
                                                          //       ),
                                                          //     );
                                                          //   },
                                                          // ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: GridView
                                                                .builder(
                                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                  crossAxisCount:
                                                                      2,
                                                                  childAspectRatio:
                                                                      0.79.h,
                                                                  crossAxisSpacing:
                                                                      10.w,
                                                                  mainAxisSpacing:
                                                                      10.h),
                                                              shrinkWrap: true,
                                                              physics:
                                                                  const BouncingScrollPhysics(),
                                                              itemCount:
                                                                  serviceState
                                                                      .services
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return Container(
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
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                            Radius.circular(20)),
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .push(
                                                                          MaterialPageRoute(
                                                                            builder:
                                                                                (context) {
                                                                              return CompanyServiceDetailsScreen(companyService: serviceState.services[index]);
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
                                                                            imageUrl:
                                                                                serviceState.services[index].imageUrl ?? '',
                                                                            height:
                                                                                120.h,
                                                                            width:
                                                                                200.w,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                                                Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 50),
                                                                              child: CircularProgressIndicator(
                                                                                value: downloadProgress.progress,
                                                                                color: AppColor.backgroundColor,

                                                                                // strokeWidth: 10,
                                                                              ),
                                                                            ),
                                                                            errorWidget: (context, url, error) =>
                                                                                const Icon(Icons.error),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                right: 9.0,
                                                                                left: 9.0,
                                                                                bottom: 8.0),
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  serviceState.services[index].title,
                                                                                  style: const TextStyle(
                                                                                    color: AppColor.backgroundColor,
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
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 80.h,
                                                        ),
                                                      ],
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
          )),
    );
  }
}

class ProductsListWidget extends StatelessWidget {
  const ProductsListWidget({
    super.key,
    required this.productBloc,
    required this.selectedCountry,
  });

  final GetUserBloc productBloc;
  final String selectedCountry;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        productBloc.add(GetUserProductsEvent());
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
          } else if (state is GetUserProductsFailure) {
            final failure = state.message;
            return Center(
              child: Text(
                failure,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            );
          } else if (state is GetUserProductsSuccess) {
            return state.products.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 0.74,
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
                                        color: AppColor.secondGrey
                                            .withOpacity(0.5),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return ProductDetailScreen(
                                            item: state.products[index].id);
                                      }));
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl:
                                              state.products[index].imageUrl,
                                          height: 65.h,
                                          width: 160.w,
                                          fit: BoxFit.contain,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
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
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 9.0,
                                              left: 9.0,
                                              bottom: 2.0),
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
                                        RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                  fontSize: 10.sp,
                                                  color:
                                                      AppColor.backgroundColor),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text:
                                                      '${state.products[index].price}',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: AppColor.colorTwo),
                                                ),
                                                TextSpan(
                                                  text: getCurrencyFromCountry(
                                                    selectedCountry,
                                                    context,
                                                  ),
                                                  style: TextStyle(
                                                      color: AppColor.colorTwo,
                                                      fontSize: 10.sp),
                                                )
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 90.h,
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Text(
                        AppLocalizations.of(context).translate('no_items'),
                        style:
                            const TextStyle(color: AppColor.backgroundColor)),
                  );
          }
          return Container();
        },
      ),
    );
  }
}
  // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     Column(
                        //       children: [
                        //         Text(
                        //           '100',
                        //           style: TextStyle(
                        //             color: AppColor.black,
                        //             fontWeight: FontWeight.w700,
                        //             fontSize: 18.sp,
                        //           ),
                        //         ),
                        //         Text(
                        //           'Following',
                        //           style: TextStyle(
                        //             color: AppColor.mainGrey,
                        //             // fontWeight: FontWeight.w700,
                        //             fontSize: 14.sp,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //     Column(
                        //       children: [
                        //         Text(
                        //           '200',
                        //           style: TextStyle(
                        //             color: AppColor.black,
                        //             fontWeight: FontWeight.w700,
                        //             fontSize: 18.sp,
                        //           ),
                        //         ),
                        //         Text(
                        //           'Followers',
                        //           style: TextStyle(
                        //             color: AppColor.mainGrey,
                        //             // fontWeight: FontWeight.w700,
                        //             fontSize: 14.sp,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //     Column(
                        //       children: [
                        //         Text(
                        //           state.userInfo.products!.length.toString(),
                        //           style: TextStyle(
                        //             color: AppColor.black,
                        //             fontWeight: FontWeight.w700,
                        //             fontSize: 18.sp,
                        //           ),
                        //         ),
                        //         Text(
                        //           'Products',
                        //           style: TextStyle(
                        //             color: AppColor.mainGrey,
                        //             // fontWeight: FontWeight.w700,
                        //             fontSize: 14.sp,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(
                        //   height: 10.h,
                        // ),