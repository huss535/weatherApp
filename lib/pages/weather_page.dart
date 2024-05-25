// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_data_provider.dart';
import 'package:weather_app/utilities/bottom_nav.dart';
import 'package:weather_app/utilities/daily_temp.dart';
import 'package:weather_app/utilities/hourly_temp.dart';
import 'package:weather_app/utilities/main_widgets.dart';

// Helper function that fetches current location from user
class WeatherPage extends StatefulWidget {
  WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  /* Future<Map<String, dynamic>> _setLocation() async {
    var location = await getLocation();
    String lat = location.latitude.toString();
    String long = location.longitude.toString();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(location.latitude, location.longitude);

    String locationName = "Unknown Location";
    if (placemarks.isNotEmpty) {
      Placemark locationInfo = placemarks[0];
      locationName =
          '${locationInfo.locality ?? ""}, ${locationInfo.country ?? ""}';
    }

    return {"lat": lat, "long": long, "locationName": locationName};
  } */

  @override
  Widget build(BuildContext context) {
    WeatherDataProvider weatherProvider =
        Provider.of<WeatherDataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(weatherProvider.mainWidgetData.locationName ??
            "Could not get location name"),
        backgroundColor: Colors.deepPurple,
        elevation: 30.0,
      ),
      body:
          Consumer<WeatherDataProvider>(builder: (context, weatherProvider, _) {
        //print("checking context: ${weatherProvider.mainWidgetData.temp}");
        if (weatherProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: SizedBox(
                width: 380,
                child: ListView(
                  children: [
                    MainWidgets(
                      mainWidgetData: weatherProvider.mainWidgetData,
                    ),
                    SizedBox(height: 40),
                    HourlyTempAll(
                      tempList: weatherProvider.tempList,
                    ),
                    SizedBox(height: 40),
                    DailyTempAll(
                      dailyTempList: weatherProvider.dailyTempList,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }),
      /*      bottomNavigationBar: BottomNav(), */
    );
  }
}
