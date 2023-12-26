import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/chat/screens/chat_page_screen.dart';
import 'package:netzoon/presentation/core/helpers/connect_send_bird.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:netzoon/presentation/home/widgets/auth_alert.dart';
import 'package:video_player/video_player.dart';

import '../../injection_container.dart';
import '../auth/blocs/auth_bloc/auth_bloc.dart';
import '../categories/widgets/image_free_zone_widget.dart';
import '../core/constant/colors.dart';
import '../core/helpers/share_image_function.dart';
import '../core/widgets/on_failure_widget.dart';
import '../core/widgets/phone_call_button.dart';
import '../core/widgets/price_suggestion_button.dart';
import '../utils/app_localizations.dart';
import 'blocs/ads/ads_bloc_bloc.dart';
import 'edit_ads_screen.dart';

class AnotherAdsDetails extends StatefulWidget {
  final String adsId;

  const AnotherAdsDetails({super.key, required this.adsId});

  @override
  State<AnotherAdsDetails> createState() => _AnotherAdsDetailsState();
}

class _AnotherAdsDetailsState extends State<AnotherAdsDetails>
    with ScreenLoader<AnotherAdsDetails> {
  final TextEditingController input = TextEditingController();
  final adsBloc = sl<AdsBlocBloc>();
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  final authBloc = sl<AuthBloc>();
  final visitorBloc = sl<AdsBlocBloc>();
  @override
  void initState() {
    super.initState();
    visitorBloc.add(AddAdsVisitorEvent(adsId: widget.adsId));
    adsBloc.add(GetAdsByIdEvent(id: widget.adsId));
    authBloc.add(AuthCheckRequested());
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        isHome: false,
        widget: RefreshIndicator(
          onRefresh: () async {
            adsBloc.add(GetAdsByIdEvent(id: widget.adsId));
          },
          color: AppColor.white,
          backgroundColor: AppColor.backgroundColor,
          child: SingleChildScrollView(
            child: BlocListener<AdsBlocBloc, AdsBlocState>(
              bloc: adsBloc,
              listener: (context, state) {
                if (state is DeleteAdsInProgress) {
                  startLoading();
                } else if (state is DeleteAdsFailure) {
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
                } else if (state is DeleteAdsSuccess) {
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
              child: BlocBuilder<AdsBlocBloc, AdsBlocState>(
                bloc: adsBloc,
                builder: (context, state) {
                  if (state is AdsBlocInProgress) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height - 200,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColor.backgroundColor,
                        ),
                      ),
                    );
                  } else if (state is AdsBlocFailure) {
                    final failure = state.message;
                    return FailureWidget(
                        failure: failure,
                        onPressed: () {
                          adsBloc.add(GetAdsByIdEvent(id: widget.adsId));
                        });
                  } else if (state is GetAdsByIdSuccess) {
                    _videoPlayerController = VideoPlayerController.networkUrl(
                        Uri.parse(state.ads.advertisingVedio ?? ''))
                      ..initialize().then((_) {
                        _videoPlayerController.play();
                        setState(() {});
                      });
                    _chewieController = ChewieController(
                      videoPlayerController: _videoPlayerController,
                      aspectRatio: 16 / 9,
                    );
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  width: 35.r,
                                  height: 35.r,
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
                                  imageUrl: state.ads.owner.profilePhoto ??
                                      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                ),
                              ),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                                state.ads.owner.username ?? '',
                                style: TextStyle(
                                  color: AppColor.backgroundColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ClipRRect(
                          // borderRadius: const BorderRadius.only(
                          //   bottomLeft: Radius.circular(50),
                          //   bottomRight: Radius.circular(50),
                          // ),
                          child: CachedNetworkImage(
                            height: MediaQuery.of(context).size.height / 2.2,
                            width: MediaQuery.of(context).size.width,
                            imageUrl: state.ads.advertisingImage,
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BlocBuilder<AuthBloc, AuthState>(
                                bloc: authBloc,
                                builder: (context, authState) {
                                  if (authState is Authenticated) {
                                    if (authState.user.userInfo.id ==
                                        state.ads.owner.id) {
                                      return Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return EditAdsScreen(
                                                  ads: state.ads,
                                                );
                                              }));
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              color: AppColor.backgroundColor,
                                              size: 15.sp,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              adsBloc.add(DeleteAdsEvent(
                                                  id: state.ads.id));
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: AppColor.red,
                                              size: 15.sp,
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  }
                                  return Container();
                                },
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: AppColor.secondGrey,
                                        size: 15.sp,
                                      ),
                                      Text(
                                        state.ads.advertisingLocation,
                                        style: TextStyle(
                                          color: AppColor.secondGrey,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${AppLocalizations.of(context).translate('num_of_viewers')} :',
                                        style: TextStyle(
                                          color: AppColor.black,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8.0.w,
                                      ),
                                      Text(
                                        state.ads.adsViews == null
                                            ? "0"
                                            : state.ads.adsViews.toString(),
                                        style: TextStyle(
                                          color: AppColor.backgroundColor,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  state.ads.advertisingPrice.isNotEmpty
                                      ? Text(
                                          '${state.ads.advertisingPrice} ${AppLocalizations.of(context).translate('AED')}',
                                          style: TextStyle(
                                              color: AppColor.colorOne,
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : const SizedBox(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // const Icon(
                                      //   Icons.favorite_border,
                                      //   color: AppColor.backgroundColor,
                                      // ),
                                      IconButton(
                                        onPressed: () async {
                                          await shareImageWithDescription(
                                              imageUrl:
                                                  state.ads.advertisingImage,
                                              subject: state.ads.name,
                                              description: state
                                                  .ads.advertisingDescription);
                                        },
                                        icon: Icon(
                                          Icons.share,
                                          color: AppColor.backgroundColor,
                                          size: 15.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 7.h,
                              ),
                              Text(
                                state.ads.name,
                                style: TextStyle(
                                  color: AppColor.black,
                                  fontSize: 20.sp,
                                ),
                              ),
                              SizedBox(
                                height: 7.h,
                              ),
                              Text(
                                state.ads.advertisingDescription,
                                style: TextStyle(
                                  color: AppColor.secondGrey,
                                  fontSize: 15.sp,
                                ),
                              ),
                              const Divider(),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width: 7,
                                      color: Colors.grey.withOpacity(0.4),
                                    ),
                                  ),
                                ),
                                child: Column(
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
                                    state.ads.advertisingImageList
                                                ?.isNotEmpty ==
                                            true
                                        ? GridView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: state.ads
                                                .advertisingImageList?.length,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    childAspectRatio: 0.94),
                                            itemBuilder:
                                                (BuildContext context, index) {
                                              return ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                child: ListOfPictures(
                                                  img: state.ads
                                                          .advertisingImageList![
                                                      index],
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
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width: 7,
                                      color: Colors.grey.withOpacity(0.4),
                                    ),
                                  ),
                                ),
                                child: state.ads.advertisingVedio != null &&
                                        state.ads.advertisingVedio != ''
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${AppLocalizations.of(context).translate('vedio')} :',
                                            style: TextStyle(
                                              color: AppColor.black,
                                              fontSize: 17.sp,
                                            ),
                                          ),
                                          AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child: Chewie(
                                              controller: _chewieController,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        AppLocalizations.of(context)
                                            .translate('no_vedio'),
                                        style: TextStyle(
                                          color: AppColor.mainGrey,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 140.h,
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BlocBuilder<AdsBlocBloc, AdsBlocState>(
        bloc: adsBloc,
        builder: (context, state) {
          if (state is GetAdsByIdSuccess) {
            return BottomAppBar(
              height: 60.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PhoneCallWidget(
                      phonePath: state.ads.owner.firstMobile ?? "",
                      title: AppLocalizations.of(context).translate('call')),
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
                                      authState.user.userInfo.username ?? '',
                                  otherUserId: state.ads.owner.username ?? '',
                                  title: state.ads.owner.username ?? '',
                                  image: state.ads.owner.profilePhoto ?? '',
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
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
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
                  // ElevatedButton(
                  //     onPressed: () {},
                  //     style: ButtonStyle(
                  //       backgroundColor: MaterialStateProperty.all(
                  //         AppColor.backgroundColor,
                  //       ),
                  //       shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(18.0),
                  //       )),
                  //       fixedSize: MaterialStatePropertyAll(
                  //         Size.fromWidth(100.w),
                  //       ),
                  //     ),
                  //     child:
                  //         Text(AppLocalizations.of(context).translate('chat'))),
                  // PriceSuggestionButton(input: input),
                ],
              ),
            );
          } else if (state is AdsBlocInProgress) {
            return SizedBox(
              height: MediaQuery.of(context).size.height - 200,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColor.backgroundColor,
                ),
              ),
            );
          } else if (state is AdsBlocFailure) {
            final failure = state.message;
            return FailureWidget(
                failure: failure,
                onPressed: () {
                  adsBloc.add(GetAdsByIdEvent(id: widget.adsId));
                });
          }
          return Container();
        },
      ),
    );
  }
}
