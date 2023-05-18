part of 'add_product_bloc.dart';

abstract class AddProductEvent extends Equatable {
  const AddProductEvent();

  @override
  List<Object> get props => [];
}

class AddProductRequestedEvent extends AddProductEvent {
  final String departmentName;
  final String categoryName;
  final String name;
  final String description;
  final int price;
  final List<String>? images;
  final String? videoUrl;
  final String? guarantee;
  final String? property;
  final String? madeIn;
  final File image;

  const AddProductRequestedEvent({
    required this.departmentName,
    required this.categoryName,
    required this.name,
    required this.description,
    required this.price,
    this.images,
    this.videoUrl,
    this.guarantee,
    this.property,
    this.madeIn,
    required this.image,
  });
}
