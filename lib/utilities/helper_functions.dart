import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_icons/weather_icons.dart';

class MainWidgetData {
  String locationName;
  String temp;
  String weatherInfo;
  String windSpeed;
  String iconCode; // Stores the code used to assign the correct weather icon

  MainWidgetData(
      {this.locationName = "",
      this.temp = "",
      this.weatherInfo = "",
      this.windSpeed = "",
      this.iconCode = ""});
}

// class for data needed for hourly temprature widget
class HourlyTempData {
  String temp;
  String hour;
  String iconCode; // Stores the code used to assign the correct weather icon

  HourlyTempData({required this.temp, required this.hour, this.iconCode = ""});
}

//class for data needed for daily temprature widget
class DailyTempData {
  String tempMin;
  String tempMax;
  String dayOfWeek;
  String iconCode;

  DailyTempData(
      {required this.tempMin,
      required this.tempMax,
      required this.dayOfWeek,
      this.iconCode = ""});
}

String formatTimestamp(int timestamp) {
  // Convert timestamp to DateTime object
  DateTime dateTime =
      DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
  // Convert DateTime object to local time
  dateTime = dateTime.toLocal();
  TimeOfDay displayedHour =
      TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);

  //print(displayedHour);

  // Format time
  // Example format: "9:00"
  return displayedHour.hour.toString().padLeft(2, "0") +
      ":" +
      displayedHour.minute.toString().padLeft(2, "0");
}

Future<Position> getLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error("Location services disabled");
  }
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error("Location permissions are denied");
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        "Location permissions are denied forever, we can not process your request");
  }

  return await Geolocator.getCurrentPosition();
}

String getDayOfWeek(DateTime date) {
  switch (date.weekday) {
    case 1:
      return 'Monday';
    case 2:
      return 'Tuesday';
    case 3:
      return 'Wednesday';
    case 4:
      return 'Thursday';
    case 5:
      return 'Friday';
    case 6:
      return 'Saturday';
    case 7:
      return 'Sunday';
    default:
      return '';
  }
}

// funtion that maps current weather with correct icon
IconData getWeatherIcon(String iconCode) {
  switch (iconCode) {
    case '01d':
      return WeatherIcons.day_sunny;
    case '01n':
      return WeatherIcons.night_clear;
    case '02d':
      return WeatherIcons.day_cloudy;
    case '02n':
      return WeatherIcons.night_alt_cloudy;
    case '03d':
    case '03n':
      return WeatherIcons.cloud;
    case '04d':
    case '04n':
      return WeatherIcons.cloudy;
    case '09d':
    case '09n':
      return WeatherIcons.showers;
    case '10d':
      return WeatherIcons.day_rain;
    case '10n':
      return WeatherIcons.night_alt_rain;
    case '11d':
    case '11n':
      return WeatherIcons.thunderstorm;
    case '13d':
    case '13n':
      return WeatherIcons.snow;
    case '50d':
    case '50n':
      return WeatherIcons.fog;
    default:
      return WeatherIcons.na;
  }
}
