import 'package:equatable/equatable.dart';

class ItemList extends Equatable {
  final String deviceName;
  final String deviceImg;
  final String price;
  final String description;
  final String category;
  final String? year;
  final String? property;
  final List<String>? images;
  final String? vedio;
  const ItemList({
    required this.deviceName,
    required this.deviceImg,
    required this.price,
    required this.description,
    required this.category,
    this.year,
    this.property,
    this.images,
    this.vedio,
  });
  @override
  List<Object?> get props => [deviceName, deviceImg];
}
