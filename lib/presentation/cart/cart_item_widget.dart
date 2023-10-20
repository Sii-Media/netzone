import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';
import 'package:netzoon/presentation/cart/blocs/cart_bloc/cart_bloc_bloc.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/screen/product_details_screen.dart';

class CartItemWidget extends StatefulWidget {
  const CartItemWidget({
    super.key,
    required this.cart,
    required this.currency,
  });
  final CategoryProducts cart;
  final String currency;
  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  int _quantity = 1;
  late final CartBlocBloc cartBloc;
  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
      }
    });
  }

  @override
  void initState() {
    cartBloc = BlocProvider.of<CartBlocBloc>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ProductDetailScreen(item: widget.cart.id);
        }));
      },
      child: Card(
        shadowColor: AppColor.secondGrey,
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          // padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            // color: AppColor.secondGrey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Radio(
                value: "",
                groupValue: '',
                activeColor: AppColor.backgroundColor,
                onChanged: (val) {},
              ),
              Container(
                height: 70.h,
                width: 70.w,
                margin: const EdgeInsets.only(
                  right: 3.0,
                ),
                child: CachedNetworkImage(
                  imageUrl: widget.cart.imageUrl,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70.0, vertical: 50),
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                      color: AppColor.backgroundColor,

                      // strokeWidth: 10,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120.w,
                      child: Text(
                        widget.cart.name,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.backgroundColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 120.w,
                      child: Text(
                        widget.cart.description,
                        style: TextStyle(
                            color: AppColor.mainGrey, fontSize: 12.sp),
                      ),
                    ),
                    // Text(
                    //   widget.cart.priceAfterDiscount != null
                    //       ? '\$ ${widget.cart.priceAfterDiscount} '
                    //       : '\$ ${widget.cart.price} ',
                    //   style: TextStyle(
                    //     color: AppColor.black,
                    //     fontSize: 15.sp,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontSize: 10.sp, color: AppColor.backgroundColor),
                          children: <TextSpan>[
                            TextSpan(
                              text: widget.cart.priceAfterDiscount != null
                                  ? '${widget.cart.priceAfterDiscount}'
                                  : '${widget.cart.price}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: widget.currency,
                              style: TextStyle(
                                  color: AppColor.backgroundColor,
                                  fontSize: 10.sp),
                            )
                          ]),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          cartBloc.add(RemoveFromCart(
                            product: widget.cart,
                          ));
                        },
                        child: Icon(
                          Icons.delete_rounded,
                          color: AppColor.red,
                          size: 15.sp,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              _incrementQuantity();
                              cartBloc.add(ChangeQuantity(
                                  product: widget.cart, quantity: _quantity));
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                  color: AppColor.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 10,
                                        offset: const Offset(0, 3)),
                                  ]),
                              child: Icon(
                                Icons.add,
                                color: AppColor.red.withOpacity(0.6),
                                size: 15.sp,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Text(
                              '$_quantity',
                              style: TextStyle(
                                color: AppColor.black,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                                color: AppColor.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 3,
                                      blurRadius: 10,
                                      offset: const Offset(0, 3)),
                                ]),
                            child: InkWell(
                              onTap: () {
                                _decrementQuantity();
                                cartBloc.add(ChangeQuantity(
                                    product: widget.cart, quantity: _quantity));
                              },
                              child: Icon(
                                Icons.remove,
                                color: AppColor.red.withOpacity(0.6),
                                size: 15.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
