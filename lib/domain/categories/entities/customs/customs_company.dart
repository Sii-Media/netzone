import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/categories/entities/customs_category.dart';

class CustomsCompanies extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final List<CustomsCategory> customsplaces;

  const CustomsCompanies(
      {required this.id,
      required this.name,
      required this.imageUrl,
      required this.customsplaces});

  @override
  List<Object?> get props => throw UnimplementedError();
}
