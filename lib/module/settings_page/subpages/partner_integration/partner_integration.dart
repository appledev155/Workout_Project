import 'package:flutter/material.dart';

class PartnerPage extends StatefulWidget {
  const PartnerPage({super.key});

  @override
  State<PartnerPage> createState() => _PartnerPageState();
}

class _PartnerPageState extends State<PartnerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.orange.shade900,
          title: const Text(
            'Partner Integrations',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          )),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 15, 0),
              child: Text(
                '''When you post an activity with one of the partners listed below, they can show unique or interesting content in the feed that isn't available on other activities.You have control over these integrations and can change them at any time with these settings.''',
                style: TextStyle(fontSize: 13),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Text(
                'Learn more about partner integrations',
                style: TextStyle(color: Colors.orange.shade800),
              ),
            ),
            const Divider(
              height: 100,
              color: Colors.grey,
              thickness: 0.5,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(70, 0, 0, 0),
              child: Text('You have no Partner Integrations'),
            )
          ],
        ),
      ),
    );
  }
}
