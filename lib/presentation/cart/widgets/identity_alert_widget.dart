import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';
import 'package:netzoon/presentation/cart/blocs/cart_bloc/cart_bloc_bloc.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

Future<dynamic> showIdentityAlert(
    {required BuildContext context,
    required CartBlocBloc cartBloc,
    required CategoryProducts product}) {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child:
            contentBox(cartBloc: cartBloc, context: context, product: product),
      );
    },
  );
}

Widget contentBox(
    {required BuildContext context,
    required CartBlocBloc cartBloc,
    required CategoryProducts product}) {
  return Stack(
    children: <Widget>[
      Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.info,
              color: Colors.blue,
              size: 40.sp,
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context).translate('start_new_cart'),
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context).translate('start_new_cart_caption'),
              style: TextStyle(fontSize: 16.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppLocalizations.of(context).translate('cancel'),
                    style: TextStyle(
                      color: AppColor.backgroundColor,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final cartItems = cartBloc.state.props;
                    cartBloc.add(ClearCart());
                    if (product.quantity! > 0) {
                      if (cartItems.any((elm) => elm.id == product.id)) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            AppLocalizations.of(context)
                                .translate('Product_Already_added_to_cart'),
                            style: const TextStyle(color: AppColor.white),
                          ),
                          backgroundColor: AppColor.red,
                          duration: const Duration(seconds: 2),
                        ));
                      } else {
                        cartBloc.add(AddToCart(product: product));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(AppLocalizations.of(context)
                              .translate('Product_added_to_cart')),
                          backgroundColor: AppColor.backgroundColor,
                          duration: const Duration(seconds: 2),
                        ));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          AppLocalizations.of(context)
                              .translate('product_out_of_stock'),
                          style: const TextStyle(color: AppColor.white),
                        ),
                        backgroundColor: AppColor.mainGrey,
                        duration: const Duration(seconds: 2),
                        showCloseIcon: true,
                        elevation: 4,
                      ));
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppLocalizations.of(context).translate('confirm'),
                    style: const TextStyle(
                      color: AppColor.red,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

void showOutOfStockDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: contentBox2(context),
      );
    },
  );
}

Widget contentBox2(context) {
  return Stack(
    children: <Widget>[
      Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.info,
              color: AppColor.red,
              size: 40,
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context).translate('exceeded_product_limit'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)
                  .translate('exceeded_product_limit_cap'),
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppLocalizations.of(context).translate('ok'),
                    style: const TextStyle(
                      color: AppColor.backgroundColor,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
