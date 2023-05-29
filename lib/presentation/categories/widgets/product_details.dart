import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/price_suggestion_button.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.products});

  final List<CategoryProducts> products;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        widget: Padding(
          padding: EdgeInsets.only(bottom: 20.0.h),
          child: ListView.builder(
              itemCount: products.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Product(
                  img: products[index].imageUrl,
                );
              }),
        ),
      ),
    );
  }
}

class Product extends StatelessWidget {
  const Product({
    super.key,
    required this.img,
  });
  final String img;
  @override
  Widget build(BuildContext context) {
    final TextEditingController input = TextEditingController();
    return Padding(
      padding: const EdgeInsets.only(
        top: 2,
        bottom: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2,
            child: CachedNetworkImage(
              imageUrl: img,
              fit: BoxFit.fill,
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
                        const Icon(
                          Icons.favorite_border,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        const Icon(
                          Icons.share,
                        ),
                      ],
                    ),
                    Text(
                      '${AppLocalizations.of(context).translate('price')} : 20000',
                      style: TextStyle(
                          color: AppColor.colorOne,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                PriceSuggestionButton(input: input),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              Text(
                '${AppLocalizations.of(context).translate('Product details')}: ',
                style: TextStyle(color: Colors.grey[600], fontSize: 16.sp),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)
                      .translate('There are no details now'),
                  style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
