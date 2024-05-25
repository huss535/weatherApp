import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/pages/location_page.dart';
import 'package:weather_app/pages/weather_page.dart';
import 'package:weather_app/providers/weather_data_provider.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    WeatherDataProvider weatherProvider =
        Provider.of<WeatherDataProvider>(context);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      fixedColor: Colors.purple,

      iconSize: 40,
      elevation: 0,
      currentIndex: _currentIndex,

      // Bottom Nav buttons
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.sunny),
          label: 'Weather',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_pin),
          label: 'Location',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
        switch (index) {
          case 0:
            weatherProvider.toWeather(context);
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LocationPage()),
            );
            break;
          case 2:
            // Implement navigation for Map page
            break;
          case 3:
            // Implement navigation for Settings page
            break;
        }
      },
    );
  }
}
