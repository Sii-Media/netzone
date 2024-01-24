import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/auth/blocs/auth_bloc/auth_bloc.dart';

import '../../../domain/auth/entities/user_info.dart';
import '../../../injection_container.dart';
import '../../core/constant/colors.dart';
import '../screens/chat_page_screen.dart';

class ContactsListWidget extends StatefulWidget {
  const ContactsListWidget({super.key, required this.users});
  final List<UserInfo> users;

  @override
  State<ContactsListWidget> createState() => _ContactsListWidgetState();
}

class _ContactsListWidgetState extends State<ContactsListWidget> {
  final authBloc = sl<AuthBloc>();

  @override
  void initState() {
    super.initState();
    authBloc.add(AuthCheckRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.users.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: BlocBuilder<AuthBloc, AuthState>(
                        bloc: authBloc,
                        builder: (context, state) {
                          return InkWell(
                            onTap: () {
                              state is Authenticated
                                  ? Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                      return ChatPageScreen(
                                        userId:
                                            state.user.userInfo.username ?? '',
                                        otherUserId:
                                            widget.users[index].username ?? '',
                                        title:
                                            widget.users[index].username ?? '',
                                        image:
                                            widget.users[index].profilePhoto ??
                                                '',
                                      );
                                    }))
                                  : null;
                            },
                            child: SizedBox(
                              height: 65.h,
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(35),
                                    child: CachedNetworkImage(
                                      imageUrl: widget
                                              .users[index].profilePhoto ??
                                          'https://pbs.twimg.com/media/FjU2lkcWYAgNG6d.jpg',
                                      height: 50.h,
                                      width: 45.w,
                                      fit: BoxFit.cover,
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0, vertical: 5),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              widget.users[index].username ??
                                                  'person',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: AppColor.backgroundColor,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 12.w,
                                            ),
                                            CountryFlag.fromCountryCode(
                                              widget.users[index].country ??
                                                  'AE',
                                              height: 22.h,
                                              width: 22.w,
                                              borderRadius: 8,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              93.w,
                                          child: Text(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            widget.users[index].bio ??
                                                'this is a bio',
                                            style: TextStyle(
                                              color: AppColor.mainGrey,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ));
                },
              ),
            ),
            SizedBox(
              height: 290.h,
            ),
          ],
        ),
      ),
    );
  }
}
