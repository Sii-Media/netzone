import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';

class CompanyService extends Equatable {
  final String id;
  final String title;
  final String description;
  final int price;
  final UserInfo owner;

  const CompanyService({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.owner,
  });
  @override
  List<Object?> get props => [title, description, price, owner];
}
