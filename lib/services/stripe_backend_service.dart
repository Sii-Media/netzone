// lib/services/stripe-backend-service.dart
// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

class CreateAccountResponse {
  late String url;
  late bool success;

  CreateAccountResponse(this.url, this.success);
}

class CheckoutSessionResponse {
  late Map<String, dynamic> session;

  CheckoutSessionResponse(this.session);
}

class StripeBackendService {
  static String apiBase = 'https://net-zoon.onrender.com/user/api/stripe';
  static String createAccountUrl =
      '${StripeBackendService.apiBase}/account?mobile=true';
  static Map<String, String> headers = {'Content-Type': 'application/json'};

  static Future<CreateAccountResponse> createSellerAccount() async {
    print('2');
    var url = Uri.parse(StripeBackendService.createAccountUrl);
    print('3');
    var response = await http.get(url, headers: StripeBackendService.headers);
    print('4');
    print(response);
    Map<String, dynamic> body = jsonDecode(response.body);
    print(body['raw']['request_log_url']);
    return CreateAccountResponse(body['url'], true);
  }
}
