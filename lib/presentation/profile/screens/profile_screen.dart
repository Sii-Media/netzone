import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:netzoon/presentation/core/widgets/screen_loader.dart';
import 'package:netzoon/presentation/profile/screens/my_producrs_screen.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../../../injection_container.dart';
import '../../favorites/favorite_screen.dart';
import '../../home/test.dart';
import '../../orders/screens/order_screen.dart';
import '../blocs/add_account/add_account_bloc.dart';
import '../blocs/get_user/get_user_bloc.dart';
import '../methods/show_change_account_bottom_sheet.dart';
import '../widgets/rounded_icon_text.dart';
import 'credits_screen.dart';
import 'edit_profile_screen.dart';
import 'followings_list_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;
  const UserProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with ScreenLoader<UserProfileScreen> {
  final double coverHeight = 240.h;
  final double profileHeight = 104.h;
  final userBloc = sl<GetUserBloc>();
  final getAccountsBloc = sl<AddAccountBloc>();

  @override
  void initState() {
    userBloc.add(GetUserByIdEvent(userId: widget.userId));
    super.initState();
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
            decoration: BoxDecoration(
              color: AppColor.white,
              border: Border(
                bottom: BorderSide(
                    width: 1, color: AppColor.mainGrey.withOpacity(0.1)),
              ),
              boxShadow: const [
                BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: Offset(0, 3)),
              ],
            ),
          ),
        ),
        // Container(
        //   margin: EdgeInsets.only(bottom: profileHeight / 2),
        //   height: MediaQuery.of(context).size.height * 0.14,
        //   decoration: const BoxDecoration(
        //     image: DecorationImage(
        //       image: AssetImage("assets/images/00.png"),
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        // ),
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

  Widget accountWidget(
      {required GetUserAccountsSuccess accountstate,
      required int index,
      void Function()? onTap,
      required void Function(int?)? onChanged}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                color: AppColor.backgroundColor,
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      accountstate.users[index].profilePhoto ??
                          'https://pbs.twimg.com/media/FjU2lkcWYAgNG6d.jpg',
                    ),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(100)),
          ),
          SizedBox(
            width: 10.w,
          ),
          Text(
            accountstate.users[index].username ?? '',
            style: const TextStyle(
                color: AppColor.white,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Radio<int>(
            value: 1,
            groupValue: 0,
            onChanged: onChanged,
            activeColor: AppColor.white,
          ),
        ],
      ),
    );
  }

  @override
  Widget screen(BuildContext context) {
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
            return BlocListener<AddAccountBloc, AddAccountState>(
              bloc: getAccountsBloc,
              listener: (context, changeAccountstate) {
                if (changeAccountstate is OnChangeAccountInProgress) {
                  startLoading();
                } else if (changeAccountstate is OnChangeAccountFailure) {
                  stopLoading();

                  final failure = changeAccountstate.message;
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
                } else if (changeAccountstate is OnChangeAccountSuccess) {
                  stopLoading();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      AppLocalizations.of(context).translate('success'),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ));
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                      CupertinoPageRoute(builder: (context) {
                    return const TestScreen();
                  }), (route) => false);
                }
              },
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  buildTop(top, state.userInfo.profilePhoto ?? ''),
                  Column(
                    children: [
                      changeAccountText(
                          context: context,
                          state: state,
                          getAccountsBloc: getAccountsBloc),
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
                                  }));
                                }),
                            roundedIconText(
                                context: context,
                                text: 'NetZoon Credits',
                                icon: Icons.wallet_outlined,
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return const CreditScreen();
                                  }));
                                }),
                            roundedIconText(
                                context: context,
                                text: 'my_products',
                                icon: Icons.line_weight_sharp,
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return const MyProductsScreen();
                                  }));
                                }),
                            roundedIconText(
                                context: context,
                                text: 'Favorites',
                                icon: Icons.favorite,
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return const FollowingsListScreen(
                                    type: 'followings',
                                    who: 'me',
                                  );
                                }));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${state.userInfo.followings?.length}',
                                    style: TextStyle(
                                      color: AppColor.mainGrey,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)
                                        .translate('Followings'),
                                    style: TextStyle(
                                        color: AppColor.secondGrey,
                                        fontSize: 15.sp),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return const FollowingsListScreen(
                                    type: 'followers',
                                    who: 'me',
                                  );
                                }));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${state.userInfo.followers?.length}',
                                    style: TextStyle(
                                      color: AppColor.mainGrey,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)
                                        .translate('Followers'),
                                    style: TextStyle(
                                        color: AppColor.secondGrey,
                                        fontSize: 15.sp),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
                                color:
                                    AppColor.backgroundColor.withOpacity(0.3),
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
              ),
            );
          }
          return Container();
        },
      ),
    ));
  }
}
