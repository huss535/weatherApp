import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/utilities/bottom_nav.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/utilities/hourly_temp.dart';

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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: SizedBox(
            width: 380,
            child: ListView(
              clipBehavior: Clip.none,
              children: const [
                MainWeatherWidget(),
                SizedBox(height: 40),
                WeatherData(),
                SizedBox(height: 40),
                HourlyTempAll(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}

class MainWeatherWidget extends StatelessWidget {
  const MainWeatherWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
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
            height: 220,
            width: 380,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < temps.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
}
