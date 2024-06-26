// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

import 'helper_functions.dart';

//Individual daily weather component
class DailyTemp extends StatelessWidget {
  final String min;
  final String max;
  final String day;
  final String iconCode;
  const DailyTemp({
    required this.min,
    required this.max,
    required this.day,
    this.iconCode = "",
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon = getWeatherIcon(iconCode);
    return Center(
      child: Container(
        height: 100,
        width: 350,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: SizedBox(
                width: 100,
                child: Text(
                  day,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            BoxedIcon(icon),
            Text(
              min,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            Text(
              max,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )
          ],
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(126, 74, 221, 1),
              offset: Offset(0, 8),
            )
          ],
          borderRadius: BorderRadius.circular(15.0),
          color: Color.fromRGBO(140, 190, 233, 1),
        ),
      ),
    );
  }
}

// Generates the daily weather widgets dynamically
class DailyTempAll extends StatefulWidget {
  final List<DailyTempData> dailyTempList;
  const DailyTempAll({required this.dailyTempList, super.key});

  @override
  State<DailyTempAll> createState() => _DailyTempAllState();
}

class _DailyTempAllState extends State<DailyTempAll> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          for (int i = 0; i < widget.dailyTempList.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: DailyTemp(
                min: '${widget.dailyTempList[i].tempMin}°C',
                max: '${widget.dailyTempList[i].tempMax}°C',
                day: widget.dailyTempList[i].dayOfWeek,
                iconCode: widget.dailyTempList[i].iconCode,
              ),
            ),
        ],
      ),
    );
  }
}
