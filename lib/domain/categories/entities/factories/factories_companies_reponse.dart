import 'package:equatable/equatable.dart';

import '../../../auth/entities/user_info.dart';

class FactoriesCompaniesResponse extends Equatable {
  final List<UserInfo> factories;

  const FactoriesCompaniesResponse({required this.factories});
  @override
  List<Object?> get props => [factories];
}
