import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/core/constants/constants.dart';
import '../../../../data/models/auth/user/user_model.dart';
import '../../../../injection_container.dart';
import '../../../auth/blocs/auth_bloc/auth_bloc.dart';
import '../../../core/blocs/country_bloc/country_bloc.dart';
import '../../../core/constant/colors.dart';
import '../../../core/helpers/get_currency_of_country.dart';
import '../../../core/widgets/screen_loader.dart';
import '../../../profile/blocs/get_user/get_user_bloc.dart';
import '../../../utils/app_localizations.dart';
import '../../widgets/build_rating.dart';
import '../blocs/delivery_service/delivery_service_bloc.dart';

class DeliveryCompanyProfileScreen extends StatefulWidget {
  final UserInfo deliveryCompany;
  const DeliveryCompanyProfileScreen(
      {super.key, required this.deliveryCompany});

  @override
  State<DeliveryCompanyProfileScreen> createState() =>
      _DeliveryCompanyProfileScreenState();
}

class _DeliveryCompanyProfileScreenState
    extends State<DeliveryCompanyProfileScreen>
    with ScreenLoader<DeliveryCompanyProfileScreen> {
  final authBloc = sl<AuthBloc>();
  final userBloc = sl<GetUserBloc>();
  final deliveryBloc = sl<DeliveryServiceBloc>();
  late final CountryBloc countryBloc;
  bool isFollowing = false;

  @override
  void initState() {
    authBloc.add(AuthCheckRequested());
    checkFollowStatus();
    countryBloc = BlocProvider.of<CountryBloc>(context);
    countryBloc.add(GetCountryEvent());
    deliveryBloc
        .add(GetDeliveryCompanyServicesEvent(id: widget.deliveryCompany.id));
    super.initState();
  }

  void checkFollowStatus() async {
    bool followStatus = await isFollow(widget.deliveryCompany.id);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.deliveryCompany.username ?? '',
          style: const TextStyle(color: AppColor.backgroundColor),
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
        child: DefaultTabController(
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
                            height: 160.h,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: AppColor.secondGrey.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: widget.deliveryCompany.coverPhoto ??
                                  'https://img.freepik.com/free-vector/hand-painted-watercolor-pastel-sky-background_23-2148902771.jpg?w=2000',
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          widget.deliveryCompany.profilePhoto ??
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          133.w,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              widget.deliveryCompany.username ??
                                                  '',
                                              style: TextStyle(
                                                color: AppColor.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15.w,
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
                                                                .deliveryCompany
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
                                    widget.deliveryCompany.slogn != null
                                        ? Text(
                                            widget.deliveryCompany.slogn ?? '',
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
                                          '${widget.deliveryCompany.averageRating}',
                                          style: const TextStyle(
                                              color: AppColor.secondGrey,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        GestureDetector(
                                          onTap: () => showRating(
                                              context,
                                              userBloc,
                                              widget.deliveryCompany.id,
                                              widget.deliveryCompany
                                                      .averageRating ??
                                                  0),
                                          child: RatingBar.builder(
                                            minRating: 1,
                                            maxRating: 5,
                                            initialRating: widget
                                                    .deliveryCompany
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
                                          '(${widget.deliveryCompany.totalRatings} ${AppLocalizations.of(context).translate('review')})',
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
                            height: 14.h,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              widget.deliveryCompany.bio ?? '',
                              style: const TextStyle(color: AppColor.mainGrey),
                            ),
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
                            AppLocalizations.of(context).translate('services'),
                          ),
                        ),
                        Tab(
                          icon: Text(AppLocalizations.of(context)
                              .translate('about_us')),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        RefreshIndicator(
                          onRefresh: () async {
                            deliveryBloc.add(GetDeliveryCompanyServicesEvent(
                                id: widget.deliveryCompany.id));
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
                              } else if (sstate is DeliveryServiceFailure) {
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
                                return BlocBuilder<CountryBloc, CountryState>(
                                  bloc: countryBloc,
                                  builder: (context, countryState) {
                                    if (countryState is CountryInitial) {
                                      return ListView.builder(
                                        itemCount: sstate.services.length,
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Card(
                                            elevation: 3,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    sstate
                                                        .services[index].title,
                                                    style: TextStyle(
                                                        fontSize: 18.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                            fontSize: 16.sp,
                                                            color: AppColor
                                                                .colorOne),
                                                      ),
                                                      Text(
                                                        'To: ${sstate.services[index].to}',
                                                        style: TextStyle(
                                                            fontSize: 16.sp,
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
                                                                FontWeight.bold,
                                                            color:
                                                                AppColor.black),
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
                                                                fontSize: 10),
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
                        ListView(
                          children: [
                            Column(
                              children: [
                                titleAndInput(
                                    title: AppLocalizations.of(context)
                                        .translate('company_name'),
                                    input:
                                        widget.deliveryCompany.username ?? ''),
                                titleAndInput(
                                    title: AppLocalizations.of(context)
                                        .translate('desc'),
                                    input: widget.deliveryCompany.description ??
                                        ''),
                                titleAndInput(
                                    title: AppLocalizations.of(context)
                                        .translate('Bio'),
                                    input: widget.deliveryCompany.bio ?? ''),
                                titleAndInput(
                                    title: AppLocalizations.of(context)
                                        .translate('mobile'),
                                    input: widget.deliveryCompany.firstMobile ??
                                        ';'),
                                titleAndInput(
                                    title: AppLocalizations.of(context)
                                        .translate('email'),
                                    input: widget.deliveryCompany.email ?? ''),
                                titleAndInput(
                                    title: AppLocalizations.of(context)
                                        .translate('website'),
                                    input:
                                        widget.deliveryCompany.website ?? ''),
                                titleAndInput(
                                    title: AppLocalizations.of(context)
                                        .translate('delivery_type'),
                                    input:
                                        widget.deliveryCompany.deliveryType ??
                                            ''),
                                titleAndInput(
                                    title: AppLocalizations.of(context)
                                        .translate('deliveryCarsNum'),
                                    input: widget
                                        .deliveryCompany.deliveryCarsNum
                                        .toString()),
                                titleAndInput(
                                    title: AppLocalizations.of(context)
                                        .translate('deliveryMotorsNum'),
                                    input: widget
                                        .deliveryCompany.deliveryMotorsNum
                                        .toString()),
                                titleAndInput(
                                    title: AppLocalizations.of(context)
                                        .translate('is_there_food_delivery'),
                                    input: widget.deliveryCompany
                                                .isThereFoodsDelivery ==
                                            true
                                        ? 'yes'
                                        : 'no'),
                                titleAndInput(
                                    title: AppLocalizations.of(context)
                                        .translate('is_there_warehouse'),
                                    input: widget.deliveryCompany
                                                .isThereWarehouse ==
                                            true
                                        ? 'yes'
                                        : 'no'),
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
          ),
        ),
      ),
    );
  }
}
