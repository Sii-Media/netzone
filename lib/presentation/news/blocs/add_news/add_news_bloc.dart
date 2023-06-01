import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/auth/entities/user.dart';
import 'package:netzoon/domain/auth/usecases/get_signed_in_user_use_case.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/news/usecases/add_news_use_case.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';
import 'dart:io';

part 'add_news_event.dart';
part 'add_news_state.dart';

class AddNewsBloc extends Bloc<AddNewsEvent, AddNewsState> {
  final AddNewsUseCase addNewsUseCase;
  final GetSignedInUserUseCase getSignedInUser;
  AddNewsBloc({required this.addNewsUseCase, required this.getSignedInUser})
      : super(AddNewsInitial()) {
    on<AddNewsRequested>((event, emit) async {
      emit(AddNewsInProgress());
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
        ),
      );

      emit(
        failureOrNews.fold(
          (failure) => AddNewsFailure(message: mapFailureToString(failure)),
          (news) => AddNewsSuccess(news: news),
        ),
      );
    });
  }
}
