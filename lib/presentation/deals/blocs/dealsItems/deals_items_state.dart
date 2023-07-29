part of 'deals_items_bloc.dart';

abstract class DealsItemsState extends Equatable {
  const DealsItemsState();

  @override
  List<Object> get props => [];
}

class DealsItemsInitial extends DealsItemsState {}

class DealsItemsInProgress extends DealsItemsState {}

class DealsItemsSuccess extends DealsItemsState {
  final List<DealsItems> dealsItems;

  const DealsItemsSuccess({required this.dealsItems});
}

class DealsItemsFailure extends DealsItemsState {
  final String message;

  const DealsItemsFailure({required this.message});
}

class AddDealSuccess extends DealsItemsState {
  final String message;

  const AddDealSuccess({required this.message});
}

class GetDealByIdSuccess extends DealsItemsState {
  final DealsItems deal;

  const GetDealByIdSuccess({required this.deal});
}

class EditDealInProgress extends DealsItemsState {}

class EditDealFailure extends DealsItemsState {
  final String message;

  const EditDealFailure({required this.message});
}

class EditDealSuccess extends DealsItemsState {
  final String message;

  const EditDealSuccess({required this.message});
}

class DeleteDealInProgress extends DealsItemsState {}

class DeleteDealFailure extends DealsItemsState {
  final String message;

  const DeleteDealFailure({required this.message});
}

class DeleteDealSuccess extends DealsItemsState {
  final String message;

  const DeleteDealSuccess({required this.message});
}
