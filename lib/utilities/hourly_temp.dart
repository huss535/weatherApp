import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'helper_functions.dart';

class HourlyTempData {
  String temp;
  String hour;

  HourlyTempData({required this.temp, required this.hour});
}

// Component displays hourly temprature for a day
class HourlyTemp extends StatelessWidget {
  String time;
  String temp;
  HourlyTemp({required this.time, required this.temp, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 160,
        width: 120,
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
        //Data displayed in component
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [Text(time), Icon(Icons.cloud), Text(temp)],
        ),
      ),
    );
  }
}

class HourlyTempAll extends StatefulWidget {
  String lat;
  String long;

  HourlyTempAll({required this.lat, required this.long, Key? key})
      : super(key: key);

  @override
  State<HourlyTempAll> createState() => _HourlyTempAllState();
}

class _HourlyTempAllState extends State<HourlyTempAll> {
  late List<HourlyTempData> temps;
  bool _dataFetched = false; // Flag to track whether data has been fetched

  @override
  void initState() {
    super.initState();
    temps = []; // Initialize temps list
    _fetchHourlyTemp();
  }

  Future<void> _fetchHourlyTemp() async {
    final queryParams = {
      'lat': widget.lat,
      'lon': widget.long,
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
      List<HourlyTempData> tempList = [];

      for (int i = 0; i < 24; i++) {
        HourlyTempData entry = HourlyTempData(
          temp: hourlyData[i]["main"]["temp"].round().toString(),
          hour: formatTimestamp(hourlyData[i]["dt"]),
        );
        tempList.add(entry);
      }
      print("Hourly");
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
        ? _HourlyTempList(temps: temps)
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}

class _HourlyTempList extends StatelessWidget {
  final List<HourlyTempData> temps;

  const _HourlyTempList({Key? key, required this.temps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: 380,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < temps.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  clipBehavior: Clip.none,
                  width: 100, // Adjust width as needed
                  child: HourlyTemp(
                    time: temps[i].hour,
                    temp: '${temps[i].temp}°C',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
