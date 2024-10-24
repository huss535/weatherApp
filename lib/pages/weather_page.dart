import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/providers/weather_data_provider.dart';
import 'package:weather_app/utilities/daily_temp.dart';
import 'package:weather_app/utilities/helper_functions.dart';
import 'package:weather_app/utilities/hourly_temp.dart';
import 'package:weather_app/utilities/main_widgets.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:weather_app/utilities/maps.dart';

final model = GenerativeModel(
    model: 'gemini-1.5-flash', apiKey: dotenv.env['GEMINI'] ?? "");

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  /*  String aIPropmpt = "No Comment"; */

  /* Future<void> testGemini(MainWidgetData mainWidgetData) async {
    TextPart prompt;
    final prefs = await SharedPreferences.getInstance();
    final String persona = personaMap[prefs.getDouble("persona")]!;
    final String politics = politicsMap[prefs.getDouble("politics")]!;
    final String weather = mainWidgetData.weatherInfo;
    final String temp = mainWidgetData.temp;
    final String location = mainWidgetData.locationName;

    prompt = TextPart(
        "Craft a whimsical and engaging weather update in just two sentences, fully embodying the persona of $persona. Capture their current mood of $politics, and deliver the message in their distinctive voice. The user is currently in $location, where the temperature is  $temp°C with $weather conditions. Infuse the update with $persona's unique quirks and worldview, transforming this weather report into a delightful and character-driven experience.");

    print(persona);
    print(prompt.text);
    final response = await model.generateContent([
      Content.multi([prompt])
    ]);
    setState(() {
      aIPropmpt = response.text!;
    });
  } */

  @override
  void initState() {
    super.initState();
    final weatherProvider =
        Provider.of<WeatherDataProvider>(context, listen: false);

    /*   testGemini(weatherProvider
        .mainWidgetData); // Call function to initialize Gemini data asynchronously */
  }

  /* @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    testGemini(); // Call _initializeGemini whenever dependencies change (e.g., navigating to this page)
  } */

  @override
  Widget build(BuildContext context) {
    //testGemini();
    WeatherDataProvider weatherProvider =
        Provider.of<WeatherDataProvider>(context);

    if (weatherProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            weatherProvider.mainWidgetData.locationName ??
                "Could not get location name",
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.deepPurple,
          elevation: 30.0,
        ),
        body: Consumer<WeatherDataProvider>(
          builder: (context, weatherProvider, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: SizedBox(
                  width: 380,
                  child: ListView(
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        weatherProvider.aIPrompt,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      MainWidgets(
                          mainWidgetData: weatherProvider.mainWidgetData),
                      const SizedBox(height: 40),
                      HourlyTempAll(tempList: weatherProvider.tempList),
                      const SizedBox(height: 40),
                      DailyTempAll(
                          dailyTempList: weatherProvider.dailyTempList),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
