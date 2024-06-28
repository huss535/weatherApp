import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/pages/persona_page.dart';
import '../utilities/maps.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double persona = 0.0;
  double politics = 0.0;
  bool profanity = false;

  @override
  void initState() {
    super.initState();
    intializePreferences();
  }

  Future<void> intializePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      persona = prefs.getDouble("persona") ?? 0.0;
      politics = prefs.getDouble("politics") ?? 0.0;
      profanity = prefs.getBool("profanity") ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 30.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PersonaPage(persona, politics, profanity)),
            );
            intializePreferences();
          },
          splashColor: Colors.blueAccent,
          highlightColor: const Color.fromRGBO(126, 74, 221, 1),
          borderRadius: BorderRadius.circular(15),
          child: Ink(
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
            child: SizedBox(
              height: 80,
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Persona", style: TextStyle(fontSize: 18)),
                    Row(
                      children: [
                        Text(personaMap[persona] ?? "Nothing",
                            style: TextStyle(fontSize: 18)),
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
      ),
    );
  }
}

/* void main() => runApp(MaterialApp(
      home: SettingsPage(),
    ));
 */