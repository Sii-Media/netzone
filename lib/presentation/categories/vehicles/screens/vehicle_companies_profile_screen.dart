import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/categories/vehicles/blocs/bloc/vehicle_bloc.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
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
      {super.key, required this.vehiclesCompany});
  final UserInfo vehiclesCompany;
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

  final userBloc = sl<GetUserBloc>();
  late final CountryBloc countryBloc;
  bool isFollowing = false;

  @override
  void initState() {
    bloc.add(GetCompanyVehiclesEvent(
        type: widget.vehiclesCompany.userType ?? '',
        id: widget.vehiclesCompany.id));
    authBloc.add(AuthCheckRequested());
    checkFollowStatus();
    countryBloc = BlocProvider.of<CountryBloc>(context);
    countryBloc.add(GetCountryEvent());
    visitorBloc.add(AddVisitorEvent(userId: widget.vehiclesCompany.id));

    super.initState();
  }

  void checkFollowStatus() async {
    bool followStatus = await isFollow(widget.vehiclesCompany.id);
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
          widget.vehiclesCompany.username ?? '',
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
                              imageUrl: widget.vehiclesCompany.coverPhoto ??
                                  'https://img.freepik.com/free-vector/hand-painted-watercolor-pastel-sky-background_23-2148902771.jpg?w=2000',
                              fit: BoxFit.contain,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Padding(
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
                                          widget.vehiclesCompany.profilePhoto ??
                                              '',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.fill,
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
                                              widget.vehiclesCompany.username ??
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
                                                                .vehiclesCompany
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
                                    widget.vehiclesCompany.slogn != null
                                        ? Text(
                                            widget.vehiclesCompany.slogn ?? '',
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
                                          '${widget.vehiclesCompany.averageRating}',
                                          style: const TextStyle(
                                              color: AppColor.secondGrey,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        GestureDetector(
                                          onTap: () => showRating(
                                              context,
                                              userBloc,
                                              widget.vehiclesCompany.id,
                                              widget.vehiclesCompany
                                                      .averageRating ??
                                                  0),
                                          child: RatingBar.builder(
                                            minRating: 1,
                                            maxRating: 5,
                                            initialRating: widget
                                                    .vehiclesCompany
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
                                          '(${widget.vehiclesCompany.totalRatings} ${AppLocalizations.of(context).translate('review')})',
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
                              widget.vehiclesCompany.bio ?? '',
                              style: const TextStyle(color: AppColor.mainGrey),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            // height: 50.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
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
                                            padding: const EdgeInsets.only(
                                                left: 4.0),
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .translate('Live Auction'),
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
                                      MaterialPageRoute(builder: (context) {
                                        return const ChatPageScreen();
                                      }),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
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
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Text(
                                                AppLocalizations.of(context)
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
                            AppLocalizations.of(context).translate(
                                widget.vehiclesCompany.userType ?? ''),
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
                            bloc.add(GetCompanyVehiclesEvent(
                                type: widget.vehiclesCompany.userType ?? '',
                                id: widget.vehiclesCompany.id));
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
                              } else if (state is GetCompanyVehiclesSuccess) {
                                return state.companyVehicles.isNotEmpty
                                    ? BlocBuilder<CountryBloc, CountryState>(
                                        bloc: countryBloc,
                                        builder: (context, countryState) {
                                          if (countryState is CountryInitial) {
                                            return DynamicHeightGridView(
                                                itemCount: state
                                                    .companyVehicles.length,
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 10,
                                                builder: (ctx, index) {
                                                  return VehicleWidget(
                                                    vehicle: state
                                                        .companyVehicles[index],
                                                    countryState: countryState,
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
                                                color:
                                                    AppColor.backgroundColor)),
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
                                        widget.vehiclesCompany.username ?? ''),
                                titleAndInput(
                                    title: AppLocalizations.of(context)
                                        .translate('desc'),
                                    input: widget.vehiclesCompany.description ??
                                        ''),
                                titleAndInput(
                                    title: AppLocalizations.of(context)
                                        .translate('Bio'),
                                    input: widget.vehiclesCompany.bio ?? ''),
                                // titleAndInput(
                                //     title: AppLocalizations.of(context)
                                //         .translate('mobile'),
                                //     input: widget.vehiclesCompany.firstMobile ??
                                //         ';'),
                                Padding(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)
                                                .translate('mobile'),
                                            style: TextStyle(
                                              color: AppColor.black,
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 190,
                                            child: PhoneCallWidget(
                                              phonePath: widget.vehiclesCompany
                                                      .firstMobile ??
                                                  "",
                                              title: widget.vehiclesCompany
                                                      .firstMobile ??
                                                  AppLocalizations.of(context)
                                                      .translate('call'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                titleAndInput(
                                    title: AppLocalizations.of(context)
                                        .translate('email'),
                                    input: widget.vehiclesCompany.email ?? ''),
                                titleAndInput(
                                    title: AppLocalizations.of(context)
                                        .translate('website'),
                                    input:
                                        widget.vehiclesCompany.website ?? ''),
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
