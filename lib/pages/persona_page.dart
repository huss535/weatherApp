// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utilities/maps.dart';

class PersonaPage extends StatefulWidget {
  double persona;
  double politics;
  bool profanity;
  PersonaPage(this.persona, this.politics, this.profanity, {super.key});

  @override
  State<PersonaPage> createState() => _PersonaPageState();
}

class _PersonaPageState extends State<PersonaPage> {
  late String _persona;
  double _personaValue = 0.0;
  late String _politics;
  late double _politicsValue;

  @override
  void initState() {
    super.initState();
    _personaValue = widget.persona;
    _politicsValue = widget.politics;
    _getPreference();
  }

  @override
  void dispose() {
    _setPreference();
    super.dispose();
  }

  Future<void> _getPreference() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _personaValue = prefs.getDouble("persona") ?? widget.persona;
      _politicsValue = prefs.getDouble("politics") ?? widget.politics;
      _persona = personaMap[_personaValue] ?? "";
      _politics = politicsMap[_politicsValue] ?? "";
    });
  }

  Future<void> _setPreference() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble("persona", _personaValue);
    await prefs.setDouble("politics", _politicsValue);
  }

  @override
  Widget build(BuildContext context) {
    // Check if _personaValue is null, and show a loading indicator if needed
    if (_personaValue == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, _persona);
            },
          ),
          title: Text("Persona"),
          backgroundColor: Colors.deepPurple,
          elevation: 30.0,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Persona",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 30.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Personality",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              height: 90,
              decoration: BoxDecoration(
                border: Border.all(width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(126, 74, 221, 1),
                    offset: Offset(0, 8),
                  ),
                ],
                borderRadius: BorderRadius.circular(15.0),
                color: const Color.fromRGBO(140, 190, 233, 1),
              ),
              child: Column(
                children: [
                  Slider(
                      min: 0.0,
                      max: 100.0,
                      divisions: 5,
                      value: _personaValue,
                      onChanged: (value) {
                        setState(() {
                          _personaValue = value;
                          _persona = personaMap[value] ?? "";
                          _setPreference();
                        });
                      }),
                  Text(
                    _persona,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Politics",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              height: 90,
              decoration: BoxDecoration(
                border: Border.all(width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(126, 74, 221, 1),
                    offset: Offset(0, 8),
                  ),
                ],
                borderRadius: BorderRadius.circular(15.0),
                color: const Color.fromRGBO(140, 190, 233, 1),
              ),
              child: Column(
                children: [
                  Slider(
                      min: 0.0,
                      max: 100.0,
                      divisions: 5,
                      value: _politicsValue,
                      onChanged: (value) {
                        setState(() {
                          _politicsValue = value;
                          _politics = politicsMap[value] ?? "";
                          _setPreference();
                        });
                      }),
                  Text(
                    _politics,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Choose Neutral if you want to disable this option",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
