// ignore_for_file: avoid_print, unused_local_variable, duplicate_ignore

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:netzoon/presentation/home/test.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/core/constants/constants.dart';
import '../injection_container.dart';
import 'core/blocs/country_bloc/country_bloc.dart';
import 'language_screen/blocs/language_bloc/language_bloc.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool isGetLocation = false;
  bool isFirstTime = false;
  final SharedPreferences preferences = sl<SharedPreferences>();
  // Future<Position> _getCurrentLocation() async {
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // If not, show a dialog to ask the user to enable it
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: const Text(
  //             'Location service is disabled',
  //             style: TextStyle(
  //               color: Colors.black,
  //             ),
  //           ),
  //           content: const Text(
  //             'Please enable location service in settings',
  //             style: TextStyle(
  //               color: Colors.black,
  //             ),
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 // Close the dialog
  //                 Navigator.of(context).pop();
  //               },
  //               child: const Text('OK'),
  //             ),
  //           ],
  //         ),
  //       );
  //     });
  //     // Location services are not enabled don't continue
  //     // accessing the position and request users of the
  //     // App to enable the location services.
  //     // return Future.error('Location services are disabled.');
  //   }
  //   Timer.periodic(const Duration(seconds: 1), (timer) async {
  //     // Check if location service is enabled
  //     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //     if (serviceEnabled) {
  //       // If enabled, cancel the timer and proceed to check permission
  //       timer.cancel();
  //       // Check the location permission status
  //       LocationPermission permission = await Geolocator.checkPermission();
  //       if (permission == LocationPermission.denied) {
  //         // If denied, request the permission
  //         permission = await Geolocator.requestPermission();
  //         if (permission == LocationPermission.denied) {
  //           // If still denied, show a dialog to inform the user
  //           WidgetsBinding.instance.addPostFrameCallback((_) {
  //             showDialog(
  //               context: context,
  //               builder: (context) => AlertDialog(
  //                 title: const Text('Location permission is denied'),
  //                 content: const Text(
  //                     'Please grant location permission in settings'),
  //                 actions: [
  //                   TextButton(
  //                     onPressed: () {
  //                       // Close the dialog
  //                       Navigator.of(context).pop();
  //                     },
  //                     child: const Text('OK'),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           });
  //           return;
  //         }
  //       }

  //       if (permission == LocationPermission.deniedForever) {
  //         // If denied forever, show a dialog to inform the user
  //         WidgetsBinding.instance.addPostFrameCallback((_) {
  //           showDialog(
  //             context: context,
  //             builder: (context) => AlertDialog(
  //               title: const Text('Location permission is denied forever'),
  //               content:
  //                   const Text('Please grant location permission in settings'),
  //               actions: [
  //                 TextButton(
  //                   onPressed: () {
  //                     // Close the dialog
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: const Text('OK'),
  //                 ),
  //               ],
  //             ),
  //           );
  //         });
  //         return;
  //       }

  //       // If permission is granted, get the current position
  //       // Update the state with the new position
  //       setState(() {
  //         isGetLocation = true;
  //       });
  //     }
  //   });

  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       // If still denied, show a dialog to inform the user
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         showDialog(
  //           context: context,
  //           builder: (context) => AlertDialog(
  //             title: const Text(
  //               'Location permission is denied',
  //               style: TextStyle(
  //                 color: Colors.black,
  //               ),
  //             ),
  //             content: const Text(
  //               'Please grant location permission in settings',
  //               style: TextStyle(
  //                 color: Colors.black,
  //               ),
  //             ),
  //             actions: [
  //               TextButton(
  //                 onPressed: () {
  //                   // Close the dialog
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: const Text('OK'),
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  //       // Permissions are denied, next time you could try
  //       // requesting permissions again (this is also where
  //       // Android's shouldShowRequestPermissionRationale
  //       // returned true. According to Android guidelines
  //       // your App should show an explanatory UI now.
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     // If denied forever, show a dialog to inform the user
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: const Text('Location permission is denied forever'),
  //           content: const Text('Please grant location permission in settings'),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 // Close the dialog
  //                 Navigator.of(context).pop();
  //               },
  //               child: const Text('OK'),
  //             ),
  //           ],
  //         ),
  //       );
  //     });
  //     // Permissions are denied forever, handle appropriately.
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //   return await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.best,
  //       timeLimit: const Duration(seconds: 20));
  // }
  Future<Position> _getCurrentLocation() async {
    // Check if location service is enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // If not enabled, show a dialog to ask the user to enable it
      _showLocationDisabledDialog();
      return Future.error('Location services are disabled.');
    }

    // Display a prominent disclosure dialog
    isFirstTime =
        preferences.getBool(SharedPreferencesKeys.isFirstTimeLogged) != false;
    print(isFirstTime);
    isFirstTime == true
        ? preferences.setBool(SharedPreferencesKeys.isFirstTimeLogged, false)
        : true;
    bool userConsent =
        isFirstTime == false ? false : await _showLocationDisclosureDialog();
    if (!userConsent) {
      // If the user doesn't consent, handle it accordingly
      return Future.error('User did not consent to location access.');
    }

    // Check the location permission status
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Request the permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // _showPermissionDeniedDialog();
        return Future.error('Location permissions are denied.');
      } else if (permission == LocationPermission.deniedForever) {
        // _showPermissionDeniedForeverDialog();
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
    }

    // If permission is granted, get the current position
    setState(() {
      isGetLocation = true;
    });

    // Return the current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      timeLimit: const Duration(seconds: 20),
    );
  }

  void _showLocationDisabledDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Location service is disabled',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          content: const Text(
            'Please enable location service in settings',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  void _showPermissionDeniedDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Location permission is denied'),
          content: const Text('Please grant location permission in settings'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  void _showPermissionDeniedForeverDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Location permission is denied forever'),
          content: const Text('Please grant location permission in settings'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  Future<bool> _showLocationDisclosureDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
                AppLocalizations.of(context).translate('Location Permission')),
            content: Text(
              AppLocalizations.of(context).translate(
                  'To provide you with the best delivery experience, our app needs access to your location.'),
              style: const TextStyle(color: AppColor.black),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
            contentTextStyle: const TextStyle(fontSize: 16.0),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // User consents
                },
                child: Text(
                  AppLocalizations.of(context).translate('Yes, I understand'),
                  style: const TextStyle(color: AppColor.backgroundColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // User does not consent
                },
                child: Text(
                  AppLocalizations.of(context)
                      .translate('No, I prefer not to share'),
                  style: const TextStyle(color: AppColor.backgroundColor),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  void initState() {
    _getCurrentLocation().then((value) => {
          // ignore: avoid_print
          print('${value.latitude}'),
        });
    setState(() {
      isGetLocation = true;
    });

    currentCode = preferences.getString(SharedPreferencesKeys.language) ?? 'ar';
    currentLanguage = currentCode == 'en' ? 'English' : 'Arabic';
    super.initState();
  }

  bool choosedLanguage = false;
  String selectedCountry = 'AE';
  @override
  Widget build(BuildContext context) {
    final countryBloc = BlocProvider.of<CountryBloc>(context);
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(color: AppColor.backgroundColor),
        ),
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/logo.png"),
            ),
          ),
        ),
        Positioned(
          top: 450.h,
          bottom: 0,
          right: 0,
          left: 0,
          child: isGetLocation
              ? Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 2.0, color: AppColor.white),
                          bottom: BorderSide(width: 2.0, color: AppColor.white),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          showLanguageDialog(context);
                        },
                        child: Text(
                          AppLocalizations.of(context)
                              .translate(currentLanguage),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColor.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocBuilder<CountryBloc, CountryState>(
                      builder: (context, state) {
                        selectedCountry = state.selectedCountry;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            border: Border(
                              top:
                                  BorderSide(width: 2.0, color: AppColor.white),
                              bottom:
                                  BorderSide(width: 2.0, color: AppColor.white),
                            ),
                          ),
                          child: CountryCodePicker(
                            searchStyle: const TextStyle(color: AppColor.black),
                            dialogTextStyle: TextStyle(
                                color: AppColor.black, fontSize: 10.sp),
                            boxDecoration: BoxDecoration(
                              color: const Color.fromARGB(255, 209, 219, 235)
                                  .withOpacity(0.8),
                            ),

                            textStyle: TextStyle(
                              color: AppColor.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                            ),
                            onChanged: (val) {
                              selectedCountry = val.code ?? 'AE';
                              // print(val);
                              countryBloc
                                  .add(UpdateCountryEvent(selectedCountry));

                              // sendMessageToRecipient();
                            },
                            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                            initialSelection: selectedCountry,
                            favorite: const [
                              'EG',
                              'JO',
                              'IQ',
                              '+971',
                              'AE',
                              'SA'
                            ],
                            // optional. Shows only country name and flag
                            showCountryOnly: true,
                            // optional. Shows only country name and flag when popup is closed.
                            showOnlyCountryWhenClosed: true,
                            // optional. aligns the flag and the Text left
                            alignLeft: false,
                            // backgroundColor: AppColor.backgroundColor,
                            // barrierColor: AppColor.backgroundColor,
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                              return const TestScreen();
                            }),
                          );
                        },
                        style: ButtonStyle(
                            side: const MaterialStatePropertyAll(
                              BorderSide(
                                color: AppColor.white,
                              ),
                            ),
                            backgroundColor: const MaterialStatePropertyAll(
                                AppColor.backgroundColor),
                            fixedSize: MaterialStatePropertyAll(
                                Size.fromWidth(100.w))),
                        child: Text(
                          AppLocalizations.of(context).translate('next'),
                        ),
                      ),
                      // child: Container(
                      //   margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      //   width: 150.w,
                      //   decoration: const BoxDecoration(
                      //     border: Border(
                      //       top: BorderSide(width: 2.0, color: AppColor.white),
                      //       bottom:
                      //           BorderSide(width: 2.0, color: AppColor.white),
                      //     ),
                      //   ),
                      //   child: TextButton(
                      //     onPressed: () {
                      //       Navigator.of(context).pushReplacement(
                      //         MaterialPageRoute(builder: (context) {
                      //           return const TestScreen();
                      //         }),
                      //       );
                      //     },
                      //     child: Text(
                      //       AppLocalizations.of(context).translate('next'),
                      //       style: const TextStyle(
                      //         fontSize: 14,
                      //         fontWeight: FontWeight.w600,
                      //         color: AppColor.white,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    )
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.white,
                  ),
                ),
        ),
      ],
    );
  }

  final List<Map<String, String>> languages = [
    {'name': 'English', 'code': 'en'},
    {'name': 'Arabic', 'code': 'ar'},
  ];

  // Define the current language and its code
  String currentLanguage = 'Arabic';
  String currentCode = 'ar';

  void showLanguageDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              // margin: const EdgeInsets.only(bottom: 60),
              color: AppColor.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Loop through the languages and create radio buttons
                  for (var language in languages)
                    RadioListTile<String>(
                      activeColor: AppColor.backgroundColor,
                      title: Text(
                        AppLocalizations.of(context)
                            .translate(language['name']!),
                        style: const TextStyle(color: AppColor.backgroundColor),
                      ),
                      value: language['code'] ?? '',
                      groupValue: currentCode,
                      onChanged: (value) {
                        // Update the state when a radio button is selected
                        setState(() {
                          currentCode = value!;
                          currentLanguage = language['name']!;
                        });
                        BlocProvider.of<LanguageBloc>(context)
                            .add(ChooseOnetherLang(currentCode));
                        // Close the dialog after selection
                        Navigator.pop(context);
                        setState(() {
                          choosedLanguage = true;
                        });
                      },
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
