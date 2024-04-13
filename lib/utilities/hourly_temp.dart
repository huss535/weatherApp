import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Component displays hourly temprature for a day
class HourlyTemp extends StatelessWidget {
  HourlyTemp({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 200,
        width: 120,
        decoration: BoxDecoration(
            //Container styling
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(126, 74, 221, 1), offset: Offset(-8, 8))
            ],
            borderRadius: BorderRadius.circular(15.0),
            color: Color.fromRGBO(140, 190, 233, 1)),

        //Data displayed in component
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [Text("9:00 am"), Icon(Icons.cloud), Text("27 deg")],
        ),
      ),
    );
  }
}
