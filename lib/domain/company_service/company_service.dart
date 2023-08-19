import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';

class CompanyService extends Equatable {
  final String id;
  final String title;
  final String description;
  final int? price;
  final UserInfo owner;
  final String? imageUrl;
  final List<String>? serviceImageList;
  final String? whatsAppNumber;
  final double? averageRating;
  final double? totalRatings;
  final String? bio;
  final String? vedioUrl;
  const CompanyService({
    required this.id,
    required this.title,
    required this.description,
    this.price,
    required this.owner,
    this.imageUrl,
    this.serviceImageList,
    this.whatsAppNumber,
    this.averageRating,
    this.totalRatings,
    this.bio,
    this.vedioUrl,
  });
  @override
  List<Object?> get props => [
        title,
        description,
        price,
        owner,
        imageUrl,
        serviceImageList,
        whatsAppNumber,
        averageRating,
        totalRatings,
        bio,
        vedioUrl,
      ];
}
