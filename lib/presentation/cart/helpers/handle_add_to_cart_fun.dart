import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';
import 'package:netzoon/presentation/cart/blocs/cart_bloc/cart_bloc_bloc.dart';
import 'package:netzoon/presentation/cart/widgets/identity_alert_widget.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

void handleAddToCart(
    {required BuildContext context, required CategoryProducts product}) {
  final cartBloc = context.read<CartBlocBloc>();
  final cartItems = cartBloc.state.props;

  if (cartItems.any((element) => element.owner.id != product.owner.id)) {
    showIdentityAlert(context: context, cartBloc: cartBloc, product: product);
  } else {
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
          content: Text(
              AppLocalizations.of(context).translate('Product_added_to_cart')),
          backgroundColor: AppColor.backgroundColor,
          duration: const Duration(seconds: 2),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          AppLocalizations.of(context).translate('product_out_of_stock'),
          style: const TextStyle(color: AppColor.white),
        ),
        backgroundColor: AppColor.mainGrey,
        duration: const Duration(seconds: 2),
        showCloseIcon: true,
        elevation: 4,
      ));
    }
  }
}
