import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/company_service/company_service.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../../core/constant/colors.dart';
import '../../core/widgets/background_widget.dart';

class CompanyServiceDetailsScreen extends StatelessWidget {
  final CompanyService companyService;
  const CompanyServiceDetailsScreen({super.key, required this.companyService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        widget: Padding(
          padding: EdgeInsets.only(bottom: 20.0.h),
          child: SingleChildScrollView(
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 2,
                    child: CachedNetworkImage(
                      imageUrl: companyService.imageUrl ?? '',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              companyService.title,
                              style: TextStyle(
                                color: AppColor.backgroundColor,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            // Row(
                            //   children: [
                            //     IconButton(
                            //       onPressed: () {},
                            //       icon: const Icon(
                            //         Icons.favorite_border,
                            //       ),
                            //     ),
                            //     SizedBox(
                            //       width: 10.w,
                            //     ),
                            //     IconButton(
                            //       onPressed: () async {
                            //         // final urlImage = product.imageUrl;
                            //         // final url = Uri.parse(urlImage);
                            //         // final response = await http.get(url);
                            //         // final bytes = response.bodyBytes;

                            //         // final temp = await getTemporaryDirectory();
                            //         // final path = '${temp.path}/image.jpg';
                            //         // File(path).writeAsBytesSync(bytes);
                            //         // // ignore: deprecated_member_use
                            //         // await Share.shareFiles([path],
                            //         //     text: 'This is Amazing');
                            //       },
                            //       icon: const Icon(
                            //         Icons.share,
                            //       ),
                            //     )
                            //   ],
                            // ),
                            Text(
                              '${AppLocalizations.of(context).translate('price')} : ${companyService.price} AED',
                              style: TextStyle(
                                  color: AppColor.colorOne,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      // Text(
                      //   '${AppLocalizations.of(context).translate('Product details')}: ',
                      //   style: TextStyle(color: Colors.grey[600], fontSize: 16.sp),
                      // ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: Text(
                          companyService.description,
                          style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 80.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
