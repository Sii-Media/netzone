import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/departments/entities/departments_categories/departments_categories.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/ecommerce/screens/subsection_screen.dart';
import 'package:netzoon/presentation/language_screen/blocs/language_bloc/language_bloc.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class ListofItems extends StatefulWidget {
  const ListofItems({
    super.key,
    // required this.devices,
    required this.elec,
    required this.filter,
  });

  // final List<ElectronicDevice> devices;
  final List<DepartmentsCategories> elec;
  final String filter;
  @override
  State<ListofItems> createState() => _ListofItemsState();
}

class _ListofItemsState extends State<ListofItems> {
  late final LanguageBloc langBloc;
  @override
  void initState() {
    langBloc = BlocProvider.of<LanguageBloc>(context);
    langBloc.add(GetLanguage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, langState) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.elec.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return SizedBox(
                // width: MediaQuery.of(context).size.width * 0.34,
                width: 117.r,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(1000)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return SubSectionsScreen(
                              category: widget.elec[index].name,
                              filter: widget.filter,
                            );
                          }));
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 151,
                                    spreadRadius: 300,
                                    offset: Offset(10, 30))
                              ]),
                          // height: 300.h,
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: widget.elec[index].imageUrl ?? '',
                                fit: BoxFit.cover,
                                maxHeightDiskCache: 400,
                                maxWidthDiskCache: 400,
                                height: MediaQuery.of(context).size.height,
                                // placeholder: (context, url) =>
                                //     CircularProgressIndicator(),
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 70.0, vertical: 50),
                                  child: CircularProgressIndicator(
                                    value: downloadProgress.progress,
                                    color: AppColor.backgroundColor,

                                    // strokeWidth: 10,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 45.h,
                                  color:
                                      AppColor.backgroundColor.withOpacity(0.8),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      // AppLocalizations.of(context)
                                      //     .translate(widget.elec[index].name),
                                      langState is EnglishState
                                          ? widget.elec[index].name
                                          : widget.elec[index].nameAr ??
                                              widget.elec[index].name,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 8.dm,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
