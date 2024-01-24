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
  final Failure failure;
  const DealsItemsFailure({
    required this.message,
    required this.failure,
  });
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
  final Failure failure;
  const EditDealFailure({
    required this.message,
    required this.failure,
  });
}

class EditDealSuccess extends DealsItemsState {
  final String message;

  const EditDealSuccess({required this.message});
}

class DeleteDealInProgress extends DealsItemsState {}

class DeleteDealFailure extends DealsItemsState {
  final String message;
  final Failure failure;
  const DeleteDealFailure({
    required this.message,
    required this.failure,
  });
}

class DeleteDealSuccess extends DealsItemsState {
  final String message;

  const DeleteDealSuccess({required this.message});
}

class GetUserDealsInProgress extends DealsItemsState {}

class GetUserDealsFailure extends DealsItemsState {
  final String message;

  const GetUserDealsFailure({required this.message});
}

class GetUserDealsSuccess extends DealsItemsState {
  final List<DealsItems> deals;

  const GetUserDealsSuccess({required this.deals});
}

class PurchaseDealInProgress extends DealsItemsState {}

class PurchaseDealFailure extends DealsItemsState {
  final Failure failure;

  const PurchaseDealFailure({required this.failure});
}

class PurchaseDealSuccess extends DealsItemsState {
  final String message;

  const PurchaseDealSuccess({required this.message});
}
