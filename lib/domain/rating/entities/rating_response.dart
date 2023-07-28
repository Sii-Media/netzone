import 'package:equatable/equatable.dart';

class RatingResponse extends Equatable {
  final String averageRating;

  const RatingResponse({required this.averageRating});

  @override
  List<Object?> get props => [averageRating];
}
