import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/chat/screens/chat_home_screen.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/screen/product_details_screen.dart';

import '../../../injection_container.dart';
import '../../utils/app_localizations.dart';
import '../blocs/get_user/get_user_bloc.dart';
import '../widgets/rounded_icon_text.dart';

class MyLocalCompanyProfileScreen extends StatefulWidget {
  final String userId;
  const MyLocalCompanyProfileScreen({super.key, required this.userId});

  @override
  State<MyLocalCompanyProfileScreen> createState() =>
      _MyLocalCompanyProfileScreenState();
}

class _MyLocalCompanyProfileScreenState
    extends State<MyLocalCompanyProfileScreen> with TickerProviderStateMixin {
  final double coverHeight = 240.h;
  final double profileHeight = 104.h;
  final userBloc = sl<GetUserBloc>();
  final productBloc = sl<GetUserBloc>();

  @override
  void initState() {
    userBloc.add(GetUserByIdEvent(userId: widget.userId));
    productBloc.add(GetUserProductsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TabController tabController = TabController(length: 2, vsync: this);
    final top = 80.h;
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async {
            userBloc.add(GetUserByIdEvent(userId: widget.userId));
            productBloc.add(GetUserProductsEvent());
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
                return DefaultTabController(
                  length: 2,
                  child: NestedScrollView(
                    headerSliverBuilder: (context, _) {
                      return [
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Column(
                                children: [
                                  buildTop(top, state.userInfo.coverPhoto ?? '',
                                      state.userInfo.profilePhoto ?? ''),
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
                                  const Divider(),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        roundedIconText(
                                            context: context,
                                            text: 'my_products',
                                            icon: Icons.shopping_bag_outlined,
                                            onTap: () {}),
                                        roundedIconText(
                                          context: context,
                                          text: 'Products sold',
                                          icon:
                                              Icons.production_quantity_limits,
                                        ),
                                        roundedIconText(
                                          context: context,
                                          text: 'Recovered products',
                                          icon: Icons.reset_tv_rounded,
                                        ),
                                        roundedIconText(
                                            context: context,
                                            text: 'chat',
                                            icon: Icons.chat,
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return const ChatHomeScreen();
                                              }));
                                            }),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    color: AppColor.secondGrey,
                                    thickness: 0.4,
                                    indent: 30,
                                    endIndent: 30,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ];
                    },
                    body: Column(
                      children: [
                        TabBar(
                          controller: tabController,
                          labelColor: AppColor.backgroundColor,
                          unselectedLabelColor: AppColor.secondGrey,
                          // isScrollable: true,

                          tabs: const [
                            Tab(
                              text: 'About',
                            ),
                            Tab(
                              text: 'Products',
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: tabController,
                            children: [
                              ListView(
                                children: [
                                  Column(
                                    children: [
                                      titleAndInput(
                                          title: AppLocalizations.of(context)
                                              .translate('company_name'),
                                          input: state.userInfo.username ?? ''),
                                      titleAndInput(
                                          title: AppLocalizations.of(context)
                                              .translate('email'),
                                          input: state.userInfo.email ?? ''),
                                      titleAndInput(
                                          title: AppLocalizations.of(context)
                                              .translate('mobile'),
                                          input:
                                              state.userInfo.firstMobile ?? ''),
                                    ],
                                  ),
                                ],
                              ),
                              RefreshIndicator(
                                onRefresh: () async {
                                  productBloc.add(GetUserProductsEvent());
                                },
                                color: AppColor.white,
                                backgroundColor: AppColor.backgroundColor,
                                child: BlocBuilder<GetUserBloc, GetUserState>(
                                  bloc: productBloc,
                                  builder: (context, state) {
                                    if (state is GetUserProductsInProgress) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColor.backgroundColor,
                                        ),
                                      );
                                    } else if (state
                                        is GetUserProductsFailure) {
                                      final failure = state.message;
                                      return Center(
                                        child: Text(
                                          failure,
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      );
                                    } else if (state
                                        is GetUserProductsSuccess) {
                                      return state.products.isNotEmpty
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: GridView.builder(
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 3,
                                                        childAspectRatio: 0.95,
                                                        crossAxisSpacing: 10.w,
                                                        mainAxisSpacing: 10.h),
                                                shrinkWrap: true,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                itemCount:
                                                    state.products.length,
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(vertical: 8),
                                                    decoration: BoxDecoration(
                                                        color: AppColor.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: AppColor
                                                                .secondGrey
                                                                .withOpacity(
                                                                    0.5),
                                                            blurRadius: 10,
                                                            spreadRadius: 2,
                                                            offset:
                                                                const Offset(
                                                                    0, 3),
                                                          ),
                                                        ]),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  20)),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                            return ProductDetailScreen(
                                                                item: state
                                                                        .products[
                                                                    index]);
                                                          }));
                                                        },
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            CachedNetworkImage(
                                                              imageUrl: state
                                                                  .products[
                                                                      index]
                                                                  .imageUrl,
                                                              height: 65.h,
                                                              width: 160.w,
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          9.0,
                                                                      left: 9.0,
                                                                      bottom:
                                                                          8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    state
                                                                        .products[
                                                                            index]
                                                                        .name,
                                                                    style:
                                                                        const TextStyle(
                                                                      color: AppColor
                                                                          .backgroundColor,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    '${state.products[index].price} \$',
                                                                    style:
                                                                        const TextStyle(
                                                                      color: AppColor
                                                                          .colorTwo,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          : Center(
                                              child: Text(
                                                  AppLocalizations.of(context)
                                                      .translate('no_items'),
                                                  style: const TextStyle(
                                                      color: AppColor
                                                          .backgroundColor)),
                                            );
                                    }
                                    return Container();
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Container();
            },
          )),
    );
  }

  Stack buildTop(double top, String coverUrl, String profileUrl) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: profileHeight / 2),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              color: AppColor.backgroundColor,
              image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    coverUrl,
                  ),
                  fit: BoxFit.cover),
            ),
          ),
        ),
        Positioned(
          top: top,
          child: CircleAvatar(
            radius: profileHeight / 2,
            backgroundColor: Colors.grey.shade800,
            backgroundImage: CachedNetworkImageProvider(profileUrl),
          ),
        ),
      ],
    );
  }

  Padding titleAndInput({required String title, required String input}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // height: 40.h,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.4),
              width: 1.0,
            ),
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: 15.sp,
                ),
              ),
              SizedBox(
                width: 190,
                child: Text(
                  input,
                  style: TextStyle(
                    color: AppColor.mainGrey,
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
  // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     Column(
                        //       children: [
                        //         Text(
                        //           '100',
                        //           style: TextStyle(
                        //             color: AppColor.black,
                        //             fontWeight: FontWeight.w700,
                        //             fontSize: 18.sp,
                        //           ),
                        //         ),
                        //         Text(
                        //           'Following',
                        //           style: TextStyle(
                        //             color: AppColor.mainGrey,
                        //             // fontWeight: FontWeight.w700,
                        //             fontSize: 14.sp,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //     Column(
                        //       children: [
                        //         Text(
                        //           '200',
                        //           style: TextStyle(
                        //             color: AppColor.black,
                        //             fontWeight: FontWeight.w700,
                        //             fontSize: 18.sp,
                        //           ),
                        //         ),
                        //         Text(
                        //           'Followers',
                        //           style: TextStyle(
                        //             color: AppColor.mainGrey,
                        //             // fontWeight: FontWeight.w700,
                        //             fontSize: 14.sp,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //     Column(
                        //       children: [
                        //         Text(
                        //           state.userInfo.products!.length.toString(),
                        //           style: TextStyle(
                        //             color: AppColor.black,
                        //             fontWeight: FontWeight.w700,
                        //             fontSize: 18.sp,
                        //           ),
                        //         ),
                        //         Text(
                        //           'Products',
                        //           style: TextStyle(
                        //             color: AppColor.mainGrey,
                        //             // fontWeight: FontWeight.w700,
                        //             fontSize: 14.sp,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(
                        //   height: 10.h,
                        // ),