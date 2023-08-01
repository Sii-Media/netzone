import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/screen/product_details_screen.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../../core/blocs/country_bloc/country_bloc.dart';
import '../../core/helpers/get_currency_of_country.dart';
import '../../core/helpers/share_image_function.dart';

class ListSubSectionsWidget extends StatefulWidget {
  const ListSubSectionsWidget(
      {super.key, required this.deviceList, this.department, this.category});
  final CategoryProducts deviceList;
  final String? department;
  final String? category;

  @override
  State<ListSubSectionsWidget> createState() => _ListSubSectionsWidgetState();
}

class _ListSubSectionsWidgetState extends State<ListSubSectionsWidget> {
  late final CountryBloc countryBloc;

  @override
  void initState() {
    countryBloc = BlocProvider.of<CountryBloc>(context);
    countryBloc.add(GetCountryEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<CountryBloc, CountryState>(
      bloc: countryBloc,
      builder: (context, state) {
        if (state is CountryInitial) {
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return ProductDetailScreen(
                      item: widget.deviceList.id,
                    );
                  },
                ),
              );
            },
            child: Card(
              elevation: 3,
              child: SizedBox(
                height: 300.h,
                child: Padding(
                  padding: EdgeInsets.all(size.height * 0.002),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 12.h,
                          ),
                          CachedNetworkImage(
                            imageUrl: widget.deviceList.imageUrl,
                            height: 140.h,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            height: 30.h,
                            child: Text(
                              widget.deviceList.name,
                              style: TextStyle(
                                color: AppColor.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                            child: Text(
                              widget.deviceList.description,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 4.0),
                            child: SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                            style: TextStyle(
                                                fontSize: 17.sp,
                                                color:
                                                    AppColor.backgroundColor),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text:
                                                      '${widget.deviceList.price}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    decoration: widget
                                                                .deviceList
                                                                .discountPercentage !=
                                                            null
                                                        ? TextDecoration
                                                            .lineThrough
                                                        : TextDecoration.none,
                                                  )),
                                              TextSpan(
                                                text: getCurrencyFromCountry(
                                                  state.selectedCountry,
                                                  context,
                                                ),
                                                style: TextStyle(
                                                    color: AppColor
                                                        .backgroundColor,
                                                    fontSize: 13.sp),
                                              )
                                            ]),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          await shareImageWithDescription(
                                            imageUrl:
                                                widget.deviceList.imageUrl,
                                            description: widget.deviceList.name,
                                          );
                                        },
                                        child: const Icon(
                                          Icons.share,
                                          color: AppColor.backgroundColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  widget.deviceList.discountPercentage != null
                                      ? RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                  fontSize: 17.sp,
                                                  color:
                                                      AppColor.backgroundColor),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        '${widget.deviceList.priceAfterDiscount}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    )),
                                                TextSpan(
                                                  text: '\$ ',
                                                  style: TextStyle(
                                                      color: AppColor
                                                          .backgroundColor,
                                                      fontSize: 10.sp),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '  ${widget.deviceList.discountPercentage?.round().toString()}% ${AppLocalizations.of(context).translate('OFF')}',
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14.sp),
                                                )
                                              ]),
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      widget.deviceList.condition != null
                          ? Positioned(
                              top: -2,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: widget.deviceList.condition == 'new'
                                      ? Colors.red
                                      : Colors.yellow,
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(8)),
                                ),
                                child: Text(
                                  AppLocalizations.of(context).translate(
                                      widget.deviceList.condition.toString()),
                                  style: TextStyle(
                                      color:
                                          widget.deviceList.condition == 'new'
                                              ? AppColor.white
                                              : AppColor.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.sp),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
