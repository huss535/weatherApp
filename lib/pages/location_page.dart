import 'package:flutter/material.dart';
import 'package:weather_app/utilities/bottom_nav.dart';

// Page for users to lookup weather based on location
class LocationPage extends StatelessWidget {
  const LocationPage({super.key});

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
          children: [SearchField()],
        ),
      ),
      bottomNavigationBar: BottomNav(),
    );
    ;
  }
}

// Text area component to look up locations
class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          prefix: Icon(Icons.search),
          filled: true,
          labelText: "Search locations"),
    );
  }
}
