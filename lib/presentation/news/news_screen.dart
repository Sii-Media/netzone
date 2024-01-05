import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/news/entities/news_comment.dart';
import 'package:netzoon/domain/news/entities/news_info.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/helpers/share_image_function.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/news/blocs/news/news_bloc.dart';
import 'package:netzoon/presentation/news/news_details.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:netzoon/presentation/utils/convert_date_to_string.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../../domain/auth/entities/user.dart';
import '../auth/blocs/auth_bloc/auth_bloc.dart';
import '../core/widgets/no_data_widget.dart';
import '../core/widgets/on_failure_widget.dart';
import 'comments_page.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final newsBloc = sl<NewsBloc>();

  @override
  void initState() {
    super.initState();
    newsBloc.add(GetAllNewsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        isHome: false,
        widget: RefreshIndicator(
          onRefresh: () async {
            newsBloc.add(GetAllNewsEvent());
          },
          color: AppColor.white,
          backgroundColor: AppColor.backgroundColor,
          child: BlocBuilder<NewsBloc, NewsState>(
            bloc: newsBloc,
            builder: (context, state) {
              if (state is NewsInProgress) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.backgroundColor,
                  ),
                );
              } else if (state is NewsFailure) {
                final failure = state.message;
                return FailureWidget(
                  failure: failure,
                  onPressed: () {
                    newsBloc.add(GetAllNewsEvent());
                  },
                );
              } else if (state is NewsSuccess) {
                if (state.news.isEmpty) {
                  return NoDataWidget(
                    onPressed: () {
                      newsBloc.add(GetAllNewsEvent());
                    },
                  );
                }

                return Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 25, 8, 8),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: AllNewsWidget(
                      news: state.news,
                      currentUser: state.currentUser,
                      newsBloc: newsBloc,
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(bottom: 10.0),
      //   child: FloatingActionButton(
      //     onPressed: () {
      //       Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (context) {
      //             return const AddNewScreen();
      //           },
      //         ),
      //       );
      //     },
      //     backgroundColor: AppColor.backgroundColor,
      //     tooltip: 'إضافة خبر',
      //     child: const Icon(
      //       Icons.add,
      //       size: 30,
      //     ),
      //   ),
      // ),
    );
  }
}

class AllNewsWidget extends StatefulWidget {
  const AllNewsWidget(
      {Key? key,
      required this.news,
      required this.currentUser,
      required this.newsBloc})
      : super(key: key);

  final List<News> news;
  final User? currentUser;
  final NewsBloc newsBloc;
  @override
  State<AllNewsWidget> createState() => _AllNewsWidgetState();
}

class _AllNewsWidgetState extends State<AllNewsWidget> {
  List<bool> isLikedList = [];
  final authBloc = sl<AuthBloc>();

