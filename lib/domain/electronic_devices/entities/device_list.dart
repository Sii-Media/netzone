import 'package:equatable/equatable.dart';

class ItemList extends Equatable {
  final String deviceName;
  final String deviceImg;
  final String price;
  final String description;
  final String category;
  final String? year;
  final String? property;
  const ItemList({
    required this.deviceName,
    required this.deviceImg,
    required this.price,
    required this.description,
    required this.category,
    this.year,
    this.property,
  });
  @override
  List<Object?> get props => [deviceName, deviceImg];
}
