// import 'package:netzoon/domain/auth/repositories/auth_repository.dart';
// import 'package:netzoon/domain/core/error/failures.dart';
// import 'package:dartz/dartz.dart';
// import 'package:netzoon/domain/core/usecase/usecase.dart';
// import 'package:netzoon/domain/rating/entities/rating_response.dart';

// class GetUserTotalRatingUseCase extends UseCase<RatingResponse, String> {
//   final AuthRepository authRepository;

//   GetUserTotalRatingUseCase({required this.authRepository});
//   @override
//   Future<Either<Failure, RatingResponse>> call(String params) {
//     return authRepository.getUserTotalRating(id: params);
//   }
// }
