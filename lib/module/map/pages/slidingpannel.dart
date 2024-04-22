// import 'package:flutter/material.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';

// import '../map.dart';

// class SlidinUpPanelPage extends StatefulWidget {
//   const SlidinUpPanelPage({
//     super.key,
//   });

//   @override
//   State<SlidinUpPanelPage> createState() => _SlidinUpPanelPageState();
// }

// class _SlidinUpPanelPageState extends State<SlidinUpPanelPage> {
//   // bool isSelected = false;
//   // bool? selection;
//   String? v1;
//   @override
//   Widget build(BuildContext context) {
//     return SlidingUpPanel(
//       borderRadius: BorderRadius.circular(29),
//       minHeight: 300,
//       maxHeight: 800,
//       panelBuilder: (ScrollController sc) => _buildPanel(sc),
//       //body: _buildContent(),
//     );
//   }

//   Widget _buildPanel(ScrollController sc) {
//     return Material(
//       child: ListView(
//         controller: sc,
//         children: [
//           const SizedBox(
//             height: 10,
//           ),
//           const Center(
//               child: Text(
//             'choose a Sport',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           )),
//           const SizedBox(
//             height: 10,
//           ),
//           const Divider(
//             thickness: 0.2,
//             color: Colors.grey,
//           ),
//           const Padding(
//             padding: EdgeInsets.all(14.0),
//             child: Text(
//               'Foot Sports',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.run_circle_outlined),
//             textColor: v1 == 'Run' ? Colors.orange.shade900 : null,
//             iconColor: v1 == 'Run' ? Colors.orange.shade900 : null,
//             onTap: () {
//               setState(() {
//                 v1 = 'Run';
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => MapPage(
//                               title: v1,
//                               selectedIcon: Icons.run_circle_outlined,
//                             )));
//               });
//             },
//             title: const Text('Run'),
//             trailing: v1 == 'Run'
//                 ? const Icon(
//                     Icons.check,
//                   )
//                 : null,
//           ),
//           const Divider(
//             thickness: 0.2,
//             color: Colors.grey,
//           ),
//           ListTile(
//             onTap: () {
//               setState(() {
//                 v1 = 'Trail Run';
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => MapPage(
//                               title: v1,
//                               selectedIcon: Icons.run_circle_rounded,
//                             )));
//               });
//             },
//             textColor: v1 == 'Trail Run' ? Colors.orange.shade900 : null,
//             iconColor: v1 == 'Trail Run' ? Colors.orange.shade900 : null,
//             trailing: v1 == 'Trail Run'
//                 ? const Icon(
//                     Icons.check,
//                   )
//                 : null,
//             leading: const Icon(Icons.run_circle_rounded),
//             title: const Text('Trail Run'),
//           ),
//           const Divider(
//             thickness: 0.2,
//             color: Colors.grey,
//           ),
//           ListTile(
//             leading: const Icon(Icons.directions_walk_sharp),
//             onTap: () {
//               setState(() {
//                 v1 = 'Walk';
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => MapPage(
//                               title: v1,
//                               selectedIcon: Icons.directions_walk_sharp,
//                             )));
//               });
//             },
//             textColor: v1 == 'Walk' ? Colors.orange.shade900 : null,
//             iconColor: v1 == 'Walk' ? Colors.orange.shade900 : null,
//             trailing: v1 == 'Walk'
//                 ? const Icon(
//                     Icons.check,
//                   )
//                 : null,
//             title: const Text('Walk'),
//           ),
//           const Divider(
//             thickness: 0.2,
//             color: Colors.grey,
//           ),
//           ListTile(
//             leading: const Icon(Icons.hiking_rounded),
//             onTap: () {
//               setState(() {
//                 v1 = 'Hike';
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => MapPage(
//                               title: v1,
//                               selectedIcon: Icons.hiking_rounded,
//                             )));
//               });
//             },
//             textColor: v1 == 'Hike' ? Colors.orange.shade900 : null,
//             iconColor: v1 == 'Hike' ? Colors.orange.shade900 : null,
//             trailing: v1 == 'Hike'
//                 ? const Icon(
//                     Icons.check,
//                   )
//                 : null,
//             title: const Text('Hike'),
//           ),
//           const Divider(
//             thickness: 0.2,
//             color: Colors.grey,
//           ),
//           ListTile(
//             onTap: () {
//               setState(() {
//                 v1 = 'Wheelchair';
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => MapPage(
//                               title: v1,
//                               selectedIcon: Icons.wheelchair_pickup_sharp,
//                             )));
//               });
//             },
//             iconColor: v1 == 'Wheelchair' ? Colors.orange.shade900 : null,
//             leading: const Icon(Icons.wheelchair_pickup_sharp),
//             textColor: v1 == 'Wheelchair' ? Colors.orange.shade900 : null,
//             trailing: v1 == 'Wheelchair'
//                 ? Icon(
//                     Icons.check,
//                     color: Colors.orange.shade900,
//                   )
//                 : null,
//             title: const Text('Wheelchair'),
//           ),
//           const Divider(
//             thickness: 0.2,
//             color: Colors.grey,
//           ),
//           const Padding(
//             padding: EdgeInsets.all(14.0),
//             child: Text(
//               'Cycle Sports',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           ListTile(
//             onTap: () {
//               setState(() {
//                 v1 = 'Ride';
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => MapPage(
//                               title: v1,
//                               selectedIcon: Icons.pedal_bike_outlined,
//                             )));
//               });
//             },
//             iconColor: v1 == 'Ride' ? Colors.orange.shade900 : null,
//             textColor: v1 == 'Ride' ? Colors.orange.shade900 : null,
//             leading: const Icon(Icons.pedal_bike_outlined),
//             trailing: v1 == 'Ride'
//                 ? Icon(
//                     Icons.check,
//                     color: Colors.orange.shade900,
//                   )
//                 : null,
//             title: const Text('Ride'),
//           ),
//           const Divider(
//             thickness: 0.2,
//             color: Colors.grey,
//           ),
//           ListTile(
//             onTap: () {
//               setState(() {
//                 v1 = 'Mountain Bike Ride';
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => MapPage(
//                               title: v1,
//                               selectedIcon: Icons.directions_bike_sharp,
//                             )));
//               });
//             },
//             iconColor:
//                 v1 == 'Mountain Bike Ride' ? Colors.orange.shade900 : null,
//             textColor:
//                 v1 == 'Mountain Bike Ride' ? Colors.orange.shade900 : null,
//             leading: const Icon(Icons.directions_bike_sharp),
//             trailing: v1 == 'Mountain Bike Ride'
//                 ? Icon(
//                     Icons.check,
//                     color: Colors.orange.shade900,
//                   )
//                 : null,
//             title: const Text('Mountain Bike Ride'),
//           ),
//           const Divider(
//             thickness: 0.2,
//             color: Colors.grey,
//           ),
//           ListTile(
//             onTap: () {
//               setState(() {
//                 v1 = 'Gravel Ride';
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => MapPage(
//                               title: v1,
//                               selectedIcon: Icons.pedal_bike_sharp,
//                             )));
//               });
//             },
//             iconColor: v1 == 'Gravel Ride' ? Colors.orange.shade900 : null,
//             textColor: v1 == 'Gravel Ride' ? Colors.orange.shade900 : null,
//             leading: const Icon(Icons.pedal_bike_sharp),
//             trailing: v1 == 'Gravel Ride'
//                 ? Icon(
//                     Icons.check,
//                     color: Colors.orange.shade900,
//                   )
//                 : null,
//             title: const Text('Gravel Ride'),
//           ),
//           const Divider(
//             thickness: 0.2,
//             color: Colors.grey,
//           ),
//           ListTile(
//             onTap: () {
//               setState(() {
//                 v1 = 'E-Bike Ride';
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => MapPage(
//                               title: v1,
//                               selectedIcon: Icons.electric_bike,
//                             )));
//               });
//             },
//             iconColor: v1 == 'E-Bike Ride' ? Colors.orange.shade900 : null,
//             textColor: v1 == 'E-Bike Ride' ? Colors.orange.shade900 : null,
//             leading: const Icon(Icons.electric_bike),
//             trailing: v1 == 'E-Bike Ride'
//                 ? Icon(
//                     Icons.check,
//                     color: Colors.orange.shade900,
//                   )
//                 : null,
//             title: const Text('E-Bike Ride'),
//           ),
//           const Divider(
//             thickness: 0.2,
//             color: Colors.grey,
//           ),
//           ListTile(
//             onTap: () {
//               setState(() {
//                 v1 = 'E-Mountain Bike Ride';
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => MapPage(
//                               title: v1,
//                               selectedIcon: Icons.electric_bike_outlined,
//                             )));
//               });
//             },
//             iconColor:
//                 v1 == 'E-Mountain Bike Ride' ? Colors.orange.shade900 : null,
//             textColor:
//                 v1 == 'E-Mountain Bike Ride' ? Colors.orange.shade900 : null,
//             leading: const Icon(Icons.electric_bike_outlined),
//             trailing: v1 == 'E-Mountain Bike Ride'
//                 ? Icon(
//                     Icons.check,
//                     color: Colors.orange.shade900,
//                   )
//                 : null,
//             title: const Text('E-Mountain Bike Ride'),
//           ),
//           const Divider(
//             thickness: 0.2,
//             color: Colors.grey,
//           ),
//           ListTile(
//             onTap: () {
//               setState(() {
//                 v1 = 'Handcycle';
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => MapPage(
//                               title: v1,
//                               selectedIcon: Icons.bike_scooter,
//                             )));
//               });
//             },
//             iconColor: v1 == 'Handcycle' ? Colors.orange.shade900 : null,
//             textColor: v1 == 'Handcycle' ? Colors.orange.shade900 : null,
//             leading: const Icon(Icons.bike_scooter),
//             trailing: v1 == 'Handcycle'
//                 ? Icon(
//                     Icons.check,
//                     color: Colors.orange.shade900,
//                   )
//                 : null,
//             title: const Text('Handcycle'),
//           ),
//           const Divider(
//             thickness: 0.2,
//             color: Colors.grey,
//           ),
//           ListTile(
//             onTap: () {
//               setState(() {
//                 v1 = 'Velomobile';
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => MapPage(
//                               title: v1,
//                               selectedIcon: Icons.bike_scooter,
//                             )));
//               });
//             },
//             iconColor: v1 == 'Velomobile' ? Colors.orange.shade900 : null,
//             textColor: v1 == 'Velomobile' ? Colors.orange.shade900 : null,
//             leading: const Icon(Icons.snowmobile_outlined),
//             trailing: v1 == 'Velomobile'
//                 ? Icon(
//                     Icons.check,
//                     color: Colors.orange.shade900,
//                   )
//                 : null,
//             title: const Text('Velomobile'),
//           ),
//           const SizedBox(
//             height: 30,
//           ),
//            const Padding(
//             padding: EdgeInsets.all(14.0),
//             child: Text(
//               'Water Sports',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           ListTile(
//             onTap: () {
//               setState(() {
//                 v1 = 'Swim';
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => MapPage(
//                               title: v1,
//                               selectedIcon: Icons.water,
//                             )));
//               });
//             },
//             iconColor: v1 == 'Swim' ? Colors.orange.shade900 : null,
//             textColor: v1 == 'Swim' ? Colors.orange.shade900 : null,
//             leading: const Icon(Icons.water),
//             trailing: v1 == 'Swim'
//                 ? Icon(
//                     Icons.check,
//                     color: Colors.orange.shade900,
//                   )
//                 : null,
//             title: const Text('Swim'),
//           ),
//           const Divider(
//             thickness: 0.2,
//             color: Colors.grey,
//           ),
//           ListTile(
//             onTap: () {
//               setState(() {
//                 v1 = 'Surf';
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => MapPage(
//                               title: v1,
//                               selectedIcon: Icons.surfing,
//                             )));
//               });
//             },
//             iconColor:
//                 v1 == 'Surf' ? Colors.orange.shade900 : null,
//             textColor:
//                 v1 == 'Surf' ? Colors.orange.shade900 : null,
//             leading: const Icon(Icons.surfing),
//             trailing: v1 == 'Surf'
//                 ? Icon(
//                     Icons.check,
//                     color: Colors.orange.shade900,
//                   )
//                 : null,
//             title: const Text('Surf'),
//           ),
//           const Divider(
//             thickness: 0.2,
//             color: Colors.grey,
//           ),
//           ListTile(
//             onTap: () {
//               setState(() {
//                 v1 = 'Stand Up Paddling';
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => MapPage(
//                               title: v1,
//                               selectedIcon: Icons.surfing_rounded,
//                             )));
//               });
//             },
//             iconColor: v1 == 'Stand Up Paddling' ? Colors.orange.shade900 : null,
//             textColor: v1 == 'Stand Up Paddling' ? Colors.orange.shade900 : null,
//             leading: const Icon(Icons.surfing_rounded),
//             trailing: v1 == 'Stand Up Paddling'
//                 ? Icon(
//                     Icons.check,
//                     color: Colors.orange.shade900,
//                   )
//                 : null,
//             title: const Text('Stand Up Paddling'),
//           ),
//           const Divider(
//             thickness: 0.2,
//             color: Colors.grey,
//           ),
//           ListTile(
//             onTap: () {
//               setState(() {
//                 v1 = 'Windsurf';
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => MapPage(
//                               title: v1,
//                               selectedIcon: Icons.electric_bike,
//                             )));
//               });
//             },
//             iconColor: v1 == 'Windsurf' ? Colors.orange.shade900 : null,
//             textColor: v1 == 'Windsurf' ? Colors.orange.shade900 : null,
//             leading: const Icon(Icons.electric_bike),
//             trailing: v1 == 'Windsurf'
//                 ? Icon(
//                     Icons.check,
//                     color: Colors.orange.shade900,
//                   )
//                 : null,
//             title: const Text('Windsurf'),
//           ),
//           const Divider(
//             thickness: 0.2,
//             color: Colors.grey,
//           ),
//           ListTile(
//             onTap: () {
//               setState(() {
//                 v1 = 'E-Mountain Bike Ride';
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => MapPage(
//                               title: v1,
//                               selectedIcon: Icons.electric_bike_outlined,
//                             )));
//               });
//             },
//             iconColor:
//                 v1 == 'E-Mountain Bike Ride' ? Colors.orange.shade900 : null,
//             textColor:
//                 v1 == 'E-Mountain Bike Ride' ? Colors.orange.shade900 : null,
//             leading: const Icon(Icons.electric_bike_outlined),
//             trailing: v1 == 'E-Mountain Bike Ride'
//                 ? Icon(
//                     Icons.check,
//                     color: Colors.orange.shade900,
//                   )
//                 : null,
//             title: const Text('E-Mountain Bike Ride'),
//           ),
//           const Divider(
//             thickness: 0.2,
//             color: Colors.grey,
//           ),
//           ListTile(
//             onTap: () {
//               setState(() {
//                 v1 = 'Handcycle';
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => MapPage(
//                               title: v1,
//                               selectedIcon: Icons.bike_scooter,
//                             )));
//               });
//             },
//             iconColor: v1 == 'Handcycle' ? Colors.orange.shade900 : null,
//             textColor: v1 == 'Handcycle' ? Colors.orange.shade900 : null,
//             leading: const Icon(Icons.bike_scooter),
//             trailing: v1 == 'Handcycle'
//                 ? Icon(
//                     Icons.check,
//                     color: Colors.orange.shade900,
//                   )
//                 : null,
//             title: const Text('Handcycle'),
//           ),
//           const Divider(
//             thickness: 0.2,
//             color: Colors.grey,
//           ),
//           ListTile(
//             onTap: () {
//               setState(() {
//                 v1 = 'Velomobile';
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => MapPage(
//                               title: v1,
//                               selectedIcon: Icons.bike_scooter,
//                             )));
//               });
//             },
//             iconColor: v1 == 'Velomobile' ? Colors.orange.shade900 : null,
//             textColor: v1 == 'Velomobile' ? Colors.orange.shade900 : null,
//             leading: const Icon(Icons.snowmobile_outlined),
//             trailing: v1 == 'Velomobile'
//                 ? Icon(
//                     Icons.check,
//                     color: Colors.orange.shade900,
//                   )
//                 : null,
//             title: const Text('Velomobile'),
//           ),
//           const SizedBox(
//             height: 30,
//           )
//         ],
//       ),
//     );
//   }
//   // Widget _buildContent(){
//   //   return Container(
//   //     color: Colors.white,
//   //     child: Center(
//   //       child: Text('Main content'),
//   //     ),
//   //   );
//   // }
// }
