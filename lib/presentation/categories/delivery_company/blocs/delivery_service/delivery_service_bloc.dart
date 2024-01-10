import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/categories/entities/delivery_service/delivery_service.dart';
import 'package:netzoon/domain/categories/usecases/delivery_services/add_delivery_service_use_case.dart';
import 'package:netzoon/domain/categories/usecases/delivery_services/get_delivery_company_services_use_case.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

import '../../../../../domain/auth/entities/user.dart';
import '../../../../../domain/auth/usecases/get_signed_in_user_use_case.dart';
import '../../../../../domain/core/usecase/usecase.dart';

part 'delivery_service_event.dart';
part 'delivery_service_state.dart';

class DeliveryServiceBloc
    extends Bloc<DeliveryServiceEvent, DeliveryServiceState> {
  final GetDeliveryCompanyServicesUseCase getDeliveryCompanyServicesUseCase;
  final AddDeliveryServiceUseCase addDeliveryServiceUseCase;
  final GetSignedInUserUseCase getSignedInUserUseCase;

  DeliveryServiceBloc({
    required this.getDeliveryCompanyServicesUseCase,
    required this.addDeliveryServiceUseCase,
    required this.getSignedInUserUseCase,
  }) : super(DeliveryServiceInitial()) {
    on<GetDeliveryCompanyServicesEvent>((event, emit) async {
      emit(DeliveryServiceInProgress());
      // final result = await getSignedInUserUseCase.call(NoParams());
      // late User user;
      // result.fold((l) => null, (r) => user = r!);

      final services = await getDeliveryCompanyServicesUseCase(event.id);

      emit(
        services.fold(
          (failure) => DeliveryServiceFailure(
            message: mapFailureToString(failure),
            failure: failure,
          ),
          (services) => GetDeliveryCompanyServicesSuccess(services: services),
        ),
      );
    });
    on<AddDeliveryServiceEvent>((event, emit) async {
      emit(DeliveryServiceInProgress());
      final result = await getSignedInUserUseCase.call(NoParams());
      late User user;
      result.fold((l) => null, (r) => user = r!);
      final message = await addDeliveryServiceUseCase(AddDeliveryServiceParams(
        title: event.title,
        description: event.description,
        from: event.from,
        to: event.to,
        price: event.price,
        owner: user.userInfo.id,
      ));
      emit(
        message.fold(
          (failure) => DeliveryServiceFailure(
              message: mapFailureToString(failure), failure: failure),
          (message) => AddDeliverServiceSuccess(message: message),
        ),
      );
    });
  }
}
