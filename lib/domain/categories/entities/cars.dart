import 'package:equatable/equatable.dart';

class Cars extends Equatable {
  final String name;
  final String description;
  final String imageUrl;
  final String price;
  final String kilometers;
  final String year;
  final String location;
  final String type;

  const Cars({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.kilometers,
    required this.year,
    required this.location,
    required this.type,
  });

  @override
  List<Object?> get props =>
      [name, description, imageUrl, price, kilometers, year, location, type];
}
