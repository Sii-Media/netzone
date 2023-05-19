import 'package:equatable/equatable.dart';

class Complaints extends Equatable {
  final String address;
  final String text;
  final String? reply;
  final String? createdAt;

  const Complaints({
    required this.address,
    required this.text,
    this.reply,
    this.createdAt,
  });
  @override
  List<Object?> get props => [address, text, reply, createdAt];
}
