import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/presentation/advertising/blocs/ads/ads_bloc_bloc.dart';
import 'package:netzoon/presentation/categories/real_estate/screens/real_estate_details_screen.dart';
import 'package:netzoon/presentation/categories/vehicles/screens/vehicle_companies_profile_screen.dart';
import 'package:netzoon/presentation/categories/widgets/image_free_zone_widget.dart';
import 'package:netzoon/presentation/chat/screens/chat_page_screen.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/helpers/connect_send_bird.dart';
import 'package:netzoon/presentation/core/helpers/navigate_to_profile_screen.dart';
import 'package:netzoon/presentation/core/helpers/show_image_dialog.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/on_failure_widget.dart';
import 'package:netzoon/presentation/core/widgets/phone_call_button.dart';
import 'package:netzoon/presentation/core/widgets/vehicle_details.dart';
import 'package:netzoon/presentation/home/widgets/auth_alert.dart';
import 'package:netzoon/presentation/orders/screens/congs_screen.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:netzoon/presentation/utils/remaining_date.dart';
import 'package:video_player/video_player.dart';

import '../../injection_container.dart';
import '../auth/blocs/auth_bloc/auth_bloc.dart';
import '../core/helpers/share_image_function.dart';
import '../core/widgets/screen_loader.dart';
import 'edit_ads_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';

class AdvertismentDetalsScreen extends StatefulWidget {
  const AdvertismentDetalsScreen({super.key, required this.adsId});

  final String adsId;

  @override
  State<AdvertismentDetalsScreen> createState() =>
      _AdvertismentDetalsScreenState();
}

