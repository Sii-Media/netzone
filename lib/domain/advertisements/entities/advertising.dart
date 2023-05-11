import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/advertisements/entities/advertisement.dart';

class Advertising extends Equatable {
  final String message;
  final List<Advertisement> advertisement;

  const Advertising({required this.message, required this.advertisement});

  @override
  List<Object?> get props => [message, advertisement];
}
