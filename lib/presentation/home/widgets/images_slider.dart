import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:netzoon/domain/advertisements/entities/advertisement.dart';
import 'package:netzoon/presentation/advertising/advertising_details.dart';
import 'package:netzoon/presentation/advertising/another_ads_details.dart';

import '../../core/constant/colors.dart';

class SliderImages extends StatelessWidget {
  const SliderImages({
    super.key,
    required this.advertisments,
  });

  final List<Advertisement> advertisments;
//  [
//         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgAmv5h6pjNJG5Tg0EkpCywBfa700quXU6-sJMaIOwuQ&s',
//         'https://hips.hearstapps.com/hmg-prod/images/2023-mclaren-artura-101-1655218102.jpg?crop=1.00xw:0.847xh;0,0.153xh&resize=1200:*',
//         'https://www.bentleymotors.com/content/dam/bentley/Master/homepage%20carousel/1920x1080_bentayga_ewb_2.jpg/_jcr_content/renditions/original.image_file.700.394.file/1920x1080_bentayga_ewb_2.jpg',
//       ]
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: advertisments.map((ads) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return ads.advertisingType == 'car' ||
                        ads.advertisingType == 'planes' ||
                        ads.advertisingType == 'sea_companies' ||
                        ads.advertisingType == 'real_estate'
                    ? AdvertismentDetalsScreen(adsId: ads.id)
                    : AnotherAdsDetails(
                        adsId: ads.id,
                      );
              }),
            );
          },
          child: CachedNetworkImage(
            imageUrl: ads.advertisingImage,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 70.0, vertical: 50),
              child: CircularProgressIndicator(
                value: downloadProgress.progress,
                color: AppColor.backgroundColor,

                // strokeWidth: 10,
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 400.0.h,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) {},
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
