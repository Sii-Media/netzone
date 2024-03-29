import 'package:equatable/equatable.dart';

class LocalCompanyCategory extends Equatable {
  final String id;
  final String nameEn;
  final String nameAr;

  const LocalCompanyCategory(
      {required this.id, required this.nameEn, required this.nameAr});

  @override
  List<Object?> get props => [id, nameEn, nameAr];
}
