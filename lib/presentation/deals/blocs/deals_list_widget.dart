import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/deals/entities/dealsItems/deals_items.dart';
import 'package:netzoon/presentation/deals/deals_details.dart';

import '../../core/constant/colors.dart';

class DealsListWidget extends StatelessWidget {
  const DealsListWidget(
      {super.key,
      required this.deals,
      required this.buttonText,
      required this.subTitle,
      required this.desTitle1,
      required this.desTitle2});
  final List<DealsItems> deals;
  final String buttonText;
  final String subTitle;
  final String desTitle1;
  final String desTitle2;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: deals.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return DealDetails(dealsInfoId: deals[index].id ?? '');
                }),
              );
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: Container(
                        padding: const EdgeInsets.only(bottom: 5),
                        margin: const EdgeInsets.all(5),
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 1,
                          )
                        ]),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            deals[index].name,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.sp),
                                          ),
                                          SizedBox(
                                            height: 8.0.h,
                                          ),
                                          Text(
                                            '$subTitle : ${deals[index].companyName}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13.sp,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0.h,
                                          ),
                                          Text(
                                            '$desTitle1: ${deals[index].prevPrice}',
                                            style: TextStyle(
                                                color: Colors.orange,
                                                fontSize: 12.sp),
                                          ),
                                          SizedBox(
                                            height: 4.h,
                                          ),
                                          Text(
                                            '$desTitle2 : ${deals[index].currentPrice}',
                                            style: TextStyle(
                                                color: Colors.orange,
                                                fontSize: 12.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(25.0),
                                      child: CachedNetworkImage(
                                        imageUrl: deals[index].imgUrl,
                                        fit: BoxFit.fitHeight,
                                        width: 170.w,
                                        height: 150.h,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 4.h),
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                          return DealDetails(
                                              dealsInfoId:
                                                  deals[index].id ?? '');
                                        }),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            AppColor.backgroundColor,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        //shadowColor: Colors.black,
                                        //  elevation: 5
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        textStyle:
                                            const TextStyle(fontSize: 15)),
                                    child: Text(
                                      buttonText,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                              )
                            ],
                          ),
                        )),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
