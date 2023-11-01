import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/aramex/entities/actual_weight.dart';
import 'package:netzoon/domain/aramex/entities/calculate_rate_input_data.dart';
import 'package:netzoon/domain/aramex/entities/calculate_rate_response.dart';
import 'package:netzoon/domain/aramex/entities/client_info.dart';
import 'package:netzoon/domain/aramex/entities/contact.dart';
import 'package:netzoon/domain/aramex/entities/create_pickup_input_data.dart';
import 'package:netzoon/domain/aramex/entities/create_pickup_response.dart';
import 'package:netzoon/domain/aramex/entities/create_shipment_input_data.dart';
import 'package:netzoon/domain/aramex/entities/create_shipment_response.dart';
import 'package:netzoon/domain/aramex/entities/details.dart';
import 'package:netzoon/domain/aramex/entities/label_info.dart';
import 'package:netzoon/domain/aramex/entities/party_address.dart';
import 'package:netzoon/domain/aramex/entities/pickup.dart';
import 'package:netzoon/domain/aramex/entities/pickup_items.dart';
import 'package:netzoon/domain/aramex/entities/shiper_consignee.dart';
import 'package:netzoon/domain/aramex/entities/shipment.dart';
import 'package:netzoon/domain/aramex/entities/shipment_dimensions.dart';
import 'package:netzoon/domain/aramex/entities/transaction.dart';
import 'package:netzoon/domain/aramex/usecases/calculate_rate_use_case.dart';
import 'package:netzoon/domain/aramex/usecases/create_pickup_use_case.dart';
import 'package:netzoon/domain/aramex/usecases/create_shipment_usecase.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'aramex_event.dart';
part 'aramex_state.dart';

