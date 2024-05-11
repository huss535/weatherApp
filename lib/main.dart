import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/pages/location_page.dart';
import 'package:weather_app/pages/weather_page.dart';
import 'package:weather_app/providers/weather_data_provider.dart';

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
          "/": (context) => WeatherPage(),
          "/locationWeather": (context) => LocationPage()
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
