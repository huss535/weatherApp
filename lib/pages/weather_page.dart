// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/utilities/bottom_nav.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/utilities/daily_temp.dart';
import 'package:weather_app/utilities/hourly_temp.dart';
import 'package:weather_app/utilities/helper_functions.dart';
// Helper function that fetches current location from user

//The main weather page
class WeatherPage extends StatefulWidget {
  WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String lat = "";
  String long = "";
  late String locationName = "";
  late String temp = "";
  late String weatherInfo = "";
  late String windSpeed = "";

  @override
  void initState() {
    super.initState();
    // Call the async method in initState
    _fetchCurrentWeather();
  }

  // function to fetch today's weather info
  Future<void> _fetchCurrentWeather() async {
    try {
      var location = await getLocation();
      final queryParams = {
        'lat': location.latitude.toString(),
        'lon': location.longitude.toString(),
        'units': "metric",
        'appid': dotenv.env["WEATHER_API_KEY"],
      };
      final uri = Uri.parse("https://api.openweathermap.org/data/2.5/weather")
          .replace(queryParameters: queryParams);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          temp = data["main"]["temp"].toString();
          weatherInfo = data["weather"][0]["description"].toString();
          windSpeed = data["wind"]["speed"].toString();
          locationName =
              '${data["name"].toString()}, ${data["sys"]["country"].toString()}';
        });
      } else {
        throw Exception("Failed to retrieve today's weather data");
      }
    } catch (e) {
      print("Error fetching weather data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(locationName),
        backgroundColor: Colors.deepPurple,
        elevation: 30.0,
      ),
      body: Padding(
        padding: EdgeInsetsDirectional.only(top: 20),
        child: Center(
          child: (temp.isEmpty || weatherInfo.isEmpty || windSpeed.isEmpty)
              ? CircularProgressIndicator() // Show loading indicator if data is not available
              : SizedBox(
                  width: 380,
                  child: ListView(
                    clipBehavior: Clip.none,
                    children: [
                      MainWeatherWidget(
                        temp: temp,
                      ),
                      SizedBox(height: 40),
                      WeatherData(
                        weatherInfo: weatherInfo,
                        windSpeed: windSpeed,
                      ),
                      SizedBox(height: 40),
                      HourlyTempAll(),
                      SizedBox(height: 40),
                      DailyTempAll()
                    ],
                  ),
                ),
        ),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}

//Widget displaying temprature of the day
class MainWeatherWidget extends StatelessWidget {
  String temp;
  MainWeatherWidget({required this.temp, Key? key}) : super(key: key);

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

class WeatherData extends StatelessWidget {
  String weatherInfo;
  String windSpeed;
  WeatherData({required this.weatherInfo, required this.windSpeed, Key? key})
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
