import 'package:equatable/equatable.dart';

class FactoryCompanies extends Equatable {
  final String id;
  final String name;
  final String imgurl;

  const FactoryCompanies(
      {required this.id, required this.name, required this.imgurl});
  @override
  List<Object?> get props => [id, name, imgurl];
}
