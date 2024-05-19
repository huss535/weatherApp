// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_data_provider.dart';
import 'package:weather_app/utilities/helper_functions.dart';
import 'package:weather_icons/weather_icons.dart';

// representing the main weather widget for current weather, contains the other widgets displaying the current weather

class MainWidgets extends StatefulWidget {
  final MainWidgetData mainWidgetData;
  MainWidgets({required this.mainWidgetData, super.key});

  @override
  State<MainWidgets> createState() => _MainWidgetsState();
}

class _MainWidgetsState extends State<MainWidgets> {
  //late String locationName = "";
  //late String temp = "";
  //late String weatherInfo = "";
  // late String windSpeed = "";

  @override
  Widget build(BuildContext context) {
    // Build UI with fetched data
    return Container(
      height: 300,
      child: Column(
        children: [
          MainWeatherWidget(
            temp: widget.mainWidgetData.temp,
            iconCode: widget.mainWidgetData.iconCode,
          ),
          SizedBox(height: 40),
          WeatherData(
            weatherInfo: widget.mainWidgetData.weatherInfo ?? "",
            windSpeed: widget.mainWidgetData.windSpeed ?? "",
          ),
        ],
      ),
    );

    // Handle error
  }
  // Show loading indicator while data is being fetched
}

//Widget displaying temprature of the day
class MainWeatherWidget extends StatelessWidget {
  final String temp;
  final String iconCode;
  const MainWeatherWidget({required this.temp, this.iconCode = "", Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    IconData icon = getWeatherIcon(iconCode);
    return Container(
      height: 150,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "${temp}°C",
            style: TextStyle(fontSize: 46),
          ),
          BoxedIcon(
            icon,
            size: 55,
          )
        ],
      ),
    );
  }
}

// Displays general weather information like windspeed and weather description
class WeatherData extends StatelessWidget {
  final String weatherInfo;
  final String windSpeed;
  const WeatherData(
      {required this.weatherInfo, required this.windSpeed, Key? key})
      : super(key: key);

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
            children: [
              Text("Today"),
              Text(weatherInfo),
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
            children: [
              Text("Wind Speed"),
              Text('${windSpeed} m/s'),
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
