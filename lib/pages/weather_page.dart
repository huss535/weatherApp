// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:weather_app/utilities/bottom_nav.dart';
import 'package:weather_app/utilities/daily_temp.dart';

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
            width: 350,
            child: ListView(
              clipBehavior: Clip.none,
              children: [MainWeatherWidget()],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}

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
