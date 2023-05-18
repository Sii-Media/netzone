import 'package:equatable/equatable.dart';

class Requests extends Equatable {
  final String address;
  final String text;

  const Requests({required this.address, required this.text});
  @override
  List<Object?> get props => [address, text];
}
