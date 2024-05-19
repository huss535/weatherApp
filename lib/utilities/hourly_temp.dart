import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_data_provider.dart';
import 'package:weather_icons/weather_icons.dart';
import 'helper_functions.dart';

// Component displays hourly temprature for a day
class HourlyTemp extends StatelessWidget {
  String time;
  String temp;
  String iconCode;
  HourlyTemp(
      {required this.time, required this.temp, this.iconCode = "", super.key});

  @override
  Widget build(BuildContext context) {
    IconData icon = getWeatherIcon(iconCode);
    return Center(
      child: Container(
        height: 160,
        width: 120,
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
        //Data displayed in component
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [Text(time), BoxedIcon(icon), Text(temp)],
        ),
      ),
    );
  }
}

class HourlyTempAll extends StatefulWidget {
  final List<HourlyTempData> tempList;
  HourlyTempAll({required this.tempList, Key? key}) : super(key: key);

  @override
  State<HourlyTempAll> createState() => _HourlyTempAllState();
}

class _HourlyTempAllState extends State<HourlyTempAll> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: 380,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < widget.tempList.length; i++)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  clipBehavior: Clip.none,
                  width: 100, // Adjust width as needed
                  child: HourlyTemp(
                    time: widget.tempList[i].hour,
                    temp: '${widget.tempList[i].temp}°C',
                    iconCode: widget.tempList[i].iconCode,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
