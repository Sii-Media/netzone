import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:netzoon/domain/auth/repositories/auth_repository.dart';
import 'package:netzoon/injection_container.dart';

class InjectableModule {
  Dio get dioInstance {
    final dio = Dio(
      BaseOptions(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'clientTZ': 'Asia/Dubai',
          },
          validateStatus: (statusCode) {
            if (statusCode != null) {
              if (200 <= statusCode && statusCode < 300) {
                return true;
              } else {
                return false;
              }
            } else {
              return false;
            }
          }),
    );

    dio.interceptors.add(
      LogInterceptor(
          responseBody: true,
          requestBody: true,
          logPrint: (obj) {
            debugPrint(obj.toString());
          }),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) async {
          Map<String, String> headers;

          final failureOrUser = await sl<AuthRepository>().getSignedInUser();
          final user = failureOrUser.getOrElse(() => null);
          if (user != null) {
            headers = {'Authorization': 'Bearer ${user.token}'};
            request.headers.addAll(headers);
          }

          request.sendTimeout = const Duration(milliseconds: 60000);
          request.connectTimeout = const Duration(milliseconds: 60000);
          request.receiveTimeout = const Duration(milliseconds: 60000);

          return handler.next(request);
        },
      ),
    );

    return dio;
  }
}
