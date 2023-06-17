import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';
import 'package:netzoon/presentation/cart/blocs/cart_bloc/cart_bloc_bloc.dart';
import 'package:netzoon/presentation/categories/widgets/image_free_zone_widget.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/price_suggestion_button.dart';
import 'package:netzoon/presentation/favorites/favorite_blocs/favorites_bloc.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:video_player/video_player.dart';
import '../helpers/share_image_function.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen(
      {super.key, required this.item, this.department, this.category});
  final CategoryProducts item;
  final String? department;
  final String? category;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
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

  @override
  void initState() {
    favBloc = BlocProvider.of<FavoritesBloc>(context);
    favBloc.add(IsFavoriteEvent(productId: widget.item.id));
    _videoPlayerController =
        VideoPlayerController.network(widget.item.vedioUrl ?? '')
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
          });
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9,
    );
    _videoPlayerController.setLooping(true);
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController input = TextEditingController();

    return Scaffold(
      body: BackgroundWidget(
        widget: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 8.0, bottom: 30.0.h),
            child: Column(
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
                        imageUrl: widget.item.imageUrl,
                        width: 700.w,
                        height: 200.h,
                        fit: BoxFit.contain,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${AppLocalizations.of(context).translate('price')} : ${widget.item.price}',
                                  style: TextStyle(
                                      color: AppColor.colorOne,
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        await shareImageWithDescription(
                                            imageUrl: widget.item.imageUrl,
                                            description: widget.item.name);
                                      },
                                      icon: const Icon(
                                        Icons.share,
                                        color: AppColor.backgroundColor,
                                      ),
                                    ),
                                    BlocBuilder<FavoritesBloc, FavoritesState>(
                                      builder: (context, state) {
                                        if (state is IsFavoriteState) {
                                          isFavorite = state.isFavorite;
                                        }
                                        return IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (isFavorite) {
                                                context
                                                    .read<FavoritesBloc>()
                                                    .add(
                                                      RemoveItemEvent(
                                                          productId:
                                                              widget.item.id),
                                                    );
                                              } else {
                                                context
                                                    .read<FavoritesBloc>()
                                                    .add(
                                                      AddItemToFavoritesEvent(
                                                        productId:
                                                            widget.item.id,
                                                      ),
                                                    );
                                              }
                                            });
                                          },
                                          icon: Icon(
                                            isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: isFavorite
                                                ? AppColor.red
                                                : AppColor.backgroundColor,
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
                            Text(
                              widget.item.name,
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
                        titleAndInput(
                          title:
                              AppLocalizations.of(context).translate('categ'),
                          input:
                              '${widget.department ?? ''} / ${widget.category ?? ''}',
                        ),
                        SizedBox(
                          height: 7.h,
                        ),
                        titleAndInput(
                          title:
                              AppLocalizations.of(context).translate('owner'),
                          input: widget.item.owner,
                        ),
                        SizedBox(
                          height: 7.h,
                        ),
                        widget.item.year != null
                            ? titleAndInput(
                                title: AppLocalizations.of(context)
                                    .translate('year'),
                                input: widget.item.year ?? '',
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
                        titleAndInput(
                          title: AppLocalizations.of(context)
                              .translate('guarantee'),
                          input: widget.item.guarantee == true
                              ? AppLocalizations.of(context)
                                  .translate('applies')
                              : AppLocalizations.of(context)
                                  .translate('do not apply'),
                        ),
                        SizedBox(
                          height: 7.h,
                        ),
                        widget.item.address != null
                            ? titleAndInput(
                                title: AppLocalizations.of(context)
                                    .translate('address'),
                                input: widget.item.address ?? '',
                              )
                            : const SizedBox(),
                        SizedBox(
                          height: 7.h,
                        ),
                        widget.item.madeIn != null
                            ? titleAndInput(
                                title: AppLocalizations.of(context)
                                    .translate('made_in'),
                                input: widget.item.madeIn ?? '',
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
                        AppLocalizations.of(context).translate('desc'),
                        style: TextStyle(
                          color: AppColor.black,
                          fontSize: 17.sp,
                        ),
                      ),
                      Text(
                        widget.item.description,
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
                      widget.item.images?.isNotEmpty == true
                          ? SizedBox(
                              height: 200.h,
                              // width: 120,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: widget.item.images!.length,
                                  // gridDelegate:
                                  //     const SliverGridDelegateWithFixedCrossAxisCount(
                                  //         crossAxisCount: 2,
                                  //         childAspectRatio: 0.94),
                                  itemBuilder: (BuildContext context, index) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(25.0),
                                      child: ListOfPictures(
                                        img: widget.item.images![index],
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
                  child: widget.item.gifUrl != '' && widget.item.gifUrl != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                widget.item.gifUrl ?? '',
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${AppLocalizations.of(context).translate('vedio')} :',
                        style: TextStyle(
                          color: AppColor.black,
                          fontSize: 17.sp,
                        ),
                      ),
                      widget.item.vedioUrl != null
                          ? AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Chewie(
                                controller: _chewieController,
                              ),
                            )
                          // ? VideoFreeZoneWidget(
                          //     title:
                          //         "${AppLocalizations.of(context).translate('vedio')}  : ",
                          //     vediourl: widget.item.vedioUrl ?? '',
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
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
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
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                )),
                fixedSize: const MaterialStatePropertyAll(
                  Size.fromWidth(200),
                ),
              ),
              child:
                  Text(AppLocalizations.of(context).translate('add_to_cart')),
              onPressed: () {
                // final cartBloc = sl<CartBlocBloc>();
                _togglePressed();
                final cartBloc = context.read<CartBlocBloc>();
                final cartItems = cartBloc.state.props;
                if (cartItems.any((elm) => elm.id == widget.item.id)) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      AppLocalizations.of(context)
                          .translate('Product_Already_added_to_cart'),
                      style: const TextStyle(color: AppColor.white),
                    ),
                    backgroundColor: AppColor.red,
                    duration: const Duration(seconds: 2),
                  ));
                } else {
                  cartBloc.add(AddToCart(product: widget.item));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
