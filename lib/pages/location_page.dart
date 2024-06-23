// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:weather_app/providers/navigation_provider.dart';
import 'package:weather_app/providers/weather_data_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Page for users to lookup weather based on location
class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  List<dynamic> _placeList = [];
  final _myController = TextEditingController();
  String? _sessionToken;
  String selectedLocationId = "";
  final uuid = Uuid();

//setting session tokens for the google places api
  void _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }

    getSuggestion(_myController.text);
  }

// retrieve location suggestions from the google google places api
  void getSuggestion(String input) async {
    String? kplacesApiKey = dotenv.env["MAPS_API_KEY"];
    String type = '(regions)';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';

    final queryParams = {
      'input': input,
      'key': kplacesApiKey,
      'sessiontoken': _sessionToken,
    };

    Uri placesApiCall =
        Uri.parse(baseURL).replace(queryParameters: queryParams);

    http.Response response = await http.get(placesApiCall);
    if (response.statusCode == 200) {
      setState(() {
        _placeList = json.decode(response.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  @override
  void initState() {
    super.initState();
    _myController.addListener(() {
      _onChanged();
    });
  }

  void _selectLocation(String id) {
    Provider.of<WeatherDataProvider>(context, listen: false)
        .updateLocationId(id);

    Provider.of<NavigationProvider>(context, listen: false).setIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lookup location'),
        backgroundColor: Colors.deepPurple,
        elevation: 30.0,
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment,
        children: [
          SearchField(
            myController: _myController,
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _placeList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_placeList[index]["description"]),
                onTap: () =>
                    _selectLocation(_placeList[index]["place_id"].toString()),
              );
            },
          ),
          /*  Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(
                          left: 29, right: 29, top: 15, bottom: 15),
                      backgroundColor: Color.fromRGBO(140, 190, 233, 1),
                      elevation: 20,
                      // shadowColor: Color.fromRGBO(157, 12, 12, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(color: Colors.black, width: 2.5),
                      )),
                  onPressed: () {
                    Navigator.pushNamed(context, "/",
                        arguments: {"number": 45});
                  },
                  child: Text(
                    "Lookup location",
                    style: TextStyle(color: Colors.black),
                  )),
            ) */
        ],
      ),
      /* bottomNavigationBar: BottomNav(), */
    );
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
