import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/news/entities/news_info.dart';
import 'package:netzoon/domain/news/usecases/get_all_news_usecase.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetAllNewsUseCase getAllNewsUseCase;
  NewsBloc({required this.getAllNewsUseCase}) : super(NewsInitial()) {
    on<GetAllNewsEvent>(
      (event, emit) async {
        emit(NewsInProgress());
        final news = await getAllNewsUseCase(NoParams());
        emit(
          news.fold(
            (failure) => NewsFailure(
              message: mapFailureToString(failure),
            ),
            (news) => NewsSuccess(news: news.news),
          ),
        );
      },
    );
  }
}
