// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/utilities/bottom_nav.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/utilities/daily_temp.dart';
import 'package:weather_app/utilities/hourly_temp.dart';
import 'package:weather_app/utilities/responsive_padding.dart';

Future<Position> _getLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error("Location services disabled");
  }
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error("Location permissions are denied");
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        "Location permissions are denied forever, we can not process your request");
  }

  return await Geolocator.getCurrentPosition();
}

class WeatherPage extends StatelessWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _getLocation()
        .then((value) => {print(value.latitude), print(value.longitude)});

    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Auckland'),
        backgroundColor: Colors.deepPurple,
        elevation: 30.0,
      ),
      body: ResponsivePadding(
        child: Center(
          child: SizedBox(
            width: 380,
            child: ListView(
              clipBehavior: Clip.none,
              children: [
                MainWeatherWidget(),
                SizedBox(height: 40),
                WeatherData(),
                SizedBox(height: 40),
                // DailyTempAll()
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}

class MainWeatherWidget extends StatelessWidget {
  MainWeatherWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "29 C",
            style: TextStyle(fontSize: 46),
          ),
          Icon(
            Icons.sunny,
            size: 55,
          )
        ],
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(126, 74, 221, 1),
            offset: const Offset(0, 8),
          ),
        ],
        borderRadius: BorderRadius.circular(15.0),
        color: const Color.fromRGBO(140, 190, 233, 1),
      ),
    );
  }
}

class WeatherData extends StatelessWidget {
  const WeatherData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 90,
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text("Precipitation"),
              Text("39%"),
            ],
          ),
          decoration: BoxDecoration(
            border: Border.all(width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(126, 74, 221, 1),
                offset: const Offset(0, 8),
              ),
            ],
            borderRadius: BorderRadius.circular(15.0),
            color: const Color.fromRGBO(140, 190, 233, 1),
          ),
        ),
        Container(
          height: 90,
          width: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text("Wind Speed"),
              Text("40 mph"),
            ],
          ),
          decoration: BoxDecoration(
            border: Border.all(width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(126, 74, 221, 1),
                offset: const Offset(0, 8),
              ),
            ],
            borderRadius: BorderRadius.circular(15.0),
            color: const Color.fromRGBO(140, 190, 233, 1),
          ),
        ),
      ],
    );
  }
}
