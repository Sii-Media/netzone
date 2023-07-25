// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_remote_data_source.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _VehicleRemoteDataSourceImpl implements VehicleRemoteDataSourceImpl {
  _VehicleRemoteDataSourceImpl(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'https://net-zoon.onrender.com';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<VehicleResponseModel> getAllCars(country) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'country': country};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<VehicleResponseModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/categories/cars',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = VehicleResponseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<VehicleResponseModel> getLatestCarByCreator(country) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'country': country};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<VehicleResponseModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/categories/latest-cars-by-creator',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = VehicleResponseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<VehicleResponseModel> getAllUsedPlanes(country) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'country': country};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<VehicleResponseModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/categories/planes/getoldplanes',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = VehicleResponseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<VehicleResponseModel> getAllNewPlanes(country) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'country': country};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<VehicleResponseModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/categories/planes/getnewplanes',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = VehicleResponseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<List<UserInfoModel>> getCarsCompanies(country) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'country': country};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<List<dynamic>>(_setStreamType<List<UserInfoModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/categories/cars-companies',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => UserInfoModel.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<UserInfoModel>> getPlanesCompanies(country) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'country': country};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<List<dynamic>>(_setStreamType<List<UserInfoModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/categories/planes-companies',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => UserInfoModel.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<VehicleModel>> getCompanyVehicles(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<List<dynamic>>(_setStreamType<List<VehicleModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/categories/company-vehicles/${id}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => VehicleModel.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<VehicleResponseModel> getAllPlanes(country) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'country': country};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<VehicleResponseModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/categories/planes',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = VehicleResponseModel.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
