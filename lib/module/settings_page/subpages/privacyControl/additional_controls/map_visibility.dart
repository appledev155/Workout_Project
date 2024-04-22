

import 'package:flutter/material.dart';

class MapVisibilityPage extends StatefulWidget {
  const MapVisibilityPage({super.key});

  @override
  State<MapVisibilityPage> createState() => _MapVisibilityPageState();
}

class _MapVisibilityPageState extends State<MapVisibilityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        title: const Text(
          'Map Visibility',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 5),
                  child: Image.asset(
                    'assets/images/location.png',
                    height: 30,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(right: 12)),
                Container(
                  width: 310,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '''Hide the start and end points of activities that happen''',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          'at a specific address',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.grey,
              thickness: 0.6,
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Image.asset(
                    'assets/images/earth.png',
                    height: 30,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Hide the start and end points of activities ',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        'no matter where they happen',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )
              ],
            ),
            const Divider(
              thickness: 0.6,
              color: Colors.grey,
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Image.asset(
                    'assets/images/hide_map.png',
                    height: 22,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Hide your activity maps from others completely',
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                )
              ],
            ),
            const Divider(
              thickness: 0.6,
              height: 50,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
