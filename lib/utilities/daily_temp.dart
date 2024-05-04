// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'helper_functions.dart';

class DailyTempData {
  String tempMin;
  String tempMax;
  String dayOfWeek;

  DailyTempData(
      {required this.tempMin, required this.tempMax, required this.dayOfWeek});
}

//Individual daily weather component
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

// Generates the daily weather widgets dynamically
class DailyTempAll extends StatefulWidget {
  String lat;
  String long;
  DailyTempAll({required this.lat, required this.long, Key? key})
      : super(key: key);

  @override
  State<DailyTempAll> createState() => _DailyTempAllState();
}

class _DailyTempAllState extends State<DailyTempAll> {
  List<DailyTempData> temps = [];
  bool _dataFetched = false; // Flag to track whether data has been fetched

  @override
  void initState() {
    super.initState();
    _fetchDailyTemp();
  }

  Future<void> _fetchDailyTemp() async {
    final queryParams = {
      'lat': widget.lat,
      'lon': widget.long,
      'units': "metric",
      'appid': dotenv.env["WEATHER_API_KEY"],
    };

    final uriDaily =
        Uri.parse("https://api.openweathermap.org/data/2.5/forecast/daily")
            .replace(queryParameters: queryParams);

    final response = await http.get(uriDaily);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      final List<dynamic> dailyData = jsonData['list'];

      List<DailyTempData> tempList = [];

      for (int i = 0; i < 7; i++) {
        DailyTempData entry = DailyTempData(
          tempMin: dailyData[i]["temp"]["min"].round().toString(),
          tempMax: dailyData[i]["temp"]["max"].round().toString(),
          dayOfWeek: getDayOfWeek(
              DateTime.fromMillisecondsSinceEpoch(dailyData[i]["dt"] * 1000)),
        );
        tempList.add(entry);
      }
      print("Daily");

      setState(() {
        temps = tempList;
        _dataFetched = true;
      });
    } else {
      throw Exception('Failed to load hourly temperature');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _dataFetched
        ? SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                for (int i = 0; i < temps.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: DailyTemp(
                      min: '${temps[i].tempMin}°C',
                      max: '${temps[i].tempMax}°C',
                      day: temps[i].dayOfWeek,
                    ),
                  ),
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
