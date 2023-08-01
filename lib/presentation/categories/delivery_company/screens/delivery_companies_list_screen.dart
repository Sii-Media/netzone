import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../injection_container.dart';
import '../../../core/constant/colors.dart';
import '../../../core/widgets/background_widget.dart';
import '../../users/blocs/users_bloc/users_bloc.dart';
import 'delivery_company_profile_screen.dart';

class DeliveryCompaniesListScreen extends StatefulWidget {
  const DeliveryCompaniesListScreen({super.key});

  @override
  State<DeliveryCompaniesListScreen> createState() =>
      _DeliveryCompaniesListScreenState();
}

class _DeliveryCompaniesListScreenState
    extends State<DeliveryCompaniesListScreen> {
  final usersBloc = sl<UsersBloc>();

  @override
  void initState() {
    usersBloc.add(const GetUsersListEvent(userType: 'delivery_company'));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        isHome: false,
        widget: RefreshIndicator(
          onRefresh: () async {
            usersBloc
                .add(const GetUsersListEvent(userType: 'delivery_company'));
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
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.users.length,
                          itemBuilder: (BuildContext context, index) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.40,
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                          return DeliveryCompanyProfileScreen(
                                            deliveryCompany: state.users[index],
                                          );
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
                                                  imageUrl: state.users[index]
                                                          .profilePhoto ??
                                                      'https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                left: 0,
                                                right: 0,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 50.h,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  color: AppColor
                                                      .backgroundColor
                                                      .withOpacity(0.8),
                                                  child: Center(
                                                    child: Text(
                                                      state.users[index]
                                                              .username ??
                                                          '',
                                                      style: TextStyle(
                                                          fontSize: 18.sp,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center,
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
