// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/pages/location_page.dart';
import 'package:weather_app/pages/map_page.dart';
import 'package:weather_app/pages/settings_page.dart';
import 'package:weather_app/pages/weather_page.dart';
import 'package:weather_app/providers/navigation_provider.dart';
import 'package:weather_app/providers/weather_data_provider.dart';

Future main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure that Flutter is initialized
  await dotenv.load(fileName: ".env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void _provideApiKeyToIos() {
    const platform = MethodChannel('com.example.app/google_maps');
    final apiKey = dotenv.env['MAPS_API_KEY'];
    platform.invokeMethod('provideApiKey', {'apiKey': apiKey});
  }

  @override
  Widget build(BuildContext context) {
    _provideApiKeyToIos();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WeatherDataProvider()),
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
      ],
      child: MaterialApp(
        title: 'Weather Wizard',
        theme: ThemeData(
            // Your theme configurations
            fontFamily: "Lato"),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(),
          '/weatherPage': (context) => WeatherPage(),
          '/locationWeather': (context) => LocationPage(),
          // Add more routes as needed
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final weatherDataProvider = Provider.of<WeatherDataProvider>(context);
    return Scaffold(
      body: IndexedStack(
        index: navigationProvider.currentIndex,
        children: [
          WeatherPage(),
          LocationPage(),
          MapPage(),
          SettingsPage()
          // Add your SettingsPage here if you have one
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.purple,
        iconSize: 40,
        elevation: 0,
        currentIndex: navigationProvider.currentIndex,
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
          if (index == 0) {
            weatherDataProvider.toWeather();
            navigationProvider.setIndex(index);
          } else {
            navigationProvider.setIndex(index);
          }
        },
      ),
    );
  }
}
