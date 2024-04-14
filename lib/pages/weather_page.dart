// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/utilities/bottom_nav.dart';
import 'package:weather_app/utilities/daily_temp.dart';
import 'package:http/http.dart' as http;

// Page used to display weather info
class WeatherPage extends StatelessWidget {
  WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auckland'),
        backgroundColor: Colors.deepPurple,
        elevation: 30.0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: SizedBox(
            width: 380,
            child: ListView(
              clipBehavior: Clip.none,
              children: [
                MainWeatherWidget(),
                SizedBox(
                  height: 30,
                ),
                WeatherData()
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}

// Weather widget displaying current day Temprature
class MainWeatherWidget extends StatefulWidget {
  MainWeatherWidget({super.key});

  @override
  State<MainWeatherWidget> createState() => _MainWeatherWidgetState();
}

class _MainWeatherWidgetState extends State<MainWeatherWidget> {
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
                color: Color.fromRGBO(126, 74, 221, 1), offset: Offset(-8, 8))
          ],
          borderRadius: BorderRadius.circular(15.0),
          color: Color.fromRGBO(140, 190, 233, 1)),
    );
  }
}

// Widget displaying other weather data
class WeatherData extends StatelessWidget {
  const WeatherData({super.key});

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
            children: [Text("Precipitation"), Text("39%")],
          ),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(126, 74, 221, 1),
                    offset: Offset(-8, 8))
              ],
              borderRadius: BorderRadius.circular(15.0),
              color: Color.fromRGBO(140, 190, 233, 1)),
        ),
        Container(
          height: 90,
          width: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [Text("Wind Speed"), Text("40 mph")],
          ),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(126, 74, 221, 1),
                    offset: Offset(-8, 8))
              ],
              borderRadius: BorderRadius.circular(15.0),
              color: Color.fromRGBO(140, 190, 233, 1)),
        ),
      ],
    );
  }
}

class HourlyTempAll extends StatelessWidget {
  HourlyTempAll({super.key});

  Future<http.Response> fetchHourlyTemp() {
    Map<String, dynamic> queryParams = {
      'lat': -36.852095,
      'lon': 174.7631803,
      'units': "metric",
      'appid': dotenv.env["WEATHER_API_KEY"],
    };

    Uri uri = Uri.parse("http://api.openweathermap.org/geo/1.0/direct")
        .replace(queryParameters: queryParams);
    var response = http.get(uri);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
