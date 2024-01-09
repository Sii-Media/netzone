import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:netzoon/domain/company_service/company_service.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/presentation/chat/screens/chat_page_screen.dart';
import 'package:netzoon/presentation/core/helpers/connect_send_bird.dart';
import 'package:netzoon/presentation/core/helpers/show_image_dialog.dart';
import 'package:netzoon/presentation/core/widgets/on_failure_widget.dart';
import 'package:netzoon/presentation/home/widgets/auth_alert.dart';
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
  final String companyServiceId;
  final String? callNumber;
  const CompanyServiceDetailsScreen(
      {super.key, required this.companyServiceId, this.callNumber});

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
  final serviceBloc = sl<LocalCompanyBloc>();
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  @override
  void initState() {
    serviceBloc.add(GetServiceByIdEvent(id: widget.companyServiceId));
    authBloc.add(AuthCheckRequested());
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(''))
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

              final message = state.message;
              final failure = state.failure;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    message,
                    style: const TextStyle(
                      color: AppColor.white,
                    ),
                  ),
                  backgroundColor: AppColor.red,
                ),
              );
              if (failure is UnAuthorizedFailure) {
                while (context.canPop()) {
                  context.pop();
                }
                context.push('/home');
              }
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
            child: BlocBuilder<LocalCompanyBloc, LocalCompanyState>(
              bloc: serviceBloc,
              builder: (context, serviceState) {
                if (serviceState is GetServiceByIdInProgress) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height - 170.h,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.backgroundColor,
                      ),
                    ),
                  );
                } else if (serviceState is GetServiceByIdFailure) {
                  return FailureWidget(
                      failure: 'error',
                      onPressed: () {
                        serviceBloc.add(
                            GetServiceByIdEvent(id: widget.companyServiceId));
                      });
                } else if (serviceState is GetServiceByIdSuccess) {
                  return Padding(
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
                                imageUrl: serviceState.service.imageUrl ?? '',
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        serviceState.service.title,
                                        style: TextStyle(
                                          color: AppColor.backgroundColor,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                16.w,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            serviceState.service.price != null
                                                ? Text(
                                                    '${AppLocalizations.of(context).translate('price')} : ${serviceState.service.price} AED',
                                                    style: TextStyle(
                                                        color:
                                                            AppColor.colorOne,
                                                        fontSize: 17.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : const SizedBox(),
                                            Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () async {
                                                    await shareImageWithDescription(
                                                      imageUrl: serviceState
                                                              .service
                                                              .imageUrl ??
                                                          '',
                                                      description:
                                                          'https://www.netzoon.com/home/services/${serviceState.service.id}',
                                                      subject: serviceState
                                                          .service.title,
                                                    );
                                                  },
                                                  icon: Icon(
                                                    Icons.share,
                                                    color: AppColor
                                                        .backgroundColor,
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
                                                    color: AppColor
                                                        .backgroundColor,
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
                                            MediaQuery.of(context).size.width -
                                                16.w,
                                        child: Row(
                                          children: [
                                            Text(
                                              '${serviceState.service.averageRating}',
                                              style: TextStyle(
                                                  color: AppColor.secondGrey,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            GestureDetector(
                                              onTap: () => showServiceRating(
                                                  context: context,
                                                  serviceBloc: rateBloc,
                                                  id: serviceState.service.id,
                                                  userRate: serviceState.service
                                                          .averageRating ??
                                                      0),
                                              child: RatingBar.builder(
                                                minRating: 1,
                                                maxRating: 5,
                                                initialRating: serviceState
                                                        .service
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
                                              '(${serviceState.service.totalRatings} ${AppLocalizations.of(context).translate('review')})',
                                              style: TextStyle(
                                                color: AppColor.secondGrey,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                            BlocBuilder<AuthBloc, AuthState>(
                                              bloc: authBloc,
                                              builder: (context, authState) {
                                                if (authState
                                                    is Authenticated) {
                                                  if (authState
                                                          .user.userInfo.id ==
                                                      serviceState
                                                          .service.owner.id) {
                                                    return Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        IconButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .push(MaterialPageRoute(
                                                                    builder:
                                                                        (context) {
                                                              return EditCompanyServiceScreen(
                                                                companyService:
                                                                    serviceState
                                                                        .service,
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
                                                                    id: serviceState
                                                                        .service
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
                                    serviceState.service.description,
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
                                serviceState.service.serviceImageList
                                            ?.isNotEmpty ==
                                        true
                                    ? GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: serviceState
                                            .service.serviceImageList?.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                childAspectRatio: 0.92),
                                        itemBuilder:
                                            (BuildContext context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              showImageDialog(
                                                  context,
                                                  serviceState.service
                                                      .serviceImageList!,
                                                  index);
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                              child: ListOfPictures(
                                                img: serviceState.service
                                                    .serviceImageList![index],
                                              ),
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
                                serviceState.service.vedioUrl != null
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
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: BlocBuilder<LocalCompanyBloc, LocalCompanyState>(
        bloc: serviceBloc,
        builder: (context, serviceState) {
          return serviceState is GetServiceByIdSuccess
              ? BottomAppBar(
                  height: 60.0.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PhoneCallWidget(
                          phonePath: widget.callNumber ??
                              serviceState.service.whatsAppNumber ??
                              '',
                          title:
                              AppLocalizations.of(context).translate('call')),
                      // ElevatedButton(
                      //   onPressed: () {

                      //   },
                      //   style: ButtonStyle(
                      //     backgroundColor: MaterialStateProperty.all(
                      //       AppColor.backgroundColor,
                      //     ),
                      //     shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(18.0),
                      //     )),
                      //     fixedSize: MaterialStateProperty.all(
                      //       Size.fromWidth(100.w),
                      //     ),
                      //   ),
                      //   child: Text(AppLocalizations.of(context).translate('chat')),
                      // ),
                      BlocBuilder<AuthBloc, AuthState>(
                        bloc: authBloc,
                        builder: (context, authState) {
                          return ElevatedButton(
                            onPressed: () {
                              if (authState is Authenticated) {
                                // await SendbirdChat.connect(
                                //     authState.user.userInfo
                                //             .username ??
                                //         '');
                                connectWithSendbird(
                                    username:
                                        authState.user.userInfo.username ?? '');
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return ChatPageScreen(
                                      userId:
                                          authState.user.userInfo.username ??
                                              '',
                                      otherUserId:
                                          serviceState.service.owner.username ??
                                              '',
                                      title:
                                          serviceState.service.owner.username ??
                                              '',
                                      image: serviceState
                                              .service.owner.profilePhoto ??
                                          '',
                                    );
                                  }),
                                );
                              } else {
                                authAlert(context);
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                AppColor.backgroundColor,
                              ),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              )),
                              fixedSize: MaterialStateProperty.all(
                                Size.fromWidth(100.w),
                              ),
                            ),
                            child: Text(
                                AppLocalizations.of(context).translate('chat')),
                          );
                        },
                      ),
                      WhatsAppButton(
                          whatsappNumber: widget.callNumber ??
                              serviceState.service.whatsAppNumber ??
                              ''),
                    ],
                  ),
                )
              : const SizedBox();
        },
      ),
    );
  }
}
