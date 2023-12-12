import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/aramex/aramex_remote_data_source.dart';
import 'package:netzoon/data/models/aramex/calculate_rate_response_model.dart';
// import 'package:netzoon/data/models/aramex/create_pickup_input_data_model.dart';
import 'package:netzoon/data/models/aramex/create_pickup_response_model.dart';
// import 'package:netzoon/data/models/aramex/create_shipment_input_data_model.dart';
import 'package:netzoon/data/models/aramex/create_shipment_response_model.dart';
import 'package:netzoon/domain/aramex/entities/calculate_rate_input_data.dart';
import 'package:netzoon/domain/aramex/entities/calculate_rate_response.dart';
// import 'package:netzoon/domain/aramex/entities/client_info.dart';
import 'package:netzoon/domain/aramex/entities/create_pickup_input_data.dart';
import 'package:netzoon/domain/aramex/entities/create_pickup_response.dart';
import 'package:netzoon/domain/aramex/entities/create_shipment_input_data.dart';
import 'package:netzoon/domain/aramex/entities/create_shipment_response.dart';
// import 'package:netzoon/domain/aramex/entities/label_info.dart';
// import 'package:netzoon/domain/aramex/entities/pickup.dart';
// import 'package:netzoon/domain/aramex/entities/shipment.dart';
// import 'package:netzoon/domain/aramex/entities/transaction.dart';
import 'package:netzoon/domain/aramex/repositories/aramex_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';

class AramexRespositoryImpl implements AramexRepository {
  final AramexRemoteDataSource aramexRemoteDataSource;
  final NetworkInfo networkInfo;

