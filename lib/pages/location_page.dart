// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:weather_app/utilities/bottom_nav.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Page for users to lookup weather based on location
class LocationPage extends StatelessWidget {
  LocationPage({super.key});
  final myController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lookup location'),
        backgroundColor: Colors.deepPurple,
        elevation: 30.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SearchField(
              myController: myController,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(
                          left: 29, right: 29, top: 15, bottom: 15),
                      backgroundColor: Color.fromRGBO(140, 190, 233, 1),
                      //elevation: 5,
                      shadowColor: Color.fromRGBO(157, 12, 12, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(color: Colors.black, width: 2),
                      )),
                  onPressed: () {},
                  child: Text(
                    "Lookup location",
                    style: TextStyle(color: Colors.black),
                  )),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(),
    );
    ;
  }
}

// Text area component to look up locations
class SearchField extends StatelessWidget {
  TextEditingController myController;
  SearchField({super.key, required this.myController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: myController,
      decoration: InputDecoration(
        prefix: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.search),
        ),
        filled: true,
        labelText: "Search locations",
        hoverColor: Colors.deepPurple,
      ),
    );
  }
}
