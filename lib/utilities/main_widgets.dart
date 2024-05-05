import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_data_provider.dart';

class MainWidgetData {
  String locationName = "";
  String temp = "";
  String weatherInfo = "";
  String windSpeed = "";

  MainWidgetData(
      {required this.locationName,
      required this.temp,
      required this.weatherInfo,
      required this.windSpeed});
}

// representing the main weather widget for current weather

class MainWidgets extends StatefulWidget {
  String lat;
  String long;
  MainWidgets({required this.lat, required this.long, super.key});

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
    final providerWeather = Provider.of<WeatherDataProvider>(context);

    // Build UI with fetched data
    return Container(
      height: 300,
      child: Column(
        children: [
          MainWeatherWidget(temp: providerWeather.mainWidgetData.temp ?? ""),
          SizedBox(height: 40),
          WeatherData(
            weatherInfo: providerWeather.mainWidgetData.weatherInfo ?? "",
            windSpeed: providerWeather.mainWidgetData.windSpeed ?? "",
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
  const MainWeatherWidget({required this.temp, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "${temp}°C",
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
