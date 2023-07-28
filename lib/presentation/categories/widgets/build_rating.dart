import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/profile/blocs/get_user/get_user_bloc.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import '../../home/blocs/elec_devices/elec_devices_bloc.dart';
import '../local_company/local_company_bloc/local_company_bloc.dart';

double rate = 0;
Widget buildRating(double userRate) {
  return RatingBar.builder(
    minRating: 1,
    maxRating: 5,
    initialRating: userRate,
    itemSize: 25,
    itemBuilder: (context, _) {
      return const Icon(
        Icons.star,
        color: Colors.amber,
      );
    },
    allowHalfRating: true,
    updateOnDrag: true,
    onRatingUpdate: (rating) {
      rate = rating;
    },
  );
}

void showRating(BuildContext context, GetUserBloc userBloc, String id,
        double userRate) =>
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(
            20.0,
          ), // Adjust the vertical padding as needed
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          title: const Text('Rating'),
          content: SizedBox(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)
                      .translate('please leave a star rating'),
                  style: const TextStyle(
                    color: AppColor.backgroundColor,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                buildRating(userRate)
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                userBloc.add(RateUserEvent(id: id, rating: rate));
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context).translate('submit'),
                style: const TextStyle(
                  color: AppColor.backgroundColor,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );

void showProductRating(
        {required BuildContext context,
        required ElecDevicesBloc productBloc,
        required String id,
        required double userRate}) =>
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(
            20.0,
          ), // Adjust the vertical padding as needed
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          title: const Text('Rating'),
          content: SizedBox(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)
                      .translate('please leave a star rating'),
                  style: const TextStyle(
                    color: AppColor.backgroundColor,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                buildRating(userRate)
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                productBloc.add(RateProductEvent(id: id, rating: rate));
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context).translate('submit'),
                style: const TextStyle(
                  color: AppColor.backgroundColor,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );

void showServiceRating(
        {required BuildContext context,
        required LocalCompanyBloc serviceBloc,
        required String id,
        required double userRate}) =>
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(
            20.0,
          ), // Adjust the vertical padding as needed
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          title: const Text('Rating'),
          content: SizedBox(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)
                      .translate('please leave a star rating'),
                  style: const TextStyle(
                    color: AppColor.backgroundColor,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                buildRating(userRate)
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                serviceBloc.add(RateCompanyServiceEvent(id: id, rating: rate));
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context).translate('submit'),
                style: const TextStyle(
                  color: AppColor.backgroundColor,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
