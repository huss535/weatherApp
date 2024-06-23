// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class PersonaPage extends StatefulWidget {
  double persona;
  double politics;
  bool profanity;
  PersonaPage(this.persona, this.politics, this.profanity);

  @override
  State<PersonaPage> createState() => _PersonaPageState();
}

class _PersonaPageState extends State<PersonaPage> {
  //Two variables used with the slider component
  late String _persona;
  late double _personaValue;

  late String _politics;
  late double _politicsValue;

  // Map for different personalities used in slider
  Map<double, String> personaMap = {
    0.0: "Professional",
    20.00: "Funny",
    40.00: "Snarky",
    60.00: "Mean girl",
    80.00: "Borat",
    100.0: "Mad Max"
  };

  // Map for different political ideologies used in slider
  Map<double, String> politicsMap = {
    0.0: "Apolitical",
    20.00: "Libertarian",
    40.00: "Conservative",
    60.00: "Liberal",
    80.00: "Communist",
    100.0: "Anarchist"
  };

// Variable used with the switch
  late bool _isProfanity;
  int value = -1;

  // retrieve all user preferences for the AI assistant
  @override
  void initState() {
    super.initState();
    _personaValue = widget.persona;
    _persona = personaMap[_personaValue] ?? "";
    _isProfanity = widget.profanity;
    _politicsValue = widget.politics;
    _politics = politicsMap[_politicsValue] ?? "";
  }

  Future<void> _setPreference(String persona, String updateParameter) async {
    if (updateParameter == "persona") {
    } else if (updateParameter == "profanity") {
    } else if (updateParameter == "politics") {
    } else {
      throw Exception("The setting you want to update does not exist");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Persona"),
        backgroundColor: Colors.deepPurple,
        elevation: 30.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Personality",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
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
                  //slider to pick AI persona
                  Slider(
                      min: 0.0,
                      max: 100.0,
                      divisions: 5,
                      value: _personaValue,
                      onChanged: (value) {
                        setState(() {
                          _personaValue = value;
                          _persona = personaMap[value] ?? "";
                        });
                      }),

                  Text(
                    "$_persona",
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100,
            ),

            Text(
              "Politics",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),

            //Slider for political ideologies
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
                  //slider to pick AI persona
                  Slider(
                      min: 0.0,
                      max: 100.0,
                      divisions: 5,
                      value: _politicsValue,
                      onChanged: (value) {
                        setState(() {
                          _politicsValue = value;
                          _politics = politicsMap[value] ?? "";
                        });
                      }),

                  Text(
                    "$_politics",
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Container(
              height: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Profanity",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Switch(
                      value: _isProfanity,
                      onChanged: (value) {
                        setState(() {
                          _isProfanity = value;
                        });
                      })
                ],
              ),
              decoration: BoxDecoration(
                border: Border.all(width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(126, 74, 221, 1),
                    offset: const Offset(0, 8),
                  ),
                ],
                borderRadius: BorderRadius.circular(15.0),
                color: const Color.fromRGBO(140, 190, 233, 1),
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
