import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/providers/weather_data_provider.dart';
import 'package:weather_app/utilities/daily_temp.dart';
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
  String aIPropmpt = "No Comment";

  Future<void> testGemini() async {
    TextPart prompt;
    final prefs = await SharedPreferences.getInstance();

    final String persona = personaMap[prefs.getDouble("persona")]!;
    final String politics = personaMap[prefs.getDouble("politics")]!;
    final String profanity =
        prefs.getBool("profanity")! ? "use profanity" : "not use profanity";
    if (persona == "Professional" && politics == "Apolitical") {
      prompt = TextPart(
          "Please create a prompt for a user in a mobile weather app, keeping it concise with a maximum of three sentences. It should be professional, warm and welcoming. For example, Hello'");
    }
    prompt = TextPart(
        " Please create a prompt for a user in a mobile weather app, keeping it concise with a maximum of three sentences. You should embody the character of ${persona} with ${politics} leanings and the option to  ${profanity}. For example, if I were to embody a character like a futuristic rebel with anarchist ideals and allowed to use profanity, I'd expect something like 'Hey folks, brace yourselves! The weather's about to get bloody wild, but we'll ride it out together, kicking some serious meteorological ass!'");

    print(prompt.text);
    final response = await model.generateContent([
      Content.multi([prompt])
    ]);
    setState(() {
      aIPropmpt = response.text!;
    });
  }

  /*  @override
  void initState() {
    super.initState();
    testGemini(); // Call function to initialize Gemini data asynchronously
  } */

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    testGemini(); // Call _initializeGemini whenever dependencies change (e.g., navigating to this page)
  }

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
                      Text(aIPropmpt),
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
