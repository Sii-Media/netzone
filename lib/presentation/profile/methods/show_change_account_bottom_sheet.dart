import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cart/blocs/cart_bloc/cart_bloc_bloc.dart';
import '../../core/constant/colors.dart';
import '../../core/widgets/on_failure_widget.dart';
import '../../utils/app_localizations.dart';
import '../blocs/add_account/add_account_bloc.dart';
import '../blocs/get_user/get_user_bloc.dart';
import '../screens/add_account_screen.dart';
import '../widgets/top_profile.dart';

Future<dynamic> showChangeAccountBottomSheet(
    {required BuildContext context,
    required GetUserSuccess state,
    required AddAccountBloc getAccountsBloc}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: AppColor.backgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      ),
    ),
    builder: (context) {
      return SizedBox(
        height: 300.h,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 24.0,
                bottom: 4.0,
              ),
              child: Container(
                width: 75,
                height: 7,
                decoration: const BoxDecoration(
                  color: Color(0xFFC6E2DD),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 6.0,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<AddAccountBloc, AddAccountState>(
                  bloc: getAccountsBloc,
                  builder: (context, accountstate) {
                    if (accountstate is GetUserAccountsInProgress) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColor.white,
                        ),
                      );
                    } else if (accountstate is GetUserAccountsFailure) {
                      final failure = accountstate.message;
                      return FailureWidget(
                        failure: failure,
                        onPressed: () {
                          getAccountsBloc.add(GetUserAccountsEvent());
                        },
                      );
                    } else if (accountstate is GetUserAccountsSuccess) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: AppColor.backgroundColor,
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        // ignore: unnecessary_type_check
                                        state.userInfo.profilePhoto!,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  state.userInfo.username ?? '',
                                  style: const TextStyle(
                                    color: AppColor.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                Radio<int>(
                                  value: 0,
                                  groupValue: 0,
                                  onChanged: (int? value) {
                                    // Handle radio button selection
                                  },
                                  activeColor: AppColor.white,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: accountstate.users.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: accountWidget(
                                    accountstate: accountstate,
                                    index: index,
                                    onTap: () {
                                      getAccountsBloc.add(
                                        OnChangeAccountEvent(
                                          email:
                                              accountstate.users[index].email!,
                                          password: accountstate
                                              .users[index].password!,
                                        ),
                                      );
                                    },
                                    onChanged: (int? val) {
                                      getAccountsBloc.add(
                                        OnChangeAccountEvent(
                                          email:
                                              accountstate.users[index].email!,
                                          password: accountstate
                                              .users[index].password!,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const AddAccountScreen();
                                    },
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: AppColor.white,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: AppColor.backgroundColor,
                                      size: 30,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)
                                        .translate('add_account'),
                                    style: const TextStyle(
                                      color: AppColor.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget changeAccountText(
    {required BuildContext context,
    required GetUserSuccess state,
    required AddAccountBloc getAccountsBloc}) {
  return GestureDetector(
    onTap: () {
      getAccountsBloc.add(GetUserAccountsEvent());
      showModalBottomSheet(
        context: context,
        backgroundColor: AppColor.backgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        builder: (context) {
          return SizedBox(
            height: 300.h,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 4.0,
                  ),
                  child: Container(
                    width: 75,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFFC6E2DD),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 6.0,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BlocBuilder<AddAccountBloc, AddAccountState>(
                      bloc: getAccountsBloc,
                      builder: (context, accountstate) {
                        if (accountstate is GetUserAccountsInProgress) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColor.white,
                            ),
                          );
                        } else if (accountstate is GetUserAccountsFailure) {
                          final failure = accountstate.message;
                          return FailureWidget(
                            failure: failure,
                            onPressed: () {
                              getAccountsBloc.add(GetUserAccountsEvent());
                            },
                          );
                        } else if (accountstate is GetUserAccountsSuccess) {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: AppColor.backgroundColor,
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            // ignore: unnecessary_type_check
                                            state.userInfo.profilePhoto!,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      state.userInfo.username ?? '',
                                      style: const TextStyle(
                                        color: AppColor.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Spacer(),
                                    Radio<int>(
                                      value: 0,
                                      groupValue: 0,
                                      onChanged: (int? value) {
                                        // Handle radio button selection
                                      },
                                      activeColor: AppColor.white,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: accountstate.users.length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: accountWidget(
                                        accountstate: accountstate,
                                        index: index,
                                        onTap: () {
                                          getAccountsBloc.add(
                                            OnChangeAccountEvent(
                                              email: accountstate
                                                  .users[index].email!,
                                              password: accountstate
                                                  .users[index].password!,
                                            ),
                                          );
                                        },
                                        onChanged: (int? val) {
                                          final cartBloc =
                                              context.read<CartBlocBloc>();
                                          cartBloc.add(ClearCart());
                                          getAccountsBloc.add(
                                            OnChangeAccountEvent(
                                              email: accountstate
                                                  .users[index].email!,
                                              password: accountstate
                                                  .users[index].password!,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const AddAccountScreen();
                                        },
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 40.r,
                                        width: 40.r,
                                        decoration: BoxDecoration(
                                          color: AppColor.white,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          color: AppColor.backgroundColor,
                                          size: 30.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)
                                            .translate('add_account'),
                                        style: TextStyle(
                                          color: AppColor.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.userInfo.username ?? '',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.black,
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down_sharp,
            size: 15.sp,
          ),
        ],
      ),
    ),
  );
}