class AramexBloc extends Bloc<AramexEvent, AramexState> {
  final CreatePickUpUseCase createPickUpUseCase;
  final CreateShipmentUseCase createShipmentUseCase;
  final CalculateRateUseCase calculateRateUseCase;
  AramexBloc({
    required this.createPickUpUseCase,
    required this.createShipmentUseCase,
    required this.calculateRateUseCase,
  }) : super(AramexInitial()) {
    on<CreatePickUpEvent>((event, emit) async {
      emit(CreatePickUpInProgress());

      final result = await createPickUpUseCase(event.createPickUpInputData);

      emit(
        result.fold(
          (l) => CreatePickUpInFailue(message: mapFailureToString(l)),
          (r) => CreatePickUpSuccess(createPickUpResponse: r),
        ),
      );
    });
    on<CreateShipmentEvent>((event, emit) async {
      emit(CreateShipmentInProgress());
      final result = await createShipmentUseCase(event.createShipmentInputData);
      emit(
        result.fold(
          (l) => CreateShipmentInFailue(message: mapFailureToString(l)),
          (r) => CreateShipmentSuccess(createShipmentResponse: r),
        ),
      );
    });

    on<CreatePickUpWithShipmentEvent>((event, emit) async {
      emit(CreatePickUpWithShipmentInProgress());

      const ClientInfo clientInfo = ClientInfo(
        source: 24,
        accountCountryCode: 'AE',
        accountEntity: 'DXB',
        accountPin: '116216',
        accountNumber: '45796',
        userName: 'testingapi@aramex.com',
        password: 'R123456789\$r',
        version: 'v1',
      );
      const LabelInfo labelInfo = LabelInfo(reportID: 9201, reportType: 'URL');

      const Transaction transaction = Transaction(
        reference1: 'reference1',
        reference2: '',
        reference3: '',
        reference4: '',
      );

      Map<String, List<CategoryProducts>> productGroups = {};
      for (var product in event.products) {
        if (!productGroups.containsKey(product.owner.username)) {
          productGroups[product.owner.username ?? ''] = [];
        }
        productGroups[product.owner.username]!.add(product);
      }
      for (var username in productGroups.keys) {
        final productsAtUserName = productGroups[username];
        final pickUpResult =
            await createPickUpUseCase(const CreatePickUpInputData(
                clientInfo: clientInfo,
                labelInfo: labelInfo,
                pickUp: PickUp(
                    pickupAddress: PartyAddress(
                      line1: 'Test Address',
                      line2: 'Test Address Line 2',
                      line3: '',
                      postCode: '',
                      stateOrProvinceCode: 'Dubai',
                      city: 'Dubai',
                      countryCode: 'AE',
                      longitude: 0,
                      latitude: 0,
                    ),
                    pickupContact: Contact(
                      department: 'Department',
                      personName: 'Test Company Name',
                      title: '',
                      companyName: 'companyName',
                      phoneNumber1: '97148707700',
                      cellPhone: '97148707700',
                      emailAddress: 'pickupemail@test.com',
                    ),
                    pickupLocation: 'Reception',
                    pickupDate: "/Date(1561975200000)/",
                    readyTime: "/Date(1561975200000)/",
                    lastPickupTime: "/Date(1561993200000)/",
                    closingTime: "/Date(1561993200000)/",
                    comments: '',
                    reference1: '001',
                    vehicle: 'Car',
                    pickupItems: [
                      PickupItems(
                          productGroup: 'EXP',
                          productType: 'PDX',
                          numberOfShipments: 1,
                          packageTypel: 'Box',
                          payment: 'P',
                          shipmentWeight: ActualWeight(unit: 'KG', value: 0.5),
                          numberOfPieces: 1,
                          shipmentDimensions: ShipmentDimensions(
                              length: 0, width: 0, height: 0, unit: ''),
                          comments: 'Test'),
                    ],
                    status: 'Ready',
                    branch: '',
                    routeCode: ''),
                transaction: transaction));
        pickUpResult.fold(
          (l) => emit(const CreatePickUpWithShipmentFailuer(
              message: 'Error in creating pickup')),
          (pickUpResult) async {
            final shipmentResult = await createShipmentUseCase(
                const CreateShipmentInputData(
                    shipments: [
                  Shipments(
                      reference1: null,
                      reference2: null,
                      reference3: null,
                      shipper: ShipperOrConsignee(
                        reference1: null,
                        accountNumber: '45796',
                        partyAddress: PartyAddress(
                          line1: 'Test Address',
                          line2: 'Test Address2',
                          line3: '',
                          city: 'Dubai',
                          stateOrProvinceCode: 'Dubai',
                          countryCode: 'AE',
                          postCode: '',
                          longitude: 0,
                          latitude: 0,
                        ),
                        contact: Contact(
                          department: 'Test Department',
                          personName: 'Test Person Name',
                          title: '',
                          companyName: 'companyName',
                          phoneNumber1: '97148707700',
                          cellPhone: '97148707700',
                          emailAddress: 'shipperemail@test.com',
                        ),
                      ),
                      consignee: ShipperOrConsignee(
                        reference1: null,
                        accountNumber: '45796',
                        partyAddress: PartyAddress(
                          line1: 'Test Address',
                          line2: 'Test Address2',
                          line3: '',
                          city: 'Dubai',
                          stateOrProvinceCode: 'Dubai',
                          countryCode: 'AE',
                          postCode: '',
                          longitude: 0,
                          latitude: 0,
                        ),
                        contact: Contact(
                          department: 'Test Department',
                          personName: 'Test Person Name',
                          title: '',
                          companyName: 'companyName',
                          phoneNumber1: '97148707700',
                          cellPhone: '97148707700',
                          emailAddress: 'shipperemail@test.com',
                        ),
                      ),
                      thirdParty: null,
                      shippingDateTime: "/Date(1698350400000)/",
                      dueDate: "/Date(1698350400000)/",
                      comments: '',
                      details: ShipmentDetails(
                          actualWeight: ActualWeight(unit: 'KG', value: 0.5),
                          descriptionOfGoods: 'Shoes',
                          goodsOriginCountry: 'AE',
                          numberOfPieces: 1,
                          productGroup: 'DOM',
                          productType: 'CDS',
                          paymentType: 'P'),
                      transportType: 0,
                      pickupGUID: '99065af6-45ea-43a4-8b15-a62f2aac7906')
                ],
                    labelInfo: labelInfo,
                    clientInfo: clientInfo,
                    transaction: transaction));
            emit(
              shipmentResult.fold(
                (l) => const CreatePickUpWithShipmentFailuer(
                    message: 'Error in create shipments'),
                (r) =>
                    CreatePickUpWithShipmentSuccess(createShipmentResponse: r),
              ),
            );
          },
        );
      }
    });
    on<CalculateRateEvent>((event, emit) async {
      emit(CalculateRateInProgress());
      final result = await calculateRateUseCase(event.calculateRateInputData);
      emit(result.fold(
          (failure) =>
              CalculateRateFailure(message: mapFailureToString(failure)),
          (calculateRateResponse) => CalculateRateSuccess(
              calculateRateResponse: calculateRateResponse)));
    });
  }
}
