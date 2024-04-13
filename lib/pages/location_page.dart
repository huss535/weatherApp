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
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
  }

  Future<http.Response> fetchLocation(String country) async {
    Map<String, dynamic> queryParams = {
      'q': country,
      'appid': dotenv.env["WEATHER_API_KEY"],
      // Add more parameters if needed
    };
    String uri = Uri.parse("http://api.openweathermap.org/geo/1.0/direct")
        .replace(queryParameters: queryParams)
        .toString();
    var respnse = await http.get(Uri.parse(uri));
    return respnse;
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
            ElevatedButton(
                onPressed: () async {
                  try {
                    final response =
                        await fetchLocation(myController.text.trim());
                    if (response.statusCode == 200) {
                      print(jsonDecode(response.body));
                    } else {
                      print('Failed to fetch location: ${response.statusCode}');
                    }
                  } catch (e) {
                    print('Exception occurred: $e');
                  }
                },
                child: Text("Test Env"))
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
