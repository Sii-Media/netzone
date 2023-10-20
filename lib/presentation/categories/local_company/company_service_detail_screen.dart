import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/company_service/company_service.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:video_player/video_player.dart';

import '../../../injection_container.dart';
import '../../auth/blocs/auth_bloc/auth_bloc.dart';
import '../../core/constant/colors.dart';
import '../../core/helpers/share_image_function.dart';
import '../../core/widgets/background_widget.dart';
import '../../core/widgets/phone_call_button.dart';
import '../../core/widgets/screen_loader.dart';
import '../../core/widgets/whatsapp_button.dart';
import '../widgets/build_rating.dart';
import '../widgets/image_free_zone_widget.dart';
import 'edit_company_service_screen.dart';
import 'local_company_bloc/local_company_bloc.dart';

class CompanyServiceDetailsScreen extends StatefulWidget {
  final CompanyService companyService;
  final String? callNumber;
  const CompanyServiceDetailsScreen(
      {super.key, required this.companyService, this.callNumber});

  @override
  State<CompanyServiceDetailsScreen> createState() =>
      _CompanyServiceDetailsScreenState();
}

class _CompanyServiceDetailsScreenState
    extends State<CompanyServiceDetailsScreen>
    with ScreenLoader<CompanyServiceDetailsScreen> {
  final rateBloc = sl<LocalCompanyBloc>();
  final authBloc = sl<AuthBloc>();
  final deleteBloc = sl<LocalCompanyBloc>();
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  @override
  void initState() {
    authBloc.add(AuthCheckRequested());
    _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.companyService.vedioUrl ?? ''))
      ..initialize().then((_) {
        setState(() {});
      });
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9,
    );
    _videoPlayerController.setLooping(true);
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        isHome: false,
        widget: BlocListener<LocalCompanyBloc, LocalCompanyState>(
          bloc: deleteBloc,
          listener: (context, state) {
            if (state is DeleteCompanyServiceInProgress) {
              startLoading();
            } else if (state is DeleteCompanyServiceFailure) {
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
            } else if (state is DeleteCompanyServiceSuccess) {
              stopLoading();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  AppLocalizations.of(context).translate('success'),
                ),
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ));
              Navigator.of(context).pop();
            }
          },
          child: BlocListener<LocalCompanyBloc, LocalCompanyState>(
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
              padding: EdgeInsets.symmetric(vertical: 20.h),
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
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Padding(
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
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 16.w,
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
                                                  imageUrl: widget
                                                          .companyService
                                                          .imageUrl ??
                                                      '',
                                                  description: widget
                                                      .companyService.title);
                                            },
                                            icon: Icon(
                                              Icons.share,
                                              color: AppColor.backgroundColor,
                                              size: 22.sp,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          IconButton(
                                            onPressed: () async {},
                                            icon: Icon(
                                              Icons.favorite,
                                              color: AppColor.backgroundColor,
                                              size: 22.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 16.w,
                                  child: Row(
                                    children: [
                                      Text(
                                        '${widget.companyService.averageRating}',
                                        style: TextStyle(
                                            color: AppColor.secondGrey,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      GestureDetector(
                                        onTap: () => showServiceRating(
                                            context: context,
                                            serviceBloc: rateBloc,
                                            id: widget.companyService.id,
                                            userRate: widget.companyService
                                                    .averageRating ??
                                                0),
                                        child: RatingBar.builder(
                                          minRating: 1,
                                          maxRating: 5,
                                          initialRating: widget.companyService
                                                  .averageRating ??
                                              0,
                                          itemSize: 18.sp,
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
                                      Text(
                                        '(${widget.companyService.totalRatings} ${AppLocalizations.of(context).translate('review')})',
                                        style: TextStyle(
                                          color: AppColor.secondGrey,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      BlocBuilder<AuthBloc, AuthState>(
                                        bloc: authBloc,
                                        builder: (context, authState) {
                                          if (authState is Authenticated) {
                                            if (authState.user.userInfo.id ==
                                                widget
                                                    .companyService.owner.id) {
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return EditCompanyServiceScreen(
                                                          companyService: widget
                                                              .companyService,
                                                        );
                                                      }));
                                                    },
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      color: AppColor
                                                          .backgroundColor,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      deleteBloc.add(
                                                          DeleteCompanyServiceEvent(
                                                              id: widget
                                                                  .companyService
                                                                  .id));
                                                    },
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: AppColor.red,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }
                                          }
                                          return Container();
                                        },
                                      )
                                    ],
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
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            child: Text(
                              widget.companyService.description,
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 14.sp),
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
                                          childAspectRatio: 0.92),
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
                          const Divider(),
                          Text(
                            '${AppLocalizations.of(context).translate('vedio')} :',
                            style: TextStyle(
                              color: AppColor.black,
                              fontSize: 17.sp,
                            ),
                          ),
                          widget.companyService.vedioUrl != null
                              ? AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Chewie(
                                    controller: _chewieController,
                                  ),
                                )
                              : Text(
                                  AppLocalizations.of(context)
                                      .translate('no_vedio'),
                                  style: TextStyle(
                                    color: AppColor.mainGrey,
                                    fontSize: 15.sp,
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
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60.0.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PhoneCallWidget(
                phonePath: widget.callNumber ??
                    widget.companyService.whatsAppNumber ??
                    '',
                title: AppLocalizations.of(context).translate('call')),
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
                  Size.fromWidth(100.w),
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
