import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/company_service/company_service.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../injection_container.dart';
import '../../core/constant/colors.dart';
import '../../core/helpers/share_image_function.dart';
import '../../core/widgets/background_widget.dart';
import '../../core/widgets/phone_call_button.dart';
import '../../core/widgets/screen_loader.dart';
import '../../core/widgets/whatsapp_button.dart';
import '../widgets/build_rating.dart';
import '../widgets/image_free_zone_widget.dart';
import 'local_company_bloc/local_company_bloc.dart';

class CompanyServiceDetailsScreen extends StatefulWidget {
  final CompanyService companyService;
  const CompanyServiceDetailsScreen({super.key, required this.companyService});

  @override
  State<CompanyServiceDetailsScreen> createState() =>
      _CompanyServiceDetailsScreenState();
}

class _CompanyServiceDetailsScreenState
    extends State<CompanyServiceDetailsScreen>
    with ScreenLoader<CompanyServiceDetailsScreen> {
  final rateBloc = sl<LocalCompanyBloc>();

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        widget: BlocListener<LocalCompanyBloc, LocalCompanyState>(
          bloc: rateBloc,
          listener: (context, state) {
            if (state is RateCompanyServiceInProgress) {
              startLoading();
            } else if (state is RateCompanyServiceFailure) {
              stopLoading();

              final failure = state.message;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    failure,
                    style: const TextStyle(
                      color: AppColor.white,
                    ),
                  ),
                  backgroundColor: AppColor.red,
                ),
              );
            } else if (state is RateCompanyServiceSuccess) {
              stopLoading();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  AppLocalizations.of(context).translate('success'),
                ),
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ));
            }
          },
          child: Padding(
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
                        imageUrl: widget.companyService.imageUrl ?? '',
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
                                widget.companyService.title,
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
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 16.w,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    widget.companyService.price != null
                                        ? Text(
                                            '${AppLocalizations.of(context).translate('price')} : ${widget.companyService.price} AED',
                                            style: TextStyle(
                                                color: AppColor.colorOne,
                                                fontSize: 17.sp,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : const SizedBox(),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            await shareImageWithDescription(
                                                imageUrl: widget.companyService
                                                        .imageUrl ??
                                                    '',
                                                description: widget
                                                    .companyService.title);
                                          },
                                          icon: const Icon(
                                            Icons.share,
                                            color: AppColor.backgroundColor,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {},
                                          icon: const Icon(
                                            Icons.favorite,
                                            color: AppColor.backgroundColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => showServiceRating(
                                    context: context,
                                    serviceBloc: rateBloc,
                                    id: widget.companyService.id,
                                    userRate:
                                        widget.companyService.averageRating ??
                                            0),
                                child: RatingBar.builder(
                                  minRating: 1,
                                  maxRating: 5,
                                  initialRating:
                                      widget.companyService.averageRating ?? 0,
                                  itemSize: 25,
                                  ignoreGestures: true,
                                  itemBuilder: (context, _) {
                                    return const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    );
                                  },
                                  allowHalfRating: true,
                                  updateOnDrag: true,
                                  onRatingUpdate: (rating) {},
                                ),
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
                            widget.companyService.description,
                            style:
                                TextStyle(color: Colors.grey, fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${AppLocalizations.of(context).translate('images')} :',
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: 17.sp,
                          ),
                        ),
                        widget.companyService.serviceImageList?.isNotEmpty ==
                                true
                            ? GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: widget
                                    .companyService.serviceImageList?.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.94),
                                itemBuilder: (BuildContext context, index) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(25.0),
                                    child: ListOfPictures(
                                      img: widget.companyService
                                          .serviceImageList![index],
                                    ),
                                  );
                                })
                            : GestureDetector(
                                onTap: () {},
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('no_images'),
                                  style: TextStyle(
                                    color: AppColor.mainGrey,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 120.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PhoneCallWidget(
                phonePath: widget.companyService.whatsAppNumber ?? ""),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  AppColor.backgroundColor,
                ),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                )),
                fixedSize: MaterialStateProperty.all(
                  Size.fromWidth(100),
                ),
              ),
              child: Text(AppLocalizations.of(context).translate('chat')),
            ),
            WhatsAppButton(
                whatsappNumber: widget.companyService.whatsAppNumber ?? ''),
          ],
        ),
      ),
    );
  }
}
