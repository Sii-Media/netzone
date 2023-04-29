import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';

class ImageFreeZoneWidget extends StatelessWidget {
  const ImageFreeZoneWidget({Key? key, required this.companyimages})
      : super(key: key);
  final List<String>? companyimages;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "صور المنطقة الحرة : ",
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColor.black,
            ),
          ),
          GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: companyimages?.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.94),
              itemBuilder: (BuildContext context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: ListOfPictures(
                    img: companyimages![index],
                  ),
                );
              }),
        ],
      ),
    );
  }
}

class ListOfPictures extends StatelessWidget {
  const ListOfPictures({
    super.key,
    required this.img,
  });

  final String img;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          CachedNetworkImage(
            height: 150.h,
            width: MediaQuery.of(context).size.width,
            imageUrl: img,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Icon(
                  Icons.share,
                  color: AppColor.backgroundColor,
                ),
                Icon(
                  Icons.favorite_border,
                  color: AppColor.backgroundColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
