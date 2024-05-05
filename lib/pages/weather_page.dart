// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weather_app/utilities/bottom_nav.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/utilities/daily_temp.dart';
import 'package:weather_app/utilities/hourly_temp.dart';
import 'package:weather_app/utilities/helper_functions.dart';
import 'package:weather_app/utilities/main_widgets.dart';

// Helper function that fetches current location from user
class WeatherPage extends StatelessWidget {
  WeatherPage({Key? key}) : super(key: key);

  Future<Map<String, dynamic>> _setLocation() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _setLocation(),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          String locationName =
              snapshot.data?["locationName"] ?? "Unknown Location";

          return Scaffold(
            appBar: AppBar(
              title: Text(locationName),
              backgroundColor: Colors.deepPurple,
              elevation: 30.0,
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: SizedBox(
                  width: 380,
                  child: ListView(
                    children: [
                      MainWidgets(
                        lat: snapshot.data?["lat"] ?? "",
                        long: snapshot.data?["long"] ?? "",
                      ),
                      SizedBox(height: 40),
                      HourlyTempAll(
                        lat: snapshot.data?["lat"] ?? "",
                        long: snapshot.data?["long"] ?? "",
                      ),
                      SizedBox(height: 40),
                      DailyTempAll(),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: BottomNav(),
          );
        }
      },
    );
  }
}
