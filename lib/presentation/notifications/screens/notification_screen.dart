import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/advertising/advertising_details.dart';
import 'package:netzoon/presentation/core/screen/product_details_screen.dart';
import 'package:netzoon/presentation/core/widgets/on_failure_widget.dart';
import 'package:netzoon/presentation/deals/deals_details.dart';
import 'package:netzoon/presentation/news/news_screen.dart';

import '../../../injection_container.dart';
import '../../core/constant/colors.dart';
import '../../utils/app_localizations.dart';
import '../../utils/convert_date_to_string.dart';
import '../blocs/notifications/notifications_bloc.dart';

class NotificatiionScreen extends StatefulWidget {
  const NotificatiionScreen({super.key});

  @override
  State<NotificatiionScreen> createState() => _NotificatiionScreenState();
}

class _NotificatiionScreenState extends State<NotificatiionScreen> {
  final notiBloc = sl<NotificationsBloc>();

  @override
  void initState() {
    notiBloc.add(GetAllNotificationsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_rounded,
            color: AppColor.backgroundColor,
          ),
        ),
        title: Text(
          AppLocalizations.of(context).translate('notifications'),
          style: const TextStyle(color: AppColor.backgroundColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<NotificationsBloc, NotificationsState>(
          bloc: notiBloc,
          builder: (context, state) {
            if (state is GetNotificationsInProgress) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColor.backgroundColor,
                ),
              );
            } else if (state is GetNotificationsFailure) {
              final failure = state.message;
              return FailureWidget(
                  failure: failure,
                  onPressed: () {
                    notiBloc.add(GetAllNotificationsEvent());
                  });
            } else if (state is GetNotificationsSuccess) {
              return state.notifications.isEmpty
                  ? Center(
                      child: Text(
                        AppLocalizations.of(context).translate('no_items'),
                        style: TextStyle(
                          color: AppColor.backgroundColor,
                          fontSize: 22.sp,
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: state.notifications.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  if (state.notifications[index].category ==
                                      'products') {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return ProductDetailScreen(
                                          item: state
                                              .notifications[index].itemId);
                                    }));
                                  } else if (state
                                          .notifications[index].category ==
                                      'deals') {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return DealDetails(
                                          dealsInfoId: state
                                              .notifications[index].itemId);
                                    }));
                                  } else if (state
                                          .notifications[index].category ==
                                      'advertiments') {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return AdvertismentDetalsScreen(
                                          adsId: state
                                              .notifications[index].itemId);
                                    }));
                                  } else if (state
                                          .notifications[index].category ==
                                      'news') {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return const NewsScreen();
                                    }));
                                  }
                                },
                                leading: CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                      state.notifications[index]
                                          .userProfileImage),
                                ),
                                title: Text(
                                    '${state.notifications[index].username} added a ${state.notifications[index].text} to ${AppLocalizations.of(context).translate(state.notifications[index].category)}'),
                                subtitle: Text(
                                  formatDateTime(
                                      state.notifications[index].createdAt ??
                                          ''),
                                  style: const TextStyle(
                                    color: AppColor.secondGrey,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
