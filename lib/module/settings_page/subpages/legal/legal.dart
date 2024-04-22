import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LegalPage extends StatefulWidget {
  const LegalPage({super.key});

  @override
  State<LegalPage> createState() => _LegalPageState();
}

class _LegalPageState extends State<LegalPage> {
  final Uri terms_condition_url=Uri.parse('https://www.strava.com/legal/terms#content-and-conduct');
  final Uri privacy_policy_url=Uri.parse('https://www.strava.com/legal/privacy');
  Future<void>_launchTerms_conditionUrl()async{
     if(!await launchUrl(terms_condition_url)){
      throw Exception('could not launch  $terms_condition_url');
     }
  }
  Future<void> _launchprivacy_policy_url()async{
    if(!await launchUrl(privacy_policy_url)){
      throw Exception('could not launch $privacy_policy_url');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        title: const Text(
          'Legal',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: _launchTerms_conditionUrl,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text('Terms and Conditions',style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal),),
                ),
              ),
            ),
            TextButton(
              onPressed: _launchprivacy_policy_url,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                  child: Text('Privacy Policy',style: TextStyle(fontWeight: FontWeight.normal,color: Colors.black),),
                ),
              ),
            ),
            TextButton(
              onPressed: (){},
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                  child: Text('Copyright',style: TextStyle(fontWeight: FontWeight.normal,color: Colors.black),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
