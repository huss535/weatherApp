import 'package:flutter/material.dart';
import 'package:weather_app/utilities/bottom_nav.dart';
import 'package:weather_app/utilities/daily_temp.dart';

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
      body: DailyTemp(),
      bottomNavigationBar: BottomNav(),
    );
  }
}
