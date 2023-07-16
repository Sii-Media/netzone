import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/search/search_screen.dart';

import '../../home/test.dart';
import '../../notifications/screens/notification_screen.dart';
import '../blocs/country_bloc/country_bloc.dart';
import '../constant/colors.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final BuildContext context;

  const CustomAppBar({Key? key, required this.context}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize =>
      Size.fromHeight(MediaQuery.of(context).size.height * 0.16);
}

class _CustomAppBarState extends State<CustomAppBar> {
  late String selectedCountry; // Default selected country
  List<String> countries = ['UAE', 'Egypt', 'Iraq', 'Jordan'];
  Map<String, String> currencies = {
    'AE': 'AED',
    'EG': 'EGP',
    'IQ': 'IQD',
    'JO': 'JOD',
  };
  // final countryBloc = sl<CountryBloc>();
  late final CountryBloc countryBloc;
  @override
  void initState() {
    countryBloc = BlocProvider.of<CountryBloc>(context);
    countryBloc.add(GetCountryEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final countryBloc = BlocProvider.of<CountryBloc>(context);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 150.w,
            padding: const EdgeInsets.only(
              left: 0,
              right: 5,
              bottom: 2,
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/netzoon-logo.png"),
              ),
            ),
          ),
          BlocBuilder<CountryBloc, CountryState>(
            builder: (context, state) {
              if (state is CountryInitial) {
                selectedCountry = state.selectedCountry;
                final currency = getCurrency(selectedCountry);
                return Row(
                  children: [
                    CountryCodePicker(
                      searchStyle: const TextStyle(color: AppColor.black),
                      dialogTextStyle: const TextStyle(
                        color: AppColor.black,
                      ),
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
                        setState(() {
                          selectedCountry = val.code!;
                          countryBloc.add(UpdateCountryEvent(selectedCountry));
                          Navigator.of(context, rootNavigator: true)
                              .pushReplacement(
                            MaterialPageRoute(builder: (context) {
                              return const TestScreen();
                            }),
                          );
                        });
                      },
                      initialSelection: selectedCountry,
                      favorite: const [
                        'EG',
                        'JO',
                        'IQ',
                        '+971',
                        'AE',
                      ],
                      showCountryOnly: true,
                      showFlag: true,
                      showFlagMain: true,
                      hideMainText: true,
                      showOnlyCountryWhenClosed: true,

                      padding: EdgeInsets.zero, // Remove padding
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      currency,
                      style: TextStyle(
                        color: AppColor.backgroundColor,
                        fontSize: 12.sp, // Adjust the font size
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const NotificatiionScreen();
                        }));
                      },
                      child: const Icon(
                        Icons.notifications,
                        color: AppColor.backgroundColor,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(CupertinoPageRoute(builder: (context) {
                          return const SearchPage();
                        }));
                      },
                      child: const Icon(
                        Icons.search,
                        color: AppColor.backgroundColor,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                  ],
                );
              }
              return Container();
            },
          )
        ],
      ),
    );
  }

  String getCurrency(String country) {
    switch (country) {
      case 'AE':
        return 'AED';
      case 'EG':
        return 'EGP';
      case 'JO':
        return 'JOD';
      case 'IQ':
        return 'IQD';
      case 'SA':
        return 'SAR';
      default:
        return 'USD';
    }
  }
}


        // DropdownButton<String>(
                  //   value: selectedCountry,
                  //   icon: const Icon(Icons.arrow_drop_down),
                  //   iconSize: 24,
                  //   elevation: 16,
                  //   style: const TextStyle(color: AppColor.backgroundColor),
                  //   underline: Container(
                  //     height: 2,
                  //     color: AppColor.backgroundColor,
                  //   ),
                  //   onChanged: (String? newValue) {
                  //     setState(() {
                  //       selectedCountry = newValue!;
                  //       countryBloc.add(UpdateCountryEvent(selectedCountry));
                  //     });
                  //   },
                  //   items:
                  //       countries.map<DropdownMenuItem<String>>((String value) {
                  //     return DropdownMenuItem<String>(
                  //       value: value,
                  //       child: Row(
                  //         children: [
                  //           CachedNetworkImage(
                  //             imageUrl: getFlagImage(value),
                  //             height: 20,
                  //             width: 20,
                  //           ),
                  //           const SizedBox(width: 8),
                  //           Text(value),
                  //         ],
                  //       ),
                  //     );
                  //   }).toList(),
                  // ),


                  /*  String getFlagImage(String country) {
    // Replace with appropriate flag image URLs for each country
    switch (country) {
      case 'UAE':
        return 'https://mybayutcdn.bayut.com/mybayut/wp-content/uploads/UAE-flag-history-A-06-08-1-1024x640.jpg';
      case 'Egypt':
        return 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fe/Flag_of_Egypt.svg/220px-Flag_of_Egypt.svg.png';
      case 'Iraq':
        return 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/Flag_of_Iraq.svg/255px-Flag_of_Iraq.svg.png';
      case 'Jordan':
        return 'https://a-z-animals.com/media/2023/01/iStock-1309094429.jpg';
      default:
        return '';
    }
  }*/