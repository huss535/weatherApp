// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class DailyTemp extends StatelessWidget {
  final String min;
  final String max;
  final String day;

  const DailyTemp({
    required this.min,
    required this.max,
    required this.day,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        width: 350,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              day,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            Icon(Icons.cloud_queue_outlined),
            Text(
              min,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            Text(
              max,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )
          ],
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(126, 74, 221, 1),
              offset: Offset(0, 8),
            )
          ],
          borderRadius: BorderRadius.circular(15.0),
          color: Color.fromRGBO(140, 190, 233, 1),
        ),
      ),
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
