import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../../../injection_container.dart';
import '../../favorites/favorite_screen.dart';
import '../../orders/screens/order_screen.dart';
import '../blocs/get_user/get_user_bloc.dart';
import '../widgets/rounded_icon_text.dart';
import 'credits_screen.dart';
import 'edit_profile_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;
  const UserProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final double coverHeight = 240.h;
  final double profileHeight = 104.h;
  final userBloc = sl<GetUserBloc>();

  @override
  void initState() {
    userBloc.add(GetUserByIdEvent(userId: widget.userId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final top = 40.h;
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () async {
        userBloc.add(GetUserByIdEvent(userId: widget.userId));
      },
      color: AppColor.white,
      backgroundColor: AppColor.backgroundColor,
      child: BlocBuilder<GetUserBloc, GetUserState>(
        bloc: userBloc,
        builder: (context, state) {
          if (state is GetUserInProgress) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.backgroundColor,
              ),
            );
          } else if (state is GetUserFailure) {
            final failure = state.message;
            return Center(
              child: Text(
                failure,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            );
          } else if (state is GetUserSuccess) {
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                buildTop(top, state.userInfo.profilePhoto ?? ''),
                Column(
                  children: [
                    Center(
                      child: Text(
                        state.userInfo.username ?? '',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          roundedIconText(
                              context: context,
                              text: 'Orders',
                              icon: Icons.wallet_giftcard_outlined,
                              onTap: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) {
                                  return const OrdersScreen();
                                })).then((userInfo) => userBloc.add(
                                    OnEditProfileEvent(userInfo: userInfo)));
                              }),
                          roundedIconText(
                              context: context,
                              text: 'NetZoon Credits',
                              icon: Icons.wallet_outlined,
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return const CreditScreen();
                                }));
                              }),
                          roundedIconText(
                            context: context,
                            text: 'Returns',
                            icon: Icons.reset_tv_rounded,
                          ),
                          roundedIconText(
                              context: context,
                              text: 'Favorites',
                              icon: Icons.favorite,
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return FavoriteScreen(
                                    userId: state.userInfo.id,
                                  );
                                }));
                              }),
                        ],
                      ),
                    ),
                    // socialMedialRow(),
                    SizedBox(
                      height: 10.h,
                    ),

                    infoWidget(
                      title: 'user name',
                      subTitle: state.userInfo.username ?? '',
                      icon: Icons.person_4_sharp,
                    ),
                    infoWidget(
                      title: 'email',
                      subTitle: state.userInfo.email ?? '',
                      icon: Icons.email_outlined,
                    ),
                    infoWidget(
                      title: 'mobile',
                      subTitle: state.userInfo.firstMobile ?? '',
                      icon: Icons.phone_rounded,
                    ),
                    infoWidget(
                      title: 'Location',
                      subTitle: state.userInfo.address ?? 'UAE',
                      icon: Icons.location_city,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 5),
                              color: AppColor.backgroundColor.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            AppLocalizations.of(context)
                                .translate('edit_profile'),
                            style: TextStyle(
                                color: AppColor.backgroundColor,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w600),
                          ),
                          leading: const Icon(
                            Icons.edit,
                            size: 34,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 27,
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return EditProfileScreen(
                                userInfo: state.userInfo,
                              );
                            }));
                          },
                        ),
                      ),
                    ),

                    const Divider(),
                  ],
                ),
                SizedBox(
                  height: 80.h,
                ),
              ],
            );
          }
          return Container();
        },
      ),
    ));
  }

  Padding infoWidget(
      {required String title,
      required String subTitle,
      required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              color: AppColor.backgroundColor.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 10,
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            AppLocalizations.of(context).translate(title),
            style: TextStyle(
                color: AppColor.backgroundColor,
                fontSize: 17.sp,
                fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            subTitle,
            style: TextStyle(
              color: AppColor.backgroundColor,
              fontSize: 17.sp,
            ),
          ),
          leading: Icon(
            icon,
            size: 34,
          ),
        ),
      ),
    );
  }

  Column buildInfo({required String value, required String title}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColor.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(
          AppLocalizations.of(context).translate(title),
          style: const TextStyle(
            color: AppColor.black,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Row socialMedialRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildSocialIcon(icon: FontAwesomeIcons.facebook),
        SizedBox(
          width: 14.w,
        ),
        buildSocialIcon(icon: FontAwesomeIcons.instagram),
        SizedBox(
          width: 14.w,
        ),
        buildSocialIcon(icon: FontAwesomeIcons.twitter),
        SizedBox(
          width: 14.w,
        ),
        buildSocialIcon(icon: FontAwesomeIcons.linkedin),
      ],
    );
  }

  CircleAvatar buildSocialIcon({required IconData icon}) {
    return CircleAvatar(
      radius: 22,
      child: Material(
        shape: const CircleBorder(),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Center(
            child: Icon(
              icon,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }

  Stack buildTop(double top, String? url) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: profileHeight / 2),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.14,
            decoration: const BoxDecoration(color: AppColor.backgroundColor),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: profileHeight / 2),
          height: MediaQuery.of(context).size.height * 0.14,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/00.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: top,
          child: CircleAvatar(
            radius: profileHeight / 2,
            backgroundColor: Colors.grey.shade800,
            backgroundImage: CachedNetworkImageProvider(url ?? ''),
          ),
        ),
      ],
    );
  }
}
