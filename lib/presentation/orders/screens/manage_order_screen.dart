import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/order/entities/my_order.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/core/blocs/country_bloc/country_bloc.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/helpers/get_currency_of_country.dart';
import 'package:netzoon/presentation/orders/blocs/bloc/my_order_bloc.dart';
import 'package:netzoon/presentation/orders/screens/order_details_screen.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:netzoon/presentation/utils/convert_date_to_string.dart';

class ManageOrdersScreen extends StatefulWidget {
  const ManageOrdersScreen({super.key});

  @override
  State<ManageOrdersScreen> createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
  final orderBloc = sl<OrderBloc>();
  late final CountryBloc countryBloc;
  @override
  void initState() {
    super.initState();
    orderBloc.add(GetClientOrdersEvent());
    countryBloc = BlocProvider.of<CountryBloc>(context);
    countryBloc.add(GetCountryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.h,
        backgroundColor: AppColor.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_rounded,
            color: AppColor.backgroundColor,
            size: 22.sp,
          ),
        ),
        title: Text(
          AppLocalizations.of(context).translate('manage_orders'),
          style: const TextStyle(color: AppColor.backgroundColor),
        ),
      ),
      body: BlocBuilder<CountryBloc, CountryState>(
        bloc: countryBloc,
        builder: (context, countryState) {
          return BlocBuilder<OrderBloc, OrderState>(
            bloc: orderBloc,
            builder: (context, orderState) {
              if (orderState is GetClientOrdersInProgress) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.backgroundColor,
                  ),
                );
              } else if (orderState is GetClientOrdersFailure) {
                final failure = orderState.message;
                return Center(
                  child: Text(
                    failure,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                );
              } else if (orderState is GetClientOrdersSuccess) {
                List<MyOrder> reversedList =
                    orderState.orderList.reversed.toList();
                return orderState.orderList.isEmpty
                    ? _buildEmptyOrder()
                    : _buildOrderList(
                        orders: reversedList, countryState: countryState);
              }
              return const SizedBox();
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderList(
      {required List<MyOrder> orders, required CountryState countryState}) {
    // Replace with your order data fetching logic
    // List<Order> orders = getOrders();

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (ctx, index) {
        return InkWell(
          onTap: () {
            // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            //   return OrderDetailsScreen(
            //     order: orders[index],
            //   );
            // }));
          },
          child: Card(
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${AppLocalizations.of(context).translate('Order')} ${orders.length - (index)}',
                        style: TextStyle(
                            fontSize: 18.0.sp, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return OrderDetailsScreen(
                              order: orders[index],
                              client: true,
                            );
                          }));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.backgroundColor,
                          shadowColor: AppColor.black,
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(AppLocalizations.of(context)
                            .translate('show_details')),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '${AppLocalizations.of(context).translate('order_holder')}: ${orders[index].userId.username}', // Display the name of the order holder
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${AppLocalizations.of(context).translate('Date')}: ${formatDateTime(orders[index].createdAt ?? '')}',
                    style: TextStyle(
                      fontSize: 16.0.sp,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: orders[index].products.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, indexx) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0).r,
                            // child: Image.network(
                            //   'https://imageio.forbes.com/specials-images/imageserve/64e74ad803781abed13b0612/Apple--iPhone--iPhone-15--iPhone-15-Pro--iPhone-15-Pro-Max--iPhone-15-release--new/0x0.jpg?format=jpg&crop=1275,956,x113,y0,safe&width=960',
                            //   width: 80.0,
                            //   height: 80.0,
                            //   fit: BoxFit.cover,
                            // ),

                            child: CachedNetworkImage(
                              imageUrl: orders[index]
                                  .products[indexx]
                                  .product
                                  .imageUrl,
                              width: 80.w,
                              height: 120.h,
                              fit: BoxFit.contain,
                              maxHeightDiskCache: 400,
                              maxWidthDiskCache: 400,
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
                          ),
                          title: Text(
                            orders[index].products[indexx].product.name,
                            style: TextStyle(
                                fontSize: 16.0.sp, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  // const Text(
                  //   'Total Amount: \$ 400',
                  //   style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${AppLocalizations.of(context).translate('total_amount')}:',
                        style: TextStyle(
                          color: AppColor.backgroundColor,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      RichText(
                        text: TextSpan(
                            style: TextStyle(
                              fontSize: 17.sp,
                              color: AppColor.backgroundColor,
                              fontWeight: FontWeight.w700,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '${orders[index].subTotal}',
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyOrder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_checkout,
            color: AppColor.backgroundColor.withOpacity(0.3),
            size: 70,
          ),
          Text(
            AppLocalizations.of(context)
                .translate('you_dont_have_any_orders_yet'),
            style: TextStyle(
              color: AppColor.backgroundColor.withOpacity(0.5),
              fontSize: 23.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Text(
          //   '${AppLocalizations.of(context).translate('start_shopping')}!',
          //   style: TextStyle(
          //     color: AppColor.backgroundColor.withOpacity(0.3),
          //     fontSize: 20.sp,
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),
        ],
      ),
    );
  }
}
