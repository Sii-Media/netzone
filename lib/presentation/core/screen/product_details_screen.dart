import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';
import 'package:netzoon/presentation/cart/blocs/cart_bloc/cart_bloc_bloc.dart';
import 'package:netzoon/presentation/categories/widgets/free_zone_video_widget.dart';
import 'package:netzoon/presentation/categories/widgets/image_free_zone_widget.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/price_suggestion_button.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../helpers/share_image_function.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.item});
  final CategoryProducts item;
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
                        imageUrl: item.imageUrl,
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
                                  '${AppLocalizations.of(context).translate('price')} : ${item.price}',
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
                                            imageUrl: item.imageUrl,
                                            description: item.name);
                                      },
                                      icon: const Icon(
                                        Icons.share,
                                        color: AppColor.backgroundColor,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.favorite_border,
                                      color: AppColor.backgroundColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 7.h,
                            ),
                            Text(
                              item.name,
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
                        Text(
                          AppLocalizations.of(context).translate('details'),
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: 17.sp,
                          ),
                        ),
                        SizedBox(
                          height: 7.h,
                        ),
                        titleAndInput(
                          title:
                              AppLocalizations.of(context).translate('categ'),
                          input: item.name,
                        ),
                        SizedBox(
                          height: 7.h,
                        ),
                        item.year != null
                            ? titleAndInput(
                                title: AppLocalizations.of(context)
                                    .translate('year'),
                                input: item.year ?? '',
                              )
                            : Container(),
                        SizedBox(
                          height: 7.h,
                        ),
                        item.propert != null
                            ? titleAndInput(
                                title: AppLocalizations.of(context)
                                    .translate('regional_specifications'),
                                input: item.propert ?? '',
                              )
                            : Container(),
                        SizedBox(
                          height: 7.h,
                        ),
                        titleAndInput(
                          title: AppLocalizations.of(context)
                              .translate('guarantee'),
                          input: 'لا ينطبق',
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
                        AppLocalizations.of(context).translate('desc'),
                        style: TextStyle(
                          color: AppColor.black,
                          fontSize: 17.sp,
                        ),
                      ),
                      Text(
                        item.description,
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
                      item.images?.isNotEmpty == true
                          ? GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: item.images!.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.94),
                              itemBuilder: (BuildContext context, index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(25.0),
                                  child: ListOfPictures(
                                    img: item.images![index],
                                  ),
                                );
                              })
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
                  child: item.vedioUrl != null && item.vedioUrl != ''
                      ? VideoFreeZoneWidget(
                          title:
                              "${AppLocalizations.of(context).translate('vedio')}  : ",
                          vediourl: item.vedioUrl ?? '',
                        )
                      : Text(
                          AppLocalizations.of(context).translate('no_vedio'),
                          style: TextStyle(
                            color: AppColor.mainGrey,
                            fontSize: 15.sp,
                          ),
                        ),
                ),
                SizedBox(
                  height: 50.h,
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
                final cartBloc = context.read<CartBlocBloc>();
                final cartItems = cartBloc.state.props;
                if (cartItems.any((elm) => elm.id == item.id)) {
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
                  cartBloc.add(AddToCart(product: item));
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
