// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/utilities/bottom_nav.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/utilities/daily_temp.dart';
import 'package:weather_app/utilities/hourly_temp.dart';
import 'package:weather_app/utilities/responsive_padding.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(126, 74, 221, 1),
            offset: const Offset(-8, 8),
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
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(126, 74, 221, 1),
                offset: const Offset(-8, 8),
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
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(126, 74, 221, 1),
                offset: const Offset(-8, 8),
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

class HourlyTempService {
  static Future<List<dynamic>> fetchHourlyTemp(double lat, double lon) async {
    final queryParams = {
      'lat': lat.toString(),
      'lon': lon.toString(),
      'units': "metric",
      'appid': dotenv.env["WEATHER_API_KEY"],
    };

    final uri =
        Uri.parse("https://pro.openweathermap.org/data/2.5/forecast/hourly")
            .replace(queryParameters: queryParams);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      final List<dynamic> hourlyData = jsonData['list'];

      return hourlyData;
    } else {
      throw Exception('Failed to load hourly temperature');
    }
  }
}

class HourlyTempAll extends StatelessWidget {
  const HourlyTempAll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: HourlyTempService.fetchHourlyTemp(-36.852095, 174.7631803),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final temps = snapshot.data!;

          return SizedBox(
            height: 180,
            width: 380,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < 3; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                          clipBehavior: Clip.none,
                          width: 100, // Adjust width as needed
                          child: HourlyTemp(
                              time: _formatTimestamp(temps[i]["dt"]),
                              temp: '${temps[i]["main"]["temp"]}°C')
                          //Text('T${temps[i]["main"]["temp"]}°C'),
                          ),
                    ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class DailyTempService {
  static Future<List<dynamic>> fetchDailyTemp(double lat, double lon) async {
    final queryParams = {
      'lat': lat.toString(),
      'lon': lon.toString(),
      'units': "metric",
      'appid': dotenv.env["WEATHER_API_KEY"],
    };

    final uri =
        Uri.parse("https://api.openweathermap.org/data/2.5/forecast/daily")
            .replace(queryParameters: queryParams);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      final List<dynamic> dailyData = jsonData['list'];
      print(dailyData);
      return dailyData;
    } else {
      throw Exception('Failed to load hourly temperature');
    }
  }
}

class DailyTempAll extends StatelessWidget {
  const DailyTempAll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: DailyTempService.fetchDailyTemp(-36.852095, 174.7631803),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final temps = snapshot.data!;

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                for (int i = 0; i < temps.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: DailyTemp(
                      min: '${temps[i]["temp"]["min"]}°C',
                      max: '${temps[i]["temp"]["max"]}°C',
                      day: _getDayOfWeek(DateTime.fromMillisecondsSinceEpoch(
                          temps[i]["dt"] * 1000)),
                    ),
                  ),
              ],
            ),
          );
        }
      },
    );
  }

  String _getDayOfWeek(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }
}

// Helper function to format timestamp to time
String _formatTimestamp(int timestamp) {
  // Convert timestamp to DateTime object
  DateTime dateTime =
      DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
  // Convert DateTime object to local time
  dateTime = dateTime.toLocal();
  TimeOfDay displayedHour =
      TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);

  //print(displayedHour);

  // Format time
  // Example format: "9:00"
  return displayedHour.hour.toString().padLeft(2, "0") +
      ":" +
      displayedHour.minute.toString().padLeft(2, "0");
}

String _getDay(int timestamp) {
  // Convert timestamp to DateTime object
  DateTime dateTime =
      DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
  // Convert DateTime object to local time
  dateTime = dateTime.toLocal();
  int weekday = dateTime.weekday;
  switch (weekday) {
    case 1:
      return 'Monday';
    case 2:
      return 'Tuesday';
    case 3:
      return 'Wednesday';
    case 4:
      return 'Thursday';
    case 5:
      return 'Friday';
    case 6:
      return 'Saturday';
    case 7:
      return 'Sunday';
    default:
      return '';
  }
}
