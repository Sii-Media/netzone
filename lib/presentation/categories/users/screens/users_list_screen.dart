import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/categories/users/blocs/users_bloc/users_bloc.dart';
import 'package:netzoon/presentation/categories/users/screens/users_profile_screen.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';

import '../../../../injection_container.dart';
import '../../../core/constant/colors.dart';
import '../../../utils/app_localizations.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  final usersBloc = sl<UsersBloc>();
  final controller = TextEditingController();

  @override
  void initState() {
    usersBloc.add(const GetUsersListEvent(userType: 'user'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        isHome: false,
        widget: RefreshIndicator(
          onRefresh: () async {
            usersBloc.add(const GetUsersListEvent(userType: 'user'));
          },
          color: AppColor.white,
          backgroundColor: AppColor.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 60.0),
                  child: BlocBuilder<UsersBloc, UsersState>(
                    bloc: usersBloc,
                    builder: (context, state) {
                      if (state is GetUsersInProgress) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColor.backgroundColor,
                          ),
                        );
                      } else if (state is GetUsersFailure) {
                        final failure = state.message;
                        return Center(
                          child: Text(
                            failure,
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        );
                      } else if (state is GetUsersSuccess) {
                        final filteredUsers = state.users
                            .where((user) => user.username!
                                .toLowerCase()
                                .contains(controller.text.toLowerCase()))
                            .toList();
                        return Column(
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            TextFormField(
                              controller: controller,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: 15.sp,
                                ),
                                hintText: AppLocalizations.of(context)
                                    .translate('search'),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ),
                                  borderSide: const BorderSide(
                                    color: AppColor.backgroundColor,
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Expanded(
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.85,
                                        crossAxisSpacing: 10.w,
                                        mainAxisSpacing: 10.h),
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: filteredUsers.length,
                                itemBuilder: (BuildContext context, index) {
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.40,
                                    child: InkWell(
                                      onTap: () {},
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                return UsersProfileScreen(
                                                    userId: filteredUsers[index]
                                                        .id);
                                              }),
                                            );
                                          },
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                              child: Card(
                                                child: Stack(
                                                  children: [
                                                    Positioned(
                                                      left: 0,
                                                      bottom: 0,
                                                      top: 0,
                                                      right: 0,
                                                      child: CachedNetworkImage(
                                                        imageUrl: filteredUsers[
                                                                    index]
                                                                .profilePhoto ??
                                                            'https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg',
                                                        fit: BoxFit.contain,
                                                        progressIndicatorBuilder:
                                                            (context, url,
                                                                    downloadProgress) =>
                                                                Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      70.0,
                                                                  vertical: 50),
                                                          child:
                                                              CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress,
                                                            color: AppColor
                                                                .backgroundColor,

                                                            // strokeWidth: 10,
                                                          ),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: 0,
                                                      left: 0,
                                                      right: 0,
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        height: 50.h,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        color: AppColor
                                                            .backgroundColor
                                                            .withOpacity(0.8),
                                                        child: Center(
                                                          child: Text(
                                                            filteredUsers[index]
                                                                    .username ??
                                                                '',
                                                            style: TextStyle(
                                                                fontSize: 18.sp,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
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
        ),
      ),
    );
  }
}
