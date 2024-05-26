import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/navigation_provider.dart';
import 'package:weather_app/providers/weather_data_provider.dart';
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String locationName = "";
  double lat = 0;
  double long = 0;

  Future<void> setLocationName() async {
    List<Placemark> placemarks;
    try {
      print(lat);
      placemarks = await placemarkFromCoordinates(lat, long);
      if (placemarks.isNotEmpty) {
        Placemark locationInfo = placemarks[0];
        setState(() {
          // sets location name to be displayed on long press
          locationName = locationInfo.locality != ""
              ? '${locationInfo.locality ?? ""}, ${locationInfo.country ?? ""}'
              : locationInfo.country ?? "";
        });
      } else {
        setState(() {
          locationName = "Unknown location";
        });
      }
    } catch (e) {
      setState(() {
        locationName = "Error retrieving location";
      });
    }
  }

  void setLocationId(WeatherDataProvider weatherProvider,
      NavigationProvider navigationProvider) async {
    /*  final queryParams = {
      "latlng": "$lat,$long",
      "key": dotenv.env["MAPS_API_KEY"]
    }; */

    // get map location id to fetch weather info from provider
    /*  Uri locationIdCall =
        Uri.parse("https://maps.googleapis.com/maps/api/geocode/json")
            .replace(queryParameters: queryParams);
    http.Response response = await http.get(locationIdCall); */

    /*  if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey("results") && data["results"].isNotEmpty) {
        String locationId = data["results"][0]["place_id"]; */

    print("Map page $lat $long");
    weatherProvider.updateLocationIdWithCoordinates(
        lat.toString(), long.toString());
    //Navigator.pop(context);

    navigationProvider.setIndex(0);
    /*  } else {
        throw Exception("Invalid or empty response data");
      }
    } else {
      throw Exception("Failed to fetch location data: ${response.statusCode}");
    } */
  }

  Widget _showDialog(WeatherDataProvider weatherProvider,
      NavigationProvider navigationProvider) {
    return FutureBuilder(
      future: setLocationName(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(15),
          ),
          elevation: 40,
          content: Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(140, 190, 233, 1),
              border: Border.all(color: Colors.black, width: 3),
              borderRadius: BorderRadiusDirectional.circular(15),
            ),
            height: 280,
            child: snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(locationName,
                          style: TextStyle(fontSize: 20, fontFamily: "Lato")),
                      ElevatedButton(
                        onPressed: () {
                          setLocationId(weatherProvider, navigationProvider);
                        },
                        child: const Text(
                          "Go to weather",
                        ),
                        style: ButtonStyle(
                          elevation: WidgetStatePropertyAll(5),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    WeatherDataProvider weatherProvider =
        Provider.of<WeatherDataProvider>(context);
    NavigationProvider navigationProvider =
        Provider.of<NavigationProvider>(context);

    void handleLongPress(LatLng coord) {
      setState(() {
        lat = coord.latitude;
        long = coord.longitude;
      });

      showDialog(
          context: context,
          builder: ((context) =>
              _showDialog(weatherProvider, navigationProvider)));
    }

    List<String> coordinates = weatherProvider.getCoordinates();
    double latView = double.parse(coordinates[0]).truncateToDouble();
    double longVIew = double.parse(coordinates[1]).truncateToDouble();
    LatLng center = LatLng(latView, longVIew);
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: center, zoom: 11.0),
        onLongPress: handleLongPress,
      ),
    );
  }
}
