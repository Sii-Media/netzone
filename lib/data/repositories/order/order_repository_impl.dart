import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:netzoon/data/datasource/local/auth/auth_local_data_source.dart';
import 'package:netzoon/data/datasource/remote/auth/auth_remote_datasource.dart';
import 'package:netzoon/data/models/order/my_order_model.dart';
import 'package:netzoon/domain/order/repositories/order_repository.dart';

import '../../../domain/core/error/failures.dart';
import '../../../domain/order/entities/my_order.dart';
import '../../../domain/order/entities/order_input.dart';
import '../../core/utils/network/network_info.dart';
import '../../datasource/remote/order/order_remote_data_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  final NetworkInfo networkInfo;
  final OrderRemoteDataSource orderRemoteDataSource;
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDatasource local;
  OrderRepositoryImpl({
    required this.networkInfo,
    required this.orderRemoteDataSource,
    required this.authRemoteDataSource,
    required this.local,
  });
  @override
  Future<Either<Failure, List<MyOrder>>> getUserOrders(
      {required String userId}) async {
    try {
      if (await networkInfo.isConnected) {
        final orders = await orderRemoteDataSource.getUserOrders(userId);

        return Right(orders.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      print(e);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> saveOrder({
    required String userId,
    required String clientId,
    required List<OrderInput> products,
    required String orderStatus,
    required double grandTotal,
    required final String? shippingAddress,
    required final String? mobile,
    required final double? subTotal,
    required final double? serviceFee,
  }) async {
    try {
      Dio dio = Dio();

      if (await networkInfo.isConnected) {
        final user = local.getSignedInUser();
        if (user != null) {
          if (JwtDecoder.isExpired(user.token)) {
            try {
              if (JwtDecoder.isExpired(user.refreshToken)) {
                local.logout();
                return Left(UnAuthorizedFailure());
              }
            } catch (e) {
              return Left(UnAuthorizedFailure());
            }
            final refreshTokenResponse =
                await authRemoteDataSource.refreshToken(user.refreshToken);
            final newUser = user.copyWith(
                refreshTokenResponse.refreshToken, user.refreshToken);
            await local.signInUser(newUser);
            dio.options.headers['Authorization'] = 'Bearer ${newUser.token}';
          }
          final requestData = {
            "clientId": clientId,
            "products": products.map((product) {
              return {
                "product": product.product,
                "amount": product.amount,
                "qty": product.qty,
              };
            }).toList(),
            "orderStatus": orderStatus,
            "grandTotal": grandTotal,
            'shippingAddress': shippingAddress,
            'mobile': mobile,
            'subTotal': subTotal,
            'serviceFee': serviceFee,
          };
          final requestDataJson = jsonEncode(requestData);
          final response = await dio.post(
              'https://www.netzoonback.siidevelopment.com//order/save/$userId',
              data: requestDataJson);
          // Handle the response as needed
          if (response.statusCode == 200) {
            // Request was successful
            print("Order saved successfully!");

            print(response);
            return Right(response.data);
          } else {
            print("Request failed with status code: ${response.statusCode}");
            return Left(response.data);
            // Handle other status codes if necessary
          }
        } else {
          return Left(CredintialFailure());
        }
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      print(e);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<MyOrder>>> getClientOrders(
      {required String clientId}) async {
    try {
      if (await networkInfo.isConnected) {
        final orders = await orderRemoteDataSource.getClientOrders(clientId);
        print(orders);
        return Right(orders.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      print(e);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> updateOrderPickup(
      {required String id, required String pickupId}) async {
    try {
      if (await networkInfo.isConnected) {
        final pickupresult =
            await orderRemoteDataSource.updateOrderPickup(id, pickupId);

        return Right(pickupresult);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      print(e);
      return Left(ServerFailure());
    }
  }
}
