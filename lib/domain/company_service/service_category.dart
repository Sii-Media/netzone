import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/company_service/company_service.dart';

class ServiceCategory extends Equatable {
  final String id;
  final String title;
  final String? titleAr;
  final List<CompanyService>? services;

  const ServiceCategory(
      {required this.id,
      required this.title,
      this.titleAr,
      required this.services});

  @override
  List<Object?> get props => [
        id,
        title,
        services,
        titleAr,
      ];
}
