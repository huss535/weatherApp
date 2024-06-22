import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_data_provider.dart';
import 'package:weather_app/utilities/daily_temp.dart';
import 'package:weather_app/utilities/hourly_temp.dart';
import 'package:weather_app/utilities/main_widgets.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class WeatherPage extends StatefulWidget {
  WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final model = GenerativeModel(
      model: 'gemini-1.5-flash', apiKey: dotenv.env['GEMINI'] ?? "");
  final prompt = TextPart("Hello, tell me a joke");

  void testGemini() async {
    final response = await model.generateContent([
      Content.multi([prompt])
    ]);

    print(response.text);
  }

  @override
  Widget build(BuildContext context) {
    /* print(dotenv.env['GEMINI']);
    testGemini(); */
    WeatherDataProvider weatherProvider =
        Provider.of<WeatherDataProvider>(context);

    if (weatherProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            weatherProvider.mainWidgetData.locationName ??
                "Could not get location name",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.deepPurple,
          elevation: 30.0,
        ),
        body: Consumer<WeatherDataProvider>(
          builder: (context, weatherProvider, _) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: SizedBox(
                  width: 380,
                  child: ListView(
                    children: [
                      MainWidgets(
                          mainWidgetData: weatherProvider.mainWidgetData),
                      SizedBox(height: 40),
                      HourlyTempAll(tempList: weatherProvider.tempList),
                      SizedBox(height: 40),
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
