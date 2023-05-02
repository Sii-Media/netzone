import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/deals/entities/deals_info.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/data/deals_info.dart';
import 'package:netzoon/presentation/deals/deals_details.dart';

class ViewAllDealsScreen extends StatefulWidget {
  const ViewAllDealsScreen({super.key});

  @override
  State<ViewAllDealsScreen> createState() => _ViewAllDealsScreenState();
}

class _ViewAllDealsScreenState extends State<ViewAllDealsScreen> {
  final dealsInfoList = dealsInfo;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: BackgroundWidget(
            // title: "المناقصات",
            widget: SizedBox(
                height: size.height,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: dealsInfoList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            child: Deals(dealsInfo: dealsInfoList[index]),
                          );
                        },
                      ),
                    )
                  ],
                )),
          ),
        ),
      )),
    );
  }
}

class Deals extends StatelessWidget {
  const Deals({super.key, required this.dealsInfo});

  final DealsInfo dealsInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return DealDetails(
                dealsInfo: dealsInfo,
              );
            }),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25.0),
          child: Container(
            padding: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 1,
              )
            ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          dealsInfo.name,
                          style: TextStyle(
                              color: AppColor.backgroundColor, fontSize: 20.sp),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25.0),
                          child: CachedNetworkImage(
                            imageUrl: dealsInfo.imgUrl,
                            fit: BoxFit.fill,
                            width: 160.w,
                            height: 150.h,
                          ),
                          // child: Image.network(
                          //   dealsInfo.imgUrl,
                          //   fit: BoxFit.fill,
                          //   width: 160.w,
                          //   height: 150.h,
                          // ),
                        ),
                      ],
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "اسم البائع: ${dealsInfo.companyName}",
                              style: TextStyle(
                                color: AppColor.black,
                                fontSize: 15.sp,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "السعر قبل : ",
                                  style: TextStyle(
                                    color: AppColor.backgroundColor,
                                    fontSize: 15.sp,
                                  ),
                                ),
                                Text(
                                  dealsInfo.prepeice,
                                  style: TextStyle(
                                    color: AppColor.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "السعر بعد : ",
                                  style: TextStyle(
                                    color: AppColor.backgroundColor,
                                    fontSize: 15.sp,
                                  ),
                                ),
                                Text(
                                  dealsInfo.currpeice,
                                  style: TextStyle(
                                    color: AppColor.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${dealsInfo.endDate} الصفقة صالحة لغاية ',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 13.sp),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              "متبقي : 13 يوم 10 ساعات 48 دقيقة",
                              style: TextStyle(
                                  color: AppColor.backgroundColor,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 4.h),
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      onPressed: () {
                        // Get.to(ViewDetailsDeals(dealsModel: dealsModel));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.backgroundColor,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          //shadowColor: Colors.black,
                          //  elevation: 5
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          textStyle: const TextStyle(fontSize: 15)),
                      child: const Text("اشتري الان")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}