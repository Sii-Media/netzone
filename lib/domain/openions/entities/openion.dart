import 'package:equatable/equatable.dart';

class Openion extends Equatable {
  final String text;

  const Openion({required this.text});
  @override
  List<Object?> get props => [text];
}
