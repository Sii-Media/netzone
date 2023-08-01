import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/news/entities/news_info.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/news/blocs/news/news_bloc.dart';
import 'package:netzoon/presentation/utils/convert_date_to_string.dart';

import '../../injection_container.dart';
import '../auth/blocs/auth_bloc/auth_bloc.dart';
import '../core/constant/colors.dart';
import '../core/widgets/screen_loader.dart';
import '../utils/app_localizations.dart';
import 'edit_news_screen.dart';

class NewsDetails extends StatefulWidget {
  const NewsDetails({super.key, required this.news});

  final News news;

  @override
  State<NewsDetails> createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails>
    with ScreenLoader<NewsDetails> {
  final authBloc = sl<AuthBloc>();
  final newsBloc = sl<NewsBloc>();
  @override
  void initState() {
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
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ListView(
              children: [
                SizedBox(
                  height: size.height * 0.4,
                  child: CachedNetworkImage(
                    imageUrl: widget.news.imgUrl,
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  // height: size.height * 0.05,
                  child: Text(
                    convertDateToString(widget.news.createdAt ?? ''),
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
                          widget.news.creator.id) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return EditNewsScreen(
                                    news: widget.news,
                                  );
                                }));
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: AppColor.backgroundColor,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                newsBloc.add(
                                    DeleteNewsEvent(id: widget.news.id ?? ''));
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
                ),
                Container(
                  alignment: Alignment.topCenter,
                  child: Text(
                    widget.news.title,
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
                  margin: const EdgeInsets.only(bottom: 20),
                  alignment: Alignment.topCenter,
                  child: Text(
                    widget.news.description,
                    style: TextStyle(fontSize: 13.sp, color: Colors.black),
                    textAlign: TextAlign.center,
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
