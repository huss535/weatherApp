// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/pages/location_page.dart';
import 'package:weather_app/pages/map_page.dart';
import 'package:weather_app/pages/weather_page.dart';
import 'package:weather_app/providers/weather_data_provider.dart';
import 'package:weather_app/utilities/bottom_nav.dart';

Future main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure that Flutter is initialized
  await dotenv.load(fileName: ".env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherDataProvider(),
      child: MaterialApp(
        title: 'Weather Wizard',
        theme: ThemeData(
            // Your theme configurations
            ),
        routes: {
          "/": (context) => HomePage(),
          "/weatherPage": (context) => WeatherPage(),
          "/locationWeather": (context) => LocationPage()
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [WeatherPage(), LocationPage(), MapPage()];
  @override
  Widget build(BuildContext context) {
    WeatherDataProvider weatherProvider =
        Provider.of<WeatherDataProvider>(context);
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
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
          switch (index) {
            case 0:
              weatherProvider.toWeather(context);
              setState(() {
                _currentIndex = index;
              });
              break;
            case 1:
              /*  Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LocationPage()),
              ); */
              setState(() {
                _currentIndex = index;
              });
              break;
            case 2:
              // Implement navigation for Map page
              setState(() {
                _currentIndex = index;
              });
              break;
            case 3:
              // Implement navigation for Settings page
              setState(() {
                _currentIndex = index;
              });
              break;
          }
        },
      ),
    );
  }
}
