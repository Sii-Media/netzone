import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../domain/categories/entities/vehicles/vehicle.dart';
import '../../../core/blocs/country_bloc/country_bloc.dart';
import '../../../core/constant/colors.dart';
import '../../../core/helpers/get_currency_of_country.dart';
import '../../../core/widgets/vehicle_details.dart';

class VehicleWidget extends StatelessWidget {
  final Vehicle vehicle;
  final CountryState countryState;
  const VehicleWidget({
    super.key,
    required this.vehicle,
    required this.countryState,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
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
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return VehicleDetailsScreen(vehicleId: vehicle.id ?? '');
                },
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  CachedNetworkImage(
                    imageUrl: vehicle.imageUrl,
                    height: 120.h,
                    width: 200.w,
                    fit: BoxFit.cover,
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
                  SizedBox(
                    height: 4.h,
                  ),
                  vehicle.forWhat != null && vehicle.forWhat != ''
                      ? SizedBox(
                          // height: 43.h,
                          child: Text(
                            vehicle.forWhat ?? '',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        )
                      : SizedBox(
                          height: 43.h,
                          child: Text(
                            vehicle.description,
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
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.only(right: 9.0, left: 9.0, bottom: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      vehicle.name,
                      style: const TextStyle(
                        color: AppColor.backgroundColor,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontSize: 13.sp, color: AppColor.backgroundColor),
                          children: <TextSpan>[
                            TextSpan(
                              text: '${vehicle.price}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: getCurrencyFromCountry(
                                countryState.selectedCountry,
                                context,
                              ),
                              style: TextStyle(
                                  color: AppColor.backgroundColor,
                                  fontSize: 10.sp),
                            )
                          ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
