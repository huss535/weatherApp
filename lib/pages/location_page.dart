// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:weather_app/utilities/bottom_nav.dart';

// Page for users to lookup weather based on location
class LocationPage extends StatelessWidget {
  LocationPage({super.key});
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
  }

  @override
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
          children: [
            SearchField(
              myController: myController,
            ),
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
