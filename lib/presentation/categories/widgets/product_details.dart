import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/price_suggestion_button.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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
                            final urlImage = img;
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