  AramexRespositoryImpl(
      {required this.aramexRemoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, CreateShipmentResponse>> createShipment(
      {required CreateShipmentInputData createShipmentInputData}) async {
    try {
      if (await networkInfo.isConnected) {
        final dio = Dio();

        const requestUrl =
            "https://ws.aramex.net/shippingapi.v2/shipping/service_1_0.svc/json/CreateShipments";

        final requestBody = {
          "Shipments": [
            {
              "Reference1": null,
              "Reference2": null,
              "Reference3": null,
              "Shipper": {
                "Reference1": null,
                "Reference2": null,
                "AccountNumber": "71923340",
                "PartyAddress": {
                  "Line1": createShipmentInputData
                      .shipments.first.shipper.partyAddress.line1,
                  "Line2": createShipmentInputData
                      .shipments.first.shipper.partyAddress.line2,
                  "Line3": "",
                  "City": createShipmentInputData
                      .shipments.first.shipper.partyAddress.city,
                  "StateOrProvinceCode": createShipmentInputData
                      .shipments.first.shipper.partyAddress.city,
                  "PostCode": "",
                  "CountryCode": "AE",
                  "Longitude": 0,
                  "Latitude": 0,
                  "BuildingNumber": null,
                  "BuildingName": null,
                  "Floor": null,
                  "Apartme nt": null,
                  "POBox": null,
                  "Description": null
                },
                "Contact": {
                  "Department": createShipmentInputData
                      .shipments.first.shipper.contact.department,
                  "PersonName": createShipmentInputData
                      .shipments.first.shipper.contact.personName,
                  "Title": null,
                  "CompanyName": createShipmentInputData
                      .shipments.first.shipper.contact.companyName,
                  "PhoneNumber1": createShipmentInputData
                      .shipments.first.shipper.contact.phoneNumber1,
                  "PhoneNumber1Ext": null,
                  "PhoneNumber2": null,
                  "PhoneNumber2Ext": null,
                  "FaxNumber": null,
                  "CellPhone": createShipmentInputData
                      .shipments.first.shipper.contact.cellPhone,
                  "EmailAddress": createShipmentInputData
                      .shipments.first.shipper.contact.emailAddress,
                  "Type": null
                }
              },
              "Consignee": {
                "Reference1": null,
                "Reference2": null,
                "AccountNumber": null,
                "PartyAddress": {
                  "Line1": createShipmentInputData
                      .shipments.first.consignee.partyAddress.line1,
                  "Line2": createShipmentInputData
                      .shipments.first.consignee.partyAddress.line2,
                  "Line3": "",
                  "City": createShipmentInputData
                      .shipments.first.consignee.partyAddress.city,
                  "StateOrProvinceCode": createShipmentInputData
                      .shipments.first.consignee.partyAddress.city,
                  "PostCode": "",
                  "CountryCode": "AE",
                  "Longitude": 0,
                  "Latitude": 0,
                  "BuildingNumber": null,
                  "BuildingName": null,
                  "Floor": null,
                  "Apartment": null,
                  "POBox": null,
                  "Description": null
                },
                "Contact": {
                  "Department": createShipmentInputData
                      .shipments.first.consignee.contact.department,
                  "PersonName": createShipmentInputData
                      .shipments.first.consignee.contact.personName,
                  "Title": null,
                  "CompanyName": createShipmentInputData
                      .shipments.first.consignee.contact.companyName,
                  "PhoneNumber1": createShipmentInputData
                      .shipments.first.consignee.contact.phoneNumber1,
                  "PhoneNumber1Ext": null,
                  "PhoneNumber2": null,
                  "PhoneNumber2Ext": null,
                  "FaxNumber": null,
                  "CellPhone": createShipmentInputData
                      .shipments.first.consignee.contact.cellPhone,
                  "EmailAddress": createShipmentInputData
                      .shipments.first.consignee.contact.emailAddress,
                  "Type": null
                }
              },
              "ThirdParty": null,
              "ShippingDateTime":
                  createShipmentInputData.shipments.first.shippingDateTime,
              "DueDate": createShipmentInputData.shipments.first.dueDate,
              "Comments": null,
              "PickupLocation": null,
              "OperationsInstructions": null,
              "AccountingInstrcutions": null,
              "Details": {
                "Dimensions": null,
                "ActualWeight": {
                  "Unit": "KG",
                  "Value": createShipmentInputData
                      .shipments.first.details.actualWeight.value
                },
                "ChargeableWeight": null,
                "DescriptionOfGoods": createShipmentInputData
                    .shipments.first.details.descriptionOfGoods,
                "GoodsOriginCountry": "AE",
                "NumberOfPieces": createShipmentInputData
                    .shipments.first.details.numberOfPieces,
                "ProductGroup": "DOM",
                "ProductType": "CDS",
                "PaymentType": "P",
                "PaymentOptions": null,
                "CustomsValueAmount": null,
                "CashOnDeliveryAmount": null,
                "InsuranceAmount": null,
                "CashAdditionalAmount": null,
                "CashAdditionalAmountDescription": null,
                "CollectAmou nt": null,
                "Services": null,
                "Items": createShipmentInputData.shipments.first.details.items
                    ?.map((e) {
                  return {
                    "PackageType": "item",
                    "Quantity": e.quantity,
                    "Weight": {"Unit": "KG", "Value": e.weight.value},
                    "Comments": "item remark if any",
                    "Reference": "Item ref1",
                    "PiecesDimensions": null,
                    "CommodityCode": 640000,
                    "GoodsDescription": "desc",
                    "CountryOfOrigin": "AE",
                    "CustomsValue": {
                      "CurrencyCode": "AED",
                      "Value": e.customsValue.value
                    },
                    "ContainerNumber": null
                  };
                }).toList(),
                "DeliveryInstructions": null
              },
              "Attachments": null,
              "ForeignHAWB": null,
              "TransportType": 0,
              "PickupGUID": createShipmentInputData.shipments.first.pickupGUID,
              "Number": null,
              "ScheduledDelivery": null
            }
          ],
          "LabelInfo": {"ReportID": 9729, "ReportType": "URL"},
          "ClientInfo": {
            "Source": 24,
            "AccountCountryCode": "AE",
            "AccountEntity": "DXB",
            "AccountPin": "906169",
            "AccountNumber": "71923340",
            "UserName": "netzoon.2023@gmail.com",
            "Password": "Netzoon@123@aramex",
            "Version": "v1"
          },
          "Transaction": {
            "Reference1": "001",
            "Reference2": "",
            "Reference3": "",
            "Reference4": "",
            "Reference5": ""
          }
        };

        final response = await dio.post(
          requestUrl,
          data: requestBody,
        );

        if (response.statusCode == 200) {
          // Request was successful
          print('Success create shipmeeeeeeeent');
          print(response.data);
          final result = CreateShipmentResponseModel.fromJson(response.data);
          return Right(result.toDomain());
        } else {
          // Handle the error
          print(response.data);
          print('Error');
          return Left(ServerFailure());
        }
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, CreatePickUpResponse>> createPickUp(
      {required CreatePickUpInputData createPickUpInputData}) async {
    try {
      if (await networkInfo.isConnected) {
        final dio = Dio();

        const requestUrl =
            "https://ws.aramex.net/shippingapi.v2/shipping/service_1_0.svc/json/CreatePickup";

        final requestBody = {
          "ClientInfo": {
            "Source": 24,
            "AccountCountryCode": "AE",
            "AccountEntity": "DXB",
            "AccountPin": "906169",
            "AccountNumber": "71923340",
            "UserName": "netzoon.2023@gmail.com",
            "Password": "Netzoon@123@aramex",
            "Version": "v1"
          },
          "LabelInfo": {"ReportID": 9201, "ReportType": "URL"},
          "Pickup": {
            "PickupAddress": {
              "Line1": createPickUpInputData.pickUp.pickupAddress.line1,
              "Line2": createPickUpInputData.pickUp.pickupAddress.line2,
              "Line3": "",
              "City": createPickUpInputData.pickUp.pickupAddress.city,
              "StateOrProvinceCode":
                  createPickUpInputData.pickUp.pickupAddress.city,
              "PostCode": "",
              "CountryCode": "AE",
              "Longitude": 0,
              "Latitude": 0,
              "BuildingNumber": null,
              "BuildingName": null,
              "Floor": null,
              "Apartment": null,
              "POBox": null,
              "Description": null
            },
            "PickupContact": {
              "Department":
                  createPickUpInputData.pickUp.pickupContact.department,
              "PersonName":
                  createPickUpInputData.pickUp.pickupContact.personName,
              "Title": createPickUpInputData.pickUp.pickupContact.title,
              "CompanyName":
                  createPickUpInputData.pickUp.pickupContact.companyName,
              "PhoneNumber1":
                  createPickUpInputData.pickUp.pickupContact.phoneNumber1,
              "PhoneNumber1Ext": null,
              "PhoneNumber2": null,
              "PhoneNumber2Ext": null,
              "FaxNumber": null,
              "CellPhone": createPickUpInputData.pickUp.pickupContact.cellPhone,
              "EmailAddress":
                  createPickUpInputData.pickUp.pickupContact.emailAddress,
              "Type": null
            },
            "PickupLocation": createPickUpInputData.pickUp.pickupLocation,
            "PickupDate": createPickUpInputData.pickUp.pickupDate,
            "ReadyTime": createPickUpInputData.pickUp.readyTime,
            "LastPickupTime": createPickUpInputData.pickUp.lastPickupTime,
            "ClosingTime": createPickUpInputData.pickUp.closingTime,
            "Comments": "",
            "Reference1": "001",
            "Reference2": "",
            "Vehicle": "Car",
            "Shipments": null,
            "PickupItems": [
              {
                "ProductGroup":
                    createPickUpInputData.pickUp.pickupItems.first.productGroup,
                "ProductType":
                    createPickUpInputData.pickUp.pickupItems.first.productType,
                "NumberOfShipments": createPickUpInputData
                    .pickUp.pickupItems.first.numberOfShipments,
                "PackageType": "Box",
                "Payment":
                    createPickUpInputData.pickUp.pickupItems.first.payment,
                "ShipmentWeight": {
                  "Unit": "KG",
                  "Value": createPickUpInputData
                      .pickUp.pickupItems.first.shipmentWeight.value
                },
                "ShipmentVolume": null,
                "NumberOfPieces": createPickUpInputData
                    .pickUp.pickupItems.first.numberOfPieces,
                "CashAmount": null,
                "ExtraCharges": null,
                "ShipmentDimensions": {
                  "Length": 0,
                  "Width": 0,
                  "Height": 0,
                  "Unit": ""
                },
                "Comments": "Test"
              }
            ],
            "Status": "Ready",
            "ExistingShipments": null,
            "Branch": "",
            "RouteCode": ""
          },
          "Transaction": {
            "Reference1": "",
            "Reference2": "",
            "Reference3": "",
            "Reference4": "",
            "Reference5": ""
          }
        };

        final response = await dio.post(
          requestUrl,
          data: requestBody,
        );

        if (response.statusCode == 200) {
          // Request was successful
          // You can handle the response here
          print('suuuuuuuuuuuuccccccccccceeeeeeeeeesssssssssss');
          print(response.data);
          final createPickupResponse =
              CreatePickUpResponseModel.fromJson(response.data);

          return right(createPickupResponse.toDomain());
        } else {
          print('errrrrrrrrrrrrrrrrrrroooooooooor');
          // Handle the error
          return Left(ServerFailure());
        }
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      print(e);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, CalculateRateResponse>> calculateRate(
      {required CalculateRateInputData calculateRateInputData}) async {
    try {
      if (await networkInfo.isConnected) {
        final dio = Dio();

        const requestUrl =
            "https://ws.aramex.net/ShippingAPI.V2/RateCalculator/Service_1_0.svc/json/CalculateRate";

        final requestBody = {
          "OriginAddress": {
            "Line1": calculateRateInputData.originAddress.line1,
            "Line2": calculateRateInputData.originAddress.line2,
            "Line3": calculateRateInputData.originAddress.line3,
            "City": calculateRateInputData.originAddress.city,
            "StateOrProvinceCode":
                calculateRateInputData.originAddress.stateOrProvinceCode,
            "PostCode": "",
            "CountryCode": "AE",
            "Longitude": 0,
            "Latitude": 0,
            "BuildingNumber": null,
            "BuildingName": null,
            "Floor": null,
            "Apartment": null,
            "POBox": null,
            "Description": null
          },
          "DestinationAddress": {
            "Line1": calculateRateInputData.destinationAddress.line1,
            "Line2": calculateRateInputData.destinationAddress.line2,
            "Line3": null,
            "City": calculateRateInputData.destinationAddress.city,
            "StateOrProvinceCode": null,
            "PostCode": "",
            "CountryCode": "AE",
            "Longitude": 0,
            "Latitude": 0,
            "BuildingNumber": null,
            "BuildingName": null,
            "Floor": null,
            "Apartment": null,
            "POBox": null,
            "Description": null
          },
          "ShipmentDetails": {
            "Dimensions": null,
            "ActualWeight": {
              "Unit": "KG",
              "Value": calculateRateInputData.shipmentDetails.actualWeight.value
            },
            "ChargeableWeight": {"Unit": "KG", "Value": 0},
            "DescriptionOfGoods": null,
            "GoodsOriginCountry": null,
            "NumberOfPieces":
                calculateRateInputData.shipmentDetails.numberOfPieces,
            "ProductGroup": calculateRateInputData.shipmentDetails.productGroup,
            "ProductType": calculateRateInputData.shipmentDetails.productType,
            "PaymentType": calculateRateInputData.shipmentDetails.paymentType,
            "PaymentOptions": null,
            "CustomsValueAmount": null,
            "CashOnDeliveryAmount": null,
            "InsuranceAmount": null,
            "CashAdditionalAmount": null,
            "CashAdditionalAmountDescription": null,
            "CollectAmount": null,
            "Services": "",
            "Items": null,
            "DeliveryInstructions": null,
            "AdditionalProperties": null,
            "ContainsDangerousGoods": false
          },
          "PreferredCurrencyCode": "AED",
          "ClientInfo": {
            "Source": 24,
            "AccountCountryCode": "AE",
            "AccountEntity": "DXB",
            "AccountPin": "906169",
            "AccountNumber": "71923340",
            "UserName": "netzoon.2023@gmail.com",
            "Password": "Netzoon@123@aramex",
            "Version": "v1"
          },
          "Transaction": null
        };

        final response = await dio.post(
          requestUrl,
          data: requestBody,
        );

        if (response.statusCode == 200) {
          // Request was successful
          // You can handle the response here
          print('suuuuuuuuuuuuccccccccccceeeeeeeeeesssssssssss');
          print(response.data);
          final calculateRateResponse =
              CalculateRateResponseModel.fromJson(response.data);

          return right(calculateRateResponse.toDomain());
        } else {
          print('errrrrrrrrrrrrrrrrrrroooooooooor');
          // Handle the error
          return Left(ServerFailure());
        }
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      print(e);
      return Left(ServerFailure());
    }
  }
}
