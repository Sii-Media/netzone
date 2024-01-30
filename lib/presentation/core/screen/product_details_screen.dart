import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/presentation/advertising/blocs/add_ads/add_ads_bloc.dart';
import 'package:netzoon/presentation/cart/blocs/cart_bloc/cart_bloc_bloc.dart';
import 'package:netzoon/presentation/cart/helpers/handle_add_to_cart_fun.dart';
import 'package:netzoon/presentation/categories/factories/factory_profile_screen.dart';
import 'package:netzoon/presentation/categories/local_company/local_company_profile.dart';
import 'package:netzoon/presentation/categories/users/screens/users_profile_screen.dart';
import 'package:netzoon/presentation/categories/widgets/image_free_zone_widget.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/helpers/pick_date_time.dart';
import 'package:netzoon/presentation/core/helpers/show_image_dialog.dart';
import 'package:netzoon/presentation/core/widgets/add_photo_button.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/on_failure_widget.dart';
import 'package:netzoon/presentation/core/widgets/price_suggestion_button.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:netzoon/presentation/favorites/favorite_blocs/favorites_bloc.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:netzoon/presentation/utils/convert_date_to_string.dart';
import 'package:video_player/video_player.dart';
import '../../../injection_container.dart';
import '../../auth/blocs/auth_bloc/auth_bloc.dart';
import '../../categories/widgets/build_rating.dart';
import '../../home/blocs/elec_devices/elec_devices_bloc.dart';
import '../blocs/country_bloc/country_bloc.dart';
import '../helpers/get_currency_of_country.dart';
import '../helpers/share_image_function.dart';
import 'edit_product_screen.dart';
import 'package:http/http.dart' as http;

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    super.key,
    required this.item,
  });
  final String item;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with ScreenLoader<ProductDetailScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool isFavorite = false;
  late FavoritesBloc favBloc;
  bool _isPressed = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController startDateController = TextEditingController();
  late TextEditingController endDateController = TextEditingController();
  late TextEditingController yearController = TextEditingController();
  late TextEditingController locationController = TextEditingController();
  String? _selectedStartDate;
  String? _selectedEndDate;
  Map<String, dynamic>? paymentIntent;
  final addAdsbloc = sl<AddAdsBloc>();

  Future<void> makePayment({
    required String amount,
    required String currency,
    required String title,
    required String description,
    required String location,
    required String imagePath,
    required double price,
    required String productId,
  }) async {
    try {
      // final customerId = await createcustomer(email: email, name: name);
      paymentIntent = await createPaymentIntent(amount, currency);

      var gpay = const PaymentSheetGooglePay(
        merchantCountryCode: "AE",
        currencyCode: "aed",
        testEnv: false,
      );

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret:
                paymentIntent!['client_secret'], //Gotten from payment intent
            style: ThemeMode.light,
            merchantDisplayName: 'Netzoon',
            // customerId: customerId['id'],

            googlePay: gpay,
          ))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet(
          title: title,
          description: description,
          location: location,
          imagePath: imagePath,
          price: price,
          productId: productId);
    } catch (err) {
      print(err);
    }
  }

  displayPaymentSheet({
    required String title,
    required String description,
    required String location,
    required String imagePath,
    required double price,
    required String productId,
  }) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        print("Payment Successfully");
        addAdsbloc.add(AddAdsRequestedEvent(
          advertisingTitle: title,
          advertisingStartDate: _selectedStartDate ?? '',
          advertisingEndDate: _selectedEndDate ?? '',
          advertisingDescription: description,
          advertisingYear: yearController.text,
          advertisingLocation: locationController.text,
          imagePath: imagePath,
          advertisingPrice: price,
          advertisingType: 'product',
          purchasable: true,
          productId: productId,
          forPurchase: true,
        ));
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
      // String secretKey = dotenv.get('STRIPE_LIVE_SEC_KEY', fallback: '');

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

  void _togglePressed() {
    setState(() {
      _isPressed = !_isPressed;
    });

    if (_isPressed) {
      HapticFeedback.vibrate();
    }
  }

  final authBloc = sl<AuthBloc>();

  final productBloc = sl<ElecDevicesBloc>();
  final rateBloc = sl<ElecDevicesBloc>();

  late final CountryBloc countryBloc;
  int _totalPrice = 0;

  void _calculateTotalPrice() {
    if (_selectedStartDate != null && _selectedEndDate != null) {
      DateTime startDate = DateTime.parse(_selectedStartDate!);
      DateTime endDate = DateTime.parse(_selectedEndDate!);
      Duration difference = endDate.difference(startDate);
      int totalPrice = difference.inDays * 5;
      setState(() {
        _totalPrice = totalPrice;
      });
    }
  }

  @override
  void initState() {
    productBloc.add(GetProductByIdEvent(productId: widget.item));
    favBloc = BlocProvider.of<FavoritesBloc>(context);
    favBloc.add(IsFavoriteEvent(productId: widget.item));
    countryBloc = BlocProvider.of<CountryBloc>(context);
    countryBloc.add(GetCountryEvent());
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(''))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9,
    );
    _videoPlayerController.setLooping(true);
    authBloc.add(AuthCheckRequested());

    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget screen(BuildContext context) {
    final TextEditingController input = TextEditingController();

    return Scaffold(
        body: BackgroundWidget(
          isHome: false,
          widget: RefreshIndicator(
            onRefresh: () async {
              productBloc.add(GetProductByIdEvent(productId: widget.item));
            },
            color: AppColor.white,
            backgroundColor: AppColor.backgroundColor,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 20.0.h, bottom: 30.0.h),
                child: BlocListener<ElecDevicesBloc, ElecDevicesState>(
                  bloc: rateBloc,
                  listener: (context, state) {
                    if (state is RateProductInProgress) {
                      startLoading();
                    } else if (state is RateProductFailure) {
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
                    } else if (state is RateProductSuccess) {
                      stopLoading();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          AppLocalizations.of(context).translate('success'),
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                      ));
                    }
                  },
                  child: BlocListener<ElecDevicesBloc, ElecDevicesState>(
                      bloc: productBloc,
                      listener: (context, state) {
                        if (state is DeleteProductInProgress) {
                          startLoading();
                        } else if (state is DeleteProductFailure) {
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
                        } else if (state is DeleteProductSuccess) {
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
                      child: BlocListener<AddAdsBloc, AddAdsState>(
                        bloc: addAdsbloc,
                        listener: (context, addAdsState) {
                          if (addAdsState is AddAdsInProgress) {
                            startLoading();
                          } else if (addAdsState is AddAdsFailure) {
                            stopLoading();

                            final message = addAdsState.message;
                            final failure = addAdsState.failure;

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
                          } else if (addAdsState is AddAdsSuccess) {
                            stopLoading();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                AppLocalizations.of(context)
                                    .translate('success'),
                              ),
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                            ));
                          }
                        },
                        child: BlocBuilder<CountryBloc, CountryState>(
                          bloc: countryBloc,
                          builder: (context, countryState) {
                            if (countryState is CountryInitial) {
                              return BlocBuilder<ElecDevicesBloc,
                                  ElecDevicesState>(
                                bloc: productBloc,
                                builder: (context, state) {
                                  if (state is ElecDevicesInProgress) {
                                    return SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height -
                                              170.h,
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColor.backgroundColor,
                                        ),
                                      ),
                                    );
                                  } else if (state is ElecDevicesFailure) {
                                    final failure = state.message;
                                    return FailureWidget(
                                        failure: failure,
                                        onPressed: () {
                                          productBloc.add(GetProductByIdEvent(
                                              productId: widget.item));
                                        });
                                  } else if (state is GetProductByIdSuccess) {
                                    _videoPlayerController =
                                        VideoPlayerController.networkUrl(
                                            Uri.parse(
                                                state.product.vedioUrl ?? ''))
                                          ..initialize().then((_) {
                                            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                                            setState(() {});
                                          });
                                    _chewieController = ChewieController(
                                      videoPlayerController:
                                          _videoPlayerController,
                                      aspectRatio: 16 / 9,
                                    );
                                    _videoPlayerController.setLooping(true);

                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                width: 7,
                                                color: Colors.grey
                                                    .withOpacity(0.4),
                                              ),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl:
                                                    state.product.imageUrl,
                                                width: 700.w,
                                                height: 200.h,
                                                fit: BoxFit.contain,
                                                progressIndicatorBuilder:
                                                    (context, url,
                                                            downloadProgress) =>
                                                        Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 70.0,
                                                      vertical: 50),
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: downloadProgress
                                                        .progress,
                                                    color: AppColor
                                                        .backgroundColor,

                                                    // strokeWidth: 10,
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              '${AppLocalizations.of(context).translate('price')}: ',
                                                              style: TextStyle(
                                                                  color: AppColor
                                                                      .colorOne,
                                                                  fontSize:
                                                                      20.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                            RichText(
                                                              text: TextSpan(
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18.sp,
                                                                      color: AppColor
                                                                          .backgroundColor),
                                                                  children: <TextSpan>[
                                                                    TextSpan(
                                                                        text:
                                                                            '${state.product.price}',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                          decoration: state.product.discountPercentage != null && state.product.discountPercentage != 0
                                                                              ? TextDecoration.lineThrough
                                                                              : TextDecoration.none,
                                                                        )),
                                                                    TextSpan(
                                                                      text:
                                                                          getCurrencyFromCountry(
                                                                        countryState
                                                                            .selectedCountry,
                                                                        context,
                                                                      ),
                                                                      style: TextStyle(
                                                                          color: AppColor
                                                                              .backgroundColor,
                                                                          fontSize:
                                                                              14.sp),
                                                                    )
                                                                  ]),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            IconButton(
                                                              onPressed:
                                                                  () async {
                                                                await shareImageWithDescription(
                                                                    imageUrl: state
                                                                        .product
                                                                        .imageUrl,
                                                                    subject: state
                                                                        .product
                                                                        .name,
                                                                    description:
                                                                        'https://www.netzoon.com/home/product/${state.product.id}');
                                                              },
                                                              icon: Icon(
                                                                Icons.share,
                                                                color: AppColor
                                                                    .backgroundColor,
                                                                size: 22.sp,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 8.w,
                                                            ),
                                                            BlocBuilder<
                                                                FavoritesBloc,
                                                                FavoritesState>(
                                                              builder: (context,
                                                                  state) {
                                                                if (state
                                                                    is IsFavoriteState) {
                                                                  isFavorite = state
                                                                      .isFavorite;
                                                                }
                                                                return IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      if (isFavorite) {
                                                                        context
                                                                            .read<FavoritesBloc>()
                                                                            .add(
                                                                              RemoveItemEvent(productId: widget.item),
                                                                            );
                                                                      } else {
                                                                        context
                                                                            .read<FavoritesBloc>()
                                                                            .add(
                                                                              AddItemToFavoritesEvent(
                                                                                productId: widget.item,
                                                                              ),
                                                                            );
                                                                      }
                                                                    });
                                                                  },
                                                                  icon: Icon(
                                                                    isFavorite
                                                                        ? Icons
                                                                            .favorite
                                                                        : Icons
                                                                            .favorite_border,
                                                                    size: 22.sp,
                                                                    color: isFavorite
                                                                        ? AppColor
                                                                            .red
                                                                        : AppColor
                                                                            .backgroundColor,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 7.h,
                                                    ),
                                                    state.product.discountPercentage !=
                                                                null &&
                                                            state.product
                                                                    .discountPercentage !=
                                                                0
                                                        ? Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                '${AppLocalizations.of(context).translate('price_now')}: ',
                                                                style: const TextStyle(
                                                                    color: AppColor
                                                                        .colorOne,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                              RichText(
                                                                text: TextSpan(
                                                                    style: TextStyle(
                                                                        fontSize: 18
                                                                            .sp,
                                                                        color: AppColor
                                                                            .backgroundColor),
                                                                    children: <TextSpan>[
                                                                      TextSpan(
                                                                          text:
                                                                              '${state.product.priceAfterDiscount}',
                                                                          style:
                                                                              const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                          )),
                                                                      TextSpan(
                                                                        text:
                                                                            getCurrencyFromCountry(
                                                                          countryState
                                                                              .selectedCountry,
                                                                          context,
                                                                        ),
                                                                        style: TextStyle(
                                                                            color:
                                                                                AppColor.backgroundColor,
                                                                            fontSize: 12.sp),
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            '  ${state.product.discountPercentage?.round().toString()}% ${AppLocalizations.of(context).translate('OFF')}',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.green,
                                                                            fontWeight: FontWeight.w700,
                                                                            fontSize: 14.sp),
                                                                      )
                                                                    ]),
                                                              ),
                                                            ],
                                                          )
                                                        : Container(),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            state.product.name,
                                                            style: TextStyle(
                                                              color: AppColor
                                                                  .black,
                                                              fontSize: 18.sp,
                                                            ),
                                                          ),
                                                        ),
                                                        BlocBuilder<AuthBloc,
                                                            AuthState>(
                                                          bloc: authBloc,
                                                          builder: (context,
                                                              authState) {
                                                            if (authState
                                                                is Authenticated) {
                                                              if (authState
                                                                      .user
                                                                      .userInfo
                                                                      .username ==
                                                                  state
                                                                      .product
                                                                      .owner
                                                                      .username) {
                                                                return Row(
                                                                  children: [
                                                                    IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context).push(MaterialPageRoute(builder:
                                                                            (context) {
                                                                          return EditProductScreen(
                                                                            item:
                                                                                state.product,
                                                                          );
                                                                        }));
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .edit,
                                                                        color: AppColor
                                                                            .backgroundColor,
                                                                        size: 22
                                                                            .sp,
                                                                      ),
                                                                    ),
                                                                    IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        productBloc.add(DeleteProductEvent(
                                                                            productId:
                                                                                widget.item));
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .delete,
                                                                        color: AppColor
                                                                            .red,
                                                                        size: 22
                                                                            .sp,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              }
                                                            }
                                                            return const SizedBox();
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          '${state.product.averageRating}',
                                                          style: TextStyle(
                                                              color: AppColor
                                                                  .secondGrey,
                                                              fontSize: 18.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () =>
                                                              showProductRating(
                                                                  context:
                                                                      context,
                                                                  productBloc:
                                                                      rateBloc,
                                                                  id: state
                                                                      .product
                                                                      .id,
                                                                  userRate: state
                                                                          .product
                                                                          .averageRating ??
                                                                      0),
                                                          child:
                                                              RatingBar.builder(
                                                            minRating: 1,
                                                            maxRating: 5,
                                                            initialRating: state
                                                                    .product
                                                                    .averageRating ??
                                                                0,
                                                            itemSize: 25.sp,
                                                            ignoreGestures:
                                                                true,
                                                            itemBuilder:
                                                                (context, _) {
                                                              return const Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .amber,
                                                              );
                                                            },
                                                            allowHalfRating:
                                                                true,
                                                            updateOnDrag: true,
                                                            onRatingUpdate:
                                                                (rating) {},
                                                          ),
                                                        ),
                                                        Text(
                                                          '(${state.product.totalRatings} ${AppLocalizations.of(context).translate('review')})',
                                                          style: TextStyle(
                                                            color: AppColor
                                                                .secondGrey,
                                                            fontSize: 14.sp,
                                                          ),
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
                                                color: Colors.grey
                                                    .withOpacity(0.4),
                                              ),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                titleAndInput(
                                                  title: AppLocalizations.of(
                                                          context)
                                                      .translate('categ'),
                                                  input: AppLocalizations.of(
                                                          context)
                                                      .translate(state.product
                                                          .category.name),
                                                ),
                                                SizedBox(
                                                  height: 7.h,
                                                ),
                                                titleAndInput(
                                                  title: AppLocalizations.of(
                                                          context)
                                                      .translate('owner'),
                                                  input: state.product.owner
                                                          .username ??
                                                      '',
                                                  onTap: () {
                                                    if (state.product.owner
                                                            .userType ==
                                                        'user') {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return UsersProfileScreen(
                                                            userId: state
                                                                .product
                                                                .owner
                                                                .id);
                                                      }));
                                                    } else if (state.product
                                                            .owner.userType ==
                                                        'local_company') {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return LocalCompanyProfileScreen(
                                                            id: state.product
                                                                .owner.id);
                                                      }));
                                                    } else if (state.product
                                                            .owner.userType ==
                                                        'factory') {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return FactoryProfileScreen(
                                                            id: state.product
                                                                .owner.id);
                                                      }));
                                                    } else if (state.product
                                                            .owner.userType ==
                                                        'trader') {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return LocalCompanyProfileScreen(
                                                            id: state.product
                                                                .owner.id);
                                                      }));
                                                    }
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 7.h,
                                                ),
                                                titleAndInput(
                                                  title: AppLocalizations.of(
                                                          context)
                                                      .translate('quantity'),
                                                  input: state.product
                                                              .quantity ==
                                                          null
                                                      ? 1.toString()
                                                      : state.product.quantity
                                                          .toString(),
                                                ),
                                                SizedBox(
                                                  height: 7.h,
                                                ),
                                                titleAndInput(
                                                  title: AppLocalizations.of(
                                                          context)
                                                      .translate('weightkg'),
                                                  input: state.product.weight ==
                                                          null
                                                      ? 0.toString()
                                                      : state.product.weight
                                                          .toString(),
                                                ),
                                                SizedBox(
                                                  height: 7.h,
                                                ),
                                                state.product.color != null &&
                                                        state.product.color !=
                                                            ''
                                                    ? titleAndInput(
                                                        title: AppLocalizations
                                                                .of(context)
                                                            .translate('color'),
                                                        input: state.product
                                                                .color ??
                                                            '')
                                                    : const SizedBox(),
                                                SizedBox(
                                                  height: 7.h,
                                                ),
                                                state.product.year != null
                                                    ? titleAndInput(
                                                        title: AppLocalizations
                                                                .of(context)
                                                            .translate('year'),
                                                        input: state
                                                                .product.year ??
                                                            '',
                                                      )
                                                    : Container(),
                                                SizedBox(
                                                  height: 7.h,
                                                ),
                                                // widget.item.propert != null
                                                //     ? titleAndInput(
                                                //         title: AppLocalizations.of(context)
                                                //             .translate('regional_specifications'),
                                                //         input: widget.item.propert ?? '',
                                                //       )
                                                //     : Container(),
                                                // SizedBox(
                                                //   height: 7.h,
                                                // ),
                                                state.product.condition != null
                                                    ? titleAndInput(
                                                        title: AppLocalizations
                                                                .of(context)
                                                            .translate(
                                                                'condition'),
                                                        input: state.product
                                                                .condition ??
                                                            '',
                                                      )
                                                    : const SizedBox(),
                                                SizedBox(
                                                  height: 7.h,
                                                ),
                                                titleAndInput(
                                                  title: AppLocalizations.of(
                                                          context)
                                                      .translate('guarantee'),
                                                  input: state.product
                                                              .guarantee ==
                                                          true
                                                      ? AppLocalizations.of(
                                                              context)
                                                          .translate('applies')
                                                      : AppLocalizations.of(
                                                              context)
                                                          .translate(
                                                              'do not apply'),
                                                ),
                                                SizedBox(
                                                  height: 7.h,
                                                ),
                                                state.product.address != null &&
                                                        state.product.address !=
                                                            ''
                                                    ? titleAndInput(
                                                        title:
                                                            AppLocalizations.of(
                                                                    context)
                                                                .translate(
                                                                    'address'),
                                                        input: state.product
                                                                .address ??
                                                            '',
                                                      )
                                                    : const SizedBox(),
                                                SizedBox(
                                                  height: 7.h,
                                                ),
                                                state.product.madeIn != null &&
                                                        state.product.madeIn !=
                                                            ''
                                                    ? titleAndInput(
                                                        title:
                                                            AppLocalizations.of(
                                                                    context)
                                                                .translate(
                                                                    'made_in'),
                                                        input: state.product
                                                                .madeIn ??
                                                            '',
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
                                                color: Colors.grey
                                                    .withOpacity(0.4),
                                              ),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                state.product.description,
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
                                                color: Colors.grey
                                                    .withOpacity(0.4),
                                              ),
                                            ),
                                          ),
                                          child: Column(
                                            // mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${AppLocalizations.of(context).translate('images')} :',
                                                style: TextStyle(
                                                  color: AppColor.black,
                                                  fontSize: 17.sp,
                                                ),
                                              ),
                                              state.product.images
                                                          ?.isNotEmpty ==
                                                      true
                                                  ? SizedBox(
                                                      height: 200.h,
                                                      // width: 120,
                                                      child: ListView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              const BouncingScrollPhysics(),
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemCount: state
                                                              .product
                                                              .images!
                                                              .length,
                                                          // gridDelegate:
                                                          //     const SliverGridDelegateWithFixedCrossAxisCount(
                                                          //         crossAxisCount: 2,
                                                          //         childAspectRatio: 0.94),
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  index) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                showImageDialog(
                                                                    context,
                                                                    state
                                                                        .product
                                                                        .images!,
                                                                    index);
                                                              },
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25.0),
                                                                child:
                                                                    ListOfPictures(
                                                                  img: state
                                                                          .product
                                                                          .images![
                                                                      index],
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                    )
                                                  : Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate(
                                                              'no_images'),
                                                      style: TextStyle(
                                                        color:
                                                            AppColor.mainGrey,
                                                        fontSize: 15.sp,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 7.h,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                width: 7,
                                                color: Colors.grey
                                                    .withOpacity(0.4),
                                              ),
                                            ),
                                          ),
                                          child: state.product.gifUrl != '' &&
                                                  state.product.gifUrl != null
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${AppLocalizations.of(context).translate('gif')} :',
                                                      style: TextStyle(
                                                        color: AppColor.black,
                                                        fontSize: 17.sp,
                                                      ),
                                                    ),
                                                    Center(
                                                      child: Image.network(
                                                        state.product.gifUrl ??
                                                            '',
                                                        width: 250.w,
                                                        height: 250.h,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : const SizedBox(),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                width: 7,
                                                color: Colors.grey
                                                    .withOpacity(0.4),
                                              ),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${AppLocalizations.of(context).translate('vedio')} :',
                                                style: TextStyle(
                                                  color: AppColor.black,
                                                  fontSize: 17.sp,
                                                ),
                                              ),
                                              state.product.vedioUrl != null
                                                  ? AspectRatio(
                                                      aspectRatio: 16 / 9,
                                                      child: Chewie(
                                                        controller:
                                                            _chewieController,
                                                      ),
                                                    )
                                                  // ? VideoFreeZoneWidget(
                                                  //     title:
                                                  //         "${AppLocalizations.of(context).translate('vedio')}  : ",
                                                  //     vediourl: state.product.vedioUrl ?? '',
                                                  //   )
                                                  : Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate(
                                                              'no_vedio'),
                                                      style: TextStyle(
                                                        color:
                                                            AppColor.mainGrey,
                                                        fontSize: 15.sp,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 120.h,
                                        )
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
                      )),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: BlocBuilder<ElecDevicesBloc, ElecDevicesState>(
          bloc: productBloc,
          builder: (context, state) {
            if (state is ElecDevicesInProgress) {
              return SizedBox(
                height: MediaQuery.of(context).size.height - 170.h,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.backgroundColor,
                  ),
                ),
              );
            } else if (state is ElecDevicesFailure) {
              final failure = state.message;
              return FailureWidget(
                  failure: failure,
                  onPressed: () {
                    productBloc
                        .add(GetProductByIdEvent(productId: widget.item));
                  });
            } else if (state is GetProductByIdSuccess) {
              return BlocBuilder<AuthBloc, AuthState>(
                bloc: authBloc,
                builder: (context, authState) {
                  if (authState is Authenticated &&
                      authState.user.userInfo.username ==
                          state.product.owner.username) {
                    return BottomAppBar(
                      height: 40.h,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.backgroundColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )),
                            onPressed: () async {
                              bool isWantAdd = await _showAddtoAdsDialog();
                              if (isWantAdd == true) {
                                String amount = (_totalPrice * 100).toString();
                                makePayment(
                                    amount: amount,
                                    currency: 'aed',
                                    title: state.product.name,
                                    description: state.product.description,
                                    location: state.product.address ?? '',
                                    imagePath: state.product.imageUrl,
                                    price: state.product.priceAfterDiscount ??
                                        state.product.price,
                                    productId: state.product.id);
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(AppLocalizations.of(context)
                                    .translate('add_your_product_to_ad')),
                                SizedBox(
                                  width: 7.w,
                                ),
                                const Icon(Icons.ads_click_rounded),
                              ],
                            )),
                      ),
                    );
                  }
                  if (state.product.owner.userType == 'factory' ||
                      state.product.owner.userType == 'freezone') {
                    if (authState is Authenticated) {
                      if (authState.user.userInfo.userType == 'local_company' ||
                          authState.user.userInfo.userType == 'trader') {
                        return BottomAppBar(
                          height: 60.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    AppColor.backgroundColor,
                                  ),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  )),
                                  fixedSize: MaterialStatePropertyAll(
                                    Size.fromWidth(200.w),
                                  ),
                                ),
                                child: Text(AppLocalizations.of(context)
                                    .translate('add_to_cart')),
                                onPressed: () {
                                  // final cartBloc = sl<CartBlocBloc>();
                                  _togglePressed();
                                  final cartBloc = context.read<CartBlocBloc>();
                                  final cartItems = cartBloc.state.props;
                                  if (cartItems.any(
                                      (elm) => elm.id == state.product.id)) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        AppLocalizations.of(context).translate(
                                            'Product_Already_added_to_cart'),
                                        style: const TextStyle(
                                            color: AppColor.white),
                                      ),
                                      backgroundColor: AppColor.red,
                                      duration: const Duration(seconds: 2),
                                    ));
                                  } else {
                                    cartBloc
                                        .add(AddToCart(product: state.product));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(AppLocalizations.of(context)
                                          .translate('Product_added_to_cart')),
                                      backgroundColor: AppColor.backgroundColor,
                                      duration: const Duration(seconds: 2),
                                    ));
                                  }
                                },
                              ),
                              // PriceSuggestionButton(input: input),
                            ],
                          ),
                        );
                      }
                      return const SizedBox();
                    }
                  }
                  return BottomAppBar(
                    height: 60.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              AppColor.backgroundColor,
                            ),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            )),
                            fixedSize: MaterialStatePropertyAll(
                              Size.fromWidth(200.w),
                            ),
                          ),
                          child: Text(AppLocalizations.of(context)
                              .translate('add_to_cart')),
                          onPressed: () {
                            // final cartBloc = sl<CartBlocBloc>();
                            _togglePressed();
                            handleAddToCart(
                                context: context, product: state.product);
                          },
                        ),
                        // PriceSuggestionButton(input: input),
                      ],
                    ),
                  );
                },
              );
            }
            return Container();
          },
        ));
  }

  Future<bool> _showAddtoAdsDialog() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColor.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
          child: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.all(26),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppLocalizations.of(context)
                                .translate('add_your_product_to_ad'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColor.backgroundColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Text(
                            '${AppLocalizations.of(context).translate('start_date')} :',
                            style: TextStyle(
                              color: AppColor.backgroundColor,
                              fontSize: 14.sp,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 2),
                            child: TextFormField(
                              controller: startDateController,
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.datetime,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please select a date';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                //<-- SEE HERE
                                fillColor: Colors.green.withOpacity(0.1),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                contentPadding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 30)
                                    .flipped,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              onTap: () async {
                                final date = await pickDate(
                                  context: context,
                                  initialDate: DateTime.now(),
                                );
                                if (date == null) {
                                  return;
                                }
                                setState(() {
                                  _selectedStartDate = date.toIso8601String();
                                  startDateController.text =
                                      convertDateToString(date.toString());
                                  _calculateTotalPrice();
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            '${AppLocalizations.of(context).translate('end_date')} :',
                            style: TextStyle(
                              color: AppColor.backgroundColor,
                              fontSize: 14.sp,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 2),
                            child: TextFormField(
                              controller: endDateController,
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.datetime,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please select a date';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                //<-- SEE HERE
                                fillColor: Colors.green.withOpacity(0.1),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                contentPadding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 30)
                                    .flipped,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              onTap: () async {
                                final date = await pickDate(
                                  context: context,
                                  initialDate: DateTime.parse(
                                      _selectedEndDate ??
                                          DateTime.now().toIso8601String()),
                                );
                                if (date == null) {
                                  return;
                                }
                                setState(() {
                                  _selectedEndDate = date.toIso8601String();
                                  endDateController.text =
                                      convertDateToString(date.toString());
                                  _calculateTotalPrice();
                                });
                              },
                            ),
                          ),
                          Text(
                            '${AppLocalizations.of(context).translate('total_amount')}: $_totalPrice AED',
                            style: TextStyle(
                              color: AppColor.colorOne,
                              fontSize: 14.sp,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context).translate('year'),
                                style: TextStyle(
                                  color: AppColor.backgroundColor,
                                  fontSize: 16.sp,
                                ),
                              ),
                              TextFormField(
                                controller: yearController,
                                style: const TextStyle(color: Colors.black),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: InputDecoration(
                                  filled: true,
                                  //<-- SEE HERE
                                  fillColor: Colors.green.withOpacity(0.1),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  contentPadding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 30)
                                      .flipped,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'required';
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              Text(
                                AppLocalizations.of(context)
                                    .translate('الموقع'),
                                style: TextStyle(
                                  color: AppColor.backgroundColor,
                                  fontSize: 16.sp,
                                ),
                              ),
                              TextFormField(
                                controller: locationController,
                                style: const TextStyle(color: Colors.black),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  filled: true,
                                  //<-- SEE HERE
                                  fillColor: Colors.green.withOpacity(0.1),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  contentPadding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 30)
                                      .flipped,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'required';
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              Center(
                                child: addPhotoButton(
                                    context: context,
                                    text: 'add_ads',
                                    onPressed: () async {
                                      if (!_formKey.currentState!.validate()) {
                                        return;
                                      }

                                      bool submit = await _showSubmitPay();
                                      if (submit == true) {
                                        Navigator.of(context).pop(true);
                                      } else {
                                        Navigator.of(context).pop(false);
                                      }
                                    }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
              );
            },
          ),
        );
      },
    );
  }

  Future<bool> _showSubmitPay() async {
    return await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  AppLocalizations.of(context).translate('service_fee'),
                  style: const TextStyle(
                      color: AppColor.backgroundColor,
                      fontWeight: FontWeight.w700),
                ),
                content: Text(
                  '${AppLocalizations.of(context).translate('you_should_pay')} $_totalPrice',
                  style: const TextStyle(
                    color: AppColor.backgroundColor,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      AppLocalizations.of(context).translate('cancel'),
                      style: const TextStyle(color: AppColor.red),
                    ),
                  ),
                  BlocBuilder<AuthBloc, AuthState>(
                    bloc: authBloc,
                    builder: (context, authState) {
                      return TextButton(
                        onPressed: () {
                          // String amount = (_totalPrice * 100).toString();
                          // makePayment(
                          //   amount: amount,
                          //   currency: 'aed',
                          //   email: authState is Authenticated ? authState.user.userInfo.email ?? '' : '',
                          //   name: authState is Authenticated ? authState.user.userInfo.username ?? '' : '',
                          // );
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          AppLocalizations.of(context).translate('submit'),
                          style:
                              const TextStyle(color: AppColor.backgroundColor),
                        ),
                      );
                    },
                  ),
                ],
              );
            }) ??
        false;
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
            InkWell(
              onTap: onTap,
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
    );
  }
}
