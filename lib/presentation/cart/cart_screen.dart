import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/cart/blocs/cart_bloc/cart_bloc_bloc.dart';
import 'package:netzoon/presentation/cart/cart_item_widget.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double totalPrice = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CartBlocBloc, CartBlocState>(
        builder: (context, state) {
          if (state is CartLoaded) {
            if (state.props.isEmpty) {
              // setState(() {
              //   totalPrice = state.totalPrice;
              // });
              return Center(
                child: Text(
                  AppLocalizations.of(context).translate('empty_cart'),
                  style: TextStyle(
                    color: AppColor.backgroundColor,
                    fontSize: 22.sp,
                  ),
                ),
              );
            }
            return Container(
              padding: const EdgeInsets.only(
                top: 15,
              ),
              // height: 700.h,
              width: double.infinity,
              decoration: const BoxDecoration(
                // color: AppColor.secondGrey.withOpacity(0.3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                  topRight: Radius.circular(35.0),
                ),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: state.props.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return CartItemWidget(
                    cart: state.props[index],
                  );
                },
              ),
            );
          }
          return Container();
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 22.0),
        child: BottomAppBar(
          // elevation: 1,
          // color: Colors.red,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            height: 130.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('order_total'),
                      style: TextStyle(
                        color: AppColor.backgroundColor,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    BlocBuilder<CartBlocBloc, CartBlocState>(
                      builder: (context, state) {
                        if (state is CartLoaded) {
                          return Text(
                            '\$ ${state.totalPrice}',
                            style: TextStyle(
                              color: AppColor.backgroundColor,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                        return Text(
                          '\$ 0',
                          style: TextStyle(
                            color: AppColor.backgroundColor,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: AppColor.backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      AppLocalizations.of(context).translate('check_out'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColor.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
