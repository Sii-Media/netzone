import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String url;
  final String name;

  const Category({required this.url, required this.name});
  @override
  List<Object?> get props => [url, name];
}
