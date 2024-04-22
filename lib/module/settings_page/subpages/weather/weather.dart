
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  bool checkboxValue = false;
  final Uri _url = Uri.parse(
      'https://developer.apple.com/weatherkit/data-source-attribution/');
  Future<void> _launchurl() async {
    if (!await launchUrl(_url)) {
      throw Exception('could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        title: const Text(
          'About Strava Weather',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
              child: Text(
                '''If you would like to hide weather on all your activities, turn this off.''',
                style: TextStyle(fontSize: 13),
              ),
            ),
            const Divider(
              color: Colors.grey,
            ),
            CheckboxListTile(
                title: const Text(
                  'Weather On Activites',
                  style: TextStyle(fontSize: 14),
                ),
                controlAffinity: ListTileControlAffinity.trailing,
                value: checkboxValue,
                onChanged: null),
            const Divider(
              color: Colors.grey,
            ),
            TextButton(
              onPressed: () {
                _launchurl();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 50, 0, 10),
                  child: RichText(
                    text: TextSpan(
                        text: 'You can learn more about weather data resource',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 12),
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            baseline: TextBaseline.ideographic,
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.orange.shade800,
                                          width: 1))),
                              child: Text(
                                'here',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.orange.shade800),
                              ),
                            ),
                          ),
                          const TextSpan(
                            text: '.',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