class _AdvertismentDetalsScreenState extends State<AdvertismentDetalsScreen>
    with ScreenLoader<AdvertismentDetalsScreen> {
  String secretKey = dotenv.get('STRIPE_LIVE_SEC_KEY', fallback: '');

  Map<String, dynamic>? paymentIntent;
  final adsBloc = sl<AdsBlocBloc>();
  final visitorBloc = sl<AdsBlocBloc>();

  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  final authBloc = sl<AuthBloc>();

  @override
  void initState() {
    super.initState();
    visitorBloc.add(AddAdsVisitorEvent(adsId: widget.adsId));
    adsBloc.add(GetAdsByIdEvent(id: widget.adsId));
    authBloc.add(AuthCheckRequested());
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Container titleAndInput(
      {required String title, required String input, void Function()? onTap}) {
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
        child: GestureDetector(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context).translate(title),
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
      ),
    );
  }

  Future<void> makePayment({
    required String amount,
    required String currency,
  }) async {
    try {
      // final customerId = await createcustomer(email: toEmail, name: toName);
      paymentIntent = await createPaymentIntent(amount, currency);

      // var gpay = const PaymentSheetGooglePay(
      //   merchantCountryCode: "UAE",
      //   currencyCode: "aed",
      //   testEnv: true,
      // );
      var gpay = const PaymentSheetGooglePay(
        merchantCountryCode: "AE",
        currencyCode: "aed",
        testEnv: false,
      );
      print(paymentIntent!['client_secret']);
      print(paymentIntent);

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent!['client_secret'],
              style: ThemeMode.light,
              merchantDisplayName: 'Netzoon',
              googlePay: gpay,
              // customerId: customerId['id'],
              // googlePay: gpay,
              // allowsDelayedPaymentMethods: true,
              // billingDetails: const BillingDetails(
              //   name: 'adams',
              // ),
              // billingDetailsCollectionConfiguration:
              //     const BillingDetailsCollectionConfiguration(
              //   name: CollectionMode.always,
              // ),
            ),
          )
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      print(err);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        print("Payment Successfully");
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return const CongsScreen();
        }));
      });
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer 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',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: BackgroundWidget(
          isHome: false,
          widget: RefreshIndicator(
            onRefresh: () async {
              adsBloc.add(GetAdsByIdEvent(id: widget.adsId));
            },
            color: AppColor.white,
            backgroundColor: AppColor.backgroundColor,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: 30.0.h),
                child: BlocListener<AdsBlocBloc, AdsBlocState>(
                  bloc: adsBloc,
                  listener: (context, state) {
                    if (state is DeleteAdsInProgress) {
                      startLoading();
                    } else if (state is DeleteAdsFailure) {
                      stopLoading();

                      final message = state.message;
                      final failure = state.failure;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            message,
                            style: const TextStyle(
                              color: AppColor.white,
                            ),
                          ),
                          backgroundColor: AppColor.red,
                        ),
                      );
                      if (failure is UnAuthorizedFailure) {
                        while (context.canPop()) {
                          context.pop();
                        }
                        context.push('/home');
                      }
                    } else if (state is DeleteAdsSuccess) {
                      stopLoading();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          AppLocalizations.of(context).translate('success'),
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                      ));
                      Navigator.of(context).pop();
                    }
                  },
                  child: BlocBuilder<AdsBlocBloc, AdsBlocState>(
                    bloc: adsBloc,
                    builder: (context, state) {
                      if (state is AdsBlocInProgress) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height - 200.h,
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
                              adsBloc.add(GetAdsByIdEvent(id: widget.adsId));
                            });
                      } else if (state is GetAdsByIdSuccess) {
                        final int days = calculateRemainingDays(
                            state.ads.advertisingEndDate);
                        _videoPlayerController =
                            VideoPlayerController.networkUrl(
                                Uri.parse(state.ads.advertisingVedio ?? ''))
                              ..initialize().then((_) {
                                // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                                _videoPlayerController.play();
                                setState(() {});
                              });
                        _chewieController = ChewieController(
                          videoPlayerController: _videoPlayerController,
                          aspectRatio: 16 / 9,
                        );
                        _videoPlayerController.setLooping(true);
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
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        // borderRadius: const BorderRadius.only(
                                        //   bottomLeft: Radius.circular(50),
                                        //   bottomRight: Radius.circular(50),
                                        // ),
                                        child: CachedNetworkImage(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              2.2,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          imageUrl: state.ads.advertisingImage,
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
                                      ),
                                      days > 0
                                          ? state.ads.itemId != null &&
                                                  state.ads.itemId != ''
                                              ? Positioned(
                                                  bottom: 0,
                                                  left: 0,
                                                  right: 0,
                                                  child: InkWell(
                                                    onTap: () {
                                                      if (state.ads
                                                              .advertisingType ==
                                                          'car') {
                                                        Navigator.of(context)
                                                            .push(
                                                                MaterialPageRoute(
                                                          builder: (context) {
                                                            return VehicleDetailsScreen(
                                                                vehicleId: state
                                                                        .ads
                                                                        .itemId ??
                                                                    '');
                                                          },
                                                        ));
                                                      } else if (state.ads
                                                              .advertisingType ==
                                                          'planes') {
                                                        Navigator.of(context)
                                                            .push(
                                                                MaterialPageRoute(
                                                          builder: (context) {
                                                            return VehicleDetailsScreen(
                                                                vehicleId: state
                                                                        .ads
                                                                        .itemId ??
                                                                    '');
                                                          },
                                                        ));
                                                      } else if (state.ads
                                                              .advertisingType ==
                                                          'sea_companies') {
                                                        Navigator.of(context)
                                                            .push(
                                                                MaterialPageRoute(
                                                          builder: (context) {
                                                            return VehicleDetailsScreen(
                                                                vehicleId: state
                                                                        .ads
                                                                        .itemId ??
                                                                    '');
                                                          },
                                                        ));
                                                      } else if (state.ads
                                                              .advertisingType ==
                                                          'real_estate') {
                                                        Navigator.of(context)
                                                            .push(
                                                                MaterialPageRoute(
                                                          builder: (context) {
                                                            return RealEstateDetailsScreen(
                                                                realEstateId: state
                                                                        .ads
                                                                        .itemId ??
                                                                    '');
                                                          },
                                                        ));
                                                      }
                                                    },
                                                    splashColor: AppColor
                                                        .backgroundColor,
                                                    child: Container(
                                                      height: 40.h,
                                                      width: double.infinity,
                                                      color: Colors.grey[200],
                                                      child: Center(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              AppLocalizations.of(
                                                                      context)
                                                                  .translate(
                                                                      'show_details'),
                                                              style: TextStyle(
                                                                color: AppColor
                                                                    .black,
                                                                fontSize: 15.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 8.w,
                                                            ),
                                                            const Icon(Feather
                                                                .more_horizontal),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox()
                                          : const SizedBox(),
                                    ],
                                  ),
                                  // CachedNetworkImage(
                                  //   imageUrl: state.ads.advertisingImage,
                                  //   width: 700.w,
                                  //   height: 200.h,
                                  //   fit: BoxFit.contain,
                                  //   progressIndicatorBuilder:
                                  //       (context, url, downloadProgress) =>
                                  //           Padding(
                                  //     padding: const EdgeInsets.symmetric(
                                  //         horizontal: 70.0, vertical: 50),
                                  //     child: CircularProgressIndicator(
                                  //       value: downloadProgress.progress,
                                  //       color: AppColor.backgroundColor,

                                  //       // strokeWidth: 10,
                                  //     ),
                                  //   ),
                                  //   errorWidget: (context, url, error) =>
                                  //       const Icon(Icons.error),
                                  // ),
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
                                            Text(
                                              '${state.ads.advertisingPrice} ${AppLocalizations.of(context).translate('AED')}',
                                              style: TextStyle(
                                                  color: AppColor.colorOne,
                                                  fontSize: 17.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // const Icon(
                                                //   Icons.favorite_border,
                                                //   color: AppColor.backgroundColor,
                                                // ),
                                                IconButton(
                                                  onPressed: () async {
                                                    await shareImageWithDescription(
                                                      imageUrl: state
                                                          .ads.advertisingImage,
                                                      description:
                                                          'https://www.netzoon.com/home/advertisments/${state.ads.id}',
                                                      subject: state.ads.name,
                                                    );
                                                  },
                                                  icon: Icon(
                                                    Icons.share,
                                                    color: AppColor
                                                        .backgroundColor,
                                                    size: 15.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 7.h,
                                        ),
                                        Text(
                                          state.ads.name,
                                          style: TextStyle(
                                            color: AppColor.black,
                                            fontSize: 20.sp,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 7.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'num_of_viewers'),
                                                  style: TextStyle(
                                                    color: AppColor.black,
                                                    fontSize: 15.sp,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 8.0.w,
                                                ),
                                                Text(
                                                  state.ads.adsViews == null
                                                      ? "0"
                                                      : state.ads.adsViews
                                                          .toString(),
                                                  style: TextStyle(
                                                    color: AppColor
                                                        .backgroundColor,
                                                    fontSize: 15.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            BlocBuilder<AuthBloc, AuthState>(
                                              bloc: authBloc,
                                              builder: (context, authState) {
                                                if (authState
                                                    is Authenticated) {
                                                  // print(authState.user
                                                  //     .userInfo.username);
                                                  // print(widget.news.creator
                                                  //     .username);

                                                  if (authState
                                                          .user.userInfo.id ==
                                                      state.ads.owner.id) {
                                                    return Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        IconButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .push(MaterialPageRoute(
                                                                    builder:
                                                                        (context) {
                                                              return EditAdsScreen(
                                                                ads: state.ads,
                                                              );
                                                            }));
                                                          },
                                                          icon: Icon(
                                                            Icons.edit,
                                                            color: AppColor
                                                                .backgroundColor,
                                                            size: 22.sp,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: () {
                                                            adsBloc.add(
                                                                DeleteAdsEvent(
                                                                    id: state
                                                                        .ads
                                                                        .id));
                                                          },
                                                          icon: Icon(
                                                            Icons.delete,
                                                            color: AppColor.red,
                                                            size: 22.sp,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                }
                                                return Container();
                                              },
                                            ),
                                          ],
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
                                    Text(
                                      AppLocalizations.of(context)
                                          .translate('details'),
                                      style: TextStyle(
                                        color: AppColor.black,
                                        fontSize: 17.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    titleAndInput(
                                      title: 'owner',
                                      input: state.ads.owner.username ?? '',
                                      onTap: () {
                                        navigateToProfileScreen(
                                            context: context,
                                            userType:
                                                state.ads.owner.userType ?? '',
                                            userId: state.ads.owner.id);
                                      },
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    titleAndInput(
                                      title: 'categ',
                                      input: state.ads.advertisingType,
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    state.ads.type != null &&
                                            state.ads.type != ''
                                        ? titleAndInput(
                                            title: 'car_name',
                                            input: state.ads.type ?? '',
                                          )
                                        : const SizedBox(),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    state.ads.category != null &&
                                            state.ads.category != ''
                                        ? titleAndInput(
                                            title: 'car_category',
                                            input: state.ads.category ?? '',
                                          )
                                        : const SizedBox(),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    titleAndInput(
                                      title: 'year',
                                      input: state.ads.advertisingYear,
                                    ),
                                    // SizedBox(
                                    //   height: 7.h,
                                    // ),
                                    // titleAndInput(
                                    //   title: 'kilometers',
                                    //   input: '123',
                                    // ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    // titleAndInput(
                                    //   title: 'regional_specifications',
                                    //   input: 'مواصفات خليجية',
                                    // ),
                                    state.ads.color != null &&
                                            state.ads.color != ''
                                        ? titleAndInput(
                                            title: 'color',
                                            input: state.ads.color ?? '',
                                          )
                                        : const SizedBox(),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    state.ads.guarantee != null
                                        ? titleAndInput(
                                            title: 'guarantee',
                                            input: state.ads.guarantee == true
                                                ? AppLocalizations.of(context)
                                                    .translate('applies')
                                                : AppLocalizations.of(context)
                                                    .translate('do not apply'),
                                          )
                                        : const SizedBox(),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    titleAndInput(
                                      title: 'الموقع',
                                      input: state.ads.advertisingLocation,
                                    ),
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
                                    state.ads.advertisingDescription,
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
                                  state.ads.advertisingImageList?.isNotEmpty ==
                                          true
                                      ? GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: state
                                              .ads.advertisingImageList?.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  childAspectRatio: 0.90),
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                showImageDialog(
                                                    context,
                                                    state.ads
                                                        .advertisingImageList!,
                                                    index);
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                child: ListOfPictures(
                                                  img: state.ads
                                                          .advertisingImageList![
                                                      index],
                                                ),
                                              ),
                                            );
                                          })
                                      : GestureDetector(
                                          onTap: () {},
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate('no_images'),
                                            style: TextStyle(
                                              color: AppColor.mainGrey,
                                              fontSize: 15.sp,
                                            ),
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
                              child: state.ads.advertisingVedio != null &&
                                      state.ads.advertisingVedio != ''
                                  // ? VideoFreeZoneWidget(
                                  //     title:
                                  //         "${AppLocalizations.of(context).translate('vedio')}  : ",
                                  //     vediourl: state.ads.advertisingVedio ?? '',
                                  //   )
                                  ? AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Chewie(
                                        controller: _chewieController,
                                      ),
                                    )
                                  : Text(
                                      AppLocalizations.of(context)
                                          .translate('no_vedio'),
                                      style: TextStyle(
                                        color: AppColor.mainGrey,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                            ),
                            SizedBox(
                              height: 120.h,
                            ),
                          ],
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BlocBuilder<AdsBlocBloc, AdsBlocState>(
        bloc: adsBloc,
        builder: (context, state) {
          if (state is GetAdsByIdSuccess) {
            return BottomAppBar(
              height: 60.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PhoneCallWidget(
                      phonePath: state.ads.owner.firstMobile ?? "",
                      title: AppLocalizations.of(context).translate('call')),
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
                                      authState.user.userInfo.username ?? '',
                                  otherUserId: state.ads.owner.username ?? '',
                                  title: state.ads.owner.username ?? '',
                                  image: state.ads.owner.profilePhoto ?? '',
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
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
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
                  //     child:
                  //         Text(AppLocalizations.of(context).translate('chat'))),
                  // PriceSuggestionButton(input: input),
                ],
              ),
            );
          } else if (state is AdsBlocInProgress) {
            return SizedBox(
              height: MediaQuery.of(context).size.height - 200,
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
                  adsBloc.add(GetAdsByIdEvent(id: widget.adsId));
                });
          }
          return Container();
        },
      ),
    );
  }
}
