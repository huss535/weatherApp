import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/utilities/helper_functions.dart';
import 'package:http/http.dart' as http;

// class for data needed for main widgets component
class MainWidgetData {
  String? locationName = "";
  String? temp = "";
  String? weatherInfo = "";
  String? windSpeed = "";

  MainWidgetData(
      {this.locationName, this.temp, this.weatherInfo, this.windSpeed});
}

// class for data needed for hourly temprature widget
class HourlyTempData {
  String temp;
  String hour;

  HourlyTempData({required this.temp, required this.hour});
}

//class for data needed for daily temprature widget
class DailyTempData {
  String tempMin;
  String tempMax;
  String dayOfWeek;

  DailyTempData(
      {required this.tempMin, required this.tempMax, required this.dayOfWeek});
}

// Central class for fetching data from the openweather API

class WeatherDataProvider extends ChangeNotifier {
  String _lat = "";
  String _long = "";
  String _locationName = "";

  MainWidgetData mainWidgetData = MainWidgetData();
  List<HourlyTempData> tempList = [];
  List<DailyTempData> dailyTempList = [];

  WeatherDataProvider() {
    _initialize();
  }
  Future<void> _initialize() async {
    await _setLocation();
    await _fetchCurrentWeather();
    await _fetchHourlyTemp();
    await _fetchDailyTemp();
  }

  Future<void> _setLocation() async {
    Position location = await getLocation();
    _lat = location.latitude.toString();
    _long = location.longitude.toString();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(location.latitude, location.longitude);

    _locationName = "Unknown Location";
    if (placemarks.isNotEmpty) {
      Placemark locationInfo = placemarks[0];
      _locationName =
          '${locationInfo.locality ?? ""}, ${locationInfo.country ?? ""}';
    }
  }

  Future<void> _fetchCurrentWeather() async {
    try {
      final queryParams = {
        'lat': _lat,
        'lon': _long,
        'units': "metric",
        'appid': dotenv.env["WEATHER_API_KEY"],
      };
      final uri = Uri.parse("https://api.openweathermap.org/data/2.5/weather")
          .replace(queryParameters: queryParams);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        mainWidgetData.locationName = _locationName;
        mainWidgetData.temp = data["main"]["temp"].toString();
        mainWidgetData.weatherInfo = data["weather"][0]["description"];
        mainWidgetData.windSpeed = data["wind"]["speed"].toString();
        notifyListeners();
      } else {
        throw Exception("Failed to retrieve today's weather data");
      }
    } catch (e) {
      print("Error fetching weather data: $e");
      // Rethrow the exception to let the caller handle it.
      throw e;
    }
  }

  Future<void> _fetchHourlyTemp() async {
    print("Hourly API called");
    final queryParams = {
      'lat': _lat,
      'lon': _long,
      'units': "metric",
      'appid': dotenv.env["WEATHER_API_KEY"],
    };

    final uri =
        Uri.parse("https://pro.openweathermap.org/data/2.5/forecast/hourly")
            .replace(queryParameters: queryParams);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      final List<dynamic> hourlyData = jsonData['list'];

      for (int i = 0; i < 24; i++) {
        HourlyTempData entry = HourlyTempData(
          temp: hourlyData[i]["main"]["temp"].round().toString(),
          hour: formatTimestamp(hourlyData[i]["dt"]),
        );
        tempList.add(entry);
      }
      notifyListeners();
    } else {
      throw Exception('Failed to load hourly temperature');
    }
  }

  Future<void> _fetchDailyTemp() async {
    final queryParams = {
      'lat': _lat,
      'lon': _long,
      'units': "metric",
      'appid': dotenv.env["WEATHER_API_KEY"],
    };

    final uriDaily =
        Uri.parse("https://api.openweathermap.org/data/2.5/forecast/daily")
            .replace(queryParameters: queryParams);

    final response = await http.get(uriDaily);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      final List<dynamic> dailyData = jsonData['list'];

      for (int i = 0; i < 7; i++) {
        DailyTempData entry = DailyTempData(
          tempMin: dailyData[i]["temp"]["min"].round().toString(),
          tempMax: dailyData[i]["temp"]["max"].round().toString(),
          dayOfWeek: getDayOfWeek(
              DateTime.fromMillisecondsSinceEpoch(dailyData[i]["dt"] * 1000)),
        );
        dailyTempList.add(entry);
      }
      notifyListeners();
    } else {
      throw Exception('Failed to load hourly temperature');
    }
  }
}
