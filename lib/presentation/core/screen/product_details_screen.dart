import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/cart/blocs/cart_bloc/cart_bloc_bloc.dart';
import 'package:netzoon/presentation/categories/widgets/image_free_zone_widget.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/on_failure_widget.dart';
import 'package:netzoon/presentation/core/widgets/price_suggestion_button.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:netzoon/presentation/favorites/favorite_blocs/favorites_bloc.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:video_player/video_player.dart';
import '../../../injection_container.dart';
import '../../auth/blocs/auth_bloc/auth_bloc.dart';
import '../../categories/widgets/build_rating.dart';
import '../../home/blocs/elec_devices/elec_devices_bloc.dart';
import '../blocs/country_bloc/country_bloc.dart';
import '../helpers/get_currency_of_country.dart';
import '../helpers/share_image_function.dart';
import 'edit_product_screen.dart';

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

  @override
  void initState() {
    productBloc.add(GetProductByIdEvent(productId: widget.item));
    favBloc = BlocProvider.of<FavoritesBloc>(context);
    favBloc.add(IsFavoriteEvent(productId: widget.item));
    countryBloc = BlocProvider.of<CountryBloc>(context);
    countryBloc.add(GetCountryEvent());
    _videoPlayerController = VideoPlayerController.network('')
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
          widget: RefreshIndicator(
            onRefresh: () async {
              productBloc.add(GetProductByIdEvent(productId: widget.item));
            },
            color: AppColor.white,
            backgroundColor: AppColor.backgroundColor,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 30.0.h),
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
                    child: BlocBuilder<CountryBloc, CountryState>(
                      bloc: countryBloc,
                      builder: (context, countryState) {
                        if (countryState is CountryInitial) {
                          return BlocBuilder<ElecDevicesBloc, ElecDevicesState>(
                            bloc: productBloc,
                            builder: (context, state) {
                              if (state is ElecDevicesInProgress) {
                                return SizedBox(
                                  height: MediaQuery.of(context).size.height -
                                      120.h,
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
                                _videoPlayerController = VideoPlayerController
                                    .network(state.product.vedioUrl ?? '')
                                  ..initialize().then((_) {
                                    // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
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
                                          CachedNetworkImage(
                                            imageUrl: state.product.imageUrl,
                                            width: 700.w,
                                            height: 200.h,
                                            fit: BoxFit.contain,
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          '${AppLocalizations.of(context).translate('price')}: ',
                                                          style: const TextStyle(
                                                              color: AppColor
                                                                  .colorOne,
                                                              fontSize: 20,
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
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                    text:
                                                                        '${state.product.price}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      decoration: state.product.discountPercentage !=
                                                                              null
                                                                          ? TextDecoration
                                                                              .lineThrough
                                                                          : TextDecoration
                                                                              .none,
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
                                                          onPressed: () async {
                                                            await shareImageWithDescription(
                                                                imageUrl: state
                                                                    .product
                                                                    .imageUrl,
                                                                description:
                                                                    state
                                                                        .product
                                                                        .name);
                                                          },
                                                          icon: const Icon(
                                                            Icons.share,
                                                            color: AppColor
                                                                .backgroundColor,
                                                          ),
                                                        ),
                                                        BlocBuilder<
                                                            FavoritesBloc,
                                                            FavoritesState>(
                                                          builder:
                                                              (context, state) {
                                                            if (state
                                                                is IsFavoriteState) {
                                                              isFavorite = state
                                                                  .isFavorite;
                                                            }
                                                            return IconButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  if (isFavorite) {
                                                                    context
                                                                        .read<
                                                                            FavoritesBloc>()
                                                                        .add(
                                                                          RemoveItemEvent(
                                                                              productId: widget.item),
                                                                        );
                                                                  } else {
                                                                    context
                                                                        .read<
                                                                            FavoritesBloc>()
                                                                        .add(
                                                                          AddItemToFavoritesEvent(
                                                                            productId:
                                                                                widget.item,
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
                                                state.product
                                                            .discountPercentage !=
                                                        null
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
                                                                fontSize: 20,
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
                                                                children: <
                                                                    TextSpan>[
                                                                  TextSpan(
                                                                      text:
                                                                          '${state.product.priceAfterDiscount}',
                                                                      style:
                                                                          const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                      )),
                                                                  TextSpan(
                                                                    text: '\$ ',
                                                                    style: TextStyle(
                                                                        color: AppColor
                                                                            .backgroundColor,
                                                                        fontSize:
                                                                            12.sp),
                                                                  ),
                                                                  TextSpan(
                                                                    text:
                                                                        '  ${state.product.discountPercentage?.round().toString()}% ${AppLocalizations.of(context).translate('OFF')}',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .green,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        fontSize:
                                                                            14.sp),
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
                                                    Text(
                                                      state.product.name,
                                                      style: TextStyle(
                                                        color: AppColor.black,
                                                        fontSize: 22.sp,
                                                      ),
                                                    ),
                                                    BlocBuilder<AuthBloc,
                                                        AuthState>(
                                                      bloc: authBloc,
                                                      builder:
                                                          (context, authState) {
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
                                                                    Navigator.of(
                                                                            context)
                                                                        .push(MaterialPageRoute(builder:
                                                                            (context) {
                                                                      return EditProductScreen(
                                                                        item: state
                                                                            .product,
                                                                      );
                                                                    }));
                                                                  },
                                                                  icon:
                                                                      const Icon(
                                                                    Icons.edit,
                                                                    color: AppColor
                                                                        .backgroundColor,
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
                                                                      const Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color:
                                                                        AppColor
                                                                            .red,
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          }
                                                        }
                                                        return Container();
                                                      },
                                                    )
                                                  ],
                                                ),
                                                GestureDetector(
                                                  onTap: () => showProductRating(
                                                      context: context,
                                                      productBloc: rateBloc,
                                                      id: state.product.id,
                                                      userRate: state.product
                                                              .averageRating ??
                                                          0),
                                                  child: RatingBar.builder(
                                                    minRating: 1,
                                                    maxRating: 5,
                                                    initialRating: state.product
                                                            .averageRating ??
                                                        0,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            titleAndInput(
                                              title:
                                                  AppLocalizations.of(context)
                                                      .translate('categ'),
                                              input:
                                                  AppLocalizations.of(context)
                                                      .translate(state.product
                                                          .category.name),
                                            ),
                                            SizedBox(
                                              height: 7.h,
                                            ),
                                            titleAndInput(
                                              title:
                                                  AppLocalizations.of(context)
                                                      .translate('owner'),
                                              input: state
                                                      .product.owner.username ??
                                                  '',
                                            ),
                                            SizedBox(
                                              height: 7.h,
                                            ),
                                            titleAndInput(
                                              title:
                                                  AppLocalizations.of(context)
                                                      .translate('quantity'),
                                              input:
                                                  state.product.quantity == null
                                                      ? 1.toString()
                                                      : state.product.quantity
                                                          .toString(),
                                            ),
                                            SizedBox(
                                              height: 7.h,
                                            ),
                                            state.product.color != null &&
                                                    state.product.color != ''
                                                ? titleAndInput(
                                                    title: AppLocalizations.of(
                                                            context)
                                                        .translate('color'),
                                                    input:
                                                        state.product.color ??
                                                            '')
                                                : const SizedBox(),
                                            SizedBox(
                                              height: 7.h,
                                            ),
                                            state.product.year != null
                                                ? titleAndInput(
                                                    title: AppLocalizations.of(
                                                            context)
                                                        .translate('year'),
                                                    input: state.product.year ??
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
                                                    title: AppLocalizations.of(
                                                            context)
                                                        .translate('condition'),
                                                    input: state.product
                                                            .condition ??
                                                        '',
                                                  )
                                                : const SizedBox(),
                                            SizedBox(
                                              height: 7.h,
                                            ),
                                            titleAndInput(
                                              title:
                                                  AppLocalizations.of(context)
                                                      .translate('guarantee'),
                                              input: state.product.guarantee ==
                                                      true
                                                  ? AppLocalizations.of(context)
                                                      .translate('applies')
                                                  : AppLocalizations.of(context)
                                                      .translate(
                                                          'do not apply'),
                                            ),
                                            SizedBox(
                                              height: 7.h,
                                            ),
                                            state.product.address != null &&
                                                    state.product.address != ''
                                                ? titleAndInput(
                                                    title: AppLocalizations.of(
                                                            context)
                                                        .translate('address'),
                                                    input:
                                                        state.product.address ??
                                                            '',
                                                  )
                                                : const SizedBox(),
                                            SizedBox(
                                              height: 7.h,
                                            ),
                                            state.product.madeIn != null &&
                                                    state.product.madeIn != ''
                                                ? titleAndInput(
                                                    title: AppLocalizations.of(
                                                            context)
                                                        .translate('made_in'),
                                                    input:
                                                        state.product.madeIn ??
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
                                            color: Colors.grey.withOpacity(0.4),
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
                                            color: Colors.grey.withOpacity(0.4),
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
                                          state.product.images?.isNotEmpty ==
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
                                                      itemCount: state.product
                                                          .images!.length,
                                                      // gridDelegate:
                                                      //     const SliverGridDelegateWithFixedCrossAxisCount(
                                                      //         crossAxisCount: 2,
                                                      //         childAspectRatio: 0.94),
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              index) {
                                                        return ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      25.0),
                                                          child: ListOfPictures(
                                                            img: state.product
                                                                .images![index],
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
                                      height: 7.h,
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
                                                    state.product.gifUrl ?? '',
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
                                            color: Colors.grey.withOpacity(0.4),
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
                                                  AppLocalizations.of(context)
                                                      .translate('no_vedio'),
                                                  style: TextStyle(
                                                    color: AppColor.mainGrey,
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
                  ),
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
                height: MediaQuery.of(context).size.height - 120.h,
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
                    return const SizedBox();
                  }
                  if (state.product.owner.userType == 'factory' ||
                      state.product.owner.userType == 'freezone') {
                    if (authState is Authenticated) {
                      if (authState.user.userInfo.userType == 'local_company' ||
                          authState.user.userInfo.userType == 'trader') {
                        return BottomAppBar(
                          height: 60.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                  fixedSize: const MaterialStatePropertyAll(
                                    Size.fromWidth(200),
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
                              PriceSuggestionButton(input: input),
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            fixedSize: const MaterialStatePropertyAll(
                              Size.fromWidth(200),
                            ),
                          ),
                          child: Text(AppLocalizations.of(context)
                              .translate('add_to_cart')),
                          onPressed: () {
                            // final cartBloc = sl<CartBlocBloc>();
                            _togglePressed();
                            final cartBloc = context.read<CartBlocBloc>();
                            final cartItems = cartBloc.state.props;
                            if (cartItems
                                .any((elm) => elm.id == state.product.id)) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  AppLocalizations.of(context).translate(
                                      'Product_Already_added_to_cart'),
                                  style: const TextStyle(color: AppColor.white),
                                ),
                                backgroundColor: AppColor.red,
                                duration: const Duration(seconds: 2),
                              ));
                            } else {
                              cartBloc.add(AddToCart(product: state.product));
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
                        PriceSuggestionButton(input: input),
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
