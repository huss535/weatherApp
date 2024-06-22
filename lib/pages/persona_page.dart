// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class PersonaPage extends StatefulWidget {
  const PersonaPage({super.key});

  @override
  State<PersonaPage> createState() => _PersonaPageState();
}

class _PersonaPageState extends State<PersonaPage> {
  double _value = 20;
  String _persona = "";
  bool _isProfanity = false;
  int value = -1;
  Map<double, String> personaMap = {
    0.0: "Professional",
    20.00: "Funny",
    40.00: "Snarky",
    60.00: "Mean girl",
    80.00: "Borat",
    100.0: "Mad Max"
  };

  Widget CustomRadioButton(String text, int index) {
    return OutlinedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (value == index) {
                return Colors.red;
              } else {
                return Colors.blue;
              }
            },
          ),
        ),
        onPressed: () {
          setState(() {
            value = index;
          });
        },
        child: Text(text));
  }

// dialog for choosing political idealogies
  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16.0),
            height: 400,
            decoration: BoxDecoration(
              border: Border.all(width: 2),
              borderRadius: BorderRadius.circular(15.0),
              color: const Color.fromRGBO(140, 190, 233, 1),
            ),
            child: Column(
              children: [
                CustomRadioButton("Apolitical", 1),
                CustomRadioButton("Libertarian", 2),
                CustomRadioButton("Conservative", 3),
                CustomRadioButton("Liberal", 4),
                CustomRadioButton("Communist", 5),
                CustomRadioButton("Anarchist", 6),
              ],
            ),
          ),
        );
      },
    );
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
            Container(
              child: Column(
                children: [
                  //slider to pick AI persona
                  Slider(
                      min: 0.0,
                      max: 100.0,
                      divisions: 5,
                      value: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = value;
                          _persona = personaMap[value] ?? "";
                        });
                      }),

                  Text(
                    "$_persona",
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
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
            InkWell(
              onTap: () => {_dialogBuilder(context)},
              splashColor: Colors.blueAccent,
              highlightColor: Color.fromRGBO(126, 74, 221, 1),
              borderRadius: BorderRadius.circular(15),
              child: Ink(
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
                child: Container(
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Politics", style: TextStyle(fontSize: 18)),
                        Row(
                          children: [
                            Text('Communist', style: TextStyle(fontSize: 18)),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
