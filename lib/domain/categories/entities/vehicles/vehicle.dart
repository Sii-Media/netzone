import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';

class Vehicle extends Equatable {
  final String name;
  final String imageUrl;
  final String description;
  final int price;
  final int kilometers;
  final String year;
  final String location;
  final String type;
  final String category;
  final UserInfo? creator;

  const Vehicle({
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.kilometers,
    required this.year,
    required this.location,
    required this.type,
    required this.category,
    this.creator,
  });
  @override
  List<Object?> get props => [
        name,
        imageUrl,
        description,
        price,
        kilometers,
        year,
        location,
        type,
        category,
        creator
      ];
}
