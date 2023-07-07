import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/screen/product_details_screen.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/price_suggestion_button.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../cart/blocs/cart_bloc/cart_bloc_bloc.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.products});

  final List<CategoryProducts> products;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        widget: Padding(
          padding: EdgeInsets.only(bottom: 20.0.h),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: products.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Product(
                        product: products[index],
                      );
                    }),
              ),
              const SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Product extends StatelessWidget {
  const Product({
    super.key,
    required this.product,
  });
  final CategoryProducts product;
  @override
  Widget build(BuildContext context) {
    final TextEditingController input = TextEditingController();
    return Padding(
      padding: const EdgeInsets.only(
        top: 2,
        bottom: 11,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ProductDetailScreen(item: product.id);
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
                  imageUrl: product.imageUrl,
                  fit: BoxFit.contain,
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
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.favorite_border,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            IconButton(
                              onPressed: () async {
                                final urlImage = product.imageUrl;
                                final url = Uri.parse(urlImage);
                                final response = await http.get(url);
                                final bytes = response.bodyBytes;

                                final temp = await getTemporaryDirectory();
                                final path = '${temp.path}/image.jpg';
                                File(path).writeAsBytesSync(bytes);
                                // ignore: deprecated_member_use
                                await Share.shareFiles([path],
                                    text: 'This is Amazing');
                              },
                              icon: const Icon(
                                Icons.share,
                              ),
                            )
                          ],
                        ),
                        Text(
                          '${AppLocalizations.of(context).translate('price')} : ${product.price}',
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
                      product.description,
                      style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
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
                    child: Text(
                        AppLocalizations.of(context).translate('add_to_cart')),
                    onPressed: () {
                      // final cartBloc = sl<CartBlocBloc>();
                      final cartBloc = context.read<CartBlocBloc>();
                      final cartItems = cartBloc.state.props;
                      if (cartItems.any((elm) => elm.id == product.id)) {
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
                        cartBloc.add(AddToCart(product: product));
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
            ],
          ),
        ),
      ),
    );
  }
}
