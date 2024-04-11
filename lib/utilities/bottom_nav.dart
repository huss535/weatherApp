import 'package:flutter/material.dart';
import 'package:weather_app/pages/weather_page.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        //Bottom Nav buttons
        children: [
          IconButton(
            iconSize: 40,
            icon: Icon(Icons.sunny),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WeatherPage()));
            },
          ),
          IconButton(
            iconSize: 40,
            icon: Icon(Icons.location_pin),
            onPressed: () {},
          ),
          IconButton(
            iconSize: 40,
            icon: Icon(Icons.settings),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
