import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:netzoon/presentation/ecommerce/widgets/listsubsectionswidget.dart';

class SubSectionsScreen extends StatelessWidget {
  const SubSectionsScreen({super.key, required this.list});
  final List<dynamic> list;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          body: BackgroundWidget(
        widget: list.isEmpty
            ? Center(
                child: Text(
                  'لا يوجد عناصر',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.sp,
                  ),
                ),
              )
            : Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.all(15),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: DynamicHeightGridView(
                      itemCount: list.length,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      builder: (ctx, index) {
                        return ListSubSectionsWidget(
                          deviceList: list[index],
                        );

                        /// return your widget here.
                      }),
                ),
              ),
      )),
    );
  }
}
