import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/news/entities/news_info.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/on_failure_widget.dart';
import 'package:netzoon/presentation/news/blocs/news/news_bloc.dart';
import 'package:netzoon/presentation/utils/convert_date_to_string.dart';

import '../../injection_container.dart';
import '../auth/blocs/auth_bloc/auth_bloc.dart';
import '../core/constant/colors.dart';
import '../core/widgets/screen_loader.dart';
import '../utils/app_localizations.dart';
import 'edit_news_screen.dart';

class NewsDetails extends StatefulWidget {
  const NewsDetails({super.key, required this.newsId});

  final String newsId;

  @override
  State<NewsDetails> createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails>
    with ScreenLoader<NewsDetails> {
  final authBloc = sl<AuthBloc>();
  final newsBloc = sl<NewsBloc>();
  @override
  void initState() {
    newsBloc.add(GetNewsByIdEvent(id: widget.newsId));
    authBloc.add(AuthCheckRequested());
    super.initState();
  }

  @override
  Widget screen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BackgroundWidget(
        isHome: false,
        widget: BlocListener<NewsBloc, NewsState>(
          bloc: newsBloc,
          listener: (context, state) {
            if (state is DeleteNewsInProgress) {
              startLoading();
            } else if (state is DeleteNewsFailure) {
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
            } else if (state is NewsSuccess) {
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
          child: BlocBuilder<NewsBloc, NewsState>(
            bloc: newsBloc,
            builder: (context, newsState) {
              if (newsState is NewsInProgress) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.backgroundColor,
                  ),
                );
              } else if (newsState is NewsFailure) {
                final failure = newsState.message;
                return FailureWidget(
                  failure: failure,
                  onPressed: () {
                    newsBloc.add(GetAllNewsEvent());
                  },
                );
              } else if (newsState is GetNewsByIdSuccess) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ListView(
                    children: [
                      SizedBox(
                        // height: size.height * 0.4,
                        child: CachedNetworkImage(
                          imageUrl: newsState.news.imgUrl,
                          // fit: BoxFit.fill,
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
                      Container(
                        alignment: Alignment.topCenter,
                        // height: size.height * 0.05,
                        child: Text(
                          convertDateToString(newsState.news.createdAt ?? ''),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                              color: Colors.black),
                        ),
                      ),
                      BlocBuilder<AuthBloc, AuthState>(
                        bloc: authBloc,
                        builder: (context, authState) {
                          if (authState is Authenticated) {
                            if (authState.user.userInfo.id ==
                                newsState.news.creator.id) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return EditNewsScreen(
                                          news: newsState.news,
                                        );
                                      }));
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: AppColor.backgroundColor,
                                      size: 25.sp,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      newsBloc.add(DeleteNewsEvent(
                                          id: newsState.news.id ?? ''));
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: AppColor.red,
                                      size: 25.sp,
                                    ),
                                  ),
                                ],
                              );
                            }
                          }
                          return Container();
                        },
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        child: Text(
                          newsState.news.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                              color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 80.h),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.center,
                        child: Text(
                          newsState.news.description,
                          style:
                              TextStyle(fontSize: 13.sp, color: Colors.black),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
