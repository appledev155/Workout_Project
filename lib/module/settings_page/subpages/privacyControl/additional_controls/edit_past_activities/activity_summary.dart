import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/additional_controls/edit_past_activities/edit_activities.dart';
import 'package:flutter/material.dart';

class ActivitySummaryPage extends StatefulWidget {
  String? selectvalue;
  ActivitySummaryPage({super.key, this.selectvalue});

  @override
  State<ActivitySummaryPage> createState() => _ActivitySummaryPageState();
}

class _ActivitySummaryPageState extends State<ActivitySummaryPage> {
  void dialogbox() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              actions: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Are you sure?',
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '''This action will change all past activities to "${widget.selectvalue}" ''',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              color: Colors.orange.shade800, fontSize: 12),
                        )),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          'YES',
                          style: TextStyle(
                              color: Colors.orange.shade800, fontSize: 12),
                        )),
                  ],
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:primaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => ActivityVisibilityPage()));
            },
            icon: const Icon(Icons.arrow_back)),
        title:  Text(
          'Summary',
         style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: pageTitleSize,
                          color: lightColor),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: RichText(
                  text:  TextSpan(children: [
                TextSpan(
                    text:
                        '''You have selected the following detail(s) to be updated across all of your ''',
                   style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: pageIconSize,
                          color: blackColorDark),),
                TextSpan(
                    text: 'past ',
                    style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: pageIconSize,
                          color: blackColorDark),),
                TextSpan(
                    text: 'activities. \n ',
                  style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: pageIconSize,
                          color: blackColorDark),),
              ])),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
              child: RichText(
                  text:  TextSpan(children: [
                TextSpan(
                  text:
                      'Please note, this change will be applied to every activity you have uploaded to WorkOut - ',
                style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: pageIconSize,
                          color: blackColorDark),
                ),
                TextSpan(
                    text: 'all will now have the same visibility setting.',
                 style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: pageIconSize,
                          color: blackColorDark),)
              ])),
            ),
            const Divider(
                height: 1,
                thickness: 0.5,
                color: dividerColor,
              ),
            Container(
              padding: const EdgeInsets.only(top: 20,bottom: 20),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                   Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: Text(
                      'Activity Visibility',
                     style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: pageIconSize,
                          color: blackColorDark),
                    ),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  Expanded(
                    child: Text(
                      'Change all activities to ${widget.selectvalue}',
                      style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: pageIconSize,
                            color: blackColorDark),
                    ),
                  )
                ],
              ),
            ),
            const Divider(
                height: 1,
                thickness: 0.5,
                color: dividerColor,
              ),
            Container(
              padding: EdgeInsets.only(top: 20,bottom: 20),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: ElevatedButton(
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(greyColor)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const EditActivitiesPage()));
                          },
                          child:  Text(
                            'Cancel',
                            style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: pageIconSize,
                          color: blackColorDark),
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(primaryColor)),
                      onPressed: () {
                        dialogbox();
                      },
                      child:  Text(
                        'Update all past activities',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: pageIconSize,
                          color: blackColorDark),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
