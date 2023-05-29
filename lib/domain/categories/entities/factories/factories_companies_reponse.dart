import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/categories/entities/factories/factory_companies.dart';

class FactoriesCompaniesResponse extends Equatable {
  final List<FactoryCompanies> factories;

  const FactoriesCompaniesResponse({required this.factories});
  @override
  List<Object?> get props => [factories];
}
