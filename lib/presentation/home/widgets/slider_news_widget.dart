import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/news/entities/news_info.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/news/news_details.dart';

class SliderNewsWidget extends StatelessWidget {
  const SliderNewsWidget({
    super.key,
    required this.controller,
    required this.news,
  });

  final PageController controller;
  final List<News> news;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          PageView.builder(
            allowImplicitScrolling: true,
            controller: controller,
            onPageChanged: (value) {
              // controller.onPageChanged(value);
            },
            physics: const BouncingScrollPhysics(),
            itemCount: news.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CachedNetworkImage(
                                    width: 35.w,
                                    height: 35.h,
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Padding(
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
                                    imageUrl: news[index]
                                            .creator
                                            .profilePhoto ??
                                        'https://www.emaratalyoum.com/polopoly_fs/1.1739617.1681807932!/image/image.jpg',
                                  ),
                                ),
                                SizedBox(
                                  width: 6.w,
                                ),
                                Text(
                                  news[index].creator.username ?? '',
                                  style: TextStyle(
                                    color: AppColor.backgroundColor,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return NewsDetails(
                                      news: news[index],
                                    );
                                  }),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25.0),
                                child: Container(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 1,
                                        )
                                      ]),
                                  child: Column(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: news[index].imgUrl,
                                        fit: BoxFit.fitWidth,
                                        height: 90,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Padding(
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
                                      // Image.network(
                                      //   news[index].imgUrl,
                                      //   fit: BoxFit.fitWidth,
                                      //   height: 90,
                                      //   width: MediaQuery.of(context).size.width,
                                      // ),
                                      Text(
                                        news[index].title,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.sp),
                                        maxLines: 1,
                                        softWrap: false,
                                      ),
                                      Text(
                                        news[index].description,
                                        style: TextStyle(
                                            color:
                                                Colors.grey.withOpacity(0.6)),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        softWrap: false,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: Container(
                    width: 25.r,
                    height: 25.r,
                    color: AppColor.backgroundColor.withOpacity(0.6),
                    child: IconButton(
                      onPressed: () {
                        if (controller.page?.round() == 0) {
                          controller.animateToPage(news.length - 1,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInCirc);
                        } else {
                          controller.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_sharp,
                        size: 10.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: Container(
                    width: 25.r,
                    height: 25.r,
                    color: const Color(0xFF5776a5).withOpacity(0.6),
                    child: IconButton(
                      onPressed: () {
                        if (controller.page?.round() == news.length - 1) {
                          controller.animateToPage(0,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInCirc);
                        } else {
                          controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 10.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
