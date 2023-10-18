import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/custom_appbar.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class BackgroundTwoWidget extends StatefulWidget {
  final Widget widget;
  final String title;
  final bool isHome;
  const BackgroundTwoWidget({
    Key? key,
    required this.widget,
    required this.title,
    this.selectedValue,
    this.onChanged,
    required this.isHome,
  }) : super(key: key);
  final String? selectedValue;
  final void Function(String?)? onChanged;
  @override
  State<BackgroundTwoWidget> createState() => _BackgroundTwoWidgetState();
}

class _BackgroundTwoWidgetState extends State<BackgroundTwoWidget> {
  final TextEditingController search = TextEditingController();

  // final List<String> list = <String>['One', 'Two', 'Three', 'Four', 'Five'];
  final List<String> items = [
    'show_all',
    'company',
    'car',
    'planes',
    'real_estate',
    'product',
    'service'
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.22,
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
          //   height: MediaQuery.of(context).size.height,
          //   decoration: const BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage("assets/images/00.png"),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          CustomAppBar(
            context: context,
            isHome: widget.isHome,
          ),

          Positioned(
            top: 147.h,
            right: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Expanded(child: widget.widget),
                  SizedBox(
                    height: 140.h,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 100.h,
            right: 2.w,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                        fontSize: 22.sp, color: AppColor.backgroundColor),
                  ),
                ),
                DropdownButton2(
                  isExpanded: true,
                  hint: Row(
                    children: [
                      SizedBox(
                        width: 4.w,
                      ),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context).translate('show_all'),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  items: items
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              AppLocalizations.of(context).translate(item),
                              style: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  value: widget.selectedValue,
                  onChanged: widget.onChanged,
                  buttonStyleData: ButtonStyleData(
                    height: 40.h,
                    width: 170.w,
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.black26,
                      ),
                      color: Colors.white,
                    ),
                  ),
                  iconStyleData: IconStyleData(
                    icon: ClipRRect(
                      borderRadius: BorderRadius.circular(10000),
                      child: Container(
                        height: 20.r,
                        width: 20.r,
                        color: AppColor.backgroundColor,
                        child: const Icon(
                          color: AppColor.white,
                          Icons.arrow_downward_rounded,
                        ),
                      ),
                    ),
                    iconSize: 14.sp,
                    iconEnabledColor: Colors.black,
                    iconDisabledColor: Colors.grey,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 240.h,
                    width: 200.w,
                    padding: null,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white,
                    ),
                  ),
                ),
                // DropdownButtonExample(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      // isDense: false,

      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2.h,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
