import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/men_fashion/entities/men_fashion.dart';

class MenFashionList extends Equatable {
  final String name;
  final String imgUrl;
  final List<MenFashion> deviceList;

  const MenFashionList(
      {required this.name, required this.imgUrl, required this.deviceList});
  @override
  List<Object?> get props => [name, imgUrl, deviceList];
}
