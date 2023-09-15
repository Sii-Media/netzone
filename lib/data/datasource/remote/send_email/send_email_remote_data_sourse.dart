import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class SendEmailRemoteDataSource {
  Future<String> sendEmail(
    String name,
    String email,
    String subject,
    String message,
  );

  Future<String> sendEmailOnPayment(
      String toName,
      String toEmail,
      String userMobile,
      String productsNames,
      String grandTotal,
      String serviceFee);

  Future<String> sendEmailOnDelivery({
    required String toName,
    required String toEmail,
    required String mobile,
    required String city,
    required String addressDetails,
    required String floorNum,
    required String subject,
    required String from,
  });
}

class SendEmailRemoteDataSourceImpl implements SendEmailRemoteDataSource {
  @override
  Future<String> sendEmail(
      String name, String email, String subject, String message) async {
    const String serviceId = 'service_x67jyuw';
    const String templateId = 'template_cmny7bu';
    const String userId = 'W46O5SuH3NyMtu_gW';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'user_name': name,
          'user_email': email,
          'user_subject': subject,
          'user_message': message,
        }
      }),
    );
    return response.body;
  }

  @override
  Future<String> sendEmailOnPayment(
      String toName,
      String toEmail,
      String userMobile,
      String productsNames,
      String grandTotal,
      String serviceFee) async {
    const String serviceId = 'service_gho7z1b';
    const String templateId = 'template_cnm4fgb';
    const String userId = 'K-2rPXOy2bcBaUIoJ';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'user_name': toName,
          'user_mobile': userMobile,
          'user_email': toEmail,
          'products_names': productsNames,
          'grand_total': grandTotal,
          'service_fee': serviceFee,
        }
      }),
    );
    return response.body;
  }

  @override
  Future<String> sendEmailOnDelivery({
    required String toName,
    required String toEmail,
    required String mobile,
    required String city,
    required String addressDetails,
    required String floorNum,
    required String subject,
    required String from,
  }) async {
    const String serviceId = 'service_7yt10vg';
    const String templateId = 'template_2ptxcf9';
    const String userId = '2vGtyRz3bApfGj25l';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'to_name': toName,
          'to_email': toEmail,
          'subject': subject,
          'mobile': mobile,
          'city': city,
          'address_details': addressDetails,
          'floor_num': floorNum,
          'from': from,
        }
      }),
    );
    return response.body;
  }
}
