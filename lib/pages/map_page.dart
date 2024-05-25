import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/pages/weather_page.dart';
import 'package:weather_app/providers/weather_data_provider.dart';

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
      placemarks = await placemarkFromCoordinates(lat, long);
      if (placemarks.isNotEmpty) {
        Placemark locationInfo = placemarks[0];
        setState(() {
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

  void _handleLongPress(LatLng coord) {
    setState(() {
      lat = coord.latitude;
      long = coord.longitude;
    });

    showDialog(context: context, builder: ((context) => _showDialog()));
  }

  Widget _showDialog() {
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
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WeatherPage(),
                            ),
                          );
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
    List<String> coordinates = weatherProvider.getCoordinates();
    lat = double.parse(coordinates[0]).truncateToDouble();
    long = double.parse(coordinates[1]).truncateToDouble();
    LatLng center = LatLng(lat, long);
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: center, zoom: 11.0),
        onLongPress: _handleLongPress,
      ),
    );
  }
}
