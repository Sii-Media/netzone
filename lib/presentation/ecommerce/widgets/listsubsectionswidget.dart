import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:netzoon/presentation/cart/helpers/handle_add_to_cart_fun.dart';
import 'package:netzoon/presentation/cart/widgets/identity_alert_widget.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../../cart/blocs/cart_bloc/cart_bloc_bloc.dart';
import '../../core/blocs/country_bloc/country_bloc.dart';
import '../../core/helpers/get_currency_of_country.dart';
import '../../core/helpers/share_image_function.dart';

class ListSubSectionsWidget extends StatefulWidget {
  const ListSubSectionsWidget(
      {super.key,
      required this.deviceList,
      this.department,
      this.category,
      this.onTap});
  final CategoryProducts deviceList;
  final String? department;
  final String? category;
  final void Function()? onTap;
  @override
  State<ListSubSectionsWidget> createState() => _ListSubSectionsWidgetState();
}

class _ListSubSectionsWidgetState extends State<ListSubSectionsWidget> {
  late final CountryBloc countryBloc;
  final authBloc = sl<AuthBloc>();
  @override
  void initState() {
    countryBloc = BlocProvider.of<CountryBloc>(context);
    countryBloc.add(GetCountryEvent());
    authBloc.add(AuthCheckRequested());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<CountryBloc, CountryState>(
      bloc: countryBloc,
      builder: (context, state) {
        if (state is CountryInitial) {
          return BlocBuilder<AuthBloc, AuthState>(
            bloc: authBloc,
            builder: (context, authState) {
              return InkWell(
                onTap: widget.onTap,
                child: Card(
                  elevation: 3,
                  child: SizedBox(
                    height: 340.h,
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
                                maxHeightDiskCache: 400,
                                maxWidthDiskCache: 400,
                                matchTextDirection: true,
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.error,
                                  color: AppColor.red,
                                ),
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
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColor.black,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 65.h,
                                child: Text(
                                  widget.deviceList.description,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 4.0),
                                child: SizedBox(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                                style: TextStyle(
                                                    fontSize: 17.sp,
                                                    color: AppColor
                                                        .backgroundColor),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text:
                                                          '${widget.deviceList.price}',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        decoration: widget.deviceList
                                                                        .discountPercentage !=
                                                                    null &&
                                                                widget
                                                                        .deviceList
                                                                        .discountPercentage !=
                                                                    0
                                                            ? TextDecoration
                                                                .lineThrough
                                                            : TextDecoration
                                                                .none,
                                                      )),
                                                  TextSpan(
                                                    text:
                                                        getCurrencyFromCountry(
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
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  authState is Authenticated
                                                      ? authState.user.userInfo
                                                                  .id ==
                                                              widget.deviceList
                                                                  .owner.id
                                                          ? ScaffoldMessenger
                                                                  .of(context)
                                                              .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  AppLocalizations.of(
                                                                          context)
                                                                      .translate(
                                                                          'you_cannot_purchase_your_product'),
                                                                  style:
                                                                      const TextStyle(
                                                                    color: AppColor
                                                                        .white,
                                                                  ),
                                                                ),
                                                                backgroundColor:
                                                                    AppColor
                                                                        .red,
                                                              ),
                                                            )
                                                          : handleAddToCart(
                                                              context: context,
                                                              product: widget
                                                                  .deviceList)
                                                      : null;
                                                },
                                                child: Icon(
                                                  Icons.shopping_cart_outlined,
                                                  color:
                                                      AppColor.backgroundColor,
                                                  size: 23.sp,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 4.w,
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  await shareImageWithDescription(
                                                    imageUrl: widget
                                                        .deviceList.imageUrl,
                                                    description:
                                                        widget.deviceList.name,
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.share,
                                                  color:
                                                      AppColor.backgroundColor,
                                                  size: 23.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      widget.deviceList.discountPercentage !=
                                                  null &&
                                              widget.deviceList
                                                      .discountPercentage !=
                                                  0
                                          ? RichText(
                                              text: TextSpan(
                                                  style: TextStyle(
                                                      fontSize: 17.sp,
                                                      color: AppColor
                                                          .backgroundColor),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text:
                                                            '${widget.deviceList.priceAfterDiscount}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        )),
                                                    TextSpan(
                                                      text:
                                                          getCurrencyFromCountry(
                                                        state.selectedCountry,
                                                        context,
                                                      ),
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
                                      color:
                                          widget.deviceList.condition == 'new'
                                              ? Colors.red
                                              : Colors.yellow,
                                      borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(8)),
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context).translate(
                                          widget.deviceList.condition
                                              .toString()),
                                      style: TextStyle(
                                          color: widget.deviceList.condition ==
                                                  'new'
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
            },
          );
        }
        return Container();
      },
    );
  }
}
