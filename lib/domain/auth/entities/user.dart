import 'package:netzoon/domain/auth/entities/user_info.dart';

class User {
  final String token;
  final String refreshToken;
  final String message;
  final UserInfo userInfo;

  User({
    required this.token,
    required this.refreshToken,
    required this.message,
    required this.userInfo,
  });
}
