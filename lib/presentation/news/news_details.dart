import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/news/entities/news.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';

class NewsDetails extends StatelessWidget {
  const NewsDetails({super.key, required this.news});

  final News news;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: BackgroundWidget(
          widget: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ListView(
              children: [
                SizedBox(
                  height: size.height * 0.4,
                  child: CachedNetworkImage(
                    imageUrl: news.imgUrl,
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  // height: size.height * 0.05,
                  child: Text(
                    news.date,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                        color: Colors.black),
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  child: Text(
                    news.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  alignment: Alignment.topCenter,
                  child: Text(
                    news.description,
                    style: TextStyle(fontSize: 13.sp, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