  @override
  void initState() {
    super.initState();
    // Initialize the isLikedList with the initial like status for each news item
    isLikedList = List<bool>.generate(
      widget.news.length,
      (index) =>
          widget.news[index].likes?.contains(widget.currentUser?.userInfo.id) ??
          false,
    );
    authBloc.add(AuthCheckRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsState>(
      bloc: widget.newsBloc,
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.news.length,
                itemBuilder: (BuildContext context, index) {
                  final News newsItem = widget.news[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  width: 35.w,
                                  height: 35.h,
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
                                  imageUrl: widget
                                          .news[index].creator.profilePhoto ??
                                      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                ),
                              ),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                                widget.news[index].creator.username ?? '',
                                style: TextStyle(
                                  color: AppColor.backgroundColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 250.h,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return NewsDetails(
                                      newsId: widget.news[index].id ?? '',
                                    );
                                  }),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25.0),
                                child: Card(
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        bottom: 0,
                                        top: 0,
                                        right: 0,
                                        child: CachedNetworkImage(
                                          imageUrl: widget.news[index].imgUrl,
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
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
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          alignment: Alignment.center,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: AppColor.backgroundColor,
                                          child: Column(
                                            children: [
                                              Text(
                                                convertDateToString(widget
                                                        .news[index]
                                                        .createdAt ??
                                                    ''),
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                // height: 70.h,
                                                child: Text(
                                                  widget.news[index].title,
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                    color: Colors.white,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                // height: 30.h,
                                                child: Text(
                                                  widget
                                                      .news[index].description,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: AppColor.white,
                                                    fontSize: 11.sp,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          BlocBuilder<AuthBloc, AuthState>(
                            bloc: authBloc,
                            builder: (context, authState) {
                              if (authState is AuthInProgress) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColor.backgroundColor,
                                  ),
                                );
                              } else if (authState is Authenticated) {
                                return Padding(
                                  padding:
                                      EdgeInsets.only(right: 8.0, top: 10.h),
                                  child: SizedBox(
                                    width: 90.w,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isLikedList[index] =
                                                  !isLikedList[index];
                                            });

                                            widget.newsBloc.add(
                                              ToggleonlikeEvent(
                                                  newsId: newsItem.id ?? ''),
                                            );
                                          },
                                          child: Icon(
                                            isLikedList[index]
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: isLikedList[index]
                                                ? AppColor.red
                                                : AppColor.black,
                                            size: 23.sp,
                                          ),
                                        ),
                                        // IconButton(
                                        //   icon: Icon(
                                        //     isLikedList[index]
                                        //         ? Icons.favorite
                                        //         : Icons.favorite_border,
                                        //   ),
                                        //   onPressed: () {
                                        //     setState(() {
                                        //       isLikedList[index] = !isLikedList[index];
                                        //     });

                                        //     widget.newsBloc.add(
                                        //       ToggleonlikeEvent(newsId: newsItem.id ?? ''),
                                        //     );
                                        //   },
                                        // ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                return CommentsPage(
                                                  newsId:
                                                      widget.news[index].id ??
                                                          '',
                                                );
                                              }),
                                            );
                                          },
                                          child: Icon(
                                            Feather.message_square,
                                            size: 23.sp,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            // await shareImageWithDescription(
                                            //   imageUrl:
                                            //       widget.news[index].imgUrl,
                                            //   description: widget
                                            //       .news[index].description,
                                            // );
                                            await shareImageWithDescription(
                                                imageUrl:
                                                    widget.news[index].imgUrl,
                                                subject:
                                                    widget.news[index].title,
                                                description:
                                                    'https://www.netzoon.com/home/news/news_details/${widget.news[index].id}');
                                          },
                                          child: Icon(
                                            Feather.share_2,
                                            size: 23.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                          Text(
                            getLikeText(
                                widget.news[index].likes, isLikedList[index]),
                            style: const TextStyle(
                              color: AppColor.secondGrey,
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            getCommentText(widget.news[index].comments),
                            style: const TextStyle(
                              color: AppColor.secondGrey,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return CommentsPage(
                                    newsId: widget.news[index].id ?? '',
                                  );
                                }),
                              );
                            },
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('View All Comments'),
                              style: const TextStyle(
                                color: AppColor.secondGrey,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            convertDateToString(
                                widget.news[index].createdAt ?? ''),
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 60.h,
            ),
          ],
        );
      },
    );
  }

  String getLikeText(List<String>? likes, bool isLiked) {
    final likeCount = likes?.length ?? 0;

    if (isLiked) {
      if (likeCount == 1) {
        return 'You and 1 other person like this';
      } else if (likeCount > 1) {
        return '${AppLocalizations.of(context).translate('You and')} $likeCount ${AppLocalizations.of(context).translate('others like this')}';
      }
    }

    if (likeCount == 1) {
      return AppLocalizations.of(context).translate('1 person likes this');
    } else if (likeCount > 1) {
      return '$likeCount ${AppLocalizations.of(context).translate('people like this')}';
    }

    return AppLocalizations.of(context).translate('No likes');
  }

  String getCommentText(List<NewsComment>? comments) {
    if (comments == null || comments.isEmpty) {
      return 'No comments';
    } else if (comments.length == 1) {
      return AppLocalizations.of(context).translate('1 comment');
    } else {
      return '${comments.length} ${AppLocalizations.of(context).translate('comments')}';
    }
  }
}
