import 'package:equatable/equatable.dart';

class Factories extends Equatable {
  final String id;
  final String title;

  const Factories({required this.id, required this.title});
  @override
  List<Object?> get props => [id, title];
}
