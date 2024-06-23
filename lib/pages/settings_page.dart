import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/pages/persona_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double persona = 0.0;
  String politics = "Apolitical";
  bool profanity = false;

  Future<void> intializePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      persona = prefs.getDouble("persona") ?? 0.0;
      politics = prefs.getString("politics") ?? "Apolitical";
      profanity = prefs.getBool("profanity") ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 30.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PersonaPage(persona, politics, profanity)),
            );
          },
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
                    Text("Persona", style: TextStyle(fontSize: 18)),
                    Row(
                      children: [
                        Text('American Psycho', style: TextStyle(fontSize: 18)),
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