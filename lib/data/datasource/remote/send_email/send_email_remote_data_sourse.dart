import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class SendEmailRemoteDataSource {
  Future<String> sendEmail(
    String name,
    String email,
    String subject,
    String message,
  );
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
}
