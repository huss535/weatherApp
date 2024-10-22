import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/utilities/helper_functions.dart';
import 'package:http/http.dart' as http;

class WeatherDataProvider extends ChangeNotifier {
  String _lat = "";
  String _long = ""; // Co-ordinates used in APIs
  String? locationId;

  //used primarily for UI
  bool isLoading = true;
  var dailyWeatherData;
  var hourlyWeatherData;

// Getter function for current location coordinates.
  List<String> getCoordinates() {
    return [_lat, _long];
  }

  MainWidgetData mainWidgetData = MainWidgetData();
  List<HourlyTempData> tempList = [];
  List<DailyTempData> dailyTempList = [];

  WeatherDataProvider() {
    _initialize();
  }

  Future<void> _fetchCurrentWeather() async {
    try {
      final queryParams = {
        'lat': _lat,
        'lon': _long,
        'units': "metric",
        'appid': dotenv.env["WEATHER_API_KEY"],
      };
      final uri = Uri.parse("https://api.openweathermap.org/data/3.0/onecall")
          .replace(queryParameters: queryParams);

      final response = await http.get(uri);
      print("Current Weather (Body): ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        //setting array of hourly temprature data
        hourlyWeatherData = data["hourly"];
        dailyWeatherData = data["daily"];

        mainWidgetData.temp = data["current"]["temp"].round().toString();
        mainWidgetData.weatherInfo =
            data["current"]["weather"][0]["description"];
        mainWidgetData.windSpeed = data["current"]["wind_speed"].toString();
        mainWidgetData.iconCode = data["current"]["weather"][0]["icon"];
        /* print("Current weather data set:" + mainWidgetData.temp); */
        notifyListeners();
        // Reverting to current location after displaying searched location weather
      } else {
        throw Exception("Failed to retrieve today's weather data");
      }
    } catch (e) {
      print("Error fetching weather data: $e");
      // Rethrow the exception to let the caller handle it.
      rethrow;
    }
  }

  Future<void> _fetchHourlyTemp() async {
    /*  print("Hourly API called");
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
    print("hourly weather :" + response.body); */
    if (hourlyWeatherData.length > 0) {
      tempList.clear();
      //print(hourlyWeatherData.length);
      for (int i = 0; i < 24; i++) {
        HourlyTempData entry = HourlyTempData(
          temp: hourlyWeatherData[i]["temp"].round().toString(),
          hour: formatTimestamp(hourlyWeatherData[i]["dt"]),
          iconCode: hourlyWeatherData[i]["weather"][0]["icon"].toString(),
        );

        tempList.add(entry);
      }

      notifyListeners();
    } else {
      throw Exception('Failed to load hourly temperature');
    }
  }

  Future<void> _fetchDailyTemp() async {
    if (dailyWeatherData.length > 0) {
      dailyTempList.clear();
      for (int i = 0; i < 7; i++) {
        DailyTempData entry = DailyTempData(
          tempMin: dailyWeatherData[i]["temp"]["min"].round().toString(),
          tempMax: dailyWeatherData[i]["temp"]["max"].round().toString(),
          dayOfWeek: getDayOfWeek(DateTime.fromMillisecondsSinceEpoch(
              dailyWeatherData[i]["dt"] * 1000)),
          iconCode: dailyWeatherData[i]["weather"][0]["icon"],
        );
        dailyTempList.add(entry);
      }
      notifyListeners();
    } else {
      throw Exception('Failed to load hourly temperature');
    }
  }

// function used with the weather button on the bottom nav
  void toWeather() {
    isLoading = true;
    _initialize();
    //Navigator.pushNamed(context, "/weatherPage");
  }

  Future<void> _initialize() async {
    await _setLocation(locationId);
    await _fetchCurrentWeather();
    await _fetchHourlyTemp();
    await _fetchDailyTemp();
    isLoading = false;
  }

//sets the current location co-ordinates to be used to fetch weather data
  Future<void> _setLocation(String? placeId) async {
    if (placeId == null) {
      Position location = await getLocation();
      _lat = location.latitude.toString();
      _long = location.longitude.toString();
    } else {
      try {
        final queryParams = {
          "place_id": placeId,
          "key": dotenv.env["MAPS_API_KEY"]
        };

        // print("Parameters: ${queryParams.toString()}");

        Uri coordinatesCall =
            Uri.parse("https://maps.googleapis.com/maps/api/place/details/json")
                .replace(queryParameters: queryParams);

        http.Response response = await http.get(coordinatesCall);
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          _lat = data["result"]["geometry"]["location"]["lat"].toString();
          _long = data["result"]["geometry"]["location"]["lng"].toString();
        } else {
          throw Exception("Failed to retrieve location through maps");
        }
      } catch (e) {
        rethrow;
      }
    }

    List<Placemark> placemarks =
        await placemarkFromCoordinates(double.parse(_lat), double.parse(_long));

    if (placemarks.isNotEmpty) {
      Placemark locationInfo = placemarks[0];

      mainWidgetData.locationName = locationInfo.locality != ""
          ? '${locationInfo.locality ?? ""}, ${locationInfo.country ?? ""}'
          : locationInfo.country ?? "";
      notifyListeners();
    }
  }

  Future<void> updateLocationId(newLocationId) async {
    isLoading = true;
    await _setLocation(newLocationId);
    await _fetchCurrentWeather();
    await _fetchHourlyTemp();
    await _fetchDailyTemp();
    locationId = null;
    isLoading = false;
  }

  Future<void> updateLocationIdWithCoordinates(String lat, String long) async {
    isLoading = true;
    _lat = lat;
    _long = long;

    List<Placemark> placemarks =
        await placemarkFromCoordinates(double.parse(_lat), double.parse(_long));

    if (placemarks.isNotEmpty) {
      Placemark locationInfo = placemarks[0];

      mainWidgetData.locationName = locationInfo.locality != ""
          ? '${locationInfo.locality ?? ""}, ${locationInfo.country ?? ""}'
          : locationInfo.country ?? "";
      notifyListeners();
      print("Coordinates: $_lat,$_long");
      await _fetchCurrentWeather();
      await _fetchHourlyTemp();
      await _fetchDailyTemp();
      locationId = null;
      isLoading = false;
    }
  }
}
