import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'helper_functions.dart';

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
            //Container styling
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(126, 74, 221, 1), offset: Offset(-8, 8))
            ],
            borderRadius: BorderRadius.circular(15.0),
            color: Color.fromRGBO(140, 190, 233, 1)),

        //Data displayed in component
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [Text(time), Icon(Icons.cloud), Text(temp)],
        ),
      ),
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
                              time: formatTimestamp(temps[i]["dt"]),
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

// Helper function to format timestamp to time
