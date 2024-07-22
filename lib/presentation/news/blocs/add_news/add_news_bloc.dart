import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/auth/entities/user.dart';
import 'package:netzoon/domain/auth/usecases/get_signed_in_user_use_case.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/get_country_use_case.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/news/usecases/add_news_use_case.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';
import 'dart:io';

part 'add_news_event.dart';
part 'add_news_state.dart';

class AddNewsBloc extends Bloc<AddNewsEvent, AddNewsState> {
  final AddNewsUseCase addNewsUseCase;
  final GetSignedInUserUseCase getSignedInUser;
  final GetCountryUseCase getCountryUseCase;
  AddNewsBloc({
    required this.addNewsUseCase,
    required this.getSignedInUser,
    required this.getCountryUseCase,
  }) : super(AddNewsInitial()) {
    on<AddNewsRequested>((event, emit) async {
      emit(AddNewsInProgress());

      late String country;
      final result1 = await getCountryUseCase(NoParams());
      result1.fold((l) => null, (r) => country = r ?? 'AE');

      final result = await getSignedInUser.call(NoParams());
      late User user;
      result.fold((l) => null, (r) => user = r!);
      final failureOrNews = await addNewsUseCase(
        AddNewsParams(
            title: event.title,
            description: event.description,
            image: event.image,
            ownerName: event.ownerName,
            ownerImage: event.ownerImage,
            creator: user.userInfo.id,
            country: country),
      );

      emit(
        failureOrNews.fold(
          (failure) => AddNewsFailure(
              message: mapFailureToString(failure), failure: failure),
          (news) => AddNewsSuccess(news: news),
        ),
      );
    });
  }
}
