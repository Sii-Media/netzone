import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constant/colors.dart';
import '../../core/widgets/background_widget.dart';
import '../widgets/contacts_list_widget.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
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
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              hintText: 'Search', border: InputBorder.none),
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
            const ContactsListWidget(),
          ],
        ),
      ),
    );
  }
}
