import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/module/settings_page/subpages/link_other_device/other_services.dart';
import 'package:flutter/material.dart';

class LinkPage extends StatefulWidget {
  const LinkPage({super.key});

  @override
  State<LinkPage> createState() => _LinkPageState();
}

class _LinkPageState extends State<LinkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => OtherServicePage())));
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text(
          'Link with Google Fit',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        color: greyColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(
                Icons.favorite_sharp,
                size: 40,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Connect Strava to Google Fit',
                style: TextStyle(color: blackColor, fontSize: 15),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 3, 0),
                child: Text(
                  '''     When you connect Strava to Google Fit your activity data, 
  such as distance covered and calories burned,will be shared 
           with Google Fit.Additionally, your Strava profile will 
     automatically be updated with the latest information from 
                                            Google Fit.''',
                  style: TextStyle(height: 1.3, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        child: ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(primaryColor)),
            onPressed: () {},
            child: const Text(
              'Connect',
              style: TextStyle(fontSize: 12),
            )),
      ),
    );
  }
}
