import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/utilities/helper_functions.dart';
import 'package:http/http.dart' as http;

class MainWidgetData {
  String? locationName = "";
  String? temp = "";
  String? weatherInfo = "";
  String? windSpeed = "";

  MainWidgetData(
      {this.locationName, this.temp, this.weatherInfo, this.windSpeed});
}

// Central class for fetching data from the openweather API

class WeatherDataProvider extends ChangeNotifier {
  String _lat = "";
  String _long = "";
  String _locationName = "";
  String _temp = "";
  String _weatherInfo = "";
  String _windSpeed = "";
  MainWidgetData mainWidgetData = MainWidgetData();

  WeatherDataProvider() {
    _initialize();
  }
  Future<void> _initialize() async {
    await _setLocation();
    await _fetchCurrentWeather();
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
}
