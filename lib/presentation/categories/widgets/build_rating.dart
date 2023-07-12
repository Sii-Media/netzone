import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

Widget buildRating() {
  return RatingBar.builder(
    minRating: 1,
    maxRating: 5,
    initialRating: 3,
    itemSize: 25,
    itemBuilder: (context, _) {
      return const Icon(
        Icons.star,
        color: Colors.amber,
      );
    },
    allowHalfRating: true,
    updateOnDrag: true,
    onRatingUpdate: (rating) {},
  );
}

void showRating(BuildContext context) => showDialog(
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
                buildRating()
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
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
