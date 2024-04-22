
import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/additional_controls/edit_past_activities/select_details.dart';
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/privacy_controls.dart';
import 'package:flutter/material.dart';


class EditActivitiesPage extends StatefulWidget {
  const EditActivitiesPage({super.key});

  @override
  State<EditActivitiesPage> createState() => _EditActivitiesPageState();
}

class _EditActivitiesPageState extends State<EditActivitiesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:primaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivacyControlPage()));
        }, icon: const Icon(Icons.arrow_back)),
        title:  Text(
          'Edit Past Activities',
           style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: lightColor)
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                      '''Use this feature to adjust details and settings in bulk for your activities on WorkOut.''',
                       style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark)),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Learn more about editing past activities',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: primaryColor),
                  ),
                ],
              ),
            ),
           const Divider(
                        height: 1,
                        thickness: 0.5,
                        color: dividerColor,
                      ),
            const SizedBox(height: 20,),
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.8,
              child:
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(primaryColor)),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const SelectDetailsPage()));
                    }, child:  Text('Get Started', style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: lightColor))),
            )
          ],
        ),
      ),
    );
  }
 
}
