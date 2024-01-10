import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/categories/entities/vehicles/vehicle.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:netzoon/presentation/categories/vehicles/blocs/bloc/vehicle_bloc.dart';
import 'package:netzoon/presentation/chat/screens/chat_page_screen.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/helpers/connect_send_bird.dart';
import 'package:netzoon/presentation/core/helpers/map_to_date.dart';
import 'package:netzoon/presentation/core/helpers/show_image_dialog.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/core/widgets/on_failure_widget.dart';
import 'package:netzoon/presentation/core/widgets/phone_call_button.dart';
import 'package:netzoon/presentation/core/widgets/whatsapp_button.dart';
import 'package:netzoon/presentation/home/widgets/auth_alert.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

import 'package:video_player/video_player.dart';

import '../../categories/widgets/image_free_zone_widget.dart';
import '../blocs/country_bloc/country_bloc.dart';
import '../helpers/get_currency_of_country.dart';
import '../helpers/share_image_function.dart';

class VehicleDetailsScreen extends StatefulWidget {
  const VehicleDetailsScreen({super.key, required this.vehicleId});

  final String vehicleId;

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  late final CountryBloc countryBloc;
  final authBloc = sl<AuthBloc>();
  final vehicleBloc = sl<VehicleBloc>();
  @override
  void initState() {
    authBloc.add(AuthCheckRequested());
    vehicleBloc.add(GetVehicleByIdEvent(id: widget.vehicleId));
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(''))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9,
    );
    _videoPlayerController.setLooping(true);
    countryBloc = BlocProvider.of<CountryBloc>(context);
    countryBloc.add(GetCountryEvent());
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController input = TextEditingController();
    return Scaffold(
      body: BackgroundWidget(
        isHome: false,
        widget: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: 30.0.h, top: 20.h),
            child: BlocBuilder<CountryBloc, CountryState>(
              bloc: countryBloc,
              builder: (context, countryState) {
                if (countryState is CountryInitial) {
                  return BlocBuilder<VehicleBloc, VehicleState>(
                    bloc: vehicleBloc,
                    builder: (context, vehicleState) {
                      if (vehicleState is VehicleInProgress) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height - 170.h,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColor.backgroundColor,
                            ),
                          ),
                        );
                      } else if (vehicleState is VehicleFailure) {
                        final failure = vehicleState.message;
                        return FailureWidget(
                            failure: failure,
                            onPressed: () {
                              vehicleBloc.add(
                                  GetVehicleByIdEvent(id: widget.vehicleId));
                            });
                      } else if (vehicleState is GetVehicleByIdSuccess) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 7,
                                    color: Colors.grey.withOpacity(0.4),
                                  ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: vehicleState.vehicle.imageUrl,
                                    width: 700.w,
                                    height: 200.h,
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 70.0, vertical: 50),
                                      child: CircularProgressIndicator(
                                        value: downloadProgress.progress,
                                        color: AppColor.backgroundColor,

                                        // strokeWidth: 10,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                  style: TextStyle(
                                                      fontSize: 18.sp,
                                                      color: AppColor
                                                          .backgroundColor),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          '${vehicleState.vehicle.price}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          getCurrencyFromCountry(
                                                        countryState
                                                            .selectedCountry,
                                                        context,
                                                      ),
                                                      style: TextStyle(
                                                          color: AppColor
                                                              .backgroundColor,
                                                          fontSize: 14.sp),
                                                    )
                                                  ]),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                IconButton(
                                                  onPressed: () async {
                                                    await shareImageWithDescription(
                                                        imageUrl: vehicleState
                                                            .vehicle.imageUrl,
                                                        subject: vehicleState
                                                            .vehicle.name,
                                                        description:
                                                            'https://www.netzoon.com/home/vehicle/${vehicleState.vehicle.id}');
                                                  },
                                                  icon: Icon(
                                                    Icons.share,
                                                    color: AppColor
                                                        .backgroundColor,
                                                    size: 15.sp,
                                                  ),
                                                ),
                                                // const Icon(
                                                //   Icons.favorite_border,
                                                //   color: AppColor.backgroundColor,
                                                // ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 7.h,
                                        ),
                                        Text(
                                          vehicleState.vehicle.name,
                                          style: TextStyle(
                                            color: AppColor.black,
                                            fontSize: 22.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 7,
                                    color: Colors.grey.withOpacity(0.4),
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   AppLocalizations.of(context).translate('details'),
                                    //   style: TextStyle(
                                    //     color: AppColor.black,
                                    //     fontSize: 17.sp,
                                    //   ),
                                    // ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    titleAndInput(
                                      title: AppLocalizations.of(context)
                                          .translate('owner'),
                                      input: vehicleState
                                              .vehicle.creator?.username ??
                                          '',
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    titleAndInput(
                                      title: AppLocalizations.of(context)
                                          .translate('categ'),
                                      input: vehicleState.vehicle.category,
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    vehicleState.vehicle.aircraftType != null &&
                                            vehicleState.vehicle.aircraftType !=
                                                ''
                                        ? titleAndInput(
                                            title: AppLocalizations.of(context)
                                                .translate('aircraft_type'),
                                            input: vehicleState
                                                    .vehicle.aircraftType ??
                                                '',
                                          )
                                        : const SizedBox(),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    vehicleState.vehicle.shipType != null &&
                                            vehicleState.vehicle.shipType != ''
                                        ? titleAndInput(
                                            title: AppLocalizations.of(context)
                                                .translate('ship_type'),
                                            input:
                                                vehicleState.vehicle.shipType ??
                                                    '',
                                          )
                                        : const SizedBox(),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    vehicleState.vehicle.shipType != null &&
                                            vehicleState.vehicle.shipType != ''
                                        ? titleAndInput(
                                            title: AppLocalizations.of(context)
                                                .translate('ship_type'),
                                            input:
                                                vehicleState.vehicle.shipType ??
                                                    '',
                                          )
                                        : const SizedBox(),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    titleAndInput(
                                      title: AppLocalizations.of(context)
                                          .translate('contactNumber'),
                                      input:
                                          vehicleState.vehicle.contactNumber ??
                                              '',
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    titleAndInput(
                                      title: AppLocalizations.of(context)
                                          .translate('year'),
                                      input:
                                          formatDate(vehicleState.vehicle.year),
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    vehicleState.vehicle.kilometers != null
                                        ? titleAndInput(
                                            title: AppLocalizations.of(context)
                                                .translate('kilometers'),
                                            input: vehicleState
                                                .vehicle.kilometers
                                                .toString(),
                                          )
                                        : const SizedBox(),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    vehicleState.vehicle.regionalSpecs !=
                                                null &&
                                            vehicleState
                                                    .vehicle.regionalSpecs !=
                                                ''
                                        ? titleAndInput(
                                            title: AppLocalizations.of(context)
                                                .translate('regional_specs'),
                                            input: AppLocalizations.of(context)
                                                .translate(
                                                    '${vehicleState.vehicle.regionalSpecs}'),
                                          )
                                        : const SizedBox(),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    titleAndInput(
                                      title: AppLocalizations.of(context)
                                          .translate('address'),
                                      input: vehicleState.vehicle.location,
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    vehicleState.vehicle.manufacturer != null &&
                                            vehicleState.vehicle.manufacturer !=
                                                ''
                                        ? titleAndInput(
                                            title: AppLocalizations.of(context)
                                                .translate('manufacturer'),
                                            input: vehicleState
                                                    .vehicle.manufacturer ??
                                                '',
                                          )
                                        : const SizedBox(),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    vehicleState.vehicle.vehicleModel != null &&
                                            vehicleState.vehicle.vehicleModel !=
                                                ''
                                        ? titleAndInput(
                                            title: AppLocalizations.of(context)
                                                .translate('model'),
                                            input: vehicleState
                                                    .vehicle.vehicleModel ??
                                                '',
                                          )
                                        : const SizedBox(),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    vehicleState.vehicle.maxDistance != null &&
                                            vehicleState.vehicle.maxDistance !=
                                                ''
                                        ? titleAndInput(
                                            title: AppLocalizations.of(context)
                                                .translate('max_distance'),
                                            input: vehicleState
                                                    .vehicle.maxDistance ??
                                                '',
                                          )
                                        : const SizedBox(),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    vehicleState.vehicle.maxSpeed != null &&
                                            vehicleState.vehicle.maxSpeed != ''
                                        ? titleAndInput(
                                            title: AppLocalizations.of(context)
                                                .translate('max_speed'),
                                            input:
                                                vehicleState.vehicle.maxSpeed ??
                                                    '',
                                          )
                                        : const SizedBox(),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    vehicleState.vehicle.shipLength != null &&
                                            vehicleState.vehicle.shipLength !=
                                                ''
                                        ? titleAndInput(
                                            title: AppLocalizations.of(context)
                                                .translate('ship_length'),
                                            input: vehicleState
                                                    .vehicle.shipLength ??
                                                '',
                                          )
                                        : const SizedBox(),
                                    vehicleState.vehicle.exteriorColor != null
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 7.0),
                                            child: titleAndInput(
                                              title: AppLocalizations.of(
                                                      context)
                                                  .translate('exterior_color'),
                                              input: vehicleState
                                                      .vehicle.exteriorColor ??
                                                  '',
                                            ),
                                          )
                                        : const SizedBox(),
                                    vehicleState.vehicle.interiorColor != null
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 7.0),
                                            child: titleAndInput(
                                              title: AppLocalizations.of(
                                                      context)
                                                  .translate('interior_color'),
                                              input: vehicleState
                                                      .vehicle.interiorColor ??
                                                  '',
                                            ),
                                          )
                                        : const SizedBox(),
                                    vehicleState.vehicle.doors != null
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 7.0),
                                            child: titleAndInput(
                                              title:
                                                  AppLocalizations.of(context)
                                                      .translate('doors'),
                                              input:
                                                  '${vehicleState.vehicle.doors} doors',
                                            ),
                                          )
                                        : const SizedBox(),
                                    vehicleState.vehicle.bodyCondition !=
                                                null &&
                                            vehicleState
                                                    .vehicle.bodyCondition !=
                                                ''
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 7.0),
                                            child: titleAndInput(
                                              title: AppLocalizations.of(
                                                      context)
                                                  .translate('body_condition'),
                                              input: vehicleState
                                                      .vehicle.bodyCondition ??
                                                  '',
                                            ),
                                          )
                                        : const SizedBox(),
                                    vehicleState.vehicle.bodyType != null &&
                                            vehicleState.vehicle.bodyType != ''
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 7.0),
                                            child: titleAndInput(
                                              title:
                                                  AppLocalizations.of(context)
                                                      .translate('body_type'),
                                              input: vehicleState
                                                      .vehicle.bodyType ??
                                                  '',
                                            ),
                                          )
                                        : const SizedBox(),
                                    vehicleState.vehicle.mechanicalCondition !=
                                                null &&
                                            vehicleState.vehicle
                                                    .mechanicalCondition !=
                                                ''
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 7.0),
                                            child: titleAndInput(
                                              title: AppLocalizations.of(
                                                      context)
                                                  .translate(
                                                      'mechanical_condition'),
                                              input: vehicleState.vehicle
                                                      .mechanicalCondition ??
                                                  '',
                                            ),
                                          )
                                        : const SizedBox(),
                                    vehicleState.vehicle.seatingCapacity !=
                                                null &&
                                            vehicleState
                                                    .vehicle.seatingCapacity !=
                                                0
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 7.0),
                                            child: titleAndInput(
                                              title:
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'seating_capacity'),
                                              input:
                                                  '${vehicleState.vehicle.seatingCapacity} Seater',
                                            ),
                                          )
                                        : const SizedBox(),
                                    vehicleState.vehicle.numofCylinders != null
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 7.0),
                                            child: titleAndInput(
                                              title:
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'num_of_cylinders'),
                                              input:
                                                  '${vehicleState.vehicle.numofCylinders}',
                                            ),
                                          )
                                        : const SizedBox(),
                                    vehicleState.vehicle.transmissionType !=
                                                null &&
                                            vehicleState
                                                    .vehicle.transmissionType !=
                                                ''
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 7.0),
                                            child: titleAndInput(
                                              title:
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'transmission_type'),
                                              input: vehicleState.vehicle
                                                      .transmissionType ??
                                                  "",
                                            ),
                                          )
                                        : const SizedBox(),
                                    vehicleState.vehicle.horsepower != null &&
                                            vehicleState.vehicle.horsepower !=
                                                ''
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 7.0),
                                            child: titleAndInput(
                                              title:
                                                  AppLocalizations.of(context)
                                                      .translate('horsepower'),
                                              input: vehicleState
                                                      .vehicle.horsepower ??
                                                  "",
                                            ),
                                          )
                                        : const SizedBox(),
                                    vehicleState.vehicle.fuelType != null &&
                                            vehicleState.vehicle.fuelType != ''
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 7.0),
                                            child: titleAndInput(
                                              title:
                                                  AppLocalizations.of(context)
                                                      .translate('fuelType'),
                                              input: vehicleState
                                                      .vehicle.fuelType ??
                                                  "",
                                            ),
                                          )
                                        : const SizedBox(),
                                    vehicleState.vehicle.extras != null &&
                                            vehicleState.vehicle.extras != ''
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 7.0),
                                            child: titleAndInput(
                                              title:
                                                  AppLocalizations.of(context)
                                                      .translate('extras'),
                                              input:
                                                  vehicleState.vehicle.extras ??
                                                      "",
                                            ),
                                          )
                                        : const SizedBox(),
                                    vehicleState.vehicle.technicalFeatures !=
                                                null &&
                                            vehicleState.vehicle
                                                    .technicalFeatures !=
                                                ''
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 7.0),
                                            child: titleAndInput(
                                              title:
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'technicalFeatures'),
                                              input: vehicleState.vehicle
                                                      .technicalFeatures ??
                                                  "",
                                            ),
                                          )
                                        : const SizedBox(),
                                    vehicleState.vehicle.steeringSide != null &&
                                            vehicleState.vehicle.steeringSide !=
                                                ''
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 7.0),
                                            child: titleAndInput(
                                              title: AppLocalizations.of(
                                                      context)
                                                  .translate('steering_side'),
                                              input: vehicleState
                                                      .vehicle.steeringSide ??
                                                  "",
                                            ),
                                          )
                                        : const SizedBox(),
                                    vehicleState.vehicle.guarantee != null
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 7.0),
                                            child: titleAndInput(
                                              title:
                                                  AppLocalizations.of(context)
                                                      .translate('guarantee'),
                                              input: vehicleState
                                                          .vehicle.guarantee ==
                                                      true
                                                  ? 'applies'
                                                  : 'do not apply',
                                            ),
                                          )
                                        : const SizedBox(),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 7.0),
                                      child: titleAndInput(
                                        title: AppLocalizations.of(context)
                                            .translate('condition'),
                                        input: AppLocalizations.of(context)
                                            .translate(
                                                vehicleState.vehicle.type),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 7,
                                    color: Colors.grey.withOpacity(0.4),
                                  ),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)
                                        .translate('desc'),
                                    style: TextStyle(
                                      color: AppColor.black,
                                      fontSize: 17.sp,
                                    ),
                                  ),
                                  Text(
                                    vehicleState.vehicle.description,
                                    style: TextStyle(
                                      color: AppColor.mainGrey,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 7.h,
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 7,
                                    color: Colors.grey.withOpacity(0.4),
                                  ),
                                ),
                              ),
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${AppLocalizations.of(context).translate('images')} :',
                                    style: TextStyle(
                                      color: AppColor.black,
                                      fontSize: 17.sp,
                                    ),
                                  ),
                                  vehicleState.vehicle.carImages?.isNotEmpty ==
                                          true
                                      ? GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: vehicleState
                                              .vehicle.carImages?.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  childAspectRatio: 0.94),
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                showImageDialog(
                                                    context,
                                                    vehicleState
                                                        .vehicle.carImages!,
                                                    index);
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                child: ListOfPictures(
                                                  img: vehicleState.vehicle
                                                      .carImages![index],
                                                ),
                                              ),
                                            );
                                          })
                                      : GestureDetector(
                                          onTap: () {},
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate('no_images'),
                                            style: TextStyle(
                                              color: AppColor.mainGrey,
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 7,
                                    color: Colors.grey.withOpacity(0.4),
                                  ),
                                ),
                              ),
                              child: vehicleState.vehicle.vedioUrl != null &&
                                      vehicleState.vehicle.vedioUrl != ''
                                  // ? VideoFreeZoneWidget(
                                  //     title:
                                  //         "${AppLocalizations.of(context).translate('vedio')}  : ",
                                  //     vediourl: state.ads.advertisingVedio ?? '',
                                  //   )
                                  ? AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Chewie(
                                        controller: _chewieController,
                                      ),
                                    )
                                  : Text(
                                      AppLocalizations.of(context)
                                          .translate('no_vedio'),
                                      style: TextStyle(
                                        color: AppColor.mainGrey,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                            ),
                            SizedBox(
                              height: 110.h,
                            ),
                          ],
                        );
                      }
                      return const SizedBox();
                    },
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: BlocBuilder<VehicleBloc, VehicleState>(
        bloc: vehicleBloc,
        builder: (context, vehicleState) {
          return vehicleState is GetVehicleByIdSuccess
              ? BottomAppBar(
                  height: 60.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PhoneCallWidget(
                          phonePath: vehicleState.vehicle.contactNumber ?? "",
                          title:
                              AppLocalizations.of(context).translate('call')),
                      BlocBuilder<AuthBloc, AuthState>(
                        bloc: authBloc,
                        builder: (context, authState) {
                          return ElevatedButton(
                            onPressed: () {
                              if (authState is Authenticated) {
                                // await SendbirdChat.connect(
                                //     authState.user.userInfo
                                //             .username ??
                                //         '');
                                connectWithSendbird(
                                    username:
                                        authState.user.userInfo.username ?? '');
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return ChatPageScreen(
                                      userId:
                                          authState.user.userInfo.username ??
                                              '',
                                      otherUserId: vehicleState
                                              .vehicle.creator?.username ??
                                          '',
                                      title: vehicleState
                                              .vehicle.creator?.username ??
                                          '',
                                      image: vehicleState
                                              .vehicle.creator?.profilePhoto ??
                                          '',
                                    );
                                  }),
                                );
                              } else {
                                authAlert(context);
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                AppColor.backgroundColor,
                              ),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              )),
                              fixedSize: MaterialStateProperty.all(
                                Size.fromWidth(100.w),
                              ),
                            ),
                            child: Text(
                                AppLocalizations.of(context).translate('chat')),
                          );
                        },
                      ),
                      WhatsAppButton(
                          whatsappNumber:
                              vehicleState.vehicle.creator?.firstMobile ?? ''),
                      // ElevatedButton(
                      //     onPressed: () {},
                      //     style: ButtonStyle(
                      //       backgroundColor: MaterialStateProperty.all(
                      //         AppColor.backgroundColor,
                      //       ),
                      //       shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(18.0),
                      //       )),
                      //       fixedSize: MaterialStatePropertyAll(
                      //         Size.fromWidth(100.w),
                      //       ),
                      //     ),
                      //     child: Text(AppLocalizations.of(context).translate('chat'))),
                      // PriceSuggestionButton(input: input),
                    ],
                  ),
                )
              : const SizedBox();
        },
      ),
    );
  }

  Container titleAndInput({
    required String title,
    required String input,
  }) {
    return Container(
      height: 40.h,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.4),
            width: 1.0,
          ),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColor.black,
                fontSize: 15.sp,
              ),
            ),
            Text(
              input,
              style: TextStyle(
                color: AppColor.mainGrey,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
