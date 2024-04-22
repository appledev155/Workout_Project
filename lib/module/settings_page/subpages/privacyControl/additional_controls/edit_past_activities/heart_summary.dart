import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/additional_controls/edit_past_activities/edit_activities.dart';
import 'package:flutter/material.dart';

class SummaryPage extends StatefulWidget {
  String? selectvalue;
   SummaryPage({super.key,this.selectvalue});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  void dialogbox(){
    showDialog(context: context, builder: (BuildContext context)=>AlertDialog(
      actions: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Are you sure?',style: TextStyle(fontSize: 15),),
              const SizedBox(height: 10,),
              Text('''This action will change all past activities to "${widget.selectvalue}" ''',style: const TextStyle(fontSize: 13),),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text('Cancel',style: TextStyle(color: Colors.orange.shade800,fontSize: 12),)),
            TextButton(onPressed: (){}, child: Text('YES',style: TextStyle(color: Colors.orange.shade800,fontSize: 12),)),
          ],
        )
      ],

    ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        title: const Text('Summary',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),),
        body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: RichText(
                  text: const TextSpan(children: [
                TextSpan(
                    text:
                        '''You have selected the following detail(s) to be updated across all of your ''',
                    style: TextStyle(color: Colors.black, fontSize: 13)),
                TextSpan(
                    text: 'past ',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
                TextSpan(
                    text: 'activities. \n ',
                    style: TextStyle(color: Colors.black, fontSize: 13)),
              ])),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: RichText(
                  text: const TextSpan(children: [
                TextSpan(
                    text:
                        'Please note, this change will be applied to every activity you have uploaded to Strava - ',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                  text: 'all will now have the same visibility setting.',
                  style: TextStyle(color: Colors.black,fontSize: 13)
                        )
              ])),
            ),
            const Divider(
              height: 50,
              color: Colors.grey,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text('Heart Rate Visibility',style: TextStyle(fontSize: 13),),
                  ),
                  const SizedBox(width: 30,),
                  Text('Change all activities to ${widget.selectvalue}',style: const TextStyle(fontSize: 12),)
                ],
              ),
            ),
            const Divider(
              height: 50,
              color: Colors.grey,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width*0.3,
                      child: OutlinedButton(
                        
                        onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: ((context) => const EditActivitiesPage())));
                        }, child: const Text('Cancel',style: TextStyle(color: Colors.black,fontSize: 13),)),
                    ),
                  ),
                  const SizedBox(width: 30,),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.orange.shade900)),
                    onPressed: (){
                     dialogbox();
                    }, child: const Text('Update all past activities',))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}