import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/categories/entities/real_estate/real_estate.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:netzoon/presentation/categories/real_estate/blocs/real_estate/real_estate_bloc.dart';
import 'package:netzoon/presentation/chat/screens/chat_page_screen.dart';
import 'package:netzoon/presentation/core/helpers/connect_send_bird.dart';
import 'package:netzoon/presentation/core/helpers/show_image_dialog.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/on_failure_widget.dart';
import 'package:netzoon/presentation/core/widgets/phone_call_button.dart';
import 'package:netzoon/presentation/home/widgets/auth_alert.dart';

import '../../../core/blocs/country_bloc/country_bloc.dart';
import '../../../core/constant/colors.dart';
import '../../../core/helpers/get_currency_of_country.dart';
import '../../../core/helpers/share_image_function.dart';
import '../../../core/widgets/price_suggestion_button.dart';
import '../../../utils/app_localizations.dart';
import '../../widgets/image_free_zone_widget.dart';

class RealEstateDetailsScreen extends StatefulWidget {
  final String realEstateId;
  const RealEstateDetailsScreen({super.key, required this.realEstateId});

  @override
  State<RealEstateDetailsScreen> createState() =>
      _RealEstateDetailsScreenState();
}

class _RealEstateDetailsScreenState extends State<RealEstateDetailsScreen> {
  final TextEditingController input = TextEditingController();
  late final CountryBloc countryBloc;
  final authBloc = sl<AuthBloc>();
  final realEstateBloc = sl<RealEstateBloc>();
  @override
  void initState() {
    authBloc.add(AuthCheckRequested());
    countryBloc = BlocProvider.of<CountryBloc>(context);
    countryBloc.add(GetCountryEvent());
    realEstateBloc.add(GetRealEstateByIdEvent(id: widget.realEstateId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        isHome: false,
        widget: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<CountryBloc, CountryState>(
              bloc: countryBloc,
              builder: (context, state) {
                if (state is CountryInitial) {
                  return BlocBuilder<RealEstateBloc, RealEstateState>(
                    bloc: realEstateBloc,
                    builder: (context, realEstateState) {
                      if (realEstateState is GetRealEstateInProgress) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height - 170.h,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColor.backgroundColor,
                            ),
                          ),
                        );
                      } else if (realEstateState is GetRealEstateFailure) {
                        final failure = realEstateState.message;
                        return FailureWidget(
                            failure: failure,
                            onPressed: () {
                              realEstateBloc.add(GetRealEstateByIdEvent(
                                  id: widget.realEstateId));
                            });
                      } else if (realEstateState is GetRealEstateByIdSuccess) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 7,
                                    color: Colors.grey.withOpacity(0.4),
                                  ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl:
                                        realEstateState.realEstate.imageUrl,
                                    width: 700.w,
                                    height: 200.h,
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
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Text(
                                            //   '${widget.realEstate.price.toString()} \$',
                                            //   style: TextStyle(
                                            //       color: AppColor.colorOne,
                                            //       fontSize: 17.sp,
                                            //       fontWeight: FontWeight.bold),
                                            // ),
                                            RichText(
                                              text: TextSpan(
                                                  style: TextStyle(
                                                      fontSize: 18.sp,
                                                      color: AppColor
                                                          .backgroundColor),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          '${realEstateState.realEstate.price}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          getCurrencyFromCountry(
                                                        state.selectedCountry,
                                                        context,
                                                      ),
                                                      style: TextStyle(
                                                          color: AppColor
                                                              .backgroundColor,
                                                          fontSize: 14.sp),
                                                    )
                                                  ]),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                IconButton(
                                                  onPressed: () async {
                                                    await shareImageWithDescription(
                                                        imageUrl:
                                                            realEstateState
                                                                .realEstate
                                                                .imageUrl,
                                                        subject: realEstateState
                                                            .realEstate.title,
                                                        description:
                                                            'https://netzoon.com/home/real_estate/${realEstateState.realEstate.id}');
                                                  },
                                                  icon: Icon(
                                                    Icons.share,
                                                    color: AppColor
                                                        .backgroundColor,
                                                    size: 15.sp,
                                                  ),
                                                ),
                                                // const Icon(
                                                //   Icons.favorite_border,
                                                //   color: AppColor.backgroundColor,
                                                // ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 7.h,
                                        ),
                                        Text(
                                          realEstateState.realEstate.title,
                                          style: TextStyle(
                                            color: AppColor.black,
                                            fontSize: 22.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 7,
                                    color: Colors.grey.withOpacity(0.4),
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   AppLocalizations.of(context).translate('details'),
                                    //   style: TextStyle(
                                    //     color: AppColor.black,
                                    //     fontSize: 17.sp,
                                    //   ),
                                    // ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    titleAndInput(
                                      title: AppLocalizations.of(context)
                                          .translate('owner'),
                                      input: realEstateState
                                              .realEstate.createdBy.username ??
                                          '',
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    titleAndInput(
                                      title: AppLocalizations.of(context)
                                          .translate('area'),
                                      input: realEstateState.realEstate.area
                                          .toString(),
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    titleAndInput(
                                      title: AppLocalizations.of(context)
                                          .translate('Bathrooms'),
                                      input: realEstateState
                                          .realEstate.bathrooms
                                          .toString(),
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    titleAndInput(
                                      title: AppLocalizations.of(context)
                                          .translate('Bedrooms'),
                                      input: realEstateState.realEstate.bedrooms
                                          .toString(),
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    titleAndInput(
                                      title: AppLocalizations.of(context)
                                          .translate('address'),
                                      input:
                                          realEstateState.realEstate.location,
                                    ),

                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    realEstateState.realEstate.type != null
                                        ? titleAndInput(
                                            title: AppLocalizations.of(context)
                                                .translate('property_type'),
                                            input: AppLocalizations.of(context)
                                                .translate(realEstateState
                                                    .realEstate.type!),
                                          )
                                        : const SizedBox(),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    realEstateState.realEstate.category != null
                                        ? titleAndInput(
                                            title: AppLocalizations.of(context)
                                                .translate(
                                                    'residential_categories'),
                                            input: AppLocalizations.of(context)
                                                .translate(realEstateState
                                                    .realEstate.category!),
                                          )
                                        : const SizedBox(),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    realEstateState.realEstate.furnishing !=
                                            null
                                        ? titleAndInput(
                                            title: AppLocalizations.of(context)
                                                .translate('furnishing_type'),
                                            input: realEstateState.realEstate
                                                        .furnishing ==
                                                    true
                                                ? AppLocalizations.of(context)
                                                    .translate('furnished')
                                                : AppLocalizations.of(context)
                                                    .translate('unfurnished'),
                                          )
                                        : const SizedBox(),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    realEstateState.realEstate.forWhat != null
                                        ? titleAndInput(
                                            title: AppLocalizations.of(context)
                                                .translate('for_what'),
                                            input: AppLocalizations.of(context)
                                                .translate(realEstateState
                                                    .realEstate.forWhat!),
                                          )
                                        : const SizedBox(),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 7,
                                    color: Colors.grey.withOpacity(0.4),
                                  ),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)
                                        .translate('desc'),
                                    style: TextStyle(
                                      color: AppColor.black,
                                      fontSize: 17.sp,
                                    ),
                                  ),
                                  Text(
                                    realEstateState.realEstate.description,
                                    style: TextStyle(
                                      color: AppColor.mainGrey,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 7,
                                    color: Colors.grey.withOpacity(0.4),
                                  ),
                                ),
                              ),
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${AppLocalizations.of(context).translate('images')} :',
                                    style: TextStyle(
                                      color: AppColor.black,
                                      fontSize: 17.sp,
                                    ),
                                  ),
                                  realEstateState
                                              .realEstate.images?.isNotEmpty ==
                                          true
                                      ? SizedBox(
                                          height: 200.h,
                                          // width: 120,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              scrollDirection: Axis.horizontal,
                                              itemCount: realEstateState
                                                  .realEstate.images!.length,
                                              // gridDelegate:
                                              //     const SliverGridDelegateWithFixedCrossAxisCount(
                                              //         crossAxisCount: 2,
                                              //         childAspectRatio: 0.94),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    showImageDialog(
                                                        context,
                                                        realEstateState
                                                            .realEstate.images!,
                                                        index);
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.0),
                                                    child: ListOfPictures(
                                                      img: realEstateState
                                                          .realEstate
                                                          .images![index],
                                                    ),
                                                  ),
                                                );
                                              }),
                                        )
                                      : Text(
                                          AppLocalizations.of(context)
                                              .translate('no_images'),
                                          style: TextStyle(
                                            color: AppColor.mainGrey,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 140.h,
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
        ),
      ),
      bottomNavigationBar: BlocBuilder<RealEstateBloc, RealEstateState>(
        bloc: realEstateBloc,
        builder: (context, realEstateState) {
          return realEstateState is GetRealEstateByIdSuccess
              ? BottomAppBar(
                  height: 60.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PhoneCallWidget(
                          phonePath: realEstateState
                                  .realEstate.createdBy.firstMobile ??
                              '',
                          title:
                              AppLocalizations.of(context).translate('call')),
                      BlocBuilder<AuthBloc, AuthState>(
                        bloc: authBloc,
                        builder: (context, authState) {
                          return ElevatedButton(
                            onPressed: () {
                              if (authState is Authenticated) {
                                // await SendbirdChat.connect(
                                //     authState.user.userInfo
                                //             .username ??
                                //         '');
                                connectWithSendbird(
                                    username:
                                        authState.user.userInfo.username ?? '');
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return ChatPageScreen(
                                      userId:
                                          authState.user.userInfo.username ??
                                              '',
                                      otherUserId: realEstateState
                                              .realEstate.createdBy.username ??
                                          '',
                                      title: realEstateState
                                              .realEstate.createdBy.username ??
                                          '',
                                      image: realEstateState.realEstate
                                              .createdBy.profilePhoto ??
                                          '',
                                    );
                                  }),
                                );
                              } else {
                                authAlert(context);
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                AppColor.backgroundColor,
                              ),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              )),
                              fixedSize: MaterialStateProperty.all(
                                Size.fromWidth(100.w),
                              ),
                            ),
                            child: Text(
                                AppLocalizations.of(context).translate('chat')),
                          );
                        },
                      ),
                      // ElevatedButton(
                      //     onPressed: () {},
                      //     style: ButtonStyle(
                      //       backgroundColor: MaterialStateProperty.all(
                      //         AppColor.backgroundColor,
                      //       ),
                      //       shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(18.0),
                      //       )),
                      //       fixedSize: MaterialStatePropertyAll(
                      //         Size.fromWidth(100.w),
                      //       ),
                      //     ),
                      //     child: Text(AppLocalizations.of(context).translate('chat'))),
                      // PriceSuggestionButton(input: input),
                    ],
                  ),
                )
              : const SizedBox();
        },
      ),
    );
  }

  Container titleAndInput({
    required String title,
    required String input,
  }) {
    return Container(
      height: 40.h,
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
            Text(
              input,
              style: TextStyle(
                color: AppColor.mainGrey,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
