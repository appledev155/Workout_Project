import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/additional_controls/edit_past_activities/heart_summary.dart';
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/additional_controls/edit_past_activities/select_details.dart';
import 'package:flutter/material.dart';

enum Visibilityoption { Everyone, Only_You }

class HeartRateVisibilityPage extends StatefulWidget {
  const HeartRateVisibilityPage({super.key});

  @override
  State<HeartRateVisibilityPage> createState() =>
      _HeartRateVisibilityPageState();
}

class _HeartRateVisibilityPageState extends State<HeartRateVisibilityPage> {
  Visibilityoption? visibilityoption;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const SelectDetailsPage())));
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text(
          'Heart Rate Visibility',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
              onPressed: () {
                if (visibilityoption == Visibilityoption.Everyone ||
                    visibilityoption == Visibilityoption.Only_You) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => SummaryPage(
                                selectvalue: (visibilityoption ==
                                        Visibilityoption.Everyone)
                                    ? "Everyone"
                                    : "Only You",
                              ))));
                }
              },
              child: visibilityoption == Visibilityoption.Everyone ||
                      visibilityoption == Visibilityoption.Only_You
                  ? const Text(
                      'NEXT',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    )
                  : const Text(
                      'NEXT',
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ))
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 20, 0),
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                        text:
                            '''Change the visibility of past activities' heart rate data ''',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: 'by selecting a new setting.',
                        style: TextStyle(color: Colors.black))
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            RadioListTile(
                controlAffinity: ListTileControlAffinity.trailing,
                activeColor: Colors.orange.shade900,
                value: Visibilityoption.Everyone,
                groupValue: visibilityoption,
                title: const Text(
                  '''Update past heart rate data to "Everyone"''',
                  style: TextStyle(fontSize: 13),
                ),
                subtitle: const Padding(
                  padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                  child: Text(
                      '''Set the past activities' heart rate data so it will be visible to other Strava athletes.'''),
                ),
                onChanged: ( Visibilityoption? value) {
                  setState(() {
                    visibilityoption = value;
                  });
                }),
            const SizedBox(
              height: 15,
            ),
            RadioListTile(
                value: Visibilityoption.Only_You,
                activeColor: Colors.orange.shade900,
                controlAffinity: ListTileControlAffinity.trailing,
                groupValue: visibilityoption,
                title: const Text(
                  '''Update past heart rate data to "Only you" .''',
                  style: TextStyle(fontSize: 13),
                ),
                subtitle: const Padding(
                  padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                  child: Text(
                      '''You will always be able to see your heart rate but set past activities' heart rate data so that other athletes cannot view it'''),
                ),
                onChanged: ( Visibilityoption? value) {
                  setState(() {
                    visibilityoption = value;
                  });
                })
          ],
        ),
      ),
    );
  }
}
