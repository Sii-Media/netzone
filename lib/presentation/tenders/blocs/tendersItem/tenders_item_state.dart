part of 'tenders_item_bloc.dart';

abstract class TendersItemState extends Equatable {
  const TendersItemState();

  @override
  List<Object> get props => [];
}

class TendersItemInitial extends TendersItemState {}

class TendersItemInProgress extends TendersItemState {}

class TendersItemSuccess extends TendersItemState {
  final List<TenderItem> tenderItems;

  const TendersItemSuccess({required this.tenderItems});
}

class TendersItemFailure extends TendersItemState {
  final String message;

  const TendersItemFailure({required this.message});
}
