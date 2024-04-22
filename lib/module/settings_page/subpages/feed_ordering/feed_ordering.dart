import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/isar/feed_ordering/feed.dart';
import 'package:anytimeworkout/isar/feed_ordering/feedoperation.dart'
    as feed_store;
import 'package:anytimeworkout/module/settings_page/pages/settingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum Radiooption { Personalized, Latest_activities }

class FeedOrderingPage extends StatefulWidget {
  const FeedOrderingPage({super.key});

  @override
  State<FeedOrderingPage> createState() => _FeedOrderingPageState();
}

class _FeedOrderingPageState extends State<FeedOrderingPage> {
  Radiooption? _radiooption = Radiooption.Personalized;
  bool isLoading = true;
  feed_store.FeedOperation feedstore = feed_store.FeedOperation();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getfeeddata();
  }

  getfeeddata() async {
    List<Feed> getfeedvalue = await feedstore.getfeeddata();
    if (getfeedvalue.isNotEmpty) {
      setState(() {
        _radiooption =
            (getfeedvalue.first.feedselectvalue == "Radiooption.Personalized")
                ? Radiooption.Personalized
                : Radiooption.Latest_activities;
        print(_radiooption);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
              systemNavigationBarColor: lightColor,
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarColor: primaryColor,
              statusBarIconBrightness: Brightness.dark),
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SettingPage()));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Feed Ordering'),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Text(
                  '''Change how activities are ordered in your feed. Any changes will apply only to new activities in your feed,so you may not notice a difference at first''',                style: TextStyle(
                    color: blackColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600)),
            ),
            GestureDetector(
              child: const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                child: Text(
                  'Learn more',
                  style: TextStyle(color: primaryColor),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              thickness: 0.5,
              color: Colors.grey,
            ),
            RadioListTile<Radiooption>(
              activeColor: primaryColor,
              controlAffinity: ListTileControlAffinity.trailing,
              title: const Text('Personalized',
                  style: TextStyle(
                      color: blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
              subtitle: const Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Text(
                    '''The feed is ordered as a blend of new activities,the kind of activities you tend to interact with and great efforts you may have missed.''',
                    style: TextStyle(
                        color: blackColorLight,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
              ),
              groupValue: _radiooption,
              onChanged: (Radiooption? value) {
                const CircularProgressIndicator();
                setState(() {
                  _radiooption = value;
                  Feed getfeeddata = Feed(
                      id: 1,
                      feedselectvalue: Radiooption.Personalized.toString());
                  feedstore.insert(getfeeddata);
                  wait();
                });
              },
              value: Radiooption.Personalized,
            ),
            const Divider(
              height: 30,
              thickness: 0.5,
              color: Colors.grey,
            ),
            RadioListTile<Radiooption>(
              activeColor: primaryColor,
              controlAffinity: ListTileControlAffinity.trailing,
              title: const Text(
                'Latest Activities',
                style: TextStyle(
                    color: blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              subtitle: const Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Text(
                  '''The feed is ordered chronologically by when new activities are finished.''',
                  style: TextStyle(
                      color: blackColorLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ),
              groupValue: _radiooption,
              onChanged: (Radiooption? value) {
                setState(() {
                  _radiooption = value;
                  Feed getfeeddata = Feed(
                      id: 1,
                      feedselectvalue:
                          Radiooption.Latest_activities.toString());
                  feedstore.insert(getfeeddata);
                  wait();
                });
              },
              value: Radiooption.Latest_activities,
            ),
            const Divider(
              height: 30,
              thickness: 0.5,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  void wait() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            child: SizedBox(
              height: 70,
              child: Row(
                children: const [
                  SizedBox(
                    width: 20,
                  ),
                  CircularProgressIndicator(
                    color: primaryColor,
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text('Please wait...')
                ],
              ),
            ),
          );
        });
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }
}
