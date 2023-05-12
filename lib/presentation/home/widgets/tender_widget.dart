import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/tenders/entities/tendersItems/tender_item.dart';
import 'package:netzoon/presentation/utils/convert_date_to_string.dart';

class TenderWidget extends StatelessWidget {
  const TenderWidget({
    super.key,
    required this.tenders,
    required this.buttonText,
    required this.subTitle,
    required this.desTitle1,
    required this.desTitle2,
  });

  final List<TenderItem> tenders;
  final String buttonText;
  final String subTitle;
  final String desTitle1;
  final String desTitle2;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: tenders.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return SizedBox(
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
                              padding: const EdgeInsets.symmetric(vertical: 10),
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
                                          tenders[index].nameAr,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20.sp),
                                        ),
                                        SizedBox(
                                          height: 8.0.h,
                                        ),
                                        Text(
                                          '$subTitle : ${tenders[index].companyName}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.sp,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8.0.h,
                                        ),
                                        Text(
                                          '$desTitle1: ${convertDateToString(tenders[index].startDate)}',
                                          style: TextStyle(
                                              color: Colors.orange,
                                              fontSize: 13.sp),
                                        ),
                                        SizedBox(
                                          height: 4.h,
                                        ),
                                        Text(
                                          '$desTitle2 : ${convertDateToString(tenders[index].endDate)}',
                                          style: TextStyle(
                                              color: Colors.orange,
                                              fontSize: 13.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(25.0),
                                    // child: Image.network(
                                    //   tenders[index].imgUrl,
                                    //   fit: BoxFit.fitHeight,
                                    //   width: 170.w,
                                    //   height: 150.h,
                                    // ),
                                    child: CachedNetworkImage(
                                      imageUrl: tenders[index].type,
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
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF5776a5),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      //shadowColor: Colors.black,
                                      //  elevation: 5
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      textStyle: const TextStyle(fontSize: 15)),
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
          );
        });
  }
}
