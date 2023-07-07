import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/search_location/autocomplate_prediction.dart';
import 'package:netzoon/presentation/search_location/network_utility.dart';
import 'package:netzoon/presentation/search_location/place_auto_complate_response.dart';

import 'location_list_tile.dart';

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({super.key});

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  List<AutocompletePrediction> placePredictions = [];
  void placeAutoComplete(String query) async {
    Uri uri = Uri.https(
      "maps.googleapis.com",
      'maps/api/place/autocomplete/json',
      {
        "input": query,
        "key": "AIzaSyCh9NuSRTyACfviwkWaNB2SnySHOno0daY",
      },
    );
    String? response = await Networkutility.fetchUrl(uri);

    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        setState(() {
          placePredictions = result.predictions!;
        });
      }
    }
  }

  void getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String address = placemark.name ?? placemark.thoroughfare ?? '';

        // Print the obtained address or place name
        print('Current Location: $address');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey.withOpacity(0.1),
            child: Icon(
              Icons.location_on_sharp,
              color: AppColor.secondGrey,
              size: 16,
            ),
          ),
        ),
        title: const Text(
          'Set Your Location',
          style: TextStyle(
            color: AppColor.black,
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.grey.withOpacity(0.2),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.close, color: Colors.black),
            ),
          ),
          const SizedBox(width: 8)
        ],
      ),
      body: Column(
        children: [
          Form(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: TextFormField(
                onChanged: (value) {
                  placeAutoComplete(value);
                },
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search your location',
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Icon(
                      Icons.location_searching_sharp,
                      color: AppColor.secondGrey,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Divider(
            height: 3,
            thickness: 3,
            color: Colors.grey.withOpacity(0.1),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: ElevatedButton.icon(
              onPressed: getCurrentLocation,
              icon: Icon(Feather.map_pin),
              label: Text(
                'Use My Current Location',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.withOpacity(0.2),
                foregroundColor: AppColor.mainGrey,
                elevation: 0,
                fixedSize: const Size(double.infinity, 40),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          Divider(
            height: 3,
            thickness: 3,
            color: Colors.grey.withOpacity(0.1),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: placePredictions.length,
              itemBuilder: (context, index) {
                return LocationListTile(
                  location: placePredictions[index].description!,
                  press: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
