import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/categories/entities/local_company.dart';
import 'package:netzoon/presentation/categories/widgets/product_details.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';

class LocalCompanyProfileScreen extends StatefulWidget {
  final LocalCompany localCompany;
  const LocalCompanyProfileScreen({super.key, required this.localCompany});

  @override
  State<LocalCompanyProfileScreen> createState() =>
      _LocalCompanyProfileScreenState();
}

class _LocalCompanyProfileScreenState extends State<LocalCompanyProfileScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final TextEditingController search = TextEditingController();
    // final TabController tabController = TabController(length: 3, vsync: this);

    Size size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: SizedBox(
            height: size.height,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.30,
                    decoration:
                        const BoxDecoration(color: AppColor.backgroundColor),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/00.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.18,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(right: 5.0, bottom: 5.0),
                          child: TextFormField(
                            style: const TextStyle(color: Colors.black),
                            controller: search,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColor.white,
                              suffixIcon: InkWell(
                                  child: const Icon(Icons.search),
                                  onTap: () {}),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              hintText: 'البحث في netzoon.com',
                              alignLabelWithHint: true,
                              hintStyle: TextStyle(
                                fontSize: 8.sp,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 30),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 135.w,
                        height: 130.h,
                        padding: const EdgeInsets.only(left: 0, right: 5),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/logo.png"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 144.h,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: widget.localCompany.imgUrl,
                          width: 120,
                          height: 120,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 270.h,
                  right: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 20),
                    height: size.height,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.localCompany.description,
                                style: TextStyle(
                                  color: AppColor.black,
                                  fontSize: 16.sp,
                                ),
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      AppColor.backgroundColor),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  )),
                                ),
                                child: const Text('follow'),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          SizedBox(
                            // height: 50.h,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Rating',
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                      Text(
                                        '1/10',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Products',
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                      Text(
                                        '10',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Views',
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                      Text(
                                        '1/10',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          SizedBox(
                            // height: 50.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Container(
                                    height: 50,
                                    width: 170,
                                    decoration: const BoxDecoration(
                                      color: AppColor.backgroundColor,
                                      // borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.monetization_on,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            'مزاد لايف (قريباً)',
                                            style: TextStyle(
                                              // color: Colors.black,
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Container(
                                    height: 50,
                                    width: 170,
                                    decoration: const BoxDecoration(
                                      color: AppColor.backgroundColor,
                                      // borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.chat,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            'خدمة العملاء',
                                            style: TextStyle(
                                              // color: Colors.black,
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: SizedBox(
                              child: Column(
                                children: [
                                  TabBar(
                                    // controller: tabController,
                                    tabs: [
                                      Text(
                                        'المنتجات',
                                        style: TextStyle(
                                          color: AppColor.black,
                                          fontSize: 17.sp,
                                        ),
                                      ),
                                      Text(
                                        'المستندات',
                                        style: TextStyle(
                                          color: AppColor.black,
                                          fontSize: 17.sp,
                                        ),
                                      ),
                                      Text(
                                        'من نحن',
                                        style: TextStyle(
                                          color: AppColor.black,
                                          fontSize: 17.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    // color: Colors.red,
                                    height: size.height,
                                    child: TabBarView(
                                      children: [
                                        GridView.builder(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  childAspectRatio: 0.95,
                                                  crossAxisSpacing: 10.w,
                                                  mainAxisSpacing: 10.h),
                                          shrinkWrap: true,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemCount:
                                              widget.localCompany.images.length,
                                          itemBuilder: (context, index) {
                                            return ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20)),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return ProductDetailsScreen(
                                                          products: widget
                                                              .localCompany
                                                              .images,
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: CachedNetworkImage(
                                                  imageUrl: widget.localCompany
                                                      .images[index],
                                                  height: 60,
                                                  width: 60,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        Container(
                                          padding:
                                              const EdgeInsets.only(top: 30),
                                          child: const Text(
                                            "لا يوجد مستندات",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: AppColor.black,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.localCompany.desc2,
                                              style: TextStyle(
                                                color: AppColor.black,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Text(
                                              widget.localCompany.mobile,
                                              style: TextStyle(
                                                color: AppColor.black,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Text(
                                              widget.localCompany.mail,
                                              style: TextStyle(
                                                color: AppColor.black,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Text(
                                              widget.localCompany.website,
                                              style: TextStyle(
                                                color: AppColor.black,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   height: 200,
                          // ),
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
    );
  }
}
