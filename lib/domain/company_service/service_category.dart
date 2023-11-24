import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/company_service/company_service.dart';

class ServiceCategory extends Equatable {
  final String id;
  final String title;
  final List<CompanyService>? services;

  const ServiceCategory(
      {required this.id, required this.title, required this.services});

  @override
  List<Object?> get props => [id, title, services];
}
