import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/auth/entities/user_info.dart';
import '../../../injection_container.dart';
import '../../core/constant/colors.dart';
import '../../core/widgets/background_widget.dart';
import '../../utils/app_localizations.dart';
import '../users/blocs/users_bloc/users_bloc.dart';
import 'freezone_company_profile_screen.dart';

class FreeZoneCompaniesListScreen extends StatefulWidget {
  const FreeZoneCompaniesListScreen({super.key});

  @override
  State<FreeZoneCompaniesListScreen> createState() =>
      _FreeZoneCompaniesListScreenState();
}

class _FreeZoneCompaniesListScreenState
    extends State<FreeZoneCompaniesListScreen> {
  final usersBloc = sl<UsersBloc>();

  final controller = TextEditingController();
  @override
  void initState() {
    usersBloc.add(const GetUsersListEvent(userType: 'freezone'));
    super.initState();
  }

  List<UserInfo> filteredUsers = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        isHome: false,
        widget: RefreshIndicator(
          onRefresh: () async {
            usersBloc.add(const GetUsersListEvent(userType: 'freezone'));
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
                            .where((user) => user.freezoneCity!
                                .toLowerCase()
                                .contains(controller.text.toLowerCase()))
                            .toList();
                        return state.users.isEmpty
                            ? Center(
                                child: Text(
                                    AppLocalizations.of(context)
                                        .translate('no_items'),
                                    style: const TextStyle(
                                        color: AppColor.backgroundColor)),
                              )
                            : Column(
                                children: [
                                  TextFormField(
                                    controller: controller,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.search,
                                      ),
                                      hintText: AppLocalizations.of(context)
                                          .translate('search by city'),
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
                                      usersBloc.add(
                                          SearchUsersEvent(searchQuery: value));
                                      setState(() {});
                                    },
                                  ),
                                  SizedBox(
                                    height: 25.h,
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: filteredUsers.length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.40,
                                          child: InkWell(
                                            onTap: () {},
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                      return FreezoneCompanyProfileScreen(
                                                          id: filteredUsers[
                                                                  index]
                                                              .id);
                                                    }),
                                                  );
                                                },
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.0),
                                                    child: Card(
                                                      child: Stack(
                                                        children: [
                                                          Positioned(
                                                            left: 0,
                                                            bottom: 0,
                                                            top: 0,
                                                            right: 0,
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: filteredUsers[
                                                                          index]
                                                                      .profilePhoto ??
                                                                  'https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg',
                                                              fit: BoxFit
                                                                  .contain,
                                                              progressIndicatorBuilder:
                                                                  (context, url,
                                                                          downloadProgress) =>
                                                                      Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        70.0,
                                                                    vertical:
                                                                        50),
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  value: downloadProgress
                                                                      .progress,
                                                                  color: AppColor
                                                                      .backgroundColor,

                                                                  // strokeWidth: 10,
                                                                ),
                                                              ),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  const Icon(Icons
                                                                      .error),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            bottom: 0,
                                                            left: 0,
                                                            right: 0,
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: 50.h,
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              color: AppColor
                                                                  .backgroundColor
                                                                  .withOpacity(
                                                                      0.8),
                                                              child: Center(
                                                                child: Text(
                                                                  filteredUsers[
                                                                              index]
                                                                          .username ??
                                                                      '',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18.sp,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  textAlign:
                                                                      TextAlign
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
                                  SizedBox(
                                    height: 80.h,
                                  )
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


/*  void searchCompanies(String query, List<UserInfo> users) {
    print('asd');
    final suggestions = users.where((element) {
      final freezoneCity = element.freezoneCity?.toLowerCase();
      final input = query.toLowerCase();
      return freezoneCity!.contains(input);
    }).toList();
    setState(() {
      users = suggestions;
    });
  }*/