import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/tenders/entities/tender.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/tenders/tender_info_screen.dart';

class ViewAllTendersScreen extends StatelessWidget {
  const ViewAllTendersScreen({super.key, required this.tenders});
  final List<Tender> tenders;
  @override
  Widget build(BuildContext context) {
    // final tendersList = tendersCategrories;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: BackgroundWidget(
          widget: SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: tenders.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return TenderInfoScreen(
                            tender: tenders[index],
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
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
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 4.0.w),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
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
                                                    tenders[index].name,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16.sp),
                                                  ),
                                                  SizedBox(
                                                    height: 8.0.h,
                                                  ),
                                                  Text(
                                                    'اسم الشركة: ${tenders[index].companyName}',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14.sp,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 4.0.h,
                                                  ),
                                                  Text(
                                                    'السعر يبدأ من 20000',
                                                    style: TextStyle(
                                                      color: AppColor
                                                          .backgroundColor,
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 8.0.h,
                                                  ),
                                                  Text(
                                                    'تاريخ البدأ : ${tenders[index].startDate}',
                                                    style: TextStyle(
                                                        color: Colors.orange,
                                                        fontSize: 12.sp),
                                                  ),
                                                  SizedBox(
                                                    height: 4.h,
                                                  ),
                                                  Text(
                                                    'تاريخ الانتهاء : ${tenders[index].endDate}',
                                                    style: TextStyle(
                                                        color: Colors.orange,
                                                        fontSize: 12.sp),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                              // child: Image.network(
                                              //   tenders[index].imgUrl,
                                              //   fit: BoxFit.fitHeight,
                                              //   width: 170.w,
                                              //   height: 150.h,
                                              // ),
                                              child: CachedNetworkImage(
                                                imageUrl: tenders[index].imgUrl,
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xFF5776a5),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                //shadowColor: Colors.black,
                                                //  elevation: 5
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                textStyle: const TextStyle(
                                                    fontSize: 15)),
                                            child: const Text(
                                              'بدء المناقصة',
                                              style: TextStyle(
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
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
