// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/pages/location_page.dart';
import 'package:weather_app/pages/weather_page.dart';
import 'package:weather_app/providers/weather_data_provider.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WeatherDataProvider weatherProvider =
        Provider.of<WeatherDataProvider>(context);
    const unusedData = IconThemeData(color: Colors.deepPurple);

    return BottomNavigationBar(
      backgroundColor: Color(0xC0C0C0FF),
      unselectedIconTheme: unusedData,
      iconSize: 40,
      elevation: 30,

      //Bottom Nav buttons
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.sunny),
          label: 'Weather', // Provide labels for better accessibility
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_pin),
          label: 'Location',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        )
      ],
      onTap: (int index) {
        // Handle navigation based on the index
        switch (index) {
          case 0:
            weatherProvider.toWeather(context);
            /* Navigator.pushNamed(context, "/"); */
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LocationPage()),
            );
            break;
          case 2:
            // Handle settings button press
            break;
        }
      },
    );
  }
}
