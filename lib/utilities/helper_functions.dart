import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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
