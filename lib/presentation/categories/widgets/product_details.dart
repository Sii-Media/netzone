import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.products});

  final List<String> products;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: BackgroundWidget(
          widget: Padding(
            padding: EdgeInsets.only(bottom: 20.0.h),
            child: ListView.builder(
                itemCount: products.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Product(
                    img: products[index],
                  );
                }),
          ),
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
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              Text(
                'تفاصيل المنتج: ',
                style: TextStyle(color: Colors.grey[600], fontSize: 16.sp),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Text(
                  'لا يوجد تفاصيل الان',
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
