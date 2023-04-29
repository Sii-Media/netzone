import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/categories/entities/factory.dart';

class FactoriesCategories extends Equatable {
  final String title;
  final List<Factory> factory;

  const FactoriesCategories({required this.title, required this.factory});
  @override
  List<Object?> get props => [title, factory];
}
