import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/advertising/advertising_details.dart';
import 'package:netzoon/presentation/categories/delivery_company/screens/delivery_company_profile_screen.dart';
import 'package:netzoon/presentation/categories/factories/factory_profile_screen.dart';
import 'package:netzoon/presentation/categories/free_zoon/freezone_company_profile_screen.dart';
import 'package:netzoon/presentation/categories/local_company/local_company_profile.dart';
import 'package:netzoon/presentation/categories/real_estate/screens/real_estate_company_profile_screen.dart';
import 'package:netzoon/presentation/categories/users/screens/users_profile_screen.dart';
import 'package:netzoon/presentation/categories/vehicles/screens/vehicle_companies_profile_screen.dart';
import 'package:netzoon/presentation/core/screen/product_details_screen.dart';
import 'package:netzoon/presentation/core/widgets/on_failure_widget.dart';
import 'package:netzoon/presentation/deals/deals_details.dart';
import 'package:netzoon/presentation/news/news_screen.dart';

import '../../../injection_container.dart';
import '../../auth/blocs/auth_bloc/auth_bloc.dart';
import '../../auth/screens/signin.dart';
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
  final notiunreadBloc = sl<NotificationsBloc>();
  late final NotificationsBloc unreadBloc;
  final authBloc = sl<AuthBloc>();

  @override
  void initState() {
    super.initState();
    notiBloc.add(GetAllNotificationsEvent());

    notiunreadBloc.add(MarkAllNotificationsAsReadEvent());
    unreadBloc = BlocProvider.of<NotificationsBloc>(context);
    unreadBloc.add(GetUnreadNotificationsEvent());

    authBloc.add(AuthCheckRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.h,
        backgroundColor: AppColor.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_rounded,
            color: AppColor.backgroundColor,
            size: 22.sp,
          ),
        ),
        title: Text(
          AppLocalizations.of(context).translate('notifications'),
          style: const TextStyle(color: AppColor.backgroundColor),
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        bloc: authBloc,
        builder: (context, authState) {
          if (authState is AuthInProgress) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.backgroundColor,
              ),
            );
          } else if (authState is Authenticated) {
            return BlocBuilder<NotificationsBloc, NotificationsState>(
              bloc: notiunreadBloc,
              builder: (context, notiState) {
                if (notiState is MarkAllNotificationsAsReadSuccess) {
                  notiunreadBloc.add(GetUnreadNotificationsEvent());
                }
                return Padding(
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
                                  AppLocalizations.of(context)
                                      .translate('no_items'),
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
                                            if (state.notifications[index]
                                                    .category ==
                                                'products') {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return ProductDetailScreen(
                                                    item: state
                                                        .notifications[index]
                                                        .itemId);
                                              }));
                                            } else if (state
                                                    .notifications[index]
                                                    .category ==
                                                'deals') {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return DealDetails(
                                                    dealsInfoId: state
                                                        .notifications[index]
                                                        .itemId);
                                              }));
                                            } else if (state
                                                    .notifications[index]
                                                    .category ==
                                                'advertiments') {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return AdvertismentDetalsScreen(
                                                    adsId: state
                                                        .notifications[index]
                                                        .itemId);
                                              }));
                                            } else if (state
                                                    .notifications[index]
                                                    .category ==
                                                'news') {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return const NewsScreen();
                                              }));
                                            } else if (state
                                                    .notifications[index]
                                                    .category ==
                                                'account') {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                if (state.notifications[index]
                                                        .text ==
                                                    'local_company') {
                                                  return LocalCompanyProfileScreen(
                                                      id: state
                                                          .notifications[index]
                                                          .itemId);
                                                } else if (state
                                                            .notifications[
                                                                index]
                                                            .text ==
                                                        'car' ||
                                                    state.notifications[index]
                                                            .text ==
                                                        'planes' ||
                                                    state.notifications[index]
                                                            .text ==
                                                        'sea_companies') {
                                                  return VehicleCompaniesProfileScreen(
                                                    id: state
                                                        .notifications[index]
                                                        .itemId,
                                                    userType: state
                                                        .notifications[index]
                                                        .text,
                                                  );
                                                } else if (state
                                                        .notifications[index]
                                                        .text ==
                                                    'real_estate') {
                                                  return RealEstateCompanyProfileScreen(
                                                      id: state
                                                          .notifications[index]
                                                          .itemId);
                                                } else if (state
                                                        .notifications[index]
                                                        .text ==
                                                    'trader') {
                                                  return LocalCompanyProfileScreen(
                                                    id: state
                                                        .notifications[index]
                                                        .itemId,
                                                  );
                                                } else if (state
                                                        .notifications[index]
                                                        .text ==
                                                    'delivery_company') {
                                                  return DeliveryCompanyProfileScreen(
                                                    id: state
                                                        .notifications[index]
                                                        .itemId,
                                                  );
                                                } else if (state
                                                        .notifications[index]
                                                        .text ==
                                                    'factory') {
                                                  return FactoryProfileScreen(
                                                    id: state
                                                        .notifications[index]
                                                        .itemId,
                                                  );
                                                } else if (state
                                                        .notifications[index]
                                                        .text ==
                                                    'freezone') {
                                                  return FreezoneCompanyProfileScreen(
                                                    id: state
                                                        .notifications[index]
                                                        .itemId,
                                                  );
                                                } else {
                                                  return UsersProfileScreen(
                                                      userId: state
                                                          .notifications[index]
                                                          .itemId);
                                                }
                                              }));
                                            }
                                          },
                                          leading: CircleAvatar(
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                              state.notifications[index]
                                                  .userProfileImage,
                                            ),
                                            radius: 20.r,
                                          ),
                                          title: Text(state.notifications[index]
                                                      .category ==
                                                  'account'
                                              ? '${state.notifications[index].username} ${AppLocalizations.of(context).translate('created an account as')} ${state.notifications[index].text}'
                                              : '${state.notifications[index].username} ${AppLocalizations.of(context).translate('added a')} ${state.notifications[index].text} ${AppLocalizations.of(context).translate('to')} ${AppLocalizations.of(context).translate(state.notifications[index].category)}'),
                                          subtitle: Text(
                                            formatDateTime(state
                                                    .notifications[index]
                                                    .createdAt ??
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
                );
              },
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context).translate('You must log in first'),
                style: TextStyle(
                  color: AppColor.mainGrey,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        AppColor.backgroundColor,
                      ),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )),
                    ),
                    child:
                        Text(AppLocalizations.of(context).translate('login')),
                    onPressed: () async {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const SignInScreen();
                      }));
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
