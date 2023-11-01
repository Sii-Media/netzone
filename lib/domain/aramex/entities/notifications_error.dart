import 'package:equatable/equatable.dart';

class NotificationsError extends Equatable {
  final String code;
  final String message;

  const NotificationsError({required this.code, required this.message});

  @override
  List<Object?> get props => [code, message];
}
