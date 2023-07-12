import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/news/entities/news_info.dart';
import 'package:netzoon/domain/news/usecases/add_like_use_case.dart';
import 'package:netzoon/domain/news/usecases/get_all_news_usecase.dart';
import 'package:netzoon/domain/news/usecases/get_company_news_use_case.dart';
import 'package:netzoon/domain/news/usecases/get_news_by_id_use_case.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

import '../../../../domain/auth/entities/user.dart';
import '../../../../domain/auth/usecases/get_signed_in_user_use_case.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetAllNewsUseCase getAllNewsUseCase;
  final GetSignedInUserUseCase getSignedInUser;
  final ToggleOnLikeUseCase toggleOnLikeUseCase;
  final GetNewsByIdUseCase getNewsByIdUseCase;
  final GetCompanyNewsUseCase getCompanyNewsUseCase;
  NewsBloc({
    required this.getAllNewsUseCase,
    required this.getSignedInUser,
    required this.toggleOnLikeUseCase,
    required this.getNewsByIdUseCase,
    required this.getCompanyNewsUseCase,
  }) : super(NewsInitial()) {
    on<GetAllNewsEvent>(
      (event, emit) async {
        emit(NewsInProgress());
        final news = await getAllNewsUseCase(NoParams());
        final result = await getSignedInUser.call(NoParams());
        late User? user;
        result.fold((l) => null, (r) => user = r);
        emit(
          news.fold(
            (failure) => NewsFailure(
              message: mapFailureToString(failure),
            ),
            (news) => NewsSuccess(news: news.news, currentUser: user),
          ),
        );
      },
    );
    on<ToggleonlikeEvent>((event, emit) async {
      final result = await getSignedInUser.call(NoParams());
      late User user;
      result.fold((l) => null, (r) => user = r!);
      // ignore: unused_local_variable
      final response = await toggleOnLikeUseCase(
          ToggleOnLikeParams(newsId: event.newsId, userId: user.userInfo.id));
    });
    on<UserLikedNewsEvent>((event, emit) async {
      final result = await getSignedInUser.call(NoParams());
      late User user;
      result.fold((l) => null, (r) => user = r!);
      final state = this.state;
      if (state is NewsSuccess) {
        final news = state.news;
        final isLiked = news.any(
            (newsItem) => newsItem.likes?.contains(user.userInfo.id) ?? false);
        emit(state.copyWith(currentUser: user, isLiked: isLiked));
      }
    });
    on<GetNewsByIdEvent>((event, emit) async {
      emit(NewsInProgress());
      final news = await getNewsByIdUseCase(event.id);

      emit(
        news.fold(
          (failure) => NewsFailure(message: mapFailureToString(failure)),
          (news) => GetNewsByIdSuccess(news: news),
        ),
      );
    });
    on<GetCompanyNewsEvent>((event, emit) async {
      emit(NewsInProgress());
      final news = await getCompanyNewsUseCase(event.id);
      emit(
        news.fold(
          (failure) => NewsFailure(message: mapFailureToString(failure)),
          (news) {
            return GetCompanyNewsSuccess(news: news);
          },
        ),
      );
    });
  }
}

extension NewsStateCopyWithExtension on NewsState {
  NewsState copyWith({bool? isLiked, User? currentUser}) {
    if (this is NewsSuccess) {
      return NewsSuccess(
        news: (this as NewsSuccess).news,
        currentUser: currentUser!,
      );
    } else {
      return this;
    }
  }
}
