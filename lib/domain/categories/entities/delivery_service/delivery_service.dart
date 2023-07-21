import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';

class DeliveryService extends Equatable {
  final String id;
  final String title;
  final String description;
  final String from;
  final String to;
  final int price;
  final UserInfo owner;

  const DeliveryService({
    required this.id,
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    required this.price,
    required this.owner,
  });
  @override
  List<Object?> get props => [title, description, from, to, price, owner];
}
