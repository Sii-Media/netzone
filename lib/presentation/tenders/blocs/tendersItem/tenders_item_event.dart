part of 'tenders_item_bloc.dart';

abstract class TendersItemEvent extends Equatable {
  const TendersItemEvent();

  @override
  List<Object> get props => [];
}

class GetTendersItemEvent extends TendersItemEvent {
  const GetTendersItemEvent();
}

class GetTendersItemByMinEvent extends TendersItemEvent {
  final String category;

  const GetTendersItemByMinEvent({required this.category});
}

class GetTendersItemByMaxEvent extends TendersItemEvent {
  final String category;

  const GetTendersItemByMaxEvent({required this.category});
}
