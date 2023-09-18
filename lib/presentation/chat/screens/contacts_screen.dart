import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/categories/users/blocs/users_bloc/users_bloc.dart';

import '../../../domain/auth/entities/user_info.dart';
import '../../../injection_container.dart';
import '../../core/constant/colors.dart';
import '../../core/widgets/background_widget.dart';
import '../../core/widgets/on_failure_widget.dart';
import '../widgets/contacts_list_widget.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final userbloc = sl<UsersBloc>();
  @override
  void initState() {
    super.initState();
    userbloc.add(GetAllUsersEvent());
  }

  List<UserInfo> filteredUsers = [];
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        isHome: false,
        widget: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 20,
              ),
              child: Text(
                'Contacts',
                style: TextStyle(
                  color: AppColor.backgroundColor,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            BlocBuilder<UsersBloc, UsersState>(
              bloc: userbloc,
              builder: (context, state) {
                if (state is GetAllUsersInProgress) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.backgroundColor,
                    ),
                  );
                } else if (state is GetAllUsersFailure) {
                  final failure = state.message;
                  return FailureWidget(
                    failure: failure,
                    onPressed: () {
                      userbloc.add(GetAllUsersEvent());
                    },
                  );
                } else if (state is GetAllUsersSuccess) {
                  final filteredUsers = state.users
                      .where((user) => user.username!
                          .toLowerCase()
                          .contains(controller.text.toLowerCase()))
                      .toList();
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              color: AppColor.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.secondGrey.withOpacity(0.5),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 3),
                                ),
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 250.w,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: TextFormField(
                                    controller: controller,
                                    onChanged: (val) {
                                      setState(() {});
                                    },
                                    decoration: const InputDecoration(
                                        hintText: 'Search',
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.search,
                                color: AppColor.backgroundColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                      ContactsListWidget(users: filteredUsers),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
