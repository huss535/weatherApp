// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';

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
