// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_data_provider.dart';

import 'helper_functions.dart';

//Individual daily weather component
class DailyTemp extends StatelessWidget {
  final String min;
  final String max;
  final String day;

  const DailyTemp({
    required this.min,
    required this.max,
    required this.day,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        width: 350,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              day,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            Icon(Icons.cloud_queue_outlined),
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
          boxShadow: [
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
  DailyTempAll({required this.dailyTempList, Key? key}) : super(key: key);

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
              ),
            ),
        ],
      ),
    );
  }
}
