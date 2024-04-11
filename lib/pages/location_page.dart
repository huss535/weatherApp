import 'package:flutter/material.dart';
import 'package:weather_app/utilities/bottom_nav.dart';

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
      bottomNavigationBar: BottomNav(),
    );
    ;
  }
}
