import 'package:flutter/material.dart';

class DailyTemp extends StatefulWidget {
  DailyTemp({super.key});

  @override
  State<DailyTemp> createState() => _DailyTempState();
}

class _DailyTempState extends State<DailyTemp> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        width: 350,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Monday"),
            Icon(Icons.cloud_queue_outlined),
            Text("Percp 38%"),
            Text("27°C")
          ],
        ),
        decoration: BoxDecoration(
            //126, 74, 221
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(126, 74, 221, 1), offset: Offset(-8, 8))
            ],
            borderRadius: BorderRadius.circular(15.0),
            color: Color.fromRGBO(140, 190, 233, 1)),
      ),
    );
  }
}
