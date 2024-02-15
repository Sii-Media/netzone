import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/helpers/share_image_function.dart';
import 'package:netzoon/presentation/core/screen/product_details_screen.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/price_suggestion_button.dart';
import 'package:netzoon/presentation/favorites/favorite_blocs/favorites_bloc.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../cart/blocs/cart_bloc/cart_bloc_bloc.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen(
      {super.key, required this.products, required this.index});

  final List<CategoryProducts> products;
  final int index;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToIndex(widget.index);
    });
    super.initState();
  }

  void scrollToIndex(int index) {
    _scrollController.animateTo(
      640.0.h * index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        isHome: false,
        widget: Padding(
          padding: EdgeInsets.only(bottom: 20.0.h),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: widget.products.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Product(
                      product: widget.products[index],
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Product extends StatefulWidget {
  const Product({
    super.key,
    required this.product,
  });
  final CategoryProducts product;

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  bool isFavorite = false;
  late FavoritesBloc favBloc;

  @override
  void initState() {
    favBloc = BlocProvider.of<FavoritesBloc>(context);
    favBloc.add(IsFavoriteEvent(productId: widget.product.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController input = TextEditingController();
    return Padding(
      padding: const EdgeInsets.only(
        top: 2,
        bottom: 11,
      ),
      child: SizedBox(
        height: 630.h,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ProductDetailScreen(item: widget.product.id);
            }));
          },
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 2,
                  child: CachedNetworkImage(
                    imageUrl: widget.product.imageUrl,
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
                  height: 10.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // IconButton(
                              //   onPressed: () {},
                              //   icon: const Icon(
                              //     Icons.favorite_border,
                              //   ),
                              // ),
                              BlocBuilder<FavoritesBloc, FavoritesState>(
                                builder: (context, state) {
                                  if (state is IsFavoriteState) {
                                    isFavorite = state.isFavorite;
                                  }
                                  return IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (isFavorite) {
                                          context.read<FavoritesBloc>().add(
                                                RemoveItemEvent(
                                                    productId:
                                                        widget.product.id),
                                              );
                                        } else {
                                          context.read<FavoritesBloc>().add(
                                                AddItemToFavoritesEvent(
                                                  productId: widget.product.id,
                                                ),
                                              );
                                        }
                                      });
                                    },
                                    icon: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 22.sp,
                                      color: isFavorite
                                          ? AppColor.red
                                          : AppColor.backgroundColor,
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              IconButton(
                                onPressed: () async {
                                  // final urlImage = product.imageUrl;
                                  // final url = Uri.parse(urlImage);
                                  // final response = await http.get(url);
                                  // final bytes = response.bodyBytes;

                                  // final temp = await getTemporaryDirectory();
                                  // final path = '${temp.path}/image.jpg';
                                  // File(path).writeAsBytesSync(bytes);
                                  // // ignore: deprecated_member_use
                                  // await Share.shareFiles(
                                  //   [path],
                                  //   text: 'This is Amazing',
                                  //   sharePositionOrigin: Rect.fromPoints(
                                  //     const Offset(2, 2),
                                  //     const Offset(3, 3),
                                  //   ),
                                  // );
                                  await shareImageWithDescription(
                                      imageUrl: widget.product.imageUrl,
                                      subject: widget.product.name,
                                      description:
                                          'https://www.netzoon.com/home/product/${widget.product.id}');
                                },
                                icon: const Icon(
                                  Icons.share,
                                ),
                              )
                            ],
                          ),
                          Text(
                            '${AppLocalizations.of(context).translate('price')} : ${widget.product.price}',
                            style: TextStyle(
                                color: AppColor.colorOne,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
                    // Text(
                    //   '${AppLocalizations.of(context).translate('Product details')}: ',
                    //   style: TextStyle(color: Colors.grey[600], fontSize: 16.sp),
                    // ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: Text(
                        widget.product.description,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      child: Text(AppLocalizations.of(context)
                          .translate('add_to_cart')),
                      onPressed: () {
                        // final cartBloc = sl<CartBlocBloc>();
                        final cartBloc = context.read<CartBlocBloc>();
                        final cartItems = cartBloc.state.props;
                        if (cartItems
                            .any((elm) => elm.id == widget.product.id)) {
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
                          cartBloc.add(AddToCart(product: widget.product));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
